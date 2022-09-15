class CD_SpawnCycle_Preset_trash_only
	extends CD_SpawnCycle_PresetBase
	implements (CD_SpawnCycle_Preset);

function GetShortSpawnCycleDefs( out array<string> sink )
{
	GetLongSpawnCycleDefs( sink ); 

	// keep waves 1, 4, 7, 10 
	sink.Remove(1, 2); 
	sink.Remove(2, 2); 
	sink.remove(3, 2); 

	sink.Length = 4; 
}

function GetNormalSpawnCycleDefs( out array<string> sink )
{
	GetLongSpawnCycleDefs(sink);
    sink.Remove(2, 1);
    sink.Remove(3, 1);
    sink.Remove(5, 1);
    sink.Length = 7;
}

function GetLongSpawnCycleDefs( out array<string> sink )
{
	local int i;

	i = 0;

	sink.length = 0;
	sink.length = 10;

	// Wave 01
	sink[i++] = "1SL,2ST_1CY,1ST_1GF,1GF,1ST,1GF_1CY,1CY_1SL_1CR,1ST,1SL_1AL,1CR_1GF_1SL,1SL_1AL,1SL_2CR_1ST,1SL_1CR_1ST,1CY_1SL_1AL,1GF_1AL_1CY_1SL,2AL,1GF_1AL_1CR,1ST_1CR,1CR_1ST,3ST";
	
	// Wave 02
	sink[i++] = "1ST_2AL,2CR_1GF,1AL_2CR_1GF,1SL,1CR,1SL_2GF,1AL_1CY,1CR_1CY,1ST_1CY,1SL_2AL,1SL,1CY_1CR,1CY_1CR_1SL,1CR_2CY_1AL,1AL_2SL_1CR,1SL_1AL_1ST,1ST_1CY,1ST";
	
	// Wave 03
	sink[i++] = "1SL_1ST_1AL,1CR,1CY_1CR*_1AL,1SL,1AL,2ST_1GF*_1CR,1SL_1AL_1CY_1CR,1CR_1ST,1ST,1ST_1GF_1SL,1GF_1ST,1ST_1GF_1SL_1AL*,1GF_1CR_1AL*_1ST,2CY,1SL_1GF_2AL,1ST_1CY_1AL,1SL,1GF_1CY";
	
	// Wave 04
	sink[i++] = "1GF_1SL_1ST_1CY,2GF_1CR_1SL,1CY_1SL_1GF,3ST_1SL,1AL_1GF,1CR_1SL,1CY_1SL_1ST,1CR,1SL_1AL_1GF,1AL_1CR,1CR_1CY_1AL*,1CR,1GF_1AL,1SL,1CY_1AL_1SL,1ST,1ST_1CR_1SL";
	
	// Wave 05
	sink[i++] = "2ST_1AL_1CR,1ST_2SL,1CY_1ST_2SL,1ST_2GF_1AL,1GF_1ST_1SL_1CR,1CY_1CR,1GF*_1ST_1GF_1SL,1SL_1AL,1CR,1GF_1CR,1AL*,1CY,1SL_1CR_1AL,1SL_1AL*_1CR_1GF,1CR_1CY_1ST,1CR_1ST,1SL_2CR_1CY,1ST,1GF";
	
	// Wave 06
	sink[i++] = "2SL_1ST_1AL,1CR_1CY_1GF,1AL_1CY_1ST,2SL_1GF_1CR,1AL,2AL_1CY,1ST_1CR_1AL_1GF,2SL_1CY_1AL,2CR_1ST_1GF,1SL,1AL,1AL,2CY_1ST,1CR_1AL*,1CR_1CR*_1AL*,1AL*,3CR";
	
	// Wave 07
	sink[i++] = "1ST_1CY_1SL_1AL,1GF_1AL,1CY_1AL,1SL_1ST_1AL,1ST_1CY,1AL_1ST,2SL_1GF,3ST_1CY,1AL_1GF*,1SL_1CR,1ST_1CR_1SL_1GF,1AL_1GF_1CR*,1CR_1CY_1SL_1AL,1CY_1CR*_1GF,1CY,1CR,2CY,1AL_2SL_1CR,1AL_1ST,2GF_2CR";
	
	// Wave 08
	sink[i++] = "1CY,1AL_1GF_1CR,1CR,1GF_1ST,1CY_1ST_2GF,1GF_1CR_1SL,2AL_1CR,2AL_1SL,2SL_1CY_1CR,2CR_2ST,1AL*_2GF_1SL,1ST_2AL_1CR,1GF_2CY,1CR*,2AL_1SL,1GF_1CR,1CR,1ST_1CY,1SL";
	
	// Wave 09
	sink[i++] = "1ST_1CR,2SL_1AL_1GF,1ST_1CY_1GF,1AL_1CY_1CR,2ST_1CY_1GF,2CR_1AL_1ST,1GF_1AL,1GF_2SL_1CY,1ST_1CY,1CR,1AL_1CR_2SL,1ST_1GF_2SL,1CR*,1SL_1GF_2AL,1CR_1AL_1CY,1AL_1ST,2SL_1AL_1CR,2AL_2CY,1ST_1SL_1AL";
	
	// Wave 10
	sink[i++] = "1GF_2SL_1AL,1AL,1ST_2CR_1CY,1CY_1CR*_1AL,1GF,1SL_1CY_1ST_1GF,1CR_1GF,1SL,1AL_1GF_1ST,1CY_1SL,1GF,1GF*,1GF_1SL,1CY,1CR*_1AL,2SL_2AL,1ST,1AL,1GF_3ST,1GF_1CR";
}

function string GetLength()
{
	return "Long";
}

function string GetDate()
{
	return "Unknown";
}

function string GetAuthor()
{
	return "Tamari";
}