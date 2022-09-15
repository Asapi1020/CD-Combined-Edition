/////////////////////////////////////////////////////////////////////////////////////////
// CD STATS SYSTEM
/////////////////////////////////////////////////////////////////////////////////////////
// Most of the stats here are already tracked by the game for use with GameConductor,
// AnalyticsLog, or end of match awards, this exposes that information to players upon
// request via chat commands. Extensions have been made for persistent stat tracking with
// the magicked admin tool or anything else that parses chat logs.
/////////////////////////////////////////////////////////////////////////////////////////

class CD_StatsSystem extends Object
	within CD_Survival
	DependsOn(CD_Survival);

struct StructCDPlayerStats
{
	var string PlayerName;
	
	var int DoshEarned;
	var int DamageDealt;
	var int DamageTaken;
	var int HealsGiven;
	var int HealsRecv;
	var int LargeKills;
	var int ShotsFired;
	var int ShotsHit;
	var int HeadShots;
	var float Accuracy;	
	var float HSAccuracy;

	var int SCKills;
	var int FPKills;
	var int QPKills;
	var int HUKills;
};
	
var array<StructCDPlayerStats> CDPlayerStats;

var int StatsCount;


// Called when !cdstats <stat> chat command is used
function string CDStatsCommand(string CommandString)
{
	local array<string> params;
	local string Stat;
	local string Output;
	local int i;
	
	ParseStringIntoArray( CommandString, params, " ", true );
	Stat = Locs(params[1]);
	
	// refresh CDPlayerStats array
	GetCDPlayerStats();	
	
	// This is a messy but functional implementation
	// I wouldn't rule out future optimization
	
	if ( WaveNum < 1 )
	{
		return ("The crystal ball is broken. Try again after the first wave has started.");
	}
	
	if (Left( Stat, 3 ) == "acc")
	{
		CDPlayerStats.Sort(ByAccuracy);
		
		Output = "--- Accuracy ------------------------------------------";
		
		for (i = 0; i < CDPlayerStats.Length; i++)
		{
			Output = Output $ "\n" $ i+1 $ ") - " $ round(CDPlayerStats[i].Accuracy) $ "% - " $ CDPlayerStats[i].PlayerName ;
		}
		
	}
	else if (Left( Stat, 7 ) == "damaged" || Left( Stat, 4 ) == "dmgd")
	{		
		CDPlayerStats.Sort(ByDamageDealt);
		
		Output = "--- Damage Dealt ----------------------------------";
		
		for (i = 0; i < CDPlayerStats.Length; i++)
		{
			Output = Output $ "\n" $ i+1 $ ") - " $ CDPlayerStats[i].DamageDealt $ " - " $ CDPlayerStats[i].PlayerName ;
		}
	}
	else if (Left( Stat, 7 ) == "damaget" || Left( Stat, 4 ) == "dmgt")
	{		
		CDPlayerStats.Sort(ByDamageTaken);
		
		Output = "--- Damage Taken ----------------------------------";
		
		for (i = 0; i < CDPlayerStats.Length; i++)
		{
			Output = Output $ "\n" $ i+1 $ ") - " $ CDPlayerStats[i].DamageTaken $ " - " $ CDPlayerStats[i].PlayerName ;
		}
	}
	else if (Left( Stat, 4 ) == "dosh")
	{
		CDPlayerStats.Sort(ByDoshEarned);
		
		Output = "-- Dosh Earned ---------------------------------------";
		
		for (i = 0; i < CDPlayerStats.Length; i++)
		{		
			Output = Output $ "\n" $ i+1 $ ") - " $ CDPlayerStats[i].DoshEarned $ " - " $ CDPlayerStats[i].PlayerName ;
		}
	}
	else if ( Left( Stat, 9 ) == "headshota" || Left( Stat, 5 ) == "hsacc")
	{
		CDPlayerStats.Sort(ByHeadshotAccuracy);
		
		Output = "-- Headshot Accuracy ----------------------------";

		for (i = 0; i < CDPlayerStats.Length; i++)
		{
			Output = Output $ "\n" $ i+1 $ ") - " $ round(CDPlayerStats[i].HSAccuracy) $ "% - " $ CDPlayerStats[i].PlayerName ;
		}
	}
	else if ( Left( Stat, 9 ) == "headshots" || Left( Stat, 2 ) == "hs" )
	{
		CDPlayerStats.Sort(ByHeadshots);
		
		Output = "-- Headshots ------------------------------------------";

		for (i = 0; i < CDPlayerStats.Length; i++)
		{
			Output = Output $ "\n" $ i+1 $ ") - " $ CDPlayerStats[i].Headshots $ "[" $ round(CDPlayerStats[i].HSAccuracy) $ "%] - " $ CDPlayerStats[i].PlayerName ;
		}
	}
	else if (Left( Stat, 6 ) == "healsg")
	{
		CDPlayerStats.Sort(ByHealsGiven);
		
		Output = "-- Heals Given ----------------------------------------";
		
		for (i = 0; i < CDPlayerStats.Length; i++)
		{
			Output = Output $ "\n" $ i+1 $ ") - " $ CDPlayerStats[i].HealsGiven $ " - " $ CDPlayerStats[i].PlayerName ;
		}
	}
	else if (Left( Stat, 6 ) == "healsr")
	{
		CDPlayerStats.Sort(ByHealsReceived);
		
		Output = "-- Heals Received -----------------------------------";
		
		for (i = 0; i < CDPlayerStats.Length; i++)
		{
			Output = Output $ "\n" $ i+1 $ ") - " $ CDPlayerStats[i].HealsRecv $ " - " $ CDPlayerStats[i].PlayerName ;
		}
	}
	else if (Left( Stat, 4 ) == "larg")
	{
		CDPlayerStats.Sort(ByLargeKills);
		
		Output = "-- Large Kills -------------------------------------------";
		
		for (i = 0; i < CDPlayerStats.Length; i++)
		{
			Output = Output $ "\n" $ i+1 $ ") - " $ CDPlayerStats[i].LargeKills $ " (SC:" $ CDPlayerStats[i].SCKills $ " FP:" $ CDPlayerStats[i].FPKills $ " QP:" $ CDPlayerStats[i].QPKills $ ") - " $ CDPlayerStats[i].PlayerName ;
		}
	}
	else if (Left( Stat, 6 ) == "shotsf")
	{
		CDPlayerStats.Sort(ByShotsFired);
		
		Output = "-- Shots Fired ------------------------------------------";
		
		for (i = 0; i < CDPlayerStats.Length; i++)
		{
			Output = Output $ "\n" $ i+1 $ ") - " $ CDPlayerStats[i].ShotsFired $ " - " $ CDPlayerStats[i].PlayerName ;
		}
	}
	else if (Left( Stat, 6 ) == "shotsh")
	{
		CDPlayerStats.Sort(ByShotsHit);
		
		Output = "-- Shots Hit ---------------------------------------------";
		
		for (i = 0; i < CDPlayerStats.Length; i++)
		{
			Output = Output $ "\n" $ i+1 $ ") - " $ CDPlayerStats[i].ShotsHit $ "("$ round(CDPlayerStats[i].Accuracy) $"%) - " $ CDPlayerStats[i].PlayerName ;
		}
	}
	else if (Left( Stat, 2 ) == "hu")
	{
		CDPlayerStats.Sort(ByHUKills);
		
		Output = "-- Husk Kills ---------------------------------------------";
		
		for (i = 0; i < CDPlayerStats.Length; i++)
		{
			Output = Output $ "\n" $ i+1 $ ") - " $ CDPlayerStats[i].HUKills $ " - " $  CDPlayerStats[i].PlayerName ;
		}
	}
	
	else
	{
		Output = "PEBCAK! Available stats are:\nAccuracy, DamageDealt, DamageTaken, DoshEarned, Headshots, HeadshotAccuracy, HealsGiven, HealsReceived, Large Kills, Husk Kills, ShotsFired, and ShotsHit.";
	}
	
	return Output;
}

