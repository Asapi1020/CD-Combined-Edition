Class KFGUI_ComboSelector extends KFGUI_Clickable;

`include(Build.uci)
`include(Logger.uci)

var KFGUI_ComboBox Combo;
var KFGUI_ScrollBarV ScrollBar;

var int CurrentRow, OldRow, PerPage;

function InitMenu()
{
	Super.InitMenu();

	ScrollBar = new class'KFGUI_ScrollBarV';
	ScrollBar.Owner = Owner;
	ScrollBar.XPosition = 1.f;
	ScrollBar.YPosition = 0.f;
	ScrollBar.XSize = 0.04f;
	ScrollBar.YSize = 1.f;
	ScrollBar.InitMenu();
}

function PreDraw()
{
	local byte i;

	Super.PreDraw();

	ScrollBar.Canvas = Canvas;
	for (i = 0; i < 4; i++)
	{
		ScrollBar.InputPos[i] = CompPos[i];
	}
	ScrollBar.PreDraw();
}

function DrawMenu()
{
	Owner.CurrentStyle.RenderComboList(Self);
}

function HandleMouseClick(bool bRight)
{
	PlayMenuSound(MN_ClickButton);
	DropInputFocus();
	if (CurrentRow >= 0)
	{
		Combo.SelectedIndex = CurrentRow;
		Combo.OnComboChanged(Combo);
	}
}

function ScrollMouseWheel(bool bUp)
{
	if (!ScrollBar.bDisabled)
		ScrollBar.ScrollMouseWheel(bUp);
}

public function UpdateScrollSize()
{
	ScrollBar.UpdateScrollSize(ScrollBar.CurrentScroll, (Combo.Values.Length - PerPage), 1, PerPage);
}

defaultproperties
{
	CurrentRow=-1
	OldRow=-1
	bFocusedPostDrawItem=true
}
