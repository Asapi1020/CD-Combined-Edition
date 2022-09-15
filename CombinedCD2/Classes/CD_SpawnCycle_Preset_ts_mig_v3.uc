class CD_SpawnCycle_Preset_ts_mig_v3
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
	sink[i++] = "3CY_3AL,2GF_2GF*,3CR_2CR*,2BL_4ST,7SL,2AL*_2GF*_1AL_1CY,4CR,2AL_2CY_2GF,2HU_1FP,1AL*_3GF,3CY_1AL_2GF,2AL_1CY_2SL,4CR_1CR*,5ST,4CY_3AL,1AL*_2GF_2AL_1CY,2SI_3CY,7SL,2BL_1SC_2SI_2HU,4ST,5CR_2CR*,1AL*_3AL_1GF*_2CY";
	
	// Wave 02 	
	sink[i++] = "3CY_2AL,3CR_3CR*,2BL_2SC,2AL*_2GF*_2GF,1FP_1HU_1SI,4SL_3ST,2AL_1CY_2SL_2GF,4CR,1SC_1SI,2CY_1AL_2GF,1FP_2HU,3CY_2AL,6ST,6SL,2AL*_2GF*_1AL_1CY,1BL_2SC_1SI,5CR_1CR*,2AL_2CY_2GF";
	
	// Wave 03
	sink[i++] = "2CR_1CR*_1AL_2CY,2AL*_2GF*_1GF,1FP_1SC,6SL,1BL_1SC_1SI,5ST,3CY_2AL_1GF,5CR_2CR*,1SC_1HU,2CY_1AL_2AL*_2GF*,1FP_2SC_2SI,6ST,3AL_1CY_3GF,4CR_1CR*,2BL_1SC,6SL,2CY_3GF_2AL,2HU,1AL*_1GF*_1GF,1FP_1SC,4CR_1CR*,2CY_1AL_1GF";
	
	// Wave 04 
	sink[i++] = "1AL_1CY_2GF,5SL,2BL_2SC,3CR_2CR*,2HU_1FP,1AL*_2GF*_1AL_1CY,2SC_2SI,5ST,3CY_2AL,3GF_1AL*_2GF*,1FP_1SC,1CY_1AL_2GF_1AL*,1BL_2SC_1SI,4CR_2CR*,5SL,1HU_1SC,2AL_1CY_1GF_1AL*,1FP_1SC,5ST,2CY_1AL_1AL*_2GF*,5CR_2CR*,1HU_1FP,1BL_1AL*_1SC_1SI,1AL_2GF"; 

	// Wave 05 
	sink[i++] = "4CR_1CR*,1AL_1CY_2AL*_1GF*_2GF,2BL_3SC,2HU,2FP_2SI,4ST,1AL_1CY_2AL*_3GF*,1BL_3SC_2SI,1SC_1FP_1HU,3CR_3CR*,2CY_1AL_2GF,1AL_1AL*_2SC_2GF*,3SL_1CR_2CR*,1SC_2FP_1HU,3ST_3SL,1BL_2SC_1AL*,2AL_2GF_1CY"; 
	
	// Wave 06 
	sink[i++] = "1AL_1CY_2GF,3CR_2CR*,3SC_2FP_2HU,2AL*_3GF*,2CY_1AL_2GF,2BL_3SC_2SI,4ST,1AL_1CY_2AL*_2GF*_1GF,3CR_3CR*,2HU_2FP_2SI,2BL_3SC,6SL,1AL*_1GF*_2SC,3ST_1CR*_2CR,1FP_2SC_1HU,1AL*_1CY_2AL";
	
	// Wave 07 
	sink[i++] = "1BL_1SC,2AL_1CY_1BL,2AL*_2GF_2GF*,3SC_2SI,2HU_2FP,3CR_2CR*,1AL_1CY_1SL_1AL*_1GF_1GF*,2BL_2SC_2SI,3ST_2CR*_2CR,2FP_3SC_2HU,2AL*_2GF*,3SL_4ST,1BL_3SC,3CR_2CR*,2SC_1HU_2FP_1SI,1AL*_1GF*_2GF_2CY_1AL";
	
	// Wave 08	
	sink[i++] = "1CY_2AL_2GF_2SL,4CR_2CR*,2BL_1SC_2HU_2FP,4ST,2BL_3SC_2SI,1HU_1FP,2AL*_1AL_1CY_3GF*,4CR_1CR*,1HU_4SC_1SI,2AL_3GF,2FP_3SC_2SI,2HU,1BL_2SC_1SI,1BL_2AL*_2GF*,5SL,3ST_2CR_2CR*,3FP_2SC,2AL_2CY_1AL*_2GF";
	
	// Wave 09 
	sink[i++] = "1AL_2GF_1CY_1SL,2BL_3SC_1HU,2CR*_3CR,2HU_3FP,2GF*_2AL*_1GF,2BL_2SI_3SC,4CR,2AL_1AL*_2GF*_2GF,2SC_2HU_3FP,2CY_1AL_2SL,3SI_3SC,4ST_2SL,2CR*_1CR,3SC_1HU_2FP_1SI,3ST_2CR_1CR*,1BL_1AL*_1GF_2SL,2FP_2SC_1HU,1BL_1AL_1CY_2GF,1AL*_1AL_1CY";

	// Wave 10	
	sink[i++] = "1AL_2GF_1CY_1SL,2CR*_3CR,2GF*_2AL*_1GF,2BL_3SC,2HU_2SI,4FP_3SC,4ST,3SL_2CY,2AL_2GF*_1AL*,1CR*_3CR,2HU_3FP_2SI,2BL_3SC,2AL_1AL*_2GF,2SL_2ST,1BL_2SC,2CY_1GF_1GF*,2HU_2FP,1BL_3SC_2SI,2CR*_4CR,2FP_1HU_1AL*_2SC,1SC_2AL";
}

function string GetDate()
{
	return "2019-09-18";
}

function string GetAuthor()
{
	return "Machine";
}