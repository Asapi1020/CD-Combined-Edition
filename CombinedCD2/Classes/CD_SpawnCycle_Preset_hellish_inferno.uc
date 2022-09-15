class CD_SpawnCycle_Preset_hellish_inferno
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
	sink[i++] = "8HU_1CR,8HU,8HU,1ST_5HU,7HU_1AL,1CR_2GF_6HU,10HU,7HU_1GF,6HU_1CR_1AL,5HU_1GF,6HU_1ST,2AL_3HU,6HU_1ST,5HU_1AL_1SL,5HU,8HU,8HU_1GF,5HU,6HU,5HU,8HU,6HU";
	
	// Wave 02
	sink[i++] = "6HU,8HU_1GF,9HU,8HU_1AL,8HU,5HU_1SL,5HU,9HU_1GF,9HU_1ST,5HU_1GF*,7HU_1CY_1ST,7HU_1CR,5HU_1GF,4HU_1CR*,9HU,6HU_1ST,7HU_1CY,6HU,9HU_1CY,5HU_1GF";
	
	// Wave 03
	sink[i++] = "5HU,5HU,10HU,7HU_1GF,7HU_1AL,7HU_1AL,9HU_1ST,1AL*_9HU,6HU,6HU,10HU,7HU,10HU,5HU_1CY_1GF,10HU,5HU,9HU_1ST,1CY_7HU_1CR,8HU,8HU_1AL*_1GF,9HU";
	
	// Wave 04
	sink[i++] = "5HU_1MF,1FP_1SC_6HU,7HU,1FP_5HU_1SC,5HU_1FP,7HU_1AL_1FP,9HU,8HU,1FP_7HU,9HU_1SL,4HU_1AL,5HU_1CY,7HU,1GF_1AL_5HU_1MF,1CR_8HU_1SL,9HU_1SL,5HU,8HU_1SC,9HU_1SC,7HU_1SC_1FP,1FP_3HU_1SL_1GF,4HU_1FP,1SC_5HU_1CR_1SL,5HU_1MF,6HU_1MF";
	
	// Wave 05
	sink[i++] = "1CR_7HU_1CR*,5HU_1CY,1FP_7HU,6HU,4HU_1FP,8HU,7HU_1AL,1SC_5HU_1MF_1CY,10HU,8HU,8HU_1FP,1GF_8HU_1MF,10HU,8HU_1CR,9HU_1GF,1CY_2HU_1MF_1SC,1CR_4HU";
	
	// Wave 06
	sink[i++] = "7HU_1ST_1MF,5HU_1GF,7HU,5HU_1FP_1MF,8HU_1CY,9HU,1AL_8HU_1FP,6HU_1SC,9HU_1AL,9HU,4HU_1CR,6HU_2SC,1MF_6HU,8HU_1SC,9HU_1MF,9HU,2SC_1SL_5HU_1CY,1MF_5HU_1GF_1CR_1CY_1CR*,2FP_5HU,5HU_1SC,7HU_1SC_1CR_1MF,8HU,4HU_1GF";
	
	// Wave 07
	sink[i++] = "9HU,5HU_1CR_1MF,10HU,1AL_6HU_1SL,9HU_1SL,1SL_1MF_1AL_1SC_5HU_1CR,5HU,7HU,5HU_1AL,1FP_5HU_1GF,7HU,8HU_1ST,7HU_2SC,4HU_1MF_1AL,1SC_3HU_1CR,9HU_1SL,5HU,7HU_1CR_1SL";

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