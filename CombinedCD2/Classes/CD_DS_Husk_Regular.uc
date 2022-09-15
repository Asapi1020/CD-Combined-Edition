//=============================================================================
// CD_DS_Husk_Regular
// Sets the special spawnchance to zero on all difficulties (always husk)
//=============================================================================
class CD_DS_Husk_Regular extends KFDifficulty_Husk
	abstract;

static function float GetSpecialSpawnChance(KFGameReplicationInfo KFGRI)
{
	return 0.f;
}
