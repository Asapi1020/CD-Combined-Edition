class machine_solo extends CD_SpawnCycle_PresetBase
    implements(CD_SpawnCycle_Preset);

function GetShortSpawnCycleDefs(out array<string> sink)
{
    local int I;

    I = 0;
    sink.Length = 4;
    sink[I++] = "4CY,2AL_2GF,6SL,3ST,4CR,2SI_1BL,3AL_1SL,4CY,4CR_2GF,3ST,4CY_1BL,3AL_1SL,2HU";
    sink[I++] = "2AL_3SL,4CR,3CY_3GF,1BL_1SI_3SL,1SC_4ST,1BL_1SI_3SL,2CY_2CR,2FP_1SC,2HU,4CR,6ST,2AL_3GF_2CY,1AL_3SL_1CY,4GF,1BL_4SL,2SI_4CR,1BL_2SC_2HU,3AL_3CY,4GF,5ST,2AL_3SL,4CR,1BL_1SI_1SC,4CY_2GF,1BL_2HU_1SI,1SC,2AL_2GF";
    sink[I++] = "2CY_2AL,3GF,4CR,1CY_2SL,2BL_1SI,2FP_2SC_2HU,6ST,4CR,2GF_1HU,2AL_3SL,2CY_2GF,4CR_3SL,2BL_2SI,1SC_1HU,4GF_1SL_1CY,4CR_2ST,3CY_2AL,4SL_2GF,2GF_2SI_1BL_1HU,2GF_1SC,4AL_2CY,5ST,2AL_3GF,2BL_2SI,4CR,4SL,2FP_2SC_2HU,1CY_3AL_1SL,3CY";
    sink[I++] = "4SL,2GF,4CR,2BL_2SI,3FP_2SC,4ST,3HU,4GF,2AL_2CY,4CR,2SC,4GF,6SL,3AL_1BL,3CY,1SC_1HU,4CR_2BL,4ST,2SI_4GF,3AL_1CY,2SL_2GF,3AL_1SI,1FP_2SC_2HU,4ST,3CY_2GF,2AL_2SL_2SI,4CR,3CY_2AL,2CR_4GF,2CR_3SL,2FP_2SC_2HU,4CY,4ST,2GF,3AL_3SL,3BL_1SI,4CR,2AL_2CY,1SC";   
}

function GetNormalSpawnCycleDefs(out array<string> sink)
{
    sink.Length = 0;
}

function GetLongSpawnCycleDefs(out array<string> sink)
{
    sink.Length = 0;
}

function string GetDate()
{
    return "2019-05-05";   
}

function string GetAuthor()
{
    return "Machine";   
}
