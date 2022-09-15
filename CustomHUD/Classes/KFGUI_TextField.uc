Class KFGUI_TextField extends KFGUI_MultiComponent;

`include(Build.uci)
`include(Logger.uci)

enum ETextFieldStyles
{
	TEXT_FIELD_NONE,
	TEXT_FIELD_HSV,
	TEXT_FIELD_SCAN,
	TEXT_FIELD_FLASH
};
struct FTextPart
{
	var string S;
	var ETextFieldStyles TextType;
	var Color C;
	var float X;

	structdefaultproperties
	{
		TextType=TEXT_FIELD_NONE
	}
};
struct FTextLineInfo
{
	var array<FTextPart> Text;
	var float Y;
};
var KFGUI_ScrollBarV ScrollBar;

var() string LineSplitter;
var() protected string Text;
var() Color TextColor;
var() Canvas.FontRenderInfo TextFontInfo;
var() float FontScale, MessageDisplayTime, MessageFadeInTime, MessageFadeOutTime;
var() bool bNoReset, bFadeInOut, bUseOutlineText;
var() int MaxHistory, OutlineSize;
var protected transient array<FTextLineInfo> Lines, OrgLines;
var transient float MaxHeight, ScrollWidth, OldSize[2], InitFontScale, TextHeight, FadeStartTime;
var transient Font InitFont;
var transient bool bShowScrollbar, bTextParsed;

function SetText(string S)
{
	if (Text == S)
		return;
	Text = S;
	OldSize[0] = -1; // Force to refresh.
	Lines.Length = 0;
	OrgLines.Length = 0;
	bTextParsed = false;
}
function AddText(string S, optional bool bIgnoreSpam)
{
	Text $= S;
	OldSize[0] = -1;
	Lines.Length = 0;
	OrgLines.Length = 0;
	bTextParsed = false;
}
final function string GetText()
{
	return Text;
}

final function ParseTextLines()
{
	local array<string> SA;
	local int i, j,z;
	local string S;
	local color C;
	local ETextFieldStyles TextType;

	ParseStringIntoArray(Text, SA, LineSplitter, false);
	Lines.Length = SA.Length;
	C.A = 0;
	TextType = TEXT_FIELD_NONE;
	for (i=0; i < SA.Length; ++i)
	{
		Lines[i].Text.Length = 0;

		S = SA[i];
		if (S == "")
			continue;

		z = 0;
		while (true)
		{
			j = InStr(S, "#{");
			if (j > 0)
			{
				Lines[i].Text.Length = z+1;
				Lines[i].Text[z].S = Left(S, j);
				Lines[i].Text[z].C = C;
				Lines[i].Text[z].TextType = TextType;
				++z;
			}
			else if (j == -1)
				break;

			S = Mid(S, j+2);
			if (Left(S, 4) == "DEF}")
			{
				C.A = 0;
				S = Mid(S, 4);
				TextType = TEXT_FIELD_NONE;
			}
			else if (Left(S, 4) == "HSV}")
			{
				C.A = 0;
				S = Mid(S, 4);
				TextType = TEXT_FIELD_HSV;
			}
			else if (Left(S, 6) == "FLASH}")
			{
				C.A = 0;
				S = Mid(S, 6);
				TextType = TEXT_FIELD_FLASH;
			}
			else if (Left(S, 7) == "CFLASH=")
			{
				C.A = 0;
				S = Mid(S, 7);
				TextType = TEXT_FIELD_FLASH;

				C.R = GrabHexValue(Mid(S, 0,2));
				C.G = GrabHexValue(Mid(S, 2,2));
				C.B = GrabHexValue(Mid(S, 4,2));
				S = Mid(S, 7);
				C.A = 255;
			}
			else
			{
				C.R = GrabHexValue(Mid(S, 0,2));
				C.G = GrabHexValue(Mid(S, 2,2));
				C.B = GrabHexValue(Mid(S, 4,2));
				S = Mid(S, 7);
				C.A = 255;
				TextType = TEXT_FIELD_NONE;
			}
		}
		Lines[i].Text.Length = z+1;
		Lines[i].Text[z].S = S;
		Lines[i].Text[z].C = C;
		Lines[i].Text[z].TextType = TextType;
	}
	OrgLines = Lines; // Create a backup.
}
final function byte GrabHexValue(string S)
{
	local byte n;

	n = (HexToInt(Asc(Left(S, 1))) << 4) | HexToInt(Asc(Right(S, 1)));
	S = Mid(S, 2);
	return n;
}
final function byte HexToInt(byte n)
{
	if (n >= 48 && n <= 57 ) // '0' - '9'
		return n-48;
	if (n >= 65 && n <= 70 ) // 'A' - 'F'
		return n-55; // 'A' - 10
	if (n >= 97 && n <= 102 ) // 'a' - 'f'
		return n-87; // 'a' - 10
	return 0;
}

