Class KFGUI_EditBox extends KFGUI_Clickable;

`include(Build.uci)
`include(Logger.uci)

var enum eTextCase
{
	TXTC_None,
	TXTC_Upper,
	TXTC_Lower,
} TextCase;

var Color FontColor, BackgroundColor, CursorColor, SelectedColor;

var string TextStr, AllowedCharSet;
var bool bDrawBackground, bNoClearOnEnter, bMaskText, bIntOnly, bFloatOnly, bIncludeSign, bConvertSpaces, bCtrl, bAllSelected, bForceShowCaret;
var int MaxWidth;
var bool bReadOnly, bAlwaysNotify, bDrawHeadLine;
var int CaretPos, FirstVis, LastSizeX, LastCaret, LastLength;
var float TextScale;

function InitMenu()
{
	Super.InitMenu();

	if (bIntOnly || bFloatOnly)
	{
		AllowedCharSet = "0123456789";

		if (bFloatOnly)
			AllowedCharSet $= ".";
	}

	bAllSelected = true;
}

function SetText(string NewText, optional bool bIgnoreDelegate, optional bool bNoSelect)
{
	local bool bChanged;

	bChanged = bAlwaysNotify || TextStr != NewText;
	TextStr = NewText;
	CaretPos = Len(TextStr);

	if (bChanged && !bIgnoreDelegate)
		TextChanged();

	bAllSelected=!bNoSelect;
}

function bool NotifyInputChar(int Key, string Unicode)
{
	local string Temp, S;

	if (bReadOnly)
		return false;

	if (UniCode != "")
		S = Unicode;
	else S = Chr(Key);

	if (Asc(S) == 13 || Asc(S) == 8 || Asc(S) == 27)
		return false;

	if (bCtrl)
		return false;

	if (bAllSelected)
	{
		TextStr="";
		CaretPos=0;
		bAllSelected=false;
	}

	if ((AllowedCharSet == "") || ( (bIncludeSign) && ( (S == "-") || (S == "+") ) && (TextStr == "") ) || (InStr(AllowedCharSet, S) >= 0))
	{
		if ((MaxWidth == 0) || (Len(TextStr) < MaxWidth))
		{
			if ((bConvertSpaces) && ((S == " ") || (S == "?") || (S == "\\")))
				S = "_";

			if ((TextStr == "") || ( CaretPos == Len(TextStr)))
			{
				TextStr = TextStr$S;
				CaretPos=Len(TextStr);
			}
			else
			{
				Temp = Left(TextStr, CaretPos)$S$Mid(TextStr, CaretPos);
				TextStr = Temp;
				CaretPos++;
			}

			TextChanged();
			return true;
		}
	}

	return false;
}

function SetInputText(string S)
{
	switch (TextCase)
	{
		case TXTC_Upper:
			S = Caps(S);
			break;
		case TXTC_Lower:
			S = Locs(S);
			break;
	}

	TextStr = S;
	TextChanged();
}

function AppendInputText(string Text)
{
	local int Character;

	while (Len(Text) > 0)
	{
		Character = Asc(Left(Text, 1));
		Text = Mid(Text, 1);

		if (Character >= 0x20 && Character < 0x100)
		{
			SetInputText(Left(TextStr, CaretPos) $ Chr(Character) $ Right(TextStr, Len(TextStr) - CaretPos));
			CaretPos += 1;
		}
	}
}

function bool ProcessControlKey(name Key, EInputEvent Event)
{
	if (Key == 'LeftControl' || Key == 'RightControl')
	{
		if (Event == IE_Released)
		{
			bCtrl = false;
		}
		else if (Event == IE_Pressed)
		{
			bCtrl = true;
		}

		return true;
	}
	else if (bCtrl && Event == IE_Pressed && GetPlayer() != None)
	{
		if (Key == 'V')
		{
			// paste
			AppendInputText(GetPlayer().PasteFromClipboard());
			return true;
		}
		else if (Key == 'C')
		{
			// copy
			GetPlayer().CopyToClipboard(TextStr);
			return true;
		}
		else if (Key == 'X')
		{
			// cut
			if (TextStr != "")
			{
				GetPlayer().CopyToClipboard(TextStr);
				SetInputText("");
				CaretPos = 0;
			}
			return true;
		}
		else if (Key == 'A')
		{
			// all
			HandleMouseClick(false);
		}
	}

	return false;
}

