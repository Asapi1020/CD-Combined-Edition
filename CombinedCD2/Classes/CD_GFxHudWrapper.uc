class CD_GFxHudWrapper extends CustomGFxHudWrapper;

var class<KFScoreBoard> ScoreboardClass;
var KFScoreBoard Scoreboard;

var transient OnlineSubsystem OnlineSub;
var transient array<byte> WasNewlyAdded;
var transient array<string> NewItems;
var transient bool bLoadedInitItems;

var class<xUI_Console> ConsoleClass;
var transient GameViewportClient ClientViewport;
var transient Console OrgConsole;
var transient xUI_Console NewConsole;

var CD_PlayerController CDPC;
var CD_GameReplicationInfo CDGRI;
var CD_DroppedPickup WeaponPickup;

var const FontRenderInfo MyFontRenderInfo;
var const Texture2D BackgroundTexture;
var const Texture2D WeaponAmmoIcon, WeaponWeightIcon;
var const float MaxWeaponPickupDist;
var const float WeaponPickupScanRadius;
var const float ZedScanRadius;
var const float WeaponIconSize;
var const float WeaponFontScale;
var const color WeaponIconColor,WeaponOverweightIconColor;

var Vector2D WaveInfoLoc, WaveInfoSize;
var float TextScale;

var string MyStats;
var float ReceivedTime;
var int VoteLeftTime;

var localized string ItemDropPrefix;
var localized string WaveInfoBasic;
var localized string WaveInfoTrader;
var localized string WaveInfoBoss;
var localized string CDSettingsString;
var localized string SpectatorsString;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();	

	CDPC = CD_PlayerController(Owner);
	SetupCDGRI();

	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if (OnlineSub!=None)
	{
		OnlineSub.AddOnInventoryReadCompleteDelegate(SearchInventoryForNewItem);
		SetTimer(60,false,'SearchInventoryForNewItem');
	}
	
	SetTimer(240.f,false,'CheckForItems');
	SetTimer(0.1, true, 'CheckForWeaponPickup');
}

function SetupCDGRI()
{
	CDGRI = CD_GameReplicationInfo(CDPC.WorldInfo.GRI);
	
	if(CDGRI == none)
	{
		SetTimer(1.f, false, 'SetupCDGRI');
	}
}

function bool MainMenuIsOpen()
{
	return CDPC != none && CDPC.MyGfxManager != none && CDPC.MyGFxManager.bMenusOpen && CDPC.MyGFxManager.bMenusActive && KFGFxMenu_Trader(CDPC.MyGFxManager.CurrentMenu) == None;
}

function PostRender()
{
	if(CDPC != none && CDGRI != none)
	{
		if(CDPC.bShowVolumes)
			DrawVolumesNumber();

		if(CDPC.bShowPathNodes)
			DrawPathsNumber();

		if( !CDPC.bCinematicMode && WeaponPickup != none && CDGRI.bTraderIsOpen )
			DrawWeaponPickupInfo(WeaponPickup, CDPC.Pawn);

		if(MainMenuIsOpen())
		{
			if(CD_GFxMenu_StartGame(CDPC.MyGFxManager.CurrentMenu) != none)
			{
				DrawCDSettings();
				DrawSpectatorsInfo();
			}

			if(CDGRI.bMatchHasBegun && !CDGRI.bMatchIsOver && !CDGRI.bRoundIsOver && CDPC.PlayerReplicationInfo.bWaitingPlayer)
			{
				DrawWaveInfo();
			}
		}

		else if (!CDPC.PlayerReplicationInfo.bWaitingPlayer)
		{
			if(!CDGRI.bWaveIsActive && CDPC.WaveEndStats && MyStats != "")
			{
				DrawExtraContainer(class'KFGame.KFGFxMenu_PostGameReport'.default.PlayerStatsString, MyStats);
			}
			DrawVoteLeftTime();
		}
	}

	Super.PostRender();
}

function LaunchHUDMenus()
{
	Scoreboard = KFScoreBoard(GUIController.InitializeHUDWidget(ScoreboardClass));
	Scoreboard.SetVisibility(false);

	InitializeHUD();
}

