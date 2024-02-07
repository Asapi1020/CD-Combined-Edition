class CustomGFxHUDWrapper extends KFGFxHudWrapper;

`include(Build.uci)
`include(Logger.uci)

const HUDBorderSize = 3;

var float ScaledBorderSize;
var array<KFGUI_Base> HUDWidgets;

var transient KF2GUIController GUIController;
var transient GUIStyleBase GUIStyle;

var Vector2D NoContainerLoc;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	PlayerOwner.PlayerInput.OnReceivedNativeInputKey = NotifyInputKey;
	PlayerOwner.PlayerInput.OnReceivedNativeInputAxis = NotifyInputAxis;
	PlayerOwner.PlayerInput.OnReceivedNativeInputChar = NotifyInputChar;

	RemoveMovies();
	CreateHUDMovie();

	KFPlayerOwner = KFPlayerController(Owner);
}

function PostRender()
{
	if (KFGRI == None)
		KFGRI = KFGameReplicationInfo(WorldInfo.GRI);

	if (GUIController != None && PlayerOwner.PlayerInput == None)
		GUIController.NotifyLevelChange();

	if (GUIController == None || GUIController.bIsInvalid)
	{
		GUIController = Class'CustomHUD.KF2GUIController'.Static.GetGUIController(PlayerOwner);
		if (GUIController != None)
		{
			GUIStyle = GUIController.CurrentStyle;
			GUIStyle.HUDOwner = self;
			LaunchHUDMenus();
		}
	}
	GUIStyle.Canvas = Canvas;
	GUIStyle.PickDefaultFontSize(Canvas.ClipY);

	if (!GUIController.bIsInMenuState)
		GUIController.HandleDrawMenu();

	ScaledBorderSize = FMax(GUIStyle.ScreenScale(HUDBorderSize), 1.f);

	Super.PostRender();
}

function LaunchHUDMenus(){ return; }

function bool NotifyInputKey(int ControllerId, Name Key, EInputEvent Event, float AmountDepressed, bool bGamepad)
{
	local int i;

	for (i=(HUDWidgets.Length-1); i >= 0; --i)
	{
		if (HUDWidgets[i].bVisible && HUDWidgets[i].NotifyInputKey(ControllerId, Key, Event, AmountDepressed, bGamepad))
			return true;
	}

	return false;
}

function bool NotifyInputAxis(int ControllerId, name Key, float Delta, float DeltaTime, optional bool bGamepad)
{
	local int i;

	for (i=(HUDWidgets.Length-1); i >= 0; --i)
	{
		if (HUDWidgets[i].bVisible && HUDWidgets[i].NotifyInputAxis(ControllerId, Key, Delta, DeltaTime, bGamepad))
			return true;
	}

	return false;
}

function bool NotifyInputChar(int ControllerId, string Unicode)
{
	local int i;

	for (i=(HUDWidgets.Length-1); i >= 0; --i)
	{
		if (HUDWidgets[i].bVisible && HUDWidgets[i].NotifyInputChar(ControllerId, Unicode))
			return true;
	}

	return false;
}


/******* Draw *******/

function DrawContainer(string title, string body, float X, float Y)
{
	local float XL, YL, Sc, W, W1, H, Edge;
	local int i;
	local array<string> splitbuf;

    Edge = 5;

	Canvas.Font = GUIStyle.PickFont(Sc);
    Canvas.TextSize(title, W, YL, Sc, Sc);

	Sc *= 0.9;
    ParseStringIntoArray(body, splitbuf, "\n", true);
	for (i=0; i<splitbuf.length; i++)
	{
		Canvas.TextSize(splitbuf[i], XL, YL, Sc, Sc);
		W = Max(W, XL);
	}

    X -= YL * 0.5;
    Y -= YL * 0.5;
    W1 = YL * 0.5;
    W += YL + W1;
    H = YL * 1.5;
	Canvas.SetDrawColor(21, 31, 31, 250);
	GUIStyle.DrawRectBox(X, Y, W, H, Edge, 150);
	Canvas.SetDrawColor(250, 250, 250, 255);
	GUIStyle.DrawTextShadow(title, X + W1*2, Y ,1, Sc/0.9);

	Y += H;
	H = YL * (float(i)+0.5);
	Canvas.SetDrawColor(21, 31, 31, 250);
	GUIStyle.DrawRectBox(X, Y, W1, H, Edge, 151);
	Canvas.SetDrawColor(0, 0, 0, 180);
	X += W1;
	W -= W1;
	GUIStyle.DrawRectBox(X, Y, W, H, Edge, 0);
	Canvas.SetDrawColor(250, 250, 250, 255);
	GUIStyle.DrawTextShadow(body, X + W1, Y ,1, Sc);
}

function DrawExtraContainer(string title, string body)
{
	DrawContainer(title, body, Canvas.ClipX * default.NoContainerLoc.X, Canvas.ClipY * default.NoContainerLoc.Y);
}

function DrawTitledInfoBox(string title, string body, float Sc, float XL, float YL, float X, float Yb, int LineNum)
{
	local float Y, a, h, w;

	a = YL/2;
	h = YL*(LineNum+1);
	Y = Yb - h;

	Canvas.SetDrawColor(0, 0, 0, 250);
	GUIStyle.DrawRectBox(X-a, Y-a, XL+YL, h, 8.f, 152);
	Canvas.SetDrawColor(250, 250, 250, 255);
	GUIStyle.DrawTextShadow(body, X, Y, 1, Sc);

	Canvas.TextSize(title, w, YL, Sc, Sc);
	h = YL + ScaledBorderSize*2;
	Y -= (h+a-ScaledBorderSize);
	Canvas.SetDrawColor(75, 0, 0, 200);
	GUIStyle.DrawRectBox(X-a, Y-ScaledBorderSize, XL+YL, h, 8.f, 0);
	Canvas.SetDrawColor(250, 250, 250, 255);
	GUIStyle.DrawTextShadow(title, X + (XL-w)/2, Y, 1, Sc);	
}

defaultproperties
{
	NoContainerLoc=(X=0.023, Y=0.36)
}