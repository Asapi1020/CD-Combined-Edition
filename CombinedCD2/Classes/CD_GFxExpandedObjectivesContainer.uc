class CD_GFxExpandedObjectivesContainer extends KFGFxExpandedObjectivesContainer;

function FullRefresh()
{
	if (WeeklyEventContainer != None)
	{
		WeeklyEventContainer.Initialize(StartMenu);
	}
}