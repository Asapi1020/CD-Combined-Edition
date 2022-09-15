class CD_TestMut extends KFMutator;

var Pawn LastPawn;
var int LastHP;

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
