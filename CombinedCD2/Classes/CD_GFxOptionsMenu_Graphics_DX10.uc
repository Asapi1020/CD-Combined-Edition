class CD_GFxOptionsMenu_Graphics_DX10 extends KFGFxOptionsMenu_Graphics_DX10;

function Callback_ReadyClicked( bool bReady )
{
	local CD_PlayerController CDPC;

	CDPC = CD_PlayerController(GetPC());
	CD_GFxManager(CDPC.MyGFxManager).ReadyFilter(CDPC, bReady);
}