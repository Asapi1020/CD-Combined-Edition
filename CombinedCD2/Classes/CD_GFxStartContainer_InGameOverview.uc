class CD_GFxStartContainer_InGameOverview extends KFGFxStartContainer_InGameOverview
	dependson(KFUnlockManager);

function UpdateGameMode( string Mode )
{
	SetString("gameMode", "Controlled Difficulty");
}

function UpdateMap( string MapName, string MapSource )
{
	super.UpdateMap(class'CD_Object'.static.GetCustomMapName(MapName), MapSource);
}