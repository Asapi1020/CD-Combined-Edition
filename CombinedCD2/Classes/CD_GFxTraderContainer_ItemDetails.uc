class CD_GFxTraderContainer_ItemDetails extends KFGFxTraderContainer_ItemDetails;

function SetGenericItemDetails(const out STraderItem TraderItem, out GFxObject ItemData, optional int UpgradeLevel = INDEX_NONE)
{
	local CD_GameReplicationInfo CDGRI;

	CDGRI = CD_GameReplicationInfo(KFPC.WorldInfo.GRI);

	if(CDGRI != none && CDGRI.MaxUpgrade <= KFPC.GetPurchaseHelper().GetItemUpgradeLevelByClassName(TraderItem.ClassName))
	{
		ItemData.SetInt("upgradePrice", 0);
		ItemData.SetInt("upgradeWeight", 0);
		ItemData.SetBool("bCanUpgrade", false);
		ItemData.SetBool("bCanBuyUpgrade", false);
		ItemData.SetBool("bCanCarryUpgrade", false);
	}
	super.SetGenericItemDetails(TraderItem, ItemData, INDEX_NONE);
}