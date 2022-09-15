class KFGUI_CategoryButton extends KFGUI_Button;

`include(Build.uci)
`include(Logger.uci)


var transient bool bOpened;
var Texture2D Icon;
var Color IconColor;

function DrawMenu()
{
	local float XL, YL, TS, TextX, TextY;
	local Texture2D Mat;
	local bool bDrawOverride;

	bDrawOverride = DrawOverride(Canvas, Self);
	if (!bDrawOverride)
	{
		if (bDisabled)
			Mat = Owner.CurrentStyle.ButtonTextures[`BUTTON_DISABLED];
		else if (bPressedDown)
			Mat = Owner.CurrentStyle.ButtonTextures[`BUTTON_PRESSED];
		else if (bFocused || bIsHighlighted)
			Mat = Owner.CurrentStyle.ButtonTextures[`BUTTON_NORMAL];
		else Mat = Owner.CurrentStyle.ButtonTextures[`BUTTON_HIGHLIGHTED];

		Canvas.SetPos(0.f, 0.f);
		Canvas.DrawTileStretched(Mat, CompPos[2], CompPos[3], 0,0, 32, 32);

		if (OverlayTexture.Texture != None)
		{
			Canvas.SetPos(0.f, 0.f);
			Canvas.DrawTile(OverlayTexture.Texture, CompPos[2], CompPos[3], OverlayTexture.U, OverlayTexture.V, OverlayTexture.UL, OverlayTexture.VL);
		}
	}

	if (ButtonText != "")
	{
		Canvas.Font = Owner.CurrentStyle.MainFont;

		TS = Owner.CurrentStyle.GetFontScaler();
		TS *= FontScale;

		while (true)
		{
			Canvas.TextSize(ButtonText, XL, YL, TS, TS);
			if (XL < (CompPos[2]*0.9) && YL < (CompPos[3]*0.9))
				break;

			TS -= 0.001;
		}

		TextX = (CompPos[2]-XL)*0.5;
		TextY = (CompPos[3]-YL)*0.5;

		Canvas.SetPos(TextX, TextY);
		if (bDisabled)
			Canvas.DrawColor = TextColor*0.5f;
		else Canvas.DrawColor = TextColor;
		Canvas.DrawText(ButtonText, ,TS, TS, TextFontInfo);

		if (Icon != None)
		{
			Canvas.DrawColor = IconColor;

			Canvas.SetPos(TextX-CompPos[3], 0.f);
			Canvas.DrawRect(CompPos[3], CompPos[3], Icon);

			Canvas.SetPos(TextX+XL, 0.f);
			Canvas.DrawRect(CompPos[3], CompPos[3], Icon);
		}
	}

	Canvas.DrawColor = class'HUD'.default.WhiteColor;
	Canvas.SetPos(0.f, 0.f);
	Canvas.DrawRect(CompPos[3], CompPos[3], bOpened ? Owner.CurrentStyle.ArrowTextures[`ARROW_DOWN] : Owner.CurrentStyle.ArrowTextures[`ARROW_RIGHT]);
	Canvas.SetPos(CompPos[2]-CompPos[3], 0.f);
	Canvas.DrawRect(CompPos[3], CompPos[3], bOpened ? Owner.CurrentStyle.ArrowTextures[`ARROW_DOWN] : Owner.CurrentStyle.ArrowTextures[`ARROW_LEFT]);
}

defaultproperties
{
}