function bool NotifyInputKey(int ControllerId, name Key, EInputEvent Event, float AmountDepressed, bool bGamepad)
{
	local string Temp;

	if (bReadOnly)
	{
		return false;
	}

	if (ProcessControlKey(Key, Event))
	{
		return false;
	}
	else if (Key == 'Escape' && Event == IE_Pressed)
	{
		if (TextStr != "")
		{
			SetInputText("");
			CaretPos = 0;
			return true;
		}
		else
		{
			if (ParentComponent != None)
			{
				ParentComponent.UserPressedEsc();
				return true;
			}
		}
	}
	else if (Key == 'Enter' && Event == IE_Released)
	{
		if (TextStr != "")
		{
			Temp = TextStr;
			OnTextFinished(self, Temp);
			if (!bNoClearOnEnter)
			{
				SetInputText("");
				CaretPos = 0;
			}
		}

		return true;
	}
	else if (Key == 'Home')
	{
		CaretPos = 0;
		return true;
	}
	else if (Key == 'End')
	{
		CaretPos = Len(TextStr);
		return true;
	}
	else if (Event == IE_Pressed || Event == IE_Repeat)
	{
		if (Key == 'Backspace')
		{
			if (bAllSelected)
			{
				SetInputText("");
				CaretPos = 0;
			}
			else if (CaretPos > 0)
			{
				SetInputText(Left(TextStr, CaretPos-1) $ Right(TextStr, Len(TextStr) - CaretPos));
				CaretPos -= 1;
			}

			return true;
		}
		else if(Key == 'Delete')
		{
			if (bAllSelected)
			{
				SetInputText("");
				CaretPos = 0;
			}
			else if (CaretPos < Len(TextStr))
			{
				SetInputText(Left(TextStr, CaretPos) $ Right(TextStr, Len(TextStr)-CaretPos-1));
			}
			return true;
		}
		else if (Key == 'Left')
		{
			CaretPos = Max(0, CaretPos - 1);
			return true;
		}
		else if (Key == 'Right')
		{
			CaretPos = Min(Len(TextStr), CaretPos + 1);
			return true;
		}
	}

	return true;
}

function string ConvertIllegal(string InputStr)
{
	local int i, Max;
	local string Retval;
	local string C;

	i = 0;
	Max = Len(InputStr);
	while ( i < Max)
	{
		C = Mid(InputStr, i,1);
		if (AllowedCharSet != "" && InStr(AllowedCharSet, C) < 0)
		{
			C = "";
		}
		if (bConvertSpaces &&
			((C == " ") || (C =="?") || (C == "\\")))
		{
			C = "_";
		}
		Retval = Retval $ C;
		i++;
	}

	if (MaxWidth > 0)
		return Left(Retval, MaxWidth);

	return Retval;
}

function string GetText()
{
	return TextStr;
}

function TextChanged()
{
	OnChange(Self);
}

