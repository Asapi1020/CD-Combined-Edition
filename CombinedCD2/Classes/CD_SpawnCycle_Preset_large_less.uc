class CD_SpawnCycle_Preset_large_less
	extends CD_SpawnCycle_PresetBase
	implements (CD_SpawnCycle_Preset);

function GetShortSpawnCycleDefs( out array<string> sink )
{
	GetNormalSpawnCycleDefs( sink ); 

	// keep waves 1, 3, 4, 7
	sink.Remove(1, 1); 
	sink.Remove(2, 1); 
	sink.remove(3, 1); 

	sink.Length = 4; 
}

function GetNormalSpawnCycleDefs( out array<string> sink )
{
	local int i;

	i = 0;

	sink.length = 0;
	sink.length = 7;

	// Wave 01
	sink[i++] = "1CR_2HU_1BL_2CY_2SI_1GF,3BL_2CR_2ST_1SI_1GF_1SL,3HU_2GF_2BL_1SL_1ST,3HU_1GF_1AL,2HU_2BL_2ST_1GF_1AL_1SL,1CR_1ST_1HU_1SI_2CY,1CY_1SL_1HU_1CR_2SI_1ST_1BL,2HU_2CY_2CR_2SI_1SL_1BL,2GF_1BL_1CY_2SL_2ST,1HU_1CY_1AL_2ST_3BL_1SI,2BL_1HU_3SI_1AL,1SI_2BL_1ST_2CY,1AL_1CR_1ST_1GF_1SI,2SI_2BL_2HU_1CR_1ST_1SL,1GF_4HU_3SI_1SL_1BL,2SI_2GF_1ST_1BL,4HU_1CR_1SI_1AL_1GF,3SI_3HU_2BL_1CY_1SL,1GF_2AL_1HU_1CY_3SI,1HU_4SI_1CR_1SL_2BL_1ST,3BL_1CY_3SI_1ST_1AL,2CY_2CR_1ST_1SI,3CY_2BL_1HU_2AL,3HU_1SL_1SI_1BL,2HU_2BL_1SI_2CY_1CR";
	
	// Wave 02
	sink[i++] = "3SI_1CR_3HU_2CY_1BL,1ST_3AL_1HU_1CR_1CY,1AL_1CY_3BL_2HU_1GF_2SI,2CR_1GF_2SL_1HU,4BL_1SI_2AL_2HU,2SI_2ST_1HU_2BL_1CR_1AL,2HU_2BL_1ST,1CY_2BL_1GF_1HU_1SI,1SL_2BL_1HU_1SI,3ST_1HU_1AL,2SI_2HU_1BL_1CR_1AL_1GF,2AL_2ST_2SI_1CR_1CY_2HU,1BL_3AL_3SL_2ST_1SI,1HU_2BL_2SI_1ST_1CR_1AL_1GF,1SI_1AL_4BL_1HU_1SL,1SI_1CR_1SL_2HU_1BL,2ST_2HU_1AL_1SI,2CR_1SL_2SI_1BL_2AL_2HU,3BL_1AL_2SL_1HU_1CR,2GF_1AL_1ST_1SI,2HU_1CY_1SL_1CR,2GF_1CR_2HU_1BL_1SL_2SI,1BL_4SI";
	
	// Wave 03
	sink[i++] = "4ST_1AL*_1BL_1CY_2SI,3CR_1HU_3SI_1SL,3BL_1GF_2CR_1SL_1CY,1SL_2ST_1BL_1AL,2SI_1BL_1GF*_1ST,1HU_1CR_3SI_1ST_1GF,1CY_2BL_1CR*_1HU,1SI_2AL*_1BL_1GF_1CR*_1CY_1SL,1CR*_1BL_1SL_1SI_1AL_1CR_2CY_1GF,1AL*_1SI_1HU_1SL_1CR_1BL,1BL_2SL_1CR*_1AL_1CR_1ST_1HU,1CY_1GF*_2HU_3SI_1GF_1BL,1SI_1CY_1GF_1AL_1ST_1CR_1SL,1SI_2HU_1CR_1ST_1GF*_1BL_1GF,1GF_1HU_1AL*_1BL_1CR,1ST_1HU_1CR*_2BL,1SI_2BL_2ST_1AL*_1AL";
	
	// Wave 04
	sink[i++] = "2CY_2HU_1CR*_2SI_1CR,2HU_2BL_2ST_1AL*,4SI_3BL_1SL_1CY_1GF,2ST_2HU_1SL_1CR_1SI_1CY_1AL,1GF_1CR_1BL_1ST_1SL_2HU_1SI,1HU_1SI_1GF_1CR*_3BL,2SL_1AL_2HU_2CR_2CY_1SI,2CR_1BL_1GF*_2HU_1GF_1SI,2SI_1AL*_1CR*_1CY,1SL_1BL_1ST_1HU_1CR_1CY,2SI_2BL_1CY_1ST,1SL_1BL_1CR*_1HU_1AL,2BL_2SL_3HU_1SI_1CY_1AL,1ST_1SL_1AL*_2SI_2CR_1BL_1AL,2GF_1SL_1AL*_2SI_1BL_1CY,2HU_3BL_1SL_1ST_1AL_2SI";
	
	// Wave 05
	sink[i++] = "1BL_3HU_1ST_2SI,3SI_1GF_2BL_1SL_1AL_1HU_1CY,3SI_1BL_1HU,3SI_2CR*_1BL_1ST_1HU,1ST_2SL_1CY_1SI_1HU,2CY_1CR*_1HU_1BL_1ST_1AL,1ST_4SI_1CY_1AL_1BL_1CR*,3SI_1GF_1AL_2BL_1CR*_1CR,1ST_2CY_3BL_1SL_1HU,2SL_2ST_1CY_1GF_1SI_2CR,1AL_2CY_1BL_1CR_1SI_1HU,1SI_2HU_1GF_1SL,2BL_1CY_2GF_1SL_1CR*_1SI,2AL_1GF_1HU_1CY_1AL*_1BL_1CR,1GF_1ST_1SI_1BL_1AL,1CR*_2BL_3HU_1SL,1AL_1SL_1HU_1SI_1ST,3SI_3BL_1CY_1ST,4SI_1BL_2SL_1GF*_1CY_1HU,1BL_2SL_1SI_1HU";
	
	// Wave 06
	sink[i++] = "1AL_1SI_2HU_1CY_1CR*_1ST,2AL*_2ST_1AL_2HU_1CY,1BL_1AL_3SI,2ST_1CY_1AL*_3HU_1BL_1GF*_1GF,1AL_2SI_1CY_1BL_1CR_1ST_1GF*,4HU_1AL_1SI_1AL*_1GF_1SL_1BL,1AL*_2SI_1BL_1CY,1ST_1GF_1BL_1SI_1CR_1AL,2CY_1GF*_2HU_1SI_2ST_2BL,3HU_2SI_2SL_1AL_1BL,1HU_1CR*_1BL_1CY_1SL_1ST_1CR,1AL_2HU_1SL_3SI,3SI_2GF_1BL_2AL,1CY_2GF_1SL_1HU_2SI_1ST_1BL,2CR_1SL_1GF_1BL,3BL_1AL_1HU_1SL,3AL_1ST_1SL_1BL,1BL_1SL_1HU_2ST,2CY_1AL*_1GF_1ST_1HU,2ST_1SL_1SI_1CR_2BL_1CR*,1AL_1GF_1BL_2HU_1SL,3SI_1CY_1GF_1ST_2HU";
	
	// Wave 07
	sink[i++] = "1AL_2BL_1ST_1SI_1SL_1CY,2CY_1SI_1HU_1AL_1CR,2GF_1CR_1ST_1AL_2SI_2HU,1HU_2GF_1CY_1BL,1SI_1ST_2CR_1BL_1HU_1CY,2HU_1GF_1ST_1AL*_1BL_1CY,2SL_1GF_1CY_2AL_1SI_1BL_1HU,2CY_1HU_2SI,2SI_2HU_1BL_2GF_1ST_1CY_1SL,2SI_1CR_2BL,2SL_1CR_1BL_1CR*_1SI_1HU,2HU_1BL_2SL_1CY_1ST_1GF,4BL_1CY_1SI_3HU_1ST,1SI_1SL_1CR_1AL_1CY_2HU_1ST,2BL_1SL_2CY_2ST_1HU_1CR*_1CR,1GF*_1AL*_1ST_1SI_1HU";

}

function GetLongSpawnCycleDefs( out array<string> sink )
{
	sink.length = 0;
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