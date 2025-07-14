// Written by Marco.
// Mapvote manager client.
Class xVotingReplication extends ReplicationInfo
	dependson(xStructHolder);

struct FGameTypeEntry
{
	var string GameName,GameShortName,Prefix;
};


var array<FGameTypeEntry> GameModes;
var array<xStructHolder.FMapEntry> Maps;
var array<xStructHolder.FVotedMaps> ActiveVotes;

var PlayerController PlayerOwner;
var xVotingHandler VoteHandler;
var byte DownloadStage;
var int DownloadIndex,ClientCurrentGame;
var int CurrentVote[2];
var transient float RebunchTimer,NextVoteTimer;
var bool bClientConnected,bAllReceived,bClientRanked;
var transient bool bListDirty;

//var localized string MaplistRecvMsg;
//var localized string ClientMapVoteMsg;
var localized string InitMapVoteMsg;
var localized string TwoMinRemainMsg;
var localized string OneMinRemainMsg;
var localized string XSecondsRemainMsg;
var localized string UnknownPlayerName;
var localized string VotedForKnownMapMsg;
var localized string VotedForUnkownMapMsg;
var localized string AdminForcedKnownMapswitchMsg;
var localized string AdminForcedUnknownMapswitchMsg;
var localized string KnownMapSwitchMsg;
var localized string UnknownMapSwitchMsg;
var localized string MapVoteHelpString;
var localized string MapVotePrefix;
var localized string PleaseWaitMsg;

var string XmasHatPath;
var transient LinearColor ZC_MonoChromeValue;
var transient LinearColor ZC_ColorValue;

function PostBeginPlay()
{
	PlayerOwner = PlayerController(Owner);
	RebunchTimer = WorldInfo.TimeSeconds+5.f;
}

function Tick(float Delta)
{
	if (PlayerOwner==None || PlayerOwner.Player==None)
	{
		Destroy();
		return;
	}

	if (!bClientConnected)
	{
		if (RebunchTimer<WorldInfo.TimeSeconds)
		{
			RebunchTimer = WorldInfo.TimeSeconds+0.75;
			ClientVerify();
		}
	}
	else if (DownloadStage<255)
		VoteHandler.ClientDownloadInfo(Self);
}

reliable server function ServerNotifyReady()
{
	bClientConnected = true;
}

unreliable client simulated function ClientVerify()
{
	SetOwner(GetPlayer());
	ServerNotifyReady();
}

simulated final function PlayerController GetPlayer()
{
	if (PlayerOwner==None)
		PlayerOwner = GetALocalPlayerController();
	return PlayerOwner;
}

reliable client simulated function ClientReceiveGame(int Index, string GameName, string GameSName)
{
	if (GameModes.Length<=Index)
		GameModes.Length = Index+1;
	GameModes[Index].GameName = GameName;
	GameModes[Index].GameShortName = GameSName;
	bListDirty = true;
}

reliable client simulated function ClientReceiveMap(int Index, string MapName, int UpVote, int DownVote, int Sequence, int NumPlays, optional string MapTitle)
{
	if (Maps.Length<=Index)
		Maps.Length = Index+1;
	Maps[Index].MapName = MapName;
	if(MapTitle == "")
	{
		MapTitle = class'KFCommon_LocalizedStrings'.static.GetFriendlyMapName(MapName);
		Maps[Index].MapTitle = class'CD_Object'.static.GetCustomMapName(MapTitle);
	}
	else
	{
		Maps[Index].MapTitle = MapTitle;
	}
	Maps[Index].UpVotes = UpVote;
	Maps[Index].DownVotes = DownVote;
	Maps[Index].Sequence = Sequence;
	Maps[Index].NumPlays = NumPlays;
	bListDirty = true;
}

reliable client simulated function ClientReceiveVote(int GameIndex, int MapIndex, int VoteCount)
{
	local int i;
	
	for (i=0; i<ActiveVotes.Length; ++i)
	{
		if (ActiveVotes[i].GameIndex==GameIndex && ActiveVotes[i].MapIndex==MapIndex)
		{
			if (VoteCount==0)
				ActiveVotes.Remove(i,1);
			else ActiveVotes[i].NumVotes = VoteCount;
			bListDirty = true;
			return;
		}
	}

	if (VoteCount==0)
		return;
	ActiveVotes.Length = i+1;
	ActiveVotes[i].GameIndex = GameIndex;
	ActiveVotes[i].MapIndex = MapIndex;
	ActiveVotes[i].NumVotes = VoteCount;
	bListDirty = true;
}

