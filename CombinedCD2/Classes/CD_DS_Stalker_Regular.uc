//=============================================================================
// CD_DS_Stalker_Regular
// Sets the special spawnchance to zero on all difficulties
//=============================================================================
class CD_DS_Stalker_Regular extends KFDifficulty_Stalker
	abstract;

static function float GetSpecialSpawnChance(KFGameReplicationInfo KFGRI)
{
	return 0.f;
}
