Class KFGUI_TextScroll extends KFGUI_TextField;

`include(Build.uci)
`include(Logger.uci)

var float ScrollSpeed;

var transient float CharStartTime;
var transient bool bScrollCompleted, bTextDirty;
var transient array<bool> RowsCompleted;
var transient int MaxIndex, RowsDropped;

function SetText(string S)
{
	Super.SetText(S);

	MaxIndex = 0;
	RowsCompleted.Length = 0;
	RowsDropped = 0;

	bScrollCompleted = false;
	bTextDirty = true;
	CharStartTime = GetPlayer().WorldInfo.TimeSeconds;
}

function DrawMenu()
{
	local int i, j,k, SLen, CurrentIndex;
	local float Y, DTime, XL, YL, MainY, MainX, CharTime;
	local string MainString;
	local Color MainTextColor;
	local Texture CurrentCursor;
	local ETextFieldStyles TextStyle;

	if (bScrollCompleted)
	{
		Super.DrawMenu();
		return;
	}

	if (Text == "")
		return;

	// Need to figure out best fitting font.
	if (OldSize[0] != CompPos[2] || OldSize[1] != CompPos[3])
		InitSize();

	Canvas.Font = InitFont;

	if (bShowScrollbar)
	{
		Canvas.SetClip(CompPos[0]+(CompPos[2]-ScrollWidth), CompPos[1]+CompPos[3]);
		i = ScrollBar.GetValue();
	}
	else i = 0;

	if (ScrollBar != None)
	{
		if (bTextDirty)
		{
			ScrollBar.bDisabled = true;
			RowsCompleted.Length = Lines.Length;
			bTextDirty = false;
		}

		if (RowsCompleted[Lines.Length-1])
		{
			ScrollBar.AddValue(1);
			ScrollBar.bDisabled = false;
			bScrollCompleted = true;

			//Temp fix! The last line in the string seems to be skipped
			AddText(LineSplitter);

			return;
		}
		else if (MaxIndex != 0 && RowsCompleted[MaxIndex])
		{
			MaxIndex = 0;
			ScrollBar.AddValue(1);

			RowsDropped++;

			i = ScrollBar.GetValue();
		}
	}

	if (RowsDropped > 0)
	{
		for (i=0; i <= RowsDropped; ++i)
		{
			for (j=0; j < Lines[i].Text.Length; ++j)
			{
				for (k=0; k <= Len(Lines[i].Text[j].S); ++k)
				{
					CharTime += ScrollSpeed;
				}
			}
		}
	}

	DTime = `TimeSinceEx(GetPlayer(), CharStartTime);
	if (i < Lines.Length)
	{
		CurrentCursor = Owner.DefaultPens[GetCursorStyle()];
		Y = Lines[i].Y;
		for (i=i; i < Lines.Length; ++i)
		{
			if ((Lines[i].Y-Y+TextHeight) >= CompPos[3])
			{
				MaxIndex = i-1;
				break;
			}

			if (Lines[i].Text.Length != 0)
			{
				for (j=0; j < Lines[i].Text.Length; ++j)
				{
					MainTextColor = Lines[i].Text[j].C;
					if (MainTextColor.A == 0)
						MainTextColor = TextColor;

					TextStyle = Lines[i].Text[j].TextType;

					MainX = Lines[i].Text[j].X;
					MainY = Lines[i].Y-Y;
					MainString = Lines[i].Text[j].S;
					SLen = Len(MainString);

					CurrentIndex = 0;
					for (k=0; k <= SLen; ++k)
					{
						CharTime += ScrollSpeed;

						Canvas.TextSize(Mid(MainString, 0, k), XL, YL, InitFontScale, InitFontScale);

						if (CharTime > DTime)
						{
							if (CurrentIndex == k)
							{
								Canvas.SetDrawColor(255, 255, 255, 255);
								Canvas.SetPos(MainX+XL, MainY);
								Canvas.DrawTile(CurrentCursor, YL/2, YL, 0, 0, CurrentCursor.GetSurfaceWidth(), CurrentCursor.GetSurfaceHeight());
							}

							continue;
						}

						Canvas.DrawColor = GetColorFromStyle(MainTextColor, TextStyle);
						Canvas.SetPos(MainX+XL, MainY);
						Canvas.DrawText(Mid(MainString, k, 1), ,InitFontScale, InitFontScale, TextFontInfo);

						CurrentIndex = k+1;

						if (k >= SLen)
						{
							RowsCompleted[i] = true;
						}
					}
				}
			}
		}
	}
}

function bool CaptureMouse()
{
	return (!bScrollCompleted && Super(KFGUI_MultiComponent).CaptureMouse()) || Super.CaptureMouse();
}

function MouseClick(bool bRight)
{
	if (bScrollCompleted)
		return;

	if (ScrollBar != None)
		ScrollBar.bDisabled = false;

	bScrollCompleted = true;

	//Temp fix! The last line in the string seems to be skipped
	AddText(LineSplitter);
}

defaultproperties
{
	ScrollSpeed=0.01
}