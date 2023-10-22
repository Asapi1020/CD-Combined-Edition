Class KF2GUIController extends Info
	transient;

`include(Build.uci)
`include(Logger.uci)

var() class<GUIStyleBase> DefaultStyle;

var PlayerController PlayerOwner;
var CustomGFxHudWrapper HUDOwner;
var transient KF2GUIInput CustomInput;
var transient PlayerInput BackupInput;
var transient GameViewportClient ClientViewport;

var delegate<Interaction.OnReceivedNativeInputKey> OldOnReceivedNativeInputKey;
var delegate<Interaction.OnReceivedNativeInputAxis> OldOnReceivedNativeInputAxis;
var delegate<Interaction.OnReceivedNativeInputChar> OldOnReceivedNativeInputChar;

var delegate<GameViewportClient.HandleInputAxis> OldHandleInputAxis;

var array<KFGUI_Page> ActiveMenus, PersistentMenus;
var transient KFGUI_Base MouseFocus, InputFocus, KeyboardFocus;
var IntPoint MousePosition, ScreenSize, OldMousePos, LastMousePos, LastClickPos[2];
var transient float MousePauseTime, MenuTime, LastClickTimes[2];
var transient GUIStyleBase CurrentStyle;

var transient Console OrgConsole;
var transient KFGUIConsoleHack HackConsole;

var array<Texture2D> CursorTextures;
var Color CursorColor;
var int CurrentCursorIndex, CursorSize;

var Texture DefaultPens[3];
var byte CursorFade, FastCursorFade, CursorFlash;
var int CursorStep, FastCursorStep;
var int FontBlurX, FontBlurX2, FontBlurY, FontBlurY2, FastFontBlurX, FastFontBlurX2, FastFontBlurY, FastFontBlurY2;

var bool bMouseWasIdle, bIsInMenuState, bAbsorbInput, bIsInvalid, bHideCursor, bUsingGamepad, bForceEngineCursor, bNoInputReset;
var bool bForceConsoleInput;

static function KF2GUIController GetGUIController(PlayerController PC)
{
	local KF2GUIController G;

	if (PC.Player == None)
	{
		return None;
	}

	foreach PC.ChildActors(class'CustomHUD.KF2GUIController', G)
	{
		if (!G.bIsInvalid)
		{
			break;
		}
	}

	if (G == None)
	{
		G = PC.Spawn(class'CustomHUD.KF2GUIController', PC);
	}

	return G;
}

simulated function PostBeginPlay()
{
	PlayerOwner = PlayerController(Owner);
	ClientViewport = LocalPlayer(PlayerOwner.Player).ViewportClient;
	HUDOwner = CustomGFxHudWrapper(PlayerOwner.myHUD);

	CurrentStyle = new (None) DefaultStyle;
	CurrentStyle.InitStyle();
	CurrentStyle.Owner = self;

	SetTimer(0.1, true, 'SetupFontBlur');
	SetTimer(0.05, true, 'SetupFastFontBlur');

	SetTimer(0.75, true, 'SetupCursorFlash');
}

simulated function SetupCursorFlash()
{
	if (CursorFlash == 255)
		CursorFlash = 0;
	else CursorFlash = 255;
}

simulated function SetupFastFontBlur()
{
	FastFontBlurX = RandRange(-8, 8);
	FastFontBlurX2 = RandRange(-8, 8);
	FastFontBlurY = RandRange(-8, 8);
	FastFontBlurY2 = RandRange(-8, 8);
}

simulated function SetupFontBlur()
{
	FontBlurX = RandRange(-8, 8);
	FontBlurX2 = RandRange(-8, 8);
	FontBlurY = RandRange(-8, 8);
	FontBlurY2 = RandRange(-8, 8);
}

simulated function Tick(float DT)
{
	Super.Tick(DT);

	DT /= WorldInfo.TimeDilation;

	CursorFade += 255 * DT * CursorStep;
	if (CursorFade <= 0)
	{
		CursorFade = 0;
		CursorStep = 1;
	}
	else if (CursorFade >= 255)
	{
		CursorFade = 255;
		CursorStep = -1;
	}

	FastCursorFade += 8192 * DT * FastCursorStep;
	if (FastCursorFade <= 0)
	{
		FastCursorFade = 0;
		FastCursorStep = 1;
	}
	else if (FastCursorFade >= 255)
	{
		FastCursorFade = 255;
		FastCursorStep = -1;
	}
}

