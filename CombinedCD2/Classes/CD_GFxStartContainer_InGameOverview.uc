class CD_GFxStartContainer_InGameOverview extends KFGFxStartContainer_InGameOverview
	dependson(KFUnlockManager);

function UpdateGameMode( string Mode )
{
	SetString("gameMode", "Controlled Difficulty");
}