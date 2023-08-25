class xUI_ConsoleMenu extends xUI_MenuBase;

var transient xUI_Console MainConsole;
var export editinline xUI_ConsoleAutoCompleteList ConsoleAutoComplete;
var transient bool bAutoCompleteOpen;
var int MaxAutoCompletes;

var int CurrentEntryIndex;
var array<string> SavedTextEntries;

var KFGUI_TextField ChatBoxText;
var KFGUI_EditBox ChatBoxEdit;

function InitMenu()
{
	super.InitMenu();
	ChatBoxText = KFGUI_TextField(FindComponentID('ChatBoxTextBox'));
	ChatBoxEdit = KFGUI_EditBox(FindComponentID('ChatBoxField'));
	CurrentEntryIndex = -1;
}

function DrawMenu()
{
	local float XPos, YPos, W, H;

    Super.DrawMenu();
	WindowTitle = Title @ "v1.0";
    W = CompPos[2];
    H = ChatBoxEdit.CompPos[3]/8;
    XPos = 0;
    YPos = CompPos[3] - ChatBoxEdit.CompPos[3] - H/2;
    Canvas.SetDrawColor(0, 255, 0, 255);
    Owner.CurrentStyle.DrawRectBox(XPos, YPos, W, H, 1.f, 0);
}

function ShowMenu()
{
	Super.ShowMenu();
	CurrentEntryIndex = -1;
	SetTimer(0.0150, false, 'SetConsoleOpen');
	if(ChatBoxText.ScrollBar != none)
    {
        ChatBoxText.ScrollBar.SetValue(ChatBoxText.ScrollBar.MaxRange);
    }
}

function SetConsoleOpen()
{
    Owner.GrabInputFocus(ChatBoxEdit, true);
}

function PlayerHitEnter(KFGUI_EditBox Sender, string S)
{
	MainConsole.ConsoleCommand(S);
}

final function CheckAutoCompletes(KFGUI_EditBox Sender)
{
    local int I;
    local string S, ToolTip;

    if(Sender.GetText() == "")
    {
        MainConsole.OriginalConsole.HistoryCur = MainConsole.OriginalConsole.HistoryTop;
    }
    MainConsole.TypedStr = Sender.GetText();
    MainConsole.UpdateCompleteIndices();
    ConsoleAutoComplete.ItemRows.Length = 0;
    
    if(MainConsole.AutoCompleteIndices.Length > 0)
    {
        if(!bAutoCompleteOpen)
        {
            bAutoCompleteOpen = true;
            ConsoleAutoComplete.OpenMenu(self);
        }
        CurrentEntryIndex = -1;
        
        for(I=0; I < MainConsole.AutoCompleteIndices.Length; I++)
        {
            if(ConsoleAutoComplete.ItemRows.Length - 1 == MaxAutoCompletes)
            {
                continue;
            }
            S = MainConsole.AutoCompleteList[MainConsole.AutoCompleteIndices[I]].Command;
            
            if((MainConsole.AutoCompleteIndices.Length <= (I + 1) ||
                S != MainConsole.AutoCompleteList[MainConsole.AutoCompleteIndices[I + 1]].Command) &&
                S != "")
            {
                ToolTip = MainConsole.AutoCompleteList[MainConsole.AutoCompleteIndices[I]].Desc;
                
                if(ToolTip ~= S)
                {
                    ToolTip = "";
                }
                ConsoleAutoComplete.AddRow(S, false, ToolTip);
            }
        }
    }
    else if(bAutoCompleteOpen)
    {
        CurrentEntryIndex = -1;
        ConsoleAutoComplete.DropInputFocus();
        bAutoCompleteOpen = false;
    }
}

function PreDraw()
{
	super.PreDraw();
    if(bAutoCompleteOpen)
    {
        ConsoleAutoComplete.InputPos[0] = 0.0;
        ConsoleAutoComplete.InputPos[1] = 0.0;
        ConsoleAutoComplete.InputPos[2] = float(Canvas.SizeX);
        ConsoleAutoComplete.InputPos[3] = float(Canvas.SizeY);
        ConsoleAutoComplete.Canvas = Canvas;
        ConsoleAutoComplete.OldSizeX = 0;
        ConsoleAutoComplete.PreDraw();
    }
}

