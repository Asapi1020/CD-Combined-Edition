class CD_SpawnCycle_Preset_boss_only
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

	// Wave 01
	sink[i++] = "1AB_1KF_1AS,1PT_1AB_1HV,1KF_2AS_1PT,2AB_1MT,1KF_1PT_2AS,1AS_1PT,1KF_1MT_1AS,1PT,1HV_3PT,2MT,1MT,2AB_1MT_1PT,1MT_1PT,1AB_1HV,1AB_1PT,1AB,1AB_1AS,1AS,1MT_1KF_1AS";
	
	// Wave 02
	sink[i++] = "1HV,1PT_1AB,1MT,1KF_1MT_1AS_1AB,1KF_1HV,3KF_1MT,1KF_1AB_1PT,2AS_1PT,2PT_1AS,2PT_1AS,1KF_1AS_1PT,1PT_1MT,1PT_1AB_1MT,1MT_1KF_1AB_1HV,1AB_1HV_1PT,2AS_1AB,1PT_1MT_1AB,1PT_2HV_1KF,1HV_1AS";
	
	// Wave 03
	sink[i++] = "1PT_1AS,1KF_2MT_1PT,1PT_1HV_1AS,1MT,2PT_1AS,1HV_1MT,1HV,2AB_2AS,2AS_1KF,1AB_1AS_1MT,1HV,1KF_1MT,1MT_1HV,1AS_1PT,1MT_1HV_1PT_1KF";
	
	// Wave 04
	sink[i++] = "2PT_1MT,1HV_1AB_2MT,2AB_1AS,2AS,1KF_2AS_1PT,1KF_3MT,1KF_1AS,1HV_1AS_1AB,1AB_1PT,1MT,1AB_1AS,3AB,1AB,1AS_1HV,1AB_1KF,1HV,1AB,2KF,1PT_1HV,1PT_1HV_1AS";
	
	// Wave 05
	sink[i++] = "1AB_1PT_1MT,1AS,1AS,1PT_1MT_1KF,2HV_2MT,2HV_1AB,1AB_1AS,1MT_1AS,1AB_1HV,1AS,1PT_1MT,1MT,1AB_1AS_1KF,2KF_1PT,1MT_2KF,1MT_1PT_1AS_1KF,1PT_1MT_1KF,1HV";
	
	// Wave 06
	sink[i++] = "1HV,2PT_1AS_1AB,1AB_1KF_1AS_1PT,1PT_2KF_1HV,1PT_1AS,1MT,1AB,1KF_1AS,1KF_1HV_1MT,1AB_1MT_1HV_1PT,1PT_2AS_1AB,1HV_2KF_1AB,2MT,2KF_1PT_1AS,3MT_1KF,1AS,3PT_1MT,1AB_1HV_1PT_1KF";
	
	// Wave 07
	sink[i++] = "1PT,1PT_1KF,1MT_1AS_1AB,1HV,1PT_1AS,1AB_1KF,3HV,3PT_1HV,2AS_1KF,1AS,1KF_1AB_1AS,2AB_1HV_1AS,1KF_1AB_1PT,1MT_1PT,1HV_1MT";
	
	// Wave 08
	sink[i++] = "3PT_1HV,1HV_1AS_2AB,1AS_1HV,1AS_1AB_1PT,1KF_1HV_1MT,2PT,1AB_2PT,1AS_1MT,1KF_1AB,1MT_2AB_1HV,1KF_1AS_1AB,1AB_1AS_2MT,2KF_1AB_1MT,1AS,2KF_1MT_1AB,3PT_1MT,1HV_1AB,2MT_1PT,1PT_1HV_2AB,2KF_1PT";
	
	// Wave 09
	sink[i++] = "1PT_1AB_1KF_1HV,2PT_1HV_1KF,2MT_1AS_1PT,1KF,2MT,1MT_1HV_1PT_1AS,1HV_1AS_1PT,1PT_1AS,1AB_1AS,1AS_1KF_2MT,1MT_1PT_1AB,1MT_1HV,1AB_1HV_1MT,1KF,2HV_1PT_1AB,1MT,1KF_2PT";
	
	// Wave 10
	sink[i++] = "1AB,1MT_1KF,1HV_1PT_1KF,1PT_1AB_1AS,1HV,1PT,2AS_1AB,1PT_2MT,1AS,1AS_1PT_1HV,1AB,1MT,1AS_2HV_1AB,1HV_1PT,1KF_1AB_1HV_1AS,1KF_1PT";
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