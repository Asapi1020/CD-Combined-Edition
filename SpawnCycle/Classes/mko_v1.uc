class mko_v1
	extends CD_SpawnCycle_PresetBase
	implements (CD_SpawnCycle_Preset);

//lots of sc
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
	sink[i++] = "1CY_5AL,1GF_3GF*,5CR,2BL_4ST,7CR,2AL*_4GF*,4CR,2AL*_2CY_2GF,2HU_1FP,1AL*_3CY,5CY_1AL,5SL,5CR,5ST,4CY_3HU,1AL*_2GF*_3CY,2SI_3CY,7CY,2BL_5HU,4ST,7CR,2AL*_2AL_3GF*";
	
	// Wave 02 	// 
	sink[i++] = "4CY_1AL*,6CR,1BL_3SC,2AL*_3GF_1HU,2HU_1SI_1SC_1AL*,4SL_3GF*,2AL_1CY_2SL_2GF,4CR,1SC_1SI,2CY_1AL*_2GF*,1FP_2HU,3CY_2AL,6ST,6GF,1AL*_2GF_1BL_1CY,1BL_2SC_1SI,5CR_1GF*,2AL*_2CY_2GF*";
	
	// Wave 03 // 
	sink[i++] = "3CR_1AL*_2GF,2AL*_3GF*,3SC,6GF,1BL_2SC_1SI,5ST,2AL*_4GF*,7CR,1SC_1HU,2CY_1AL_2AL*_2GF,1FP_2SC_2AL*,6ST,2AL*_1CY_4GF*,5CR,2BL_1SC,6CY,2CY_3GF*_2AL*,2HU,1AL*_2GF*,3SC,5CR,2CY_1AL*_1HU";
	
	// Wave 04 // 
	sink[i++] = "1AL*_3GF*,3SI_1HU,2BL_4SC,3CR_2GF*,2HU_1FP_1SC,1AL*_2GF*_1AL_1CY,2SC_2SI,5ST,3CY_2AL*,3GF*_3AL*,3SC,2GF_2GF*_1AL*,2SC_1SI_1HU,6ST,5CY,1HU_1SC,2AL*_1CY_2GF*,3SC,5ST,2CY_2AL*_2GF*,5CR_2HU,1HU_1FP,1BL_1AL*_1SC_1SI,1AL_2GF*"; 

	// Wave 05 // 
	sink[i++] = "4CR_1HU,1AL_1CY_2AL*_3GF*,2BL_5SC,2HU,3FP_2SI,4ST,1AL*_1CY_5GF*,1BL_3SC_2SI,3SC_1HU,6CR,2CY_1AL*_2GF,1AL_1AL*_2SC_2GF,3SL_1CR_2HU,3SC_1FP_1HU,3ST_3CY,1BL_3SC_1AL*,2AL_2GF_1CY"; 
	
	// Wave 06 //
	sink[i++] = "4CY,5CR,5SC_1FP_2HU,1AL*_3GF_1CR,2CY_1AL_2GF,1BL_3SC_2SI,4ST,2CY_1AL*_3GF*_1CR,6ST,1HU_1FP_2SI_2SC,2BL_3SC,6SL,1AL*_1GF*_3SC,3ST_1CR*_2CR,4SC_1AL*,1AL*_3CY";
	
	// Wave 07 //
	sink[i++] = "2SC,2AL*_2BL,1HU_5GF,3SC_2SI,2AL*_1FP_2SC,3CR_2HU,3CY_1AL*_2GF*,1BL_3SC_2SI,3ST_2HU_2CR,1FP_5SC_2HU,2AL*_2GF*,3SL_4ST,1BL_3SC,3CR_2HU,4SC_1FP_1SI,1AL*_1GF*_5CY";
	
	// Wave 08	// 
	sink[i++] = "7CR,4SI_2BL,3BL_3SC_1HU_1FP,4ST,2BL_3SC_2SI,1AL*_1FP,2AL*_2CY_3GF*,4CR_1HU,1AL*_4SC_1SI,5AL,1FP_5SC_2SI,2SI,1AL*_3SC_1SI,1BL_1AL*_3GF,5SL,3ST_2CR_2HU,3FP_3SC,2AL_2CY_1AL*_2CR";
	
	// Wave 09 // 
	sink[i++] = "5CR,2BL_4SC_1SI,5AL,2HU_2FP_2SC,3GF_2AL*,1BL_1SI_3SC_2CY,4CR,2AL_1AL*_2HU_2GF,4SC_1AL*_2FP_1SI,2CY_1AL_2SL,2SI_4SC,4ST_2SL,3CR,3SC_1AL*_2FP_1SI,3ST_3SL,1BL_1AL*_3GF*,1FP_4SC_1HU,1BL_1AL*_3ST,3ST";

	// Wave 10	//
	sink[i++] = "4CR_1SI,5ST,2CR_2AL*_1AL,1BL_4SC,1HU_2ST_1AL*,3FP_5SC,4ST,1AL*_4CR,1AL*_4GF*,4CR,2SC_2FP_2SI,1BL_3SC_1CR,1AL*_4GF,4GF,3SC,2AL_2GF,2HU_2FP,1BL_3SC_1SI_1AL*,6CR,1FP_1SI_1AL*_4SC,1SC_2CR";
}

function string GetDate()
{
	return "unknown";
}

function string GetAuthor()
{
	return "unknown";
}