function InitSize()
{
	local byte i;
	local float XS;
	local int MaxScrollRange;

	if (Canvas == None)
		return;

	OldSize[0] = CompPos[2];
	OldSize[1] = CompPos[3];
	if (!bTextParsed)
	{
		ParseTextLines();
		bTextParsed = true;
	}
	else Lines = OrgLines;

	InitFont = Owner.CurrentStyle.PickFont(InitFontScale);
	InitFontScale *= FontScale;

	// Compute Y-offsets of each line.
	Canvas.Font = InitFont;
	Canvas.TextSize("ABC", XS, TextHeight, InitFontScale, InitFontScale);

	ParseLines(CompPos[2] / InitFontScale);
	MaxHeight = (Lines.Length * TextHeight);
	bShowScrollbar = (MaxHeight >= CompPos[3]);
	bClickable = bShowScrollbar;
	bCanFocus = bShowScrollbar;

	if (bShowScrollbar)
	{
		if (ScrollBar == None)
		{
			ScrollBar = new(Self) class'KFGUI_ScrollBarV';
			ScrollBar.SetPosition(0.9, 0.0, 0.1, 1.0);
			ScrollBar.Owner = Owner;
			ScrollBar.ParentComponent = Self;
			ScrollBar.InitMenu();
			ScrollBar.SetVisibility(bVisible);
		}

		// Compute scrollbar size and X-position.
		for (i=0; i < 4; ++i)
			ScrollBar.InputPos[i] = CompPos[i];
		ScrollWidth = ScrollBar.GetWidth();
		ScrollBar.XPosition = 1.f - ScrollWidth;
		ScrollWidth *= CompPos[2];

		ScrollBar.ComputeCoords();

		// Recompute line sizes because we now have a scrollbar.
		Lines = OrgLines;
		ParseLines((CompPos[2]-ScrollWidth) / InitFontScale);

		if (Components.Find(ScrollBar) == -1)
			Components.AddItem(ScrollBar);
		MaxHeight = (Lines.Length * TextHeight);
		MaxScrollRange = Max(((MaxHeight-CompPos[3])/TextHeight), 1);
		ScrollBar.UpdateScrollSize(bNoReset ? MaxScrollRange : 0, MaxScrollRange, 1,1);
	}
	else if (ScrollBar != None)
		Components.RemoveItem(ScrollBar);
}

// Parse textlines to see if they're too long.
final function ParseLines(float ClipX)
{
	local float X, XS, YS;
	local int i, j,z, n;

	for (i=0; i < Lines.Length; ++i)
	{
		Lines[i].Y = i*TextHeight;
		X = 0.f;
		for (j=0; j < Lines[i].Text.Length; ++j)
		{
			Lines[i].Text[j].X = (X*InitFontScale);
			Canvas.TextSize(Lines[i].Text[j].S, XS, YS);

			if ((X+XS) > ClipX)
			{
				z = FindSplitPoint(Lines[i].Text[j].S, X,ClipX);

				// Add new line.
				Lines.Insert(i+1, 1);

				// Append the remaining lines there.
				for (n=j; n < Lines[i].Text.Length; ++n)
					Lines[i+1].Text.AddItem(Lines[i].Text[n]);

				// Split the string at wrapping point.
				Lines[i+1].Text[0].S = Mid(Lines[i].Text[j].S, z);

				// Remove whitespaces in front of the string.
				Lines[i+1].Text[0].S = StripWhiteSpaces(Lines[i+1].Text[0].S);

				// If empty, clean it up.
				if (Lines[i+1].Text[0].S == "")
					Lines[i+1].Text.Remove(0, 1);

				// End the current line at wrapping point.
				Lines[i].Text[j].S = Left(Lines[i].Text[j].S, z);
				Lines[i].Text.Length = j+1;
				break;
			}
			X+=XS;
		}
	}
}

// Slow, find wrapped splitting point in text.
final function int FindSplitPoint(string S, float X, float ClipX)
{
	local int i, l,PrevWord;
	local float XL, YL;
	local bool bWasWhite, bStartedZero;

	bStartedZero = (X == 0.f);
	Canvas.TextSize(Mid(S, 0,1), XL, YL);
	X += XL;
	i = 1;
	l = Len(S);
	PrevWord = 0;
	bWasWhite = true;
	while (i < l)
	{
		if (Mid(S, i,1) == " ")
		{
			if (!bWasWhite)
			{
				PrevWord = i;
				bWasWhite = true;
			}
		}
		else
		{
			bWasWhite = false;
		}
		Canvas.TextSize(Mid(S, i,1), XL, YL);
		X+=XL;
		if (X > ClipX ) // Split here if possible.
		{
			if (PrevWord == 0)
				return (bStartedZero ? i : 0); // No wrap.
			return PrevWord;
		}
		++i;
	}
	return l;
}
final function string StripWhiteSpaces(string S)
{
	if (Left(S, 1) == " ")
		S = Mid(S, 1);
	return S;
}

