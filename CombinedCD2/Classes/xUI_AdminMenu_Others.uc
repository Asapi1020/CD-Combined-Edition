class xUI_AdminMenu_Others extends KFGUI_MultiComponent
	within xUI_AdminMenu;

`include(CD_Log.uci)

var transient bool bDisableCDRecordOnline, bDisableCustomPostGameMenu;

var KFGUI_CheckBox DisableCDRecordOnlineCheckBox;
var KFGUI_CheckBox DisableCustomPostGameMenuCheckBox;

public function InitMenu()
{
	Super.InitMenu();

	GetCDPC().GetDisableCDRecordOnline();
	GetCDPC().GetDisableCustomPostGameMenu();
}

public function DrawMenu()
{
	Super.DrawMenu();

	DisableCDRecordOnlineCheckBox = KFGUI_CheckBox(FindComponentID('DisableCDRecordOnline'));
	DisableCDRecordOnlineCheckBox.bChecked = bDisableCDRecordOnline;
	DrawBoxDescription("DisableCDRecordOnline", DisableCDRecordOnlineCheckBox, 0.45, bVisible);

	DisableCustomPostGameMenuCheckBox = KFGUI_CheckBox(FindComponentID('DisableCustomPostGameMenu'));
	DisableCustomPostGameMenuCheckBox.bChecked = bDisableCustomPostGameMenu;
	DrawBoxDescription("DisableCustomPostGameMenu", DisableCustomPostGameMenuCheckBox, 0.45, bVisible);
}

protected function ToggleCheckBox(KFGUI_CheckBox Sender)
{
	switch(Sender.ID)
	{
		case 'DisableCDRecordOnline':
			bDisableCDRecordOnline = Sender.bChecked;
			GetCDPC().SetDisableCDRecordOnline(bDisableCDRecordOnline);
			break;

		case 'DisableCustomPostGameMenu':
			bDisableCustomPostGameMenu = Sender.bChecked;
			GetCDPC().SetDisableCustomPostGameMenu(bDisableCustomPostGameMenu);
			break;

		default:
			`cdlog("Unknown checkbox ID: " $ Sender.ID);
			break;
	}
}

defaultproperties
{
	ID="AdminMenu_Others"

	Begin Object Class=KFGUI_CheckBox Name=DisableCDRecordOnline
		XPosition=0.05
		YPosition=0.05
		ID="DisableCDRecordOnline"
		OnCheckChange=ToggleCheckBox
	End Object
	Components.Add(DisableCDRecordOnline)

	Begin Object Class=KFGUI_CheckBox Name=DisableCustomPostGameMenu
		XPosition=0.05
		YPosition=0.10
		ID="DisableCustomPostGameMenu"
		OnCheckChange=ToggleCheckBox
	End Object
	Components.Add(DisableCustomPostGameMenu)
}
