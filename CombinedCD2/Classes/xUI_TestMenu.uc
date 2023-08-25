class xUI_TestMenu extends xUI_MenuBase;

var KFGUI_EditBox EditField;
var KFGUI_Button TestButton;

function DrawMenu()
{
	Super.DrawMenu();
	WindowTitle = "Test Menu";
}

function InitMenu()
{
	super.InitMenu();
	EditField = KFGUI_EditBox(FindComponentID('Edit'));
	TestButton = KFGUI_Button(FindComponentID('TestButton'));
}

function ButtonClicked(KFGUI_Button Sender)
{
	switch(Sender.ID)
	{
		case 'TestButton':
			GetCDPC().ClientMessage("Hi.", 'CDEcho');
			break;
	}
}

defaultproperties
{
//	General
	XPosition=0.18
	YPosition=0.05
	XSize=0.64
	YSize=0.9
	Begin Object Class=KFGUI_EditBox Name=EditBox
		ID="Edit"
		XPosition=0.05
		YPosition=0.09
		XSize=0.9
		YSize=0.08
		bDrawBackground=true
		//OnTextChange=MOTDEdited
	End Object
	Begin Object Class=KFGUI_Button Name=TestButton
		ID="TestButton"
		XPosition=0.05
		YPosition=0.20
		XSize=0.10
		YSize=0.05
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object
	Components.Add(EditBox)
	Components.Add(TestButton)
}