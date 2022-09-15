class CD_Pawn_ZedClot_AlphaKing extends KFPawn_ZedClot_AlphaKing;

simulated event PostBeginPlay()
{
	local CD_PlayerController CDPC;

	super.PostBeginPlay();

	CDPC = CD_PlayerController( GetALocalPlayerController() );

	if ( CDPC != none && !CDPC.AlphaGlitterBool )
	{
		SpecialMoveHandler.SpecialMoveClasses[SM_Rally] = class'CD_AlphaRally_NoGlitter';
	}
}

defaultproperties
{
	ElitePawnClass.Empty
}