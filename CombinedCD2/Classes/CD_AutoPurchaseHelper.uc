class CD_AutoPurchaseHelper extends KFAutoPurchaseHelper
	within CD_PlayerController;

`include(CD_Log.uci)

var int PurchaseCount;
var int RetryNum;
var array<LoadoutInfo> LoadoutList;

var localized string AutoTraderPartialSuccessMsg;
var localized string AutoTraderCompleteSuccessMsg;
var localized string AutoTraderFailMsg;
var localized string AutoTraderNullMsg;

function bool CanUpgrade(STraderItem SelectedItem, out int CanCarryIndex, out int bCanAffordIndex, optional bool bPlayDialog)
{
	local bool b1, b2;
	local CD_GameReplicationInfo CDGRI;

	CDGRI = CD_GameReplicationInfo(Outer.WorldInfo.GRI);	
	b1 = super.CanUpgrade(SelectedItem, CanCarryIndex, bCanAffordIndex, bPlayDialog);
	b2 = CDGRI.MaxUpgrade > Outer.GetPurchaseHelper().GetItemUpgradeLevelByClassName(SelectedItem.ClassName);

	return (b1 && b2);
}

function DoAutoPurchase()
{
	local int LoadoutIndex, ItemIndex;
	local int i, j, k;
	local int PotentialDosh, PotentialBlocks;
	local int Purchased, Failed;
	local STraderItem TempTraderItem;
	local array<int> IndexList;
	local Array <STraderItem> LoadoutWeapons;
	local bool bSuccess;
	local string ClientMessage;

	`cdlog("---Start logging auto purchase---");
	`cdlog("LoadoutList.length=" $ string(LoadoutList.length));
	GetTraderItems();
	LoadoutIndex = LoadoutList.Find('Perk', CurrentPerk.GetPerkClass());

	if(LoadoutIndex == INDEX_NONE)
	{
		`cdlog("!!!Autobuy load out path not set!!!");
		return;
	}

	for(i=0; i<LoadoutList[LoadoutIndex].WeapDef.length; i++)
	{
		if(!Outer.IsAllowedWeapon(LoadoutList[LoadoutIndex].WeapDef[i], false, false))
		{
			`cdlog(string(LoadoutList[LoadoutIndex].WeapDef[i]) $ ": Restricted");
			continue;
		}

		ItemIndex = TraderItems.SaleItems.Find('WeaponDef', LoadoutList[LoadoutIndex].WeapDef[i]);
		if(ItemIndex == INDEX_NONE)
		{
			`cdlog("ERROR: Failed to register LoadoutWeapon: " $ string(LoadoutList[LoadoutIndex].WeapDef[i]));
			continue;
		}

		LoadoutWeapons.AddItem(TraderItems.SaleItems[ItemIndex]);
	}

	for(i=0; i<LoadoutWeapons.length; ++i)
	{
		if(DoIOwnThisWeapon(LoadoutWeapons[i]))
		{
			`cdlog(string(i) $ ": Already Owned");
			continue;
		}

		if(IsInOwnedItemList(LoadoutWeapons[i].DualClassName) || IsInOwnedItemList(LoadoutWeapons[i].SingleClassName))
		{
			`cdlog(string(i) $ ": Access Denied to purchase both Dual and Single pistols");
			continue;
		}

		if(GetCanAfford( GetAdjustedBuyPriceFor(LoadoutWeapons[i]) + DoshBuffer ) && CanCarry( LoadoutWeapons[i] ))
		{
			PurchaseWeapon(LoadoutWeapons[i]);
			`cdlog(string(i) $ ": Purchase Success");
			Purchased += 1;
			continue;
		}

		PotentialDosh = TotalDosh;
		PotentialBlocks = TotalBlocks;
		IndexList.Remove(0, IndexList.length);

		for(j=0; j<OwnedItemList.length; ++j)
		{
			if (LoadoutWeapons.Find('WeaponDef', OwnedItemList[j].DefaultItem.WeaponDef) != INDEX_NONE ||
				OwnedItemList[j].DefaultItem.WeaponDef == class'KFWeapDef_9mm')
			{
				`cdlog(string(i) $ ": " $string(OwnedItemList[j].DefaultItem.WeaponDef) $ ": necessary and unable to sell");
				continue;
			}

			TempTraderItem = OwnedItemList[j].DefaultItem;
			PotentialDosh += OwnedItemList[j].SellPrice;
			PotentialBlocks -= MyKFIM.GetDisplayedBlocksRequiredFor(TempTraderItem);
			TempTraderItem = LoadoutWeapons[i];
			IndexList.AddItem(j);
			`cdlog(string(i) $ ": " $string(OwnedItemList[j].DefaultItem.WeaponDef) $ ": unncessary");

			if(TempTraderItem.WeaponDef.default.BuyPrice <= PotentialDosh && PotentialBlocks + MyKFIM.GetDisplayedBlocksRequiredFor(TempTraderItem) <= MaxBlocks)
			{
				for(k=0; k<IndexList.length; k++)
				{
					`cdlog(string(i) $ ": " $string(OwnedItemList[IndexList[k]].DefaultItem.WeaponDef) $ ": sold");
					SellWeapon(OwnedItemList[IndexList[k]], IndexList[k]);
				}
				bSuccess = true;
				break;
			}
		}

		if(!bSuccess)
		{
			`cdlog(string(i) $ ": No potential...");
			Failed += 1;
			continue;
		}

		PurchaseWeapon(LoadoutWeapons[i]);
		Purchased += 1;
		`cdlog(string(i) $ ": Sale and Purchase Success");
	}

	StartAutoFill();
	MyKFIM.ServerCloseTraderMenu();

	if(Failed > 0)
	{
		if(Purchased > 0)
			ClientMessage = AutoTraderPartialSuccessMsg;
		else
			ClientMessage = AutoTraderFailMsg;
	}
	else
	{
		if(Purchased > 0)
			ClientMessage = AutoTraderCompleteSuccessMsg;
		else
			ClientMessage = AutoTraderNullMsg;
	}
	
	Outer.ShowMessageBar('Game', ClientMessage );
}	

