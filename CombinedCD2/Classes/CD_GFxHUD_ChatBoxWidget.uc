class CD_GFxHUD_ChatBoxWidget extends KFGFxHUD_ChatBoxWidget;

function AddChatMessage(string NewMessage, string HexVal)
{
	if( Left(NewMessage, 1) == " " )
		NewMessage = Mid(NewMessage, 1);

	super.AddChatMessage(NewMessage, HexVal);
}