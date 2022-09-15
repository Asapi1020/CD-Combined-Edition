Class KFGUI_ListHorz extends KFGUI_MultiComponent;

`include(Build.uci)
`include(Logger.uci)

var() bool bDrawBackground, bHideScrollbar, bUseFocusSound;
var() protected int ListCount;
var() int ListItemsPerPage;
var() float ButtonScale;
var() color BackgroundColor;
var KFGUI_ScrollBarH ScrollBar;

var transient float OldYSize, ItemWidth, MouseXHit;
var transient int FocusMouseItem, LastFocusItem;

var byte PressedDown[2];
var bool bPressedDown;

delegate OnDrawItem(Canvas C, int Index, float XOffset, float Height, float Width, bool bFocus);

// Requires bClickable=true to receive this event.
delegate OnClickedItem(int Index, bool bRight, int MouseX, int MouseY);
delegate OnDblClickedItem(int Index, bool bRight, int MouseX, int MouseY);

function InitMenu()
{
	Super.InitMenu();
	ScrollBar = KFGUI_ScrollBarH(FindComponentID('Scrollbar'));
	ScrollBar.bHideScrollbar = bHideScrollbar;
	ScrollBar.ButtonScale = ButtonScale <= 0.f ? 1.f : ButtonScale;
	UpdateListVis();
}

function DrawMenu()
{
	local int i, n;
	local float X;
	local bool bCheckMouse;

	if (bDrawBackground)
	{
		//Canvas.DrawColor = BackgroundColor;
		Canvas.SetDrawColor(250, 250, 250, 255);
		Canvas.SetPos(0.f, 0.f);
		Canvas.DrawTileStretched(Owner.CurrentStyle.BorderTextures[`BOX_INNERBORDER], CompPos[2], CompPos[3], 0,0, 128, 128);
	}

	// Mouse focused item check.
	bCheckMouse = bClickable && bFocused;
	FocusMouseItem = -1;
	if (bCheckMouse)
		MouseXHit = Owner.MousePosition.X - CompPos[0];

	n = ScrollBar.CurrentScroll;
	ItemWidth = CompPos[2] / ListItemsPerPage;
	X = 0.f;
	for (i=0; i < ListItemsPerPage; ++i)
	{
		if (n >= ListCount)
			break;
		if (bCheckMouse && FocusMouseItem == -1)
		{
			if (MouseXHit < ItemWidth)
				FocusMouseItem = n;
			else MouseXHit -= ItemWidth;
		}
		OnDrawItem(Canvas, n,X, CompPos[3], ItemWidth, (FocusMouseItem == n));
		X+=ItemWidth;
		++n;
	}
	if (LastFocusItem != FocusMouseItem)
	{
		LastFocusItem = FocusMouseItem;
		if (bUseFocusSound)
		{
			PlayMenuSound(MN_FocusHover);
		}
	}
}

function PreDraw()
{
	local int i;
	local byte j;

	if (!bVisible)
		return;

	ComputeCoords();

	if (!ScrollBar.bDisabled && !ScrollBar.bHideScrollbar)
	{
		// First draw scrollbar to allow it to resize itself.
		for (j=0; j < 4; ++j)
			ScrollBar.InputPos[j] = CompPos[j];
		if (OldYSize != InputPos[3])
		{
			OldYSize = InputPos[3];
			ScrollBar.YPosition = 1.f - ScrollBar.GetWidth();
		}
		ScrollBar.Canvas = Canvas;
		ScrollBar.PreDraw();

		// Then downscale our selves to give room for scrollbar.
		CompPos[3] -= ScrollBar.CompPos[3]*1.15f;
		Canvas.SetOrigin(CompPos[0], CompPos[1]);
		Canvas.SetClip(CompPos[0]+CompPos[2], CompPos[1]+CompPos[3]);
		DrawMenu();
		CompPos[3] += ScrollBar.CompPos[3]*1.15f;
	}
	else
	{
		Canvas.SetOrigin(CompPos[0], CompPos[1]);
		Canvas.SetClip(CompPos[0]+CompPos[2], CompPos[1]+CompPos[3]);
		DrawMenu();
	}

	// Then draw rest of components.
	for (i=0; i < Components.Length; ++i)
	{
		if (Components[i] != ScrollBar)
		{
			Components[i].Canvas = Canvas;
			for (j=0; j < 4; ++j)
				Components[i].InputPos[j] = CompPos[j];
			Components[i].PreDraw();
		}
	}
}
function UpdateListVis()
{
	if (ListCount <= ListItemsPerPage)
	{
		ScrollBar.UpdateScrollSize(0, 1,1, 1);
		ScrollBar.SetDisabled(true);
	}
	else
	{
		ScrollBar.UpdateScrollSize(ScrollBar.CurrentScroll, (ListCount-ListItemsPerPage), 1,ListItemsPerPage);
		ScrollBar.SetDisabled(false);
	}
}
function ChangeListSize(int NewSize)
{
	if (ListCount == NewSize)
		return;
	ListCount = NewSize;
	UpdateListVis();
}
final function int GetListSize()
{
	return ListCount;
}

function DoubleMouseClick(bool bRight)
{
	if (!bDisabled && bClickable)
	{
		PlayMenuSound(MN_ClickButton);
		PressedDown[byte(bRight)] = 0;
		bPressedDown = (PressedDown[0] != 0 || PressedDown[1] != 0);
		OnDblClickedItem(FocusMouseItem, bRight, MouseXHit, Owner.MousePosition.Y-CompPos[1]);
	}
}
function MouseClick(bool bRight)
{
	if (!bDisabled && bClickable)
	{
		PressedDown[byte(bRight)] = 1;
		bPressedDown = true;
	}
}
function MouseRelease(bool bRight)
{
	if (!bDisabled && bClickable && PressedDown[byte(bRight)] == 1)
	{
		PlayMenuSound(MN_ClickButton);
		PressedDown[byte(bRight)] = 0;
		bPressedDown = (PressedDown[0] != 0 || PressedDown[1] != 0);
		OnClickedItem(FocusMouseItem, bRight, MouseXHit, Owner.MousePosition.Y-CompPos[1]);
	}
}
function MouseLeave()
{
	Super.MouseLeave();
	PressedDown[0] = 0;
	PressedDown[1] = 0;
	bPressedDown = false;
}
function MouseEnter()
{
	Super.MouseEnter();
	LastFocusItem = -1;
	if (!bDisabled && bClickable && bUseFocusSound)
		PlayMenuSound(MN_FocusHover);
}

function ScrollMouseWheel(bool bUp)
{
	if (!ScrollBar.bDisabled)
		ScrollBar.ScrollMouseWheel(bUp);
}

function NotifyMousePaused()
{
	if (Owner.InputFocus == None && FocusMouseItem >= 0)
		OnMouseRest(FocusMouseItem);
}

Delegate OnMouseRest(int Item);

defaultproperties
{
	ListItemsPerPage=7
	ListCount=1
	BackgroundColor=(R=0, G=0, B=0, A=75)
	bDrawBackground=false
	bUseFocusSound=false

	Begin Object Class=KFGUI_ScrollBarH Name=ListScroller
		XPosition=0
		YPosition=0.96
		XSize=1
		YSize=0.04
		ID="Scrollbar"
	End Object
	Components.Add(ListScroller)
}