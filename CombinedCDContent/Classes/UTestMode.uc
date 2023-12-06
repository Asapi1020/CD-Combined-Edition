/*******************************************************************************
 * UltimateTestMap 
 *******************************************************************************/
class UTestMode extends CD_Survival
    config(utm)
    hidecategories(Navigation,Movement,Collision);

/* Original */
var config int SettingsIniVer;
var array<Controller> PendingSpawners;
var UTM_GameReplicationInfo MySTMGRI;
var KFPawn LastHitZed;
var int LastHitHP;
var UTM_PlayerController LastDamageDealer;
var Vector LastDamagePosition;
var transient class<DamageType> LastKillDamageType;
var bool bDamageTracking;
var bool bAllowKillZeds;
var config bool bDisableZedTime;
var config int ZedHPFakes;

/* New */
struct SpawnCombo
{
    var PlayerReplicationInfo PRI;
    var string StaticZedName;
    var class<KFPawn> StaticSpawnClass;
    var vector StaticSpawnLoc;
    var rotator StaticSpawnRot;
};

var config bool bHSOnly;
var array<SpawnCombo> AutoSpawnInfo;
var string OldSC;
var int OldMM;
var bool bDisableRespawn;

/** ================================================================
 *   General
 *  ================================================================ **/

event PostBeginPlay()
{
    super.PostBeginPlay();
    MySTMGRI = UTM_GameReplicationInfo(GameReplicationInfo);

    //  Setup Super Variables
    GameStartDelay = 2;
    bEnableGameAnalytics = false;
    bLogScoring = false;
    bLogAIDefaults = false;
    bLogAnalytics = false;
    MaxPlayersAllowed = MaxPlayers;
    
    //  Setup Config
    if(SettingsIniVer != 1)
    {
        if(SettingsIniVer < 1)
        {
            ZedHPFakes = 6;
            bDisableZedTime = false;
            bLargeLess = false;
            bHSOnly = false;
        }

        SettingsIniVer = 1;
    }

    ZedHPFakes = Clamp(ZedHPFakes, 1, 32);
    ScrakeHPFakesInt = ZedHPFakes;
    FleshpoundHPFakesInt = ZedHPFakes;
    QuarterpoundHPFakesInt = ZedHPFakes;
    TrashHPFakesInt = ZedHPFakes;
    ScrakeHPFakes = string(ZedHPFakes);
    FleshpoundHPFakes = string(ZedHPFakes);
    QuarterpoundHPFakes = string(ZedHPFakes);
    TrashHPFakes = string(ZedHPFakes);
    //bTraderDash = false;
    //TraderDash = string(bTraderDash);

    //  Setup GRI Variables
    MySTMGRI.bDisableZedTime = bDisableZedTime;
    MySTMGRI.bSpawnRaged = FleshpoundRageSpawnsBool;
    MySTMGRI.bDisableRobots = bDisableRobots;
    MySTMGRI.bLargeLess = bLargeLess;
    MYSTMGRI.bHSOnly = bHSOnly;
    MySTMGRI.nFakedPlayers = ZedHPFakes;
    RefleshWebInfo();

    bNVBlockDramatic = bDisableZedTime; // an variable called in DramaEvent()
    SaveConfig();
    SetTimer(10800.0, false, 'AutoRefresh');    
}

function ShowPostGameMenu(){ ConsoleCommand("disconnect"); }

function StartMatch()
{
    super(KFGameInfo).StartMatch();
    WaveNum = 0;
    MyKFGRI.RemainingTime = 2;
    GotoState('TraderOpen');
}

function EndOfMatch(bool bVictory){ return; }

function Logout(Controller Exiting)
{
    if(PendingSpawners.Find(Exiting) != -1)
    {
        PendingSpawners.RemoveItem(Exiting);
    }
    super(KFGameInfo).Logout(Exiting);
    
    if((NumPlayers == 0) && NumTravellingPlayers == 0)
    {
        Ext_KillZeds();
    }
}