simulated function Destroyed()
{
	if (PlayerOwner != None)
		SetMenuState(false);
}

simulated function HandleDrawMenu()
{
	if (HackConsole == None)
	{
		HackConsole = new(ClientViewport)class'CustomHUD.KFGUIConsoleHack';
		HackConsole.OutputObject = Self;
	}
	if (HackConsole != ClientViewport.ViewportConsole)
	{
		OrgConsole = ClientViewport.ViewportConsole;
		ClientViewport.ViewportConsole = HackConsole;

		// Make sure nothing overrides these settings while menu is being open.
		if (bIsInMenuState ) PlayerOwner.PlayerInput = CustomInput;
	}
}
simulated function RenderMenu(Canvas C)
{
	local int i;
	local float OrgX, OrgY, ClipX, ClipY;

	ClientViewport.ViewportConsole = OrgConsole;

	OrgX = C.OrgX;
	OrgY = C.OrgY;
	ClipX = C.ClipX;
	ClipY = C.ClipY;

	ScreenSize.X = C.SizeX;
	ScreenSize.Y = C.SizeY;
	CurrentStyle.Canvas = C;
	CurrentStyle.PickDefaultFontSize(C.SizeY);

	if (!KFPlayerController(PlayerOwner).MyGFxManager.bMenusActive)
	{
		HUDOwner.Canvas = C;

		for (i=(HUDOwner.HUDWidgets.Length-1); i >= 0; --i)
		{
			HUDOwner.HUDWidgets[i].InputPos[0] = 0.f;
			HUDOwner.HUDWidgets[i].InputPos[1] = 0.f;
			HUDOwner.HUDWidgets[i].InputPos[2] = ScreenSize.X;
			HUDOwner.HUDWidgets[i].InputPos[3] = ScreenSize.Y;
			HUDOwner.HUDWidgets[i].Canvas = C;
			HUDOwner.HUDWidgets[i].PreDraw();
		}

		C.SetOrigin(OrgX, OrgY);
		C.SetClip(ClipX, ClipY);
	}

	if (bIsInMenuState)
	{
		for (i=(ActiveMenus.Length-1); i >= 0; --i)
		{
			ActiveMenus[i].bWindowFocused = (i == 0);
			ActiveMenus[i].InputPos[0] = 0.f;
			ActiveMenus[i].InputPos[1] = 0.f;
			ActiveMenus[i].InputPos[2] = ScreenSize.X;
			ActiveMenus[i].InputPos[3] = ScreenSize.Y;
			ActiveMenus[i].Canvas = C;
			ActiveMenus[i].PreDraw();
		}
		if (InputFocus != None && InputFocus.bFocusedPostDrawItem)
		{
			InputFocus.InputPos[0] = 0.f;
			InputFocus.InputPos[1] = 0.f;
			InputFocus.InputPos[2] = ScreenSize.X;
			InputFocus.InputPos[3] = ScreenSize.Y;
			InputFocus.Canvas = C;
			InputFocus.PreDraw();
		}
		C.SetOrigin(OrgX, OrgY);
		C.SetClip(ClipX, ClipY);

		if (!bHideCursor)
		{
			DrawCursor(C, MousePosition.X, MousePosition.Y);
		}
	}

	if (OrgConsole != None)
		OrgConsole.PostRender_Console(C);
	OrgConsole = None;
}

simulated function DrawCursor(Canvas C, float PosX, float PosY)
{
	C.SetPos(PosX, PosY);
	C.DrawColor = CursorColor;
	C.DrawTile(CursorTextures[CurrentCursorIndex], CurrentStyle.ScreenScale(CursorSize), CurrentStyle.ScreenScale(CursorSize), 0.f, 0.f, CursorTextures[CurrentCursorIndex].SizeX, CursorTextures[CurrentCursorIndex].SizeY, , true);
}

simulated final function InventoryChanged(optional KFWeapon Wep, optional bool bRemove)
{
	local int i;

	for (i=(ActiveMenus.Length-1); i >= 0; --i)
	{
		ActiveMenus[i].InventoryChanged(Wep, bRemove);
	}
}

