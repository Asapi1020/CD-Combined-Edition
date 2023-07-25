class CD_TestMut extends KFMutator;

var Pawn LastPawn;
var int LastHP;
var array<string> ReplaceArchPath;

//	for offline
static final function LogToConsole(string Text)
{
    local KFGameEngine KFGE;
    local KFGameViewportClient KFGVC;
    local Console TheConsole;
    
    KFGE = KFGameEngine(class'Engine'.Static.GetEngine());
    
    if (KFGE != none)
    {
        KFGVC = KFGameViewportClient(KFGE.GameViewport);
        
        if (KFGVC != none)
        {
            TheConsole = KFGVC.ViewportConsole;
            
            if (TheConsole != none)
                TheConsole.OutputText( "[HP Test]" $ Text);
        }
    }
}
/*
function NetDamage(int OriginalDamage, out int Damage, Pawn injured, Controller InstigatedBy, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType, Actor DamageCauser)
{
    if(NextMutator != none)
		NextMutator.NetDamage(OriginalDamage, Damage, injured, InstigatedBy, HitLocation, Momentum, DamageType, DamageCauser);
    
    if(injured != none && InstigatedBy.Pawn != injured && injured.Health > 0)
    {
	    ClearTimer('CheckHealth');
	    LastPawn = injured;
	    CheckHealth();
	    SetTimer(0.0010, false, 'CheckHealth');
    }
}

function CheckHealth()
{
	if(LastPawn != none && LastPawn.Health > 0 && LastHP != LastPawn.Health)
	{
		LastHP = LastPawn.Health;
		LogToConsole(string(LastHP));
	}
}
*/

function ModifyAI(Pawn AIPawn)
{
    local KFPawn_Monster KFPM;

    KFPM = KFPawn_Monster(AIPawn);
    if(KFPM != none)
    {
        KFPM.SetCharacterArch(class'KFPlayerReplicationInfo'.default.CharacterArchetypes[Rand(class'KFPlayerReplicationInfo'.default.CharacterArchetypes.length)], true);
    }
}
/*
defaultproperties
{
    ReplaceArchPath.Add("CHR_Playable_ARCH.CHR_MrFoster_archetype")
    ReplaceArchPath.Add("CHR_Playable_ARCH.CHR_Alberts_archetype")
    ReplaceArchPath.Add("CHR_Playable_ARCH.CHR_Knight_Archetype")
    ReplaceArchPath.Add("CHR_Playable_ARCH.chr_briar_archetype")
    ReplaceArchPath.Add("CHR_Playable_ARCH.CHR_Mark_archetype")
    ReplaceArchPath.Add("CHR_Playable_ARCH.CHR_Jagerhorn_Archetype")
    ReplaceArchPath.Add("CHR_Playable_ARCH.CHR_Ana_Archetype")
    ReplaceArchPath.Add("CHR_Playable_ARCH.CHR_Masterson_Archetype")
    ReplaceArchPath.Add("CHR_Playable_ARCH.CHR_Alan_Archetype")
    ReplaceArchPath.Add("CHR_Playable_ARCH.CHR_Coleman_archetype")
    ReplaceArchPath.Add("CHR_Playable_ARCH.chr_DJSkully_archetype")
    ReplaceArchPath.Add("CHR_Playable_ARCH.CHR_Strasser_Archetype")
    ReplaceArchPath.Add("CHR_Playable_ARCH.CHR_Tanaka_Archetype")
    ReplaceArchPath.Add("CHR_Playable_ARCH.chr_rockabilly_archetype")
    ReplaceArchPath.Add("CHR_Playable_ARCH.CHR_DAR_archetype")
    ReplaceArchPath.Add("CHR_Playable_ARCH.CHR_MrsFoster_archetype")
    ReplaceArchPath.Add("CHR_Playable_ARCH.CHR_BadSanta_Archetype")    
}*/