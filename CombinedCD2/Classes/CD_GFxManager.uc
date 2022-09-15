class CD_GFxManager extends KFGFxMoviePlayer_Manager;

function LaunchMenus( optional bool bForceSkipLobby )
{
	local int index;

	super.LaunchMenus(bForceSkipLobby);

	index = WidgetBindings.Find('WidgetName', 'optionsGraphicsMenu'	);
	switch( class'KFGameEngine'.static.GetPlatform() )
	{
		case PLATFORM_PC_DX10:
			WidgetBindings[index].WidgetClass = class'CD_GFxOptionsMenu_Graphics_DX10';
			break;
		default:
			WidgetBindings[index].WidgetClass = class'CD_GFxOptionsMenu_Graphics';
	}
}

function ReadyFilter(CD_PlayerController CDPC, bool bReady)
{
	local CD_GameReplicationInfo CDGRI;
	local KFPlayerReplicationInfo KFPRI;
	local class<KFPerk> Perk;

	CDGRI = CD_GameReplicationInfo(CDPC.WorldInfo.GRI);
	KFPRI = KFPlayerReplicationInfo(CDPC.PlayerReplicationInfo);
	Perk = CDPC.GetPerk().GetPerkClass();

	if(KFPRI == none)
		return;
	`Log("FILTER TRY");
	if(CDGRI.bMatchHasBegun)
	{
		if (CDGRI.bTraderIsOpen && KFPRI.bHasSpawnedIn)
		{
			if(bMenusOpen && CurrentMenu != TraderMenu)
			{
				if(CD_PlayerReplicationInfo(KFPRI).bIsReadyForNextWave)
					CDPC.Say("!cdur");
				
				else
					CDPC.Say("!cdr");

				if(PartyWidget !=none)
    				PartyWidget.RefreshParty();
				CloseMenus();
			}
		}
		else
		{
			bReady = bReady && ( !CDGRI.bEnableSolePerksSystem || (Perk != class'KFPerk_Commando' && Perk != class'KFPerk_FieldMedic')/* ||
					 CDGRI.ControlSolePerks(KFPRI, Perk)*/ );

			KFPRI.SetPlayerReady(bReady);
			CloseMenus();
			CDPC.ServerRestartPlayer();
		}
	}

	else
	{
		bReady = bReady && ( !CDGRI.bEnableSolePerksSystem || (Perk != class'KFPerk_Commando' && Perk != class'KFPerk_FieldMedic') /*||
				 CDPC.ControlSolePerks(KFPRI, Perk)*/ );

		if(!bReady)
			`Log("Filtered");	

		KFPRI.SetPlayerReady(bReady);

    	if(PartyWidget !=none)
    		PartyWidget.RefreshParty();
		
		if(StartMenu != none && bReady)
			StartMenu.OnPlayerReadiedUp();
		
		if(PerksMenu != none)
			PerksMenu.SelectionContainer.SetPerkListEnabled(!bReady);
	}
}

defaultproperties
{
	InGamePartyWidgetClass = class'CD_GFxWidget_PartyInGame'

	WidgetBindings(10)=(WidgetName="startMenu",WidgetClass=class'CD_GFxMenu_StartGame')
	WidgetBindings(11)=(WidgetName="exitMenu",WidgetClass=class'CD_GFxMenu_Exit')
	WidgetBindings(12)=(WidgetName="PerksMenu",WidgetClass=class'CD_GFxMenu_Perks')
	WidgetBindings(15)=(WidgetName="storeMenu",WidgetClass=class'CD_GFxMenu_Store')
	WidgetBindings(16)=(WidgetName="optionsSelectionMenu",WidgetClass=class'CD_GFxOptionsMenu_Selection')
	WidgetBindings(17)=(WidgetName="optionsControlsMenu",WidgetClass=class'CD_GFxOptionsMenu_Controls')
	WidgetBindings(18)=(WidgetName="optionsAudioMenu",WidgetClass=class'CD_GFxOptionsMenu_Audio')
	WidgetBindings(19)=(WidgetName="optionsGameSettingsMenu",WidgetClass=class'CD_GFxOptionsMenu_GameSettings')
	WidgetBindings(21)=(WidgetName="traderMenu",WidgetClass=class'CD_GFxMenu_Trader')
	WidgetBindings(22)=(WidgetName="ChatBoxWidget",WidgetClass=class'CD_GFxHUD_ChatBoxWidget')
}