// Menu system written by Marco.
Class KFGUI_Base extends Object
	abstract;

`include(Build.uci)
`include(Logger.uci)


var KF2GUIController Owner;
var CustomGFxHudWrapper HUDOwner;
var KFGUI_Base ParentComponent; // Parent component if any.
var transient Canvas Canvas;

enum EMenuSound
{
	MN_Focus,
	MN_LostFocus,
	MN_FocusHover,
	MN_ClickButton,
	MN_ClickCheckboxOn,
	MN_ClickCheckboxOff,
	MN_Dropdown,
	MN_DropdownChange,
};

var() float XPosition, YPosition, XSize, YSize;
var() name ID; // Just for internal purposes, you can give the components unique ID values.
var() int IDValue; // Integer ID value.
var transient float CompPos[4], InputPos[4];

var transient KFGUI_Base MouseArea; // Next in recurse line of the mouse pointer focus area.

var() bool bDisabled, bClickable, bCanFocus;
var bool bFocusedPostDrawItem; // If this component has been given input focus, should it receive draw menu call after everything else been drawn?
var transient bool bFocused, bTextureInit, bVisible;
var bool bIsHUDWidget, bEnableInputs, bNoLookInputs, bForceInput;
var array<name> TimerNames;

function InitMenu(); // Menu was initialized for the first time.
function ShowMenu(); // Menu was opened.
function PreDraw()
{
	if (!bVisible)
		return;

	ComputeCoords();
	Canvas.SetDrawColor(255, 255, 255);
	Canvas.SetOrigin(CompPos[0], CompPos[1]);
	Canvas.SetClip(CompPos[0]+CompPos[2], CompPos[1]+CompPos[3]);
	DrawMenu();
}
function DrawMenu(); // Draw menu now.
function CloseMenu(); // Menu was closed.
function InventoryChanged(optional KFWeapon Wep, optional bool bRemove); // Called when a players inventory is changed.
function MenuTick(float DeltaTime);

final function SetTimer(float InRate, optional bool inbLoop, optional Name inTimerFunc='Timer')
{
	if (InRate <= 0.f)
	{
		ClearTimer(inTimerFunc);
		return;
	}

	if (TimerNames.Find(inTimerFunc) == INDEX_NONE)
	{
		TimerNames.AddItem(inTimerFunc);
	}

	`TimerHelper.SetTimer(InRate, inbLoop, inTimerFunc, self);
}
final function ClearTimer(optional Name inTimerFunc='Timer')
{
	if (TimerNames.Find(inTimerFunc) != INDEX_NONE)
	{
		TimerNames.RemoveItem(inTimerFunc);
	}

	`TimerHelper.ClearTimer(inTimerFunc, self);
}
function Timer();

function MouseEnter()
{
	bFocused = true;
	OnFocus(Self, True);
}
function MouseLeave()
{
	bFocused = false;
	OnFocus(Self, False);
}
function MouseClick(bool bRight);
function MouseRelease(bool bRight);
function DoubleMouseClick(bool bRight ) // User rapidly double clicked this component.
{
	MouseClick(bRight);
}

function ScrollMouseWheel(bool bUp);

function bool ReceievedControllerInput(int ControllerId, name Key, EInputEvent Event)
{
	return false;
}

final function PlayerController GetPlayer()
{
	return Owner.PlayerOwner;
}

function SetDisabled(bool bDisable)
{
	bDisabled = bDisable;
}

Delegate OnFocus(KFGUI_Base Sender, bool bBecame);

final function ComputeCoords()
{
	CompPos[0] = XPosition*InputPos[2]+InputPos[0];
	CompPos[1] = YPosition*InputPos[3]+InputPos[1];
	CompPos[2] = XSize*InputPos[2];
	CompPos[3] = YSize*InputPos[3];
}

function bool CaptureMouse()
{
	if(SomeAncestorIsInvisible())
	{
		return false;
	}

	return bVisible && ( Owner.MousePosition.X >= CompPos[0] && Owner.MousePosition.Y >= CompPos[1] && Owner.MousePosition.X <= (CompPos[0]+CompPos[2]) && Owner.MousePosition.Y <= (CompPos[1]+CompPos[3]));
}

/**
 * Invisible KFGUI_MultiComponents do not render their components even if their bVisible is true.
 * Prevent mouse capture if the parent component is not visible
 */