simulated final function SetMenuState(bool bActive)
{
	if (PlayerOwner.PlayerInput == None)
	{
		NotifyLevelChange();
		bActive = false;
	}

	if (bIsInMenuState == bActive)
		return;
	bIsInMenuState = bActive;
	bHideCursor = !bActive;

	if (bActive)
	{
		if (CustomInput == None)
		{
			CustomInput = new (KFPlayerController(PlayerOwner)) class'CustomHUD.KF2GUIInput';
			CustomInput.ControllerOwner = Self;
			CustomInput.OnReceivedNativeInputKey = ReceivedInputKey;
			CustomInput.BaseInput = PlayerOwner.PlayerInput;
			BackupInput = PlayerOwner.PlayerInput;
			PlayerOwner.Interactions.AddItem(CustomInput);
		}

		OldOnReceivedNativeInputKey = BackupInput.OnReceivedNativeInputKey;
		OldOnReceivedNativeInputAxis = BackupInput.OnReceivedNativeInputAxis;
		OldOnReceivedNativeInputChar = BackupInput.OnReceivedNativeInputChar;

		BackupInput.OnReceivedNativeInputKey = ReceivedInputKey;
		BackupInput.OnReceivedNativeInputAxis = ReceivedInputAxis;
		BackupInput.OnReceivedNativeInputChar = ReceivedInputChar;

		OldHandleInputAxis = ClientViewport.HandleInputAxis;
		ClientViewport.HandleInputAxis = ReceivedInputAxis;

		PlayerOwner.PlayerInput = CustomInput;

		if (LastMousePos != default.LastMousePos)
			ClientViewport.SetMouse(LastMousePos.X, LastMousePos.Y);
	}
	else
	{
		LastMousePos = MousePosition;

		ClientViewport.HandleInputAxis = None;

		if (BackupInput != None)
		{
			PlayerOwner.PlayerInput = BackupInput;
			BackupInput.OnReceivedNativeInputKey = OldOnReceivedNativeInputKey;
			BackupInput.OnReceivedNativeInputAxis = OldOnReceivedNativeInputAxis;
			BackupInput.OnReceivedNativeInputChar = OldOnReceivedNativeInputChar;

			ClientViewport.HandleInputAxis = OldHandleInputAxis;
		}
		LastClickTimes[0] = 0;
		LastClickTimes[1] = 0;
	}

	if (!bNoInputReset)
	{
		PlayerOwner.PlayerInput.ResetInput();
	}
}

simulated function NotifyLevelChange()
{
	local int i;

	if (bIsInvalid)
		return;
	bIsInvalid = true;

	if (InputFocus != None)
	{
		InputFocus.LostInputFocus();
		InputFocus = None;
	}

	for (i=(ActiveMenus.Length-1); i >= 0; --i)
		ActiveMenus[i].NotifyLevelChange();
	for (i=(PersistentMenus.Length-1); i >= 0; --i)
		PersistentMenus[i].NotifyLevelChange();

	SetMenuState(false);
}

simulated function MenuInput(float DeltaTime)
{
	local int i;
	local vector2D V;

	if (PlayerOwner.PlayerInput == None)
	{
		NotifyLevelChange();
		return;
	}
	if (InputFocus != None)
		InputFocus.MenuTick(DeltaTime);
	for (i=0; i < ActiveMenus.Length; ++i)
		ActiveMenus[i].MenuTick(DeltaTime);

	// Check idle.
	if (Abs(MousePosition.X-OldMousePos.X) > 5.f || Abs(MousePosition.Y-OldMousePos.Y) > 5.f || (bMouseWasIdle && MousePauseTime < 0.5f))
	{
		if (bMouseWasIdle)
		{
			bMouseWasIdle = false;
			if (InputFocus != None)
				InputFocus.InputMouseMoved();
		}
		OldMousePos = MousePosition;
		MousePauseTime = 0.f;
	}
	else if (!bMouseWasIdle && (MousePauseTime+=DeltaTime) > 0.5f)
	{
		bMouseWasIdle = true;
		if (MouseFocus != None)
			MouseFocus.NotifyMousePaused();
	}

	if (ActiveMenus.Length > 0)
		MenuTime+=DeltaTime;

	V = ClientViewport.GetMousePosition();

	MousePosition.X = Clamp(V.X, 0, ScreenSize.X); 
	MousePosition.Y = Clamp(V.Y, 0, ScreenSize.Y); 

	MouseMove();
}

