class CD_SpawnCycle_Preset_doom_v1
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
	//	keep waves 1, 2, 4, 6, 7, 9, 10
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

	// Wave 01 - Simple stuff (DTF_V1 W1 modified)
	sink[i++] = "4CC,2CR_2GF*,2SI,2AL_2GF,3CS,4AL_1BL,3AL_1GF*,1CR_3GF*,2AL_1CS,4CC_1SI,3HU,2AL_2GF*,4CC_1BL,3AL_1CS,3CC_3CR,3CC_1AL*_2GF,6CS,4CC_1BL,2AL_4CC,2SI,1SI_3CC_1AL*_1GF,4CC_1BL,3AL_1CS,4AL,3CR_1HU";
	
	// Wave 02 - Scrakes start spawning (DTF_V1 W2 modified: 6 Scrakes)
	sink[i++] = "4CR,3AL_1BL,2CS_3CR_1GF,4GF*,2HU,4ST_1HU,2CC_1GF*,1SI_1BL,2SC,2CS_2GF,2CC_1AL,2CR_2GF*,2SI_1BL,4ST_2SI,1HU_2CR,1SC_2GF,3CR_3CC,1SI_1BL,2AL_2CC,4GF*,2CS_3CR,2GF_2CR,2CC_1GF,2BL_1SI,2CS_2GF,2CC_1AL,2CR_2ST,1SI_1HU,4ST_2GF,4CR,4GF*,2SC_1BL,2AL_2CS,3CR_1GF,4ST,1AL_2CC_1GF,1SC,1SI_1BL,2CS_2GF";
	
	// Wave 03 - Quarter Pounds start spawning (GSO_V1 W3 modified: 6 Scrakes, 4 Quarter Pounds)
	sink[i++] = "4CR,3AL_1BL,2CS_3CR_1GF,4ST_1HU,2CC_1GF*,2SC_3HU,3SI_1BL,2MFP_1SC,2BL_1HU_1SI,3AL_1BL,2AL_2GF_1BL,1AL_3CR_1GF,1SI_1HU,1SI_1BL,2AL_2CC,2CS_3CR,2GF_2CR,2CC_1GF,2CS_2GF,2CC_1AL,2CR_2ST,1SI_1HU,2SC_2MFP,4CR,2AL,2CS,3CR,1GF,4ST,1BL_2CC_1GF,1SI_2CS,2GF,2CC_1AL,2CR_2GF,3ST_1SI,3GF_1BL_1SC,3CR_1HU,4CC_1SI,2AL_2CS,3CR_1GF,3CC_1GF_1SI_1HU,2CS_2GF,3CC_1AL,2CR_2GF_4ST";
	
	// Wave 04 - Fleshpounds start spawning (Nam_pro_V3 W6 modified: 6 Scrakes, 4 Quarter Pounds, 3 Fleshpounds)
	sink[i++] = "4CR,3AL_1SL,2SC_1MFP,2SL_2CR_1GF_2SI,2BL_1AL_1GF_1SC_2FP_2HU,3SI,2CC_1SL_1BL,2CR,2ST,1AL_1SL_1AL_1GF,2MFP_1SC,2GF_2GF,5CR,2CR_2GF_2HU_1SI,1AL_1SC_1SL_1GF_2GF,2SL_3CR_1GF,2SI,1AL_2AL_1GF_2GF,3SL_3CR,1AL_2AL_1GF,1SI,2GF_3SL_3CR,2AL_1GF,2GF_3SL_3CR_1AL,3CC_1CR_2ST_1SI,1GF_4ST,1AL_3CC,4ST,2CC_1MFP_1GF_1AL,2AL_1GF_1HU,4CR,2AL_1SL,2BL_1SC_1AL_1FP_2HU,2SL_2CR_1GF_2SI,1AL_2CC_1SL_1BL";
	
	// Wave 05 - ASL_V1 W7 modified: 9 Scrakes, 5 Quarter Pounds, 4 Fleshpounds
	sink[i++] = 	"1SL_2AL_1GF*,2AL_2GF,4AL_3SI,2SL_3CR_1GF,1HU_2FP_2SC_1MFP,3CC_2ST_1BL,3CC_1AL*_1GF,2HU,4ST,4GF_2CR,2ST_4AL_1SI,1SC_1MFP,2HU_3AL_2AL*,2SL_2GF_2SI,4CR,2SL_3GF,2MFP_2SC_1FP,4CR,3SL_2BL,2HU,4CC,1SL_2AL*_1GF*,3BL_2SI,2AL_2GF,2SL_3CR_1GF*,3AL_2ST_1BL_2SI,3SC_1FP,3CC_1AL_1GF*,4ST,4GF,4ST_1BL_2SI,1MFP,3CC_2AL*,2SL_2CR_2GF_2SI,2SL_3GF*";
	
	// Wave 06 - ASL_V1 W8 modified: 8 Scrakes, 6 Quarter Pounds, 5 Fleshpounds
	sink[i++] = 	"4CC,2SL_3GF,2CC,2MFP_1SC,2BL,3AL_1GF*_1HU,2ST,1SL_2AL*_1GF,2SL_2GF*_1SI,3HU_1SC,3AL_1SL,4CR,3AL*_2GF,2FP_2MFP,2SL_3CR_1GF*,3CC_1CR_2ST,4GF_3SI,3HU,4ST,4AL_2SC,4SL,4GF,2CR_2GF*_2ST_1SI,5CR,2MFP_1FP_1SC,1BL,2SL_3GF,2CR,2AL*_1GF_1HU,3ST_1BL,1SL_2AL_1GF,2SL_3GF_2SI,3AL_1SL,2AL_2GF*,2FP_3SC_3CR,3CC_1CR_2ST_3BL_1SI,2HU,4ST,2AL*_2SL,4CC,4GF,2CR_2GF_2ST_1SI";
	
	// Wave 7 - ASL_V1 W9 modified: 10 Scrakes, 8 Quarter Pounds, 5 Fleshpounds
	sink[i++] = 	"4ST,3HU_2MFP,4CC_3BL,3AL_1SL,2AL*_2SC,5CR,2HU_2CR_2GF*_2SI,4GF,2ST,1BL_2AL_1GF*,2FP,2AL_2GF,2SL_3GF_2SC,2SL_3CR_1HU,3CC_2ST_3BL_1SI,2CC_2SL,2CR_2GF*_2ST_1SI,1FP_2MFP,4CC_1BL,3AL_1SL,2AL*_2SC,3CR,2SL_2CR_2GF_2SI,2GF_2GF*,2ST,2MFP_2SC,1SL_2AL_1GF,2HU,2AL*_2GF,2SL_3CR_1GF,3CC_2ST_2BL_1SI,2SL_3GF_1SC,2CC_2SL,2FP_1SC_2MFP,2BL_2GF*_2ST_1SI,2AL_2GF,2SL_1GF,2SL_2GF_1SI,3AL_1SL,2HU,1GF*_3CR,2CC_2AL_2SI,1AL*_2GF_1GF*";
	
	// Wave 08 - ASL_V1 W10 modified: 9 Scrakes, 6 Quarter Pounds, 6 Fleshpounds
	sink[i++] = 	"4CR,2SL_3GF,2CC,2MFP,3AL_1GF*_1HU,2ST,2HU,1SL_2AL*_1GF,2SL_2GF*_1SI,1FP_2SC,3AL_1SL,4CR,3AL*_2BL,1SI_2MFP,2SL_3CR_1GF*,3CC_1CR_2ST,4GF_3SI,3HU,4ST,4AL_2SC,4SL,4GF,2CR_2GF*_2ST_1SI,5CR,2FP_2SC,1BL,2SL_3GF,2CR,2AL*_1GF_1HU,2ST,1SL_2AL_1GF,2SL_3GF_2SI,3AL_1SL,2AL_2GF*,2FP_3SC_3CR,3CC_1CR_2ST_3BL_1SI,2HU,4ST,2AL*_2MFP,4CC,4GF,2CR_2GF_2ST_1SI";
	
	// Wave 09 - DOOM_V1 start: 10 Scrakes, 8 Quarter Pounds, 7 Fleshpounds
	sink[i++] = 	"2SC_3MFP,5CR,2HU_2CR_2GF*_2SI,4GF*,2ST,1SL_2AL_1GF*,2FP_1SC,2AL_2GF,2SL_3GF_2SC,2SL_3CR_1GF,3CC_2ST_3BL_1SI,2CC_2SL,2CR_2GF*_2ST_1SI,4ST,2FP_2HU,4CC_1BL,3AL_1SL,2AL*_2SC,3CR,2SL_2CR_2GF_2SI,2GF_2GF*,2ST,3MFP_2SC,1SL_2AL_1GF,2AL*_2GF,2SL_3CR_1GF,3CC_2ST_2BL_1SI,2SL_3GF_1HU,2CC_2SL,3FP_1SC_2MFP,2CR_2GF*_2ST_1SI,2AL_2GF,2SL_1GF,2SL_2GF_1SI,3AL_1SL,2HU,1GF*_3CR,2CC_2AL_2SL,1AL*_2GF_1GF*";
	
	// Wave 10 - DOOM_V1 final: 12 Scrakes, 10 Quarter Pounds, 8 Fleshpounds
	sink[i++] = 	"2SI_2SC,2SL_3GF*,2CC,4GF*_2SI,3MFP_1FP,3AL_1GF*_1HU,2ST,1SL_2AL*_1GF,2BL_2GF*_1SI,2FP_3SC,3BL,3AL_1SL,4CR,3AL*_2GF,1SI_3MFP,2SL_3CR_1GF*,3CC_1CR_2ST,4GF_3SI,3HU,4ST,4AL_2SC,4SL,4GF,2CR_2GF*_2ST_1SI,5CR,3FP_2SC,3BL,2SL_3GF,2CR,2AL*_1GF_1HU,2ST,2MFP,1SL_2AL_1GF,2SL_3GF_2SI,3AL_1SL,2AL_2GF*,2FP_3SC_3CR,3CC_1CR_2ST_3BL_1SI,4ST,2AL*_2MFP,4AL,4GF*";
}

function string GetDate()
{
	return "2018-12-04";
}

function string GetAuthor()
{
	return "HUNTER";
}
