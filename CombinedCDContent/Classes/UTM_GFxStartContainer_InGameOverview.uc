class UTM_GFxStartContainer_InGameOverview extends KFGFxStartContainer_InGameOverview
	dependson(KFUnlockManager);

function UpdateGameMode( string Mode )
{
	SetString("gameMode", "Ultimate Test Mode");
}