reliable client simulated function ClientReady(int CurGame)
{
	ClientCurrentGame = CurGame;
	bAllReceived = true;
	MapVoteMsg(MapVoteHelpString);
}

simulated final function MapVoteMsg(string S)
{
	if (S!="")
		GetPlayer().ClientMessage(MapVotePrefix @ S, 'MapVote');
}

reliable client simulated function ClientNotifyVote(PlayerReplicationInfo PRI, int GameIndex, int MapIndex)
{
	if (bAllReceived)
		MapVoteMsg((PRI!=None ? PRI.PlayerName : UnknownPlayerName)$" "$VotedForKnownMapMsg$" "$Maps[MapIndex].MapTitle$" ("$GameModes[GameIndex].GameShortName$").");
	else MapVoteMsg((PRI!=None ? PRI.PlayerName : UnknownPlayerName)$" "$VotedForUnkownMapMsg);
}

reliable client simulated function ClientNotifyVoteTime(int Time)
{
	if (Time==0)
		MapVoteMsg(InitMapVoteMsg);
	if (Time<=10)
		MapVoteMsg(string(Time)$"...");
	else if (Time<60)
		MapVoteMsg(string(Time)$" "$XSecondsRemainMsg);
	else if (Time==60)
		MapVoteMsg(OneMinRemainMsg);
	else if (Time==120)
		MapVoteMsg(TwoMinRemainMsg);
}

reliable client simulated function ClientNotifyVoteWin(int GameIndex, int MapIndex, bool bAdminForce)
{
	Class'KF2GUIController'.Static.GetGUIController(GetPlayer()).CloseMenu(None,true);
	if (bAdminForce)
	{
		if (bAllReceived)
			MapVoteMsg(AdminForcedKnownMapswitchMsg$" "$Maps[MapIndex].MapTitle$" ("$GameModes[GameIndex].GameShortName$").");
		else MapVoteMsg(AdminForcedUnknownMapswitchMsg);
	}
	else if (bAllReceived)
		MapVoteMsg(Maps[MapIndex].MapTitle$" ("$GameModes[GameIndex].GameShortName$") "$KnownMapSwitchMsg);
	else MapVoteMsg(UnknownMapSwitchMsg);
}

reliable client simulated function ClientOpenMapvote(name OpenState, optional bool bShowRank)
{
	if (bAllReceived)
	{
		if(OpenState=='MapVote') SetTimer(0.25f, false, 'DelayedOpenMapvote'); // To prevent no-mouse issue when local server host opens it from chat.
		else if(OpenState=='PlayerStats') SetTimer(0.25f, false, 'DelayedOpenPlayerStats');
		else if(OpenState=='TeamAward') SetTimer(0.25f, false, 'DelayedOpenTeamAward');
	}
	else
	{
		CD_PlayerController(GetPlayer()).ShowConnectionProgressPopup(PMT_AdminMessage, class'CombinedCD2.KFScoreboard'.default.NotReady, PleaseWaitMsg);
	}

	if (bShowRank)
	{
		if (KFGFxHudWrapper(GetPlayer().myHUD)!=None)
			KFGFxHudWrapper(GetPlayer().myHUD).HudMovie.DisplayPriorityMessage("MAP VOTE TIME","Cast your votes!",2);
		
		if (KFGameReplicationInfo(WorldInfo.GRI)!=none)
			KFGameReplicationInfo(WorldInfo.GRI).ProcessChanceDrop();
	}
}

simulated function DelayedOpenMapvote()
{
	OpenPostGameMenu('MapVote');
	MapVoteMsg(MapVoteHelpString);
}

simulated function DelayedOpenPlayerStats()
{
	OpenPostGameMenu('PlayerStats');
}

simulated function DelayedOpenTeamAward()
{
	OpenPostGameMenu('TeamAward');
}

