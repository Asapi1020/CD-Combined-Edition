class UTM_PlayerController extends CD_PlayerController
    config(utm)
    hidecategories(Navigation);

/* Original */
var config bool bShowDamageMsg;
var config bool bShowDamagePopup;
var config bool bShowZedHealth;
var config bool bAutoSpawn;
var bool bClientShowDamageMsg;
var bool bClientShowDamagePopup;
var bool bDamageTracking;
var int FakedPlayerNum;
var string ReplacedZedName;
var config float ForceSpawnRate;

/* New */
var config bool bAutoFillMag;
var config bool bAutoFillNade;
var config bool bShowAcc;
var config bool bSpawnBrainDead;
var config bool bImGod;
var config bool bImDemiGod;
var config bool bUltraSyringe;
var config bool bShowCollectibles;
var config int SCNum;
var config int FPNum;
var config int SpawnDistance;
var vector LargeLoc;
var rotator LargeRot;
var int LargeWaveNum;
var bool bCheckingWeapSkin;

reliable server function OpenTraderMenuFromSTMOptions(){ OpenTraderMenu(true); }


reliable client simulated function ClientSetHUD(class<HUD> newHUDType)
{
    super.ClientSetHUD(newHUDType);
    SaveSTMSettings(); 
}

reliable server function SpawnSTMZed(string ZedName, KFPathnode SpawnNode, optional bool bBrainDead)
{
    local UTestMode UTM;

    UTM = UTestMode(WorldInfo.Game); 

    if(ZedName ~= "Both")
    {
        SpawnMultiLarges(bBrainDead);
        return;
    }

    if(ZedName ~= "Large")
    {
        StartLargeChallenge();
        return;
    }

    if((ZedName ~= "qp" || ZedName ~= "fp") && UTM.MySTMGRI.bSpawnRaged)
        ZedName $= "!";

    if(bBrainDead)
        UTM.CD_SpawnZed(ZedName, self, Max(SpawnDistance*100, 200.f));

    else
    {
        UTM.CD_SpawnAI(ZedName, self, Max(SpawnDistance*100, 500.f));

        if(bAutoSpawn)
            SetTimer(ForceSpawnRate, true, 'AutoSpawn', self);
    }
}

reliable server function AutoSpawn()
{
    local UTestMode UTM;
    local KFPawn Zed;

    UTM = UTestMode(WorldInfo.Game);
    Zed = UTM.LocatedSpawn( "", none, vect(0,0,0), rot(0,0,0), self, true);

    if ( Zed != None )
    {
        Zed.SpawnDefaultController();
        if( KFAIController(Zed.Controller) != none )
        {
            KFAIController( Zed.Controller ).SetTeam(1);
        }
    }

    if(!bAutoSpawn)
        ClearTimer('AutoSpawn');
}

reliable server function StopAutoSpawn()
{
    ClearTimer('AutoSpawn');
    ClearTimer('LargeChallenge');
    LogLargeResult();
}

