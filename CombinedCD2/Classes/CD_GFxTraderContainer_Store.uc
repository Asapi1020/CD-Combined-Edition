class CD_GFxTraderContainer_Store extends KFGFxTraderContainer_Store;

/*	Don't show banned weapons */
function bool IsItemFiltered(STraderItem Item, optional bool bDebug)
{
	local KFGameReplicationInfo KFGRI;
	local class<KFWeaponDefinition> KFWD;

	//	original features
	if (KFPC.GetPurchaseHelper().IsInOwnedItemList(Item.ClassName) ||
		KFPC.GetPurchaseHelper().IsInOwnedItemList(Item.DualClassName) ||
		!KFPC.GetPurchaseHelper().IsSellable(Item))
		return true;
	
	//	Dual pistol (without dual 9mm)
	if(CD_PlayerController(KFPC).HideDualPistol && Item.DualClassName == '' && Item.SingleClassName != '' && Item.WeaponDef != class'KFWeapDef_9mmDual')
		return true;

	//	Restricted Weapons
	KFGRI = KFGameReplicationInfo(KFPC.WorldInfo.GRI);
//	KFWD = class<KFDamageType>(class'CD_Object'.static.GetWeapClass(Item.WeaponDef).default.InstantHitDamageTypes[3]).default.WeaponDef;
	KFWD = Item.WeaponDef;

	if( !CD_PlayerController(KFPC).IsAllowedWeapon(KFWD, KFGRI.WaveNum == KFGRI.WaveMax - 1, true, false) )
		return true;
	
	//	All DLC is available
	return false;
}