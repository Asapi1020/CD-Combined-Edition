class xUI_AdminMenu extends xUI_MenuBase;

`include(CD_Log.uci)

enum PageState
{
	RPW,
	Authority,
	CustomPlayerStart
};

var KFGUI_Button RPWB;
var KFGUI_Button AuthorityB;
var KFGUI_Button PlayerStartButton;

var private xUI_AdminMenu_RPW RPWComponents;
var private xUI_AdminMenu_Authority AuthorityComponents;
var private xUI_AdminMenu_PlayerStart PlayerStartComponents;

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
	RPWComponents.InitComponents();

	AuthorityComponents = new(self) class'xUI_AdminMenu_Authority';
	AddComponent(AuthorityComponents);
	AuthorityComponents.InitComponents();

	PlayerStartComponents = new(self) class'xUI_AdminMenu_PlayerStart';
	AddComponent(PlayerStartComponents);
	PlayerStartComponents.InitComponents();
}

function DrawMenu()
{
//	Setup
	local float XL, YL, FontScalar;

	Super.DrawMenu();

	Canvas.Font = Owner.CurrentStyle.PickFont(FontScalar);
	Canvas.TextSize("ABC", XL, YL, FontScalar, FontScalar);

	switch(CurState)
	{
		case RPW:
			RPWComponents.DrawComponents(XL, YL, FontScalar);
			break;
		case Authority:
			AuthorityComponents.DrawComponents();
			break;
		case CustomPlayerStart:
			PlayerStartComponents.DrawComponents();
			break;
		default:
			`cdlog("invalid cur state");
			CurState = RPW;
			break;
	}

	if(!bListUpdate)
	{
		UpdateList();
	}

	RPWComponents.bVisible = CurState == RPW;
	AuthorityComponents.bVisible = CurState == Authority;
	PlayerStartComponents.bVisible = CurState == CustomPlayerStart;

	RPWB = KFGUI_Button(FindComponentID('RPW'));
	RPWB.ButtonText = RPWButtonText;
	RPWB.bDisabled = CurState == RPW;

	AuthorityB = KFGUI_Button(FindComponentID('Authority'));
	AuthorityB.ButtonText = AuthorityButtonText;
	AuthorityB.bDisabled = CurState == Authority;

	PlayerStartButton = KFGUI_Button(FindComponentID('CustomPlayerStart'));
	PlayerStartButton.ButtonText = PlayerStartButtonText;
	PlayerStartButton.bDisabled = CurState == CustomPlayerStart;
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
		default:
			`cdlog("invalid cur state");
			CurState = RPW;
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
	}
}

public function ReceiveDisableCustomStarts( bool bDisable )
{
	PlayerStartComponents.bServerDisableCustomStarts = bDisable;
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
}
