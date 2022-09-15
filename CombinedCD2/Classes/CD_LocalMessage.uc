class CD_LocalMessage extends KFLocalMessage
	abstract;

enum CDLocalMessageType
{
	CDLMT_LargeKill
};

static function ClientReceive(
	PlayerController P,
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	local class<KFPawn_Monster> KFPMClass;
	local KFPlayerReplicationInfo KFPRI;
	local KFPlayerController KFPC;
	local GFxObject GFxManager, DataObject;


	if (Switch == CDLMT_LargeKill)
	{
		// Adapted from KFGFxMoviePlayer_HUD.ShowKillMessage()
		KFPMClass = class<KFPawn_Monster>(OptionalObject);
		KFPRI = KFPlayerReplicationInfo(RelatedPRI_1);
		KFPC = KFPlayerController(P);

		if (KFPMClass == None || KFPRI == None || KFPC == None || KFPC.MyGFxHUD == None || !KFPC.bShowKillTicker)
			return;

		GFxManager = KFPC.MyGFxHUD.GetVariableObject("root");
		DataObject = KFPC.MyGFxHUD.CreateObject("Object");

		DataObject.SetBool("humanDeath", false);

		DataObject.SetString("killedName", KFPMClass.static.GetLocalizedName());
		DataObject.SetString("killedTextColor", "");
		// This would normally be left blank,
		// but the Flash HUD puts a space in the
		// kill message, which looks sloppy
		DataObject.SetString("killedIcon", "img://" $ class'KFGame.KFPerk_Monster'.static.GetPerkIconPath());

		DataObject.SetString("killerName", KFPRI.GetHumanReadableName());
		DataObject.SetString("killerTextColor", "");
		DataObject.SetString("killerIcon", "img://" $ KFPRI.CurrentPerkClass.static.GetPerkIconPath());

		GFxManager.SetObject("newBark", DataObject);

		return;
	}

	super.ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
}