Class ClassicStyle extends KF2Style;

`include(Build.uci)
`include(Logger.uci)

function RenderFramedWindow(KFGUI_FloatingWindow P)
{
	local int XS, /*YS, */TitleHeight;
	local float XL, YL, FontScale;

	if(P.bHide) return;

	XS = Canvas.ClipX-Canvas.OrgX;
	TitleHeight = DefaultHeight;

	if (P.bWindowFocused)
		Canvas.SetDrawColor(105, 105, 105, 255);
	else Canvas.SetDrawColor(85, 85, 85, P.FrameOpacity);

	// Frame itself.
	Canvas.SetPos(0, TitleHeight);
	Canvas.DrawColor = P.FrameColor; //Canvas.SetDrawColor(10, 10, 10, 200);
	Owner.CurrentStyle.DrawRectBox(P.XPosition, P.YPosition, P.CompPos[2], P.CompPos[3], 8.f, 0);

	// Frame Header
	Canvas.SetPos(0, 0);
	Canvas.SetDrawColor(75, 0, 0, 200);
	Owner.CurrentStyle.DrawRectBox(P.HeaderComp.XPosition, P.HeaderComp.YPosition, P.HeaderComp.CompPos[2], P.HeaderComp.CompPos[3], 8.f, 0);


	// Title.
	if (P.WindowTitle != "")
	{
		Canvas.Font = PickFont(FontScale);
		Canvas.TextSize(P.WindowTitle, XL, YL, FontScale, FontScale);
		Canvas.SetDrawColor(250, 250, 250, 255);
		Canvas.SetPos((XS*0.5)-(XL*0.5), 0);
		Canvas.DrawText(P.WindowTitle, ,FontScale, FontScale);
	}
}

function RenderWindow(KFGUI_Page P)
{
	Canvas.SetPos(0, 0);
	Canvas.SetDrawColor(30, 30, 30, 200);
	Owner.CurrentStyle.DrawRectBox(P.XPosition, P.YPosition, P.CompPos[2], P.CompPos[3], 8.f, 0);
}

function RenderToolTip(KFGUI_Tooltip TT)
{
	local int i;
	local float X, Y,XS, YS, TX, TY, TS, DefFontHeight;

	Canvas.Font = PickFont(TS);

	// First compute textbox size.
	TY = DefaultHeight*TT.Lines.Length;
	for (i=0; i < TT.Lines.Length; ++i)
	{
		if (TT.Lines[i] != "")
			Canvas.TextSize(TT.Lines[i], XS, YS);
		TX = FMax(XS, TX);
	}
	TX*=TS;

	// Give some borders.
	TX += TOOLTIP_BORDER*2;
	TY += TOOLTIP_BORDER*2;

	X = TT.CompPos[0];
	Y = TT.CompPos[1]+24.f;

	// Then check if too close to window edge, then move it to another pivot.
	if ((X+TX) > TT.Owner.ScreenSize.X)
		X = TT.Owner.ScreenSize.X-TX;
	if ((Y+TY) > TT.Owner.ScreenSize.Y)
		Y = TT.CompPos[1]-TY;

	if (TT.CurrentAlpha < 255)
		TT.CurrentAlpha = Min(TT.CurrentAlpha+25, 255);

	// Reset clipping.
	Canvas.SetOrigin(0, 0);
	Canvas.SetClip(TT.Owner.ScreenSize.X, TT.Owner.ScreenSize.Y);

	// Draw frame.
	Canvas.SetDrawColor(115, 115, 115, TT.CurrentAlpha);
	Canvas.SetPos(X-2, Y-2);
	DrawBoxHollow(X-2, Y-2, TX+4, TY+4, 2);
	Canvas.SetDrawColor(5, 5,5, TT.CurrentAlpha);
	Canvas.SetPos(X, Y);
	DrawWhiteBox(TX, TY);

	DefFontHeight = DefaultHeight;

	// Draw text.
	Canvas.SetDrawColor(255, 255, 255, TT.CurrentAlpha);
	X+=TOOLTIP_BORDER;
	Y+=TOOLTIP_BORDER;
	for (i=0; i < TT.Lines.Length; ++i)
	{
		Canvas.SetPos(X, Y);
		Canvas.DrawText(TT.Lines[i], ,TS, TS, TT.TextFontInfo);
		Y+=DefFontHeight;
	}
}

