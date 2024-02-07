//=============================================================================
// CD_EphemeralMatchStats
//=============================================================================
// TWI's stat tracking (supporting the after-action report and some steamworks
// stats) depends on the classes of zeds killed.  CD uses custom zed subclasses
// for some behavioral controls (like specifying albinos or non-albinos in
// SpawnCycles).  This class substitutes CD's custom zed subclasses with
// ordinary TWI classes just before TWI's stat code tries to count them.
//=============================================================================


class CD_EphemeralMatchStats extends EphemeralMatchStats;

`include(CD_Log.uci)

var array<PerkUseNum> PerkUseNums;
var int TrashKills;
var int MediumKills;
var int RobotKills;
var int BossKills;

function RecordIntStat(int StatID, int Value)
{
	if(KFGameReplicationInfo(WorldInfo.GRI).bWaveIsActive)
	{
		super.RecordIntStat(StatID, Value);
	}
}

function RecordZedKill(Class<Pawn> PawnClass, class<DamageType> DT)
{
	local CD_Survival CDGameInfo;
	local bool ShouldLog;
	local class<KFPawn_Monster> MonsterClass;

	if(!KFGameReplicationInfo(WorldInfo.GRI).bWaveIsActive)
		return;

	ShouldLog = true;

	// Try to read CD_Survival.bLogControlledDifficulty
	if ( WorldInfo != None )
	{
		CDGameInfo = CD_Survival( WorldInfo.Game );

		if ( CDGameInfo != None )
		{
			ShouldLog = CDGameInfo.bLogControlledDifficulty;
		}
	}

	PawnClass = class'CD_ZedNameUtils'.static.CheckPawnClassRemap( PawnClass, "CD_EphemeralMatchStats.RecordZedKill", ShouldLog );

	`cdlog("Recording stat: player killed a zed with PawnClass="$PawnClass, ShouldLog);

	super.RecordZedKill( PawnClass, DT );

	MonsterClass = class<KFPawn_Monster>(PawnClass);
	if(MonsterClass != none)
	{
		if(MonsterClass.static.IsABoss())
		{
			BossKills++;
			return;
		}
		if(ClassIsChildOf(MonsterClass, class'KFGameContent.KFPawn_ZedDAR'))
		{
			RobotKills++;
			return;
		}

		switch(MonsterClass)
		{
			case class'KFGameContent.KFPawn_ZedBloat':
			case class'KFGameContent.KFPawn_ZedHusk':
			case class'KFGameContent.KFPawn_ZedSiren':
				MediumKills++;
				return;
		}

		TrashKills++;
	}
}

function InternalRecordWeaponDamage(class<KFDamageType> KFDT, class<KFWeaponDefinition> WeaponDef, int Damage, KFPawn TargetPawn, int HitZoneIdx)
{
	local int i;

	if(!KFGameReplicationInfo(WorldInfo.GRI).bWaveIsActive)
	{
		// Cancel Headshot increament here
		// because it is difficult to override function which controls weapons' headshots amount.
		if(HitZoneIdx == HZI_HEAD)
		{
			i = WeaponDamageList.Find('WeaponDef', WeaponDef);
			WeaponDamageList[i].HeadShots--;
		}
		return;
	}

	super.InternalRecordWeaponDamage(KFDT, WeaponDef, Damage, TargetPawn, HitZoneIdx);
}