function InitializeHUD()
{
    if(KFPlayerOwner == none || KFPlayerOwner.PlayerReplicationInfo == none || KFPlayerOwner.MyGFxManager == none || HudMovie == none)
    {
        if(KFPlayerOwner.PlayerReplicationInfo.bOnlySpectator && (KFPlayerOwner.MyGFxManager.PartyWidget == none || KFPlayerOwner.MyGFxManager.PartyWidget.PartyChatWidget == none))
        {
        	KFPlayerOwner.MyGFxManager.ToggleMenus();
        }
        SetTimer(1.0, false, 'InitializeHUD');
        return;
    }

    ClientViewport = LocalPlayer(PlayerOwner.Player).ViewportClient;
    
    if(ClientViewport != none)
    {
    	CreateAndSetConsoleReplacment();
    }
}

final function CreateAndSetConsoleReplacment()
{
    if(ConsoleClass == none)
   		return;
    
    if(NewConsole == none)
    {
        NewConsole = new (ClientViewport) ConsoleClass;
        NewConsole.Initialized();
        OrgConsole = ClientViewport.ViewportConsole;
    }
    OrgConsole.__OnReceivedNativeInputKey__Delegate = NewConsole.InputKey;
    OrgConsole.__OnReceivedNativeInputChar__Delegate = NewConsole.InputChar;
    ClientViewport.ViewportConsole = NewConsole;   
}

exec function SetShowScores(bool bNewValue)
{
	if (Scoreboard != None)
		Scoreboard.SetVisibility(bNewValue);
	else Super.SetShowScores(bNewValue);
}

/* ====================================================================
	 Item Drop during a match
	==================================================================== */


simulated function Destroyed()
{
	Super.Destroyed();
	ResetConsole();
	if(GUIController != none)
	{
		GUIController.Destroy();
	}

	NotifyLevelChange();
}

final function ResetConsole()
{
    if(OrgConsole == none || ClientViewport.ViewportConsole == OrgConsole)
    {
        return;
    }
    ClientViewport.ViewportConsole = OrgConsole;
    OrgConsole.__OnReceivedNativeInputKey__Delegate = OrgConsole.InputKey;
    OrgConsole.__OnReceivedNativeInputChar__Delegate = OrgConsole.InputChar;  
}

simulated final function NotifyLevelChange()
{
	if (OnlineSub!=None)
	{
		OnlineSub.ClearOnInventoryReadCompleteDelegate(SearchInventoryForNewItem);
		OnlineSub = None;
	}
}

simulated function SearchInventoryForNewItem()
{
	local int i,j;

	if (WasNewlyAdded.Length!=OnlineSub.CurrentInventory.Length)
		WasNewlyAdded.Length = OnlineSub.CurrentInventory.Length;
	for (i=0; i<OnlineSub.CurrentInventory.Length; ++i)
	{
		if (OnlineSub.CurrentInventory[i].NewlyAdded==1 && WasNewlyAdded[i]==0)
		{
			WasNewlyAdded[i] = 1;
			if (WorldInfo.TimeSeconds<80.f || !bLoadedInitItems) // Skip initial inventory.
				continue;
			j = OnlineSub.ItemPropertiesList.Find('Definition', OnlineSub.CurrentInventory[i].Definition);

			if (j != INDEX_NONE)
			{
				NewItems.Insert(0,1);
				NewItems[0] = OnlineSub.ItemPropertiesList[j].Name;
				CD_PlayerController(Owner).TeamMessage(none, ItemDropPrefix @ NewItems[0], 'System');
			}
		}
	}
	bLoadedInitItems = true;
}

simulated function CheckForItems()
{
	if (CD_PlayerController(Owner).DropItem && CDGRI!=none)
		CDGRI.ProcessChanceDrop();
	SetTimer(240.f,false,'CheckForItems');
}

/* ====================================================================
	 Additional Render System
	==================================================================== */

function DrawVolumesNumber()
{
	local KFSpawnVolume KFSV;

	foreach WorldInfo.AllActors(Class'KFSpawnVolume', KFSV)
	{
		DrawActorNumber(KFSV);
	}
}

function DrawPathsNumber()
{
	local KFPathnode N;
	
	ForEach AllActors( class 'KFPathnode', N )
	{
		DrawActorNumber(N);
	}
}

