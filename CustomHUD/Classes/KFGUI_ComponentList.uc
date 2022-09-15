// List box with components as items.
Class KFGUI_ComponentList extends KFGUI_List;

`include(Build.uci)
`include(Logger.uci)

var int VisRange[2];
var() int NumColumns;
var array<KFGUI_Base> ItemComponents;

// REMEMBER to call InitMenu() on the newly created component after values are init!!!
final function KFGUI_Base AddListComponent(class<KFGUI_Base> CompClass, optional float XS=1.f, optional float YS=1.f)
{
	return AddComponentAtIndex(ItemComponents.Length, CompClass, XS, YS);
}

final function KFGUI_Base CreateComponent(class<KFGUI_Base> CompClass, optional float XS=1.f, optional float YS=1.f)
{
	local KFGUI_Base G;

	G = new(Self)CompClass;
	if (G == None)
		return None;

	G.XPosition = (1.f - XS) * 0.5f;
	G.YPosition = (1.f - YS) * 0.5f;
	G.XSize = XS;
	G.YSize = YS;

	return G;
}

final function AddItem(KFGUI_Base Item)
{
	AddItemAtIndex(ItemComponents.Length, Item);
}

final function AddItemAtIndex(int i, KFGUI_Base Item)
{
	ItemComponents.InsertItem(i, Item);
}

final function KFGUI_Base AddComponentAtIndex(int i, class<KFGUI_Base> CompClass, optional float XS=1.f, optional float YS=1.f)
{
	local KFGUI_Base G;

	G = CreateComponent(CompClass, XS, YS);
	G.Owner = Owner;
	G.ParentComponent = Self;
	ItemComponents.InsertItem(i, G);

	return G;
}

function EmptyList()
{
	ItemComponents.Length = 0;
}

function InitMenu()
{
	Super.InitMenu();
	ListCount = 0;
	NumColumns = Max(NumColumns, 1);
}

function DrawMenu()
{
	if (bDrawBackground)
	{
		Canvas.SetDrawColor(250, 250, 250, 255);
		Canvas.SetPos(0.f, 0.f);
		Canvas.DrawTileStretched(Owner.CurrentStyle.BorderTextures[`BOX_INNERBORDER], CompPos[2], CompPos[3], 0,0, 128, 128);
	}
}

function PreDraw()
{
	local int i;
	local byte j;

	if (!bVisible)
		return;

	ComputeCoords();

	// Update list size
	i = ItemComponents.Length / NumColumns;
	if (i != NumColumns)
	{
		ListCount = i;
		UpdateListVis();
	}

	if (!ScrollBar.bDisabled && !ScrollBar.bHideScrollbar)
	{
		// First draw scrollbar to allow it to resize itself.
		for (j=0; j < 4; ++j)
			ScrollBar.InputPos[j] = CompPos[j];
		if (OldXSize != InputPos[2])
		{
			OldXSize = InputPos[2];
		}
		ScrollBar.Canvas = Canvas;
		ScrollBar.PreDraw();

		// Then downscale our selves to give room for scrollbar.
		CompPos[2] -= ScrollBar.CompPos[2];
		Canvas.SetOrigin(CompPos[0], CompPos[1]);
		Canvas.SetClip(CompPos[0]+CompPos[2], CompPos[1]+CompPos[3]);
		DrawMenu();
		PreDrawListItems();
		CompPos[2] += ScrollBar.CompPos[2];
	}
	else
	{
		Canvas.SetOrigin(CompPos[0], CompPos[1]);
		Canvas.SetClip(CompPos[0]+CompPos[2], CompPos[1]+CompPos[3]);
		DrawMenu();
		PreDrawListItems();
	}
}

function PreDrawListItems()
{
	local int i, XNum, r;
	local float XS, YS;

	XNum = 0;
	r = 0;
	XS = CompPos[2] / NumColumns;
	YS = CompPos[3] / ListItemsPerPage;
	VisRange[0] = (ScrollBar.CurrentScroll*NumColumns);
	VisRange[1] = ItemComponents.Length;
	for (i=VisRange[0]; i < VisRange[1]; ++i)
	{
		ItemComponents[i].Canvas = Canvas;
		ItemComponents[i].InputPos[0] = CompPos[0]+XS*XNum;
		ItemComponents[i].InputPos[1] = CompPos[1]+YS*r;
		ItemComponents[i].InputPos[2] = XS;
		ItemComponents[i].InputPos[3] = YS;
		ItemComponents[i].PreDraw();

		if (++XNum == NumColumns)
		{
			XNum = 0;
			if (++r == ListItemsPerPage)
			{
				VisRange[1] = i+1;
				break;
			}
		}
	}
}

function ChangeListSize(int NewSize);

function MouseClick(bool bRight);
function MouseRelease(bool bRight);
function MouseLeave()
{
	Super(KFGUI_Base).MouseLeave();
}
function MouseEnter()
{
	Super(KFGUI_Base).MouseEnter();
}

function bool CaptureMouse()
{
	local int i;

	if (ItemComponents.Length > 0)
	{
		for (i=VisRange[1] - 1; i >= VisRange[0] && i < ItemComponents.Length; i--)
		{
			if (ItemComponents[i].CaptureMouse())
			{
				MouseArea = ItemComponents[i];
				return true;
			}
		}
	}

	return Super.CaptureMouse();
}
function CloseMenu()
{
	local int i;

	for (i=0; i < ItemComponents.Length; ++i)
		ItemComponents[i].CloseMenu();
	Super.CloseMenu();
}
function NotifyLevelChange()
{
	local int i;

	for (i=0; i < ItemComponents.Length; ++i)
		ItemComponents[i].NotifyLevelChange();
	Super.NotifyLevelChange();
}
function InventoryChanged(optional KFWeapon Wep, optional bool bRemove)
{
	local int i;

	for (i=0; i < ItemComponents.Length; ++i)
		ItemComponents[i].InventoryChanged(Wep, bRemove);
}
function MenuTick(float DeltaTime)
{
	local int i;

	Super.MenuTick(DeltaTime);
	for (i=0; i < ItemComponents.Length; ++i)
		ItemComponents[i].MenuTick(DeltaTime);
}

defaultproperties
{
	ListCount=0
	NumColumns=1
	bClickable=true
	bDrawBackground=false
}