class xUI_Console extends Console within GameViewportClient
    transient;

var transient Console OriginalConsole;
var transient xUI_ConsoleMenu ConsoleMenu;
var transient KF2GUIController Controller;
var transient bool bDisconnecting;
var transient CD_GFxHUDWrapper HUD;
var string PreviousMessage;
var bool bTyping;

function Initialized()
{
    local int i;

    super.Initialized();
    Controller = class'KF2GUIController'.static.GetGUIController(Outer.Outer.GamePlayers[0].Actor);
    HUD = CD_GFxHUDWrapper(Outer.Outer.GamePlayers[0].Actor.myHUD);
    OriginalConsole = Outer.ViewportConsole;
    ConsoleMenu = new (none) class'xUI_ConsoleMenu';
    ConsoleMenu.Owner = Controller;
    ConsoleMenu.HUDOwner = HUD;
	ConsoleMenu.MainConsole = self;
    ConsoleMenu.InitMenu();

    for(i=0; i < OriginalConsole.Scrollback.Length; i++)
    {
        ConsoleMenu.AddText(OriginalConsole.Scrollback[i] $ "<LINEBREAK>");
    }
    Controller.PersistentMenus.AddItem(ConsoleMenu);
    if((OriginalConsole.GetStateName() == 'Open') || OriginalConsole.GetStateName() == 'Typing')
    {
        OriginalConsole.GotoState('None');
        Controller.OpenMenu(ConsoleMenu.Class);
    }
}

function ConsoleCommand(string Command)
{
    local string S, OrgS;
    local int OldLen, NewLen, i;
    local array<string> splitbuf;

    if(Command ~= "clear")
    {
        ClearOutput();
        return;
    }
    
    if(Command ~= "disconnect")
    {
        ConsoleMenu = none;
        Controller.Destroy();
        Outer.Outer.GamePlayers[0].Actor.myHUD.Destroy();
        bDisconnecting = true;
        OriginalConsole.ConsoleCommand(Command);
        return;
    }
	S = ("\n#{00ff00}>>>#{NOPARSE}" @ Command) @ "#{00ff00}<<<#{NOPARSE}";
    ConsoleMenu.AddText(S $ "<LINEBREAK>");
    OldLen = OriginalConsole.Scrollback.Length;
    OriginalConsole.ConsoleCommand(Command);
    NewLen = OriginalConsole.Scrollback.Length;
    ParseStringIntoArray(Command, splitbuf, " ", false);
    S = Locs(splitbuf[0]);

    switch(S)
    {
        case "quit":
        case "exit":
        case "get":
        case "getall":
        case "enablecheats":
        case "display":
        case "displayall":
        case "say":
        	return;
    }
    
    for(i=OldLen; i < NewLen; i++)
    {
        OrgS = OriginalConsole.Scrollback[i];
        
        if(OrgS != PreviousMessage && InStr(OrgS, Command) == -1 && Len(OrgS) > 0)
        {
            ConsoleMenu.AddText(OrgS $ "#{DEF}" $ "<LINEBREAK>");
        }
    }
    PreviousMessage = OriginalConsole.Scrollback[OriginalConsole.SBHead];
}

function ClearOutput()
{
	ConsoleMenu.ChatBoxText.SetText("");
    OriginalConsole.ClearOutput();  
}

function OutputText(coerce string Text)
{
    if(ConsoleMenu == none)
    {
        OriginalConsole.OutputText(Text);
        return;
    }
    
    if(Text == "")
    {
        return;
    }
    OriginalConsole.OutputText(Text);
    ConsoleMenu.AddText(Text $ "<LINEBREAK>");  
}

