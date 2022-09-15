class CD_SpawnCycle_Preset_owo_v1
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

	sink[i++] = "1CY,3ST_2CR*,3CR,1SI,4ST,3CR,4SI,8ST,2SI,7CR_1CR*,5ST,3SI,2ST_4CR,1CR_1CR*";
	sink[i++] = "1CY,8CR_2GF,9ST_1CR*,2CR_1SI_1GF,9CR_1SI,1ST_4CR*,10ST,10CR,10ST,5SI,8ST,2CR*,6CR,2SC";
	sink[i++] = "1CY,4ST_3SI_3GF,1SC,5ST_2CR_2CR*_1GF,4CR_5ST_1GF,3ST_6CR_1SI,1GF_2CR_1CR*_4ST_2SI,10ST,8SI_2GF,4GF_5CR_1ST";
	sink[i++] = "1CY,1SC,4GF_5ST_1CR,7ST_1CR_1CR*_1GF,5GF_4ST_1CR,4SI_3GF_1ST_1CR*_1CR,8ST_2GF,2CR_1CR*_3ST_2GF_2SI,2FP!_4ST_3CR_1CR*,10SI,10ST,3GF";
	sink[i++] = "4CY_2SC,9ST_1SI,2GF_3ST_2CR_1CR*_2SC,4GF_5ST_1CR,2FP!_2SC_2GF_4ST,10SI,2ST_1GF_1CR*_1CR_3SC";
	sink[i++] = "6CY_1SC_2FP!,5CR_2CR*_1GF_2SI,4CR_3GF_2SC_1CY,9SI_1GF,3SI_1SC_5CY_1GF,2FP!,5SI_3CR_2CR*,9ST_1CR";
	sink[i++] = "3CY_5SC_1CR_1SI,5GF_5ST,3SI_6CR*_1GF,10SI,2FP!_3SC_1CY_4GF,6ST_2SI_2CR*,9ST_1GF,1SI_3ST_1GF_4CR_1SC,10ST";
	sink[i++] = "1CY_5SC_3CR_1ST,10SI,6ST_1GF_2FP!_1SC,4GF_4ST_1CR_1CR*,2FP!_2SC_1CY_3CR_2ST,9CR_1ST,2SI_6ST_2CR*,3SC_2GF_4ST";
	sink[i++] = "2CY_2SC_3CR_3ST,10SI,2FP!_3GF_3ST_1CR*_1SC,6ST_3SI_1CR,9ST_1SI,1SC,10SI,1FP!_5CY_3CR_1ST,3SC_2CR_5CR*";
	sink[i++] = "3CY_2FP!_4SC_1SI,1SC_6SI_3ST,8ST_1GF_1CR*,1FP!_5CR_3ST_1SI,3CY_6CR_1ST,3SC_6ST_1GF,2SC_1FP!_4CR_1CR*_2ST,7ST_1SI_2CR,4SC_5CY_1CR,9ST_1GF,2GF_2CR_2CR*_2ST_2SI,10SI,3FP!_3CY,1CY_8GF_1ST,4ST_1SI_5CR*";
}

function string GetDate()
{
	return "";
}

function string GetAuthor()
{
	return "Alice";
}