function DrawActorNumber(Actor A)
{
	local vector ScreenPos;
	local float Sc, Hight, Width, MarginX, MarginY;
	local string S;
	local Canvas C;

	C = Canvas;
	ScreenPos = C.Project(A.Location);

	if(ScreenPos.X < 0 || ScreenPos.X > C.ClipX || ScreenPos.Y < 0 || ScreenPos.Y > C.ClipY)
		return;
	if(VSize(A.Location - KFPlayerController(Owner).Pawn.Location) > 600)
		return;

	if(KFPathNode(A) != none && (A.Location - KFPlayerController(Owner).Pawn.Location).Z > 100)
		return;

	S = string(A.name);

	C.Font = GUIStyle.PickFont(Sc);
	C.TextSize(S, Width, Hight, Sc, Sc);
	C.SetDrawColor(10, 10, 10, 200);
	MarginX = Width * 0.125 * 0.5;
	MarginY = Hight * 0.125 * 0.5;
	Width *= 1.125;
	Hight *= 1.125;
	GUIStyle.DrawRectBox(ScreenPos.X - MarginX, ScreenPos.Y - MarginY, Width, Hight, 8.f, 0);
	C.SetDrawColor(255, 255, 255, 255);
	DrawTextShadowHVCenter(S, ScreenPos.X - MarginX, ScreenPos.Y - MarginY, Width, Sc);
}

function DrawTextShadowHVCenter(string Str, float XPos, float YPos, float BoxWidth, float FontScalar)
{
	local float TextWidth;
	local float TextHeight;

	Canvas.TextSize(Str, TextWidth, TextHeight, FontScalar, FontScalar);

	GUIStyle.DrawTextShadow(Str, XPos + (BoxWidth - TextWidth)/2 , YPos, 1, FontScalar);
}

/* ====================================================================
	 Weapon Pickup
	==================================================================== */

	// ToDo: Lots of wastes are remaining. should deleted