function DrawMenu()
{
	local string Storage, FinalDraw, TmpString;
	local int MaskIndex, StorageLength;
	local float XL, YL, BoxWidth, FontScale, CursorY, BorderSize, CursorOffsetX;
	local FontRenderInfo FRI;

	Super.DrawMenu();

	if (bDrawBackground)
	{
		Canvas.DrawColor = BackgroundColor;
		Canvas.SetPos(0.f, 0.f);
		Owner.CurrentStyle.DrawRectBox(0, 0, CompPos[2], CompPos[3], 1.f, 0);
	}

	BorderSize = Owner.CurrentStyle.ScreenScale(4.f);

	FRI.bClipText = true;
	FRI.bEnableShadow = true;

	Storage = TextStr;

	if (bMaskText && Len(Storage) > 0)
	{
		StorageLength = Len(Storage);

		Storage = "";
		for (MaskIndex=1; MaskIndex <= StorageLength; MaskIndex++)
		{
			Storage $= "*";
		}
	}

	Canvas.Font = Owner.CurrentStyle.PickFont(FontScale);
	FontScale *= TextScale;

	BoxWidth=CompPos[2]*0.9875;

	if ((Len(Storage) != LastLength) || (CaretPos != LastCaret))
	{
		if (CaretPos <= FirstVis)
			FirstVis = Max(0, CaretPos-1);
		else
		{
			FinalDraw = Mid(Storage, FirstVis, CaretPos-FirstVis);
			Canvas.TextSize(FinalDraw, XL, YL, FontScale, FontScale);

			// Scrolling to right for too long sentence
			while ( (XL >= BoxWidth) && (FirstVis < Len(Storage)))
			{
				FirstVis++;
				FinalDraw = Mid(Storage, FirstVis, CaretPos-FirstVis);
				Canvas.TextSize(FinalDraw, XL, YL, FontScale, FontScale);
			}
		}
	}
	LastLength = Len(Storage);

	if (bReadOnly)
	{
		FirstVis = 0;
	}

	FinalDraw = Mid(Storage, FirstVis, Len(Storage)-FirstVis);

	if (!bReadOnly && (Owner.KeyboardFocus == self || bForceShowCaret))
	{
		if ((FirstVis == CaretPos) || (Len(FinalDraw) == 0))
		{
			Canvas.TextSize("W", XL, YL, FontScale, FontScale);
			XL = BorderSize;
			bAllSelected=false;
			CursorOffsetX = -3;
		}
		else
		{
			TmpString = Mid(FinalDraw, 0, CaretPos-FirstVis);
			Canvas.TextSize(TmpString, XL, YL, FontScale, FontScale);
			CursorOffsetX = 3;
		}

		CursorY = (CompPos[3]/2) - ((YL-Owner.HUDOwner.ScaledBorderSize)/2);

		if (bAllSelected)
		{
			Canvas.SetDrawColor(SelectedColor.R, SelectedColor.G, SelectedColor.B, SelectedColor.A);
			Owner.CurrentStyle.DrawRectBox(BorderSize, CursorY, XL, YL-Owner.HUDOwner.ScaledBorderSize, 3.f, 0);
		}
		else
		{
			Canvas.SetDrawColor(CursorColor.R, CursorColor.G, CursorColor.B, Owner.CursorFlash);
			Owner.CurrentStyle.DrawRectBox(XL + CursorOffsetX, CursorY, Owner.HUDOwner.ScaledBorderSize, YL-Owner.HUDOwner.ScaledBorderSize, 1.f, 0);
		}
	}

	Canvas.DrawColor = FontColor;
	Canvas.SetPos(BorderSize, (CompPos[3]/2) - (YL/2));
	Canvas.DrawText(FinalDraw, ,FontScale, FontScale, FRI);

	if(bDrawHeadLine)
	{
		Canvas.SetDrawColor(0, 255, 0, 255);
		Owner.CurrentStyle.DrawRectBox(0, -CompPos[3]/16, CompPos[2], CompPos[3]/8, 1.f, 0);
	}
}

function HandleMouseClick(bool bRight)
{
	if (Owner.KeyboardFocus != self)
	{
		GrabKeyFocus();
	}

	CaretPos = Len(TextStr);
	bAllSelected = !bAllSelected;
}

Delegate OnChange(KFGUI_EditBox Sender);
Delegate OnTextFinished(KFGUI_EditBox Sender, string S);

defaultproperties
{
	FontColor=(R=255, G=255, B=255, A=255)
	BackgroundColor=(R=30, G=30, B=30, A=200)
	CursorColor=(R=255, G=255, B=255)
	SelectedColor=(R=0, G=120, B=215, A=255)
	MaxWidth=768
	TextScale=1
	TextCase=TXTC_None
	LastCaret=-1
	LastLength=-1

	YSize=0.06
}
