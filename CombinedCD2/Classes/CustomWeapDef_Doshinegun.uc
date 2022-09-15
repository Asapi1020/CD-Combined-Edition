class CustomWeapDef_Doshinegun extends KFWeapDef_Doshinegun
	abstract;

static function string GetItemLocalization(string KeyName)
{
	return class'CD_TraderItemsHelper'.static.GetWeaponLocalization(KeyName, default.class, class'KFGame.KFWeapDef_Doshinegun');
}
defaultproperties
{
	WeaponClassPath="CombinedCD2.CustomWeap_Doshinegun"
	BuyPrice=0
}