simulated function MouseMove()
{
	local int i;
	local KFGUI_Base F;

	// Capture mouse for GUI
	if (InputFocus != None && InputFocus.bCanFocus)
	{
		if (InputFocus.CaptureMouse())
		{
			F = InputFocus.GetMouseFocus();
			if (F != MouseFocus)
			{
				MousePauseTime = 0;
				if (MouseFocus != None)
					MouseFocus.MouseLeave();
				MouseFocus = F;
				F.MouseEnter();
			}
		}
		else i = ActiveMenus.Length;
	}
	else
	{
		for (i=0; i < ActiveMenus.Length; ++i)
		{
			if (ActiveMenus[i].CaptureMouse())
			{
				F = ActiveMenus[i].GetMouseFocus();
				if (F != MouseFocus)
				{
					MousePauseTime = 0;
					if (MouseFocus != None)
						MouseFocus.MouseLeave();
					MouseFocus = F;
					F.MouseEnter();
				}
				break;
			}
			else if (ActiveMenus[i].bOnlyThisFocus ) // Discard any other menus after this one.
			{
				i = ActiveMenus.Length;
				break;
			}
		}
	}
	if (MouseFocus != None && i == ActiveMenus.Length ) // Hovering over nothing.
	{
		MousePauseTime = 0;
		if (MouseFocus != None)
			MouseFocus.MouseLeave();
		MouseFocus = None;
	}
}