/*
 * called by !cdmystats command, since we can't use local vars in an event
 * These stats are already collected for us through EphemeralMatchStats and weapons and in player controller
 * for GameConductor and end of match awards so we might as well make them available to players on request.
 * This command doesn't make use of GetCDPlayerStats() because populating an array of structs to return values for
 * just one of the array entries is a waste of resources.
 *
 * Notes:
 *	- unlike most other MatchStats, TotalLargeZedKills is updated regularly instead of on per-wave basis #TWIthings
 *	- KFPlayerController.ShotsHit always counts on a per-pellet basis, there is no TWI implemented alternative to how this is tracked.
 */
function string GetIndividualPlayerStats(KFPlayerController KFPC)
{
	local string PlayerStats;
	local array<ZedKillType> PersonalStats;
	local ZedKillType Status;
	
	local int LargeKills,
			  HealsGiven,
			  HealsRecv,
			  DamageDealt,
			  DamageTaken,
			  ShotsFired,
			  ShotsHit,
			  HeadShots,

			  SCKills,
			  FPKills,
			  QPKills,
			  HUKills;
			  
	PlayerStats = "";
	
	if (!KFPC.PlayerReplicationInfo.bOnlySpectator && !KFPC.PlayerReplicationInfo.bDemoOwner)
	{
//		DoshEarned = KFPC.MatchStats.TotalDoshEarned + KFPC.MatchStats.GetDoshEarnedInWave();	
		LargeKills = KFPC.MatchStats.TotalLargeZedKills;
		HealsGiven = KFPC.MatchStats.TotalAmountHealGiven + KFPC.MatchStats.GetHealGivenInWave();
		HealsRecv  = KFPC.MatchStats.TotalAmountHealReceived + KFPC.MatchStats.GetHealReceivedInWave();
		DamageDealt= KFPC.MatchStats.TotalDamageDealt + KFPC.MatchStats.GetDamageDealtInWave();
		DamageTaken= KFPC.MatchStats.TotalDamageTaken + KFPC.MatchStats.GetDamageTakenInWave();
		ShotsFired = KFPC.ShotsFired;
		
		ShotsHit   = KFPC.ShotsHit;
		
		if (Outer.bCountHeadshotsPerPellet)
		{
			Headshots = KFPC.ShotsHitHeadshot;
		}
		else
		{
			HeadShots  = KFPC.MatchStats.TotalHeadShots + KFPC.MatchStats.GetHeadShotsInWave();
		}

		PersonalStats = KFPC.MatchStats.ZedKillsArray;
		foreach PersonalStats(Status)
		{
			switch(Status.MonsterClass)
			{
				case class'KFGameContent.KFPawn_ZedScrake':
					SCKills = Status.KillCount;
					break;
				case class'KFGameContent.KFPawn_ZedFleshpound':
					FPKills = Status.KillCount;
					break;
				case class'KFGameContent.KFPawn_ZedFleshpoundMini':
					QPKills = Status.KillCount;
					break;
				case class'KFGameContent.KFPawn_ZedHusk':
					HUKills = Status.KillCount;
					break;
			}
		}
		
		PlayerStats = "Stats for " $ KFPC.PlayerReplicationInfo.PlayerName $ ": \n" $
					"Large Kills: " $ LargeKills $ " (SC:" $ SCKills $ " FP:" $ FPKills $ " QP:" $ QPKills $ ")\n" $
					"Husk Kills: " $ HUKills $ "\n" $
					"Heals - Given: " $ HealsGiven $ " Received: " $ HealsRecv $ "\n" $
					"Damage - Dealt: " $ DamageDealt $ " Taken: " $ DamageTaken $ "\n" $
//					"Shots - Fired: " $ ShotsFired $ " Hit: " $ ShotsHit $ "HS: " $ HeadShots $ "\n" $
					"Accuracy - Hit: ";
		
		// make sure we return a positive value or 0 for accuracy rather than attempting to divide with zero.
		if (ShotsHit < 1 || ShotsFired == 0)
		{
			PlayerStats = PlayerStats $ "0% HeadShots: ";
		}
		else
		{
			PlayerStats = PlayerStats $ round(Float(ShotsHit)/Float(ShotsFired) * 100.0) $ "% HeadShots: ";
		}
		// make sure we return a positive value or 0 for headshot accuracy rather than attempting to divide with zero.
		if (ShotsHit < 1 || ShotsFired == 0 || HeadShots < 1)
		{
			PlayerStats = PlayerStats $ "0%";
		}
		else
		{
			PlayerStats = PlayerStats $ round(Float(HeadShots)/Float(ShotsHit) * 100.0) $ "%";
		}
			
		return PlayerStats;
	}
	else
	{	// Provide obligatory sass to people using this command when they shouldn't.
		return "You've spectated really hard, but that doesn't count for anything.";
	}
}

