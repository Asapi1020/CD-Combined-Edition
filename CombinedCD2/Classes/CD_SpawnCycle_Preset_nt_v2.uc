class CD_SpawnCycle_Preset_nt_v2
	extends CD_SpawnCycle_PresetBase
	implements (CD_SpawnCycle_Preset);

function GetShortSpawnCycleDefs( out array<string> sink )
{
	sink.length = 0;
}

function GetNormalSpawnCycleDefs( out array<string> sink )
{
	sink.length = 0;
}

function GetLongSpawnCycleDefs( out array<string> sink )
{
	local int i;

	i = 0;

	sink.length = 0;
	sink.length = 10;

	// Wave 01
	sink[i++] = "1CY_1AL_1SL_1GF_1AL*_1GF*,1CR_1ST_1CY_1AL*_1AL_1SL,1GF_1CR_1AL*_1CY_1AL_1ST,1SL_1AL*_1GF_1CY_1SI_1BL,2AL*_1AL_1CR_1SL_1GF,1HU_1CY_1AL_1GF*_1AL*_1ST,1SL_1GF_1CR_1AL*_1SC_1CY,2AL_1CY_1SL_1GF_1BL,1SI_1CR_1ST_1CY_1AL_1SL,1GF_1CY_1AL_1CR_1SL_1HU,1GF_1GF*_1ST_1CY_1AL_1SL,1GF_1CR_1CY_1AL_1SL_1BL,1SI_1GF_1CY_1AL_1ST_1CR,1CY_1AL_1FP_1SL_1GF_1GF*,1CR_1CY_1AL_1SL_1GF_1HU,1ST_1CY_1AL_1SL_1GF_1BL,1SI_1CR_1CY_1AL_1ST_1SL,2GF_1CY_1AL_1CR_1SL,1GF*_2CY_1AL_1CR_1ST,1AL_1SL_1GF_1CY_1SI_1BL,1HU_1CY";
	
	// Wave 02 	
	sink[i++] = "1CY_1AL_1SL_1GF_1GF*_1CR,2ST_1CR_1CY_1GF_1AL,1SL_1SC_1CR_1ST_1CY_1GF,1AL*_1GF*_1AL_1BL_1SL_1HU,1SI_1CR_1ST_1SC_1CY_1GF,1CR_1ST_1AL_1SL_1CY_1GF,1CR_1AL*_1ST_1GF*_1AL_1SC,1SL_1FP_1BL_1CY_1GF_1HU,1SI_2CR_1ST_1AL_1SL,1ST_1SC_1AL*_1CY_1GF_1GF*,1CR_1ST_1CY_1AL_1SL_1BL,1GF_1CR_1ST_1SC_1CY_1HU,1SI_1GF_1AL_1AL*_1SL_1CR,1GF*_1CY_1GF_1CR_1AL_1SC,1SL_1CY_1GF_1BL_1FP_1CR,1FP_1SI_1HU_1AL_1AL*_1SL,1GF*_2CY_1GF_1AL_1SL,2GF_1AL_1SL_1CY_1GF*,1CY_1BL_1AL_1SI_1HU_1FP,1AL*_1SL_2GF_1CY_1AL,2SL_2CY_1GF_1AL,2AL_1SL_2CY_1BL,1AL*_1AL_1SI_1FP_1HU";
	
	// Wave 03 
	sink[i++] = "1CY_1AL_1SL_1GF_1GF*_1CR,2ST_1CR_1CY_1GF_1SC,1AL_1SL_1CR_1ST_1CY_1GF,1GF*_1AL_1SI_1BL_1HU_1SC,1SL_1CR_1FP_1ST_1CY_1GF,1CR_1ST_1AL_1SL_1CY_1SC,1GF_1CR_1ST_1GF*_1AL_1SL,1SI_1BL_1HU_1CY_1GF_1SC,2CR_1ST_1AL_1SL_1FP,1ST_1CY_1GF_1GF*_1CR_1SC,1ST_1CY_1AL_1SL_1SI_1BL,1HU_1GF_1CR_1ST_1CY_1SC,1GF_1AL_1SL_1CR_1ST_1GF*,1CY_1GF_1FP_1CR_1ST_1SC,1AL_1SL_1SI_1BL_1HU_1CY,1GF_1CR_1ST_1AL_1SL_1SC,1GF*_1CR_1ST_1CY_1GF_1AL,1SL_1CR_1ST_1CY_1FP_1SC,1FP_1HU_1SI_1BL_1GF_1CR,1ST_1AL_1SL_1CY_1GF_1GF*,1CR_1ST_1CY_1AL_1SL_1GF,1CR_1ST_1CY_1SI_1HU_1FP,1BL_1GF_1CR_1ST_1AL_1SL,1GF*_1CR_1ST_1CY_1GF_1AL,2SL_1CY_1GF_1GF*_1AL,1CY_1AL_1BL_1SI_1HU_1FP";
	
	// Wave 04 
	sink[i++] = "1CY_1AL_1SL_1GF_1GF*_1CR,1ST_1GF_1SC_1CY_1CR_1AL,1SL_1ST_1GF_1GF*_1CY_1SC,1BL_1SI_1FP_1HU_1CR_1AL,1SL_1ST_1SC_1GF_1CY_1CR,1GF_1GF*_1AL_1SL_1ST_1SC,1CY_1BL_1CR_1GF_1SI_1FP,1HU_1AL_1SC_1SL_1ST_1CY,1GF_1GF*_1CR_1AL_1SL_1SC,2GF_1ST_1BL_1CY_1CR,1GF*_1HU_1SC_1FP_1SI_1CY,1AL_1SL_1CR_1ST_1GF_1SC,1CY_1CR_1AL_1BL_1SL_1ST,1GF_1GF*_1SC_1CY_1SI_1FP,1HU_1CR_1GF_1AL_1SL_1SC,1ST_1CY_1GF_1GF*_1BL_1CR,1AL_1SL_1SC_1ST_1GF_1CY,1CR_1SI_1FP_1HU_1AL_1SL,1FP_1HU_1SI_1GF_1GF*_1BL,1ST_1CY_1CR_1GF_1AL_1SL,1ST_2CY_1CR_1GF_1GF*,1AL_1SL_1CR_1SI_1HU_1FP,1BL_1ST_2GF_1CY_1GF*,2CR_1AL_1SL_1ST_1CY,2AL_1SL_1ST_1GF*_1CY,1SL_1BL_1ST_1SI_1HU_1FP"; 

	// Wave 05 
	sink[i++] = "1CY_1AL_1SL_1GF_1GF*_1CR,1ST_1GF_1SC_1CY_1AL_1SL,1CR_1ST_1HU_1GF_1GF*_1SC,1BL_1FP_1GF_1CY_1AL_1SI,1SL_1CR_1SC_1ST_1GF_1HU,1GF*_1GF_1CY_1AL_1SL_1SC,1CR_1BL_1ST_1FP_1GF_1GF*,1CY_1AL_1SC_1HU_1SL_1SI,2GF_1CR_1ST_1CY_1SC,1AL_1SL_1BL_1CR_1ST_1FP,1HU_2GF_1SC_1GF*_1CY,1AL_1SL_1CR_1ST_1GF_1SC,1SI_1GF*_1HU_1BL_1GF_1CY,1AL_1FP_1SC_1SL_1CR_1ST,1GF_1GF*_1CY_1AL_1SL_1SC,1HU_1GF_1CR_1ST_1BL_1SI,1GF_1CY_1SC_1FP_1AL_1SL,1GF*_1CR_1HU_1ST_1GF_1SC,1GF_1CY_1AL_1SL_1CR_1BL,1ST_2GF_1SC_1GF*_1FP,2SI_1CY_1AL_1FP_1HU,1SL_1CR_1ST_1GF_1GF*_1CY,1BL_1AL_1SL_1GF_1CR_1ST,1FP_1HU_1SI_1GF_1GF*_1CY,1AL_1SL_1CR_1ST_1GF_1CY,1AL_1BL_1SL_1SI_1FP_1HU,2CR_1ST_1GF*_1CY_1SL,2ST_1GF*_1CY_1CR_1BL,1SI_1HU_1FP"; 
	
	// Wave 06 
	sink[i++] = "1CY_1AL_1SL_1GF_1GF*_1CR,2ST_1SC_1GF_1CR_1CY,1AL_1SL_1HU_1SC_1FP_1BL,2GF_1SI_1GF*_1CR_1SC,1ST_1CY_1AL_1SL_1GF_1HU,1GF*_1SC_1CR_1FP_1BL_1ST,1GF_1CY_1AL_1SC_1SI_1SL,1GF_1GF*_1HU_1CR_1ST_1SC,1GF_1CR_1FP_1BL_1ST_1CY,1AL_1SC_1SL_1GF_1GF*_1HU,1SI_1GF_1CR_1SC_1ST_1CY,1AL_1FP_1BL_1SL_1GF_1SC,1GF*_1CR_1HU_1ST_1GF_1CY,1AL_1SC_1SI_1SL_1GF_1GF*,1FP_1BL_1CR_1SC_1ST_1HU,1GF_1CR_1ST_1CY_1AL_1SC,1SL_2GF_1GF*_1SI_1FP,1BL_1SC_1HU_1CR_1ST_1CY,1AL_1SL_1GF_1SC_1GF*_1CR,1ST_1GF_1CY_1BL_1FP_1SC,2HU_2SI_1AL_1FP,1SL_2GF_1GF*_1CR_1ST,1CR_1ST_1CY_1BL_1AL_1SL,1FP_1HU_1SI_2GF_1GF*,1CR_1ST_1CY_1AL_1SL_1GF,1GF*_1CR_1BL_1SI_1FP_1HU,1ST_1GF_1CY_1AL_1SL_1GF*,2CR_2ST_1GF*_1BL,1SI_1HU_1FP";
	
	// Wave 07 
	sink[i++] = "1CY_1AL_1SL_1GF_1GF*_1CR,1SC_1ST_1GF_1CR_1SL_1GF*,1HU_1SC_1FP_1BL_1SI_1ST,2GF_1CY_1SC_1AL_1CR,1SL_1HU_1GF*_1SC_1ST_1FP,1BL_1GF_1CY_1SI_1SC_1AL,1CR_1GF_1HU_1SL_1GF*_1SC,1ST_1GF_1FP_1BL_1CR_1CY,1SC_1AL_1SI_1HU_1SL_1GF,1GF*_1SC_1ST_1CR_1GF_1FP,1BL_1SL_1SC_1GF*_1HU_1ST,1CY_1SI_1AL_1SC_1GF_1CR,1GF_1SL_1FP_1BL_1SC_1HU,1GF*_1CR_1ST_1GF_1CY_1SC,1SI_1AL_1GF_1CR_1BL_1FP,1SC_1HU_1SL_1GF*_1ST_1GF,1CY_1SC_1AL_1CR_1SL_1SI,1HU_1BL_1SC_1FP_1GF_1GF*,1ST_1GF_1CR_1SC_1CY_1AL,1SL_1GF*_1HU_1SI_1SC_1FP,1BL_1ST_1GF_1FP_1SI_1HU,1CR_1GF_1SL_1GF*_1ST_1CY,1AL_2GF_1BL_1CR_1SL,1FP_1HU_1SI_1GF*_1ST_1CR,2GF_1CY_1AL_1SL_1BL,1GF*_1CR_1ST_1SI_1FP_1HU,1GF_1CY_1AL_1CR_1SL_1GF*,2ST_2GF_1BL_1GF*,1SI_1HU_1FP";
	
	// Wave 08	
	sink[i++] = "1CY_1AL_1SL_1GF_1GF*_1CR,1SC_2ST_1GF_1CR_1SL,1HU_1SC_1FP_1BL_1GF*_1GF,1AL_1CY_1SC_1SI_1GF_1CR,1ST_1HU_1SL_1SC_1FP_1GF*,1GF_1BL_1AL_1CR_1SC_1ST,1CY_1GF_1HU_1SL_1SI_1SC,1FP_1GF*_1GF_1CR_1ST_1BL,1SC_1AL_1SL_1HU_1GF_1GF*,1CY_1SC_1FP_1CR_1ST_1GF,1SL_1SI_1SC_1BL_1HU_1GF*,1AL_1GF_1CR_1SC_1FP_1ST,1CY_1GF_1SL_1GF*_1SC_1HU,1CR_1BL_1ST_1GF_1SI_1SC,1FP_1AL_1GF_1CR_1ST_1SL,1SC_1HU_1GF*_1CY_1GF_1BL,1AL_1SC_1FP_1CR_1ST_1SL,1GF_1HU_1SC_1SI_1GF*_1CY,1GF_1CR_1BL_1SC_1FP_1ST,1AL_1SL_1HU_1GF*_1SC_1GF,1CR_1ST_1GF_1CY_1SI_1SC,1FP_1BL_1SL_1GF*_1AL_1GF,1SC_1CR_1ST_1GF_1SL_1GF*,1CR_1FP_1ST_1CY_1GF_1BL,1AL_2SI_1SL_1FP_1HU,2GF_1GF*_1CR_1ST_1CY,1AL_1CR_1BL_1SI_1FP_1HU,1ST_1SL_1GF*_2GF_1CR,1ST_1SL_1GF*_1SI_1FP_1HU,1AL_1BL_1CY_1GF_1CR_1ST,1GF_1SL_1GF*_1FP_1HU_1SI,1AL_1CR_1ST_1CY_1GF*_1BL,1CR_1SI_1HU_1FP";
	
	// Wave 09 
	sink[i++] = "1CY_1AL_1SL_1GF_1GF*_1CR,1SC_2ST_1GF_1CR_1GF*,1SL_1SC_1FP_1BL_1HU_1GF,1AL_1CR_1SC_1SI_1ST_1CY,1GF_1GF*_1CR_1SC_1FP_1BL,1ST_1HU_1SL_1GF_1SC_1AL,1GF_1CR_1ST_1GF*_1CY_1SC,1FP_1SI_1BL_1SL_1GF_1HU,1SC_1CR_1ST_1AL_1GF_1GF*,1CR_1SC_1FP_1ST_1SL_1BL,1GF_1GF*_1SC_1HU_1CR_1SI,1ST_1CY_1AL_1SC_1FP_1GF,1SL_1GF_1BL_1CR_1SC_1ST,1GF*_1HU_1GF_1AL_1CR_1SC,1FP_1ST_1CY_1SI_1SL_1BL,1SC_1GF_1GF*_1CR_1ST_1HU,1GF_1SC_1FP_1AL_1CR_1ST,1SL_1GF_1SC_1BL_1GF*_1CY,1GF_1SI_1HU_1SC_1FP_1CR,1ST_1AL_1GF*_1SL_1SC_1BL,2GF_1CR_1ST_1GF*_1SC,1FP_1HU_1CR_1ST_1CY_1SI,1SC_1AL_1BL_1SL_1GF_1CR,1ST_1SC_1FP_1GF_1GF*_1HU,1SL_1GF_1CR_1ST_1AL_1BL,1CY_1GF_1GF*_1FP_1SI_1CR,1ST_1FP_1HU_1SI_1SL_1GF,1AL_1CR_1BL_1ST_1GF*_1GF,1CR_1FP_1HU_1SI_1ST_1CY,1SL_2GF_1GF*_1AL_1BL,1CR_1FP_1HU_1SI_1ST_1SL,1GF_1GF*_1CR_1ST_1CY_1AL,1FP_1HU_1SI_1BL_1GF_1SL,1GF*_2SI_2HU_1FP,1FP";

	// Wave 10
	sink[i++] = "1CY_1AL_1SL_1GF_1GF*_1CR,1SC_1ST_1GF_1GF*_1CR_1FP,1ST_1SC_1BL_1HU_1GF_1SL,1SI_1AL_1SC_1CY_1GF_1FP,1GF*_1CR_1ST_1SC_1BL_1HU,1GF_1SL_1GF*_1CR_1SC_1FP,1ST_1SI_1AL_1GF_1CY_1SC,1BL_1GF_1HU_1GF*_1CR_1FP,1SC_1ST_1SL_1GF_1AL_1GF*,1CR_1SC_1BL_1SI_1ST_1FP,1HU_2GF_1SC_1CY_1SL,1GF*_1CR_1ST_1SC_1BL_1FP,1AL_1GF_1HU_1SI_1SC_1GF*,1CR_1ST_1GF_1SL_1BL_1SC,1FP_1CY_1GF_1GF*_1CR_1HU,1SC_1ST_1AL_1GF_1SI_1FP,1SL_1SC_1BL_1GF*_1CR_1ST,1GF_1CY_1SC_1HU_1AL_1FP,1GF_1GF*_1CR_1SC_1BL_1SI,1ST_1SL_1GF_1GF*_1SC_1FP,1HU_1CR_1ST_1GF_1AL_1SC,1BL_1CY_1SL_1GF_1GF*_1FP,1SC_1SI_1HU_1CR_1ST_1GF,1GF*_1SC_1BL_1CR_1ST_1FP,1AL_1GF_1SC_1SL_1CY_1HU,1GF_1SI_1GF*_1SC_1BL_1FP,1CR_1FP_1HU_1SI_1ST_1GF,1AL_1SL_1GF*_1CR_1ST_1BL,2GF_1FP_1HU_1SI_1CY,1GF*_1CR_1ST_1SL_1AL_1GF,1BL_1FP_1HU_1SI_1GF*_1CR,1ST_2GF_1CY_1SL_1CR,1FP_1HU_1SI_1BL_1ST_1GF,1CR_2SI_2HU_1FP,1FP";
}

function string GetDate()
{
	return "2023-06-12";
}

function string GetAuthor()
{
	return "EtherealDoom";
}