reliable server function SpawnMultiLarges(optional bool bBrainDead)
{
    local int TotalNum, Dis, i, j, LeftSC, LeftFP;
    local string TempStr;
    local array<vector> Locations;
    local vector BaseLoc;
    local rotator BaseRot;
    local vector TempVect;
    local class<KFPawn> SpawnClass;
    local KFPawn Zed;
    local UTestMode UTM;

    UTM = UTestMode(WorldInfo.Game);
    TotalNum = SCNum + FPNum;
    Dis = (bBrainDead) ? 200 : 500;
    Dis = Max(SpawnDistance*100, Dis);
    
    BaseLoc = Pawn.Location + Dis*Vector(Pawn.Rotation) + vect(0,0,1)*15;
    BaseRot.Yaw = Pawn.Rotation.Yaw + 32768;

    TempVect.X = Vector(Pawn.Rotation).Y;
    TempVect.Y = Vector(Pawn.Rotation).X;
    TempVect.Z = Vector(Pawn.Rotation).Z;

    switch(TotalNum)
    {
        case 1:
            Locations.Add(1);
            Locations[0] = BaseLoc;
            break;

        case 2:
            Locations.Add(2);
            Locations[0] = BaseLoc + 100*TempVect;
            Locations[1] = BaseLoc - 100*TempVect;
            break;

        case 3:
            Locations.Add(3);
            Locations[0] = BaseLoc;
            Locations[1] = BaseLoc + 200*TempVect;
            Locations[2] = BaseLoc - 200*TempVect;
            break;

        case 4:
            Locations.Add(4);
            Locations[0] = BaseLoc + 100*TempVect;
            Locations[1] = BaseLoc - 100*TempVect;
            Locations[2] = BaseLoc + 200*TempVect + 200*Vector(Pawn.Rotation);
            Locations[3] = BaseLoc - 200*TempVect + 200*Vector(Pawn.Rotation);
            break;

        case 5:
            Locations.Add(5);
            Locations[0] = BaseLoc;
            Locations[1] = BaseLoc + 200*TempVect;
            Locations[2] = BaseLoc - 200*TempVect;
            Locations[3] = BaseLoc + 100*TempVect + 200*Vector(Pawn.Rotation);
            Locations[4] = BaseLoc - 100*TempVect + 200*Vector(Pawn.Rotation);
            break;

        case 6:
            Locations.Add(6);
            Locations[0] = BaseLoc;
            Locations[1] = BaseLoc + 200*TempVect;
            Locations[2] = BaseLoc - 200*TempVect;
            Locations[3] = Locations[0] + 200*Vector(Pawn.Rotation);
            Locations[4] = Locations[1] + 200*Vector(Pawn.Rotation);
            Locations[5] = Locations[2] + 200*Vector(Pawn.Rotation);
            break;

        default:
            return;
    }

    LeftSC = SCNum;
    LeftFP = FPNum;

    for(i=0; i<TotalNum; i++)
    {
        if(LeftSC*LeftFP != 0)
        {
            j = Rand(2);
            if(j == 0)
            {
                TempStr = "SC";
                LeftSC--;
            }
            else
            {
                TempStr = "FP";
                LeftFP--;
            }
        }
        else if(LeftSC != 0)
        {
            TempStr = "SC";
            LeftSC--;
        }
        else
        {
            TempStr = "FP";
            LeftFP--;
        }

        SpawnClass = class'CD_ZedNameUtils'.static.GetZedClassFromName(TempStr, false, UTM.MySTMGRI.bSpawnRaged);
        Zed = UTM.LocatedSpawn(TempStr, SpawnClass, Locations[i], BaseRot, self);

        if(!bBrainDead && Zed != None)
        {
            Zed.SpawnDefaultController();
            if( KFAIController(Zed.Controller) != none )
            {
                KFAIController( Zed.Controller ).SetTeam(1);
            }
        }
    }
}

reliable server function StartLargeChallenge()
{
    local int d;

    d = Max(SpawnDistance*100, 500);
    LargeLoc = Pawn.Location + d*Vector(Pawn.Rotation) + vect(0,0,15);
    LargeRot.Yaw = Pawn.Rotation.Yaw + 32768;
    SetTimer(5.f, false, 'LargeChallenge');
}

reliable server function LargeChallenge()
{
    local UTestMode UTM;
    local UTM_PlayerReplicationInfo UTMPRI;
    local KFPawn Zed;
    local class<KFPawn> SpawnClass;
    local int LargeCount;
    local float SP;
    local string s;

    UTM = UTestMode(WorldInfo.Game);
    UTMPRI = UTM_PlayerReplicationInfo(PlayerReplicationInfo);

    if(Rand(2) == 0)
    {
        SpawnClass = class'KFGameContent.KFPawn_ZedScrake';
        s = "SC";
        UTMPRI.SCKills++;
    }
    else
    {
        SpawnClass = class'CombinedCD2.CD_Pawn_ZedFleshpound_NRS';
        s = "FP";
        UTMPRI.FPKills++;
    }

    LargeCount = UTMPRI.SCKills + UTMPRI.FPKills;

    if(LargeCount % 10 == 1)
    {
        UTMPRI.LargeWaveNum++;
    }

    SP = 8.f - float(UTMPRI.LargeWaveNum);

    if(LargeCount % 10 == 0)
        SP = Max(5.f, SP);    

    Zed = UTM.LocatedSpawn(s, SpawnClass, LargeLoc, LargeRot, self);

    if(Zed != none)
    {
        Zed.SpawnDefaultController();
        if( KFAIController(Zed.Controller) != none )
        {
            KFAIController( Zed.Controller ).SetTeam(1);
        }
    }

    if(LargeCount < 50)
    {
        SetTimer(SP, false, 'LargeChallenge', self);
    }
    else
    {
        UTMPRI.PendingZed = Zed;
    }
}

