Class xVotingHandler extends Mutator
	config( CombinedCD )
	dependson(xStructHolder);

`include(CD_Log.uci)

/* Original */

struct FGameModeOption
{
	var config string GameName,GameShortName,GameClass,Mutators,Options,ServerName;
};
var config array<FGameModeOption> GameModes;
var config int INIVersion;
var config int LastVotedGameInfo;
var config int VoteTime;
var config float MidGameVotePct;
var config float MapWinPct;
var config float MapChangeDelay;

var class<Mutator> BaseMutator;
var array<xStructHolder.FMapEntry> Maps;
var array<xStructHolder.FVotedMaps> ActiveVotes;
var array<xVotingReplication> ActiveVoters;
var KFGameReplicationInfo KF;
var int VoteTimeLeft;
var int ShowMenuDelay;
var string PendingMapURL;
var bool bMapvoteHasEnded;
var bool bMapVoteTimer;
var bool bHistorySaved;

/* Unique */

struct CustomStart
{
	var string MapName;
	var array<int> NodeIndex;
};

var config bool DisableCustomStarts;
var config array<CustomStart> CustomStarts;

var CD_Survival CD;
var int StartCycle;
var bool bBossDefeat;

/* ==============================================================================================================================
 *	Set up
 * ============================================================================================================================== */

function PostBeginPlay()
{
	local int i,j,z;

	//	Set up BaseMutator
	if (WorldInfo.Game.BaseMutator==None)
		WorldInfo.Game.BaseMutator = Self;

	else
		WorldInfo.Game.BaseMutator.AddMutator(Self);
	
	// This was a duplicate instance of the mutator.
	if (bDeleteMe)
		return;

	//	Setup Config value
	SetupConfig();

	// Build maplist.
	z = 0;
	for (i=0; i<Class'KFGameInfo'.Default.GameMapCycles.Length; i++)
	{
		for (j=0; j<Class'KFGameInfo'.Default.GameMapCycles[i].Maps.Length; j++)
		{
			Maps.Length = z+1;
			Maps[z].MapName = Class'KFGameInfo'.Default.GameMapCycles[i].Maps[j];
			++z;
		}
	}

	SetTimer(0.15,false,'SetupBroadcast');
	SetTimer(1,true,'CheckEndGameEnded');
}

function AddMutator(Mutator M)
{
	if (M!=Self) // Make sure we don't get added twice.
	{
		if (M.Class==Class)
			M.Destroy();
		else Super.AddMutator(M);
	}
}

function SetupConfig()
{
	local bool ConfigChanged;
	
	ConfigChanged = False;

	//	Avoid invalid variables
	if (LastVotedGameInfo<0 || LastVotedGameInfo>=GameModes.Length)
		LastVotedGameInfo = 0;
	
	if (MapChangeDelay==0)
		MapChangeDelay = 4;

	// None specified, so use current settings.
	if (GameModes.Length==0)
	{
		GameModes.Length = 1;
		GameModes[0].GameName = "Killing Floor";
		GameModes[0].GameShortName = "KF";
		GameModes[0].GameClass = PathName(WorldInfo.Game.Class);
		GameModes[0].Mutators = "";
		GameModes[0].ServerName = "";
		ConfigChanged = True;
	}

	//	Control ini version
	if(INIVersion < 1)
	{	
		MidGameVotePct = 0.5f;
		MapWinPct = 0.5f;
		VoteTime = 90;
		GameModes.Length = 4;

		GameModes[0].GameName = "CD Long";
		GameModes[0].GameShortName = "CD Long";
		GameModes[0].GameClass = "CombinedCD2.CD_Survival";
		GameModes[0].Mutators = "FriendlyHUD.FriendlyHUDMutator";
		GameModes[0].Options = "Difficulty=3?GameLength=2";
		GameModes[0].ServerName = "CD Long";

		GameModes[1].GameName = "CD Medium";
		GameModes[1].GameShortName = "CD Medium";
		GameModes[1].GameClass = "CombinedCD2.CD_Survival";
		GameModes[1].Mutators = "FriendlyHUD.FriendlyHUDMutator";
		GameModes[1].Options = "Difficulty=3?GameLength=1";
		GameModes[1].ServerName = "CD Medium";

		GameModes[2].GameName = "CD Short";
		GameModes[2].GameShortName = "CD Short";
		GameModes[2].GameClass = "CombinedCD2.CD_Survival";
		GameModes[2].Mutators = "FriendlyHUD.FriendlyHUDMutator";
		GameModes[2].Options = "Difficulty=3?GameLength=0";
		GameModes[2].ServerName = "CD Short";

		GameModes[3].GameName = "UTM";
		GameModes[3].GameShortName = "U Test Mode";
		GameModes[3].GameClass = "CombinedCDContent.UTestMode";
		GameModes[3].Mutators = "FriendlyHUD.FriendlyHUDMutator";
		GameModes[3].Options = "Difficulty=3?GameLength=2";
		GameModes[3].ServerName = "UTM";

		INIVersion = 1;
		ConfigChanged = True;
	}
	
	if (ConfigChanged)
		SaveConfig();
}

function SetupBroadcast()
{
	local xVoteBroadcast B;

	B = Spawn(class'xVoteBroadcast');
	B.Handler = Self;
	B.NextBroadcaster = WorldInfo.Game.BroadcastHandler;
	WorldInfo.Game.BroadcastHandler = B;

	SetupWebApp();
}

function SetupWebApp()
{
	local xVoteWebApp xW;
	local WebServer W;
	local WebAdmin A;
	local byte i;

	foreach AllActors(class'WebServer',W)
		break;

	if (W!=None)
	{
		for (i=0; (i<10 && A==None); ++i)
			A = WebAdmin(W.ApplicationObjects[i]);

		if (A!=None)
		{
			xW = new (None) class'xVoteWebApp';
			A.addQueryHandler(xW);
			xW.xVH = Self;
		}
		else `Log("X-VoteWebAdmin ERROR: No valid WebAdmin application found!");
	}
	else `Log("X-VoteWebAdmin ERROR: No WebServer object found!");		
}

/* ==============================================================================================================================
 *	Vote System
 * ============================================================================================================================== */

final function AddVote(int Count, int MapIndex, int GameIndex)
{
	local int i,j;

	if (bMapvoteHasEnded)
		return;

	for (i=0; i<ActiveVotes.Length; ++i)
	{
		if (ActiveVotes[i].GameIndex==GameIndex && ActiveVotes[i].MapIndex==MapIndex)
		{
			ActiveVotes[i].NumVotes += Count;

			for (j=(ActiveVoters.Length-1); j>=0; --j)
				ActiveVoters[j].ClientReceiveVote(GameIndex,MapIndex,ActiveVotes[i].NumVotes);

			if (ActiveVotes[i].NumVotes<=0)
			{
				for (j=(ActiveVoters.Length-1); j>=0; --j)
				{
					if (ActiveVoters[j].DownloadStage==2 && ActiveVoters[j].DownloadIndex>=i && ActiveVoters[j].DownloadIndex>0) // Make sure client doesn't skip a download at this point.
						--ActiveVoters[j].DownloadIndex;
				}

				ActiveVotes.Remove(i,1);
			}
			return;
		}
	}

	if (Count<=0)
		return;

	ActiveVotes.Length = i+1;
	ActiveVotes[i].GameIndex = GameIndex;
	ActiveVotes[i].MapIndex = MapIndex;
	ActiveVotes[i].NumVotes = Count;

	for (j=(ActiveVoters.Length-1); j>=0; --j)
		ActiveVoters[j].ClientReceiveVote(GameIndex,MapIndex,Count);
}

final function LogoutPlayer(PlayerController PC)
{
	local int i;
	
	for (i=(ActiveVoters.Length-1); i>=0; --i)
	{
		if (ActiveVoters[i].PlayerOwner==PC)
		{
			ActiveVoters[i].Destroy();
			break;
		}
	}
}

final function LoginPlayer(PlayerController PC)
{
	local xVotingReplication R;
	local int i;
	
	for (i=(ActiveVoters.Length-1); i>=0; --i)
	{
		if (ActiveVoters[i].PlayerOwner==PC)
			return;
	}

	R = Spawn(class'xVotingReplication',PC);
	R.VoteHandler = Self;
	ActiveVoters.AddItem(R);
}

function NotifyLogout(Controller Exiting)
{
	if (PlayerController(Exiting)!=None)
		LogoutPlayer(PlayerController(Exiting));
	if (NextMutator != None)
		NextMutator.NotifyLogout(Exiting);
}

function NotifyLogin(Controller NewPlayer)
{
	if (PlayerController(NewPlayer)!=None)
		LoginPlayer(PlayerController(NewPlayer));
	if (NextMutator != None)
		NextMutator.NotifyLogin(NewPlayer);
}

function ClientDownloadInfo(xVotingReplication V)
{
	if (bMapvoteHasEnded)
	{
		V.DownloadStage = 255;
		return;
	}
	
	switch (V.DownloadStage)
	{
		case 0: // Game modes.
			if (V.DownloadIndex>=GameModes.Length)
				break;
			V.ClientReceiveGame(V.DownloadIndex,GameModes[V.DownloadIndex].GameName,GameModes[V.DownloadIndex].GameShortName);
			++V.DownloadIndex;
			return;

		case 1: // Maplist.
			if (V.DownloadIndex>=Maps.Length)
				break;
			if (Maps[V.DownloadIndex].MapTitle=="")
				V.ClientReceiveMap(V.DownloadIndex,Maps[V.DownloadIndex].MapName,Maps[V.DownloadIndex].UpVotes,Maps[V.DownloadIndex].DownVotes,Maps[V.DownloadIndex].Sequence,Maps[V.DownloadIndex].NumPlays);
			else V.ClientReceiveMap(V.DownloadIndex,Maps[V.DownloadIndex].MapName,Maps[V.DownloadIndex].UpVotes,Maps[V.DownloadIndex].DownVotes,Maps[V.DownloadIndex].Sequence,Maps[V.DownloadIndex].NumPlays,Maps[V.DownloadIndex].MapTitle);
			++V.DownloadIndex;
			return;

		case 2: // Current votes.
			if (V.DownloadIndex>=ActiveVotes.Length)
				break;
			V.ClientReceiveVote(ActiveVotes[V.DownloadIndex].GameIndex,ActiveVotes[V.DownloadIndex].MapIndex,ActiveVotes[V.DownloadIndex].NumVotes);
			++V.DownloadIndex;
			return;

		default:
			V.ClientReady(LastVotedGameInfo);
			V.DownloadStage = 255;
			return;
	}
	++V.DownloadStage;
	V.DownloadIndex = 0;
}

function ClientCastVote(xVotingReplication V, int GameIndex, int MapIndex, bool bAdminForce)
{
	local int i;

	if (bMapvoteHasEnded)
		return;

	if (bAdminForce && (V.PlayerOwner.PlayerReplicationInfo.bAdmin))
	{
		SwitchToLevel(GameIndex,MapIndex,true);
		return;
	}
	if (V.CurrentVote[0]>=0)
		AddVote(-1,V.CurrentVote[1],V.CurrentVote[0]);
	V.CurrentVote[0] = GameIndex;
	V.CurrentVote[1] = MapIndex;
	AddVote(1,MapIndex,GameIndex);
	for (i=(ActiveVoters.Length-1); i>=0; --i)
		ActiveVoters[i].ClientNotifyVote(V.PlayerOwner.PlayerReplicationInfo,GameIndex,MapIndex);
	TallyVotes();
}

function ClientDisconnect(xVotingReplication V)
{
	ActiveVoters.RemoveItem(V);
	if (V.CurrentVote[0]>=0)
		AddVote(-1,V.CurrentVote[1],V.CurrentVote[0]);
	TallyVotes();
}

final function float GetPctOf(int Nom, int Denom)
{
	local float R;
	
	R = float(Nom) / float(Denom);
	return R;
}

final function TallyVotes(optional bool bForce)
{
	local int i,NumVotees,c;
	local array<int> Candidates;

	if (bMapvoteHasEnded)
		return;

	NumVotees = ActiveVoters.Length;
	c = 0;

	if (bForce)
	{
		// First check for highest result.
		for (i=(ActiveVotes.Length-1); i>=0; --i)
			c = Max(c,ActiveVotes[i].NumVotes);
		
		if (c>0)
		{
			// Then check how many votes for the best.
			for (i=(ActiveVotes.Length-1); i>=0; --i)
				if (ActiveVotes[i].NumVotes==c)
					Candidates.AddItem(i);
			
			// Finally pick a random winner from the best.
			c = Candidates[Rand(Candidates.Length)];
			
			SwitchToLevel(ActiveVotes[c].GameIndex,ActiveVotes[c].MapIndex,false);
		}
		else
		{
			// Pick a random map to win.
			c = Rand(Maps.Length);			
			i = LastVotedGameInfo;

			SwitchToLevel(i,c,false);
		}
		return;
	}

	// Check for insta-win vote.
	for (i=(ActiveVotes.Length-1); i>=0; --i)
	{
		c+=ActiveVotes[i].NumVotes;
		if (GetPctOf(ActiveVotes[i].NumVotes,NumVotees)>=MapWinPct)
		{
			SwitchToLevel(ActiveVotes[i].GameIndex,ActiveVotes[i].MapIndex,false);
			return;
		}
	}
	
	// Check for mid-game voting timer.
	if (!bMapVoteTimer && NumVotees>0 && GetPctOf(c,NumVotees)>=MidGameVotePct)
		StartMidGameVote(true);
}

final function StartMidGameVote(bool bMidGame)
{
	local int i;

	if (bMapVoteTimer || bMapvoteHasEnded)
		return;
	bMapVoteTimer = true;
	if (bMidGame)
	{
		for (i=(ActiveVoters.Length-1); i>=0; --i)
			ActiveVoters[i].ClientNotifyVoteTime(0);
	}
	ShowMenuDelay = 5;
	VoteTimeLeft = Max(VoteTime,10);
	SetTimer(1,true);
}

function CheckEndGameEnded()
{
	if (KF==None)
	{
		KF = KFGameReplicationInfo(WorldInfo.GRI);
		if (KF==None)
			return;
	}

	if (KF.bMatchIsOver) // HACK, since KFGameInfo_Survival doesn't properly notify mutators of this!
	{	
		if (!bMapVoteTimer)
			StartMidGameVote(false);
		ClearTimer('CheckEndGameEnded');
	}
}

function bool HandleRestartGame()
{
	if (!bMapVoteTimer)
		StartMidGameVote(false);
	return true;
}

function Timer()
{
	local int i;

	if (bMapvoteHasEnded)
	{
		// NOTE:
		// "WorldInfo.NetMode != NM_Standalone" prevents cyclic unsuccessful map change in single player mode.
		// I have not tested how this code will behave if it really fails to change the map.
		// Most likely there should be another solution here, but for now it will do.
		if (WorldInfo.NetMode != NM_Standalone && WorldInfo.NextSwitchCountdown<=0.f) // Mapswitch failed, force to random other map.
		{
			ActiveVotes.Length = 0;
			bMapvoteHasEnded = false;
			TallyVotes(true);
		}
		return;
	}
	if (ShowMenuDelay>0 && --ShowMenuDelay==0 && bBossDefeat)
	{
		SetTimer(3.f, false, 'CheckBossMovie');
	}
	--VoteTimeLeft;
	if (VoteTimeLeft==0)
	{
		TallyVotes(true);
	}
	if (VoteTimeLeft >= 0)
	{
		for (i=(ActiveVoters.Length-1); i>=0; --i)
		{
			CD_PlayerController(ActiveVoters[i].PlayerOwner).ReceiveVoteLeftTime(VoteTimeLeft);
		}
	}
}

function CheckBossMovie()
{
	local KFPlayerController KFPC;

	foreach WorldInfo.AllControllers( class'KFPlayerController', KFPC )
	{
		KFPC.SetCinematicMode( false, false, true, true, true, false );
	}	
}

final function SwitchToLevel(int GameIndex, int MapIndex, bool bAdminForce)
{
	local int i;
	local string S;

	if (bMapvoteHasEnded)
		return;
	
	Default.LastVotedGameInfo = GameIndex;
	Class.Static.StaticSaveConfig();
	bMapvoteHasEnded = true;
	
	S = Maps[MapIndex].MapName$" ("$GameModes[GameIndex].GameName$")";
	for (i=(ActiveVoters.Length-1); i>=0; --i)
	{
		CD_PlayerController(ActiveVoters[i].PlayerOwner).ShowLocalizedPopup("<local>xVotingHandler.SwitchLevelString</local>", S);
		ActiveVoters[i].ClientNotifyVoteWin(GameIndex,MapIndex,bAdminForce);
	}
	
	PendingMapURL = Maps[MapIndex].MapName$"?Game="$GameModes[GameIndex].GameClass$"?Mutator="$PathName(BaseMutator);
	if (GameModes[GameIndex].Mutators!="")
		PendingMapURL $= ","$GameModes[GameIndex].Mutators;
	if (GameModes[GameIndex].Options!="")
		PendingMapURL $= "?"$GameModes[GameIndex].Options;
	`Log("MapVote: Switch map to "$PendingMapURL);
	if (GameModes[GameIndex].ServerName != "")
	{
		WorldInfo.GRI.ServerName = GameModes[GameIndex].ServerName;
		WorldInfo.GRI.SaveConfig();
		`Log("MapVote: Next ServerName: "$WorldInfo.GRI.ServerName);
	}
	SetTimer(FMax(MapChangeDelay,0.1),false,'PendingSwitch');
}

function Pendingswitch()
{
	WorldInfo.ServerTravel(PendingMapURL,false);
	SetTimer(1,true);
}

/* ==============================================================================================================================
 *	Chat Command & Broadcast System
 * ============================================================================================================================== */

final function ParseCommand(string Cmd, PlayerController PC)
{
	if (Cmd~="xra")
		CC_ReceiveAmmo(PC, true);
	else if (Cmd~="xrg")
		CC_ReceiveAmmo(PC, false);
	else if (Cmd ~= "xnuke")
		xNukeGrenade(PC);
	else if (Cmd~="Test")
		Testfuntion(PC);
	else if (!PC.PlayerReplicationInfo.bAdmin && !PC.IsA('MessagingSpectator'))
		return;
	else if (Left(Cmd, 4)~="xdcs")
	{
		Cmd = Mid(Cmd, 4);
		if(Cmd != "")
		{
			DisableCustomStarts = bool(Cmd);
			SaveConfig();
		}
		MsgToAll("<local>CD_Survival.AdminPrefix</local> DisableCustomStarts=" $ string(DisableCustomStarts), true);
	}
	else if (Left(Cmd,7)~="AddMap ")
	{
		Cmd = Mid(Cmd,7);
		PC.ClientMessage("Added map '"$Cmd$"'!");
		AddMap(Cmd);
	}
	else if (Left(Cmd,10)~="RemoveMap ")
	{
		Cmd = Mid(Cmd,10);
		if (RemoveMap(Cmd))
			PC.ClientMessage("Removed map '"$Cmd$"'!");
		else PC.ClientMessage("Map '"$Cmd$"' not found!");
	}
}

function xNukeGrenade(PlayerController PC)
{
    local vector StartTrace, TraceDir;
    local KFProj_Grenade    SpawnedGrenade;
    local class<KFProj_Grenade> GrenadeClass;
    local KFGameReplicationInfo KFGRI;

    KFGRI = KFGameReplicationInfo(WorldInfo.GRI);

    if(KFGRI != none && !(KFGRI.bTraderIsOpen)) return;

    GrenadeClass = class<KFProj_Grenade>(DynamicLoadObject("KFGameContent.KFProj_DynamiteGrenade", class'Class'));

    // Leave a splat on level geometry along the direction being shot at
    StartTrace = PC.Pawn.Location;
    TraceDir = vector(PC.Pawn.Weapon.GetAdjustedAim(StartTrace));

    // Spawn Grenade
    SpawnedGrenade = PC.Pawn.Weapon.Spawn( GrenadeClass, PC.Pawn.Weapon );
    if( SpawnedGrenade != none && !SpawnedGrenade.bDeleteMe )
    {
        SpawnedGrenade.ExplosionTemplate = class'KFPerk_Demolitionist'.static.GetNukeExplosionTemplate();
        SpawnedGrenade.ExplosionActorClass = class'KFPerk_Demolitionist'.static.GetNukeExplosionActorClass();
        SpawnedGrenade.Init( TraceDir );
    }
}

function Testfuntion(PlayerController PC)
{
	local int i;

	for (i=(ActiveVoters.Length-1); i>=0; --i)
	{
		if (ActiveVoters[i].PlayerOwner==PC)
		{
			ActiveVoters[i].ClientTestFunction();
			return;
		}
	}
}

function ShowMapVote(name OpenState, PlayerController PC)
{
	local int i;

	if (bMapvoteHasEnded)
		return;

	for (i=(ActiveVoters.Length-1); i>=0; --i)
	{
		if (ActiveVoters[i].PlayerOwner==PC)
		{
			ActiveVoters[i].ClientOpenMapvote(OpenState, false);
			`Log("Player Owner Found");
			return;
		}
	}
	`Log("Owner Not Found");
}

function MsgToAll(string S, optional bool bLocalize)
{
	local CD_PlayerController CDPC;
	foreach WorldInfo.AllControllers(class'CD_PlayerController', CDPC)
	{
		if(bLocalize)
		{
			CDPC.LocalizedClientMessage(S, 'MapVote');
		}
		else
		{
			CDPC.ClientMessage(S, 'MapVote');
		}
	}
}

final function AddMap(string M)
{
	if (Class'KFGameInfo'.Default.GameMapCycles.Length==0)
		Class'KFGameInfo'.Default.GameMapCycles.Length = 1;
	Class'KFGameInfo'.Default.GameMapCycles[0].Maps.AddItem(M);
	Class'KFGameInfo'.Static.StaticSaveConfig();
}

final function bool RemoveMap(string M)
{
	local int i,j;

	for (i=(Class'KFGameInfo'.Default.GameMapCycles.Length-1); i>=0; --i)
	{
		for (j=(Class'KFGameInfo'.Default.GameMapCycles[i].Maps.Length-1); j>=0; --j)
		{
			if (Class'KFGameInfo'.Default.GameMapCycles[i].Maps[j]~=M)
			{
				Class'KFGameInfo'.Default.GameMapCycles[i].Maps.Remove(j,1);
				Class'KFGameInfo'.Static.StaticSaveConfig();
				return true;
			}
		}
	}
	return false;
}

//	Remote receiving ammo or grenade
function CC_ReceiveAmmo(PlayerController Sender, bool bAmmo)
{
	local KFPlayerController KFPC, EPC;
	local KFPawn_Human KFPH;
	local class<KFPerk> PerkClass;

	PerkClass = (bAmmo) ? class'KFPerk_Support' : class'KFPerk_Demolitionist';

	KFPC = KFPlayerController(Sender);

	if(KFPC != none && KFPC.Pawn.IsAliveAndWell())
	{
		KFPH = KFPawn_Human(KFPC.Pawn);

		if(KFPH != none)
		{
			foreach WorldInfo.AllControllers(class'KFPlayerController', EPC)
			{
				if( EPC != KFPC && EPC.GetPerk().GetPerkClass() == PerkClass )
				{
					EPC.GetPerk().Interact(KFPH);
				}
			}
		}
	}
}

/* ==============================================================================================================================
 *	Overridden functions
 * ============================================================================================================================== */

//	Change player starts
function NavigationPoint FindPlayerStart(Controller Player, optional byte InTeam, optional string incomingName)
{
	local int i;
	local KFPathnode N;
	local array<string> splitbuf;

	if(DisableCustomStarts) return super.FindPlayerStart(Player, InTeam, incomingName);

	for(i=0; i<CustomStarts.length; i++)
	{
		if(CustomStarts[i].MapName ~= WorldInfo.GetMapName( true ))
		{
			ForEach AllActors( class 'KFPathnode', N )
			{
				ParseStringIntoArray(string(N), splitbuf, "_", true);

				if(int(splitbuf[1]) == CustomStarts[i].NodeIndex[StartCycle])
				{
					StartCycle += 1;
					StartCycle = StartCycle % CustomStarts[i].NodeIndex.length;
					return N;
				}
			}
		}
	}

	return super.FindPlayerStart(Player, InTeam, incomingName);
}

function AddPlayerStart(int index, PlayerController PC)
{
	local int i, j;
	local string s;

	i = CustomStarts.Find('MapName', WorldInfo.GetMapName( true ));

	if(i != INDEX_NONE)
	{
		CustomStarts[i].NodeIndex.AddItem(index);
	}
	else
	{
		i = CustomStarts.length;
		CustomStarts.Add(1);
		CustomStarts[i].MapName = WorldInfo.GetMapName( true );
		CustomStarts[i].NodeIndex.AddItem(index);
	}

	s = "KFPathnode_" $ string(index) $ "<local>xVotingHandler.AddedString</local>" $ "\n";
	s $= CustomStarts[i].MapName $": ";
	for(j=0; j<CustomStarts[i].NodeIndex.length; j++)
	{
		s $= string(CustomStarts[i].NodeIndex[j]) $ ", ";
	}

	SaveConfig();
	CD_PlayerController(PC).LocalizedClientMessage(s);
}

function RemovePlayerStart(int index, PlayerController PC)
{
	local int i, j;
	local string s;

	i = CustomStarts.Find('MapName', WorldInfo.GetMapName( true ));
	s = "KFPathnode_" $ string(index);

	if(i != INDEX_NONE)
	{
		CustomStarts[i].NodeIndex.RemoveItem(index);
		SaveConfig();
		
		s $= "<local>xVotingHandler.DeletedString</local>\n";
		s $= CustomStarts[i].MapName $": ";
		for(j=0; j<CustomStarts[i].NodeIndex.length; j++)
		{
			s $= string(CustomStarts[i].NodeIndex[j]) $ ", ";
		}
		CD_PlayerController(PC).LocalizedClientMessage(s);
	}
	else
	{
		CD_PlayerController(PC).LocalizedClientMessage("<local>xVotingHandler.NoCustomStartsString</local>", 'UMEcho');
	}
}

function ClearPlayerStart(PlayerController PC)
{
	local int i;

	i = CustomStarts.Find('MapName', WorldInfo.GetMapName( true ));

	if(i != INDEX_NONE)
	{
		CustomStarts[i].NodeIndex.Remove(0, CustomStarts[i].NodeIndex.length);
		SaveConfig();
		CD_PlayerController(PC).LocalizedClientMessage("<local>xVotingHandler.ClearCustomStartsString</local>");
	}
	else
	{
		CD_PlayerController(PC).LocalizedClientMessage("<local>xVotingHandler.NoCustomStartsString</local>", 'UMEcho');
	}
}

function CheckPlayerStart(CD_PlayerController CDPC)
{
	local string s;
	local int i, j;

	s = "";
	for(i=0; i<CustomStarts.length; i++)
	{
		s $= CustomStarts[i].MapName $ ": ";
		for(j=0; j<CustomStarts[i].NodeIndex.length; j++)
		{
			s $= string(CustomStarts[i].NodeIndex[j]) $ ", ";
		}
		s $= "\n";
	}

	CDPC.PrintConsole(s);
}

public function string GetPlayerStartForCurMap()
{
	local int CustomStartsIndex, PathNodeIndex;
	local string JoinedPathNodesIndexString;

	CustomStartsIndex = CustomStarts.Find('MapName', WorldInfo.GetMapName( true ));
	if(CustomStartsIndex == INDEX_NONE)
	{
		return "";
	}

	JoinedPathNodesIndexString = "";
	foreach CustomStarts[CustomStartsIndex].NodeIndex(PathNodeIndex)
	{
		JoinedPathNodesIndexString $= "," $ string(PathNodeIndex);
	}

	return JoinedPathNodesIndexString;
}

defaultproperties
{
	BaseMutator=Class'xVotingHandler'
}
