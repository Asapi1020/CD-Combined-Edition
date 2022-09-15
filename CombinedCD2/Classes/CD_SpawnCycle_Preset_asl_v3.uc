class CD_SpawnCycle_Preset_asl_v3
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
	
	// Wave 01: added rioters and a third scrake, this was to encourage more teamwork and an attempt at reducing the prevalence of SWATs on wave 1, also added more husks and sirens
	sink[i++] = 
	"1CC_1AL_1BL,1CC_2AL*,3CC_2SL,1SL_4AL_2GF,2AL_2GF*,4CC_2AL_2GF,4CR,2SL_1BL,2AL*,1SC_3HU_1SI,3ST_1SL,1SL_2GF_1GF*,2GF,2CC_1AL_1AL*_1GF*,1CC_3GF,4SL,1AL*,3AL,3CC_2SL,1SL_2AL_2AL*_2GF,2BL_1HU_1SI,2AL_1GF,4CC_2GF,4CR,1SC_2BL_2HU_4SI,1CC_2AL*,3CC_2SL,1SL_3AL_2GF,2AL_2GF*,4CC_2AL_2GF,4CR,3SL_3BL,2AL*,1SC_2HU_2SI,3ST_1SL,1SL_2GF_1GF*,2GF,2CC_1AL_1AL*_1GF*,1CC_3GF,4SL,1AL*,3AL,3CC_2SL,1SL_2AL_2AL*_2GF,2BL_1HU_2SI,2AL_2GF,4CC_2GF,4CR";
	
	// Wave 02: added more mediums and a large zed, also switched some spawn squads to make the squads slightly more challenging
	sink[i++] = 
	"2AL*,5SL,1GF,2ST,2BL_1SI,2HU_1SC,4SL_2GF,3AL_2GF,3CC_1AL*_1GF*,4AL,4CR,1MFP_2CC_1AL,4SL,2GF*,2BL,2ST_1MFP_3SI,1HU,1SL_1GF,1AL*_2GF*,3CC_1AL_1GF,4CC,4CR,3GF_1SL_2BL,2ST,1AL*,2BL_2SI,1HU_2SC_1FP,2AL_1GF_1GF*,2GF,3CC_1GF,4CC,4CR,2AL*,5SL,1GF,2ST,2BL_1SI,2HU_1SC,4SL_2GF,3AL_2GF,2CC_1AL*_1GF*,4AL,4CR,1MFP_3CC_1AL,4SL,2GF*,2BL,2ST_1MFP_3SI,1HU,1SL_1GF,1AL*_2GF*,3CC_1AL_1GF,4CC,4CR,3GF_1SL_2BL,2ST,1AL*,2BL_1SI,1HU_2SC_1FP,2AL_1GF_1GF*,2GF,3CC_1AL_1GF,4CC,4CR,2AL*,5SL,1GF,2ST,2BL_1SI,2HU_1SC,4SL_2GF,3AL_2GF,3CC_1AL*_1GF*,4AL,4CR,2MFP_3CC_1AL,4SL,2GF*,2BL,2ST_1MFP_2SI,1HU,1SL_1GF,1AL*_2GF*,3CC_1AL_1GF,4CC,4CR,3GF_1SL_2BL,2ST,1AL*,2BL_1SI,1HU";
	
	// Wave 03: adjusted spawn squads, added slightly more husks
	sink[i++] = 
	"4CR,3AL,1BL_1SI,2SL_3CC_1GF*,2SC_2MFP,2CC_2AL*,2GF_3GF*,1HU,3CC_1AL*,3BL_2CC,2CR_2GF_2SL_1SI,4ST,4GF,4CR,2SL_3CC_1GF,3SC,3CC_1GF_1SI,1SL_3GF,1HU_2FP_1SC,2AL_2AL*,2CC,2GF*_2ST_1SI,4ST,4GF,4CR,3AL*,2SL_2AL_1GF*,2BL_2HU_2SI,2AL_1GF*,2MFP,1SL_3GF,1HU,4CR,2SL_1BL_2AL*,4SL_2CC_1GF,1BL_1HU,1SC_6SI,2CC_1GF,1SL_3GF,4CR,2AL,1BL,2SL_3CC_1GF*,2SC_2MFP,2CC_2AL*,2GF_3GF*,1HU_1SI,3CC_1AL*,3BL_2CC,2CR_2GF_2SL,4ST,4GF,4CR,2SL_3CC_1GF,3SC,3CC_1GF_1SI,1SL_3GF,1HU_2FP,2AL_2AL*,2CC,2GF*_2ST,4ST,4GF,4CR,3AL*,2SL_3AL_1GF*,2BL_1SI_1HU,2AL_1GF*,2MFP,1SL_3GF,1HU,4CR,3SL_1BL_2AL*,4SL_2CC_1GF,1BL_1HU,2CC_1GF,1SL_3GF";
	
	// Wave 04: adjusted spawn squads, added slightly more husks
	sink[i++] = 
	"2FP_3AL_2AL*,3SL_2ST_2SI,2BL_2HU,4CR,3CC,2AL_2GF*,3CC_1SI,3GF_2SC_2MFP,2AL,2SL_3GF,4AL_2ST_1SI,4CR,4GF,2AL_2GF*_2AL_1SI,2FP_2SC,3SL,2AL*,3HU_3BL,6CR_4ST,3CC_3BL_2SI,2GF,3CC_1GF*_1SI,2SL,1SL_3GF,2SC_3MFP,2SL_1AL*_2ST,5CR,4GF,2AL_2GF*_2ST_1SI,5CC_2ST,2SL,2SL_1AL*_2GF*,4GF_2HU";
	
	// Wave 05
	sink[i++] = 
	"2CR,4ST,2GF*_2ST_1SI,4CR,4CC_2ST_2BL_1SI,2AL_4ST_1HU,3FP_3SC,4CC_2BL,2AL*_1GF,4GF,4CR,4SL_2GF,1SL_3GF_1SC,3CC_1GF*_1SI,3AL*_1SL,4MFP_2HU,2GF_2ST_3SI,2AL_1GF*,5CR_1CC,2SL_4BL_2SI_1HU,2ST_2CC,3GF_1GF*,5CR_2FP,2AL_2GF_2AL*_1GF*,4SL_3GF,1GF,5AL_2SL,3GF_2HU,1AL*_3SC_2MFP,2CC_2AL_1AL*_2SL";
	
	// Wave 06
	sink[i++] = 
	"2AL*_1GF*_3HU,4CR,2AL_1CC,2SL_2GF_2SI,2FP_2MFP,2SC_4ST,3CC_1SL_3BL,4AL_1SC,2ST,1SL_2AL*_1GF,4GF,4CR,2GF*_2ST_1SI,1SL_3GF,2SL_1GF,3FP_2SC_1MFP,2ST_2BL_1SI,4SL,4ST,4CC_1AL*_1GF*,4AL_1GF*,4CR_2HU,3AL_1SL,2SL_2CR_2GF_2SI,1SL_2BL,4MFP,2AL*_2SC,2ST,1CC_2AL_1GF,4GF,5CR,2GF*_2ST_1SI,1HU,1SL_3GF,2SL_3CR_1GF,4CC_2ST_2BL_1SI,4CC_2FP,4ST,3CC_2AL*_1GF";
	
	// Wave 07
	sink[i++] = 
	"1SL_2AL_1GF*,2AL_2GF,2SL_3CR_1GF,1HU_3FP_2SC_2MFP,3CC_2ST_1BL,3CC_1AL*_1GF,4ST,4GF_2CR,2ST_4BL_1SI,2HU_3AL_2AL*,2SL_2GF_2SI,4CR,2SL_3GF,2MFP_2FP_2SC,4CR,3SL_2BL,2HU,4CC,1SL_2AL*_1GF*,2AL_2GF,2SL_3CR_1GF*,3AL_2ST_1BL_2SI,3SC_3FP,3CC_1AL_1GF*,4ST,4GF,4ST_1BL_2SI,3CC_2AL*,2SL_2CR_2GF_2SI,2SL_3GF*,2SC_4MFP,4CR,3SL_1BL,2HU,4CC_2AL*_3AL";
	
	// Wave 08
	sink[i++] = 
	"2MFP_4CC,2SL_3GF,2CC,3AL_1GF*_1HU,2ST,1SL_2AL*_1GF,2SL_2GF*_1SI,1BL_2SC,3AL_1SL,4CR,3AL*_2GF,3FP_4MFP,2SL_3CR_1GF*,3CC_1CR_2ST,4BL_3SI,3HU,4ST,4AL_2SC,4SL,4GF,2CR_2GF*_2ST_1SI,5CR,2FP_2SC,1BL,2SL_3GF,2CR,2AL*_1GF_1HU,2ST,1SL_2AL_1GF,2SL_3GF_2SI,3AL_1SL,2AL_2GF*,4FP_3SC_3CR,3CC_1CR_2ST_3BL_1SI,2HU,4ST,2AL*_2SL,4CC,4GF,2CR_2GF_2ST_1SI";
	
	// Wave 09
	sink[i++] = 
	"4ST,2HU_4MFP,4CC_3BL,3AL_1SL,2AL*_2SC,5CR,2HU_2CR_2GF*_2SI,4GF,2ST,1SL_2AL_1GF*,4FP,2AL_2GF,2SL_2GF_2SC,2SL_3CR_1GF,3CC_2ST_3BL_1SI,2CC_2SL,2CR_2GF*_2ST_1SI,4ST,3FP_3HU,4CC_1BL,2AL_1SL,2AL*_2SC,3CR,2SL_2CR_2GF_2SI,2GF_2GF*,2ST,2MFP_2SC,1SL_2AL_1GF,2AL*_2GF,2SL_3CR_1GF,2CC_2ST_2BL_3SI,2SL_3GF_1SC,2CC_2SL,3FP_1SC_2MFP,2CR_2GF*_2ST,2AL_2GF,2SL_1GF,2SL_2GF_1SI,3AL_1SL,2HU,1GF*_3CR,2CC_2AL_2SL,1AL*_2GF_1GF*";
	
	// Wave 10
	sink[i++] = 
	"1SL_2AL*_1GF*,5CR,3HU,2SI_2GF,2AL_1SC_3FP,3AL_2BL,2GF_1AL*,2SL_1GF*,2SL_2ST_2GF_1SI,2AL_1SL_1AL*,4SL_2CR,3ST_3BL_3SI,4CR,2GF_1SL,4SC_4FP,4MFP,3CC_1AL*_1GF*,2ST_3GF_1SC,3CC_1CR_2ST_1BL_1SI,1SL_2AL_1GF,4CR,1HU,3CC_1BL,2MFP_3GF_2FP,3CC_2GF*,2AL_2SC,2AL_2GF,2SL_3CR_1GF,2SL_2CR_2GF_1SI,3AL_1SL,3HU_3FP,1GF*_4CR,4ST,2CC,4ST_1BL_2SI,2CC_1AL_1GF,2SL_2GF_1GF*,2SC_2HU_3MFP,3CR,3CC_3ST_1BL,3GF_3SL";
}

function string GetLength()
{
	return "Long";
}

function string GetDate()
{
	return "2019-07-01";
}

function string GetAuthor()
{
	return "DarkDarkington";
}
