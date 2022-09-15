Class KFGUI_TextLable extends KFGUI_Base;

`include(Build.uci)
`include(Logger.uci)

var() protected string Text;
var() color TextColor;
var() Canvas.FontRenderInfo TextFontInfo;
var() byte AlignX, AlignY; // Alignment, 0=Left/Up, 1=Center, 2=Right/Down
var() float FontScale;
var() bool bUseOutline;
var() int OutlineSize;

var transient Font InitFont;
var transient float OldSize[2], InitOffset[2], InitFontScale;

function InitSize()
{
	local float XL, YL, TS;

	OldSize[0] = CompPos[2];
	OldSize[1] = CompPos[3];

	TS = Owner.CurrentStyle.GetFontScaler();
	TS *= FontScale;

	while (true)
	{
		Canvas.Font = Owner.CurrentStyle.MainFont;
		if (TextFontInfo.bClipText)
			Canvas.TextSize(Text, XL, YL, TS, TS);
		else
		{
			Canvas.SetPos(0, 0);
			if (TS == 1)
				Canvas.StrLen(Text, XL, YL);
			else
			{
				Canvas.SetClip(CompPos[2]/TS, CompPos[3]); // Hacky, since StrLen has no TextSize support.
				Canvas.StrLen(Text, XL, YL);
				XL*=TS;
				YL*=TS;
			}
		}
		if ((XL < (CompPos[2]*0.99) && YL < (CompPos[3]*0.99)))
			break;

		TS -= 0.001;
	}
	Canvas.SetClip(CompPos[0]+CompPos[2], CompPos[1]+CompPos[3]);
	InitFont = Canvas.Font;
	InitFontScale = TS;

	switch (AlignX)
	{
	case 0:
		InitOffset[0] = 0;
		break;
	case 1:
		InitOffset[0] = FMax((CompPos[2]-XL)*0.5, 0.f);
		break;
	default:
		InitOffset[0] = CompPos[2]-(XL+1);
	}
	switch (AlignY)
	{
	case 0:
		InitOffset[1] = 0;
		break;
	case 1:
		InitOffset[1] = FMax((CompPos[3]-YL)*0.5, 0.f);
		break;
	default:
		InitOffset[1] = CompPos[3]-YL;
	}
}
function SetText(string S)
{
	if (Text == S)
		return;
	Text = S;
	OldSize[0] = -1; // Force to refresh.
}
final function string GetText()
{
	return Text;
}

function DrawMenu()
{
	if (Text == "")
		return;

	// Need to figure out best fitting font.
	if (OldSize[0] != CompPos[2] || OldSize[1] != CompPos[3])
		InitSize();

	Canvas.Font = InitFont;
	Canvas.DrawColor = TextColor;
	if (bUseOutline)
	{
		Owner.CurrentStyle.DrawTextShadow(Text, InitOffset[0], InitOffset[1], OutlineSize, InitFontScale);
	}
	else
	{
		Canvas.SetPos(InitOffset[0], InitOffset[1]);
		Canvas.DrawText(Text, ,InitFontScale, InitFontScale, TextFontInfo);
	}
}
function bool CaptureMouse()
{
	return false;
}

defaultproperties
{
	Text="Label"
	TextColor=(R=255, G=255, B=255, A=255)
	TextFontInfo=(bClipText=false, bEnableShadow=true)
	FontScale=1.f
	OutlineSize=1
	bCanFocus=false
}