simulated final function int GetFreeIndex(bool bNewAlwaysTop ) // Find first allowed top index of the stack.
{
	local int i;

	for (i=0; i < ActiveMenus.Length; ++i)
		if (bNewAlwaysTop || !ActiveMenus[i].bAlwaysTop)
		{
			ActiveMenus.Insert(i, 1);
			return i;
		}
	i = ActiveMenus.Length;
	ActiveMenus.Length = i+1;
	return i;
}
simulated function KFGUI_Base InitializeHUDWidget(class<KFGUI_Base> GUIClass)
{
	local KFGUI_Base Widget;

	if (GUIClass == None)
		return None;

	Widget = New(None) GUIClass;

	if (Widget == None)
		return None;

	HUDOwner.HUDWidgets.AddItem(Widget);

	Widget.Owner = Self;
	Widget.HUDOwner = HUDOwner;
	Widget.InitMenu();
	Widget.ShowMenu();
	Widget.bIsHUDWidget = true;

	return Widget;
}
simulated function KFGUI_Page OpenMenu(class<KFGUI_Page> MenuClass)
{
	local int i;
	local KFGUI_Page M;

	if (MenuClass == None)
		return None;

	if (KeyboardFocus != None)
	{
		GrabInputFocus(None);
	}

	if (InputFocus != None)
	{
		InputFocus.LostInputFocus();
		InputFocus = None;
	}

	// Enable mouse on UI if disabled.
	SetMenuState(true);

	// Check if should use pre-excisting menu.
	if (MenuClass.Default.bUnique)
	{
		for (i=0; i < ActiveMenus.Length; ++i)
		{
			if (ActiveMenus[i].Class == MenuClass)
			{
				if (i > 0 && ActiveMenus[i].BringPageToFront() ) // Sort it upfront.
				{
					M = ActiveMenus[i];
					ActiveMenus.Remove(i, 1);
					i = GetFreeIndex(M.bAlwaysTop);
					ActiveMenus[i] = M;
				}
				return M;
			}
		}

		if (MenuClass.Default.bPersistant)
		{
			for (i=0; i < PersistentMenus.Length; ++i)
				if (PersistentMenus[i].Class == MenuClass)
				{
					M = PersistentMenus[i];
					PersistentMenus.Remove(i, 1);
					i = GetFreeIndex(M.bAlwaysTop);
					ActiveMenus[i] = M;
					M.ShowMenu();
					return M;
				}
		}
	}
	M = New(None)MenuClass;

	if (M == None ) // Probably abstract class.
		return None;

	i = GetFreeIndex(M.bAlwaysTop);
	ActiveMenus[i] = M;
	M.Owner = Self;
	M.InitMenu();
	M.ShowMenu();
	return M;
}
simulated function CloseMenu(class<KFGUI_Page> MenuClass, optional bool bCloseAll)
{
	local int i, j;
	local KFGUI_Page M;

	if (!bCloseAll && MenuClass == None)
		return;

	if (KeyboardFocus != None)
		GrabInputFocus(None);
	if (InputFocus != None)
	{
		InputFocus.LostInputFocus();
		InputFocus = None;
	}
	for (i=(ActiveMenus.Length-1); i >= 0; --i)
	{
		if (bCloseAll || ActiveMenus[i].Class == MenuClass)
		{
			M = ActiveMenus[i];
			ActiveMenus.Remove(i, 1);
			M.CloseMenu();

			for (j=0; j < M.TimerNames.Length; j++)
			{
				M.ClearTimer(M.TimerNames[j]);
			}

			// Cache menu.
			if (M.bPersistant && M.bUnique)
				PersistentMenus[PersistentMenus.Length] = M;
		}
	}
	if (ActiveMenus.Length == 0)
	{
		SetMenuState(false);
	}
}
simulated function PopCloseMenu(KFGUI_Base Item)
{
	local int i;
	local KFGUI_Page M;

	if (Item == None)
		return;

	if (Item.bIsHUDWidget)
	{
		HUDOwner.HUDWidgets.RemoveItem(Item);
		Item.CloseMenu();
		return;
	}

	if (KeyboardFocus != None)
		GrabInputFocus(None);
	if (InputFocus != None)
	{
		InputFocus.LostInputFocus();
		InputFocus = None;
	}
	for (i=(ActiveMenus.Length-1); i >= 0; --i)
		if (ActiveMenus[i] == Item)
		{
			M = ActiveMenus[i];
			ActiveMenus.Remove(i, 1);
			M.CloseMenu();

			// Cache menu.
			if (M.bPersistant && M.bUnique)
				PersistentMenus[PersistentMenus.Length] = M;
			break;
		}
	if (ActiveMenus.Length == 0)
		SetMenuState(false);
}
simulated function BringMenuToFront(KFGUI_Page Page)
{
	local int i;

	if (ActiveMenus[0].bAlwaysTop && !Page.bAlwaysTop)
		return; // Can't override this menu.

	// Try to remove from current position at stack.
	for (i=(ActiveMenus.Length-1); i >= 0; --i)
		if (ActiveMenus[i] == Page)
		{
			ActiveMenus.Remove(i, 1);
			break;
		}
	if (i == -1)
		return; // Page isn't open.

	// Put on front of stack.
	ActiveMenus.Insert(0, 1);
	ActiveMenus[0] = Page;
}
simulated final function bool MenuIsOpen(optional class<KFGUI_Page> MenuClass)
{
	local int i;

	for (i=(ActiveMenus.Length-1); i >= 0; --i)
		if (MenuClass == None || ActiveMenus[i].Class == MenuClass)
			return true;
	return false;
}
simulated final function GrabInputFocus(KFGUI_Base Comp, optional bool bForce)
{
	if (Comp == KeyboardFocus && !bForce)
		return;

	if (KeyboardFocus != None)
		KeyboardFocus.LostKeyFocus();

	if (Comp == None)
	{
		OnInputKey = InternalInputKey;
		OnReceivedInputChar = InternalReceivedInputChar;
	}
	else if (KeyboardFocus == None)
	{
		OnInputKey = Comp.NotifyInputKey;
		OnReceivedInputChar = Comp.NotifyInputChar;
		OnReceivedInputAxis = Comp.NotifyInputAxis;
	}
	KeyboardFocus = Comp;
}