function LogLargeResult()
{
    local UTM_PlayerReplicationInfo UTMPRI;

    UTMPRI = UTM_PlayerReplicationInfo(PlayerReplicationInfo);

    if(UTMPRI.LargeWaveNum > 0)
    {
        ClientMessage("Result(SC:" $ string(UTMPRI.SCKills) @ "FP:" $ string(UTMPRI.FPKills) $ ")", 'CDEcho');
        UTMPRI.LargeWaveNum = 0;
        UTMPRI.SCKills = 0;
        UTMPRI.FPKills = 0;
    }
}

reliable server function StartTrashChallenge()
{
    local UTestMode UTM;

    UTM = UTestMode(WorldInfo.Game);
    UTM.BeginTrashChallenge();
}

reliable server function AddFakedPlayer()
{
    local UTestMode STMGameInfo;

    STMGameInfo = UTestMode(WorldInfo.Game);
    if(STMGameInfo.MySTMGRI.nFakedPlayers < 32)
    {
        ++STMGameInfo.MySTMGRI.nFakedPlayers;
        STMGameInfo.SetAllHPFakes(self, "!cdahpf" @ string(STMGameInfo.MySTMGRI.nFakedPlayers));
        STMGameInfo.SaveConfig();
    }
}

reliable server function RemoveFakedPlayer()
{
    local UTestMode STMGameInfo;

    STMGameInfo = UTestMode(WorldInfo.Game);
    if(STMGameInfo.MySTMGRI.nFakedPlayers > 1)
    {
        -- STMGameInfo.MySTMGRI.nFakedPlayers;
        STMGameInfo.SetAllHPFakes(self, "!cdahpf" @ string(STMGameInfo.MySTMGRI.nFakedPlayers));
        STMGameInfo.SaveConfig();
    }
}

reliable server function SetDisableZedtime(bool bDisable)
{
    local UTestMode STMGameInfo;

    STMGameInfo = UTestMode(WorldInfo.Game);
    STMGameInfo.bDisableZedTime = bDisable;
    STMGameInfo.bNVBlockDramatic = bDisable;
    STMGameInfo.SaveConfig();

    STMGameInfo.MySTMGRI.bDisableZedTime = bDisable;
}

reliable server function SetRageSpawn(bool bRage)
{
    local UTestMode STMGameInfo;

    STMGameInfo = UTestMode(WorldInfo.Game);
    STMGameInfo.ChatCommander.RunCDChatCommandIfAuthorized(self, "!cdfprs" @ string(bRage));
    STMGameInfo.SaveConfig();

    STMGameInfo.MySTMGRI.bSpawnRaged = bRage;
}

reliable server function SetDisableRobots(bool bDisable)
{
    local UTestMode STMGameInfo;

    STMGameInfo = UTestMode(WorldInfo.Game);
    STMGameInfo.ChatCommander.RunCDChatCommandIfAuthorized(self, "!cddr" @ string(bDisable));
    STMGameInfo.SaveConfig();

    STMGameInfo.MySTMGRI.bDisableRobots = bDisable;
}

reliable server function SetLargeLess(bool bLess)
{
    local UTestMode STMGameInfo;

    STMGameInfo = UTestMode(WorldInfo.Game);
    STMGameInfo.bLargeLess = bLess;
    STMGameInfo.SaveConfig();

    STMGameInfo.MySTMGRI.bLargeLess = bLess;
}

reliable server function SetHSOnly(bool bOnly)
{
    local UTestMode STMGameInfo;

    STMGameInfo = UTestMode(WorldInfo.Game);
    STMGameInfo.bHSOnly = bOnly;
    STMGameInfo.SaveConfig();

    STMGameInfo.MySTMGRI.bHSOnly = bOnly;
}

reliable server function SetMM(int NewMM)
{
    local UTestMode UTM;

    UTM = UTestMode(WorldInfo.Game);
    UTM.SetParams(self, "!cdmm" @ string(NewMM));
}

reliable server function SetWSF(int WSF)
{
    local UTestMode UTM;

    UTM = UTestMode(WorldInfo.Game);
    UTM.SetParams(self, "!cdwsf" @ string(WSF));
}

