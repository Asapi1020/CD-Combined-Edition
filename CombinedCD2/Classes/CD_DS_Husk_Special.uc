//=============================================================================
// CD_DS_Husk_Special
// Sets the special spawnchance to one on all difficulties (always EDAR)
//=============================================================================
class CD_DS_Husk_Special extends KFDifficulty_Husk
	abstract;

static function float GetSpecialSpawnChance(KFGameReplicationInfo KFGRI)
{
	return 1.f;
}
