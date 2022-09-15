Class KFGUI_FloatingWindowHeader extends KFGUI_Base;

`include(Build.uci)
`include(Logger.uci)

var bool bDragWindow;

function PreDraw()
{
	ComputeCoords();
}
function MouseClick(bool bRight)
{
	if (!bRight)
		KFGUI_FloatingWindow(ParentComponent).SetWindowDrag(true);
}
function MouseRelease(bool bRight)
{
	if (!bRight)
		KFGUI_FloatingWindow(ParentComponent).SetWindowDrag(false);
}

defaultproperties
{
	bClickable=true
}