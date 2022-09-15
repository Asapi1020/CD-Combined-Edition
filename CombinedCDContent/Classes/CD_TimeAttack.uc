class CD_TimeAttack extends CD_Survival
	config( CombinedCDContent );

var byte ActualWaveNum;

function StartMatch()
{
	ActualWaveNum = 0;

	super.StartMatch();

	SpawnManager.bTemporarilyEndless = true;
	MyKFGRI.bWaveIsEndless = true;
	SetTimer(180.f, false, 'EndCurrentWave');
}

state TraderOpen
{
	local KFPlayerController KFPC;

	function BeginState(name PreviousStateName)
	{
		MyKFGRI.SetWaveActive(false, GetGameIntensityForMusic());

		ForEach WorldInfo.AllControllers(class'KFPlayerController', KFPC)
		{
			if( KFPC.GetPerk() != none )
			{
				KFPC.GetPerk().OnWaveEnded();
			}
			KFPC.ApplyPendingPerks();
		}

		StartHumans();

		OpenTrader();

		if ( AllowBalanceLogging() )
		{
			LogPlayersDosh(GBE_TraderOpen);
		}

		SetTimer(TimeBetweenWaves, false, nameof(CloseTraderTimer));
	}

	function EndState(name NextStateName)
	{
		StartHumans();
		super.EndState(NextStateName);
		SetTimer(180.f, false, 'EndCurrentWave');
	}
}

function WaveEnded( EWaveEndCondition WinCondition )
{
	local string CDSettingChangeMessage;

	if(WinCondition == WEC_TeamWipedOut)
		SaveFinalSettings();

	super(KFGameInfo_Survival).WaveEnded( WinCondition );

	if ( ApplyStagedConfig( CDSettingChangeMessage, "Staged settings applied:" ) )
	{
		BroadcastCDEcho( CDSettingChangeMessage );
		RefleshWebInfo();
	}
}

function StartWave()
{
	ActualWaveNum++;
	if(WaveNum == 10)
	{
		WaveNum = 9;
		MyKFGRI.WaveNum = ActualWaveNum;
	}

	super.StartWave();
}

exec function EndCurrentWave()
{
	ClearTimer('EndCurrentWave');
	WaveEnded(WEC_WaveWon);
}

exec function SetWave(byte NewWaveNum)
{
	return;
}

exec function WinMatch()
{
	return;
}

defaultproperties
{
	DifficultyInfoClass=class'CombinedCDContent.CD_DifficultyInfo_TimeAttack'
}