class UTM_GFxMenu_StartGame extends CD_GFxMenu_StartGame
	dependson(TWOnlineLobby);

defaultproperties
{
	SubWidgetBindings.(3)=(WidgetName="overviewContainer",WidgetClass=class'UTM_GFxStartContainer_InGameOverview')
}