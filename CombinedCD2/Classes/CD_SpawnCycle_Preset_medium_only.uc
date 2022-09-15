class CD_SpawnCycle_Preset_medium_only
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
	sink[i++] = "2SI,1BL,2HU_1SI,2BL_2SI,1SI,4HU,1SI_2HU,1SI_1HU_1BL,2HU_1BL,1BL_1HU,2BL_1HU,1SI,1SI_2HU,1BL_1SI,1BL,3BL,3SI_1BL,2HU_1SI_1BL,3BL";
	
	// Wave 02
	sink[i++] = "2SI_1BL,2BL_1SI,1SI_3HU,1SI,1HU_1BL,1BL,3HU,1BL,1SI,1HU_1SI,2HU_1BL_1SI,1BL_1SI,2HU,3BL_1HU,2HU_1SI";
	
	// Wave 03
	sink[i++] = "2SI,1BL_1SI,1HU_2BL,2BL,3SI_1BL,1SI,1SI_1BL,1HU,2HU_1SI,2SI_2BL,1SI_1BL,1BL_1SI_1HU,1HU_1SI,3BL,1SI_1BL,2HU_1SI,2BL_1SI,1BL";
	
	// Wave 04
	sink[i++] = "3BL,2HU_2BL,2BL_1HU_1SI,2BL_1HU,2HU_1SI_1BL,1BL_1HU_1SI,2HU,1HU_1SI,1SI_1BL,1HU,1HU,1HU,2BL_2SI,2SI_1HU_1BL,2BL_1SI_1HU,1HU_1BL_1SI,2BL_1SI_1HU,1SI,1BL";
	
	// Wave 05
	sink[i++] = "1SI,2HU_1SI,1HU_1BL,1BL_1HU_1SI,1SI,1BL,1SI_1BL_1HU,2HU_1BL,1SI,1HU_1SI,1SI_1BL,1BL,2BL_1SI_1HU,1SI,2BL_1HU,1HU,1HU_2BL_1SI,1HU,1SI";
	
	// Wave 06
	sink[i++] = "2HU,2BL,3HU_1SI,3SI,2HU_1SI,1BL,1HU,1HU_1BL,1SI_2HU_1BL,2BL_1HU,2HU_2BL,3SI_1BL,3BL_1SI,1SI,1BL_1SI_2HU,2SI";
	
	// Wave 07
	sink[i++] = "1BL_2SI,1SI,2BL_1HU_1SI,1BL_1HU,1BL_1SI_1HU,2HU_2BL,2HU_2BL,1BL_2SI_1HU,1SI,1SI,1SI_1HU_1BL,1HU_1BL_2SI,3BL_1HU,1BL,1BL_2HU_1SI,2SI_1BL_1HU,2BL,3BL,2BL_1SI";
	
	// Wave 08
	sink[i++] = "3SI_1HU,1SI,1SI_1HU,2HU_1BL,1HU_3SI,2SI_1BL_1HU,1BL_2HU,1BL,1SI_1BL,1SI,2BL_1HU,3HU,1SI,2HU_1SI_1BL,2BL_2SI,3HU,1BL";
	
	// Wave 09
	sink[i++] = "1HU,2HU_1BL_1SI,1HU,1SI,1SI,2HU_1BL_1SI,2HU_2SI,2BL,1SI_1HU_1BL,1SI_2BL_1HU,1HU_1SI_1BL,2SI,1HU_2SI_1BL,1HU,1SI_1HU";
	
	// Wave 10
	sink[i++] = "1HU,1HU,1SI_1HU,1SI_1HU,2HU,1HU,1SI_1BL,1BL,2HU_1BL,3SI_1BL,2BL_1SI_1HU,3HU_1BL,2BL_1SI,1SI,1SI_1BL,1SI_1BL,2HU_1BL";
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