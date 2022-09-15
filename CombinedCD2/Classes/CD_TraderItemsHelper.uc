class CD_TraderItemsHelper extends ReplicationInfo;

struct TraderWeaponMod
{
	var class<KFWeaponDefinition> NewWeapDef;
	var class<KFWeaponDefinition> ReplWeapDef;
	var name ReplWeapName;
	var bool bAffectsGameplay;
	var class<KFWeaponDefinition> CheckWeapDef;
};

var const array<TraderWeaponMod> TraderModList;

var repnotify bool bModifiedTraderList;
var int TraderItemCount;

replication
{
	if (bNetDirty)
		bModifiedTraderList;
}

simulated event ReplicatedEvent(name VarName)
{
	if (VarName == 'bModifiedTraderList')
		SetTimer(1.0, false, nameof(CheckTraderListClient));
		
	super.ReplicatedEvent(VarName);
}

function CheckTraderList()
{
	if (bModifiedTraderList)
		return;

	ModifyTraderList();
	bModifiedTraderList = true;
}

simulated function CheckTraderListClient()
{
	if (WorldInfo.GRI == None)
	{
		SetTimer(1.0, false, nameof(CheckTraderListClient));
		return;
	}
	
	TraderItemCount = KFGameReplicationInfo(WorldInfo.GRI).TraderItems.SaleItems.Length;
	SetTimer(1.0, false, nameof(ModifyTraderList));
}

