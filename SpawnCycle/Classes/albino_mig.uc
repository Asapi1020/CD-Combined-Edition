class albino_mig extends CD_SpawnCycle_PresetBase
	implements (CD_SpawnCycle_Preset);

function GetLongSpawnCycleDefs( out array<string> sink ){
	local int i;

	i = 0;

	sink.length = 0;
	sink.length = 10;

	sink[i++] = "3AL_1GF*,3SL_1SI,2AL_1BL_3GF*_2SL,2CR_2CR*,3ST,3SL_1AL_1AL*_3GF*,2SL_2AL,1HU,3SL_1GF*,1BL_3CR_1CR*,2ST_1AL_1GF*_2SL,2HU,4CR,2SL_1AL_1AL*_4GF*,4ST_2SI,3AL_1GF*,1CR_4SL_1GF*_1CR*,3SL_1SI,3AL_1GF*,2AL_1BL_3GF*_2SL,2SI_1FP,2CR_2CR*,3ST,3SL_1AL_1AL*_3GF*,2SL_2AL,1HU,3SL_1GF*,1BL_2CR_2CR*,2ST_1AL_1GF*_2SL,2HU,2CR_2CR*,2SL_1AL_1AL*_4GF*,4ST_2SI,3AL_1GF*,1CR_4SL_1GF*_1CR*,3AL_1GF*,3SL_1SI,2AL_1BL_3GF*_2SL,2CR_2CR*,2HU_1SC,3ST,2SL_1AL_1AL*_3GF*,2SL_2AL,3SL_1GF*,1BL_2CR_2CR*,2ST_3AL_1GF*,2CR_2CR*,3SL_1AL*_4GF*,2ST,4SL_1AL_1GF*,1CR_4SL_1GF*_1CR*";
	sink[i++] = "3SL_1AL_4GF*,1AL_1AL*_2CR_2CR*_2SL,1BL_3ST,2SL_2AL_4GF*,3SL_2AL,1SC_1HU_1SI,2CR_2SL_1AL_1AL*_2CR*,1BL_4SL_4GF*,3ST_2CR_3CR*,1FP_2HU_1SI,4SL_1AL_1AL*_2GF*,2CR_2CR*,1BL_3ST_1CR*,2SL_2AL_4GF*,1SI_1SC";
	sink[i++] = "3SL_2CR_2CR*,1SL_1AL_1AL*_1SC_2SI_1HU_2GF*,3SL_1AL_3GF*,4ST_2CR_2CR*,3SL_1AL_2AL*,4CR_1CR*_2GF*,1BL_1FP_1SC_1HU,2SL_2AL_5GF*,2CR_2CR*_4ST,1BL_4GF*_2SL,3ST_1SL_2AL_1AL*_2GF*,4SL_2CR_2CR*,2BL_1FP_1SC_2HU_2SI,2SL_2AL_4GF*";
	sink[i++] = "3SL_2GF*,1AL_2AL*_2GF*_1SC_2SI_1HU,1BL_2CR_3CR*,2SL_1AL_3GF*_1AL*,1BL_4ST,1FP_1SC_1HU,3SL_1AL*_2CR*_2GF*,2CR_1BL_3CR*,1BL_1FP_1SC_2SI_2HU_2GF*,3ST,3SL_1AL_4GF*_1AL*,3SL_1AL_1AL*_1CR_2CR*";
	sink[i++] = "2SL_1AL_1CR_1CR*,1AL_1GF*_2SL,1AL*_4GF*_2SL,2BL_2SC_2HU,1CR_3CR*,2SL_1AL_1AL*_2GF*,2FP,4SL_1AL*_2GF*,1FP_1SC,3SI_1BL_2GF*,1CR_3CR*_3ST,1SC_2AL_2AL*_4GF*,2BL_2HU_1FP_2SI,2ST_3SL_1AL_3GF*,1SC_1CR_3CR*_2SL,1BL_2SI_3GF*,1CR_3CR*_1AL_1AL*_1SL,2FP_2HU,2AL*_3GF*,3SL_1CR_3CR*,2BL_1CR_4CR*,3ST,1AL_1SC_2SI_1AL*,3SL_1GF*,2AL*_2HU_4GF*,1CR_3CR*_1SC_3GF*,3SL_1AL_1AL*_2GF*,2BL_1SI,2FP,2AL_1GF*_1SL,1BL_2SL_1AL_1AL*_4GF*,2AL_1SC_1AL*,4ST_1CR_3CR*,1AL_1GF*_1AL*_1SL,2BL_2SL_1AL*_2GF*_2FP,4ST,2AL*_4GF*_2HU,1CR_3CR*,3AL_1CR_3CR*_1GF*,2HU_1SC,1BL_2SI_1CR_3CR*,4SL_2SC,1SL_1AL_1GF*_1AL*,1AL*_2GF*_3SL,1BL_2FP_3SI,2HU,2SL_1AL_1AL*_3GF*,1CR_3CR*,3SL_1AL*_2GF*,2FP_2AL*_4GF*,2HU,2BL_1SI,3SL_1AL_2SC,4ST,1CR_4CR*,1SL_1AL_1GF*_1AL*,1BL_1SC_2HU_2SL,3SL_1AL*_3GF*,2BL_2FP_3SI,1GF*_3SL,2SL_1AL_1AL*_1SI_1GF*,2HU_1SC,1SL_1AL_2CR_4CR*_1AL*";
	sink[i++] = "1AL_1AL*_2SL,1CR_3CR*,2SL_1AL*_4GF*,2BL_2SC_2HU,2AL*_2GF*_2SL,2FP,1SC_3SL_1AL,1CR_3CR*_2ST,3SI_1BL_2GF*,1FP_2AL*_4GF*_2SL,1CR_3CR*_3ST,2BL_2HU_1FP_2SC_2SI,3SL_1GF*,1CR_3CR*_1AL_1AL*_1SL,1FP_1SC,2HU,2SL_1AL_1GF*,2AL*_2GF*_2SL,1CR_3CR*,2AL_3CR_2GF*_1AL*,1BL_4ST,2FP_2HU_3SI,1CR_3CR*_2GF*,2AL_1SC_1AL*,1BL_2AL*_2GF*_1CR_3CR*,3SL_1GF*,2BL_2AL*_3GF*_2CR*,2HU_1FP_2SC_2SI,1AL*_1CR_1CR*_2SL,1BL_1SC_3GF*,1AL_2SL_1CR_1CR*_1GF*,2BL_1SI_2AL*_1FP_2SC,2HU,1CR_3CR*,3SL_1GF*,1AL_3AL*_5GF*,2BL_1FP_2SC_2HU,4ST,1CR_3CR*,2SI_1BL_3GF*,1FP_1HU,2SL_1AL*_1GF*,1AL_1CR_2CR*_1AL*,2BL_3ST_1SC,1HU_2AL*_4GF*,2FP_3SI,1CR_3CR*,3SL_1GF*,2BL_2SI_2AL*_3GF*,2FP_2HU_3SI,2FP_2HU_3SI,4ST,1CR_3CR*,1SL_1AL_1AL*_1GF*,2AL*_4GF*_2SI,3SL_1AL_1GF*,1BL_2SL_1CR_1GF*_3CR*,1AL_3AL*_4GF*,3SL_1FP_1SC_2HU,1CR_4CR*,3SL_1AL_1AL*_3GF*";
	sink[i++] = "2SL_1AL*_4GF*,1CR_5CR*,2BL_2SC_2HU,1AL*_2GF*_3SL,2FP_2SC,4ST,1SL_1AL_1CR_3CR*_2GF*_1AL*,2SI_1BL_1HU_2GF*_1SC,2SL_2AL*_4GF*,1CR_3CR*_1AL_2ST_1AL*,2BL_1HU_2FP_1SC,3SL_1AL_1AL*_3GF*,1CR_2CR*_1AL*_2SL,3SI_1FP,4SL_1AL_2GF*_1AL*,2SI_2SC_1HU,1AL*_1GF*_2SL,1BL_1AL_1GF*_1AL*,3SL_1GF*,1AL*_3GF*_2SL,2BL_2FP_2SC_2HU,2CR*_4ST,1CR_1SL_1AL_1GF*_1CR*,1AL*_2GF*_2SL,1CR_2ST_1CR*,1SI_2GF*,2BL_2SI_2FP_1SC_1HU,1CR_4CR*,1AL_2AL*_4GF*,3SL_1GF*,2BL_2FP_1HU,2SI_1SC,2SL_1AL_2GF*,1AL*_2GF*_1CR_3CR*_2SL,4ST,2SL_1AL_2GF*_1AL*,2AL*_2BL_1HU_1SC,1CR_4CR*,2BL_2FP_1SC_3SI,2AL_2CR_2GF*_1AL*,2SL_1AL*_3GF*,1BL_2SI_1CR_2CR*_1AL_1AL*,2HU_1SC_2FP,2AL*_3GF*_2SL,2SC_2HU,2FP_1SC_2SI_2HU,1BL_1CR_5CR*,3SL_1GF*,2AL*_3GF*_2HU,4ST_1SC,2AL_1GF*_1AL*,2FP_1AL*_3GF*,1CR_3CR*,2SL_2AL*_2GF*_2CR*,4ST,2GF*_3SL,1BL_1SC,1SL_1AL_1AL*_3GF*,1BL_1FP_1SI,1CR_4CR*";
	sink[i++] = "4GF*_1AL_1AL*_2SL,2BL_3SC_2HU,2SL_1AL_1AL*_1CR_4CR*,3FP_1SC_2HU_2SI,3SL_4GF*,2ST_1CR_3CR*,2BL_3SC_2SI,3SL_1AL*_4GF*,2AL_3GF*_1AL*_1SL,4ST_1CR_3CR*,2FP_2SI,4SL_1CR_2CR*,2BL_2HU,2AL*_3GF*,2CR*_1FP";
	sink[i++] = "4GF*_1SL_1AL_2AL*,2BL_3SC_2HU,3SL_2AL*_1CR_3CR*,3FP_2SC,2HU,2SL_1AL_3GF*_1AL*,2ST_1CR_4CR*,4SI_2BL_3SC,2SL_2AL*_4GF*,3GF*_3SL,4ST_1CR_3CR*,2FP_2SI,2SC_1AL_1CR_1AL*_2CR*,2BL_2HU_1SC,2AL*_4GF*,2CR*_1FP";
	sink[i++] = "4GF*_1AL_2AL*_1SL,2BL_3SC_2HU,3SL_1AL*_5CR*,4FP_3SC_2HU,3SL_3GF*,2ST_4CR*,4SI_2BL_3SC,2AL*_4GF*_2SL,2SL_3GF*_1AL*,4ST_3CR*,2FP_2SC_2SI,4SL_3CR*,2BL_2HU,2AL*_4GF*,2CR*_1FP";
}

function string GetDate(){
	return "2024-11-04";
}

function string GetAuthor(){
	return "Asapi1020";
}
