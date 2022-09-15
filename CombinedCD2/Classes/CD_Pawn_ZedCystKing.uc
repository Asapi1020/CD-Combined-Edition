class CD_Pawn_ZedCystKing extends KFPawn_ZedClot_Cyst
	implements(KFInterface_MonsterBoss);

//Intro Camera
var bool bUseAnimatedCamera;
var vector AnimatedBossCameraOffset;

simulated function string GetRandomBossCaption()
{
	return "Cyst, so cute!";
}

static simulated event bool IsABoss()
{
    return true;
}

simulated function float GetHealthPercent()
{
    return float(Health) / float(HealthMax);
}

simulated function SetAnimatedBossCamera(bool bEnable, optional vector CameraOffset)
{
    bUseAnimatedCamera = bEnable;
    if (bUseAnimatedCamera)
    {
        AnimatedBossCameraOffset = CameraOffset;
    }
    else
    {
        AnimatedBossCameraOffset = vect(0, 0, 0);
    }
}

/** Whether this pawn is in theatric camera mode */
simulated function bool UseAnimatedBossCamera()
{
    return bUseAnimatedCamera;
}

/** The name of the socket to use as a camera base for theatric sequences */
simulated function name GetBossCameraSocket()
{
    return 'TheatricCameraRootSocket';
}

/** The relative offset to use for the cinematic camera */
simulated function vector GetBossCameraOffset()
{
    return AnimatedBossCameraOffset;
}

function OnZedDied(Controller Killer)
{
    super.OnZedDied(Killer);

	KFGameInfo(WorldInfo.Game).BossDied(Killer);
}

function KFAIWaveInfo GetWaveInfo(int BattlePhase, int Difficulty)
{
    return none;
}

/** Returns the number of minions to spawn based on number of players */
function byte GetNumMinionsToSpawn()
{
    return 0;
}

/*
simulated event ReplicatedEvent(name VarName)
{
    super.ReplicatedEvent(VarName);
}
*/
/** Called from Possessed event when this controller has taken control of a Pawn */
function PossessedBy(Controller C, bool bVehicleTransition)
{
    Super.PossessedBy(C, bVehicleTransition);

    PlayBossMusic();
    class'KFPawn_MonsterBoss'.static.PlayBossEntranceTheatrics(self);
}

/** Play music for this boss (overridden for each boss) */
function PlayBossMusic()
{
    if (KFGameInfo(WorldInfo.Game) != none)
    {
        KFGameInfo(WorldInfo.Game).ForceKingFPMusicTrack();
    }
}

//Skip for boss
function CauseHeadTrauma(float BleedOutTime = 5.f)
{
    return;
}

simulated function bool PlayDismemberment(int InHitZoneIndex, class<KFDamageType> InDmgType, optional vector HitDirection)
{
    return false;
}

//Skip if boss
simulated function PlayHeadAsplode()
{
    return;
}

//Skip if boss
simulated function ApplyHeadChunkGore(class<KFDamageType> DmgType, vector HitLocation, vector HitDirection)
{
    return;
}

simulated function string GetIconPath()
{
	return "";
}

simulated function KFPawn_Monster GetMonsterPawn()
{
    return self;
}

DefaultProperties
{
//	DifficultySettings=class'CD_DS_CystKing'
	IncapSettings(AF_Knockdown)=  (Vulnerability=(0), Cooldown=100.0)
}