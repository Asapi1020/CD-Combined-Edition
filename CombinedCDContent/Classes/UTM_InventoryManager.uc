class UTM_InventoryManager extends KFInventoryManager;

simulated function AttemptQuickHeal()
{
	super.AttemptQuickHeal();

	if ( Instigator.Health < Instigator.HealthMax &&
		 UTM_PlayerController(Instigator.Controller).bUltraSyringe )
	{
		UTM_Pawn_Human(Instigator).ServerGiveMaxHealth();
	}
}