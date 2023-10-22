//=============================================================================
// CD_WaveInfoUtils
//=============================================================================
// Static helper methods for displaying SpawnCycles/CD_AIWaveInfos
//=============================================================================

class CD_WaveInfoUtils extends Object;

/*
 * Print the exact list of squads in each wave of the
 * supplied WaveInfos, one wave per line.
 *
 * Verbosity controls the level of abbreviation, if any,
 * applied to zed names.  Can be tiny, full, or short.
 */
static function PrintSpawnDetails(
	const out array<CD_AIWaveInfo> WaveInfos,
	const string Verbosity,
	const CD_ConsolePrinter CDCP )
{
	local int WaveIndex, SquadIndex, ElemIndex;
	local string s;
	local CD_AIWaveInfo WaveInfo;
	local CD_AISpawnSquad ss;
	local array<string> SquadList;
	local array<string> ElemList;
	local string ZedNameTmp;

	for ( WaveIndex = 0; WaveIndex < WaveInfos.length; WaveIndex++ )
	{
		WaveInfo = WaveInfos[WaveIndex];
		SquadList.length = 0;

		for ( SquadIndex = 0; SquadIndex < WaveInfo.CustomSquads.length; SquadIndex++ )
		{
			ss = WaveInfo.CustomSquads[SquadIndex];
			ElemList.length = 0;

			for ( ElemIndex = 0; ElemIndex < ss.CustomMonsterList.length; ElemIndex++ )
			{
				class'CD_ZedNameUtils'.static.GetZedName( Verbosity, ss.CustomMonsterList[ElemIndex], ZedNameTmp );

				if ( ZedNameTmp == "" )
				{
					ZedNameTmp = string( ss.CustomMonsterList[ElemIndex].Type );
				}

				ElemList.AddItem(string( ss.CustomMonsterList[ElemIndex].Num ) $ ZedNameTmp);
			}

			JoinArray( ElemList, s, "_" );
			SquadList.AddItem( s );
		}

		JoinArray( SquadList, s, ", " );
		CDCP.Print( "["$class'CD_StringUtils'.static.GetShortWaveNameByIndex( WaveIndex )$"] "$s, false );
	}
}

/*
 * Project how many of each type of zed would spawn for each
 * wave in the supplied WaveInfos, at the supplied GameLength,
 * for the supplied total PlayerCount and difficulty settings.
 *
 * Also display a grand total line summing zed categories from
 * all waves (except the boss wave).
 */
static function string PrintSpawnSummaries(
	const out array<CD_AIWaveInfo> WaveInfos,
	int PlayerCount,
	const out CD_ConsolePrinter CDCP,
	const int GameLength,
	const out CD_DifficultyInfo CustomDifficultyInfo,
	const out DifficultyWaveInfo DWS )
{
	local int WaveIndex;
	local CD_AIWaveInfo WaveInfo;
	local CD_WaveSummary WaveSummary, GameSummary;
	local string WaveSummaryString, OutputText;

	if ( PlayerCount <= 0 )
	{
		PlayerCount = 1;
	}

	GameSummary = new class'CD_WaveSummary';
	OutputText = "";

	for ( WaveIndex = 0; WaveIndex < WaveInfos.length; WaveIndex++ )
	{
		WaveInfo = WaveInfos[WaveIndex];

		WaveSummaryString = "";

		WaveSummary = new class'CD_WaveSummary';

		GetCDWaveSummary( WaveInfo, WaveIndex, PlayerCount, GameLength, CustomDifficultyInfo, DWS, WaveSummary );
		GameSummary.AddParamToSelf( WaveSummary );
		WaveSummaryString = WaveSummary.GetString();

		OutputText $= "["$class'CD_StringUtils'.static.GetShortWaveNameByIndex( WaveIndex )$"] "$WaveSummaryString$"\n";
	}
	OutputText $= " #{00ff00}>>#{NOPARSE} Projected Game Totals:\n" $
				  "         " $ GameSummary.GetString() $ "\n" $
				  " #{00ff00}>>#{NOPARSE} Boss wave not included in preceding tally.";
	return OutputText;
}

private static function GetCDWaveSummary(
	const out CD_AIWaveInfo WaveInfo,
	const int WaveIndex,
	const int PlayerCount,
	const int GameLength,
	const out CD_DifficultyInfo CustomDifficultyInfo,
	const out DifficultyWaveInfo DWS,
	out CD_WaveSummary result )
{
	local int WaveTotalAI;
	local int squadIndex;
	local CD_AISpawnSquad CDSquad;
	local array<AISquadElement> CustomMonsterList;
	local int elemIndex, remainingBudget, zedsFromElement;


	WaveTotalAI = DWS.Waves[WaveIndex].MaxAI *
	              CustomDifficultyInfo.GetRawPlayerNumMaxAIModifier( PlayerCount ) *
	              CustomDifficultyInfo.GetDifficultyMaxAIModifier();
	
	result.Clear();

	squadIndex = 0;

	while ( result.GetTotal() < WaveTotalAI )
	{
		CDSquad = WaveInfo.CustomSquads[squadIndex++ % WaveInfo.CustomSquads.length];

		CDSquad.CopyAISquadElements( CustomMonsterList );

		for ( elemIndex = 0; elemIndex < CustomMonsterList.length; elemIndex++ )
		{

			remainingBudget = WaveTotalAI - result.GetTotal();

			if ( remainingBudget <= 0 )
			{
				break;
			}

			zedsFromElement = Min( CustomMonsterList[elemIndex].Num, remainingBudget );

			result.Increment( CustomMonsterList[elemIndex], zedsFromElement );
		}
	}
}


