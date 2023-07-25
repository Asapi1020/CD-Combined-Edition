class UTM_AutoPurchaseHelper extends CD_AutoPurchaseHelper
	within UTM_PlayerController;

function bool CanUpgrade(STraderItem SelectedItem, out int CanCarryIndex, out int bCanAffordIndex, optional bool bPlayDialog)
{
	return super(KFAutoPurchaseHelper).CanUpgrade(SelectedItem, CanCarryIndex, bCanAffordIndex, bPlayDialog);
}