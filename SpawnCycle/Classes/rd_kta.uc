class rd_kta
	extends CD_SpawnCycle_PresetBase
	implements (CD_SpawnCycle_Preset);

function GetLongSpawnCycleDefs( out array<string> sink )
{
	local int i;

	i = 0;

	sink.length = 0;
	sink.length = 10;

	// Wave 01
	sink[i++] = "1SI_3CY,1CR_2CY_1SL_1GF*,3SL_1AL_1HU_1CY,3CY_1BL,3ST,2CY_2SL,2CY_2GF,5CY,1SC_1HU_1SL_1GF,5CR,5CR*,6SL,4CY_1BL,2AL_1ST_1SL,3GF_1GF*,2SL_3CY_1GF,5CY,2SL_2HU,4CY,3CY_1AL*_1GF,5CY,3SL_1AL,7CY_1MI_1GF*,6SL,1CY_1CR_3CY_1BL,4SL,4CY,1SL_3CY_1AL_1GF,6CY_1AL*,4SL,4CY,1CR_2CY_1SL_1GF,4CY,1CR_2CY_2SI,6SL,4CY_1BL,2ST_1AL,4CY,3CY_1SL_1GF,5CY,2SL_1GF,3CY_6CR,3CY_1CR*_1GF,6ST,5CY_5AL,2GF,1FP";

	// Wave 02
	sink[i++] = "1FP_1MI_1ST,1CR_1SL_1BL_1SI,8CY_1AL*,3CY_2SL,10CR,1BL_2GF,3AL_1GF,2HU_2AL,1SC_5GF_1GF*,5CY,4CR_1CR*,3CY_1AL,3CY_1SL_1BL,2CR,2ST,1SL_2AL_1GF,2AL_2GF_1AL_1MI,3CY_2GF,4CY,2CR*,3CY_1AL,3CY_1SL_1BL,5ST,1SC,10CR,4CY_1BL_2GF,5CY_5SL,1SL_1AL_1GF,2SI_1AL_1SL_3CY,2HU_2CR*,3CY_1SL_1BL,3ST_3SL_3CY,3GF_1SC,9CY_1AL*,1BL_2GF,1BL_1HU_1SI_5CY_2SL,1GF*_2GF,1MI_1AL*_8CY,10CR";

	// Wave 03
	sink[i++] = "1BL_1CR,3AL_1BL_1AL*,2SL_3CR_1GF*,1SC_6ST_2FP_1BL,3CY_1GF_1SI,1SL_3GF,1HU,3CY_1AL,2CR_2GF_2ST_1SI,5CR_1BL,4ST,4GF_1BL,3CR_1CR*,4CY_1SI,4AL_2BL,2SL_3CR_1GF_1CR,3CY_1GF,1SL_3GF_1SC,1HU_4CY_4AL_1AL*,2CR_2GF_2ST_1BL,6BL,4ST,4GF,4CR,5CY_5SL,5ST_5GF,1HU_1SL_1GF_6CY,2GF_2ST_1SI,2SC_1FP_1MI,4ST,4GF_1BL,1AL*_1CR*,4CR,4CY_1SI,1AL_2AL_2BL,2SL_1CR*_2CR_1GF*,3CY_1GF_1SI,1SL_3GF,1HU,3CY_1AL,2CR,1CR*_2GF,4ST,4GF,5CY_5SL,3HU_3SL_3CY_1BL,3CR_3ST_3CY_1CR*,1HU_1SI_6CY_2MI,3BL_3SL_1AL*_2CY";

	// Wave 04
	sink[i++] = "1SC,3SI_3HU_1AL*_2GF_1CR*,3ST_1BL_1HU_5CY,2CY_1AL*_2GF_1AL_3CY,5CY_3AL_2ST,2CR_2SL_1BL_1GF*,3SI_3HU_1FP_2SC,5GF_5CY,2ST,1SL_2GF_1AL,3CY_2CR_2ST_1SI,5CR_1CR*,4GF*,2CR_2GF_2ST,1BL_4CY_1AL,3CY_1CR_2ST_1BL_1SI,4CR,3CY_2BL,1AL_2GF_1AL,1HU,3CY_1GF_1SI,2ST,1SL_3GF,3CY_1CR_2ST_1BL_1SI,3SI_3HU_1SC_1FP,1AL_4CR,2CY_1SL_1HU,4GF,2CR_2GF_2ST_1SI,3CY_1AL,3CY_1CR_2ST_1BL_1SI,1HU_4CR,3CY,1AL_2GF_1AL*,3CY_1GF_1SI,9GF,2MI,3SI_3HU_1AL*_2GF_1CR*,2ST,1SL_2GF_1AL,3CY_2CR_2ST_1SI,6CR,4GF,2CR_2GF_2ST,4CY_1CR_2ST_1BL_1SI,3CR_1AL,3CY_2BL,2AL_2GF,1HU,3CY_1GF_1SI,2ST,1SL_2GF_1AL,3CY_1CR_2ST_1BL_1SI,3SI_3HU_1AL*_2GF_1CR*";

	// Wave 05
	sink[i++] = "3CR_2GF_2ST_1SI,4CR_1AL,2CY_1CR_2ST_1BL_1SI,1AL_1SC_1FP,1AL*_2ST,1CY_1BL,4GF,5CR_1CR*,4ST,1AL_2GF,2AL_1GF_1HU,1AL_1SL_3GF,2CY_1GF_1SI,3AL_1SL,2CR,4ST,1AL_2CR_2GF_2ST_1SI,4CR,2CY_1CR_2ST_1BL_1SI,1AL_1SC_1FP,2ST,2CY_1BL_1AL,4GF*,2AL_1GF_1HU,5CR_1CR*,1AL_2GF_1AL,1SL_3GF,3CY_1GF_1SI,2AL_1SL_1AL,2CR,2CR_2GF_2ST_1SI,4CR,2CY_1CR_2ST_1BL_1SI,1AL_1SC_6ST,2ST,2CY_1BL,4GF,6CR,4ST,2AL_2GF,2AL*_1GF_1HU_1AL,2SC_2FP,1SL_3GF,2CY_1GF_1SI,3AL_1SL,1AL_2CR,4ST,2CR_2GF_2ST_1SI,4CR,2CY_1CR_2ST_1BL_1SI,1AL_2ST,3CY_1BL,4GF,2AL_1GF_1HU,6CR,1AL_2GF_1AL,1SL_3GF,4CY_1GF*_1SI,2FP_2MFP_5CY,2SC_4CY_4SL,5AL_5ST,9CR_1CR*,3BL_3GF_3CR_1HU";

	// Wave 06
	sink[i++] = "1SC_2GF_1AL*_3CY,1SC_2AL_1GF*_1HU,4CR,3AL_1SC,2SL_2CR_2GF_2SI,1SC_1SL_1BL,5CR_3ST,1SC_1MI_3CY_1GF,2AL_1SL_1GF,5CY_2SI_3SL,4GF,5CR,2CR_2GF_2ST_1SI,1AL_1SC_1SL_3GF*,2SL_3CR_1GF,3AL_3GF,3SL_3CR,3SL_3CR,2AL_3GF,3SL_3CR_1AL,1SC_2FP_2MI,3CY_1CR_2ST_1BL_1SI,1GF_4ST,1AL_3CY,4ST,2CY_1SC_1GF_1AL,2AL_1GF_1HU,4CR,2AL_1SL,1AL_1SC,6CY_2SI,5ST_3CR_2CY,2CR,2ST,1SL_2AL_1GF*,4GF,1AL_6CR_1CR*,2GF_2ST_1SI,1SC_2FP,4HU,3CY_1AL,3CY_1SL_1BL,2CR*,2ST,4CY_1BL_2GF,1HU,1SC_1SL_2AL_1GF,1AL_1AL*_2GF,3CY_1AL_1GF*,4CY,4CR_1SI,3CY_1AL,3CY_1SL_1BL,2CR,5ST,1SI_1HU_1BL,1SC_2AL_1GF,2AL_2GF_1AL,3CY_1AL_1GF,4CY,2CR*,1MI_1FP,3AL_4CY_1SL_1BL,1SC,2CR_2ST,4CY_1BL_2GF,1SC_1HU_2CR*,2AL_2GF*,1AL_3CY,4CY,4CR,3CY_1SC_1BL,2CR_1CR*,2ST,1HU,1SL_2AL_1GF,2GF,3CY_1AL_1GF";

	// Wave 07
	sink[i++] = "3CY,1SI_1SL_2AL_1GF,2FP_2SC_2MI,3CY,1SI_2AL_2GF,3CY,1SI_2SL_3CR_1GF,3CY,1SI_3CY_1CR_2ST_1BL,3CY,1SI_2AL_1GF,2HU_2BL_1SI_4CY,5ST_1SI_3CY,4GF_1SI,1HU_2CR_2ST_1AL*_1SI,1AL_2SL_2CR_2GF_1SI,5CY,1AL_5CR,2SL_3GF_1SC,1HU_3CR_1CR*,1AL_2CY_1BL,1SI,4CY_1HU_1AL_2SL,1SL_1AL_1GF*,1SI,3AL_5GF*,2SL_3CR_1GF*,1AL*_2CY_1CR_2ST_1SI,2SL_2GF*_1SC_1AL,5CY,2CY_1AL_1GF,4ST_4GF,2CR_2ST_1BL_1MI_1SI_1AL,2CY_1AL,2SL_2CR_2GF,1AL_5CR,4CR,2CY_1BL,4CY,3FP_2MFP_1SC_2AL,7SI,5ST_5CY,1BL_1HU_1GF_1AL*,1SI_3CY,1CR_1SL_1GF*,3SL_1AL_1HU,4CY_1BL,3ST,3CY_2SL_2GF,1AL*_3AL_1SC_1HU_1SL_1GF,5CR,5CR*,6SL,4CY_1BL,2AL_1ST_1SL,3GF_1GF*,2SL_3CY_1GF,5CY,2SL_2HU,4CY,3CY_1AL*_1GF,5CY,3SL_1AL,7CY_1MI_1GF*,6SL,1CY_1CR_3CY_1BL,4SL,4CY,1SL_3CY_1AL_1GF,6CY_1AL*,4SL,4CY,1CR_2CY_1SL_1GF,4CY,1CR_2CY_2SI,6SL,4CY_1BL,2ST_1AL,4CY,3CY_1SL_1GF,5CY,2SL_1GF,3CY_1FP_1MI_1SC_3CR,3CY_1CR*_1GF,6ST_2GF,5CY_5AL";

	// Wave 08
	sink[i++] = "4CY_2HU_1BL,2SL_3GF*_1AL*,1BL_1CR*_1CR,4SC_1AL_1GF_2HU,1AL_2ST,1SL_2AL_1GF,2HU,2SL_1CR_2GF,1CR*_2SI_1AL,2HU,2AL_1SL,1CR*_2CR,2AL_2GF,2BL_2HU_1CR*_1AL_3MI_1FP,2SL_2CR_1GF,1CY_1CR_2ST_1BL_1SC,1CR*_4ST,1AL_4GF,1HU,2CR_2GF_2ST,1AL_1CR*,1AL_5CR,1BL_2CR,1AL_2AL_1GF_1HU,2ST_1CR*,1SL_1AL_1MI,2SL_1CR_2GF,1AL_2SI,2AL_1SL,1CR*_3CR_2HU_2AL_2GF,1AL_2SL_2CR_1GF,2HU,1CR*_2SL_3GF,2CY_1CR_2ST_1BL_1SI_1AL,5CY_2SL_3CR,3BL_4ST_2HU,1CR_2CY,1AL_4GF,2CR_2GF_2ST_1SI,5CR,1MI_1AL,2SL_3GF_1SC_1AL,1CR*_2CY_1BL,2CR,1AL_1GF_2HU,1AL*_2ST,1SL_2AL_1GF*,2SL_2CR_2GF,1CR*_2SI_1AL,2AL_1SL,3CR,2AL_2GF_2HU,3BL_1AL_3FP_2SC_1CR*,2SL_2CR_1GF,2CY_2ST_1BL_1SI,4ST,1AL_2CY,4GF,1CR*_2HU,2CR_2GF_2ST_1SI,2AL_7CY_1BL,1CR*_3CR,3AL_1GF_2HU,2ST,1SL_1AL_1GF,2SL_2CR_2GF,1CY_2SI,2AL_1SL,1CR*_3CR_1SC_1AL_1AL*_2GF,1AL_2SL_2CR_1GF,2HU,2SL_3GF,2CY_1CR_2ST_1BL_1SI_1AL,1CR*_2AL,1BL_4ST,3CY,1AL_1GF_1SC_1FP_1MI,2CR_2GF_2ST_1SI,4CR_1CR*,2AL_1BL_1HU_3SL";

	// Wave 09
	sink[i++] = "4ST_4GF*_1AL*,5CY_5CR,4ST,2AL_2CY_1BL_2CR,3AL_1SL,2CR*_5CR,3FP_1MI_2SC,2CR_2GF_2SI_4ST,3GF_1AL*_1SC_1AL_1CR*,4ST_4GF*_1AL*,2ST_1SL_2AL_1GF,3CR_2AL_2GF_1HU,2SL_2CR_1GF_1CR*,2CY_1CR_2ST,1AL_2BL_1SI,2CR_2GF_2ST_1SI,1CR*_1AL_1CY,4ST_4GF*_1AL*,2SL_3GF_2CY_1SC_1MI,4ST,2CY_1BL,2CR,1CR*_1AL_1HU,3CY_2GF,3AL_1SL,4CR,2SL_2CR_2GF_2SI,1CR*_1AL_4GF*,2ST,1SL_2AL_1GF_1HU,3CR_1CR*,2SL_3CR_1GF_1AL,5ST,1AL_2GF,2AL_1CR*_2FP_2SC,1CY_1CR_2ST_1BL_1SI,2SL_3GF_1SC_1AL,1CR*_2CY,2CR_2GF_2ST_1SI,1CR*_1HU_1AL,5ST,1CY_1CR_2ST,1BL_1SI,2CY,3GF_1SL,1AL_1HU_4ST,1CR*_2AL_1SC,4CY_1BL,2CR,3AL_1SL,5CR_1CR*,1AL_2CR_2GF_2SI,4GF*_2FP_1MI_1SC_1AL_1CR*,2ST,1SL_1AL_1GF,3CR,2AL_2GF,2SL_3CR_1GF*,1CR*_1AL*_1CY_1CR_2ST,2BL_1SI,2CR_2GF_2ST_1SI,1AL_2CY,2SL_3GF_1SC_1CR*,4ST,1AL_2SC_1AL_3MI,5ST,3CY_1BL,2CR,1AL_1HU,1CY_2GF,3AL_1SL,1CR*_6CR,2SL_2CR_2GF_2SI,1AL_4GF*,2ST,1SL_2AL*_1GF,1CR*_3CR,2SL_3CR_1GF,2AL_2GF,1CR*_2CY_1CR_2ST_1BL_1SI,2SL_3GF_1SC_1AL,5ST,1CY,2CR_2GF*_2ST_1SI,1CR*_1AL_1HU,3CY_1CR_2ST,1FP_1SI,4CY,3GF_1SL,1CR*_1HU_4ST,2AL_1SC_2CY_2BL";

	// Wave 10
	sink[i++] = "3FP_3MFP_2SC,5CY_5SL,5ST,3SL,1SL_1AL*_1GF_1AL,8GF_2GF*,1CR*_3CY_1SL,3AL_2SL_3CR_1GF,1MI_2SL_1CR_2GF_1SI,1CR*_2AL_1SL,4AL_2GF,1HU_2CY_1CR*_1AL*,1MI_4ST_2SL_3GF,3CR_1AL_1HU,2CR_2ST,1BL_2SI,1CR*_2CY_1AL_1MI_1GF_1AL,2CY_1CR_2ST_1BL_1SI,1HU_1SC_2GF,1CR*_1SL_2AL_1GF,4CR,1AL_2CY_2BL,2AL,1HU_2CY,2AL_2GF,2SL_2CR_1GF,1CR*_1AL_2SL_2CR_2GF,2SI,1HU,2SL_3GF_1SC_1AL,3AL_1SL,2CY_1AL*,1CR*_4ST,1CR_2ST_1BL_1SI,1AL_5CR,2CY_1AL_1GF,3CY_1CR_2ST_1BL,1CR*_1HU,1AL_3GF,1SL_2AL_1GF,3CR,2CY_1SL,2AL_2CY,2AL_2GF,1CR*_1AL_3CY,2FP_1MI_2SC,1CR*_2SL_2CR_1GF,1HU_2SL_2CR_2GF*_1SI,3AL_1SL,4ST,2SL_3GF_1SC,1CR*_4CR,1AL*_1HU,2CR_2ST,1BL_2SI,2CY_1AL_1GF_1AL*,2CY_1CR_2ST_1BL_1SI,1CR*_4GF,1SL_2AL_1GF,1CR*_3CR,1AL_2CY_2BL,2AL_1SC,1AL_1HU_2CY,2AL_2GF,2SL_2CR_1GF,1CR*_1AL_2SL_2CR_2GF,2SI_2SL_3GF,1HU_3AL_1SL,1AL_2CY_1AL*,4ST,1CR_2ST_1BL_1SI,1CR*_1AL_5CR,2CY_1AL_1GF,3CY_1CR_2ST_1BL,4GF_1AL,1SL_2AL_1GF,1CR*_3CR,1SL,2AL_2CY,2AL_2GF,2CY_2AL,2SL_3CR_1GF,2SL_2CR_2GF_1SI,3FP_2SC,2MI_2SC,3CY_3SL_3AL_1AL*";
}

function string GetDate()
{
	return "2018-01-27";
}

function string GetAuthor()
{
	return "Extonix, Slayer and BardzBeast";
}