reliable server function SetCS(int CS)
{
    local UTestMode UTM;

    UTM = UTestMode(WorldInfo.Game);
    UTM.SetParams(self, "!cdcs" @ string(CS));
}

reliable server function SetSP(float SP)
{
    local UTestMode UTM;

    UTM = UTestMode(WorldInfo.Game);
    UTM.SetParams(self, "!cdsp" @ string(SP));
}

exec function STMKillZeds(){ STMKillZedsServer(); }

reliable server function STMKillZedsServer(){ UTestMode(WorldInfo.Game).Ext_KillZeds(); }

exec function Do(string S){ STMDo(S); }

reliable server function STMDo(string S)
{
    local array<string> Cmd;

    ParseStringIntoArray(S, Cmd, Chr(32), true);
    
    if(Cmd[0] ~= "ZedTime")
    {
        if(Cmd[1] ~= "") Cmd[1] = "3";
        UTestMode(WorldInfo.Game).ForceDramaEvent(float(Cmd[1]));
    }
    
    else if(Cmd[0] ~= "zed")
    {
        ReplacedZedName = Cmd[1];
    }
    
    else if(Cmd[0] ~= "rate")
    {
        ForceSpawnRate = float(Cmd[1]);
    }
    
    else if(Cmd[0] ~= "buff")
    {
        UTM_Pawn_Human(Pawn).Buff(int(Cmd[1]));
    }  
}

final simulated function SaveSTMSettings()
{
    if(LocalPlayer(Player) != none)
    {
        ServerSetSettings(bShowDamageMsg, bShowDamagePopup, bImDemiGod, bImGod, bAutoSpawn, bAutoFillMag, bAutoFillNade, SCNum, FPNum, SpawnDistance);
        SaveConfig();
    }   
}

reliable server function ServerSetSettings(bool bShowDmg, bool bShowNum, bool bDemiGod, bool bGod, bool bAuto, bool bMag, bool bNade, int SC, int FP, int Dis)
{
    local UTM_PlayerReplicationInfo UTMPRI;

    UTMPRI = UTM_PlayerReplicationInfo(PlayerReplicationInfo);
    UTMPRI.bAutoSpawn = bAuto;
    bAutoSpawn = bAuto;

    bClientShowDamageMsg = bShowDmg;
    bClientShowDamagePopup = bShowNum;
    bDamageTracking = bShowDmg || bShowNum;
    bGodMode = bGod;
    bDemiGodMode = bDemiGod;
    bAutoFillMag = bMag;
    bAutoFillNade = bNade;  
    SCNum = SC;
    FPNum = FP;
    SpawnDistance = Dis;
}

unreliable client simulated function ReceiveDamageMessage(Pawn Victim, int Damage)
{
    if((bShowDamageMsg && UTM_GFxHudWrapper(myHUD) != none) && Victim != none)
    {
        UTM_GFxHudWrapper(myHUD).AddKillMessage(Victim, Damage, none, 2);
    } 
}

unreliable client simulated function ReceiveDamagePopup(int Count, Vector pos)
{
    if(bShowDamagePopup && UTM_GFxHudWrapper(myHUD) != none)
    {
        UTM_GFxHudWrapper(myHUD).AddNumberMsg(Count, pos);
    }
}


simulated function DelayedOpenWeapSkinMenu()
{
    Class'KF2GUIController'.Static.GetGUIController(self).OpenMenu(class'UTM_UI_WeaponSkin');
}

reliable client simulated function OpenWeapSkinMenu()
{
    PrepareOpenMenu();
    SetTimer(0.25f, false, 'DelayedOpenWeapSkinMenu');
}

exec function WeapSkinOption(){ OpenWeapSkinMenu(); }

exec function ToggleCollectibles(){ bShowCollectibles = !bShowCollectibles; }

exec function CheckRot()
{
    Client_CDCP.Print("Yaw=" $ Pawn.Rotation.Yaw);
}

/** ================================================================
 *   Tick System
 *  ================================================================ **/

simulated event PostBeginPlay()
{
    super.PostBeginPlay();

    bGodMode = bImGod;
    bDemiGodMode = bImDemiGod;
    ForceSpawnRate = FClamp(ForceSpawnRate, 1.f, 20.f);
    SpawnDistance = Clamp(SpawnDistance, 2, 30);
    SCNum = Clamp(SCNum, 1, 3);
    FPNum = Clamp(FPNum, 1, 3);

    SetTimer(0.25f, true, 'PawnJudgePlayer');
}

