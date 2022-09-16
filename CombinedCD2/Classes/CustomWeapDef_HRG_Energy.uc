class CustomWeapDef_HRG_Energy extends KFWeapDef_HRG_Energy
	abstract;

static function string GetItemLocalization(string KeyName)
{
	return "Beta1 Disrupter";
}

static function string GetItemName()
{
	return "Beta1 Disrupter";
}

defaultproperties
{
	WeaponClassPath="CombinedCD2.CustomWeap_HRG_Energy"
}