//=============================================================================
// CD_SpawnCycleCatalog
//=============================================================================
// SpawnCycle preset/inidata parsing.  This class exposes the highest level
// of abstraction for SpawnCycle handling; it is the main entry point for other
// components trying to manipulate or load SpawnCycles.
//=============================================================================

class CD_SpawnCycleCatalog extends Object;

`include(CD_Log.uci)

var private array< class< KFPawn_Monster > > AIClassList;

var array<CD_SpawnCycle_Preset> SpawnCyclePresetList;

var private CD_ConsolePrinter CDCP;

var private bool EnableLogging;

var bool bNoShooter;

function Initialize( const out array< class< KFPawn_Monster > > NewAIClassList, CD_ConsolePrinter NewCDCP, const bool NewEnableLogging )
{
	AIClassList = NewAIClassList;
	CDCP = NewCDCP;
	EnableLogging = NewEnableLogging;
	InitSpawnCyclePresetList();
}

function SetLogging( bool b )
{
	EnableLogging = b;
}

/*
 * Resolve a SpawnCycle preset name, check that it is defined
 * under the supplied GameLength, and then parse it and copy
 * its wave data into the WaveInfos pass-by-ref parameter.
 *
 * Returns true if successful, false if unsuccessful.  If false
 * the WaveInfos should be ignored.
 */
function bool ParseSquadCyclePreset( const string CycleName, const int GameLength, out array<CD_AIWaveInfo> WaveInfos )
{
	local array<string> CycleDefs;
	local CD_SpawnCycleParser SCParser;

	WaveInfos.Length = 0;

	if ( None == ResolvePreset( CycleName, GameLength, CycleDefs ) )
	{
		`cdlog("Unable to map SpawnCycle="$ CycleName $" to a preset", EnableLogging);
		return false;
	}

	SCParser = new class'CD_SpawnCycleParser';
	SCParser.SetConsolePrinter( CDCP );
	SCParser.SetLogging( EnableLogging );
	
	if ( !SCParser.ParseFullSpawnCycle( CycleDefs, AIClassList, WaveInfos ) )
	{
		`cdlog("Found a preset corresponding to SpawnCycle="$ CycleName $", but failed to parse it", EnableLogging);
		return false;
	}
	
	`cdlog("Located and parsed preset corresponding to SpawnCycle="$ CycleName, EnableLogging);
	return true;
}

/*
 * Convert the supplied list of CycleDefs into WaveInfos, checking
 * that the number of CycleDefs matches the number of non-boss waves
 * on GameRLength.
 *
 * Returns true if successful, false if unsuccessful.  If false
 * the WaveInfos should be ignored.
 */
function bool ParseIniSquadCycle( const array<string> CycleDefs, const int GameLength, out array<CD_AIWaveInfo> WaveInfos )
{
	local int ExpectedWaveCount;
	local CD_SpawnCycleParser SCParser;

	if ( CycleDefs.length == 0 )
	{
		CDCP.Print("WARNING SpawnCycle=ini appears to define no waves"$
		               " (are there any SpawnCycleDefs lines in KFGame.ini?)");
		return false;
	}

	SCParser = new class'CD_SpawnCycleParser';
	SCParser.SetConsolePrinter( CDCP );
	SCParser.SetLogging( EnableLogging );
	
	if ( !SCParser.ParseFullSpawnCycle( CycleDefs, AIClassList, WaveInfos ) )
	{
		return false;
	}
	
	// Number of parsed waves must match the current gamelength
	// (Parsed waves only cover non-boss waves)
	switch( GameLength )
	{
		case GL_Short:  ExpectedWaveCount = 4;  break;
		case GL_Normal: ExpectedWaveCount = 7;  break;
		case GL_Long:   ExpectedWaveCount = 10; break;
	};
	
	if ( WaveInfos.length != ExpectedWaveCount )
	{
		CDCP.Print("WARNING SpawnCycle=ini defines "$ WaveInfos.length $
		               " waves, but there are "$ ExpectedWaveCount $" waves in this GameLength");
		return false;
	}
	
	return true;
}

/*
 * Print recognized SpawnCycle presets -- that is, everything
 * but unmodded or ini -- to the console.
 */
function PrintPresets()
{
	local int i;
	local CD_SpawnCycle_Preset SCPreset;

	CDCP.Print( "Total available SpawnCycle presets: "$ SpawnCyclePresetList.length, false );

	if ( 0 < SpawnCyclePresetList.length )
	{
		CDCP.Print( "Listing format:", false);
		CDCP.Print( "    <SpawnCycle name> by <author> (<accession date>) [SML]", false );
		CDCP.Print( "The SML letters denote supported game lengths (Short/Medium/Long)", false);
		CDCP.Print( "-------------------------------------------------------------------", false );
	}

	for ( i = 0; i < SpawnCyclePresetList.length; i++ )
	{
		SCPreset = SpawnCyclePresetList[i];
		CDCP.Print( "    "$ SCPreset.GetName()$" by "$ SCPreset.GetAuthor() $
		            " ("$ SCPreset.GetDate() $") "$ GetLengthBadgeForPreset( SCPreset ) , false );
	}
}

function string PrintPresetsOnline()
{
	local int i;
	local CD_SpawnCycle_Preset SCPreset;
	local string Result;

	Result = "Total available SpawnCycle presets: "$ SpawnCyclePresetList.length $"\n";

	for ( i = 0; i < SpawnCyclePresetList.length; i++ )
	{
		SCPreset = SpawnCyclePresetList[i];
		Result $= "    "$ SCPreset.GetName()$" by "$ SCPreset.GetAuthor() $
		            " ("$ SCPreset.GetDate() $") "$ GetLengthBadgeForPreset( SCPreset ) $"\n";
	}

	return Result;
}