function UserPressedEsc()
{
    MainConsole.OriginalConsole.HistoryCur = MainConsole.OriginalConsole.HistoryTop;
    super(KFGUI_Base).UserPressedEsc();
}

function CloseMenu()
{
	if(ChatBoxText.ScrollBar != none)
    {
        ChatBoxText.ScrollBar.SetValue(ChatBoxText.ScrollBar.MaxRange);
    }
    MainConsole.bCaptureKeyInput = false;
	bAutoCompleteOpen = false;
}

final function SelectedAutoComplete(int Index)
{
    ChatBoxEdit.SetText(ConsoleAutoComplete.ItemRows[Index].Text, true, true);
    ChatBoxEdit.GrabKeyFocus();
}

function bool NotifyInputChar(int Key, string Unicode)
{
	return ChatBoxEdit.NotifyInputChar(Key, Unicode); 
}

function bool NotifyInputKey(int ControllerId, name Key, EInputEvent Event, float AmountDepressed, bool bGamepad)
{
    //  Call History
    if(Event == IE_Pressed && SavedTextEntries.Length > 0)
    {
        if(Key == 'Up')
        {
            if(CurrentEntryIndex == -1)
            {
                CurrentEntryIndex = SavedTextEntries.Length - 1;
            }
            else
            {
                -- CurrentEntryIndex;
                if(CurrentEntryIndex < 0)
                {
                    CurrentEntryIndex = SavedTextEntries.Length - 1;
                }
            }
        }
        else if(Key == 'Down')
        {
            if(CurrentEntryIndex == -1)
            {
                CurrentEntryIndex = 0;
            }
            else
            {
                ++ CurrentEntryIndex;
                if(CurrentEntryIndex >= SavedTextEntries.Length)
                {
                    CurrentEntryIndex = 0;
                }
            }
        }
        ChatBoxEdit.SetText(SavedTextEntries[CurrentEntryIndex], true);
    }

    // Notify to Menu and EditBox
    super(KFGUI_Base).NotifyInputKey(ControllerId, Key, Event, AmountDepressed, bGamepad);
    ChatBoxEdit.NotifyInputKey(ControllerId, Key, Event, AmountDepressed, bGamepad);
    return true;
}

function ScrollMouseWheel(bool bUp)
{
    ChatBoxText.ScrollMouseWheel(bUp);
}

function AddText(string S)
{
	S = Repl(S, "\n", ChatBoxText.LineSplitter);
    S = Repl(S, "\"", "\'\'");
    ChatBoxText.AppendText(S);
}

defaultproperties
{
	// General
	XPosition=0.05
	YPosition=0.05
	XSize=0.90
	YSize=0.70
    MaxAutoCompletes=9 //(Max Index)
	bAlwaysTop=true
	bOnlyThisFocus=true
    bEnableInputs=true
    bForceInput=true
    FrameOpacity=250
    FrameColor=(R=0, G=0, B=0, A=220)

	// Components
	Begin Object Class=KFGUI_TextField Name=ChatBoxTextBox
		ID="ChatBoxTextBox"
		Text=""
    	TextColor=(R=195,G=195,B=195,A=255)
    	FontScale=0.90
    	XPosition=0.01
    	YPosition=0.032
    	XSize=0.99
    	YSize=0.936
    	LineSplitter="<LINEBREAK>"
        bShowScrollbar=true
        MaxHistory=512
        bNoReset=true
        bUseOutlineText=true
    End Object

    Begin Object Class=KFGUI_EditBox Name=ChatBoxField
    	ID="ChatBoxField"
        bDrawBackground=true
        FontColor=(R=0, G=255, B=0, A=255)
        BackgroundColor=(R=0, G=0, B=0, A=200)
        CursorColor=(R=0, G=255, B=0)
        MaxWidth=2048
        XPosition=0.0
        YPosition=0.968
        XSize=1.0
        YSize=0.032
        OnChange=CheckAutoCompletes
        OnTextFinished=PlayerHitEnter
    End Object

    Components.Add(ChatBoxTextBox)
    Components.Add(ChatBoxField)

    Begin Object Class=xUI_ConsoleAutoCompleteList Name=ConsoleAutoCompleteMenu
        OnSelectedItem=SelectedAutoComplete
    End Object

    ConsoleAutoComplete=ConsoleAutoCompleteMenu
}