function bool InputKey(int ControllerId, name Key, EInputEvent Event, optional float AmountDepressed, optional bool bGamepad)
{
    local PlayerController PC;

    AmountDepressed = 1.0;
    bGamepad = false;
    
    if(bDisconnecting)
    {
        return false;
    }

    // Console Menu is open
    if(bCaptureKeyInput)
    {
        // Press Event
        if(Event == IE_Pressed)
        {
            if(Key == ConsoleKey)
            {
            	//	Change type to open
            	if(bTyping)
            	{
            		bTyping = false;
            		ConsoleMenu.Transit();
            	}
            	else
            	{
            		ConsoleMenu.DoClose();
            	}
                return true;
            }

            if(Key == TypeKey)
            {
            	ConsoleMenu.DoClose();
            	return true;
            }

            //	Handle Auto Completion
            if(ConsoleMenu.bAutoCompleteOpen && ConsoleMenu.ConsoleAutoComplete.ItemRows.Length > 0)
            {
            	if(Key == 'Up')
                {
                	if(ConsoleMenu.ConsoleAutoComplete.CurrentRow != -1)
	                {
	                    ConsoleMenu.CurrentEntryIndex = ConsoleMenu.ConsoleAutoComplete.CurrentRow;
	                }

                	if(ConsoleMenu.CurrentEntryIndex == -1)
                    {
                        ConsoleMenu.CurrentEntryIndex = ConsoleMenu.ConsoleAutoComplete.ItemRows.Length - 1;
                    }
                    else
                    {
                        -- ConsoleMenu.CurrentEntryIndex;
                        if(ConsoleMenu.CurrentEntryIndex < 0)
                        {
                            ConsoleMenu.CurrentEntryIndex = ConsoleMenu.ConsoleAutoComplete.ItemRows.Length - 1;
                        }
                    }

	                ConsoleMenu.ConsoleAutoComplete.bForceKeyboardAction = true;
	                ConsoleMenu.ChatBoxEdit.SetText(ConsoleMenu.ConsoleAutoComplete.ItemRows[ConsoleMenu.CurrentEntryIndex].Text, true, true);
	                return true;
                }
                else if(Key == 'Down')
                {
                	if(ConsoleMenu.ConsoleAutoComplete.CurrentRow != -1)
	                {
	                    ConsoleMenu.CurrentEntryIndex = ConsoleMenu.ConsoleAutoComplete.CurrentRow;
	                }

                	if(ConsoleMenu.CurrentEntryIndex == -1)
                    {
                        ConsoleMenu.CurrentEntryIndex = 0;
                    }
                    else
                    {
                        ++ ConsoleMenu.CurrentEntryIndex;
                        if(ConsoleMenu.CurrentEntryIndex >= ConsoleMenu.ConsoleAutoComplete.ItemRows.Length)
                        {
                            ConsoleMenu.CurrentEntryIndex = 0;
                        }
                    }

	                ConsoleMenu.ConsoleAutoComplete.bForceKeyboardAction = true;
	                ConsoleMenu.ChatBoxEdit.SetText(ConsoleMenu.ConsoleAutoComplete.ItemRows[ConsoleMenu.CurrentEntryIndex].Text, true, true);
	                return true;
                }
            }

            //	Other Auto Completion
            else if(Key == 'Up')
            {
                if(OriginalConsole.HistoryBot >= 0)
                {
                    if(OriginalConsole.HistoryCur == OriginalConsole.HistoryBot)
                    {
                        OriginalConsole.HistoryCur = OriginalConsole.HistoryTop;
                    }
                    else
                    {
                        -- OriginalConsole.HistoryCur;
                        if(OriginalConsole.HistoryCur < 0)
                        {
                            OriginalConsole.HistoryCur = OriginalConsole.MaxHistory - 1;
                        }
                    }
                    ConsoleMenu.ChatBoxEdit.SetText(OriginalConsole.History[OriginalConsole.HistoryCur], true, true);
                }
                return true;
            }
            else if(Key == 'Down')
            {
                if(OriginalConsole.HistoryBot >= 0)
                {
                    if(OriginalConsole.HistoryCur == OriginalConsole.HistoryTop)
                    {
                        OriginalConsole.HistoryCur = OriginalConsole.HistoryBot;
                    }
                    else
                    {
                        OriginalConsole.HistoryCur = (OriginalConsole.HistoryCur + 1) % OriginalConsole.MaxHistory;
                    }
                    ConsoleMenu.ChatBoxEdit.SetText(OriginalConsole.History[OriginalConsole.HistoryCur], true, true);
                }
                return true;
            }
        }

        // All Event
	    if(bCaptureKeyInput && ConsoleMenu.NotifyInputKey(ControllerId, Key, Event, AmountDepressed, bGamepad))
	    {                
	        return true;
	    }
	}

	// Console menu is close & Press Event
	if(Event == IE_Pressed)
	{
        if(Key == 'F10')
        {
            foreach class'Engine'.static.GetCurrentWorldInfo().LocalPlayerControllers(class'PlayerController', PC)
            {
                PC.ForceDisconnect();                
            }            
        }
        
        if(Key == ConsoleKey || Key == TypeKey)
        {
            class'WorldInfo'.static.GetWorldInfo().TimerHelper.SetTimer(0.010, false, 'EnableCaptureInput', self);
            bTyping = Key==TypeKey;
            return true;
        }
    }

    if ( Controller.ReceivedInputKey(ControllerId, Key, Event, AmountDepressed, bGamepad) )
    {
        return true;
    }

    return false;  
}

function EnableCaptureInput()
{
	bCaptureKeyInput = true;
    OriginalConsole.HistoryCur = OriginalConsole.HistoryTop;
    Controller.OpenMenu(ConsoleMenu.Class);   
}

function bool InputChar(int ControllerId, string Unicode)
{
    if(bCaptureKeyInput)
    {
        if(ConsoleMenu.NotifyInputChar(ControllerId, Unicode))
        {
            return true;
        }
    }
    return false;   
}

function bool InputAxis(int ControllerId, name Key, float Delta, float DeltaTime, optional bool bGamepad)
{
//	local int i;

    if(bCaptureKeyInput)
    {
        if(ConsoleMenu.NotifyInputAxis(ControllerId, Key, Delta, DeltaTime, bGamepad))
        {
            return true;
        }
    }
	/*
    for(i=0; i<Controller.ActiveMenus.length; i++)
    {
    	if (xUI_ConsoleMenu(Controller.ActiveMenus[i]) != none)
    	{
    		continue;
    	}

    	if (Controller.ActiveMenus[i].NotifyInputAxis(ControllerId, Key, Delta, DeltaTime, bGamepad))
    	{
    		return true;
    	}
    }
    */

    return false; 
}

function PostRender_Console(Canvas Canvas)
{
    
    if(Controller.bForceConsoleInput != bCaptureKeyInput)
    {
    	Controller.bForceConsoleInput = bCaptureKeyInput;
    }
    
    OriginalConsole.PostRender_Console(Canvas);
}

defaultproperties
{
    OnReceivedNativeInputAxis=InputAxis
}
