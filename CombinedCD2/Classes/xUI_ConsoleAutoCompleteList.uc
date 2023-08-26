class xUI_ConsoleAutoCompleteList extends KFGUI_RightClickMenu;

var KFGUI_Base BaseMenu;
var byte CurrentAlpha;
var int OldCurrentRow;
var bool bForceKeyboardAction, bReverse;
var IntPoint LastMousePos;

function OpenMenu(KFGUI_Base menu)
{
    Owner = menu.Owner;
    BaseMenu = menu;
    InitMenu();
    GetInputFocus();
    OldSizeX = 0;
}

function ComputePosition()
{
    XPosition = BaseMenu.XPosition;
    YPosition = BaseMenu.YPosition;

    if(bReverse && xUI_ConsoleMenu(BaseMenu) != none)
    {
    	YPosition += xUI_ConsoleMenu(BaseMenu).ChatBoxEdit.YPosition*BaseMenu.YSize - YSize;
    }
    else
    {
    	YPosition += BaseMenu.YSize;
    }
}

function DrawMenu()
{
    if(bForceKeyboardAction && LastMousePos != Owner.MousePosition)
    {
        bForceKeyboardAction = false;
    }
    
    if((CaptureMouse()) && !bForceKeyboardAction)
    {
        if(CurrentRow != OldRow)
        {
            CurrentAlpha = 0;
        }
        LastMousePos = Owner.MousePosition;
        super.DrawMenu();
        return;
    }
    DrawAutoCompletes();
    
    if(CurrentRow != -1)
    {
        DrawToolTipEx();
    }  
}

function DrawAutoCompletes()
{
    local float XL, YL, YP, Edge, textscale;

    local int I;
    local string S;

    Edge = float(EdgeSize);
    Owner.CurrentStyle.DrawOutlinedBox(0.0, 0.0, CompPos[2], CompPos[3], Edge, BoxColor, OutlineColor);
    Owner.CurrentStyle.PickFont(textscale);
    YP = Edge * float(2);
    CurrentRow = xUI_ConsoleMenu(BaseMenu).CurrentEntryIndex;
    
    if(OldCurrentRow != CurrentRow)
    {
        CurrentAlpha = 0;
        OldCurrentRow = CurrentRow;
    }
    Canvas.PushMaskRegion(Canvas.OrgX, Canvas.OrgY, Canvas.ClipX, Canvas.ClipY);
    
    for(I=0; I < ItemRows.Length; I++)
    {
        if(ItemRows[I].bSplitter)
        {
            S = "-------";
        }
        else
        {
            S = ItemRows[I].Text;
        }
        Canvas.TextSize(S, XL, YL, textscale, textscale);
        
        if(I == CurrentRow)
        {
            Canvas.SetPos(Edge, YP);
            Canvas.SetDrawColor(128, 0, 0, 255);
            Owner.CurrentStyle.DrawWhiteBox(CompPos[2] - (Edge * 2.0), YL);
        }
        Canvas.SetPos(Edge * float(6), YP);
        
        if(ItemRows[I].bSplitter)
        {
            Canvas.SetDrawColor(255, 255, 255, 255);
        }
        else if(ItemRows[I].bDisabled)
        {
            Canvas.SetDrawColor(148, 148, 148, 255);
        }
        else
        {
            Canvas.SetDrawColor(248, 248, 248, 255);
        }
        Canvas.DrawText(S,, textscale, textscale);
        YP += YL;
    }
    Canvas.PopMaskRegion();
}

function DrawToolTipEx()
{
    local float X, Y, XL, YL, BoxW, BoxH,
	    TextX, TextY, Scalar;

    local string S;

    Canvas.Reset();
    Canvas.SetClip(float(Owner.ScreenSize.X), float(Owner.ScreenSize.Y));
    S = ItemRows[CurrentRow].ToolTip;
    Canvas.Font = Owner.CurrentStyle.PickFont(Scalar);
    Canvas.TextSize(S, XL, YL, Scalar, Scalar);
    X = (CompPos[0] + CompPos[2]) + (float(EdgeSize) * 2.0);
    
    if(XL > (float(Owner.ScreenSize.X) - X))
    {
        Y = CompPos[1] + (float(CurrentRow) * YL) + YL + float(EdgeSize);
    }
    else
    {
        Y = CompPos[1] + (float(CurrentRow) * YL) + float(EdgeSize);
    }
    BoxW = FMin(XL * 1.250, float(Owner.ScreenSize.X));
    BoxH = YL * 1.250;
    
    while(X + BoxW > Canvas.ClipX)
    {
        X -= 0.010;
    }
    
    if(CurrentAlpha < 255)
    {
        CurrentAlpha = byte(Min(CurrentAlpha + 5, 255));
    }
    Owner.CurrentStyle.DrawOutlinedBox(X, Y, BoxW, BoxH, float(EdgeSize), BoxColor, OutlineColor); //(80, 10, 80, CurrentAlpha));
    TextX = X + (BoxW / float(2)) - (XL / float(2)) - float(EdgeSize / 4);
    TextY = Y + (BoxH / float(2)) - (YL / float(2)) - float(EdgeSize / 4);
    Canvas.DrawColor = class'HUD'.default.WhiteColor;
    Canvas.DrawColor.A = CurrentAlpha;
    Canvas.SetPos(TextX, TextY);
    Canvas.DrawText(S,, Scalar, Scalar);  
}

function HandleMouseClick(bool bRight)
{
    if(CurrentRow >= 0 && (ItemRows[CurrentRow].bSplitter || ItemRows[CurrentRow].bDisabled))
    {
        return;
    }
    OnSelectedItem(CurrentRow);
    PlayMenuSound(3);
    GetInputFocus();  
}

defaultproperties
{
	OutlineColor=(R=0, G=255, B=0, A=255)
}