function RenderScrollBar(KFGUI_ScrollBarBase S)
{
	local float A;
	local byte i;

	if (S.bDisabled)
		Canvas.SetDrawColor(5, 5, 5, 0);
	else if (S.bFocused || S.bGrabbedScroller)
		Canvas.SetDrawColor(15, 15, 15, 160);
	else Canvas.SetDrawColor(15, 15, 15, 160);

	Canvas.SetPos(0.f, 0.f);
	Canvas.SetDrawColor(5, 5, 5, 200);
	Owner.CurrentStyle.DrawRectBox(S.XPosition, S.YPosition, S.CompPos[2], S.CompPos[3], 5.f, 0);


	if (S.bDisabled)
		return;

	if (S.bVertical)
		i = 3;
	else i = 2;

	S.SliderScale = FMax(S.PageStep * (S.CompPos[i] - 32.f) / (S.MaxRange + S.PageStep), S.CalcButtonScale);

	if (S.bGrabbedScroller)
	{
		// Track mouse.
		if (S.bVertical)
			A = S.Owner.MousePosition.Y - S.CompPos[1] - S.GrabbedOffset;
		else A = S.Owner.MousePosition.X - S.CompPos[0] - S.GrabbedOffset;

		A /= ((S.CompPos[i]-S.SliderScale) / float(S.MaxRange));
		S.SetValue(A);
	}

	A = float(S.CurrentScroll) / float(S.MaxRange);
	S.ButtonOffset = A*(S.CompPos[i]-S.SliderScale);

	if (S.bGrabbedScroller)
		Canvas.SetDrawColor(250, 50, 0, 200);
	else if (S.bFocused)
		Canvas.SetDrawColor(250, 100, 0, 200);
	else Canvas.SetDrawColor(200, 200, 200, 200);

	if (S.bVertical)
	{
	//	Canvas.SetPos(0.f, S.ButtonOffset);
	//	Canvas.DrawTileStretched(ScrollTexture, S.CompPos[2], S.SliderScale, 0,0, 32, 32);
		Owner.CurrentStyle.DrawRectBox(0.f, S.ButtonOffset, S.CompPos[2], S.SliderScale, 5.f, 0);
	}
	else 
	{
	//	Canvas.SetPos(S.ButtonOffset, 0.f);
	//	Canvas.DrawTileStretched(ScrollTexture, S.SliderScale, S.CompPos[3], 0,0, 32, 32);
		Owner.CurrentStyle.DrawRectBox(S.ButtonOffset, 0.f, S.SliderScale, S.CompPos[3], 5.f, 0);
	}
}

function RenderCheckbox(KFGUI_CheckBox C)
{
	Canvas.SetPos(0.f, 0.f);

	if (C.bChecked)
	{
		if (C.bDisabled)
			Canvas.SetDrawColor(30, 0, 0, 200);

		else if(C.bFocused)
			Canvas.SetDrawColor(0, 250, 156, 200);
			
		else
			Canvas.SetDrawColor(0, 210, 132, 200);	
	}

	else if(C.bFocused)
		Canvas.SetDrawColor(250, 100, 0, 200);

	else
		Canvas.SetDrawColor(200, 200, 200, 200);

	Owner.CurrentStyle.DrawRectBox(0.f, 0.f, C.CompPos[2], C.CompPos[3], 2.5f, 0);
}

function RenderComboBox(KFGUI_ComboBox C)
{
	if (C.bDisabled)
		Canvas.SetDrawColor(64, 64, 64, 255);
	else if (C.bPressedDown)
		Canvas.SetDrawColor(220, 220, 220, 255);
	else if (C.bFocused)
		Canvas.SetDrawColor(190, 190, 190, 255);

	Canvas.SetPos(0.f, 0.f);
	Owner.CurrentStyle.DrawRectBox(0.f, 0.f, C.CompPos[2], C.CompPos[3], 2.5f, 0);

	DrawArrowBox(3, C.CompPos[2]-32, 0.5f, 32, 32);

	if (C.SelectedIndex < C.Values.Length && C.Values[C.SelectedIndex] != "")
	{
		Canvas.SetPos(C.BorderSize, (C.CompPos[3]-C.TextHeight)*0.5);
		if (C.bDisabled)
			Canvas.DrawColor = C.TextColor*0.5f;
		else Canvas.DrawColor = C.TextColor;
		Canvas.PushMaskRegion(Canvas.OrgX, Canvas.OrgY, Canvas.ClipX-C.BorderSize, Canvas.ClipY);
		Canvas.DrawText(C.Values[C.SelectedIndex], ,C.TextScale, C.TextScale, C.TextFontInfo);
		Canvas.PopMaskRegion();
	}
}

