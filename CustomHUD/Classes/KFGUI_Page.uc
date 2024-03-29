Class KFGUI_Page extends KFGUI_MultiComponent
	abstract;

`include(Build.uci)
`include(Logger.uci)

var() byte FrameOpacity; // Transperancy of the frame.
var() bool bPersistant, // Reuse the same menu object throughout the level.
			bUnique, // If calling OpenMenu multiple times with same menu class, only open one instance of it.
			bAlwaysTop, // This menu should stay always on top.
			bOnlyThisFocus, // Only this menu should stay focused.
			bNoBackground; // Don't draw the background.

var bool bWindowFocused; // This page is currently focused.
var Color FrameColor;

function DrawMenu()
{
	if (!bNoBackground)
	{
		Owner.CurrentStyle.RenderWindow(Self);
	}
}


function DrawTextShadowBoxCenter(string Str, float XPos, float YPos, float BoxWidth, float BoxHeight, float FontScalar)
{
	local float TextWidth;
	local float TextHeight;

	Canvas.TextSize(Str, TextWidth, TextHeight, FontScalar, FontScalar);

	Owner.CurrentStyle.DrawTextShadow(Str, XPos + (BoxWidth - TextWidth)/2 , YPos + (BoxHeight - TextHeight)/2, 1, FontScalar);
}

function DrawTextShadowBoxLeft(string Str, float XPos, float YPos, float BoxHeight, float FontScalar)
{
	local float TextWidth;
	local float TextHeight;

	Canvas.TextSize(Str, TextWidth, TextHeight, FontScalar, FontScalar);

	Owner.CurrentStyle.DrawTextShadow(Str, XPos, YPos + (BoxHeight - TextHeight)/2, 1, FontScalar);
}

function DrawTextShadowHVCenter(string Str, float XPos, float YPos, float BoxWidth, float FontScalar)
{
	local float TextWidth;
	local float TextHeight;

	Canvas.TextSize(Str, TextWidth, TextHeight, FontScalar, FontScalar);

	Owner.CurrentStyle.DrawTextShadow(Str, XPos + (BoxWidth - TextWidth)/2 , YPos, 1, FontScalar);
}

function DrawTextShadowHLeftVCenter(string Str, float XPos, float YPos, float FontScalar)
{
	Owner.CurrentStyle.DrawTextShadow(Str, XPos, YPos, 1, FontScalar);
}

function DrawTextShadowHRightVCenter(string Str, float XPos, float YPos, float BoxWidth, float FontScalar)
{
	local float TextWidth;
	local float TextHeight;

	Canvas.TextSize(Str, TextWidth, TextHeight, FontScalar, FontScalar);
	
	Owner.CurrentStyle.DrawTextShadow(Str, XPos + BoxWidth - TextWidth, YPos, 1, FontScalar);
}

function DrawCategolyZone(string Title, float XPos, float YPos, float ZoneWidth, float ZoneHight, float FontScalar, float BorderSize, float YL)
{
	Canvas.SetDrawColor(75, 0, 0, 200);
	Owner.CurrentStyle.DrawRectBox(XPos, YPos, ZoneWidth, YL+BorderSize, 8.f, 0);
	Canvas.SetDrawColor(250, 250, 250, 255);
	DrawTextShadowHVCenter(Title, XPos, YPos, ZoneWidth, FontScalar);
	Canvas.SetDrawColor(30, 30, 30, 200);
	Owner.CurrentStyle.DrawRectBox(XPos, YPos+YL+BorderSize, ZoneWidth, ZoneHight+BorderSize, 8.f, 152);
}

function DrawBoxDescription(string Title, KFGUI_CheckBox C, float RightEnd, optional bool bDrawCond=true)
{
	local float YL, Width, Height, FontScalar, XPos, YPos;

	if(!bDrawCond)
		return;

	Width = RightEnd*CompPos[2]+CompPos[0]-C.CompPos[0]-C.CompPos[2];
	Height = C.CompPos[3];
	XPos = C.CompPos[0]-CompPos[0]+C.CompPos[2];
	YPos = C.CompPos[1]-CompPos[1];

	DrawBoxDescriptionCore(XPos, YPos, Width, Height, 153, Title, YL, FontScalar);
	DrawTextShadowHLeftVCenter(Title, XPos+Width*0.1, YPos, FontScalar);
}

function DrawBoxDescriptionReverse(string Title, KFGUI_CheckBox C, float LeftEnd, optional bool bDrawCond=true)
{
	local float YL, Width, Height, FontScalar, XPos, YPos;

	if(!bDrawCond)
		return;

	Width = C.CompPos[0]-LeftEnd*CompPos[2]-CompPos[0];
	Height = C.CompPos[3];
	XPos = LeftEnd*CompPos[2];
	YPos = C.CompPos[1]-CompPos[1];

	DrawBoxDescriptionCore(XPos, YPos, Width, Height, 151, Title, YL, FontScalar);
	DrawTextShadowHRightVCenter(Title, XPos-Width*0.1, YPos, Width, FontScalar);
}

function DrawBoxDescriptionCore(float XPos, float YPos, float Width, float Height, int ShapeID, string Title, out float YL, out float FontScalar)
{
	Canvas.SetDrawColor(0, 0, 0, 215);
	Owner.CurrentStyle.DrawRectBox(XPos, YPos, Width, Height, 2.5f, ShapeID);
	Canvas.SetDrawColor(250, 250, 250, 255);

	Canvas.Font = Owner.CurrentStyle.PickFont(FontScalar);

	FitScale(Title, Width*0.85, FontScalar);
}

function FColumnItem newFColumnItem(string Text, float Width)
{
	local FColumnItem newItem;
	newItem.Text=Text;
	newItem.Width=Width;
	return newItem;
}

function FitScale(string s, float w, out float sc)
{
	local float XL, YL;

	while(true)
	{
		Canvas.TextSize(s, XL, YL, sc, sc);
		if(XL < w)
			return;

		sc -= 0.001;
	}
}

defaultproperties
{
	bUnique=true
	bPersistant=true
	FrameOpacity=175
	FrameColor=(R=10, G=10, B=10, A=200)
}