function AutoRefresh()
{
    if((NumPlayers == 0) && NumTravellingPlayers == 0)
    {
        WorldInfo.ServerTravel(WorldInfo.GetMapName(true));
    }
    
    else
    {
        SetTimer(600.0, false, 'AutoRefresh');
    }    
}

state TraderOpen
{
    function BeginState(name PreviousStateName)
    {
        MySTMGRI.SetWaveActive(false, GetGameIntensityForMusic());
        MySTMGRI.OpenAllTraders();
    }

    function EndState(name NextStateName)
    {
        return;      
    }
    stop;    
}

function bool ShouldRecord()
{
    return false;
}

/** ================================================================
 *   Damage Display
 *  ================================================================ **/

//  Damage tracker
function ReduceDamage(out int Damage, Pawn injured, Controller InstigatedBy, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType, Actor DamageCauser, TraceHitInfo HitInfo)
{
    local int HitZoneIdx;

    if(LastDamageDealer != none)
    {
        ClearTimer('CheckDamageDone');
        CheckDamageDone();
    }
    
    if(Damage > 0)
    {
        if((KFPawn_Monster(injured) != none) && injured.GetTeamNum() != 0)
        {
            if(bHSOnly && ClassIsChildOf(DamageType, class'KFDamageType'))
            {
                HitZoneIdx = KFPawn_Monster(Injured).HitZones.Find('ZoneName', HitInfo.BoneName);
                if (HitZoneIdx != HZI_Head)
                    Damage = 0;
            }

            LastDamageDealer = UTM_PlayerController(InstigatedBy);
            
            if((bDamageTracking && LastDamageDealer != none) && LastDamageDealer.bDamageTracking)
            {
                LastHitZed = KFPawn(injured);
                LastHitHP = LastHitZed.Health;
                LastDamagePosition = HitLocation;
                SetTimer(0.0010, false, 'CheckDamageDone');
            }
            
            else
            {
                LastDamageDealer = none;
            }
        }
    }

    super.ReduceDamage(Damage, injured, InstigatedBy, HitLocation, Momentum, DamageType, DamageCauser, HitInfo);
}

final function CheckDamageDone()
{
    local int Damage;

    if(((LastDamageDealer != none) && LastHitZed != none) && LastHitHP != LastHitZed.Health)
    {
        Damage = LastHitHP - Max(LastHitZed.Health, 0);
        
        if(Damage > 0)
        {
            
            if(LastDamageDealer.bClientShowDamageMsg && KFPawn_Monster(LastHitZed) != none)
            {
                LastDamageDealer.ReceiveDamageMessage(LastHitZed, Damage);
            }
            
            if(LastDamageDealer.bClientShowDamagePopup)
            {
                LastDamageDealer.ReceiveDamagePopup(Damage, LastDamagePosition);
            }
        }
    }
    LastDamageDealer = none;  
}

/** ================================================================
 *   Immediate Respawn
 *  ================================================================ **/

function Killed(Controller Killer, Controller KilledPlayer, Pawn KilledPawn, class<DamageType> DamageType)
{
    local float RespawnDelay;

    RespawnDelay = 3.f;

    super.Killed(Killer, KilledPlayer, KilledPawn, DamageType);
    
    if((KilledPawn != none) && KilledPawn.GetTeamNum() == 255)
    {
        -- MySTMGRI.nMonsters;
    }

    if(super(KFGameInfo).GetLivingPlayerCount() < 1)
    {
        EndCurrentWave();
    }
    
    if(KFPlayerController(KilledPlayer) != none && MyKFGRI.bTraderIsOpen)
    {
        KilledPlayer.PlayerReplicationInfo.bForceNetUpdate = true;
        // End:0x109
        if(PendingSpawners.Find(KilledPlayer) < 0)
        {
            PendingSpawners.AddItem(KilledPlayer);
        }
        SetTimer(RespawnDelay, false, 'RespawnPlayers');
    }   
}