function DrawWeaponPickupInfo(CD_DroppedPickup CDDP, Pawn P)
{
	local vector ScreenPos;
	local bool bHasAmmo, bCanCarry;
	local Inventory Inv;
	local KFInventoryManager KFIM;
	local string AmmoText, WeightText;
	local class<KFWeapon> KFWC;
	local color CanCarryColor;
	local float FontScale, ResModifier, IconSize;
	local float AmmoTextWidth, WeightTextWidth, TextWidth, TextHeight, TextYOffset;
	local float InfoBaseX, InfoBaseY;
	local float BGX, BGY, BGWidth, BGHeight;
	local float WeaponTextBGX, WeaponTextBGY;
	local Canvas C;

	C = Canvas;

	// Lift this a bit off of the ground
	ScreenPos = C.Project(CDDP.Location + vect(0,0,25));
	if (ScreenPos.X < 0 || ScreenPos.X > C.ClipX || ScreenPos.Y < 0 || ScreenPos.Y > C.ClipY)
		return;
		
	bHasAmmo = CDDP.MagazineAmmo[0] >= 0;

	AmmoText = CDDP.GetAmmoText();
	WeightText = CDDP.GetWeightText(P);

	// This is only set to false on living
	// players who cannot pick up the weapon
	if (P != None && KFInventoryManager(P.InvManager) != None)
	{
		KFIM = KFInventoryManager(P.InvManager);
		KFWC = class<KFWeapon>(CDDP.InventoryClass);
		if (KFIM.CanCarryWeapon(KFWC, CDDP.UpgradeLevel))
		{
			if (KFWC.default.DualClass != None)
				bCanCarry = !KFIM.ClassIsInInventory(KFWC.default.DualClass, Inv);
			else
				bCanCarry = !KFIM.ClassIsInInventory(KFWC, Inv);
		}
	}
	else
		bCanCarry = true;

	CanCarryColor = (bCanCarry ? WeaponIconColor : WeaponOverweightIconColor);

	// TODO?: Check for scaling, maybe make WeaponFontScale configurable
	ResModifier = CDDP.WorldInfo.static.GetResolutionBasedHUDScale();
	FontScale = class'KFGame.KFGameEngine'.static.GetKFFontScale() * WeaponFontScale;
	C.Font = class'KFGame.KFGameEngine'.static.GetKFCanvasFont();
	// We don't draw the ammo text or icon if it's not relevant, so check this
	if (bHasAmmo)
	{
		// Grab the wider of the two strings
		// Text height should be the same for both
		C.TextSize(AmmoText, AmmoTextWidth, TextHeight, FontScale, FontScale);
		C.TextSize(WeightText, WeightTextWidth, TextHeight, FontScale, FontScale);
		TextWidth = FMax(AmmoTextWidth, WeightTextWidth);
	}
	else
		C.TextSize(WeightText, TextWidth, TextHeight, FontScale, FontScale);

	IconSize = WeaponIconSize * WeaponFontScale * ResModifier;
	InfoBaseX = ScreenPos.X - ((IconSize * 1.5 + TextWidth) * 0.5);
	InfoBaseY = ScreenPos.Y;
	TextYOffset = (IconSize - TextHeight) * 0.5;

	// Setup the background
	BGWidth = IconSize * 2.0 + TextWidth;
	BGX = InfoBaseX - (IconSize * 0.25);
	if (bHasAmmo)
	{
		BGHeight = (IconSize * 2.5) * 1.25;
		BGY = InfoBaseY - (BGHeight * 0.125);
	}
	else
	{
		BGHeight = IconSize * 1.5;
		BGY = InfoBaseY + IconSize * 1.5 - (BGHeight * 0.125);
	}

	C.EnableStencilTest(true);

	// Background
	C.DrawColor = class'KFGame.KFHUDBase'.default.PlayerBarBGColor;
	C.SetPos(BGX, BGY);
	C.DrawTile(BackgroundTexture, BGWidth, BGHeight, 0, 0, 32, 32);

	// We only draw ammo if it's relevant
	if (bHasAmmo)
	{
		// Ammo icon
		C.DrawColor = WeaponIconColor;
		C.SetPos(InfoBaseX, InfoBaseY);
		C.DrawTile(WeaponAmmoIcon, IconSize, IconSize, 0, 0, 256, 256);
	
		// Ammo text
		C.SetPos(InfoBaseX + IconSize * 1.5, InfoBaseY + TextYOffset);
		C.DrawText(AmmoText, , FontScale, FontScale, MyFontRenderInfo);
	}

	// Weight icon
	C.DrawColor = CanCarryColor;
	C.SetPos(InfoBaseX, InfoBaseY + IconSize * 1.5);
	C.DrawTile(WeaponWeightIcon, IconSize, IconSize, 0, 0, 256, 256);

	// Weight (and upgrade level if applicable) text
	C.SetPos(InfoBaseX + IconSize * 1.5, InfoBaseY + IconSize * 1.5 + TextYOffset);
	C.DrawText(WeightText, , FontScale, FontScale, MyFontRenderInfo);
	
	// Weapon name
	if (CDDP.InventoryClass.default.ItemName != "")
	{
		C.TextSize(CDDP.InventoryClass.default.ItemName, TextWidth, TextHeight, FontScale, FontScale);
		
		WeaponTextBGX = ScreenPos.X - (TextWidth * 0.5625);
		WeaponTextBGY = BGY - TextHeight * 1.25;

		C.DrawColor = class'KFGame.KFHUDBase'.default.PlayerBarBGColor;
		C.SetPos(WeaponTextBGX, WeaponTextBGY);
		C.DrawTile(BackgroundTexture, TextWidth * 1.125, TextHeight * 1.125, 0, 0, 32, 32);
	
		C.DrawColor = WeaponIconColor;
		C.SetPos(WeaponTextBGX + TextWidth * 0.0625, WeaponTextBGY + TextHeight * 0.0625);
		C.DrawText(CDDP.InventoryClass.default.ItemName, , FontScale, FontScale, MyFontRenderInfo);
	}

	// Owner's name
	if (CDDP.OriginalOwnerPlayerName != "")
	{
		C.TextSize(CDDP.OriginalOwnerPlayerName, TextWidth, TextHeight, FontScale, FontScale);
	
		BGX += (BGWidth * 0.5 - TextWidth * 0.5625);
		BGY += (BGHeight + TextHeight * 0.25);
		BGWidth = TextWidth * 1.125;
		BGHeight = TextHeight * 1.125;
	
		C.DrawColor = class'KFGame.KFHUDBase'.default.PlayerBarBGColor;
		C.SetPos(BGX, BGY);
		C.DrawTile(BackgroundTexture, BGWidth, BGHeight, 0, 0, 32, 32);
	
		C.DrawColor = WeaponIconColor;
		C.SetPos(BGX + TextWidth * 0.0625, BGY + TextHeight * 0.0625);
		C.DrawText(CDDP.OriginalOwnerPlayerName, , FontScale, FontScale, MyFontRenderInfo);
	}

	C.EnableStencilTest(false);
}


