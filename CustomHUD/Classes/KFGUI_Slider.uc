class KFGUI_Slider extends KFGUI_MultiComponent;

`include(Build.uci)
`include(Logger.uci)

var KFGUI_ScrollBarH ScrollBar;

var int MinValue, MaxValue;
var transient int CurrentValue;

delegate OnValueChanged(KFGUI_Slider Sender, int Value);

function InitMenu()
{
	Super.InitMenu();
	ScrollBar = KFGUI_ScrollBarH(FindComponentID('Scrollbar'));
	ScrollBar.OnScrollChange = ValueChanged;
}

function int GetValue()
{
	return CurrentValue;
}

function SetValue(int Value)
{
	CurrentValue = Clamp(Value, MinValue, MaxValue);
	OnValueChanged(self, CurrentValue);
}

function ValueChanged(KFGUI_ScrollBarBase Sender, int Value)
{
	SetValue(Value);
}

function UpdateListVis()
{
	ScrollBar.UpdateScrollSize(CurrentValue, MaxValue, 1,1, MinValue);
}

function ScrollMouseWheel(bool bUp)
{
	if (!ScrollBar.bDisabled)
		ScrollBar.ScrollMouseWheel(bUp);
}

defaultproperties
{
	Begin Object Class=KFGUI_ScrollBarH Name=SliderScroll
		XSize=1
		YSize=0.5
		ID="Scrollbar"
	End Object
	Components.Add(SliderScroll)
}