/*
 * Lookup a CD_SpawnCycle_Preset object corresponding to CycleName,
 * copying its wave definition strings into CycleDefs if found.
 *
 * Returns true if successful.  Returns false otherwise, in which
 * case CycleDefs should be ignored.
 */
function CD_SpawnCycle_Preset ResolvePreset( const string CycleName, const int GameLength, out array<string> CycleDefs )
{
	local CD_SpawnCycle_Preset SCPreset;
	local int i;

	// Avoidable linear search; this is another case where I wish unrealscript
	// had an associative array/hashtable
	for ( i = 0; i < SpawnCyclePresetList.length; i++ )
	{
		if ( CycleName == SpawnCyclePresetList[i].GetName() )
		{
			SCPreset = SpawnCyclePresetList[i];
			break;
		}
	}

	`cdlog("SCPreset: "$ SCPreset, EnableLogging);

	if ( SCPreset == None )
	{
		CDCP.Print("WARNING Not a recognized SpawnCycle value: \""$ CycleName $"\"");
		return None;
	}

	switch( GameLength )
	{
		case GL_Short:  SCPreset.GetShortSpawnCycleDefs( CycleDefs );  break;
		case GL_Normal: SCPreset.GetNormalSpawnCycleDefs( CycleDefs ); break;
		case GL_Long:   SCPreset.GetLongSpawnCycleDefs( CycleDefs );   break;
	};
       	
	if ( 0 == CycleDefs.length )
	{
		CDCP.Print( "WARNING SpawnCycle="$ CycleName $" exists but is not defined for the current GameLength.\n" $
		                "   The following GameLength(s) are supported by SpawnCycle="$ CycleName $":\n" $
		                "   " $ GetSupportedGameLengthString( SCPreset ) );
		return None;
       	}

	return SCPreset;
}

private function InitSpawnCyclePresetList()
{
	if ( 0 == SpawnCyclePresetList.length )
	{
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.albino_heavy');
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.basic_light');
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.basic_moderate');

		SpawnCyclePresetList.AddItem(new class'SpawnCycle.basic_heavy');
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.dtf_v1');
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.nam_poundemonium');
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.nam_pro_v1');
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.nam_pro_v2');
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.nam_pro_v3');
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.nam_pro_v4');
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.nam_pro_v5');
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.nam_pro_v5_plus');
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.nam_semi_pro');
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.nam_semi_pro_v2');
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.rd_kta');
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.rd_odt');
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.rd_sam');
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.asl_v1');
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.asl_v2');
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.asl_v3');
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.pubs_v1');
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.ts_mig_v1');
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.ts_mig_v2');
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.ts_mig_v3');
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.ts_mig_v1_p');
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.ts_lk313_stg');
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.doom_v1');
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.doom_v2');
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.doom_v2_plus');	
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.doom_v2_short');
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.grand_v1');
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.bl_v1');
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.bl_v2');
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.osffi_v1');
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.doomsday_v1');
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.fpp_v1');	
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.pro6');
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.pro6_plus');
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.pro_short');

		SpawnCyclePresetList.AddItem(new class'SpawnCycle.mko_v1');
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.doom_v2_plus_rmk');
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.asp_v1');
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.asp_v2');
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.asp_v3');
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.asp_fp_v1');
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.asp_fp_v2');
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.osffi_v1_ms');
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.machine_solo');
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.bl_light');
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.su_v1_short');
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.su_v1');
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.poopro_v1');
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.dtf_pm');
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.who_v1');
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.who_v2');
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.ebr_hh_v1');
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.nt_v2');

		SpawnCyclePresetList.AddItem(new class'SpawnCycle.gso_v1');
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.aio_v1');
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.aio_v2');
		SpawnCyclePresetList.AddItem(new class'SpawnCycle.gg_v1');
	}
}

/*
 * Return a string in the form
 * "Short (GameLength=0), Medium (GameLength=1), Long (GameLength=2)"
 * denoting game lengths supported by the supplied preset.
 */
private static function string GetSupportedGameLengthString( CD_SpawnCycle_Preset SCPreset )
{
	local array<string> defs;
	local string result;

	result = "";

	SCPreset.GetShortSpawnCycleDefs( defs );
	if ( 0 < defs.length )
	{
		result $= "Short (GameLength=0), ";
	}

	SCPreset.GetNormalSpawnCycleDefs( defs );
	if ( 0 < defs.length )
	{
		result $= "Medium (GameLength=1), ";
	}

	SCPreset.GetLongSpawnCycleDefs( defs );
	if ( 0 < defs.length )
	{
		result $= "Long (GameLength=2), ";
	}

	return Left( result, Len( result ) - 2 );
}

/*
 * Return a string in the form [SML] denoting game lengths
 * supported by the supplied preset.
 */
private static function string GetLengthBadgeForPreset( CD_SpawnCycle_Preset SCPreset )
{
	local string result;
	local array<string> defs;

	result = "[";

	SCPreset.GetShortSpawnCycleDefs( defs );
	result $= ( 0 < defs.length ? "S" : "_" );

	SCPreset.GetNormalSpawnCycleDefs( defs );
	result $= ( 0 < defs.length ? "M" : "_" );

	SCPreset.GetLongSpawnCycleDefs( defs );
	result $= ( 0 < defs.length ? "L" : "_" );

	result $= "]";

	return result;
}

function bool ExistThisCycle(string CycleName, out CD_SpawnCycle_Preset SCP)
{
	local int i;

	for (i=0; i<SpawnCyclePresetList.length; i++)
	{
		if(CycleName == SpawnCyclePresetList[i].GetName())
		{
			SCP = SpawnCyclePresetList[i];
			return true;
		}
	}
	SCP = none;
	return false;
}