///////////////////////
// SORTING FUNCTIONS //
///////////////////////

// this section can probably be reduced to two functions and I may do that in a future update.

private function int ByAccuracy( StructCDPlayerStats a, StructCDPlayerStats b )
{
	local int x;
	local int y;
	
	x = a.Accuracy;
	y = b.Accuracy;

	if ( x < y )
	{
		return -1;
	}
	else if ( x > y )
	{
		return 1;
	}
	return 0;
}


private function int ByDamageDealt( StructCDPlayerStats a, StructCDPlayerStats b )
{
	local int x;
	local int y;
	
	x = a.DamageDealt;
	y = b.DamageDealt;

	if ( x < y )
	{
		return -1;
	}
	else if ( x > y )
	{
		return 1;
	}
	return 0;
}

private function int ByDamageTaken( StructCDPlayerStats a, StructCDPlayerStats b )
{
	local int x;
	local int y;
	
	x = a.DamageTaken;
	y = b.DamageTaken;

	if ( x < y )
	{
		return 1;
	}
	else if ( x > y )
	{
		return -1;
	}
	return 0;
}

private function int ByDoshEarned( StructCDPlayerStats a, StructCDPlayerStats b )
{
	local int x;
	local int y;
	
	x = a.DoshEarned;
	y = b.DoshEarned;

	if ( x < y )
	{
		return -1;
	}
	else if ( x > y )
	{
		return 1;
	}
	return 0;
}

