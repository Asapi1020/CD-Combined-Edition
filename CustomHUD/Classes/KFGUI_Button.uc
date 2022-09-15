Class KFGUI_Button extends KFGUI_Clickable;

`include(Build.uci)
`include(Logger.uci)


var() Canvas.CanvasIcon OverlayTexture;
var() string ButtonText, GamepadButtonName;
var() color TextColor;
var() Canvas.FontRenderInfo TextFontInfo;
var() byte FontScale, ExtravDir;
var bool bIsHighlighted;

var() bool bUseTexture;
var() int ButtonStyle;

function DrawMenu()
{
	Owner.CurrentStyle.RenderButton(Self);
}

function bool GetUsingGamepad()
{
	return Owner.bUsingGamepad && GamepadButtonName != "";
}

function HandleMouseClick(bool bRight)
{
	if (bRight)
		OnClickRight(Self);
	else OnClickLeft(Self);
}

Delegate OnClickLeft(KFGUI_Button Sender);
Delegate OnClickRight(KFGUI_Button Sender);

Delegate bool DrawOverride(Canvas C, KFGUI_Button B)
{
	return false;
}

defaultproperties
{
	ButtonText="Button!"
	TextColor=(R=0, G=0, B=0, A=255)
	TextFontInfo=(bClipText=true, bEnableShadow=true)
	FontScale=1
}