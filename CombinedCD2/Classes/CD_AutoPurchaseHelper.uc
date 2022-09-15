class CD_AutoPurchaseHelper extends KFAutoPurchaseHelper
	within CD_PlayerController;

function bool CanUpgrade(STraderItem SelectedItem, out int CanCarryIndex, out int bCanAffordIndex, optional bool bPlayDialog)
{
	local bool b1, b2;
	local CD_GameReplicationInfo CDGRI;

	CDGRI = CD_GameReplicationInfo(Outer.WorldInfo.GRI);	
	b1 = super.CanUpgrade(SelectedItem, CanCarryIndex, bCanAffordIndex, bPlayDialog);
	b2 = CDGRI.MaxUpgrade > Outer.GetPurchaseHelper().GetItemUpgradeLevelByClassName(SelectedItem.ClassName);

	return (b1 && b2);
}