function CheckForWeaponPickup()
{
	local CD_DroppedPickup CDDP, BestCDDP;
	local int CDDPCount, ZedCount;
	local vector StartTrace, EndTrace, HitLocation, HitNormal;
	local rotator AimRot;
	local Actor HitActor;
	local float DistSq, BestDistSq;
	local KFPawn_Monster KFPM;

	if (CDPC == None || CDGRI == None || !CDGRI.bMatchHasBegun)
	{
		WeaponPickup = None;
		return;
	}

	CDPC.GetPlayerViewPoint(StartTrace, AimRot);
	EndTrace = StartTrace + vector(AimRot) * MaxWeaponPickupDist;
	
	HitActor = Trace(HitLocation, HitNormal, EndTrace, StartTrace);
	
	if (HitActor == None)
	{
		WeaponPickup = None;
		return;
	}
		
	// Check for living zeds in small radius
	// This prevents pickup info from blocking
	// sightlines to certain zeds (e.g. Crawlers)
	foreach CollidingActors(class'KFGame.KFPawn_Monster', KFPM, ZedScanRadius, HitLocation)
	{
		if (KFPM.IsAliveAndWell())
		{
			WeaponPickup = None;
			return;
		}

		// We limit this to 20 zeds for time reasons
		// This usually won't happen, but better safe than sorry
		ZedCount++;
		if (ZedCount > 20)
		{
			WeaponPickup = None;
			return;
		}
	}

	BestDistSq = WeaponPickupScanRadius * WeaponPickupScanRadius;

	// Check for dropped pickups in small radius
	foreach CollidingActors(class'CombinedCD2.CD_DroppedPickup', CDDP, WeaponPickupScanRadius, HitLocation)
	{
		if (CDDP.Velocity.Z == 0)
		{
			// We get the weapon closest to HitLocation
			DistSq = VSizeSq(CDDP.Location - HitLocation);
			if (DistSq < BestDistSq)
			{
				BestCDDP = CDDP;
				BestDistSq = DistSq;
			}
		}

		CDDPCount++;
		// We limit this to only 3 total KFDroppedPickup_UM
		// to limit potential time cost in case a bunch of
		// dropped pickups are dropped in one place
		// This usually won't happen, but better safe than sorry
		if (CDDPCount > 2)
			break;
	}

	WeaponPickup = BestCDDP;
}

/* ====================================================================
	 Wave Info
	==================================================================== */

function DrawWaveInfo()
{
	local float RX, RY;
	local string WaveInfoText;
	local FontRenderInfo FRI;
	local float FontScale, TextWidth, TextHeight, TextOffsetY;
	local Canvas C;

	C = Canvas;

	RX = Canvas.SizeX / 1920.0;
	RY = Canvas.SizeY / 1080.0;

	WaveInfoLoc.X = default.WaveInfoLoc.X * RX;
	WaveInfoLoc.Y = default.WaveInfoLoc.Y * RY;
	WaveInfoSize.X = default.WaveInfoSize.X * RX;
	WaveInfoSize.Y = default.WaveInfoSize.Y * RY;

	if(KFGRI == none) KFGRI = KFGameReplicationInfo(CDPC.WorldInfo.GRI);
	WaveInfoText = "(" $ KFGRI.WaveNum $ "/" $ KFGRI.GetFinalWaveNum() $ ")";
		
	if (KFGRI.bTraderIsOpen)
	{
		WaveInfoText @= (WaveInfoTrader @ GetTimeString(KFGRI.GetTraderTimeRemaining()));
	}
	else
	{
		// Check if this is an endless objective wave
		if (KFGRI.IsBossWave())
			WaveInfoText @= WaveInfoBoss;
		else
			WaveInfoText @= (WaveInfoBasic @ KFGRI.AIRemaining);
	}
	
	// Setup the font and scaling
	FRI = C.CreateFontRenderInfo(true);
	FontScale = class'KFGame.KFGameEngine'.static.GetKFFontScale() * TextScale;
	C.Font = class'KFGame.KFGameEngine'.static.GetKFCanvasFont();
	C.TextSize(WaveInfoText, TextWidth, TextHeight, FontScale, FontScale);
	TextOffsetY = (WaveInfoSize.Y - TextHeight) * 0.5;

	// Draw the info box
	C.SetDrawColor(0, 0, 0, 255);
	C.SetPos(WaveInfoLoc.X, WaveInfoLoc.Y);
	C.DrawTile(Texture2D'EngineResources.WhiteSquareTexture', WaveInfoSize.X, WaveInfoSize.Y, 0, 0, 32, 32);
	
	// And the text
	C.SetDrawColor(255, 255, 255, 255);
	C.SetPos(WaveInfoLoc.X + (0.04 * WaveInfoSize.X), WaveInfoLoc.Y + TextOffsetY);
	C.DrawText(WaveInfoText, , FontScale, FontScale, FRI);
}

function string GetTimeString(int TotalSeconds)
{
	local int Minutes, Seconds;
	
	Minutes = TotalSeconds / 60;
	Seconds = TotalSeconds % 60;
	
	if (Seconds >= 10)
		return (Minutes $ ":" $ Seconds);
	
	return (Minutes $ ":0" $ Seconds);
}

