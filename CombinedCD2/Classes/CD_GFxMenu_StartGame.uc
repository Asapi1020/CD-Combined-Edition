class CD_GFxMenu_StartGame extends KFGFxMenu_StartGame
	dependson(TWOnlineLobby);

function Callback_ReadyClicked( bool bReady )
{
	local CD_PlayerController CDPC;

	CDPC = CD_PlayerController(GetPC());
	CD_GFxManager(CDPC.MyGFxManager).ReadyFilter(CDPC, bReady);
}

defaultproperties
{
	SubWidgetBindings.(3)=(WidgetName="overviewContainer",WidgetClass=class'CD_GFxStartContainer_InGameOverview')
	// SubWidgetBindings.Remove((WidgetName="dailyContainerMC",WidgetClass=class'KFGFxDailyObjectivesContainer'))
	// SubWidgetBindings.Remove((WidgetName="weeklyContainerMC",WidgetClass=class'KFGFxWeeklyObjectivesContainer'))
	// SubWidgetBindings.Remove((WidgetName="missionObjectivesContainerMC",WidgetClass=class'KFGFxMissionObjectivesContainer'))
	// SubWidgetBindings.Remove((WidgetName="collapsedMissionObjectivesMC",WidgetClass=class'KFGFxCollapsedObjectivesContainer'))
   	// SubWidgetBindings.Remove((WidgetName="specialEventContainerMC",WidgetClass=class'KFGFxSpecialeventObjectivesContainer'))
	// SubWidgetBindings.Remove((WidgetName="expandedMissionObjectivesMC",WidgetClass=class'KFGFxExpandedObjectivesContainer'))
}