class KFGUI_ProgressBar extends KFGUI_Base;

`include(Build.uci)
`include(Logger.uci)

var Texture BarBack;
var Texture BarTop;
var Color BarColor;
var float Low;
var float High;
var float Value;

var float CaptionWidth;
var byte CaptionAlign;
var byte ValueRightAlign;
var string Caption;

var float GraphicMargin;
var float ValueRightWidth;
var bool bShowLow;
var bool bShowHigh;
var bool bShowValue;
var int NumDecimals;

var byte BorderSize;

function DrawMenu()
{
	local float Left, Top, Width, Height;
	local float W, Sc;
	local string S;

	Super.DrawMenu();

	Left = 0.f;
	Top = 0.f;
	Width = CompPos[2];
	Height = CompPos[3];

	// Select the right font in the Canvas
	Canvas.Font = Owner.CurrentStyle.PickFont(Sc); 

	if (CaptionWidth > 0.0 && Width > 0 && Len(Caption) > 0)
	{
		W = CaptionWidth;

		if (W < 1.0)
		{
			W *= Width;
		}

		if (W > Width)
		{
			W = Width;
		}

		// Draw the label
		Owner.CurrentStyle.DrawTextJustified(CaptionAlign, Left, Top, Left + W, Top + Height, Caption, Sc, Sc);
		Left += W;
		Width -= W;
	}

	if ((bShowHigh || bShowValue) && ValueRightWidth > 0.0 && Width > 0.0)
	{
		W = ValueRightWidth;

		if (W < 1.0)
		{
			W *= Width;
		}

		if (W > Width)
		{
			W = Width;
		}

		if (bShowValue && bShowHigh)
		{
			S = int(Value)$"/"$int(High);
		}
		else if (bShowValue)
		{
			S = string(int(Value));
		}
		else 
		{
			S = string(int(High));
		}

		Owner.CurrentStyle.DrawTextJustified(ValueRightAlign, Left + Width - W, Top, Left + Width, Top + Height, S, Sc, Sc);

		Width -= W;
	}

	if (Width > GraphicMargin)
	{
		Width -= GraphicMargin;
		Left += GraphicMargin / 2;
	}

	Canvas.SetDrawColor(255, 255, 255, 255);
	if (Width > 0.0 && BarBack != None)
	{
		Owner.CurrentStyle.DrawTileStretched(BarBack, Left, Top, Width, Height);
	}

	if (Width > 0.0 && BarTop != None && Value > Low)
	{
		Canvas.DrawColor = BarColor;
		Owner.CurrentStyle.DrawTileStretched(BarTop, Left + BorderSize, Top + BorderSize, (Width - (BorderSize * 2)) * (Value/High), Height - (BorderSize * 2));
	}
}

function SetValue(float val)
{
	Value=val;
}

function float GetValue()
{
	return Value;
}

defaultproperties
{
	BarColor=(R=255, G=255, B=255, A=255)
	Low=0.f
	High=100.f
	Value=0.f
	bShowLow=false
	bShowHigh=false
	bShowValue=true
	CaptionWidth=0.45
	ValueRightWidth=0.2
	ValueRightAlign=0
	NumDecimals=0
}
