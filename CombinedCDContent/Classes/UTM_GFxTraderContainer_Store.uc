/*******************************************************************************
 * STMGFxTraderContainer_Store 
 * to allow to use DLC weapons
 *******************************************************************************/
class UTM_GFxTraderContainer_Store extends KFGFxTraderContainer_Store within GFxMoviePlayer;

function bool IsItemFiltered(STraderItem Item, optional bool bDebug)
{
    if(KFPC.GetPurchaseHelper().IsInOwnedItemList(Item.ClassName))
        return true;

    if(KFPC.GetPurchaseHelper().IsInOwnedItemList(Item.DualClassName))
        return true;
    
    if(!KFPC.GetPurchaseHelper().IsSellable(Item))
        return true;
    
    return false;   
}
