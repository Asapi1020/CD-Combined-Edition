Class KFGUI_RightClickMenu extends KFGUI_Clickable;

`include(Build.uci)
`include(Logger.uci)

struct FRowItem
{
	var string Text, ToolTip;
	var bool bSplitter, bDisabled;
};
var array<FRowItem> ItemRows;
var int CurrentRow, OldRow;
var int EdgeSize;
var int OldSizeX;
var transient bool bDrawToolTip;
var Color BoxColor, OutlineColor;

function OpenMenu(KFGUI_Base Menu)
{
	Owner = Menu.Owner;
	InitMenu();
	PlayMenuSound(MN_Dropdown);
	GetInputFocus();
	OldSizeX = 0;
}
final function ComputeSize()
{
	local float XS, YS, XL, YL, Scalar;
	local int i;
	local string S;

	if (OldSizeX == Owner.ScreenSize.X)
		return;
 
	if (ItemRows.Length == 0)
	{
		YS = 0;
		XS = 50;
	}
	else
	{
		Canvas.Font = Owner.CurrentStyle.PickFont(Scalar);
		for (i=0; i < ItemRows.Length; ++i)
		{
			if (ItemRows[i].bSplitter)
				S = "----";
			else S = ItemRows[i].Text;

			Canvas.TextSize(S, XL, YL, Scalar, Scalar);

			XS = FMax(XS, XL);
			YS += YL;
		}
	}
	XSize = (XS+(EdgeSize*12)) / Owner.ScreenSize.X;
	YSize = (YS+(EdgeSize*4)) / Owner.ScreenSize.Y;

	ComputePosition();

	OldSizeX = Owner.ScreenSize.X;
}
function ComputePosition()
{
	XPosition = float(Owner.MousePosition.X+4) / Owner.ScreenSize.X;
	YPosition = float(Owner.MousePosition.Y+4) / Owner.ScreenSize.Y;
	if ((XPosition+XSize) > 1.f)
		YPosition = (float(Owner.MousePosition.X) / Owner.ScreenSize.X) - XSize; // Move to left side of mouse pointer.
	if ((YPosition+YSize) > 1.f)
		YPosition -= ((YPosition+YSize)-1.f); // Move up until fit on screen.
}
final function AddRow(string Text, bool bDisable, optional string AltToolTip)
{
	local int i;

	i = ItemRows.Length;
	ItemRows.Length = i+1;
	if (Text == "-")
		ItemRows[i].bSplitter = true;
	else
	{
		ItemRows[i].Text = Text;
		ItemRows[i].ToolTip = AltToolTip;
		ItemRows[i].bDisabled = bDisable;
	}
}
function PreDraw()
{
	ComputeSize();
	Super.PreDraw();
}
function DrawMenu()
{   
	Owner.CurrentStyle.RenderRightClickMenu(Self);

	if (bDrawToolTip)
	{
		if (OldRow != CurrentRow)
			bDrawToolTip = false;
		DrawToolTip();
	}
}
function DrawToolTip()
{
	local float X, Y,XL, YL, BoxW, BoxH, TextX, TextY, Scalar, CursorSize;
	local string S;

	Canvas.Reset();
	Canvas.SetClip(float(Owner.ScreenSize.X), float(Owner.ScreenSize.Y));

	S = ItemRows[CurrentRow].ToolTip;
	Canvas.Font = Owner.CurrentStyle.PickFont(Scalar);
	Canvas.TextSize(S, XL, YL, Scalar, Scalar);

	CursorSize = Owner.CurrentStyle.ScreenScale(Owner.CursorSize);
	X = Owner.MousePosition.X+CursorSize;
	Y = Owner.MousePosition.Y+CursorSize;
	BoxW = XL * 1.05f;
	BoxH = YL * 1.25f;

	while ((X + BoxW) > Canvas.ClipX)
	{
		X -= 0.01;
	}

	Owner.CurrentStyle.DrawOutlinedBox(X, Y, BoxW, BoxH, EdgeSize, MakeColor(5, 5,5, 255), MakeColor(115, 115, 115, 255));

	TextX = X + (BoxW/2) - (XL/2) - (EdgeSize/2);
	TextY = Y + (BoxH/2) - (YL/2) - (EdgeSize/2);

	Canvas.DrawColor = class'HUD'.default.WhiteColor;
	Canvas.SetPos(TextX, TextY);
	Canvas.DrawText(S, ,Scalar, Scalar);
}
function HandleMouseClick(bool bRight)
{
	if (CurrentRow >= 0 && (ItemRows[CurrentRow].bSplitter || ItemRows[CurrentRow].bDisabled))
		return;
	OnSelectedItem(CurrentRow);
	PlayMenuSound(MN_ClickButton);
	DropInputFocus();
}
function LostInputFocus()
{
	OnBecameHidden(Self);
	OldRow = -1;
	CurrentRow = -1;
}
function NotifyMousePaused()
{
	if (CurrentRow != -1 && ItemRows[CurrentRow].ToolTip != "")
		bDrawToolTip = true;
}

Delegate OnSelectedItem(int Index);
Delegate OnBecameHidden(KFGUI_RightClickMenu M);

defaultproperties
{
	CurrentRow=-1
	OldRow=-1
	bFocusedPostDrawItem=true
	bHoverSound=false
	EdgeSize=2
	BoxColor=(R=5, G=5, B=5, A=200)
	OutlineColor=(R=115, G=115, B=115, A=255)
}