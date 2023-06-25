class CD_Pawn_Human extends KFPawn_Human;

/* ==============================================================================================================================
 *  Overridden
 * ============================================================================================================================== */

simulated event PostBeginPlay()
{
    super(KFPawn).PostBeginPlay();
    SetTimer(1.0, true, 'UpdateBatteryDrainRate');
}

//	Infinite Flashlight
simulated function UpdateBatteryDrainRate(){ BatteryDrainRate = 0.f; }

/* ==============================================================================================================================
 *  Others
 * ============================================================================================================================== */

function CD_PlayerController GetCDPC()
{
    return CD_PlayerController(Controller);
}