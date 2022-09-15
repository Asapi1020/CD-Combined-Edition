class CD_GFxMenu_Trader extends KFGFxMenu_Trader;

//	Restrict Perk
function Callback_PerkChanged(int PerkIndex)
{
	local class<KFPerk> Perk;
	local CD_GameReplicationInfo CDGRI;
	local CD_PlayerController CDPC;

	if(MyKFPC != none)
	{
		CDGRI = CD_GameReplicationInfo(MyKFPC.WorldInfo.GRI);
		CDPC = CD_PlayerController(MyKFPC);

		if(MyKFPRI != none && CDGRI != none)
		{
			Perk = MyKFPC.PerkList[PerkIndex].PerkClass;

			if( CDPC.IsRestrictedLevel(MyKFPC.PerkList[PerkIndex].PerkLevel) )
				MyKFPC.ShowConnectionProgressPopup(PMT_AdminMessage,"Level Restriction", "Required level 25");

			else if( CDPC.IsRestrictedPerk(Perk) )
				MyKFPC.ShowConnectionProgressPopup(PMT_AdminMessage,"PERK Restriction", "You are not authorized to use " $ Mid(string(Perk), 7));

			else if(CDGRI.bMatchHasBegun && CDGRI.bEnableSolePerksSystem && !CDGRI.ControlSolePerks(MyKFPC, Perk))
				MyKFPC.ShowConnectionProgressPopup(PMT_AdminMessage,"Perk Restriction", "The second" @ Mid(string(Perk), 7) @ "is not allowed!");

			else
				super.Callback_PerkChanged(PerkIndex);				
		}
	}
}

defaultproperties
{
	SubWidgetBindings(2)=(WidgetName="ShopContainer",WidgetClass=Class'CombinedCD2.CD_GFxTraderContainer_Store')
	SubWidgetBindings(5)=(WidgetName="itemDetailsContainer",WidgetClass=class'CombinedCD2.CD_GFxTraderContainer_ItemDetails')
}