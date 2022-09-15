//=============================================================================
// CD_DS_Stalker_Special
// Sets the special spawnchance to one on all difficulties
//=============================================================================
class CD_DS_Stalker_Special extends KFDifficulty_Stalker
	abstract;

static function float GetSpecialSpawnChance(KFGameReplicationInfo KFGRI)
{
	return 1.f;
}
