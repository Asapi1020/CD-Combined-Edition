class xUI_Navigation extends KFGUI_MultiComponent
	within xUI_MenuBase;

`include(CD_Log.uci)

var KFGUI_Button ClientMenuButton;
var KFGUI_Button AutoTraderMenuButton;
var KFGUI_Button CycleMenuButton;
var KFGUI_Button PlayersMenuButton;
var KFGUI_Button AdminMenuButton;
var KFGUI_Button CloseButton;

public function InitMenu()
{
	local float XPos, Width;

	Super.InitMenu();

	Width = Outer.XPosition / Outer.XSize;
	XPos = Width * -1;
	Self.XPosition = XPos;
	Self.XSize = Width;
}

public function DrawMenu()
{
	local CD_PlayerController CDPC;

	Super.DrawMenu();

	CDPC = GetCDPC();

	ClientMenuButton = KFGUI_Button(FindComponentID('ClientMenuButton'));
	ClientMenuButton.ButtonText = CDPC.default.ClientMenuClass.default.Title;
	ClientMenuButton.bDisabled = isThisMenu(CDPC.default.ClientMenuClass);

	AutoTraderMenuButton = KFGUI_Button(FindComponentID('AutoTraderMenuButton'));
	AutoTraderMenuButton.ButtonText = CDPC.default.AutoTraderMenuClass.default.Title;
	AutoTraderMenuButton.bDisabled = isThisMenu(CDPC.default.AutoTraderMenuClass);

	CycleMenuButton = KFGUI_Button(FindComponentID('CycleMenuButton'));
	CycleMenuButton.ButtonText = CDPC.default.CycleMenuClass.default.Title;
	CycleMenuButton.bDisabled = isThisMenu(CDPC.default.CycleMenuClass);

	PlayersMenuButton = KFGUI_Button(FindComponentID('PlayersMenuButton'));
	PlayersMenuButton.ButtonText = CDPC.default.PlayersMenuClass.default.Title;
	PlayersMenuButton.bDisabled = isThisMenu(CDPC.default.PlayersMenuClass);

	AdminMenuButton = KFGUI_Button(FindComponentID('AdminMenuButton'));
	AdminMenuButton.ButtonText = CDPC.default.AdminMenuClass.default.Title;
	AdminMenuButton.bVisible = CDPC.hasAdminLevel();
	AdminMenuButton.bDisabled = isThisMenu(CDPC.default.AdminMenuClass);

	CloseButton = KFGUI_Button(FindComponentID('CloseButton'));
	CloseButton.ButtonText = Outer.default.CloseButtonText;
}

private function ButtonClicked(KFGUI_Button Sender)
{
	local CD_PlayerController CDPC;

	CDPC = GetCDPC();

	switch(Sender.ID)
	{
		case('ClientMenuButton'):
			if(!isThisMenu(CDPC.default.ClientMenuClass))
			{
				Owner.OpenMenu(CDPC.default.ClientMenuClass, true);
				DoClose();
			}
			break;
		case('AutoTraderMenuButton'):
			if(!isThisMenu(CDPC.default.AutoTraderMenuClass))
			{
				Owner.OpenMenu(CDPC.default.AutoTraderMenuClass, true);
				DoClose();
			}
			break;
		case('CycleMenuButton'):
			if(!isThisMenu(CDPC.default.CycleMenuClass))
			{
				Owner.OpenMenu(CDPC.default.CycleMenuClass, true);
				DoClose();
			}
			break;
		case('PlayersMenuButton'):
			if(!isThisMenu(CDPC.default.PlayersMenuClass))
			{
				Owner.OpenMenu(CDPC.default.PlayersMenuClass, true);
				DoClose();
			}
			break;
		case('AdminMenuButton'):
			if(CDPC.hasAdminLevel() && !isThisMenu(CDPC.default.AdminMenuClass))
			{
				Owner.OpenMenu(CDPC.default.AdminMenuClass, true);
				DoClose();
			}
			break;
		case('CloseButton'):
			DoClose();
			break;
		default:
			`cdlog("invalid button clicked: " $ Sender.ID);
			break;
	}
}

private function bool isThisMenu(class<KFGUI_Page> MenuClass)
{
	return Outer.default.ID == MenuClass.default.ID;
}

defaultproperties
{
	ID="NavigationBar"

	Begin Object Class=KFGUI_Button Name=ClientMenu
		XPosition=0.10
		YPosition=0.05
		XSize=0.800
		YSize=0.06
		ID="ClientMenuButton"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object
	Components.Add(ClientMenu)

	Begin Object Class=KFGUI_Button Name=AutoTraderMenu
		XPosition=0.10
		YPosition=0.12
		XSize=0.800
		YSize=0.06
		ID="AutoTraderMenuButton"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object
	Components.Add(AutoTraderMenu)

	Begin Object Class=KFGUI_Button Name=CycleMenu
		XPosition=0.10
		YPosition=0.19
		XSize=0.800
		YSize=0.06
		ID="CycleMenuButton"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object
	Components.Add(CycleMenu)

	Begin Object Class=KFGUI_Button Name=PlayersMenu
		XPosition=0.10
		YPosition=0.26
		XSize=0.800
		YSize=0.06
		ID="PlayersMenuButton"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object
	Components.Add(PlayersMenu)

	Begin Object Class=KFGUI_Button Name=AdminMenu
		XPosition=0.10
		YPosition=0.33
		XSize=0.800
		YSize=0.06
		ID="AdminMenuButton"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object
	Components.Add(AdminMenu)

	Begin Object Class=KFGUI_Button Name=CloseButton
		XPosition=0.10
		YPosition=0.925
		XSize=0.800
		YSize=0.06
		ID="CloseButton"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object
	Components.Add(CloseButton)
}