/* ====================================================================
	 Special HUD
	==================================================================== */

function DrawVoteLeftTime()
{
	local float Sc, XL, YL, X, Y;
	local int time;
	local string s;

	if(VoteLeftTime >= 0)
	{
		Canvas.Font = GUIStyle.PickFont(Sc);
		
		if(VoteLeftTime >= 60)
		{
			s = "1:";
			time = VoteLeftTime - 60;
		}
		else
		{
			s = "0:";
			time = VoteLeftTime;
		}

		if(time<10)
			s $= "0";

		s $= string(time);

		Canvas.TextSize(class'KFGame.KFGFxMenu_PostGameReport'.default.NextMapString, XL, YL, Sc, Sc);
		X = Canvas.ClipX * 0.5 - XL;
		Y = Canvas.ClipY * 0.0150;
		Canvas.SetDrawColor(10, 10, 10, 250);
		GUIStyle.DrawRectBox(X - (YL/2), Y - (YL/2), 2*XL, YL*2, 8.f, 0);
		Canvas.SetDrawColor(250, 0, 0, 255);
		GUIStyle.DrawTextShadow(class'KFGame.KFGFxMenu_PostGameReport'.default.NextMapString @ s, X, Y, 1, Sc);
	}
}

function DrawCDSettings()
{
	local float Sc, XL, YL, X, Y;
	local string s;

	if(CDGRI == none)
	{
		return;
	}

	Canvas.Font = GUIStyle.PickFont(Sc);
	s = "MaxMonsters=" $ CDGRI.CDInfoParams.MM $
		"\nCohortSize=" $ CDGRI.CDInfoParams.CS $
		"\nWaveSizeFakes=" $ CDGRI.CDInfoParams.WSF $
		"\nSpawnMod=" $ CDGRI.CDInfoParams.SM $
		"\nSpawnPoll=" $ CDGRI.CDInfoParams.SP $
		"\nSpawnCycle=" $ CDGRI.CDInfoParams.SC;
	Canvas.TextSize("SpawnCycle=nam_poundemonium", XL, YL, Sc, Sc); // The longest setting sentense

	X = Canvas.ClipX * 0.34;
	Y = Canvas.ClipY * 0.7605;
	DrawTitledInfoBox(CDSettingsString, s, Sc, XL, YL, X, Y, 6);
}

function DrawSpectatorsInfo()
{
	local float Sc, XL, YL, X, Y;
	local string s;
	local int i, n;
	local KFPlayerReplicationInfo KFPRI;

	if(CDGRI == none || WorldInfo.NetMode == NM_StandAlone) return;

	Canvas.Font = GUIStyle.PickFont(Sc);
	s = "";

	for(i=CDGRI.PRIArray.length-1; i>=0; --i)
	{
		KFPRI = KFPlayerReplicationInfo(CDGRI.PRIArray[i]);

		if(KFPRI != none && KFPRI.bOnlySpectator)
		{
			s $= KFPRI.PlayerName $ "\n";
			++n;
		}
	}

	Canvas.TextSize("ABC", XL, YL, Sc, Sc);
	X = Canvas.ClipX * 0.555;
	Y = Canvas.ClipY * 0.7605;
	XL = Canvas.ClipX * 0.171;
	DrawTitledInfoBox(SpectatorsString, s, Sc, XL, YL, X, Y, max(6, n));
}

function string TestSize(string S)
{
	local float XL, YL;

	Canvas.TextSize(S, XL, YL);
	return S @ string(XL);
}

defaultproperties
{
	ScoreboardClass=class'KFScoreBoard'
	ConsoleClass=class'CombinedCD2.xUI_Console'
	BackgroundTexture=Texture2D'EngineResources.WhiteSquareTexture'

	MyFontRenderInfo=(bClipText=true)
	MaxWeaponPickupDist=1000
	WeaponPickupScanRadius=500
	ZedScanRadius=200
	WeaponIconSize=16
	WeaponFontScale=1.25
	WeaponIconColor=(R=192, G=192, B=192, A=192)
	WeaponOverweightIconColor=(R=255, G=0, B=0, A=192)

	WaveInfoLoc=(X=1456, Y=704)
	WaveInfoSize=(X=250, Y=48)
	TextScale=1.35

	VoteLeftTime=-1

	HUDClass=class'CD_GFxMoviePlayer_HUD'
}