function RenderComboList(KFGUI_ComboSelector C)
{
	local float X, Y,YL, YP, Edge;
	local int i;
	local bool bCheckMouse;

	// Draw background.
	Edge = C.Combo.BorderSize;
	Canvas.SetPos(0.f, 0.f);
	Owner.CurrentStyle.DrawRectBox(0.f, 0.f, C.CompPos[2], C.CompPos[3], 2.5f, 0);

	// While rendering, figure out mouse focus row.
	X = C.Owner.MousePosition.X - Canvas.OrgX;
	Y = C.Owner.MousePosition.Y - Canvas.OrgY;

	bCheckMouse = (X > 0.f && X < C.CompPos[2] && Y > 0.f && Y < C.CompPos[3]);

	Canvas.Font = C.Combo.TextFont;
	YL = C.Combo.TextHeight;

	YP = Edge;
	C.CurrentRow = -1;

	Canvas.PushMaskRegion(Canvas.OrgX, Canvas.OrgY, Canvas.ClipX, Canvas.ClipY);
	for (i=0; i < C.Combo.Values.Length; ++i)
	{
		if (bCheckMouse && Y >= YP && Y <= (YP+YL))
		{
			bCheckMouse = false;
			C.CurrentRow = i;
			Canvas.SetPos(4.f, YP);
			Canvas.SetDrawColor(128, 48, 48, 255);
			DrawWhiteBox(C.CompPos[2]-(Edge*2.f), YL);
		}
		Canvas.SetPos(Edge, YP);

		if (i == C.Combo.SelectedIndex)
			Canvas.DrawColor = C.Combo.SelectedTextColor;
		else Canvas.DrawColor = C.Combo.TextColor;

		Canvas.DrawText(C.Combo.Values[i], ,C.Combo.TextScale, C.Combo.TextScale, C.Combo.TextFontInfo);

		YP+=YL;
	}
	Canvas.PopMaskRegion();
	if (C.OldRow != C.CurrentRow)
	{
		C.OldRow = C.CurrentRow;
		C.PlayMenuSound(MN_DropdownChange);
	}
}

function RenderRightClickMenu(KFGUI_RightClickMenu C)
{
	local float X, Y,XL, YL, YP, Edge, TextScale;
	local int i;
	local bool bCheckMouse;
	local string S;

	// Draw background.
	Edge = C.EdgeSize;
	DrawOutlinedBox(0.f, 0.f, C.CompPos[2], C.CompPos[3], Edge, C.BoxColor, C.OutlineColor);

	// While rendering, figure out mouse focus row.
	X = C.Owner.MousePosition.X - Canvas.OrgX;
	Y = C.Owner.MousePosition.Y - Canvas.OrgY;

	bCheckMouse = (X > 0.f && X < C.CompPos[2] && Y > 0.f && Y < C.CompPos[3]);

	PickFont(TextScale);

	YP = Edge*2;
	C.CurrentRow = -1;

	Canvas.PushMaskRegion(Canvas.OrgX, Canvas.OrgY, Canvas.ClipX, Canvas.ClipY);
	for (i=0; i < C.ItemRows.Length; ++i)
	{
		if (C.ItemRows[i].bSplitter)
			S = "-------";
		else S = C.ItemRows[i].Text;

		Canvas.TextSize(S, XL, YL, TextScale, TextScale);

		if (bCheckMouse && Y >= YP && Y <= (YP+YL))
		{
			bCheckMouse = false;
			C.CurrentRow = i;
			Canvas.SetPos(Edge, YP);
			Canvas.SetDrawColor(128, 0,0, 255);
			DrawWhiteBox(C.CompPos[2]-(Edge*2.f), YL);
		}

		Canvas.SetPos(Edge*6, YP);
		if (C.ItemRows[i].bSplitter)
			Canvas.SetDrawColor(255, 255, 255, 255);
		else
		{
			if (C.ItemRows[i].bDisabled)
				Canvas.SetDrawColor(148, 148, 148, 255);
			else Canvas.SetDrawColor(248, 248, 248, 255);
		}
		Canvas.DrawText(S, ,TextScale, TextScale);

		YP+=YL;
	}
	Canvas.PopMaskRegion();
	if (C.OldRow != C.CurrentRow)
	{
		C.OldRow = C.CurrentRow;
		C.PlayMenuSound(MN_FocusHover);
	}
}

