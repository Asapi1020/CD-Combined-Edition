class xUI_CycleMenu extends xUI_MenuBase;

var KFGUI_ColumnList CycleList;

var int SelectedCycleIndex;

function SetWindowDrag(bool bDrag)
{
	bDragWindow = false;
}

function InitMenu()
{
	super.InitMenu();

	CycleList = KFGUI_ColumnList(FindComponentID('Cycle'));
	CycleList.Columns.AddItem(newFColumnItem("Spawn Cycle", 1.f));
}

function DrawMenu()
{
	local int i;

	super.DrawMenu();

	if(CycleList.ListCount != GetCDPRI().CycleNames.length)
	{
		CycleList.EmptyList();
		for(i=0; i<GetCDPRI().CycleNames.length; i++)
		{
			CycleList.AddLine(GetCDPRI().CycleNames[i]);

			if(GetCDPRI().CycleNames[i] ~= GetCDGRI().CDInfoParams.SC)
				SelectedCycleIndex = i;
		}
	}
	CycleList.SelectedRowIndex = SelectedCycleIndex;
}

function SelectedCycleRow(KFGUI_ListItem Item, int Row, bool bRight, bool bDblClick)
{
	if(bDblClick && Row >= 0)
	{
		SelectedCycleIndex = Row;
		GetCDPC().SetSpawnCycle(GetCDPRI().CycleNames[Row]);
	}
}

defaultproperties
{
	XPosition=0.70
	YPosition=0.50
	XSize=0.15
	YSize=0.4
	bHide=true

	Begin Object Class=KFGUI_ColumnList Name=Cycle
		XPosition=0.05
		YPosition=0.05
		XSize=0.9
		YSize=0.9
		ID="Cycle"
		OnSelectedRow=SelectedCycleRow
		bCanSortColumn=false
		bOpaque=true
	End Object

	Components.Add(Cycle)
}