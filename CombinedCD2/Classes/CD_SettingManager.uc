class CD_SettingManager extends Object;

var CD_DynamicSetting
	BossHPFakesSetting,
	CohortSizeSetting,
	WaveSizeFakesSetting,
	FleshpoundHPFakesSetting,
	QuarterPoundHPFakesSetting,
	MaxMonstersSetting,
	SpawnPollSetting,
	ScrakeHPFakesSetting,
	SpawnModSetting,
	TrashHPFakesSetting,
	ZTSpawnSlowdownSetting;

var CD_BasicSetting
	AlbinoAlphasSetting,
	AlbinoCrawlersSetting,
	AlbinoGorefastsSetting,
	AutoPauseSetting,
	BossSetting,
	CountHeadshotsPerPelletSetting,
	FleshpoundRageSpawnsSetting,
	SpawnCycleSetting,
	TraderTimeSetting,
	EnableReadySystemSetting,
	ZedsTeleportCloserSetting,
	ZTSpawnModeSetting,
	StartwithFullAmmoSetting,
	StartwithFullGrenadeSetting,
	StartwithFullArmorSetting,
	StartingWeaponTierSetting,
	BossDifficultySetting,
	DisableBossMinionsSetting,
	DisableSpawnersSetting,
	DisableRobotsSetting,
	DisableBossSetting;

var array<CD_DynamicSetting> DynamicSettings;
var array<CD_BasicSetting> BasicSettings;
var array<CD_Setting> AllSettings;

public function Initialize(CD_Survival OuterClass, string Options)
{
	SetupBasicSettings(OuterClass);
	SetupDynamicSettings(OuterClass);
	SortAllSettingsByName();
	ParseCDGameOptions( Options );
}

private function SortAllSettingsByName()
{
	AllSettings.sort(SettingNameComparator);
}

private function int SettingNameComparator( CD_Setting a, CD_Setting b )
{
	local string an, bn;

	an = a.GetOptionName();
	bn = b.GetOptionName();

	if ( an < bn )
	{
		return 1;
	}
	else if ( an > bn )
	{
		return -1;
	}
	return 0;
}

private function SetupBasicSettings(CD_Survival OuterClass)
{
	AlbinoAlphasSetting = new(OuterClass) class'CD_BasicSetting_AlbinoAlphas';
	RegisterBasicSetting( AlbinoAlphasSetting );

	AlbinoCrawlersSetting = new(OuterClass) class'CD_BasicSetting_AlbinoCrawlers';
	RegisterBasicSetting( AlbinoCrawlersSetting );

	AlbinoGorefastsSetting = new(OuterClass) class'CD_BasicSetting_AlbinoGorefasts';
	RegisterBasicSetting( AlbinoGorefastsSetting );

	AutoPauseSetting = new(OuterClass) class'CD_BasicSetting_AutoPause';
	RegisterBasicSetting( AutoPauseSetting );
	
	BossSetting = new(OuterClass) class'CD_BasicSetting_Boss';
	RegisterBasicSetting( BossSetting );

	BossDifficultySetting = new(OuterClass) class'CD_BasicSetting_BossDifficulty';
	RegisterBasicSetting( BossDifficultySetting );

	CountHeadshotsPerPelletSetting = new(OuterClass) class'CD_BasicSetting_CountHeadshotsPerPellet';
	RegisterBasicSetting( CountHeadshotsPerPelletSetting );

	DisableBossSetting = new(OuterClass) class'CD_BasicSetting_DisableBoss';
	RegisterBasicSetting( DisableBossSetting );

	DisableBossMinionsSetting = new(OuterClass) class'CD_BasicSetting_DisableBossMinions';
	RegisterBasicSetting( DisableBossMinionsSetting );

	DisableRobotsSetting = new(OuterClass) class'CD_BasicSetting_DisableRobots';
	RegisterBasicSetting( DisableRobotsSetting );

	DisableSpawnersSetting = new(OuterClass) class'CD_BasicSetting_DisableSpawners';
	RegisterBasicSetting( DisableSpawnersSetting );

	EnableReadySystemSetting = new(OuterClass) class'CD_BasicSetting_EnableReadySystem';
	RegisterBasicSetting( EnableReadySystemSetting );

	FleshpoundRageSpawnsSetting = new(OuterClass) class'CD_BasicSetting_FleshpoundRageSpawns';
	RegisterBasicSetting( FleshpoundRageSpawnsSetting );

	StartingWeaponTierSetting = new(OuterClass) class'CD_BasicSetting_StartingWeaponTier';
	RegisterBasicSetting( StartingWeaponTierSetting );

	StartwithFullAmmoSetting = new(OuterClass) class'CD_BasicSetting_StartwithFullAmmo';
	RegisterBasicSetting( StartwithFullAmmoSetting );

	StartwithFullArmorSetting = new(OuterClass) class'CD_BasicSetting_StartwithFullArmor';
	RegisterBasicSetting( StartwithFullArmorSetting );

	StartwithFullGrenadeSetting = new(OuterClass) class'CD_BasicSetting_StartwithFullGrenade';
	RegisterBasicSetting( StartwithFullGrenadeSetting );
	
	SpawnCycleSetting = new(OuterClass) class'CD_BasicSetting_SpawnCycle';
	RegisterBasicSetting( SpawnCycleSetting );

	TraderTimeSetting = new(OuterClass) class'CD_BasicSetting_TraderTime';
	RegisterBasicSetting( TraderTimeSetting );

	ZedsTeleportCloserSetting = new(OuterClass) class'CD_BasicSetting_ZedsTeleportCloser';
	RegisterBasicSetting( ZedsTeleportCloserSetting );

	ZTSpawnModeSetting = new(OuterClass) class'CD_BasicSetting_ZTSpawnMode';
	RegisterBasicSetting( ZTSpawnModeSetting );
}

