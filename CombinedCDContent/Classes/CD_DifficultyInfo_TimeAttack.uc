class CD_DifficultyInfo_TimeAttack extends CD_DifficultyInfo;

function float GetTraderTimeByDifficulty()
{
	return super(KFGameDifficulty_Survival).GetTraderTimeByDifficulty();
}