simulated function ModifyTraderList()
{
	local KFGFxObject_TraderItems TraderItems;
	local class<KFWeaponDefinition> OldWeapDef, NewWeapDef;
	local array<KFGFxObject_TraderItems.STraderItem> TempTraderItem;
	local bool bWeaponDefReplaced, bWeaponDefAlreadyExists;
	local int i, j, Index;

	if (WorldInfo.GRI == None)
	{
		SetTimer(1.0, false, nameof(ModifyTraderList));
		return;
	}

	TraderItems = KFGameReplicationInfo(WorldInfo.GRI).TraderItems;

	// Check to ensure that original Trader list is done compiling
	if (WorldInfo.NetMode == NM_Client && TraderItems.SaleItems.Length != TraderItemCount)
	{
		TraderItemCount = TraderItems.SaleItems.Length;
		SetTimer(1.0, false, nameof(ModifyTraderList));
		return;
	}

	for (i=0; i<TraderModList.Length; i++)
	{
		// Check for erroneous entries
		if (TraderModList[i].NewWeapDef == None)
		{
			`log("Empty/erroneous entry in TraderHelper.TraderModList entry #" $ i);
			continue;
		}

		bWeaponDefReplaced = false;
		bWeaponDefAlreadyExists = false;
		TempTraderItem.Length = 0;
		TempTraderItem.Add(1);

		// Get our WeaponDefs
		if (!GetWeaponDefs(i, OldWeapDef, NewWeapDef))
			continue;

		// Check if this is already in the Trader list
		Index = TraderItems.SaleItems.Find('WeaponDef', NewWeapDef);

		if (Index != INDEX_NONE)
			bWeaponDefAlreadyExists = true;

		else
		{
			Index = TraderItems.SaleItems.Find('WeaponDef', OldWeapDef);
			if (Index != INDEX_NONE)
			{
				TempTraderItem[0].WeaponDef = NewWeapDef;

				for(j=0; j<TraderItems.SaleItems.length; j++)
				{
					if(TraderItems.SaleItems.Find('ItemID', j) != INDEX_NONE)
						break;
				}
				TempTraderItem[0].ItemID = j;

			//	TempTraderItem[0].ItemID = TraderItems.SaleItems[Index].ItemID;
			//	TraderItems.SaleItems[Index] = TempTraderItem[0];
				TraderItems.SaleItems.AddItem(TempTraderItem[0]);
			//	TraderItems.SetItemsInfo(TempTraderItem);
				bWeaponDefReplaced = true;
			}
		}

		// Continue if this weapon is already in the list
		if (bWeaponDefReplaced || bWeaponDefAlreadyExists)
			continue;

		// Log it if we didn't find the class
		if (TraderModList[i].ReplWeapDef != None && !bWeaponDefReplaced)
			`log("Couldn't find any weapons of type" @ TraderModList[i].ReplWeapDef @ "(trying to replace with" @ TraderModList[i].NewWeapDef $ ")");
	}
	TraderItems.SetItemsInfo(TraderItems.SaleItems);
	KFGameReplicationInfo(WorldInfo.GRI).TraderItems = TraderItems;
}

simulated function bool GetWeaponDefs(int Index, out class<KFWeaponDefinition> OldWeapDef, out class<KFWeaponDefinition> NewWeapDef)
{
	local KFGFxObject_TraderItems TraderItems;
	local int TraderIndex;
	local class<KFWeaponDefinition> OrigWeapDef;

	// Check for class name
	if (TraderModList[Index].ReplWeapDef == None && TraderModList[Index].ReplWeapName != '')
	{
		TraderItems = KFGameReplicationInfo(WorldInfo.GRI).TraderItems;
		TraderIndex = TraderItems.SaleItems.Find('ClassName', TraderModList[Index].ReplWeapName);
		
		if (TraderIndex != INDEX_NONE)
			OrigWeapDef = TraderItems.SaleItems[TraderIndex].WeaponDef;
	}
	else
		OrigWeapDef = TraderModList[Index].ReplWeapDef;
	
	OldWeapDef = OrigWeapDef;
	NewWeapDef = TraderModList[Index].NewWeapDef;
	
	return true;
}

function bool IsWeaponDefReplaced(class<KFWeaponDefinition> KFWeapDef)
{
	local int Index;
	
	Index = TraderModList.Find('ReplWeapDef', KFWeapDef);
	
	if (Index == INDEX_NONE)
		return false;
		
	return true;
}

static function class<KFWeaponDefinition> FindWeaponDef(string WeaponName, bool bGameplayWeaponsOnly)
{
	local int i;
	local class<KFWeaponDefinition> WeaponDef;
	
	for (i = 0;i < default.TraderModList.Length;i++)
	{
		if (!bGameplayWeaponsOnly || default.TraderModList[i].bAffectsGameplay)
		{
			WeaponDef = default.TraderModList[i].NewWeapDef;
			if (Instr(WeaponDef.default.WeaponClassPath, WeaponName, false, true) != INDEX_NONE)
				return WeaponDef;
		}
	}
	
	return None;
}

static function class<KFWeaponDefinition> GetOriginalWeaponDef(class<KFWeaponDefinition> UMWeapDef)
{
	local int i;
	
	// First check
	if (UMWeapDef.GetPackageName() != 'CombinedCD2')
	{
		`log("WeaponDef from outside package!" @ UMWeapDef.GetPackageName() $ "." $ UMWeapDef.name);
		return None;
	}

	for (i = 0;i < default.TraderModList.Length;i++)
	{
		if (default.TraderModList[i].NewWeapDef == UMWeapDef)
			return default.TraderModList[i].ReplWeapDef;
	}

	`log("Couldn't find original WeaponDef for" @ UMWeapDef.name $ "!?");
	return None;
}

static simulated function CopyWeaponSkins()
{
	local int i;
	local class<KFWeaponDefinition> KFWeapDef, UMWeapDef;
	local class<KFWeapon> KFWC;
	
	for (i = 0;i < default.TraderModList.Length;i++)
	{
		KFWeapDef = default.TraderModList[i].ReplWeapDef;
		UMWeapDef = default.TraderModList[i].NewWeapDef;

		// Second check ignores WeaponDefs that remove content-lock
		if (KFWeapDef != None && !(KFWeapDef.default.WeaponClassPath ~= UMWeapDef.default.WeaponClassPath))
		{
			KFWC = class<KFWeapon>(DynamicLoadObject(KFWeapDef.default.WeaponClassPath, class'Class'));
			if (KFWC != None && KFWC.default.SkinItemId != 0)
				class'KFGame.KFWeaponSkinList'.static.SaveWeaponSkin(UMWeapDef, KFWC.default.SkinItemId);
		}
	}
}

static simulated function string GetWeaponLocalization(string KeyName, class<KFWeaponDefinition> UMWeapDef, class<KFWeaponDefinition> KFWeapDef)
{
	local array<string> StringParts;
	local string WeaponString;

	ParseStringIntoArray(UMWeapDef.default.WeaponClassPath, StringParts, ".", true);
	WeaponString = Localize(StringParts[1], KeyName, StringParts[0]);
	
	if (Left(WeaponString, 1) == "?")
	{
		WeaponString = KFWeapDef.static.GetItemLocalization(KeyName);
	}
	
	return WeaponString;
}

defaultproperties
{
	TraderModList.Add((NewWeapDef=class'CombinedCD2.CustomWeapDef_Minigun', ReplWeapDef=class'KFGame.KFWeapDef_Minigun'))
	TraderModList.Add((NewWeapDef=class'CombinedCD2.CustomWeapDef_Mac10', ReplWeapDef=class'KFGame.KFWeapDef_Mac10'))
}