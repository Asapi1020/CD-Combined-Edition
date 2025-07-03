class xUI_Navigation_Right extends KFGUI_MultiComponent
	within xUI_MenuBase;

`include(CD_Log.uci)

var KFGUI_Button MapVoteMenuButton;

public function InitMenu()
{
	local float Width;

	Super.InitMenu();

	Width = (1 - Outer.XPosition - Outer.XSize) / Outer.XSize;
	Self.XSize = Width;
}

public function DrawMenu()
{
	local CD_PlayerController CDPC;

	Super.DrawMenu();

	CDPC = GetCDPC();

	MapVoteMenuButton = KFGUI_Button(FindComponentID('MapVoteMenuButton'));
	MapVoteMenuButton.ButtonText = CDPC.default.MapVoteMenuClass.default.Title;
}

protected function ButtonClicked(KFGUI_Button Sender)
{
	local CD_PlayerController CDPC;

	CDPC = GetCDPC();

	switch(Sender.ID)
	{
		case('MapVoteMenuButton'):
			CDPC.OpenMapVote();
			DoClose();
			break;
		default:
			`cdlog("invalid button clicked: " $ Sender.ID);
			break;
	}
}

defaultproperties
{
	ID="RightNavigationBar"
	XPosition=1

	Begin Object Class=KFGUI_Button Name=MapVoteMenu
		XPosition=0.100
		YPosition=0.925
		XSize=0.800
		YSize=0.060
		ID="MapVoteMenuButton"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object
	Components.Add(MapVoteMenu)
}
