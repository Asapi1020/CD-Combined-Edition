class xUI_MenuBase extends KFGUI_FloatingWindow;

function CD_PlayerController GetCDPC()
{
	return CD_PlayerController(GetPlayer());
}

function CD_PlayerReplicationInfo GetCDPRI()
{
	return CD_PlayerReplicationInfo(GetCDPC().PlayerReplicationInfo);
}

function CD_GameReplicationInfo GetCDGRI()
{
	return CD_GameReplicationInfo(GetCDPC().WorldInfo.GRI);
}

function DrawControllerInfo(string Title, string Value, KFGUI_Button LB, KFGUI_Button RB, float YL, float FontScalar, float BorderSize, int ValueDarkness, optional float SizeRate=1.f, optional bool bHeaderLess=false)
{
	local float XPos, YPos, BoxW;

	//	Header
	if(!bHeaderLess)
	{
		XPos = LB.CompPos[0] - CompPos[0];
		YPos = LB.CompPos[1] - CompPos[1] - YL - BorderSize;
		BoxW = RB.CompPos[0] - LB.CompPos[0] + RB.CompPos[2];

		Canvas.SetDrawColor(0, 0, 0, 200);
		Owner.CurrentStyle.DrawRectBox(XPos, YPos, BoxW, YL + BorderSize, 8.f, 150);
		Canvas.SetDrawColor(250, 250, 250, 255);
		DrawTextShadowHVCenter(Title, XPos, YPos, BoxW, FontScalar);
	}

	//	Value
	XPos += LB.CompPos[2];
	YPos += YL + BorderSize;
	BoxW = RB.CompPos[0] - LB.CompPos[0] - LB.CompPos[2] + BorderSize;

	Canvas.SetDrawColor(ValueDarkness, ValueDarkness, ValueDarkness, 200);
	Owner.CurrentStyle.DrawRectBox(XPos, YPos, BoxW, RB.CompPos[3], 8.f, 121);
	Canvas.SetDrawColor(250, 250, 250, 255);
	DrawTextShadowHVCenter(Value, XPos, YPos + (RB.CompPos[3]/8), BoxW, FontScalar*SizeRate);
}