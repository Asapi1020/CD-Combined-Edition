class CD_SpawnCycle_Preset_large_only
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
	sink[i++] = "1MF,3SC_1FP,2MF,2SC_1FP_1MF,1FP_2SC,2SC_1FP_1MF,1FP_3MF,2MF_1SC,1SC_2FP,1MF_2FP,2FP_2MF,1MF_1SC,1FP_1MF,3FP_1SC,1FP_1MF,2SC_1FP";
	
	// Wave 02
	sink[i++] = "3FP_1MF,1MF,1FP_1MF,1FP,1SC,3SC_1MF,1SC,1MF_1SC,2FP_1MF,2MF,1MF,1SC_1FP_1MF,1MF,3FP,1SC_1MF_2FP";
	
	// Wave 03
	sink[i++] = "2FP_1SC_1MF,1FP,1SC_2FP_1MF,1MF_1FP,2SC_1FP_1MF,2SC_1MF,1MF,2MF_1FP_1SC,2SC,1MF_1SC,1MF_1FP,1SC_2MF_1FP,1FP,2MF_1SC,1FP_1SC,1SC_1MF,1SC_1MF,2MF";
	
	// Wave 04
	sink[i++] = "1FP,1FP_1SC,1FP_2MF,2MF,2MF_2SC,1SC_1FP,2MF_1FP,2SC_1FP_1MF,1FP,1MF,1FP_1MF_1SC,1FP_2SC_1MF,1MF,1SC_1MF,1SC_1FP,1MF";
	
	// Wave 05
	sink[i++] = "1FP,1SC_1MF,1FP_1SC,2SC,1FP,2MF_1SC,1SC,1MF_1SC,3FP,2SC_1MF,1MF_1SC_2FP,2FP_1MF_1SC,3SC_1MF,2MF,3MF_1SC,2MF_1SC,2SC_1MF,2SC_1MF";
	
	// Wave 06
	sink[i++] = "2SC_1FP_1MF,3SC_1MF,1FP_1SC,1MF,2SC_1FP_1MF,1FP,1MF_2FP,1FP,1FP,1MF,2FP_1SC,1MF_1SC,2FP_1MF,2SC,2FP_1MF";
	
	// Wave 07
	sink[i++] = "1MF_2SC,2SC_1FP,3MF,1SC_1FP,1SC_1MF,2SC_1MF,1FP_2SC_1MF,2SC_1MF,1SC,1MF_2FP,1MF,1SC_1MF,1SC_1MF,3FP,1FP_1MF";
	
	// Wave 08
	sink[i++] = "1FP_1SC,1SC,2MF,2SC_1MF_1FP,2FP_1SC_1MF,2SC_1FP,2FP_1SC_1MF,3MF,1SC,1FP_1SC,1FP,1SC_1MF_1FP,1MF!,1FP_1MF,1FP,1SC_1MF_1FP,3MF,2FP,1MF_1MF!_1SC";
	
	// Wave 09
	sink[i++] = "1SC_1MF,1SC,1SC,1SC_3MF,2SC,1FP_2MF,1SC,1SC,1FP,1FP_2SC,2SC,2SC_1MF,1SC_1MF_2FP,2FP_1SC_1MF,1SC_2MF,1MF_1SC_2FP,1MF,1FP,2FP_1SC,2MF";
	
	// Wave 10
	sink[i++] = "1FP_1MF,1FP_1MF,1SC,3MF_1SC,2SC,2FP_2SC,1FP_1MF_2SC,1MF_1FP,2SC,2SC_1FP_1MF,1FP_2SC_1MF,2MF,2FP,1FP,2SC_2FP,2FP,2SC";
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