function JudgePlayers()
{
    
}

function PawnJudgePlayer()
{
    local UTM_Pawn_Human P;

    P = UTM_Pawn_Human(Pawn);
    if(P != none) P.JudgePlayer(self);
}

function AddAffliction(KFPawn_Monster KFPM)
{

}

exec function UTMClearCorpses()
{
    local int i;
    local KFGoreManager GoreManager;

    GoreManager = KFGoreManager(WorldInfo.MyGoreEffectManager);
    if( GoreManager == none )
        return;

    for (i = GoreManager.CorpsePool.Length-1; i >= 0; i--)
        GoreManager.RemoveAndDeleteCorpse(i);
}

reliable server simulated function ServerEndWave()
{
    UTestMode(WorldInfo.Game).EndCurrentWave();
}

reliable server simulated function ServerSetWave(byte NewWaveNum)
{
    UTestMode(WorldInfo.Game).SetWave(NewWaveNum);
}

function GetHellishRage()
{
    if(CurrentPowerUp.class == class'UTM_PowerUp_HellishRage')
    {
        CurrentPowerUp.ClearTimer('ReactivatePowerUp');
        CurrentPowerUp.DeactivatePowerUp();
        ClientUpdatePowerUp(class'UTM_PowerUp_HellishRage');
    }

    else
    {
        ReceivePowerUp(class'UTM_PowerUp_HellishRage');
        CurrentPowerUp.SetTimer(class'KFPowerUp_HellishRage'.default.PowerUpDuration, true, 'ReactivatePowerUp');
    }
}

function NotifyKilled( Controller Killer, Controller Killed, pawn KilledPawn, class<DamageType> damageType )
{
    local UTM_PlayerReplicationInfo UTMPRI;

    UTMPRI = UTM_PlayerReplicationInfo(PlayerReplicationInfo);

    if(Killed == self)
    {
        StopAutoSpawn();
        STMKillZeds();
    }

    else if (KFPawn(KilledPawn) == UTMPRI.PendingZed)
    {
        STMDo("ZedTime");
        UTMPRI.PendingZed = none;
        LogLargeResult();
        ShowMessageBar('Priority', "COMPLETED", "You are the largest!");
    }

    super.NotifyKilled(Killer, Killed, KilledPawn, damageType);
}

function SetSkinMat(int TargetSkinId)
{
    local WeaponSkin TargetSkin;
    local KFWeapon Weap;
    local class<Weapon> WeapClass;
    local MaterialInterface NewMat;
    local Inventory Inv;
    local int i;
    local bool bFound;

    i = class'KFWeaponSkinList'.default.Skins.Find('Id', TargetSkinId);
    if(i == INDEX_NONE || Pawn == none)
        return;

    TargetSkin = class'KFWeaponSkinList'.default.Skins[i];
    WeapClass = class'CD_Object'.static.GetWeapClass(WeapUIInfo.WeapDef);

    for(Inv=Pawn.InvManager.InventoryChain; Inv!=None; Inv=Inv.Inventory)
    {
        if(Inv.ItemName == WeapClass.default.ItemName)
        {
            Weap = KFWeapon(Inv);
            bFound = true;
            break;
        }
    }

    if(!bFound)
    {
        for(i=0; i<5; i++)
        {
            Weap = KFWeapon(Pawn.CreateInventory(WeapClass));
            if(Weap != none) break;
            else Pawn.Weapon.Destroyed();
        }
    }

    Pawn.InvManager.ServerSetCurrentWeapon(Weap);

    for(i=0; i<TargetSkin.MIC_1P.length; i++)
    {
        NewMat = MaterialInterface(DynamicLoadObject(TargetSkin.MIC_1P[i], class'MaterialInterface'));
        Weap.Mesh.SetMaterial(i, NewMat);
    }
}

defaultproperties
{
    PurchaseHelperClass=class'KFAutoPurchaseHelper'

    PerkList.Add((PerkClass=class'KFPerk_Berserker'))
    PerkList.Add((PerkClass=class'KFPerk_Demolitionist'))
    PerkList.Add((PerkClass=class'KFPerk_Firebug'))
    PerkList.Add((PerkClass=class'KFPerk_Survivalist'))
}