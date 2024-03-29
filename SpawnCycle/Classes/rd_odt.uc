class rd_odt
	extends CD_SpawnCycle_PresetBase
	implements (CD_SpawnCycle_Preset);

function GetLongSpawnCycleDefs( out array<string> sink )
{
	local int i;

	i = 0;

	sink.length = 0;
	sink.length = 10;

	// Wave 01
	sink[i++] = "1SI_3CY,1CR_2CY_1SL_1GF*,3SL_1AL_1HU_1CY,3CY_1BL,3ST,2CY_2SL,2CY_2GF,5CY,1SC_1HU_1SL_1GF,5CR,5CR*,6SL,4CY_1BL,2AL_1ST_1SL,3GF_1GF*,2SL_3CY_1GF,5CY,2SL_2HU,4CY,3CY_1AL*_1GF,5CY,3SL_1AL,7CY_1MI_1GF*,6SL,1CY_1CR_3CY_1BL,4SL,4CY,1SL_3CY_1AL_1GF,6CY_1AL*,4SL,4CY,1CR_2CY_1SL_1GF,4CY,1CR_2CY_2SI,6SL,4CY_1BL,2ST_1AL,4CY,3CY_1SL_1GF,5CY,2SL_1GF,3CY_6CR,3CY_1CR*_1GF,6ST,1SC_9CY,2GF,1FP";

	// Wave 02
	sink[i++] = "1FP_1MI_1ST,1CR_1SL_1BL_1SI,8CY_1AL*,3CY_2SL,10CR,1BL_2GF,3AL_1GF,2HU_2AL,1SC_5GF_1GF*,5CY,4CR_1CR*,3CY_1AL,3CY_1SL_1BL,2CR,2ST,1SL_2AL_1GF,2AL_2GF_1AL_1MI,3CY_2GF,3CY,2CR*,3CY_2AL,3CY_1SL_1BL,5ST,1SC,10CR,4CY_1BL_2GF,5CY_5SL,1SL_1AL_1GF,2SI_1AL_1SL_3CY,2HU_2CR*,3CY_1SL_1BL,3ST_3SL_3CY,3GF_1SC,9CY_1AL*,1BL_2GF,1BL_1HU_1SI_5CY_2SL,1GF*_2GF,1MI_1AL*_7CY_1SC,1CR*_9CR";

	// Wave 03
	sink[i++] = "1BL_1CR,3AL_1BL_1AL*,2SL_3CR_1GF*,6ST_1SC_2FP_1BL,3CY_1GF*_1SI,1SL_3GF,1HU,3CY_1AL,2CR*_2GF_2ST_1SI,1MI_4CR_1BL,4ST,4GF_1BL,3CR_1CR*,4CY_1SI,4AL_2BL,2SL_3CR_1GF_1CR,3CY_1GF,1SL_3GF_1SC,1HU_9CY,2CR_2GF_2ST_1BL,6BL,1SC_3ST,1MI_3GF,4CR,5CY_5SL,5ST_5GF,1HU_1SL_1GF_6CY,2GF_2ST_1SI,2SC_1FP_1MI,4ST,4GF_1BL,1AL*_1CR*,4CR,4CY_1SI,1AL_2AL_2BL,2SL_1CR*_2CR_1GF*,3CY_1GF_1SI,1SL_3GF,1HU,3CY_1AL,2CR,1CR*_2GF,2SC_3ST,1MI_1FP_2GF,9CY,3HU_3SL_3CY_1BL,3CR_3ST_3CY_1CR*,1HU_1SI_8CY,3BL_3SL_1AL*_2CY";

	// Wave 04
	sink[i++] = "1SC,3SI_3HU_1AL*_2GF_1CR*,3ST_1BL_1HU_5CY,2CY_1AL*_2GF_1AL_3CY,3FP_7CY,2CR_2SL_1BL_1GF*,3SI_3HU_2SC,5GF_5CY,3ST,1SL_2GF_1AL,3CY_2CR_2ST_1SI,6CR,4GF*,2CR_2GF_2ST,1BL_3CY_1MI_1AL*,3CY_1CR*_2ST_1BL_1SI,4CR,3CY_2BL,1AL_2GF_1AL,1HU,3CY_1GF_1SI,2ST,1SL_3GF,3CY_1CR_2ST_1BL_1SI,3SI_3HU_1SC_1MI,1AL_4CR,2CY_1SL_1HU,4GF,2CR_2GF_2ST_1SI,3CY_1AL,3CY_1CR_2ST_1BL_1SI,1HU_4CR,3CY,1AL_2GF_1AL*,3CY_1GF_1SI,7GF_2FP,2MI,1SC_3SI_3HU_1AL*_1GF_1CR*,2ST,1SL_2GF_1AL,3CY_2CR*_2ST_1SI,1SC_5CR,4GF,2CR_2GF_2ST,4CY_1CR_2ST_1BL_1SI,3CR_1AL,3CY_2BL,2AL_2GF,1HU,3CY_1GF*_1SI,2ST,1SL_2GF_1AL,3CY_1CR_2ST_1BL_1SI,3SI_3HU_1AL*_2GF_1CR*";

	// Wave 05
	sink[i++] = "2CR,2CR*_2GF_2ST_1SI,4CR_1AL,2CY_1CR_2ST_1BL_1SI,2SC_2FP,1AL*_1ST,1CY_1BL,4GF,5CR_1CR*,4ST,1AL_2GF,2AL_1GF_1HU,1AL*_1SL_3GF,2CY_1GF*_1SI,3AL_1SL,2CR,3ST_1MI,1AL*_2CR_2GF_2ST_1SI,4CR,2CY_1CR*_2ST_1BL_1SI,1AL_1SC,2ST,2CY_1BL_1AL,4GF*,2AL_1GF_1HU,5CR_1CR*,1AL_2GF_1AL*,1SL_3GF,3CY_1GF_1SI,2AL_1SL_1AL*,2CR,1MI_1SC_1CR_2GF_1ST_1SI,4CR,2CY_1CR*_2ST_1BL_1SI,1AL*_1SC_6ST,2ST,2CY_1BL,4GF,5CR_1CR*,4ST,2AL_2GF,2AL*_1GF_1HU_1AL,2SC_2FP,1SL_3GF*,2CY_1GF_1SI,3AL_1SL,1AL_2CR,4ST,2CR_2GF_2ST_1SI,4CR,2CY_1CR_2ST_1BL_1SI,1AL*_2ST,3CY_1BL,4GF,2AL_1GF*_1HU,6CR,1AL_2GF_1AL,1SL_3GF,3CY_1GF_1SI,2FP_2MFP_6CY,3SC_7CY,5SL_5ST,3GF*_4CR_3CR*,3BL_3GF_3CR_1HU";

	// Wave 06
	sink[i++] = "2SC_1GF_1AL*_2CY,1SC_2FP_2AL_1GF*_1HU,3CR,3AL_1SC,2SL_2CR_2GF_2SI,1SC_1SL_1BL,1CR*_4CR_3ST,1SC_2MI_2CY_1GF,2AL_1SL_1GF*,5CY_2SI_3SL,4GF,4CR_1CR*,2CY_2GF_2ST_1SI,1AL*_1SC_1SL_3GF*,2SL_3CR_1GF,3AL_3GF,3SL_3CR,3SL_3CR,2AL_3GF,3SL_3CR_1AL*,3SC_2FP_2MI,2CY_1CR*_2ST_1BL_1SI,1GF*_4ST,1AL_3CY,4ST,2CY_1SC_1GF_1AL*,2AL_1GF_1HU,4CR,2AL_1SL,1AL_1SC,8CY_2SI,5ST_3CR*_2CY,2CR,2ST,1SL_2AL_1GF*,4GF,1AL_5CR,2CR_2GF_2ST_1SI,1SC_1MI,3HU,3CY_1AL*,3CY_1SL_1BL,2CR*,2ST,4CY_1BL_2GF*,1HU,1SC_1SL_2AL_1GF,2AL_2GF,3CY_1AL*_1GF*,4CY,4CR_1SI,3CY_1AL,3CY_1SL_1BL,2CR*,4ST,1SI_1HU_1BL,1SC_3AL_1GF,2AL_2GF_1AL*,3CY_1AL_1GF,4CY,2CR*,2FP_3SC_2MI_1AL*,3CY_1SL_1BL,3CR,2ST,4CY_1BL_2GF*,1SC_1HU_1CR*,2AL_2GF*,1AL_3CY,3CY,4CR,2CY_1MI_1SC_1BL,2CR_1CR*,2ST,1HU,1SL_2AL_1GF,2GF*,3CY_1AL_1GF";
	
	// Wave 07
	sink[i++] = "3CY,1SI_1SL_2AL_1GF,2FP_3SC_2MI,2CY,1SI_2AL*_2GF,3CY,1SI_2SL_3CR_1GF*,3CY,1SI_3CY_1CR*_2ST_1BL,3CY,1SI_2AL_1GF,2HU_2BL_1SI_4CY,5ST_1SI_3CY,4GF*_1SI,1HU_2CR_2ST_1AL_1SI,1AL*_2SL_2CR_2GF_1SI,5CY,1AL_5CR,2SL_2GF_2SC_1MI,1HU_4CR*,1AL*_3CY_1BL,1SI,4CY_1HU_1AL_2SL,1SL_1AL_1GF*,1SI,3AL_4GF*,2SL_3CR_1GF*,1AL*_2CY_1CR_2ST_1SI,2SL_2GF*_1SC_1AL*,4CY,2GF_1AL_1CR,4ST_4GF,2CR_2ST_1BL_1MI_1SI_1AL*,2CY_1AL,2SL_2CR*_2GF*,1AL_5CR,4CR*,2CY_1BL,5CY,3FP_2MI_3SC,1SC_3SI_2CY,5ST_5CY,1BL_1HU_1GF_1AL*,1SI_2CY,1CR_1CY_1SL_1GF*,3SL_1AL_1HU_1CY,3CY_1BL,3ST,2CY_2SL,1CY_2GF,4CY,1SC_1HU_1SL_1GF*,5CR,5CR*,6SL,4CY_1BL,2AL_1ST_1SL,3GF_1GF*,2SL_3CY_1GF,1MI_1SC_3CY,2SL_2HU,4CY,3CY_1AL*_1GF,5CY,3SL_1AL*,7CY_1MI_1GF*,6SL,1CY_1CR*_3CY_1BL,4SL_4CY,1SL_3CY_1AL_1GF,6CY_1AL*,4SL_4CY,1CR*_2CY_1SL_1GF,4CY,1CR_2CY_2SI,4SL,4CY_1BL,2ST_1AL*,3FP_3SC_2MI,3SL_1GF*,4CY,2SL_1GF*,3CY_5CR_1CR*,3CY_1CR*_1GF,6ST,3CY_3SL_4AL,3GF";

	// Wave 08
	sink[i++] = "3CY_2HU_1BL,2SL_2GF*_1AL*,1BL_1CR*_1CR,3SC_3FP,2MI_1AL_1GF_2HU,1AL*,1SL_2AL_1GF,2HU,2SL_1CR_2GF*,1CR*_2SI_1AL,2HU,2AL_1SL,1CR*_2CR,2AL_2GF,1BL_2HU_1CR*_1AL_1SC,2SL_2CR_1GF*,3CY_1CR_2ST_1BL_1SC,1CR*_4ST,1AL*_4GF,1HU,2CR_3GF_1ST,2AL_1CR*,1AL*_5CR,1FP_2SC_1MI,1BL_3SL,1AL_2AL_1GF*_1HU,2ST_1CR*,1SL_1AL*,2SL_1CR_3GF,1AL_2SI,2AL_1SL,1CR*_3CR_2HU_2AL_2GF,1AL_2SL_1SC_1MI_1GF,2HU,1CR*_2SL_3GF,2CY_1CR_2ST_1BL_1SI_1AL*,5CY_3AL_2SL,3BL_4ST_2HU,1CR_2CY,1AL_3GF,2CR_2GF*_2ST_1SI,3FP_3MI_3SC_1AL,1SL_3GF_1AL,1CR*_2CY_1BL,2CR*,1SC_1AL_1GF_1HU,1AL_2ST,1SL_2AL_1MI,2SL_2CR_2GF*,1CR*_2SI_1AL,2AL*_1SL,3CR,2AL_1GF_1GF*_2HU,2BL_2AL_1CR*,2SL_2CR_1GF,2CY_1CR*_2ST_1BL_1SI,2FP_2SC,4ST,1AL*_2CY,4GF*,1CR*_2HU,2CR_2GF_2ST_1SI,1AL,1AL*_5CY,3CY_1BL,1CR*_2CR,1AL_2AL_1MI_2HU,2ST,1SL_1AL_1GF*,2SL_2CR_2GF,1AL_2SI,2AL_1SL,1CR*_3CR*_1SC_2AL_2GF,1AL*_2SL_2CR_1GF*,2HU,2SL_3GF,2CY_1CR_2ST_1BL_1SI_1AL*,2CR_2GF_1ST_1SI,3FP_3MI_3SC_1AL,1BL_1HU_3SL,3CY,1AL_2GF_2GF*,1CR*_2AL,1BL_3ST";

	// Wave 09
	sink[i++] = "3ST_3GF*_1AL*,4FP_3MI_3SC,1SC_2CY_3CR,4ST,2AL,2CY_1BL_2CR*,2AL_1SL_1AL*,2CR*_5CR,2CR*_2GF*_2SI,5ST,3GF,1AL*_1SC,1AL_1SC_1CR*,4ST_4GF*_1AL*,2ST,1SL_2AL_1GF,3CR_1AL,1AL*_2GF_1HU,2SL_2CR_1GF*_1CR*,2CY_1CR_2ST,1AL_2BL_1SI,2CR*_2GF*_2ST_1SI,1CR*_1AL_1CY,4ST_4GF*_1AL*,2SL_3GF_1CY,2FP_1SC_1MI,4ST,2CY_1BL,2CR,1CR*_1AL*_1HU,3CY_2GF,3AL_1SL,4CR,2SL_2CR_2GF_2SI,1CR*_1AL_3GF*_1SC,2ST,1SL_2AL_1GF_1HU,3CR_1CR*,2SL_3CR_1GF*_1AL*,5ST,1AL_2GF,1AL_2SC_1AL_1CR*,1CY_1CR_2ST_1BL_1SI,2SL_3GF*_1SC_1AL*,1CR*_2CY,2CR*_2GF_2ST_1SI,1CR*_1HU_1AL,4ST_1MI,1CY_1CR*_2ST,1BL_1SI,2CY,2GF_1GF*_1SL,1AL*_1HU_4ST,1CR*_2AL_1SC,4CY_1BL,2CR,3AL_1SL,5CR_1CR*,1AL*_2CR_2GF_2SI,2GF*_2FP,3MI_2SC,2ST,1SL_1AL*_1GF*,3CR*,2AL_2GF,2SL_3CR_1GF*,1CR*_1AL_1CY_1CR_2ST,2BL_1SI,1SC_2CR_2GF_2ST_1SI,1AL*_2CY,2SL_3GF_1CR*,4ST,1AL*_2SC_1AL_3MI,3ST,3CY_1BL,2CR*,1AL_1HU,1CY_2GF*,3AL_1SL,1CR*_4CR," $ "2SL_2CR*_2GF_2SI,1AL_4GF*,2ST,1SL_2AL*_1GF,1CR*_2MI_1SC,2SL_3CR_1GF*,2AL_2GF,1CR*_2CY_1CR*_2ST_1BL_1SI,2SL_3GF_1SC_1AL*,5ST,1CY,2CR*_2GF_2ST_1SI,1CR*_1AL*_1HU,3FP_3MI_3SC,3CY_1CR_1ST_1SI,3GF*_1SL,1CR*_1HU_4ST,1AL*_1SC_1AL,2CY_2BL";

	// Wave 10
	sink[i++] = "4FP_3MFP,4SC_3CY_3SL,5ST,3SL,1SL_1AL*_2GF_1AL,5GF_2GF*_3CY,1CR*_3CY_1SL,2AL,1AL*_2SL_3CR*_1GF,3SL_1CR*_2GF*_1SI,1CR*_2AL_1SL,3AL_2GF*_1MI_1SC,1HU_2CY,1CR*_1AL*,4ST,2SL_3GF,3CR*,1AL*_1HU,2CR_2ST,1BL_2SI,1CR*_2CY_1AL*_1MI_1GF*_1AL,2CY_1CR_2ST_1BL_1SI,1HU_3GF*,1CR*_1SL_2AL_1GF*,4CR,1AL_2CY_2BL,2AL,1HU_2CY,2AL*_2GF*,2SL_2CR_1GF,1CR*_1AL_2SL_2CR*_2GF,2SI,1HU,2SL_3FP_3SC_1AL*,1AL_1SL,1CY_1AL,1CR*_4ST,1CR_2ST_1BL_1SI,1AL*_3CR*_2MI,2CY_1AL_1GF*,2CY_1CR_1ST_1BL,1CR*_1HU,1MI_1SC_1AL*_3GF*,1SL_2AL_1GF,3CR*,2CY_1SL,2AL_2CY,2AL*_2GF,1CR*_1AL_1CY,3FP_3SC_3MI_1AL*,1CR*_2CR_1GF*,1HU_2SL_2CR_1GF_1SI,1AL*_2AL_1SL,4ST,2SL_3GF*_1SC,1CR*_4CR,1AL_1HU,2CR_2ST,1BL_2SI,2CY_1AL*_1GF*_1AL,2CY_1CR*_2ST_1BL_1SI,1CR*_3GF,1SL_2AL_1GF,1CR*_3CR,1AL*_2CY_2BL,2AL_1SC,1AL*_1HU_2CY,2AL_2GF*,2SL_2CR_1GF,1CR*_1AL_2SL_2CR_2GF,2SI,2SL_3GF,2HU_3AL_1SL,1AL*_2CY_1AL*,3FP_3MI_4SC," $ "1CR*_1ST_1BL_1SI,1CR*_1AL_2MI_2SC,2CY_1AL*_1GF*,2CY_1CR*_2ST_1BL,3GF*_1AL*,2SL_2AL_1GF*,1CR*_3CR,1AL_2CY_1SL,2AL_2CY,2AL*_2GF*,2CY_2AL_1AL*,2SL_3CR_1GF*,2SL_2CR*_3GF_1SI,3FP_2SC,4MI_2SC,1CY_2SL_2AL_1AL*,3CY_3SL,3ST_2GF_1GF*_2CR_1CR*";
}

function string GetDate()
{
	return "2018-01-27";
}

function string GetAuthor()
{
	return "Extonix, Slayer and BardzBeast";
}
