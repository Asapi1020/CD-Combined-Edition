class CD_ZT_SpawnManager extends Object
	within CD_Survival;

`include(CD_Log.uci)

public function HandleZTSpawnMode(){
	if ( Outer.ZTSpawnModeEnum == ZTSM_CLOCKWORK )
	{
		// Tweak the dilation (but do not reset)
		TuneSpawnManagerTimer();
	}
	else
	{
		// Restart the timer (but do not tweak the dilation)
		SetSpawnManagerTimer();
	}
}

public function SetSpawnManagerTimer( const optional bool ForceReset = true )
{
	if ( ForceReset || !IsTimerActive('SpawnManagerWakeup') )
	{
		// Timer does not exist, set it
		`cdlog("Setting independent SpawnManagerWakeup timer (" $ Outer.SpawnPollFloat $")", Outer.bLogControlledDifficulty);
		SetTimer(Outer.SpawnPollFloat, true, 'SpawnManagerWakeup');
	}
}

private function TuneSpawnManagerTimer()
{
	local float LocalDilation;
	local float SlowDivisor;

	LocalDilation = 1.f / WorldInfo.TimeDilation;
	if ( ZedTimeRemaining > 0.f && ZTSpawnSlowdownFloat > 1.f )
	{
		if ( ZedTimeRemaining < ZedTimeBlendOutTime )
		{
			// if zed time is running out, interpolate between [1.0, ZTSS] using the same lerp-alpha-factor that TickZedTime uses
			// When zed time first starts to fade, we will use a divisor slightly less than ZTSS
			// When zed time is on the last tick before it is completely over, we will use a divisor slightly more than 1.0
			// IOW, the divisor decreases towards one as zed time fades out
			// See TickZedTime in KFGameInfo for background
			SlowDivisor = Lerp(1.0, ZTSpawnSlowdownFloat, ZedTimeRemaining / ZedTimeBlendOutTime);
		}
		else
		{
			// if zed time is going strong, just use ZTSS
			SlowDivisor = ZTSpawnSlowdownFloat;
		}

		LocalDilation = LocalDilation / SlowDivisor;

		`cdlog("SpawnManagerWakeup's slowed clockwork timedilation: " $ LocalDilation $ " (ZTSS=" $ SlowDivisor $ ")", Outer.bLogControlledDifficulty);
	}
	else
	{
		`cdlog("SpawnManagerWakeup's realtime clockwork timedilation: " $ LocalDilation, Outer.bLogControlledDifficulty);
	}

	Outer.ModifyTimerTimeDilation('SpawnManagerWakeup', LocalDilation, self);
}

private function SpawnManagerWakeup()
{
	if ( Outer.SpawnManager != none )
	{
		Outer.SpawnManager.Update();
	}
}