function byte GetCursorStyle()
{
	return `PEN_WHITE;
}

function DrawMenu()
{
	local int i, j,Index;
	local float Y;

	if (Text == "" || !bVisible)
		return;

	// Need to figure out best fitting font.
	if (OldSize[0] != CompPos[2] || OldSize[1] != CompPos[3])
		InitSize();

	if (MaxHistory != 0)
	{
		if (Lines.Length >= MaxHistory)
		{
			Index = InStr(Text, LineSplitter);
			if (Index == INDEX_NONE)
				Lines.Remove(0, 1);
			else SetText(Mid(Text, Index+Len(LineSplitter)));
		}
	}

	Canvas.Font = InitFont;

	if (bShowScrollbar)
	{
		Canvas.SetClip(CompPos[0]+(CompPos[2]-ScrollWidth), CompPos[1]+CompPos[3]);
		i = ScrollBar.GetValue();
	}
	else i = 0;

	if (i < Lines.Length)
	{
		Y = Lines[i].Y;
		for (i=i; i < Lines.Length; ++i)
		{
			if (Lines[i].Text.Length != 0)
			{
				if ((Lines[i].Y-Y+TextHeight) >= CompPos[3])
					break;

				for (j=0; j < Lines[i].Text.Length; ++j)
				{
					DrawTextField(Lines[i].Text[j].S, i, Lines[i].Text[j].X, Lines[i].Y-Y, Lines[i].Text[j].C, Lines[i].Text[j].TextType);
				}
			}
		}
	}
}

function DrawTextField(string S, int Index, float X, float Y, optional Color C, optional ETextFieldStyles TextStyle)
{
	local float TempSize;
	local int FadeAlpha;
	local Color MainColor;

	MainColor = C;
	if (MainColor.A == 0)
		MainColor = TextColor;

	Canvas.DrawColor = GetColorFromStyle(MainColor, TextStyle);

	if (bFadeInOut)
	{
		TempSize = `TimeSinceEx(GetPlayer(), FadeStartTime);
		if (TempSize > MessageDisplayTime)
		{
			return;
		}

		if (TempSize < MessageFadeInTime)
		{
			FadeAlpha = int((TempSize / MessageFadeInTime) * 255.0);
		}
		else if (TempSize > MessageDisplayTime - MessageFadeOutTime)
		{
			FadeAlpha = int((1.0 - ((TempSize - (MessageDisplayTime - MessageFadeOutTime)) / MessageFadeOutTime)) * 255.0);
		}
		else
		{
			FadeAlpha = 255;
		}

		Canvas.DrawColor.A = FadeAlpha;
	}

	if (bUseOutlineText)
	{
		Owner.CurrentStyle.DrawTextShadow(S, X,Y, OutlineSize, InitFontScale);
	}
	else
	{
		Canvas.SetPos(X, Y);
		Canvas.DrawText(S, ,InitFontScale, InitFontScale, TextFontInfo);
	}
}

function Color GetColorFromStyle(Color MainColor, ETextFieldStyles TextStyle)
{
	local float ColorHUE, Value;
	local HSVColour HSV;

	if (TextStyle == TEXT_FIELD_HSV)
	{
		ColorHUE = Abs(Sin(GetPlayer().WorldInfo.TimeSeconds * 0.9) * 335);

		HSV.H = ColorHUE;
		HSV.S = 1.f;
		HSV.V = 1.f;
		HSV.A = MainColor.A / 255;

		return class'KFColorHelper'.static.LinearColorToColor(class'KFColorHelper'.static.HSVToRGB(HSV));
	}
	else if (TextStyle == TEXT_FIELD_FLASH)
	{
		Value = Abs(Sin(GetPlayer().WorldInfo.TimeSeconds * 0.9) * 1);
		HSV = class'KFColorHelper'.static.RGBToHSV(ColorToLinearColor(MainColor));
		HSV.V = Value;

		return class'KFColorHelper'.static.LinearColorToColor(class'KFColorHelper'.static.HSVToRGB(HSV));
	}

	return MainColor;
}

function bool CaptureMouse()
{
	return (bShowScrollbar ? Super.CaptureMouse() : false); // Nope.
}

function ScrollMouseWheel(bool bUp)
{
	if (bShowScrollbar)
		ScrollBar.ScrollMouseWheel(bUp);
}

function SetVisibility(bool Visible)
{
	Super.SetVisibility(Visible);

	if (ScrollBar != None)
	{
		ScrollBar.SetVisibility(Visible);
	}
}

defaultproperties
{
	bNoReset=false
	LineSplitter="|"
	FontScale=1
	MaxHistory=0
	OutlineSize=1
	Text="TextField"
	TextColor=(R=255, G=255, B=255, A=255)
	TextFontInfo=(bClipText=true, bEnableShadow=true)
	bCanFocus=false
	bClickable=false
	bUseOutlineText=false
}