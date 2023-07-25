class CD_GFxWidget_PartyInGame extends KFGFxWidget_PartyInGame;

var localized string CDReadyButton;

function UpdateReadyButtonText()
{
	Local bool bIsConsole;
	local string ButtonText;

	if (ReadyButton != none)
	{
		bIsConsole = GetPC().WorldInfo.IsConsoleBuild();
		ButtonText = CDReadyButton;

		if(bIsConsole && bShowingSkipTrader)
		{
			ReadyButton.SetString("label", ("  " @ ButtonText));
		}
		else
		{
			ReadyButton.SetString("label", bShowingSkipTrader ? ButtonText : default.ReadyString);
		}
	}
}

function RefreshParty()
{
	super.RefreshParty();

	if(PartyChatWidget != none)
		PartyChatWidget.SetLobbyChatVisible(true);
}