protected function bool SomeAncestorIsInvisible()
{
	local array<KFGUI_Base> Ancestors;
	local KFGUI_Base Parent;
	local int count;

	Parent = ParentComponent;

	while (Parent != None && Parent != Self && Ancestors.Find(Parent) == INDEX_NONE)
	{
		if (!Parent.bVisible)
		{
			return true;
		}

		Ancestors.AddItem(Parent);
		Parent = Parent.ParentComponent;

		count++;
		if (count > 100)
		{
			`warning("KFGUI_Base::SomeAncestorIsInvisible: Too many ancestors, breaking loop.");
			break;
		}
	}

	return false;
}

final function KFGUI_Base GetMouseFocus()
{
	local KFGUI_Base M;

	for (M=Self; M.MouseArea != None; M=M.MouseArea)
	{}
	return M;
}

function SetVisibility(bool Visible)
{
	bVisible = Visible;
}

function DoClose()
{
	local int i;

	for (i=0; i < TimerNames.Length; i++)
	{
		ClearTimer(TimerNames[i]);
	}

	if (ParentComponent != None)
		ParentComponent.DoClose();
	else Owner.PopCloseMenu(Self);
}

function byte GetCursorStyle()
{
	return (bClickable ? `PEN_BLACK : `PEN_WHITE);
}

function UserPressedEsc() // user pressed escape while this menu was active.
{
	if (ParentComponent != None)
		ParentComponent.UserPressedEsc();
	else DoClose();
}
function bool BringPageToFront()
{
	if (ParentComponent != None)
		return ParentComponent.BringPageToFront();
	return true; // Allow user to bring this page to front.
}
final function bool IsTopMenu()
{
	return (Owner.ActiveMenus.Length > 0 && GetPageTop() == Owner.ActiveMenus[0]);
}
final function KFGUI_Page GetPageTop()
{
	local KFGUI_Base M;

	for (M=Self; M.ParentComponent != None; M=M.ParentComponent)
	{}
	return KFGUI_Page(M);
}
function KFGUI_Base FindComponentID(name InID)
{
	if (ID == InID)
		return Self;
	return None;
}
function FindAllComponentID(name InID, out array<KFGUI_Base> Res)
{
	if (ID == InID)
		Res[Res.Length] = Self;
}
function RemoveComponent(KFGUI_Base B);

function GetInputFocus()
{
	if (Owner.InputFocus != None)
		Owner.InputFocus.LostInputFocus();
	Owner.InputFocus = Self;
}
function DropInputFocus()
{
	if (Owner.InputFocus == Self)
	{
		Owner.InputFocus.LostInputFocus();
		Owner.InputFocus = None;
	}
}
function LostInputFocus();

// Obtain keyboard focus.
final function GrabKeyFocus()
{
	Owner.GrabInputFocus(Self);
}
final function ReleaseKeyFocus()
{
	if (Owner.KeyboardFocus == Self)
		Owner.GrabInputFocus(None);
}
function LostKeyFocus();

function bool NotifyInputKey(int ControllerId, name Key, EInputEvent Event, float AmountDepressed, bool bGamepad)
{
	if ((bIsHUDWidget && bEnableInputs) || bForceInput)
	{
		switch (Key)
		{
		case 'XboxTypeS_Start':
		case 'Escape':
			if (Event == IE_Pressed)
				UserPressedEsc();
			return true;
		case 'XboxTypeS_DPad_Up':
		case 'XboxTypeS_DPad_Down':
		case 'XboxTypeS_DPad_Left':
		case 'XboxTypeS_DPad_Right':
		case 'MouseScrollDown':
		case 'MouseScrollUp':
		case 'MouseScrollDown':
		case 'MouseScrollUp':
			if (Event == IE_Pressed)
				ScrollMouseWheel(Key == 'MouseScrollUp' || Key == 'XboxTypeS_DPad_Up' || Key == 'XboxTypeS_DPad_Left');
			return true;
		}
	}

	return false;
}
function bool NotifyInputAxis(int ControllerId, name Key, float Delta, float DeltaTime, bool bGamepad)
{
	return false;
}
function bool NotifyInputChar(int ControllerId, string Unicode)
{
	return false;
}

// While on input focus mode, notify that mouse just moved over the threshold.
function InputMouseMoved();

// Notify any focused menu element that mouse has been idle over it.
function NotifyMousePaused();

final function GetActualPos(out float X, out float Y)
{
	X = ((XPosition+X)*InputPos[2]) + InputPos[0];
	Y = ((YPosition+Y)*InputPos[3]) + InputPos[1];
}
final function GetRelativePos(out float X, out float Y)
{
	X = X / CompPos[2];
	Y = Y / CompPos[2];
}

simulated final function PlayMenuSound(EMenuSound Slot)
{
	local SoundCue S;
	local KFGameEngine Engine;

	Engine = KFGameEngine(class'Engine'.static.GetEngine());

	switch (Slot)
	{
	case MN_FocusHover:
	case MN_Focus:
		S = Owner.CurrentStyle.MenuHover;
		break;
	case MN_LostFocus:
		S = Owner.CurrentStyle.MenuFade;
		break;
	case MN_ClickButton:
	case MN_ClickCheckboxOff:
		S = Owner.CurrentStyle.MenuClick;
		break;
	case MN_Dropdown:
		S = Owner.CurrentStyle.MenuDown;
		break;
	case MN_DropdownChange:
		S = Owner.CurrentStyle.MenuEdit;
		break;
	}

	if (S != None)
	{
		S.VolumeMultiplier = (Engine.SFxVolumeMultiplier/100.f) * (Engine.MasterVolumeMultiplier/100.f);
		GetPlayer().PlaySound(S, true, ,false);
	}
}

// Pre level change notification.
function NotifyLevelChange();

final function SetPosition(float X, float Y, float XS, float YS)
{
	XPosition = X;
	YPosition = Y;
	XSize = XS;
	YSize = YS;
}

static final function string MakeSortStr(int Value)
{
	local string S;
	local int i;

	// Prefix with zeroes to properly sort this string.
	S = string(Value);
	i = Len(S);
	if (i < 10)
		return Mid("0000000000", i)$S;
	return S;
}

final protected function DrawTexture(Texture2D Tex, float X, float Y, float IconWidth)
{
	local float XPos, YPos, ScaledIconWidth, W, H;

	XPos = X * CompPos[2];
	YPos = Y * CompPos[3];
	ScaledIconWidth = IconWidth * CompPos[2];

	W = Tex.GetSurfaceWidth();
	H = Tex.GetSurfaceHeight();

	Canvas.SetPos(XPos, YPos);
	Canvas.DrawTile(Tex, ScaledIconWidth, ScaledIconWidth * H / W, 0, 0, W, H);
}

defaultproperties
{
	XSize=1
	YSize=1
	bCanFocus=true
	bVisible=true
}
