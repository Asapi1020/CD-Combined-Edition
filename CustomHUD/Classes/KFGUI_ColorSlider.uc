class KFGUI_ColorSlider extends KFGUI_MultiComponent;

`include(Build.uci)
`include(Logger.uci)

var KFGUI_Slider RSlider, GSlider, BSlider, ASlider;
var KFGUI_TextLable TextLable, RedLabel, GreenLabel, BlueLabel, AlphaLabel, RedValue, GreenValue, BlueValue, AlphaValue;
var KFGUI_ComponentList SettingsBox;

var Color DefaultColor;
var string CaptionText;

function InitMenu()
{
	Super.InitMenu();

	SettingsBox = KFGUI_ComponentList(FindComponentID('SettingsBox'));

	TextLable = KFGUI_TextLable(FindComponentID('CaptionText'));
	TextLable.SetText(CaptionText);

	RSlider = AddSlider("Red:", 'ColorSliderR', 0,255, RedLabel, RedValue);
	GSlider = AddSlider("Green:", 'ColorSliderG', 0,255, GreenLabel, GreenValue);
	BSlider = AddSlider("Blue:", 'ColorSliderB', 0,255, BlueLabel, BlueValue);
	ASlider = AddSlider("Alpha:", 'ColorSliderA', 0,255, AlphaLabel, AlphaValue);

	SetDefaultColor(DefaultColor);
}

function SetDefaultColor(Color Def)
{
	RSlider.SetValue(Def.R);
	RSlider.UpdateListVis();

	GSlider.SetValue(Def.G);
	GSlider.UpdateListVis();

	BSlider.SetValue(Def.B);
	BSlider.UpdateListVis();

	ASlider.SetValue(Def.A);
	ASlider.UpdateListVis();
}

final function KFGUI_Slider AddSlider(string Cap, name IDN, int MinValue, int MaxValue, out KFGUI_TextLable Label, out KFGUI_TextLable ColorValueLabel)
{
	local KFGUI_Slider SL;
	local KFGUI_MultiComponent MC;

	MC = KFGUI_MultiComponent(SettingsBox.AddListComponent(class'KFGUI_MultiComponent'));
	MC.InitMenu();
	Label = new(MC) class'KFGUI_TextLable';
	Label.SetText(Cap);
	Label.XSize = 0.45;
	Label.FontScale = 1;
	MC.AddComponent(Label);	
	ColorValueLabel = new(MC) class'KFGUI_TextLable';
	ColorValueLabel.XPosition = 0.95;
	ColorValueLabel.XSize = 0.1;
	ColorValueLabel.FontScale = 1;
	MC.AddComponent(ColorValueLabel);
	SL = new(MC) class'KFGUI_Slider';
	SL.XPosition = 0.575;
	SL.XSize = 0.35;
	SL.MinValue = MinValue;
	SL.MaxValue = MaxValue;
	SL.ID = IDN;
	SL.OnValueChanged = OnValueChanged;
	MC.AddComponent(SL);
	return SL;
}

function OnValueChanged(KFGUI_Slider Sender, int Value)
{
	switch (Sender.ID)
	{
		case 'ColorSliderR':
			RedValue.SetText(string(Value));
			TextLable.TextColor.R = Value;
			break;
		case 'ColorSliderG':
			GreenValue.SetText(string(Value));
			TextLable.TextColor.G = Value;
			break;
		case 'ColorSliderB':
			BlueValue.SetText(string(Value));
			TextLable.TextColor.B = Value;
			break;
		case 'ColorSliderA':
			AlphaValue.SetText(string(Value));
			TextLable.TextColor.A = Value;
			break;
	}

	OnColorSliderValueChanged(self, Sender, Value);
}

delegate OnColorSliderValueChanged(KFGUI_ColorSlider Sender, KFGUI_Slider Slider, int Value);

function DrawMenu()
{
	Owner.CurrentStyle.DrawTileStretched(Owner.CurrentStyle.BorderTextures[`BOX_SMALL], 0,0, CompPos[2], CompPos[3]);
}

defaultproperties
{
	Begin Object Class=KFGUI_ComponentList Name=ClientSettingsBox
		XPosition=0.05
		YPosition=0.1
		XSize=0.95
		YSize=0.95
		ID="SettingsBox"
		ListItemsPerPage=4
	End Object
	Components.Add(ClientSettingsBox)

	Begin Object Class=KFGUI_TextLable Name=CaptionLabel
		XSize=1
		YSize=0.125
		AlignX=1
		AlignY=1
		ID="CaptionText"
	End Object
	Components.Add(CaptionLabel)
}