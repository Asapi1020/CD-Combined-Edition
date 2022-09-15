class CD_GFxMenu_Perks extends KFGFxMenu_Perks;

//	for Perk Restriction
function PerkChanged( byte NewPerkIndex, bool bClickedIndex)
{
	local class<KFPerk> Perk;
	local CD_GameReplicationInfo CDGRI;
	local CD_PlayerController CDPC;

	if(KFPC != none)
	{
		CDGRI = CD_GameReplicationInfo(KFPC.WorldInfo.GRI);
		CDPC = CD_PlayerController(KFPC);

		if(MyKFPRI != none && CDGRI != none)
		{
			Perk = KFPC.PerkList[NewPerkIndex].PerkClass;

			//	Level filter
			if(CDPC.IsRestrictedLevel(KFPC.PerkList[NewPerkIndex].PerkLevel))
				KFPC.ShowConnectionProgressPopup(PMT_AdminMessage,"Level Restriction", "Required level 25");

			//	Authorized Perk filter
			else if( CDPC.IsRestrictedPerk(Perk) )
				KFPC.ShowConnectionProgressPopup(PMT_AdminMessage,"PERK Restriction", "You are not authorized to use " $ Mid(string(Perk), 7));

			//	Sole Perks System
			else if( CDGRI.bMatchHasBegun && CDGRI.bEnableSolePerksSystem && !CDGRI.ControlSolePerks(KFPC, Perk) )
				KFPC.ShowConnectionProgressPopup(PMT_AdminMessage,"Perk Restriction", "The second" @ Mid(string(Perk), 7) @ "is not allowed!");

			else
				super.PerkChanged(NewPerkIndex, bClickedIndex);				
		}
	}
}

//	for skill restrict

function Callback_SkillSelected( byte TierIndex, byte SkillIndex )
{
	local int index;
	local class<KFPerk> Perk;

	if ( KFPC != none )
  	{
  		
		index = TierIndex*2 + SkillIndex - 1;
		Perk = KFPC.CurrentPerk.GetPerkClass();

		if( CD_PlayerController(KFPC).IsRestrictedSkill(Perk, index) )
		{
			KFPC.ShowConnectionProgressPopup(PMT_AdminMessage,"Skill Restriction", class'CD_PlayerController'.static.SkillBanMessage(Perk, index) @ "is banned");
			return;
		}
	  	
		super.Callback_SkillSelected(TierIndex, SkillIndex);
  	}
}

function Callback_ReadyClicked( bool bReady )
{
	local CD_PlayerController CDPC;

	CDPC = CD_PlayerController(GetPC());
	CD_GFxManager(CDPC.MyGFxManager).ReadyFilter(CDPC, bReady);
}