simulated function OpenPostGameMenu(name OpenState)
{
	local CD_PlayerController CDPC;
	local KF2GUIController GUIController;
	local KFGUI_Page Page;
	local xUI_MapVote U;

	CDPC = CD_PlayerController(GetPlayer());
	GUIController = CDPC.GetGUIController();
	Page = GUIController.OpenMenu(CDPC.default.MapVoteMenuClass);

	U = xUI_MapVote(Page);
	U.InitMapvote(Self);
	U.CurState = OpenState;
}

reliable server simulated function ServerCastVote(int GameIndex, int MapIndex, bool bAdminForce)
{
	if (NextVoteTimer<WorldInfo.TimeSeconds)
	{
		NextVoteTimer = WorldInfo.TimeSeconds+1.f;
		VoteHandler.ClientCastVote(Self,GameIndex,MapIndex,bAdminForce);
	}
}

reliable client simulated function ClientTestFunction()
{
	local KFPlayerController KFPC;

	KFPC = KFPlayerController(PlayerOwner);
	if(KFPC == none)
	{
		PlayerOwner.ClientMessage("Not found KFPC!", 'MapVote');
		return;
	}

	LocalPlayer(KFPC.Player).ViewportClient.ViewportConsole.OutputText("****** Test Console Print ******");

	if(KFPC.MyGFxManager != none && KFPC.MyGFxManager.PartyWidget != none)
		KFPC.MyGFxManager.PartyWidget.ReceiveMessage("[PartyWidget]\n* Test Chat Print *", "00DCCE");

	if(KFPC.MyGFxManager != none && KFPC.MyGFxManager.PostGameMenu != none)
		KFPC.MyGFxManager.PostGameMenu.ReceiveMessage("[PostGameMenu]\n* Test Chat Print *", "00DCCE");

	if(KFPC.MyGFxHUD != none && KFPC.MyGFxHUD.HudChatBox != none)
		KFPC.MyGFxHUD.HudChatBox.AddChatMessage("[HudChatBox]\n* Test Chat Print *", "00DCCE");
}

reliable client simulated function ClientModifyAI(KFPawn KFP)
{
	local StaticAttachments NewAttachment;
	local StaticMeshComponent StaticAttachment;
	local MaterialInstanceConstant NewMIC;

	NewAttachment.StaticAttachment = StaticMesh(DynamicLoadObject(XmasHatPath, class'StaticMesh'));
	NewAttachment.AttachSocketName = KFPawn_Monster(KFP).ZEDCowboyHatAttachName;

	StaticAttachment = new (KFP) class'StaticMeshComponent';
	if (StaticAttachment != none)
	{
		KFPawn_Monster(KFP).StaticAttachList.AddItem(StaticAttachment);
		StaticAttachment.SetActorCollision(false, false);
		StaticAttachment.SetStaticMesh(NewAttachment.StaticAttachment);
		StaticAttachment.SetShadowParent(KFP.Mesh);
		StaticAttachment.SetLightingChannels(KFP.PawnLightingChannel);
		NewMIC = StaticAttachment.CreateAndSetMaterialInstanceConstant(0);
		NewMIC.SetVectorParameterValue('color_monochrome', ZC_MonoChromeValue);
		NewMIC.SetVectorParameterValue('Black_White_switcher', ZC_ColorValue);
		KFP.AttachComponent(StaticAttachment);
		KFP.Mesh.AttachComponentToSocket(StaticAttachment, NewAttachment.AttachSocketName);
		KFP.CharacterMICs.AddItem(NewMIC);
	}
}

final function LogToConsole()
{

}

function Destroyed()
{
	VoteHandler.ClientDisconnect(Self);
}

defaultproperties
{
	bAlwaysRelevant=false
	bOnlyRelevantToOwner=true
	CurrentVote(0)=-1
	CurrentVote(1)=-1

	XmasHatPath="CHR_CosmeticSet_XMAS_02_MESH.CHR_Cosmetic_Halloween_Treeyhat"
	ZC_MonoChromeValue = (R=1.0f,G=0.0f,B=0.0f)
	ZC_ColorValue = (R=1.0f,G=0.0f,B=0.0f)
}
