class CD_GFxWeeklyObjectivesContainer extends KFGFxWeeklyObjectivesContainer
	dependson(KFMission_LocalizedStrings);

function bool PopulateData()
{
	local GFxObject DataObject;
	local KFWeeklyOutbreakInformation WeeklyInfo;
	local bool bWeeklyComplete;
	local int WeeklyIndex;

	bWeeklyComplete = KFPC.IsWeeklyEventComplete();
	WeeklyIndex = -1;

	if(bWeeklyComplete != bLastWeeklyComplete || !bInitialDataPopulated)
	{
		if (KFPC.WorldInfo.NetMode == NM_Client)
		{
			if (KFPC != none && KFGameReplicationInfo(KFPC.WorldInfo.GRI) != none)
			{
				WeeklyIndex = KFGameReplicationInfo(KFPC.WorldInfo.GRI).CurrentWeeklyIndex;
				WeeklyInfo = class'KFMission_LocalizedStrings'.static.GetWeeklyOutbreakInfoByIndex(WeeklyIndex);
			}
			else
			{
				GetPC().SetTimer(0.5f, false, nameof(PopulateData));
			}
		}
		else
		{
			WeeklyInfo = class'KFMission_LocalizedStrings'.static.GetCurrentWeeklyOutbreakInfo();
		}

		DataObject = CreateObject("Object");
		if(WeeklyInfo == none)
		{
			return false;
		}
		DataObject.SetString("label", "WeeklyInfo.FriendlyName");
		if(WeeklyInfo.ModifierDescriptions.length > 0)
    	{
			DataObject.SetString("description", "WeeklyInfo.DescriptionStrings[0]");
		}
		DataObject.SetString("iconPath", "img://"$WeeklyInfo.IconPath);

		DataObject.SetBool("complete", bWeeklyComplete);
		DataObject.SetBool("showProgres", false);
		DataObject.SetFloat("progress", 0);
		DataObject.SetString("textValue", "");
		
		SetObject("weeklyObjectiveData", DataObject);

		if (WeeklyInfo.ModifierDescriptions.Length > 0)
		{
			SetString("weeklyDescription", "WeeklyInfo.ModifierDescriptions[0]");
		}

		PopulateModifiers(WeeklyInfo);
		PopulateRewards(WeeklyInfo, WeeklyIndex);

		bLastWeeklyComplete = bWeeklyComplete;
		bInitialDataPopulated = true;
		return true;
	}

	return false;
}

function PopulateModifiers(KFWeeklyOutbreakInformation WeeklyInfo)
{
	local int i;
	local GFxObject DataObject;
	local GFxObject DataProvider; //array containing the data objects 

	if (WeeklyInfo == none || (GetPC().WorldInfo.NetMode == NM_Client && KFPC.WorldInfo.GRI == none))
	{
		return;
	}

	DataProvider = CreateArray();

	for (i = 0; i <  WeeklyInfo.ModifierDescriptions.length; i++)
	{
		DataObject = CreateObject("Object");
		DataObject.SetString("label", ""); //no lable at the moment
		DataObject.SetString("description", "description");
		DataProvider.SetElementObject(i, DataObject); //add it to the array
	}

	SetObject("modifiers", DataProvider); //pass to SWF
}

function GFxObject CreateRewardItem(KFWeeklyOutbreakInformation WeeklyInfo,int ItemID)
{
	local GFxObject DataObject;
	local int ItemIndex;
	local ItemProperties RewardItem;
	local OnlineSubsystem	OnlineSub;

	OnlineSub =  Class'GameEngine'.static.GetOnlineSubsystem();

	if(OnlineSub == none)
	{
		return none;
	}
	
	ItemIndex = OnlineSub.ItemPropertiesList.Find('Definition',ItemID);
	
	if( ItemIndex == INDEX_NONE ) 
	{
		`log("ItemID not found: " @ItemID);
		return none;
	}

	RewardItem = OnlineSub.ItemPropertiesList[ItemIndex];

	DataObject = CreateObject( "Object" );
				
	DataObject.SetString("label", "img://"$RewardItem.IconURL);
	DataObject.SetString("iconPath", "img://"$RewardItem.IconURL);

	return DataObject;
}

function LocalizeMenu()
{
    local GFxObject TextObject;

    TextObject = CreateObject("Object");
    // Localize static text
    TextObject.SetString("currentModifier",	"currentModifier");  
    TextObject.SetString("reward",			"reward");    
    TextObject.SetString("granted", 		"granted");  
    TextObject.SetString("weekly",			"weekly");  
    TextObject.SetString("overview",		"overview");  
    TextObject.SetString("vaultDosh",		"vaultDosh");  

    SetObject("localizedText", TextObject);
}