private function int ByHeadshots( StructCDPlayerStats a, StructCDPlayerStats b )
{
	local int x;
	local int y;
	
	x = a.Headshots;
	y = b.Headshots;

	if ( x < y )
	{
		return -1;
	}
	else if ( x > y )
	{
		return 1;
	}
	return 0;
}

private function int ByHeadshotAccuracy( StructCDPlayerStats a, StructCDPlayerStats b )
{
	local int x;
	local int y;
	
	x = a.HSAccuracy;
	y = b.HSAccuracy;

	if ( x < y )
	{
		return -1;
	}
	else if ( x > y )
	{
		return 1;
	}
	return 0;
}

private function int ByHealsGiven( StructCDPlayerStats a, StructCDPlayerStats b )
{
	local int x;
	local int y;
	
	x = a.HealsGiven;
	y = b.HealsGiven;

	if ( x < y )
	{
		return -1;
	}
	else if ( x > y )
	{
		return 1;
	}
	return 0;
}

private function int ByHealsReceived( StructCDPlayerStats a, StructCDPlayerStats b )
{
	local int x;
	local int y;
	
	x = a.HealsRecv;
	y = b.HealsRecv;

	if ( x < y )
	{
		return -1;
	}
	else if ( x > y )
	{
		return 1;
	}
	return 0;
}

private function int ByLargeKills( StructCDPlayerStats a, StructCDPlayerStats b )
{
	local int x;
	local int y;
	
	x = a.LargeKills;
	y = b.LargeKills;

	if ( x < y )
	{
		return -1;
	}
	else if ( x > y )
	{
		return 1;
	}
	return 0;
}

private function int ByShotsFired( StructCDPlayerStats a, StructCDPlayerStats b )
{
	local int x;
	local int y;
	
	x = a.ShotsFired;
	y = b.ShotsFired;

	if ( x < y )
	{
		return -1;
	}
	else if ( x > y )
	{
		return 1;
	}
	return 0;
}

private function int ByShotsHit( StructCDPlayerStats a, StructCDPlayerStats b )
{
	local int x;
	local int y;
	
	x = a.ShotsHit;
	y = b.ShotsHit;

	if ( x < y )
	{
		return -1;
	}
	else if ( x > y )
	{
		return 1;
	}
	return 0;
}

private function int ByHUKills( StructCDPlayerStats a, StructCDPlayerStats b )
{
	local int x;
	local int y;
	
	x = a.HUKills;
	y = b.HUKills;

	if ( x < y )
	{
		return -1;
	}
	else if ( x > y )
	{
		return 1;
	}
	return 0;
}

// We call this function to empty and repopulate the CDPlayerStats array of structs with fresh data from all connected players.
// players that reconnect will be given a new player controller so these stats are not retained through player reconnect. I may in the
// future check to see if they already exist in the array and add/replace their stats rather than clearing and repopulating. that seems
// like a fair amount of effort to account for something that shouldn't happen very often so it is not high on my priority list.

