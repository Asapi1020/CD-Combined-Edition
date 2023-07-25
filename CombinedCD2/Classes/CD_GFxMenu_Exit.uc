class CD_GFxMenu_Exit extends KFGFxMenu_Exit;

var localized string GratitudeString;

function ShowExitToOSPopUp()
{
	if(Manager != none)
	{
		if( class'WorldInfo'.static.IsConsoleBuild(CONSOLE_Durango) )
		{
			Manager.DelayedOpenPopup(EConfirmation, EDPPID_Misc, HeaderString, GratitudeString,
				Class'KFCommon_LocalizedStrings'.default.ConfirmString, Class'KFCommon_LocalizedStrings'.default.CancelString, OnLogoutConfirm);
		}
		else
		{
			Manager.DelayedOpenPopup(EConfirmation, EDPPID_Misc, HeaderString, GratitudeString,
				Class'KFCommon_LocalizedStrings'.default.ConfirmString, Class'KFCommon_LocalizedStrings'.default.CancelString, OnQuitConfirm );
		}
	}
}

function OnLogoutConfirm()
{
	KFGameEngine(class'Engine'.static.GetEngine()).PerformLogout();
}

function OnQuitConfirm()
{
	consolecommand("quit");
}

function ShowLeaveGamePopUp()
{
	if(Manager != none )
	{
		Manager.DelayedOpenPopup(EConfirmation, EDPPID_Misc, class'KFGame.KFGFxObject_Menu'.default.LeavePartyTitleString, GratitudeString,
	 		Class'KFCommon_LocalizedStrings'.default.ConfirmString, Class'KFCommon_LocalizedStrings'.default.CancelString, OnLeaveGameConfirm);
	}	
}

function Callback_ReadyClicked( bool bReady )
{
	local CD_PlayerController CDPC;

	CDPC = CD_PlayerController(GetPC());
	CD_GFxManager(CDPC.MyGFxManager).ReadyFilter(CDPC, bReady);
}