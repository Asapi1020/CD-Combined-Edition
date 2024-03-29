class su_v1_short extends CD_SpawnCycle_PresetBase
    implements(CD_SpawnCycle_Preset);

function GetShortSpawnCycleDefs(out array<string> sink)
{
    local int I;

    I = 0;
    sink.Length = 4;
    sink[I++] = "6AL,3AL*,4GF*,3GF_2BL,4GF*,5CR,1FP,3SL,4AL*,3SI,3ST,4GF*,3AL*,2BL";
    sink[I++] = "5ST,1FP,5AL,2AL*,3GF,4CR,1SC,2CR,4AL,2SL,3AL*,1FP,4ST,2GF,5GF*,2HU,1FP,2BL,3SI,1CR,2AL*,2SC,1GF,3BL";
    sink[I++] = "2FP,3BL,4ST,2HU,5AL,1FP,1SC,3ST,3GF*,4AL,4SL,2SC,2AL*,3GF*,2AL*,4GF,2FP,2BL,3SI,3AL*,4GF*,1FP,1SC,4GF*,4GF,2AL*";
    sink[I++] = "2FP,1SC,2GF*,3GF*,3SI,3AL*,1FP,3SC,3SL,2AL,6CR,5ST,2FP,1SC,3AL*,3AL*,2GF*,4ST,3SC,4SI,3ST,4SL,2AL*,2FP,3BL,2HU,1AL*,4SL,3FP";
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
    return "2021-12-14";   
}

function string GetAuthor()
{
    return "sujigami";   
}
