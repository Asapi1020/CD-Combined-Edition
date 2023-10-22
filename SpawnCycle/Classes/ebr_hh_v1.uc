// EBR HH = (E)soteric (Br)azillian (H)ard (H)olding 
class ebr_hh_v1
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
	// keep waves 1, 2, 4, 6, 7, 9, 10
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

	// Wave 1
	sink[i++] = "2SL_2ST_2CR,2CA_2CR_1GF_1SI,2CY_2CR_1GF,2CA_2SL,2CA_2CR_1GF_1SI";

	// Wave 2
	sink[i++] = "2CA_2CR_1GF_1SI,1HU_1SI,1BL_2CA_2SL,1FP,2CY_2CR_1GF,1SC,2SL_2ST_2CR_1HU,2ST_2SL_2CR,2CY_1GF_1SL,1BL";

	// Wave 3
	sink[i++] = "1SI,2SL_2ST_2CR_1HU,1FP_1SC,1BL_2CA_2SL,2CA_2CR_1GF_1SI,1SC,2SL_2ST_2CR_1HU,2CY_2CR_1GF,1CR_1CY_1ST,1BL,1GF_1ST_1CR,2SL,1FP,2CR_1CA_1CR";

	// Wave 4
	sink[i++] = "2CY_2CR_1GF,1FP,2CY_2CR_1GF,1SC,2SL_2ST_2CR_1HU,1FP_1SC,2CA_2CR_1GF_1SI,2CY_2CR_1GF,1SC,2BL_2CA_2SL,1FP_1SI_1HU,1ST_1SI,1HU,1SC,1CR_1SL_1FP,2GF_1ST";

	// Wave 5
	sink[i++] = "1FP_1SC_1HU,1BL_2CA_2SL,2CY_2CR_1GF,2SL_2ST_2CR_1HU,1FP,2CA_2CR_1GF_1SI,1SC,1BL_2CA_2SL,1SI_1FP_1SC,1CR_2CA";

	// Wave 6
	sink[i++] = "2SC_2HU_1BL,1BL_2CA_2SL,2FP_1SI,1BL_2CA_2SL,2CA_2CR_1GF_1SI,2CY_2CR_1GF,2SL_2ST_2CR_1HU,2SC_1FP,2CY_2CR_1GF,1SI,1FP,2SL_1CA";

	// Wave 7
       sink[i++] = "2CR_2ST_1SL,1SC_1HU,2FP_1SI,2CY_2CR_1GF,2SC,2BL_2CA_2SL,1FP_1SC,2SL_2ST_2CR_1HU,2CY_2CR_1GF,1HU,1BL_2CA_2SL,2CA_2CR_1GF_2SI,2FP_1SC,1SI_1CR";

	// Wave 8
	sink[i++] = "2FP_1BL,2CA_2CR_1GF_1SI,2SC_1HU,2CA_2CR_1GF_1SI,2SL_2ST_2CR_1HU,1FP,2CY_2CR_1GF,1SC_1HU,2CA_2SL,2CA_2CR_1GF_1SI,2BL_2CA_2SL,2FP_2SC,2SL_1GF";

	// Wave 9
	sink[i++] = "2FP_1SC_1HU,1BL_2CA_2SL,1SC_1FP,1BL_2CA_2SL,2SL_2ST_2CR_1HU,1SC,1BL_2CA_2SL,2CA_2CR_1GF_2SI,1SC_1FP,2CY_2CR_1GF,1FP_1SC,2CY_2CR_1GF,1SI_1HU";

	// Wave 10
        sink[i++] = "3FP_2SC_2HU,1BL_2CA_2SL,2CA_2CR_1GF_2SI,2SL_2ST_2CR_1HU,1FP,1BL_2CA_2SL,2SC,2CY_2CR_1GF,1SC,1FP,2CA_2CR_1SI,2SL_2ST_2CR_2HU,1FP,1BL_2CA_2SL,2SI_2SC,1CR_2CA,1BL,1CR_1ST_1CY,2FP_2CY_1SL,1SC,1GF_2ST_1SL";
}

function string GetDate()
{
	return "2023-04-07";
}

function string GetAuthor()
{
	return "Jary";
}