function CheckWaveEnd( optional bool bForceWaveEnd = false )
{
    if(super(KFGameInfo).GetLivingPlayerCount() < 1)
        WaveEnded(WEC_WaveWon);

    else
        super.CheckWaveEnd(bForceWaveEnd);
}

function RespawnPlayers()
{
    local int I;
    local Controller PC;
    local bool bSpawned;

    if(bDisableRespawn)
        return;

    I = 0;
    J0x0B:
    
    if(I < PendingSpawners.Length)
    {
        PC = PendingSpawners[I];
        PC.PlayerReplicationInfo.bForceNetUpdate = true;
        
        if(!bSpawned)
        {
            bSpawned = true;
            bRestartLevel = false;
            RestartPlayer(PC);
            PC.PlayerReplicationInfo.bForceNetUpdate = true;
            PendingSpawners.Remove(I, 1);
        }
        ++ I;
        
        goto J0x0B;
    }
}

/** ================================================================
 *   Start with Dosh
 *  ================================================================ **/

function RestartPlayer(Controller NewPlayer)
{
    super.RestartPlayer(NewPlayer);
    
    if(NewPlayer.PlayerReplicationInfo != none)
    {
        NewPlayer.PlayerReplicationInfo.Score = 999999.0;
    }   
}

/** ================================================================
 *   Chat Command
 *  ================================================================ **/

event Broadcast(Actor Sender, coerce string Msg, optional name Type)
{
    local string MsgHead,MsgBody/*,MsgHip*/;
    local array<String> splitbuf;

    super.Broadcast(Sender, Msg, Type);

    if ( Type == 'Say' )
    {
        Msg = Locs(Msg);
        ParseStringIntoArray(Msg,splitbuf," ",true);
        MsgHead = splitbuf[0];
        MsgBody = splitbuf[1];

        if(Msg == "!ot" || Msg == "!cdot")
        {
            KFPlayerController(Sender).OpenTraderMenu();
        }

        else if (MsgHead == "!cdsw")
        {
            if(MsgBody != "")
                SetWave(byte(MsgBody));
        }

        else if (Msg == "!cdecw")
            EndCurrentWave();

        else if (Msg == "!cdrp")
            RestartPlayer(PlayerController(Sender));
    }
}

//  Skip to check Disable Zedtime
function ForceDramaEvent(optional float Duration=3.f)
{
    local KFPlayerController KFPC;

    ZedTimeRemaining = Duration;
    bZedTimeBlendingOut = false;

    SetZedTimeDilation(ZedTimeSlomoScale);

    foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC)
    {
        if (KFPC != none)
        {
            KFPC.EnterZedTime();
        }
    }
}

/** ================================================================
 *   Zed
 *  ================================================================ **/

function KFPawn LocatedSpawn(string ZedName, class<KFPawn> SpawnClass, vector SpawnLoc, rotator SpawnRot, optional KFPlayerController KFPC, optional bool AvoidOverride)
{
    local int i;

    if(UTM_PlayerReplicationInfo(KFPC.PlayerReplicationInfo).bAutoSpawn)
    {
        i = AutoSpawnInfo.Find('PRI', KFPC.PlayerReplicationInfo);

        if(i == INDEX_NONE)
        {
            i = AutoSpawnInfo.length;
            AutoSpawnInfo.Add(1);
            AutoSpawnInfo[i].PRI = KFPC.PlayerReplicationInfo;
        }
        
        if(!AvoidOverride)
        {
            AutoSpawnInfo[i].StaticZedName = ZedName;
            AutoSpawnInfo[i].StaticSpawnClass = SpawnClass;
            AutoSpawnInfo[i].StaticSpawnLoc = SpawnLoc;
            AutoSpawnInfo[i].StaticSpawnRot = SpawnRot;
        }

        else
        {
            ZedName = AutoSpawnInfo[i].StaticZedName;
            SpawnClass = AutoSpawnInfo[i].StaticSpawnClass;
            SpawnLoc = AutoSpawnInfo[i].StaticSpawnLoc;
            SpawnRot = AutoSpawnInfo[i].StaticSpawnRot;
        }
    }

    return super.LocatedSpawn(ZedName, SpawnClass, SpawnLoc, SpawnRot, KFPC);
}