simulated final function GUI_InputMouse(bool bPressed, bool bRight)
{
	local byte i;

	MousePauseTime = 0;

	if (bPressed)
	{
		if (KeyboardFocus != None && KeyboardFocus != MouseFocus)
		{
			GrabInputFocus(None);
			LastClickTimes[0] = 0;
			LastClickTimes[1] = 0;
		}
		if (MouseFocus != None)
		{
			if (MouseFocus != InputFocus && !MouseFocus.bClickable && !MouseFocus.IsTopMenu() && MouseFocus.BringPageToFront())
			{
				BringMenuToFront(MouseFocus.GetPageTop());
				LastClickTimes[0] = 0;
				LastClickTimes[1] = 0;
			}
			else
			{
				i = byte(bRight);
				if ((MenuTime-LastClickTimes[i]) < 0.2 && Abs(LastClickPos[i].X-MousePosition.X) < 5 && Abs(LastClickPos[i].Y-MousePosition.Y) < 5)
				{
					LastClickTimes[i] = 0;
					MouseFocus.DoubleMouseClick(bRight);
				}
				else
				{
					MouseFocus.MouseClick(bRight);
					LastClickTimes[i] = MenuTime;
					LastClickPos[i] = MousePosition;
				}
			}
		}
		else if (InputFocus != None)
		{
			InputFocus.LostInputFocus();
			InputFocus = None;
			LastClickTimes[0] = 0;
			LastClickTimes[1] = 0;
		}
	}
	else
	{
		if (InputFocus != None)
			InputFocus.MouseRelease(bRight);
		else if (MouseFocus != None)
			MouseFocus.MouseRelease(bRight);
	}
}
simulated final function bool CheckMouse(name Key, EInputEvent Event)
{
	if (Event == IE_Pressed)
	{
		switch (Key)
		{
		case 'XboxTypeS_A':
		case 'LeftMouseButton':
			GUI_InputMouse(true, false);
			return true;
		case 'XboxTypeS_B':
		case 'RightMouseButton':
			GUI_InputMouse(true, true);
			return true;
		}
	}
	else if (Event == IE_Released)
	{
		switch (Key)
		{
		case 'XboxTypeS_A':
		case 'LeftMouseButton':
			GUI_InputMouse(false, false);
			return true;
		case 'XboxTypeS_B':
		case 'RightMouseButton':
			GUI_InputMouse(false, true);
			return true;
		}
	}
	return false;
}
simulated function bool ReceivedInputKey(int ControllerId, name Key, EInputEvent Event, optional float AmountDepressed=1.f, optional bool bGamepad)
{
	local KFPlayerInput KFInput;
	local KeyBind BoundKey;

	if (!bIsInMenuState)
		return false;

	bUsingGamepad = bGamepad;

	KFInput = KFPlayerInput(BackupInput);
	if (KFInput == None)
	{
		KFInput = KFPlayerInput(PlayerOwner.PlayerInput);
	}

	if (KeyboardFocus == None)
	{
		if (KFInput != None)
		{	
			KFInput.GetKeyBindFromCommand(BoundKey, "GBA_VoiceChat", false);	
			if (string(Key) ~= KFInput.GetBindDisplayName(BoundKey))
			{
				if (Event == IE_Pressed)
				{
					KFInput.StartVoiceChat(true);
				}
				else if (Event == IE_Released)
				{
					KFInput.StopVoiceChat();
				}

				return true;
			}
		}
	}

	if (!CheckMouse(Key, Event) && !OnInputKey(ControllerId, Key, Event, AmountDepressed, bGamepad))
	{
		if (bGamepad)
		{
			if (ActiveMenus[0].ReceievedControllerInput(ControllerId, Key, Event))
				return true;
		}

		switch (Key)
		{
		case 'XboxTypeS_Start':
		case 'Escape':
			if (Event == IE_Pressed)
				ActiveMenus[0].UserPressedEsc(); // Pop top menu if possible. // IE_Released
			return true;
		case 'XboxTypeS_DPad_Up':
		case 'XboxTypeS_DPad_Down':
		case 'XboxTypeS_DPad_Left':
		case 'XboxTypeS_DPad_Right':
		case 'MouseScrollDown':
		case 'MouseScrollUp':
			if (Event == IE_Pressed && MouseFocus != None)
				MouseFocus.ScrollMouseWheel(Key == 'MouseScrollUp' || Key == 'XboxTypeS_DPad_Up' || Key == 'XboxTypeS_DPad_Left');
			return true;
		}

		//	Related to Console
		if(bForceConsoleInput)
        {
            ClientViewport.ViewportConsole.OnReceivedNativeInputKey(ControllerId, Key, Event, AmountDepressed, bGamepad);
            return true;
        }
        else
        {
            if(Key == ClientViewport.ViewportConsole.ConsoleKey && !ClientViewport.ViewportConsole.bCaptureKeyInput && Event == 0)
            {
                class'WorldInfo'.static.GetWorldInfo().TimerHelper.SetTimer(0.03750, false, 'EnableCaptureInput', ClientViewport.ViewportConsole);
                return true;
            }
        }
		return bAbsorbInput;
	}

	return true;
}

