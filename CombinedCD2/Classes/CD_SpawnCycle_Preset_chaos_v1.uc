class CD_SpawnCycle_Preset_chaos_v1
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

	sink[i++] = "4SI_5SL_1CR*,2HU_2CR*_5SL_1SI,3SL_6CR_1SI,4SL_1CR*,3HU_4SI_2SL_1CR*,8SL_2GF";
	sink[i++] = "6SL_3SI_1GF,4HU_3GF_3CR*,1MF!_1GF_4CR*_3SL_1SI,5SI_4SL_1CR*,4HU_5CR*,2SI_7SL_1CR*,4GF_3CR*_2SL";
	sink[i++] = "4SI_4HU_1GF_1CR*,6CR*_2SI_1GF_1SL,6HU_4SL,10SL,9SL_1SI,6SL_4CR*,2SI_8HU,1FP!_2MF!_4CR*_2SL";
	sink[i++] = "9SL_1CR*,8SL_2HU,9SI_1SL,6CR*_4SL,5MF!_2CR*_3SL,2FP!_4CR*_2SI_2HU,8CR*_1SI,6HU_3CR*_1SI,4MF_3CR*_1SI,4HU_2CR*_1SI_1SL_2GF";
	sink[i++] = "2FP!_4MF!_4CR*,3SL_2GF_4SI_1CR*,2CR*_4SL_4GF,5HU_3SI_2SL,1CR*_3GF_4HU_1SI_1SL,10SL,4SL_3CR*_1SI_2GF,4SI_2HU_3SL_1CR*,2SI_1GF_1SL_2HU_3MF!_1FP!,6SL_2CR*";
	sink[i++] = "9SL_1SI,4SI_2CR*_4GF,2FP!_4SL_2CR*_2SI,8HU_2GF,6CR*_1GF_3SL,5MF!_2GF*_2CR*_1SL,1FP!_5CR*_2HU_2SI,7CR*_1GF*_2MF!";
	sink[i++] = "2SI_2CR*_2GF_2HU_1MF!_1FP!,6SI_4GF*,3FP!_3SL_3CR*_1HU,8CR*_2SL,2MF!_5SL_2GF*_1SI,7HU_1GF_1GF*_1SI,2MF!_1GF_1GF*_2CR*_3SI_1HU,4SL_4CR*_1SI_1HU";
	sink[i++] = "8SI_2FP!,4MF!_1FP!_2CR*_1GF*_1GF_1SL,9SL_1GF*,8HU_2SI,5SL_5CR*,2HU_3SL_2GF_1MF!_2FP!,1GF_6HU_2FP!_1CR*,1FP!_4SL_1GF*_2CR*_2MF!,3SI_1SL_2GF_4CR*,4HU_2CR*,5SL_4SI_1MF!";
	sink[i++] = "9SI_1GF*,2FP!_5CR*_2SL_1GF,4CR*_3SL_2HU_1GF,4GF_4SL_1MF!_1GF*,7CR*_1GF_1GF*_1SL,1CR*_9HU,7MF!_2SI_1CR*,4GF_5SL_1MF!,3FP!_5SL_2MF!,6CR*_2SI_2HU";
	sink[i++] = "9SI_1CR*,3FP!_4MF!_3SL,5MF!_3CR*_2SL,10HU,6MF!_3GF*_1CR*,5MF!_5CR*,1FP!_7CR*_2SL,9SL_1SI,9CR*_1SI,4FP!_2GF*_1CR*_3SL,7SI_2SL_1CR*,9SL_1CR*,4HU_4CR*_1GF*_1SL,2HU_3GF_4SL_1MF!";
}

function string GetDate()
{
	return "";
}

function string GetAuthor()
{
	return "Alice";
}
