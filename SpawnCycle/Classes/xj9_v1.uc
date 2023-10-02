class xj9_v1
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

	sink[i++] = "9GF*,9GF,9CR,9AL*,9BL,9ST,9SI,9SL,9AL,9AL*,9ST,9SC,9GF,9SI,9SL,9GF*,9GF,9CR,9GF*,9HU,9SI,9BL,9ST,9BL,9AL*,9GF,9HU,9SI";
	sink[i++] = "9GF,9GF*,9BL,9GF,9SL,9AL*,9ST,9HU,9BL,9AL,9SI,9BL,9SL,9SL,9MF,9AL,9GF,9GF*,9HU,9BL,9ST,9CR,9SI,9SC,9SI,9ST,9GF,9GF*,9BL,9HU,9CR";
	sink[i++] = "9SI,9HU,9BL,9AL*,9GF*,9AL,9BL,9SI,9SC,9ST,9BL,9GF,9AL*,9HU,9CR,9AL,9SI,9MF,9ST,9GF,9BL,9CR,9AL*,9GF*,9HU,9GF*,9SC,9SI,9BL,9CR,9AL,9HU,9GF,9CR,9SI";
	sink[i++] = "9HU,9AL*,9CR,9BL,9AL*,9GF*,9AL,9MF,9SI,9SL,9BL,9CR,9AL*,9HU,9GF*,9MF,9SI,9BL,9ST,9HU,9BL,9SI,9AL,9SC,9AL*,9GF*,9SL,9HU,9SI,9GF,9ST,9MF,9BL,9HU,9SI";
	sink[i++] = "9SC,9HU,9GF*,9CR,9BL,9SI,9AL*,9MF,9GF*,9BL,9SI,9AL*,9HU,9BL,9SC,9GF,9SL,9GF*,9AL*,9CR,9AL,9FP,9AL,9ST,9GF,9AL*,9SI,9HU,9MF,9GF*,9CR,9BL,9SL,9HU,9SI,9MF,9GF,9GF*";
	sink[i++] = "9MF,9BL,9HU,9SI,9GF*,9AL*,9SC,9BL,9SL,9SI,9CR,9BL,9MF,9GF*,9HU,9AL,9SI,9ST,9FP,9AL,9GF,9HU,9CR,9ST,9SC,9BL,9HU,9SI,9GF*,9AL*,9MF,9BL,9SI,9HU,9SI,9BL,9MF,10HU";
	sink[i++] = "9MF,9AL*,9GF*,9HU,9SI,9SC,9AL,9SI,9BL,9HU,9MF,9CR,9HU,9BL,9SI,9SC,9SL,9ST,9SI,9BL,9FP,9ST,9GF*,9SL,9AL,9SC,9HU,9GF,9BL,9SI,9MF,9GF*,9AL*,9HU,9BL,9SC,9SC,10AL";
	sink[i++] = "9MF,9AL,9HU,9BL,9SI,9SC,9GF,9HU,9SI,9BL,9SC,9SL,9SI,9BL,9HU,9FP,9GF*,9SI,9AL*,9SL,9MF,9AL,9CR,9BL,9SI,9SC,9ST,9HU,9SI,9BL,9FP,9GF*,9HU,9SL,9SI,9SC,9AL*,9BL,9HU,9SI,9SC,9MF,9AL,9SL";
	sink[i++] = "9SC,9MF,9ST,9BL,9AL*,9HU,9SC,9AL*,9HU,9BL,9SI,9MF,9AL*,9BL,9AL,9SI,9SC,9HU,9GF*,9CR,9CR,9FP,9BL,9AL*,9ST,9BL,9MF,9SL,9AL,9HU,9BL,9SC,9SC,9SI,9GF*,9AL*,9CR,9MF,9ST,9BL,9HU,9SI,9FP,9GF*,9AL*,9BL";
	sink[i++] = "9MF,9MF,9AL,9AL*,9HU,9SI,9SC,9BL,9GF*,9AL*,9HU,9FP,9BL,9CR,9SI,9AL,9SC,9SC,9ST,9HU,9BL,9GF*,9MF,9ST,9SI,9GF*,9HU,9FP,9CR,9SI,9BL,9GF,9MF,9SC,9ST,9GF,9HU,9AL*,9SC,9BL,9SI,9HU,9CR,9FP,9BL,9HU";
}

function string GetDate()
{
	return "";
}

function string GetAuthor()
{
	return "Jenny XJ-9";
}