simulated function bool ReceivedInputAxis(int ControllerId, name Key, float Delta, float DeltaTime, bool bGamepad)
{
	local Vector2D V;
	local KFPlayerInput KFInput;
	local float GamepadSensitivity, OldMouseX, OldMouseY, MoveDelta, MoveDeltaInvert;

	if (!bIsInMenuState)
		return false;

	if(bForceConsoleInput && ClientViewport.ViewportConsole.OnReceivedNativeInputAxis(ControllerId, Key, Delta, DeltaTime, bGamepad))
    {
        return true;
    }

	if (bGamepad)
	{
		if (Abs(Delta) > 0.2f)
		{
			bUsingGamepad = true;

			V = ClientViewport.GetMousePosition();
			OldMouseX = V.X;
			OldMouseY = V.Y;

			KFInput = KFPlayerInput(BackupInput);
			GamepadSensitivity = KFInput.GamepadSensitivityScale * 10;
			MoveDelta = Delta * (KFInput.bInvertController ? -GamepadSensitivity : GamepadSensitivity);
			MoveDeltaInvert = Delta * (KFInput.bInvertController ? GamepadSensitivity : -GamepadSensitivity);

			switch (Key)
			{
				case 'XboxTypeS_LeftX':
				case 'XboxTypeS_RightX':
					if (Delta < 0)
						V.X = Clamp(V.X - MoveDeltaInvert, 0, ScreenSize.X);
					else V.X = Clamp(V.X + MoveDelta, 0, ScreenSize.X);
					break;
				case 'XboxTypeS_LeftY':
					if (Delta < 0)
						V.Y = Clamp(V.Y + MoveDeltaInvert, 0, ScreenSize.Y);
					else V.Y = Clamp(V.Y - MoveDelta, 0, ScreenSize.Y);
					break;
				case 'XboxTypeS_RightY':
					if (Delta < 0)
						V.Y = Clamp(V.Y - MoveDeltaInvert, 0, ScreenSize.Y);
					else V.Y = Clamp(V.Y + MoveDelta, 0, ScreenSize.Y);
					break;
			}

			if (OldMouseX != V.X || OldMouseY != V.Y)
				ClientViewport.SetMouse(V.X, V.Y);
		}
	}
	return OnReceivedInputAxis(ControllerId, Key, Delta, DeltaTime, bGamepad);
}
simulated function bool ReceivedInputChar(int ControllerId, string Unicode)
{
	if (!bIsInMenuState)
		return false;

	if(bForceConsoleInput && ClientViewport.ViewportConsole.OnReceivedNativeInputChar(ControllerId, Unicode))
    {
        return true;
    }

	return OnReceivedInputChar(ControllerId, Unicode);
}

simulated Delegate bool OnInputKey(int ControllerId, name Key, EInputEvent Event, optional float AmountDepressed=1.f, optional bool bGamepad)
{
	return false;
}
simulated Delegate bool OnReceivedInputAxis(int ControllerId, name Key, float Delta, float DeltaTime, bool bGamepad)
{
	return false;
}
simulated Delegate bool OnReceivedInputChar(int ControllerId, string Unicode)
{
	return false;
}
simulated Delegate bool InternalInputKey(int ControllerId, name Key, EInputEvent Event, optional float AmountDepressed=1.f, optional bool bGamepad)
{
	return false;
}
simulated Delegate bool InternalReceivedInputChar(int ControllerId, string Unicode)
{
	return false;
}

defaultproperties
{
	CursorSize=24
	CursorColor=(R=255, G=255, B=255, A=255)
	CursorTextures[`CURSOR_DEFAULT]=Texture2D'UI_Managers.LoaderManager_SWF_I13'
	CurrentCursorIndex=`CURSOR_DEFAULT

	DefaultStyle=class'ClassicStyle'
	bAbsorbInput=true
	bAlwaysTick=true
	bHideCursor=true
}