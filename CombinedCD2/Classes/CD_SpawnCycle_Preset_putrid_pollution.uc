class CD_SpawnCycle_Preset_putrid_pollution
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
	sink[i++] = "3BL_2HU_1CR_2SL,3AL_2BL_1SI_1SL,1SI_2SL_2HU_1CR,1ST_4BL_1HU_1SI,1HU_3BL_1GF,1AL_1ST_1HU_1SI_1BL_1CY,1CY_2SI_2BL,6BL_1CR,2GF_3BL_1HU,2CY_1BL_1AL_1HU_1SI_1SL,3BL_1ST_2CY_1AL,1AL_2CY_3ST_1BL,3BL_1AL_1ST_2CY_1SL,3BL_1SL_1GF_1HU_1CY,2SI_1CY_1HU_2AL_1SL,3GF_1CR_1BL,4BL_3SI_1ST,5BL";
	
	// Wave 02
	sink[i++] = "4BL_1SL_1HU,1ST_1SL_1GF_1AL_1BL,1GF_1SL_1ST_1AL_2CR_1BL,2CY_4BL,2SI_1CR_2HU_1ST,1CY_2GF_1BL_1HU,1SI_2ST_1BL_1CY,2BL_1GF_1HU_1AL,2BL_2SL_2SI_1HU,1SI_1CY_2CR_1GF,1CY_2BL_1ST_2SL_1CR,1GF_1SI_2AL_1SL,2HU_2BL_1AL_1GF_1SI,4BL_1AL,2BL_1ST_1SI_1AL,2BL_1CR_2SI_2HU_1ST,1ST_4BL_2GF_1SL,1CY_1ST_5BL_1HU,2SI_3BL_1CR_1CY,2BL_1AL_1ST_1SI_1GF";
	
	// Wave 03
	sink[i++] = "2ST_1HU_1CR_2SI_1BL_1CY,1SL_2HU_1CR_1ST_2BL,3SL_2BL_1ST,1BL_2SI_2CR,4BL_1GF_1CR_1ST_1SL,1SI_1CY_1ST_1BL_1HU,5BL_1GF_1CY_1HU,1CR_3AL_2SL_1BL_1HU,1SL_1AL*_1BL_1ST_1HU_1CR,3BL_1SI_1CY_1AL_2CR,1AL_3BL_2SL_1SI_1CY,1CR_1HU_2ST_1AL_1SI,3BL_1CY_2HU,3BL_1GF_1HU_1CR*_1CR_1CY,1GF_1SL_1ST_1BL_2HU,1AL_4BL_1CY_1SI_1SL,5BL_1HU_1CR,1GF_1AL_2BL_1HU_1SI,1CY_1SI_1BL_1GF_1SL,5BL_1SI_1AL";
	
	// Wave 04
	sink[i++] = "1HU_3CY_1SI_1SL,1SI_2AL_1ST_1CY,1HU_1ST_2SL_2BL,1AL_5BL_1GF_1CR,1SI_1GF_3CY_2BL_1AL,1HU_5BL_1AL_1ST,3BL_1SL_1ST_1SI,2BL_3HU_1SI,2BL_1SI_1SL_1ST_1HU,2CY_2SI_1HU_1BL,1GF_2BL_2HU_1GF*,1CY_3BL_1ST_1GF,4BL_1SI_1AL_1ST_1GF,3ST_3BL_1AL_1SL,4BL_1SI,4BL_3SL,3BL_1AL_2HU_1CY,1ST_5BL_1CY_1GF,2SI_2AL_1BL_1GF_1HU,2BL_1GF_2HU_1ST";
	
	// Wave 05
	sink[i++] = "1GF_1CY_3SI,1CY_1ST_1GF_1FP_1SL,1AL_3BL_1FP_1HU_1CR,1CR_3BL_1AL_1FP_2HU,2SI_2HU_1CY_2BL_1AL,3BL_1GF_1CY,3HU_2BL_2ST_1CY,1CY_1CR_2BL_2SL_1SI,3BL_1ST_1SL_1SI_1AL,1HU_1CR_1SL_1SI_1CY_1BL,3BL_1SC_1AL_2HU,4BL_1HU,2ST_2CY_2CR_1SI,1ST_1FP_2BL_1SL,3BL_2SI_1HU,2AL_1BL_1SL_1HU,4BL_1AL_1CY_1SL_1HU,2ST_1AL_1BL_2CY_1GF_1HU,2SI_1CY_1HU_1CR,1ST_1HU_1GF_1MF_1SI_1SC_1SL";
	
	// Wave 06
	sink[i++] = "1SL_1BL_2CY_1MF_1SI,1HU_1AL_1SI_1BL_2FP_1MF_1ST,3HU_1GF_1BL_1SL_1ST,1SI_3BL_1AL_1FP,4BL_1SC_1AL,4BL_1SI_1GF,1CR_1BL_2SL_1CY,2HU_1CY_3BL_1SI_1CR,1SL_1SI_2BL_1HU,1SL_4BL_1CY_1SC_1SI,2BL_3ST_1SI,3BL_1SC_1SI_2HU,1BL_2GF_1CY_1HU_2SI,1CR_3BL_1ST_1SI_1HU_1CY,2BL_1CY_1CR_1HU_1ST,4BL_1CY_1SI_1CR,1CY_1CR_1SI_2BL,1ST_3BL_1AL_1SL_1HU,2AL_3BL_1CY_1ST_1SL,2BL_1SL_1FP_1CR";
	
	// Wave 07
	sink[i++] = "1CR_1SL_1ST_2BL,1SL_3BL_2CY_1HU_1ST,3BL_2CR_1SC_1HU,1CY_4BL_1CR_1FP,5BL,1AL_1CR_2HU_1SI,4BL_1HU_1CY_1SI,1CY_4BL_1GF*_1HU_1SC,2GF_2CR_1BL_1ST,1GF_1CR_1BL_2SI_1SC_1SL,1CY_3BL_1AL_1HU_1CR_1GF,2BL_2ST_1SC_1GF_1AL,2BL_1CY_1HU_1SL,1AL*_4BL_1CY,2BL_1GF_1AL_1CR_1MF,3HU_1GF_1MF_2BL_1FP,1SI_2HU_1CR_2BL,1HU_3BL_1SI,2BL_1ST_1GF_1HU";
	
	// Wave 08
	sink[i++] = "2CY_1BL_1SI_1SL,2CY_2HU_1CR,1AL_5BL_1GF,1BL_1CR_1CY_1GF_1MF,4BL_3HU_1CY,2BL_2GF_1SL_1CR_1AL_1HU,5BL_1SI_1FP_1SL,2BL_1SL_1CY_1CR,1BL_1SL_1CY_1HU_1FP,6BL_1CY,1CR_1SL_1FP_1SC_1ST,1CR_1SC_3SI_2ST,1GF_1ST_2AL_1CR_1HU_1SI,1CR_3BL_2SL_1HU,2BL_1SC_1SI_1AL_1CR,1CY_3BL_1ST,1HU_1AL*_2BL_1CY,2HU_3GF_1SI,3BL_1AL_1FP_1CR_1MF,1CR_1SC_2SI_1FP_1ST,2SI_1HU_1ST_1GF_2BL,2CY_3ST_1GF_1BL_1MF,4BL_1SI_1ST,2CY_3BL_1CR_1SL_1GF,2ST_1AL_1CR_1BL_1HU_2CY";
	
	// Wave 09
	sink[i++] = "1CR*_1SL_1BL_1CR_1MF_2AL_1SI,3GF_1SC_1SL_1BL,1HU_3BL_1FP_1AL,3BL_1CY_1ST,1HU_3BL_1CY,2CY_2BL_1FP_1GF,3CR_1BL_1SI_1FP_1ST,2SL_1HU_5BL,3BL_1MF_1GF_1CR_1SL,1HU_2CY_1MF_1SL_1GF_1AL,3BL_1CR_2ST_2HU,1GF_3BL_1ST_1AL_1FP_1HU,1HU_1FP_3ST_2BL_1CR,2BL_1GF_2SI_2ST,3BL_1FP_1ST_1HU_1CR_1AL,3CR_1AL_2SL_2BL,1BL_2HU_1ST_1CY,1GF_1ST_1AL_1BL_1HU,2BL_1SC_1SI_1HU,1GF_3BL_1HU_1ST_1CY,1FP_4BL_1CY_1GF_1MF,1CR_1HU_2BL_1GF,4BL_1SI_1CR_1CY_1GF,1ST_2BL_1HU_1CY_1SC";
	
	// Wave 10
	sink[i++] = "1BL_1SI_1SC_1AL_1CY_1SL,3HU_1SI_1CR_1BL,1BL_1SI_1SL_2CY,2BL_2AL_1SL,2AL_1SI_1MF_2GF_1CY,2SL_1ST_1CY_1AL_2BL,2CY_1AL_1SI_2SL_1GF_1BL,2SI_2BL_1ST_1CR_1FP,1BL_3GF_1AL,3BL_1SC_1SI_1FP,3BL_1SL_1HU_1ST_1CR,1SC_1HU_1CY_2BL,2SL_2CY_1HU,2CR_1AL_2BL,2CY_1SI_2BL,1ST_1GF_1SL_2SI_1FP_1BL,3BL_1SI_1AL_1ST,1CY_1AL_1BL_2ST";
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