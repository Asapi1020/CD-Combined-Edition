class xUI_AdminMenu extends xUI_MenuBase;

`include(CD_Log.uci)

enum PageState
{
	RPW,
	Authority,
	CustomPlayerStart,
	OtherSettings
};

var KFGUI_Button RPWB;
var KFGUI_Button AuthorityB;
var KFGUI_Button PlayerStartButton;
var KFGUI_Button OtherSettingsButton;

var protected xUI_AdminMenu_RPW RPWComponents;
var protected xUI_AdminMenu_Authority AuthorityComponents;
var protected xUI_AdminMenu_PlayerStart PlayerStartComponents;
var protected xUI_AdminMenu_Others OthersComponents;

var PageState CurState;
var bool bListUpdate;

var localized string LevelRestrictionToolTip;
var localized string SkillRestrictionToolTip;
var localized string AntiOvercapToolTip;
var localized string PerkAuthorityString;
var localized string MaxUpgradeString;
var localized string RPWButtonText;
var localized string AuthorityButtonText;
var localized string PlayerStartButtonText;
var localized string OtherSettingsButtonText;
var localized string LevelRequirementString;
var localized string AntiOvercapString;
var localized string WeaponHeader;
var localized string BossOnlyHeader;
var localized string NameHeader;
var localized string IDHeader;
var localized string LoadingMsg;
var localized string LevelHeader;
var localized string LevelSetString;
var localized string BanString;
var localized string ToggleBossOnlyString;
var localized string RemoveString;

function SetWindowDrag(bool bDrag)
{
	bDragWindow = false;
}

function InitMenu()
{
	super.InitMenu();

	RPWComponents = new(self) class'xUI_AdminMenu_RPW';
	AddComponent(RPWComponents);

	AuthorityComponents = new(self) class'xUI_AdminMenu_Authority';
	AddComponent(AuthorityComponents);

	PlayerStartComponents = new(self) class'xUI_AdminMenu_PlayerStart';
	AddComponent(PlayerStartComponents);

	OthersComponents = new(self) class'xUI_AdminMenu_Others';
	AddComponent(OthersComponents);
}

function DrawMenu()
{
	if (!GetCDPC().hasAdminLevel())
	{
		DoClose();
		return;
	}

	Super.DrawMenu();

	if(!bListUpdate)
	{
		UpdateList();
	}

	RPWComponents.bVisible = CurState == RPW;
	AuthorityComponents.bVisible = CurState == Authority;
	PlayerStartComponents.bVisible = CurState == CustomPlayerStart;
	OthersComponents.bVisible = CurState == OtherSettings;

	RPWB = KFGUI_Button(FindComponentID('RPW'));
	RPWB.ButtonText = RPWButtonText;
	RPWB.bDisabled = CurState == RPW;

	AuthorityB = KFGUI_Button(FindComponentID('Authority'));
	AuthorityB.ButtonText = AuthorityButtonText;
	AuthorityB.bDisabled = CurState == Authority;

	PlayerStartButton = KFGUI_Button(FindComponentID('CustomPlayerStart'));
	PlayerStartButton.ButtonText = PlayerStartButtonText;
	PlayerStartButton.bDisabled = CurState == CustomPlayerStart;

	OtherSettingsButton = KFGUI_Button(FindComponentID('OtherSettings'));
	OtherSettingsButton.ButtonText = OtherSettingsButtonText;
	OtherSettingsButton.bDisabled = CurState == OtherSettings;
}

private final function UpdateList()
{
	switch(CurState)
	{
		case(RPW):
			RPWComponents.UpdateWeaponRestrictionsList();
			break;
		case(Authority):
			AuthorityComponents.UpdateAuthorityList();
			break;
		case(CustomPlayerStart):
			PlayerStartComponents.OnUpdatePlayerStartList();
			break;
		case(OtherSettings):
			break;
		default:
			`cdlog("invalid cur state");
			return;
	}

	bListUpdate = true;
}

public final function UpdatePlayerStartList(array<string> PathNodesIndexString)
{
	PlayerStartComponents.UpdatePlayerStartList(PathNodesIndexString);
}

private function ButtonClicked(KFGUI_Button Sender)
{
	switch(Sender.ID)
	{
		case 'RPW':
			CurState = RPW;
			bListUpdate = false;
			break;
		case 'Authority':
			CurState = Authority;
			bListUpdate = false;
			break;
		case 'CustomPlayerStart':
			CurState = CustomPlayerStart;
			bListUpdate = false;
			break;
		case 'OtherSettings':
			CurState = OtherSettings;
			break;
		default:
			`cdlog("xUI_AdminMenu: ButtonClicked: Unknown button clicked: " $ Sender.ID);
			return;
	}
}

public function ReceiveDisableCustomStarts( bool bDisable )
{
	PlayerStartComponents.bServerDisableCustomStarts = bDisable;
}

public function ReceiveDisableCDRecordOnline( bool bDisable )
{
	OthersComponents.bDisableCDRecordOnline = bDisable;
}

public function ReceiveDisableCustomPostGameMenu( bool bDisable )
{
	OthersComponents.bDisableCustomPostGameMenu = bDisable;
}

defaultproperties
{
//	General
	ID="AdminMenu"
	Version="2.1.0"
	CurState=RPW

	Begin Object Class=KFGUI_Button Name=RPW
		XPosition=0.025
		YPosition=0.925
		XSize=0.14
		YSize=0.05
		ID="RPW"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object
	Components.Add(RPW)

	Begin Object Class=KFGUI_Button Name=Authority
		XPosition=0.19
		YPosition=0.925
		XSize=0.14
		YSize=0.05
		ID="Authority"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object
	Components.Add(Authority)

	Begin Object Class=KFGUI_Button Name=CustomPlayerStart
		XPosition=0.355
		YPosition=0.925
		XSize=0.14
		YSize=0.05
		ID="CustomPlayerStart"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object
	Components.Add(CustomPlayerStart)

	Begin Object Class=KFGUI_Button Name=OtherSettings
		XPosition=0.52
		YPosition=0.925
		XSize=0.14
		YSize=0.05
		ID="OtherSettings"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object
	Components.Add(OtherSettings)
}
