class CD_SpawnCycle_Preset_boss_rush
	extends CD_SpawnCycle_PresetBase
	implements (CD_SpawnCycle_Preset);

function GetShortSpawnCycleDefs( out array<string> sink )
{
	local int i;

	i = 0;

	sink.length = 0;
	sink.length = 4;

	// Wave 01 
	sink[i++] = "2SL_1BL,1DR_1CY_2ST,1SL_1DE_1HU_1DR,1CY_1HU_1ST,1BL_1CY_1AL_1DE,2CR_1GF_1ST_1DL,1DR_1AL_1GF,1GF_1HU_1CY_1DL_1ST,1GF_1HU_2DR_1CY,1HU_2AL,1HU_2DR_1SL_1CR_1DL,1AL_1DL_1SI_1DR_1CR,2CY_1GF_1DL,1DR_1DL_1ST_2SI,2SL_1DE_1AL,1CR_1HU_1AL,1GF_1SI_1CY_1DR_1ST";
	
	// Wave 02 -
	sink[i++] = "1PT_1HV_2MT_2AB,1MT_2PT_1HV,1PT_1DR_1MT_1HV_1DL,1KF_1CY_1MT_1PT,1ST_1HV_2AB_1KF_1PT,1MT_1KF_1AB,2AB_2HV_1PT_1GF,1KF_1MT_1PT,3AB_2HV,2KF_1PT_1MT_1DL,2HV_1KF,2KF_1AB_1MT_2PT,1AB_4HV_1MT,1MT_1HV_1AB_1PT_1KF,1AB_1PT_2MT,3MT_2KF_1PT";
	
	// Wave 03 
	sink[i++] = "2MT_1FP,1AB_1SC_1KF_1MT,1SI_1KF_1HV_1MT,4HV_1KF_1AB,1KF_2MT_1SI_1AB_1HV,2MT_1KF,2MT_1PT,2HV_1AB_3MT,1MT_2KF_1SL,2AB_1KF_1GF,2MF_2AB_1FP,1PT_1MT_2HV,1AB_2HV_1PT_2KF,1KF_1HV_1GF_1ST_1DR,1MF_1HV_1MT,5KF_1AL,1MT_1KF_1HV_1PT";
	
	// Wave 04
	sink[i++] = "1MF_1DE_1AB,1MF_1KF_1AB_2MT_1HV,2KF_1HV_1BL_1HU_1AL,1MT_1KF_1AB,1MT_2AB_1GF_1HV,1MT_1GF_1HV_1KF,1MF_1HV_1PT_1CY,1AB_1KF_1HU_1FP*,1MT_2AB,1KF_1PT_1DL,2AB_1SC_1KF,1DE_1PT_2MT_1AB,2HV_2KF_1BL_1MT,1HV_1MT_2PT,2MT_1PT_1AB,1HV_1ST_1KF_1PT_1MF_1AB,2PT_1MF,2HU_1MT_1SL_1PT,1MT_1HV_1CY_1KF_1AB,2FP_1KF_1PT";
}

function GetNormalSpawnCycleDefs( out array<string> sink )
{
	sink.length = 0;
}

function GetLongSpawnCycleDefs( out array<string> sink )
{
	sink.length = 0;
}

function string GetDate()
{
	return "Unknown";
}

function string GetAuthor()
{
	return "Tamari";
}
