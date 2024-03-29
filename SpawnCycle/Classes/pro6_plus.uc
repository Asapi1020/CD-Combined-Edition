class pro6_plus
	extends CD_SpawnCycle_PresetBase
	implements (CD_SpawnCycle_Preset);

function GetLongSpawnCycleDefs( out array<string> sink )
{
	local int i;

	i = 0;

	sink.length = 0;
	sink.length = 10;

	// Wave 01
	sink[i++] = "4CY,1CR*_2CY_1AL_1GF,6SL,4CY_1BL,2AL_1SL,4CY,3CY_1AL_1GF_1GF*_1FP,4CY_1BL,3AL_1SL,3CY_1CR*,3CY_1AL_1GF,6SL,4CY_1BL,2AL_1SL,4CY_1GF*_1MFP,3CY_1AL_1GF,4CY_1BL,3AL_1SL,4CY,1CR*_2CY_1GF,4CY_1BL,3AL_1SL,4CY_1FP,3CY_1AL_1SC,6SL,1CR*_3CY_1BL,2AL_1SL,4CY,3CY_1AL_1GF,4CY_1BL,3AL_1SL_1GF*_1MFP,4CY,1CR*_2CY_1AL_1GF,4CY,1CR*_2CY_1AL_1GF,6SL,4CY_1BL,2AL_1SL,4CY_1GF*_1FP,3CY_1AL_1GF,4CY_1BL,3AL_1SL,3CY_1CR*,3CY_1AL_1GF,4CY,1CR*_2CY_1AL_1GF,6SL,4CY_1BL,2AL_1SL,4CY,3CY_1AL_1GF";
	
	// Wave 02
	sink[i++] = "3CY_1AL*,3CY_1SL_1BL,2CR*,2ST,4CY_1BL_2GF,1SL_2AL_1GF,1SC_2MFP_1HU,2AL_2GF*,3CY_1AL_1GF,4CY,4CR_1CR*,3CY_1AL*,3CY_1SL_1BL,2CR,2ST,1SC_2FP_1HU,1SL_2AL_1GF,2AL_2GF*_1AL_2MFP,3CY_1AL_1GF,4CY,2CR*,3CY_1AL,3CY_1SL_1BL,1DE_1DR_2CR,1DL_2ST,4CY_1BL_2GF,1AL*_1HU_2CR*,1SL_1AL_1GF,2AL_2GF*_2MFP,1AL*_3CY_1AL_1GF_1SC,4CY,4CR,3CY_1AL*,3CY_1SL_1BL,2CR_1CR*,2ST,1HU_1DE_1DR,1DL_1SL_2AL_1GF*,2GF,3CY_1AL_1GF,4CY,2CR*,3CY_1AL*,1BL_3CY_1SL,2CR*_2MFP,2ST,"$
	"4CY_1BL_2GF,1HU_1SL_2AL_1GF_1SC,2AL_2GF*,3CY_1AL_1GF,4CY,4CR_1CR*,3CY_1AL,3CY_1SL_1BL,2CR,2ST_2GF*_1SC_1FP_1FP!_1HU,1SL_2AL_1GF,2AL_1AL,3CY_1AL_1GF,4CY,2CR*_1DE_1DR,1DL_3CY_1AL,3CY_1SL_1BL,2CR,2ST,4CY_1BL_2GF,1AL_2CR*_2MFP_1HU,1SL_1AL_1GF_1SC,2AL_2GF*,1AL*_3CY_1AL_1GF,4CY,4CR,3CY_1AL,1BL_1GF*_1CR*_1AL_2MFP_1HU,3CY_1SL,2CR_2ST,1SL_2AL_1GF*,2GF,3CY_1AL_1GF,4CY,2CR*";
	
	// Wave 03
	sink[i++] = "4CR_1CR*,3AL_1AL*,2SL_3CR_1GF,8ST,2CY_1GF_1SI_1BL,1SL_2GF_1GF*_1SC_1FP_1HU_2MFP,2CY_1AL*,2CR*,2CR_2GF*_2ST_1SI,1HU_4ST,1BL_2GF_1GF*,1SC_1FP_2MFP,3CR_1CR*,3CY_1SI,1AL_3AL_2BL,2SL_3CR_1GF_1CR*,2CY_1GF,1SL_3GF,1MFP_1HU_1DR_1DE,1DL_2CY_1AL*,2CR*,2CR_2GF_2ST_1SI_1HU,4ST,2GF_2GF*_1SC_1MFP,3CR_1CR*,1AL_1AL_1BL,2SL_3CR_1GF,8ST,1AL*_2CY_1GF_1SI,1SL_2GF_1GF*_1SC_1MFP_1HU,2DE_1DR_2CY_1AL,1DL_2CR,2CR*_2GF_2ST_1SI,4ST_3GF_1GF*,"$
	"2BL_1AL*_1CR*_1HU,1SC_1FP_1MFP,4CR,4CY_1SI,1AL_2AL_1BL,2SL_1CR*_2CR_1GF,3CY_1GF_1SI_1HU,1SL_2GF_1GF*_1SC_1FP_1FP!_1HU_1MFP,3CY_1AL*,2CR,1CR*_2GF,4ST,2GF*_2GF,4CR_1CR*,1DE_1DR,1DL_3AL_1AL,2SL_3CR_1GF,8ST,2CY_1GF_1SI_1BL,2CY_1SL_2GF_1GF*_1AL*_1SC_1MFP_1HU,2CR*,2CR_2GF*_2ST_1SI,1HU_4ST,1BL_2GF_1GF*_1SC_1MFP,3CR_1CR*,3CY_1SI,1AL_3AL_2BL,2SL_3CR_1GF_1CR*,2CY_1GF,1SL_3GF,1HU,2CY_1AL*,2CR*,2CR_2GF_2ST_1SI_1HU";
	
	// Wave 04
	sink[i++] = "1AL*_2CY_1CR_2ST,1SI_1CR_1CR*,1SL_1AL_1GF_1AL_1GF*,1CR*_2CY_4GF,1BL_1SI,3SC_2HU,1MFP_2FP_2HU,1CR*_2GF_4GF*,2ST,1SL_2GF_1AL*,1CR_2ST_5CR_1CR*_1SI,1DE_1DR,1DL_1BL_2GF_1CR*_2GF*,1FP_3MFP,2CR_2GF_2ST,2CY_1AL_1SL,1CR_2ST_1SI,3CR_2CY_1CR*,1DE_1DR,1DL_1AL_1GF_1GF*_1AL*,1GF_1CR_1SI,1BL_2CR_1CR*_1AL_1SC_1SI,2MFP_1HU,2ST_1SL_2GF_1GF*,2CY_1CR_2ST,1CR_1SL_3GF_1GF*,1CR_2GF_2ST_1SI,1CR*_2CY_1AL,1CR_2ST,1BL_1SC_1SI,1MFP_1MFP_1HU,1CR*_1SL_3CR,"$
	"2CY,1GF*_1AL_1GF_1AL,1CY_1GF,1CR*_4GF_5GF*,1BL_1SI,2ST,1SL_2GF_1AL*,2CY_2CR_2ST_1SI,1CR*_3CR_4GF,1GF*_2CR_1GF_2ST_1SL,1CR*_1BL_3SC,1DE_1DR,1DL_1AL_2FP_1FP!_1HU,2CY_1CR_2ST_1SI,2CR_1AL,2CY,2AL_2GF,2CY_1GF_1SI,1CR*_2ST_1SL_2GF,2CY_1CR_2ST_1SI,6CR,2CY_1SL_3GF*_1AL_1SC_1MFP_1HU,1AL*_2CY_1CR*_2ST,1SI_1HU_4CR,1DR_1DE,1DL_1SL_1AL_1GF_1AL_1GF*,2CY_1GF,1BL_1SC_1SI_2MFP_1HU,5GF_4GF*,1CR*_2ST,1SL_2GF_1AL*,1CR_2ST,1AL_2CY_1CR_2ST,1SI_4CR,1SL_1AL_1GF_1AL*_1GF*,2CY_1GF,1BL_1SI_2HU";
	
	// Wave 05
	sink[i++] = "1GF*_2CR,2CR_1GF_2ST_1SI,1CR*_3CR_1AL*,2CY_1CR_1SI,2MFP!,1AL*_2ST,1CY_2GF*_2GF,1CR*_4CR,1AL_2GF,1BL_1AL_1DE_2SC,2FP_1DE,1DL_1HU_1MFP,2AL_1GF*_1HU,1AL*_1SL_2GF_1GF*,2CY_1GF_1SI,3AL_1SL,1CR*_1CR,4ST_1MFP,1AL*_2CR_1GF_1GF*,1SI_4CR,2CY_1CR_2ST_1SI,1CR*_1AL,2CY_1AL,3GF_1GF*_1MFP_1DR,2AL_1GF_1DL,1CR*_4CR,1AL_2GF,1SL_1GF_1SC,1BL_1DE_2GF*_2SC_1AL*,1FP!_1HU_1MFP,1DL_3CY_1GF_1SI,1CR*_2AL_1SL_1AL,3CR_1GF_1GF*_2ST,1SI_3CR,1CR*_2CY_1CR_1SI_1MFP,1AL*_6ST,2CY,2GF_2GF*,1CR*_4CR,4ST,2AL_2GF,2AL_1GF,"$
	"1SL_1GF_2GF*,1CR*_1BL_1AL_1SC,1FP_1HU_1MFP_1DR,2CY_1GF_1SI,3AL_1SL,1AL*_2CR,2CR_2GF_2ST,1CR*_1SI_3CR,1BL_2GF*_1SC_1AL*_1DE,1FP!_1HU_1MFP,2CY_1CR_1BL_1SI,2ST_3CY_2GF,2AL_1GF_1HU,1CR*_5CR,1AL_2GF_1AL,1SL_2GF_1GF*_1MFP,3CY_1GF_1SI,1GF*_2CR,2CR_1GF_2ST_1SI,1DE,1DL_1CR*_3CR_1AL*,1BL_1AL*_3SC,1FP_2HU,2CY_1CR_1MFP_1SI,1AL_2ST,1CY_1BL,2GF*_2GF,1CR*_5CR,1AL_2GF,2AL_1GF*,1AL*_1SL_2GF_1GF*_1MFP,2CY_1GF_1SI,3AL_1SL,1GF*_2CR,2CR_1GF_2ST_1SI,1DE_1DR,1DL_1CR*_3CR_1AL*,2CY_1CR*_1SI,2BL_1AL_2SC_1FP!_1MFP_2HU,1AL*_2ST,1CY_2GF*_2GF,6CR,1AL_2GF,2AL_1GF*";
	
	// Wave 06
	sink[i++] = "1AL*_1AL_1GF_1HU,2CR*_2CR,3AL_1SL,2SL_2CR_1GF_2SI,1CR*,2BL_1AL_1GF*_2SC_1DE,2HU_1FP!_1MFP,1FP_1MFP,1DL_2ST,2CY_1SL_1AL_1GF,2GF_2GF*,1BL_1AL*_1CR*_1SL_2GF*_2MFP,1CR*_4CR,2CR_2GF_2ST_1SI,1AL_1SL_1GF*_2GF_1SC_1MFP_1FP!,1DE_1DR,1CR*_2SL_2CR_1GF_1DL,1AL*_2AL_1GF*_2GF_1SC,3SL_3CR,1AL_2AL_1GF*,1CR*_2GF_3SL_2CR,2AL_1GF*,2GF_3SL_2CR_1AL*_1MFP,1DE,1DL_1CR*_2ST_1BL_1SI_1SC_2FP_1MFP,1GF_4ST,1AL_3CY,1CR*_4ST,2CY_1GF*_1AL*,2AL_1GF*_1HU,3CR,2AL_1SL,1CR*_1BL_1SC,1AL_1MFP_1FP_2HU,1DR_1DE,"$
	"1DL_2SL_2CR_1GF*_2SI,1AL*_2CY_1SL_1BL,1CR*_1CR,2ST,1SL_2AL_1GF,2GF_2GF*,1AL_4CR,2CR_2GF_1SI_1SC_1MFP_1FP,2ST_1CR*_1AL*_1AL_1GF_1HU,4CR,3AL_1SL,2SL_1CR_1GF_2SI,1CR*_2BL_1AL_1GF*,2SC_1MFP_1HU,1DE,1DL_2CY_1SL_1BL,2CR,2ST,1FP!_1HU,1AL*_1SL_1AL_1GF,2GF_2GF*,1CR*_4CR,2CR_2GF_2ST_1SI,1AL_1SL_2GF_1GF*_1SC_1MFP,2SL_2CR_1GF,1BL_1CR*_1SC,1AL*_1MFP_2FP_2HU,1AL_2AL_1GF*_2GF,3SL_3CR,1AL*_2AL_1GF*,1DL_1DR,1DE_1CR*_2GF_3SL_2CR_1SC,2AL_2GF,3SL_2CR_1AL_1GF*_1MFP,3CY_1CR_2ST_1BL_1SI,1CR*_1GF_4ST,1AL*_3CY,4ST_1SC,2CY_1GF*_1AL,2AL_1GF*_1HU,4CR,2AL_1SL";
	
	// Wave 07
	sink[i++] = "1SL_1AL_1GF_1AL*,2AL_2GF,1CR*_2SL_2CR_1GF,3CY_1CR_2ST,1AL,1AL_1GF*,1BL_1SC_2MFP_1HU,1DL,1DE,2BL_1AL*_1HU,2SC_1FP!_2FP,3ST_1GF_3GF*,1CR_2ST_1AL_1SI,1AL,2SL_2CR_1GF_1SI,1GF_1AL*_1CR*_1SC_1SI_1MFP_1HU,4CR_1CR*,2SL_1GF_3CR,2GF*_1SC_1MFP_1HU,1FP,1AL_2CY,4CY,1CR*_1HU_1AL_2SL,1SL_1AL_1GF,1DR,1DL,1MFP,1AL*_2AL_2GF,2SL_3CR_1GF*_1SC,1AL_2CY_1CR*_2ST_1CY_1SI,2CY_1AL_1GF*_1MFP,4ST,3GF_1GF*_2SC,1CR_2ST_1BL_2SI_1AL*,2CY_1AL,1CR*_2SL_1GF_1GF*_1SC_1AL_1MFP_2FP,2SL_2CR_2GF_2SI,1CR*_1AL*_4CR,4CR,2CY_1BL,"$
	"4CY_1AL,1DE,1DR_1SL_1AL_1GF*_1AL*,2AL_2GF,1CR_1CR*_2SL_1GF*_1SC_1MFP_2FP,3CY_1CR_2ST_1BL,1AL,1AL_1GF,2CR_2ST_1AL*_1SI_1SC,1AL,1CR*_2SL_1CR_2GF_2SI,1AL_4CR,2SL_2GF_1GF*,1BL_1CR*_1SC,2MFP_1HU,2BL_1CR*_1AL*,2SC_2FP!_1HU_1FP,1DL,1DE_3ST_2GF_2GF*,1SC_1HU,1MFP,1CR*_3CR,1AL_2CY_1BL,4CY,1AL_2SL,1SL_1AL_1GF,1AL*_2AL_2GF,1CR*_2SL_2CR_1GF*_1SC_1MFP,1AL_2CY_1CR_2ST_1CY_1SI,2SL_2GF_1AL*,1CR*_2CY_1AL_1GF*,4ST,3GF_1GF*_1DR,1DL,1CR_2ST_1BL_2SI_1AL,2CY_1AL,1CR*_2SL_2CR_2GF_2SI,1AL*_4CR_1SC_1MFP_1FP,4CR,2CY_1BL,4CY_1AL";
	
	// Wave 08
	sink[i++] = "2SL_3GF*_1AL*,1CR*_1CR,1AL_1GF_1HU,1MFP_1AL_2ST,1SL_2AL_1GF,2SL_1CR_2GF,1CR*_2SI_1AL*,1MFP,2AL_1SL,1CR*_2CR,1BL_1SC_1AL_1HU_2GF*,1BL_1CR*_1AL*_2SC,2MFP_2FP!_1HU,1DL,1DR,2SL_2CR_1GF,2MFP_1FP,1CY_1CR_2ST_1BL_1SI,1CR*_4ST,1AL_2GF,2GF*_1HU,2CR_2GF,2ST_1FP_1SI,1AL_1CR*,1AL*_4CR_1SC_1CR*,2CR,1AL_2AL_1GF_1HU,2ST_1CR*,1FP!_1SL_1AL_1GF*,2SL_1CR_1GF,1DE,1DL_1GF*_1AL*_2SI_1SC_1MFP,2AL_1SL,1CR*_3CR_1AL_1AL_2GF*,1SC_1FP,1AL*_2SL_2CR_1GF*,"$
	"1CR*_2SL_2GF_1GF*_1SC_1MFP,2CY_1CR_2ST_1SI_1AL,2AL,4ST_2CY,1BL_2GF*_1CR*_1SC_1AL*_1FP,1AL_2GF,2CR_2GF_2ST_1SI,5CR_2GF*,2SL_3GF*_1SC_1AL*_1MFP,1DE,1FP,1FP!,1CR*_2CY_1BL,2CR,1AL_1GF*_1HU_1SC,1AL_2ST,1SL_2AL_1GF*,1GF_2SL_2CR_1GF*_1SC_1FP_1MFP,1CR*_2SI_1AL*,2AL_1SL,3CR,1GF*_2SL_2CR_1GF,2CY_1CR_2ST_1SI,4ST,1AL_2CY,2GF_2GF*,1CR*_1HU,2AL_1GF*_2HU,2BL_1CR*_1SC_1AL*_1HU,2FP,2MFP,2CR_2GF_2ST_1SI,1AL,1AL_4CR_1CR*,1SC_1FP!_1MFP,1DL_3CY_1BL,"$
	"1CR*_2CR,1AL*_2AL_1GF*_1HU,2ST,1SL_1AL_1GF,1MFP,2SL_2CR_2GF,1AL_2SI,2AL_1SL,2AL_1CR*_1CR_2GF*_2SC_1MFP,1DE_1AL*_2SL_2CR_1GF,2SL_3GF,2CY_1CR_2ST_1BL_1SI_1AL,1CR*_2AL,1BL_4ST,3CY,1AL*_2GF_1SC_1FP_1FP!,2CR_2GF_2ST_1SI,2GF*_5CR,1SC_1AL,2SL_3GF*_1AL*,1BL_1CR*_1CR_1SC,1AL_1GF_1HU,1AL_2ST,1SL_2AL_1GF,2SL_1CR_2GF,1CR*_2SI_1AL*,2AL";
	
	// Wave 09
	sink[i++] = "1CR*_4ST_1SC_1MFP,1AL_1AL*,2CY,2CR,2AL_1SL_1AL,1MFP,2FP!_1FP,2SC_2HU,1CR*_4CR,2CR_2GF_1SI,2GF*_1GF_1MFP,2BL_1AL*,2SC_2HU_1DE,1AL_1CR*,2ST_1MFP,1SL_2AL_1GF,1DL_3CR_1AL*,2MFP,1GF*_1AL_1GF,2SL_1CR_1GF_1FP,2CY_1CR_2ST,1MFP_1AL_1SI,1GF*_2CR_1GF_2ST,1CR*_1AL*_1CY_1SC,2FP,2SL_2GF_1SC_1GF*,4ST,2CY,2CR,1CR*_1AL,3CY_2GF,3AL_1SL,4CR,2SL_2CR_1GF_1SI,1DE,1DR_5GF_1CR*_1AL*,"$
	"1SC_1MFP!_1FP!,1ST,1SL_1AL_1GF_1HU,3CR_1CR*_1SC,1SL_2CR_1GF*_1AL,1AL_1GF,1MFP_1AL_1SC,1AL*_1CR*,1CY_1CR_1ST_1BL_1SI,1SL_2GF_1GF*_1SC_1AL_1MFP,1CR*_1CY,1CR_1GF_1ST_1SI,1CR*_1HU_1AL*,1CY_1CR_1ST,1BL_1MFP_1SI,1CY,1GF_1SL_1GF*,1AL_3ST,1DL_1CR*_2AL_1SC,2FP_1MFP,3CY_1BL,1CR,2AL_1SL,4CR_1CR*,1AL*_2CR_1GF_1SI_1GF*,1BL_1GF*_1CR*_1AL_1HU_1SI_1FP!_1MFP,1BL_1GF*_1CR*_1SC,1AL*_1HU_1SI_1FP_1MFP,1DR,2ST,1SL_1AL_1GF,3CR,2AL_2GF,"$
	"2SL_3CR_1GF*,1CR*_1AL,1FP,1CY_1CR_2ST,1SI,2CR_2GF_2ST,1AL*_2CY,2SL_2GF*_1SC_1CR*_1MFP,4ST,1BL_1GF*_1CR*_2SC_1AL_1HU_1SI,3CY_1BL,2CR,1DE,1BL_1GF*_1CR*,1SC,1AL*_1HU_1SI_1FP,1AL_1HU,1CY_2GF*,1FP!,1FP,3AL_1SL,1CR*_6CR,2SL_2CR_2GF_2SI,2GF*_1AL*_2GF,2ST,1SL_2AL_1GF,1CR*_3CR,2SL_3CR_1GF,2AL_1GF_1GF*,1CR*_1CR_2ST_1SI_1SC,1DL,1DR_1FP_1MFP!,2SL_3GF_1AL,1CY,2CR_1GF_2ST_1SI,1CR*_1AL*_1HU,3CY_1CR_2ST,1GF_4CY_2GF*_1SL,1CR*_1HU_4ST_1SC,1FP!_1MFP!,1AL_1AL,2CY";
	
	// Wave 10
	sink[i++] = "1SL_1AL_1GF*_1AL*,1MFP,1CR_1CR*,1SC_1CY_1SL,1MFP,2AL_1AL_2SL_1CR_1GF,1FP!,1MFP_1SC,2SL_1CR_2GF*_1AL*,1MFP,1SC_1SI,1CR*_2AL_1SL,1MFP,1BL_1SC_1AL,1DE_2HU,1MFP,2AL_1GF,1GF*_2HU_2CY,2FP,2FP!,1BL_1CR*,1MFP_1AL*,1DR_1SC_1HU,1MFP,4ST,2SL_1GF*_2GF,1DL,4CR_1AL,2CR_2ST,2SI,1CR*_2CY_1AL_1FP,1GF_1AL*,1SC_1MFP,2CY_1CR_2ST_1SI,2GF_2GF*,1CR*_1SL_2AL_1GF,4CR,1BL_2CY_1AL_1FP_1HU,1SC_2CY_2AL,2AL_1GF_1GF*,1BL,2SL_2CR_1GF,2SL_1CR_1CR*_2GF*_1AL*_1MFP,"$
	"1SC,1BL_1GF*_1CR*_1AL_2FP_1HU,1SI_2SL_2GF,3AL_1SL,1SC_2CY_1AL_4ST,1CR_2ST_1SI,1AL*_6CR,2CY_1AL_1GF,2CY_1CR_1ST,1CR*_1SC_2MFP_1HU,1SI,1AL_2GF_1GF*,1FP,1SL_1AL_1GF,2CR_1DE,1DL_1CY,1SC_1SL,1AL_1CY,1AL_1GF,1CR*_1AL*_2CY,1BL_1GF*_1CR*_1SC,2AL_1SI_1FP,2SL_2CR_1GF*_2MFP,1BL_1GF*_1CR*_1SC,1FP,1AL*_1HU_1SI_1FP,1AL_2AL_1SL,4ST,1SL_2GF*_1SC,1GF_1CR*_2CR,1AL*_1CR_2ST,1FP,1BL_2SI,1AL_1GF_1AL,1CR_2ST_1BL_1SI,1CR*_2GF,2GF*,1SC_1AL_1FP!,2GF*_1CR*,"$
	"1SC_1HU_1FP,1SL_2AL_1GF,1CR_1AL*_2CY_1BL,2AL_2SC,1AL_2CY,2AL_2GF_1FP,2SL_2CR_1GF*,1CR*_1AL*_2SL_2CR_2GF,2SI,2SL_3GF*_1SC,1FP_1MFP,3AL_1SL,1AL_2CY_1AL,1DL_4ST,1DR_1CR_2ST_1SI,1CR*_1AL*_4CR,1MFP_1FP_1SC,2CY_1AL_1GF,3CY_1CR_2ST,1SC,1FP!_1MFP,2GF_1GF*_1AL,1SL_2AL_1GF_1GF*,1CR*_3CR_1SC_1MFP,1AL*_2CY_1SL,2AL_2CY,2AL_1GF,2CY_2AL,2SL_3CR_1GF,1SL_1AL_1GF*_1AL*,1MFP,1CR_1CR*,1SC_1CY_1SL,1MFP,2AL_1AL_2SL_1CR_1GF,1FP!,1MFP_1SC";
}

function string GetDate()
{
	return "2020-02-29";
}

function string GetAuthor()
{
	return "Nam";
}
