class CD_GFxMoviePlayer_HUD extends KFGFxMoviePlayer_HUD;

function ShowObjectiveContainer(string title, string body)
{
	local CD_GFxHUD_ObjectiveConatiner CDOC;

	if(WaveInfoWidget.ObjectiveContainer != none)
	{
		CDOC = CD_GFxHUD_ObjectiveConatiner(WaveInfoWidget.ObjectiveContainer);
		if(CDOC != none)
			CDOC.SetObjectiveContainer(title, body);
	}
}

defaultproperties
{
	WidgetBindings(0)=(WidgetName="ObjectiveContainer",WidgetClass=class'CD_GFxHUD_ObjectiveConatiner')
	WidgetBindings(11)=(WidgetName="ChatBoxWidget",WidgetClass=class'CD_GFxHUD_ChatBoxWidget')
}