private function SetupDynamicSettings(CD_Survival OuterClass)
{
	BossHPFakesSetting = new(OuterClass) class'CD_DynamicSetting_BossHPFakes';
	BossHPFakesSetting.IniDefsArray = OuterClass.BossHPFakesDefs;
	RegisterDynamicSetting( BossHPFakesSetting );

	CohortSizeSetting = new(OuterClass) class'CD_DynamicSetting_CohortSize';
	CohortSizeSetting.IniDefsArray = OuterClass.CohortSizeDefs;
	RegisterDynamicSetting( CohortSizeSetting );

	WaveSizeFakesSetting = new(OuterClass) class'CD_DynamicSetting_WaveSizeFakes';
	WaveSizeFakesSetting.IniDefsArray = OuterClass.WaveSizeFakesDefs;
	RegisterDynamicSetting( WaveSizeFakesSetting );

	MaxMonstersSetting = new(OuterClass) class'CD_DynamicSetting_MaxMonsters';
	MaxMonstersSetting.IniDefsArray = OuterClass.MaxMonstersDefs;
	RegisterDynamicSetting( MaxMonstersSetting );

	SpawnModSetting = new(OuterClass) class'CD_DynamicSetting_SpawnMod';
	SpawnModSetting.IniDefsArray = OuterClass.SpawnModDefs;
	RegisterDynamicSetting( SpawnModSetting );

	SpawnPollSetting = new(OuterClass) class'CD_DynamicSetting_SpawnPoll';
	SpawnPollSetting.IniDefsArray = OuterClass.SpawnPollDefs;
	RegisterDynamicSetting( SpawnPollSetting );

	ScrakeHPFakesSetting = new(OuterClass) class'CD_DynamicSetting_ScrakeHPFakes';
	ScrakeHPFakesSetting.IniDefsArray = OuterClass.ScrakeHPFakesDefs;
	RegisterDynamicSetting( ScrakeHPFakesSetting );

	FleshpoundHPFakesSetting = new(OuterClass) class'CD_DynamicSetting_FleshpoundHPFakes';
	FleshpoundHPFakesSetting.IniDefsArray = OuterClass.FleshpoundHPFakesDefs;
	RegisterDynamicSetting( FleshpoundHPFakesSetting );

	QuarterPoundHPFakesSetting = new(OuterClass) class'CD_DynamicSetting_QuarterPoundHPFakes';
	QuarterPoundHPFakesSetting.IniDefsArray = OuterClass.QuarterPoundHPFakesDefs;
	RegisterDynamicSetting( QuarterPoundHPFakesSetting );
	
	TrashHPFakesSetting = new(OuterClass) class'CD_DynamicSetting_TrashHPFakes';
	TrashHPFakesSetting.IniDefsArray = OuterClass.TrashHPFakesDefs;
	RegisterDynamicSetting( TrashHPFakesSetting );

	ZTSpawnSlowdownSetting = new(OuterClass) class'CD_DynamicSetting_ZTSpawnSlowdown';
	ZTSpawnSlowdownSetting.IniDefsArray = OuterClass.ZTSpawnSlowdownDefs;
	RegisterDynamicSetting( ZTSpawnSlowdownSetting );
}

private function RegisterBasicSetting( const out CD_BasicSetting BasicSetting )
{
	BasicSettings.AddItem( BasicSetting );
	AllSettings.AddItem( BasicSetting );
}

private function RegisterDynamicSetting( const out CD_DynamicSetting DynamicSetting )
{
	DynamicSettings.AddItem( DynamicSetting );
	AllSettings.AddItem( DynamicSetting );
}

private function ParseCDGameOptions( const out string Options )
{
	local int i;

	for ( i = 0; i < AllSettings.Length; i++ )
	{
		AllSettings[i].InitFromOptions( Options );
	}
}