function RenderButton(KFGUI_Button B)
{
	local float XL, YL, TS, AX, AY, GamepadTexSize;
	local float TexW, TexH;
	local Texture2D ButtonTex;
	local bool bDrawOverride;

	bDrawOverride = B.DrawOverride(Canvas, B);
	if (!bDrawOverride)
	{
		if (B.bDisabled)
			Canvas.SetDrawColor(10, 10, 10, 200);
		else if (B.bPressedDown)
			Canvas.SetDrawColor(250, 50, 0, 200);
		else if (B.bFocused || B.bIsHighlighted)
			Canvas.SetDrawColor(150, 0, 0, 200);
		else Canvas.SetDrawColor(75, 0, 0, 200);

		Canvas.SetPos(0.f, 0.f);
		Owner.CurrentStyle.DrawRectBox(B.XPosition, B.YPosition, B.CompPos[2], B.CompPos[3], 8.f, B.ButtonStyle);

		if (B.OverlayTexture.Texture != None)
		{
			Canvas.SetPos(0.f, 0.f);
			if (B.bDisabled)
				Canvas.SetDrawColor(10, 10, 10, 255);
			else
				Canvas.SetDrawColor(250, 250, 250, 255);

		//	Compute Size
			if(B.CompPos[2]/B.OverlayTexture.UL < B.CompPos[3]/B.OverlayTexture.VL)
			{
				TexW = B.CompPos[2];
				TexH = B.CompPos[2]*(B.OverlayTexture.VL/B.OverlayTexture.UL);
			}
			else
			{
				TexW = B.CompPos[3]*(B.OverlayTexture.UL/B.OverlayTexture.VL);
				TexH = B.CompPos[3];
			}
			Canvas.SetPos((B.CompPos[2]-TexW)/2, (B.CompPos[3]-TexH)/2);

			Canvas.DrawTile(B.OverlayTexture.Texture, TexW, TexH, B.OverlayTexture.U, B.OverlayTexture.V, B.OverlayTexture.UL, B.OverlayTexture.VL);
		}
	}

	if (B.ButtonText != "")
	{
		Canvas.Font = MainFont;

		GamepadTexSize = B.CompPos[3] / 1.25;

		TS = GetFontScaler();
		TS *= B.FontScale;

		while (true)
		{
			Canvas.TextSize(B.ButtonText, XL, YL, TS, TS);
			if (XL < (B.CompPos[2]*0.9) && YL < (B.CompPos[3]*0.9))
				break;

			TS -= 0.001;
		}

		Canvas.SetPos((B.CompPos[2]-XL)*0.5, (B.CompPos[3]-YL)*0.5);
		if (B.bDisabled)
			Canvas.DrawColor = B.TextColor*0.5f;
		else Canvas.DrawColor = B.TextColor;
		Canvas.DrawText(B.ButtonText, ,TS, TS, B.TextFontInfo);

		if (B.GetUsingGamepad())
		{
			ButtonTex = Texture2D(DynamicLoadObject("UI_Controller."$B.GamepadButtonName$"_Asset", class'Texture2D'));
			if (ButtonTex != None)
			{
				B.GetRealtivePos(AX, AY);
				while ((Canvas.CurX-(GamepadTexSize*1.25)) < AX)
				{
					GamepadTexSize *= 0.95;
				}

				switch (ButtonTex.Name)
				{
					case 'XboxTypeS_A_Asset':
					case 'XboxTypeS_B_Asset':
					case 'XboxTypeS_X_Asset':
					case 'XboxTypeS_Y_Asset':
						Canvas.SetDrawColor(255, 255, 255, 145);
						break;
					default:
						Canvas.SetDrawColor(0, 0, 0, 145);
						break;
				}

				Canvas.SetPos(Canvas.CurX-(GamepadTexSize*1.25), (B.CompPos[3]-GamepadTexSize)*0.5);
				Canvas.DrawRect(GamepadTexSize, GamepadTexSize, ButtonTex);
			}
		}
	}
}

defaultproperties
{
}