function BeginTrashChallenge()
{
    MySTMGRI.bTrashChallenge = true;
    OldMM = MaxMonstersInt;

    SetParams(none, "!cdsc basic_heavy");
    SetParams(none, "!cdmm 20");
    SpawnManager.bTemporarilyEndless = true;
    MyKFGRI.bWaveIsEndless = true;

    SetWave(10);

    SetTimer(30.f, false, 'MaintainTrashChallenge');
}

function MaintainTrashChallenge()
{
    if(MaxMonstersInt < 32)
        MaxMonstersInt += 2;
    else
        MaxMonstersInt += 4;
    
    MaxMonsters = string(MaxMonstersInt);
    RefleshWebInfo();

    if(MaxMonstersInt < 32)
        SetTimer(30.f, false, 'MaintainTrashChallenge');
    else
        SetTimer(40.f, false, 'MaintainTrashChallenge');
}

/** ================================================================
 *   Exec
 *  ================================================================ **/

exec function WinMatch()
{
    super(KFGameInfo_Survival).WaveEnded(WEC_WaveWon);
}

exec function EndCurrentWave()
{
    super.EndCurrentWave();
    MyKFGRI.RemainingTime = 2;

    if(MySTMGRI.bTrashChallenge)
    {
        ClearTimer('MaintainTrashChallenge');
        SetParams(none, "!cdmm" @ string(OldMM));
        MySTMGRI.bTrashChallenge = false;
        SpawnManager.bTemporarilyEndless = false;
        MyKFGRI.bWaveIsEndless = false;
    }
}

exec function DisableRespawn(bool bDisable)
{
    bDisableRespawn = bDisable;
}

function RefleshWebInfo()
{
    MySTMGRI.CDInfoParams.SC = SpawnCycle;
    MySTMGRI.CDInfoParams.MM = MaxMonsters;
    MySTMGRI.CDInfoParams.CS = CohortSize;
    MySTMGRI.CDInfoParams.SP = SpawnPoll;
    MySTMGRI.CDInfoParams.WSF = WaveSizeFakes;
    MySTMGRI.CDInfoParams.SM = SpawnMod;
    MySTMGRI.CDInfoParams.THPF = TrashHPFakes;
    MySTMGRI.CDInfoParams.QPHPF = QuarterPoundHPFakes;
    MySTMGRI.CDInfoParams.FPHPF = FleshpoundHPFakes;
    MySTMGRI.CDInfoParams.SCHPF = ScrakeHPFakes;
}

function SetParams(CD_PlayerController CDPC, string S)
{
    ChatCommander.RunCDChatCommandIfAuthorized(CDPC, S);
    SaveConfig();
    RefleshWebInfo();
}

function ModTraderDash(bool bDash){ return; }

defaultproperties
{
    MaxPlayersAllowed=128

    KFGFxManagerClass=class'UTM_GFxMoviePlayer_Manager'
    DefaultPawnClass=class'UTM_Pawn_Human'
    PlayerControllerClass=class'UTM_PlayerController'
    PlayerReplicationInfoClass=class'UTM_PlayerReplicationInfo'
    GameReplicationInfoClass=class'UTM_GameReplicationInfo'
    HUDType=class'UTM_GFxHudWrapper'

    bDamageTracking = true
    bAllowKillZeds = true;
    bIsUTM = true;

    CDGameModes.Add((FriendlyName="UTestMode",ClassNameAndPath="CombinedCDContent.UTestMode",bSoloPlaySupported=True,DifficultyLevels=4,Lengths=4,LocalizeID=0))

        GameInfoClassAliases.Add((ShortName="UTestMode", GameClassName="CombinedCDContent.UTestMode"))
}