function GetCDPlayerStats()
{
	local KFPlayerController KFPC;
	local StructCDPlayerStats srs;

	local array<ZedKillType> PersonalStats;
	local ZedKillType Status;
	
	CDPlayerStats.Length = 0;
	
	foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC)
	{
		if ( KFPC != none && KFPC.bIsPlayer && !KFPC.PlayerReplicationInfo.bOnlySpectator && !KFPC.bDemoOwner )
		{
			srs.PlayerName = KFPC.PlayerReplicationInfo.PlayerName;
			srs.DoshEarned = KFPC.MatchStats.TotalDoshEarned + KFPC.MatchStats.GetDoshEarnedInWave();
			srs.LargeKills = KFPC.MatchStats.TotalLargeZedKills;
			srs.HealsGiven = KFPC.MatchStats.TotalAmountHealGiven + KFPC.MatchStats.GetHealGivenInWave();
			srs.HealsRecv  = KFPC.MatchStats.TotalAmountHealReceived + KFPC.MatchStats.GetHealReceivedInWave();
			srs.DamageDealt= KFPC.MatchStats.TotalDamageDealt + KFPC.MatchStats.GetDamageDealtInWave();
			srs.DamageTaken= KFPC.MatchStats.TotalDamageTaken + KFPC.MatchStats.GetDamageTakenInWave();
			srs.ShotsFired = KFPC.ShotsFired;
			srs.ShotsHit   = KFPC.ShotsHit;

			PersonalStats  = KFPC.MatchStats.ZedKillsArray;
			srs.SCKills = 0;
			srs.FPKills = 0;
			srs.QPKills = 0;
			srs.HUKills = 0;

			foreach PersonalStats(Status)
			{
				switch(Status.MonsterClass)
				{
					case class'KFGameContent.KFPawn_ZedScrake':
						srs.SCKills = Status.KillCount;
						break;
					case class'KFGameContent.KFPawn_ZedFleshpound':
						srs.FPKills = Status.KillCount;
						break;
					case class'KFGameContent.KFPawn_ZedFleshpoundMini':
						srs.QPKills = Status.KillCount;
						break;
					case class'KFGameContent.KFPawn_ZedHusk':
						srs.HUKills = Status.KillCount;
						break;
				}
			}
			

			// use toggle hs count per pellet or per shot
			// gameconductor uses per pellet but end of match award screen uses per shot
			if (Outer.bCountHeadshotsPerPellet)
			{
				srs.Headshots  = KFPC.ShotsHitHeadshot;
			}
			else
			{
				srs.HeadShots  = KFPC.MatchStats.TotalHeadShots + KFPC.MatchStats.GetHeadShotsInWave();
			}
			
			// prevent negative accuracy percentages
			if (srs.ShotsFired > 0 && srs.ShotsHit > 0)
			{
				srs.Accuracy   = (Float(srs.ShotsHit)/Float(srs.ShotsFired) * 100.0);
				srs.HSAccuracy = (Float(srs.Headshots)/Float(srs.ShotsHit) * 100.0);
			}
			else
			{
				srs.Accuracy   = 0;
				srs.HSAccuracy = 0;
			}
			
			CDPlayerStats.AddItem( srs );
		}
	}
}

// DumpToChatlog is called once in the WaveEnded event extended from TWI in CD_Survival.uc
// this feature was added by request so that MajickedAdmin and other such tools can parse stats collected here and persistently store them.
function string DumpToChatlog()
{
	local string Output;
	local int i;
	
	// All of these newlines are just to ensure we don't flood the chat-box as CD
	// will attempt to dump chat output to the chat-box if it's less than 7 lines.
	Output="\n\n\n\n\n\n------[ Match Stats BEGIN ]------";
	
	// refresh stats array
	GetCDPlayerStats();
		
	// take a dump for each player. Hurr, poop jokes.
	for (i = 0; i < CDPlayerStats.Length; i++)
	{
		Output = Output $ "\n"
						$ "PlayerName:"  $ CDPlayerStats[i].PlayerName 			$ "|"
						$ "DoshEarned:"  $ CDPlayerStats[i].DoshEarned 			$ "|"
						$ "DamageDealt:" $ CDPlayerStats[i].DamageDealt 		$ "|"
						$ "DamageTaken:" $ CDPlayerStats[i].DamageTaken 		$ "|"
						$ "HealsGiven:"  $ CDPlayerStats[i].HealsGiven 			$ "|"
						$ "HealsRecv:"   $ CDPlayerStats[i].HealsRecv 			$ "|"
						$ "LargeKills:"  $ CDPlayerStats[i].LargeKills 			$ "|"
						$ "ShotsFired:"  $ CDPlayerStats[i].ShotsFired 			$ "|"
						$ "ShotsHit:"    $ CDPlayerStats[i].ShotsHit			$ "|"
						$ "Accuracy:"    $ round(CDPlayerStats[i].Accuracy)		$ "|"
						$ "HeadShots:"   $ CDPlayerStats[i].HeadShots			$ "|"
						$ "HSAccuracy:"  $ round(CDPlayerStats[i].HSAccuracy);
	}

	Output = Output $ "\n------[ Match Stats END ]------";
	return Output;
}