function ServerReceiveLoadoutList(class<KFPerk> Perk, class<KFWeaponDefinition> WeapDef, bool bInit, int Priority, int DefLen)
{
	local int i;

	if(Priority == DefLen)
	{
		if(LoadedNoneWeap())
		{
			if(RetryNum < 50)
				Outer.SetTimer(2.f, false, 'ClientSendLoadoutList');

			else
				`cdlog("Failed to load some weapons");
		}
		else
		{
			RetryNum = 0;
		}
	}

	if(bInit)
	{
		LoadoutList.Remove(0, LoadoutList.length);
	}

	i = LoadoutList.Find('Perk', Perk);
	if(i == INDEX_NONE)
	{
		LoadoutList.Add(1);
		i = LoadoutList.length-1;
		LoadoutList[i].Perk = Perk;
	}

	if(Priority == 0)
	{
		LoadoutList[i].WeapDef.Remove(0, LoadoutList[i].WeapDef.length);
		LoadoutList[i].WeapDef.Add(DefLen);
	}

	if(Priority < DefLen)
	{
		LoadoutList[i].WeapDef[Priority] = WeapDef;
	}
}

function RemoveLoadoutList(int idx, class<KFPerk> Perk)
{
	local int i;

	i = LoadoutList.Find('Perk', Perk);
	if(i == INDEX_NONE)
	{
		`cdlog("Remove nothing! error");
	}
	else if(idx < LoadoutList[i].WeapDef.length)
	{
		LoadoutList[i].WeapDef.Remove(idx, 1);
	}
}

function SwitchLoadoutList(int i, int j, class<KFPerk> Perk)
{
	local int idx;
	local class<KFWeaponDefinition> TempWeapDef;

	idx = LoadoutList.Find('Perk', Perk);
	if(idx == INDEX_NONE || LoadoutList[idx].WeapDef.length <= max(i, j))
	{
		`cdlog("Failed to switch loadout order");
	}

	TempWeapDef = LoadoutList[idx].WeapDef[i];
	LoadoutList[idx].WeapDef[i] = LoadoutList[idx].WeapDef[j];
	LoadoutList[idx].WeapDef[j] = TempWeapDef;
}

function bool LoadedNoneWeap()
{
	local LoadoutInfo LI;
	foreach LoadoutList(LI)
	{
		if(LI.WeapDef.Find(none) != INDEX_NONE)
			return true;
	}

	return false;
}