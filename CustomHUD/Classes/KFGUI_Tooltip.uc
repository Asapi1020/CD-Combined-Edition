Class KFGUI_Tooltip extends KFGUI_Base;

`include(Build.uci)
`include(Logger.uci)

var() array<string> Lines;
var() Canvas.FontRenderInfo TextFontInfo;
var byte CurrentAlpha;

function InputMouseMoved()
{
	DropInputFocus();
}
function MouseClick(bool bRight)
{
	DropInputFocus();
}
function MouseRelease(bool bRight)
{
	DropInputFocus();
}
function ShowMenu()
{
	CurrentAlpha = 1;
}

final function SetText(string S)
{
	ParseStringIntoArray(S, Lines, "<SEPERATOR>", false);
}

function PreDraw()
{
	if (!bVisible)
		return;

	Owner.CurrentStyle.RenderToolTip(Self);
}

defaultproperties
{
	TextFontInfo=(bClipText=true, bEnableShadow=true)
	bCanFocus=false
	bFocusedPostDrawItem=true
}