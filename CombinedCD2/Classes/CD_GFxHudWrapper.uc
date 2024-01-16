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
var int CurTipIndex;
var float LastTipReloadTime;

var array<KFPathnode> PathnodeCache;

var localized string ItemDropPrefix;
var localized string WaveInfoBasic;
var localized string WaveInfoTrader;
var localized string WaveInfoBoss;
var localized string CDSettingsString;
var localized string SpectatorsString;
var localized array<string> CDTips;

const MAX_DRAW_DISTANCE = 15;
const TIP_REFRESH_DELAY = 5.f;

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
//	SetTimer(0.1, true, 'CheckForWeaponPickup');
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
		if(CDPC.myHUD.bShowHUD)
		{
			if(CDPC.bShowVolumes)
				DrawVolumesNumber();

			if(CDPC.bShowPathNodes)
				DrawPathsNumber();

			if( !CDPC.bCinematicMode && CDGRI.bTraderIsOpen )
				DrawWeaponPickupInfo();
		}

		if(MainMenuIsOpen())
		{
			DrawTips();

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
		else if (!CDPC.PlayerReplicationInfo.bWaitingPlayer && CDPC.myHUD.bShowHUD)
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
				CDPC.TeamMessage(none, ItemDropPrefix @ NewItems[0], 'System');
			}
		}
	}
	bLoadedInitItems = true;
}

simulated function CheckForItems()
{
	if (CDPC.DropItem && CDGRI!=none)
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

	if(PathnodeCache.length == 0)
	{
		CachePathnodes();
	}
	
	foreach PathnodeCache(N)
	{
		DrawActorNumber(N);
	}
}

function CachePathnodes()
{
	local KFPathnode N;
	
	ForEach WorldInfo.AllNavigationPoints( class 'KFPathnode', N )
	{
		PathnodeCache.AddItem(N);
	}
}

function DrawActorNumber(Actor A)
{
	local vector ScreenPos;
	local float Sc, Hight, Width, MarginX, MarginY;
	local string S;
	local Canvas C;

	if(!InDrawRange(A, ScreenPos))
	{
		return;
	}

	C = Canvas;
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

function bool InDrawRange(Actor A, out vector ScreenPos, optional vector PosOffset)
{
	local Canvas C;
	local vector CamLoc;
	local rotator CamRot;
	local float CamDot;

	C = Canvas;
	ScreenPos = C.Project(A.Location + PosOffset);

	if(ScreenPos.X < 0.f || ScreenPos.X > C.ClipX || ScreenPos.Y < 0.f || ScreenPos.Y > C.ClipY)
		return false;

	CDPC.GetPlayerViewPoint(CamLoc, CamRot);

	if(VSizeSq(A.location - CamLoc) > MAX_DRAW_DISTANCE*(10**5))
		return false; // Skip distant actors

	CamDot = vector(CamRot) Dot (A.location - CamLoc);
	if(CamDot < 0.5)
		return false; // Skip actors out of cam range

	return true;
}

/* ====================================================================
	 Weapon Pickup
	==================================================================== */

function DrawWeaponPickupInfo()
{
	local Canvas C;
	local CD_DroppedPickup CDDP;
	local vector ScreenPos, CamLoc;
	local rotator CamRot;
	local bool bHasAmmo, bCanCarry;
	local string WeapText, AmmoText, WeightText, OwnerText;
	local color IconColor, TextColor;
	local float IconSize, XL, YL, Sc, defaultSc;
	local array<float> tempXL, tempYL;
	local float PosX, PosY, Width, Height, OffsetX, OffsetY;
	local string WeapIconPath;
	local Texture2D WeapIcon, AmmoIcon, Avatar;
	local KFInventoryManager KFIM;
	local Inventory Inv;
	local class<KFWeapon> WeapClass;

	C = Canvas;
	C.Font = GUIStyle.PickFont(defaultSc);
	CDPC.GetPlayerViewPoint(CamLoc, CamRot);

	foreach CollidingActors(class'CombinedCD2.CD_DroppedPickup', CDDP, MAX_DRAW_DISTANCE*100, CamLoc)
	{
		if(CDDP.Velocity.Z == 0 && InDrawRange(CDDP, ScreenPos, vect(0,0,25)) && CDDP.bGlowRef)
		{
			// Intro
			tempXL.length=0;
			tempYL.length=0;
			Sc = defaultSc * Lerp(1, 0.3, VSizeSq(CDDP.location - CamLoc)/(MAX_DRAW_DISTANCE*(10**5)));
			bHasAmmo = CDDP.MagazineAmmo[0] >= 0;
			C.TextSize("ABC", XL, IconSize, Sc, Sc);
			//ResModifier = CDDP.WorldInfo.static.GetResolutionBasedHUDScale();
			//IconSize = WeaponIconSize * WeaponFontScale * ResModifier * (Sc);
			Height = 0;

			// Weapon
			if(CDDP.InventoryClass.default.ItemName != "")
			{
				WeapText = CDDP.InventoryClass.default.ItemName;
				C.TextSize(WeapText, XL, YL, Sc, Sc);
				tempXL.AddItem(XL);
				Width = XL;
				tempYL.AddItem(FMax(IconSize, YL));
				Height += tempYL[tempYL.length-1];
			}
			// Ammo
			if (bHasAmmo)
			{
				AmmoText = CDDP.GetAmmoText();
				C.TextSize(AmmoText, XL, YL, Sc, Sc);
				tempXL.AddItem(XL);
				Width = FMax(Width, XL);
				tempYL.AddItem(FMax(IconSize, YL));
				Height += tempYL[tempYL.length-1];
			}
			// Weight
			WeightText = CDDP.GetWeightText(CDPC.Pawn);
			C.TextSize(WeightText, XL, YL, Sc, Sc);
			tempXL.AddItem(XL);
			Width = FMax(Width, XL);
			tempYL.AddItem(FMax(IconSize, YL));
			Height += tempYL[tempYL.length-1];
			// Owner
			if (CDDP.OriginalOwnerPlayerName != "")
			{
				OwnerText = CDDP.OriginalOwnerPlayerName;
				C.TextSize(OwnerText, XL, YL, Sc, Sc);
				tempXL.AddItem(XL);
				Width = FMax(Width, XL);
				tempYL.AddItem(FMax(IconSize, YL));
				Height += tempYL[tempYL.length-1];
			}

			// Background
			Width += IconSize*2.5;
			OffsetX = Width * 0.125;
			OffsetY = Height * 0.125;
			Width += OffsetX*2;
			Height += OffsetY*2;
			PosX = ScreenPos.X - Width*0.5;
			PosY = ScreenPos.Y - Height*0.5;
			if(C.ClipX < PosX + Width || PosX < 0)
			{
				continue;
			}

			C.SetDrawColor(0, 0, 0, 180);
			GUIStyle.DrawRectBox(PosX, PosY, Width, Height, 8.f, 0);

			PosY += OffsetY;
			// Weapon
			if(CDDP.InventoryClass.default.ItemName != "")
			{
				PosX = ScreenPos.X - (tempXL[0] + IconSize*2.5)*0.5;
				C.DrawColor = WeaponIconColor;
				C.SetPos(PosX, PosY);
				WeapIconPath = class'CD_Object'.static.GetWeapDef(KFWeapon(CDDP.Inventory)).static.GetImagePath();
				WeapIcon = Texture2D(class'CD_Object'.static.SafeLoadObject(WeapIconPath, class'Texture2D'));
				C.DrawTile(WeapIcon, IconSize*2, IconSize, 0, 0, 256, 128);

				C.SetDrawColor(250, 250, 250, 255);
				GUIStyle.DrawTextShadow(WeapText, PosX + IconSize*2.5, PosY, 1, Sc);
				tempXL.Remove(0,1);
				PosY += tempYL[0];
				tempYL.Remove(0,1);
			}

			// Ammo
			if(bHasAmmo)
			{
				if(CDDP.IsLowAmmo())
				{
					IconColor = WeaponOverweightIconColor;
					TextColor = WeaponOverweightIconColor;
				}
				else
				{
					IconColor = WeaponIconColor;
					TextColor = MakeColor(250, 250, 250, 255);
				}

				PosX = ScreenPos.X - (tempXL[0] + IconSize*1.5)*0.5;
				C.DrawColor = IconColor;
				C.SetPos(PosX, PosY + IconSize*0.25);
				if(KFWeapon(CDDP.Inventory) != none)
				{
					AmmoIcon = KFWeapon(CDDP.Inventory).FireModeIconPaths[0];
				}
				else
				{
					AmmoIcon = WeaponAmmoIcon;
				}
				C.DrawTile(AmmoIcon, IconSize, IconSize*0.5, 0, 0, 256, 128);

				C.DrawColor = TextColor;
				GUIStyle.DrawTextShadow(AmmoText, PosX + IconSize*1.5, PosY, 1, Sc);
				tempXL.Remove(0,1);
				PosY += tempYL[0];
				tempYL.Remove(0,1);
			}

			// Weight
			PosX = ScreenPos.X - (tempXL[0] + IconSize*1.5)*0.5;
			bCanCarry = true;
			if(CDPC.Pawn != none)
			{
				KFIM = KFInventoryManager(CDPC.Pawn.InvManager);
				if(KFIM != none)
				{
					WeapClass = class<KFWeapon>(CDDP.InventoryClass);
					if (KFIM.CanCarryWeapon(WeapClass, CDDP.UpgradeLevel))
					{
						if (WeapClass.default.DualClass != None)
							bCanCarry = !KFIM.ClassIsInInventory(WeapClass.default.DualClass, Inv);
						else
							bCanCarry = !KFIM.ClassIsInInventory(WeapClass, Inv);
					}
					else
					{
						bCanCarry = false;
					}
				}
			}

			C.DrawColor = bCanCarry ? WeaponIconColor : WeaponOverweightIconColor;
			C.SetPos(PosX, PosY);
			C.DrawTile(WeaponWeightIcon, IconSize, IconSize, 0, 0, 256, 256);

			C.DrawColor = bCanCarry ? MakeColor(250, 250, 250, 255) : WeaponOverweightIconColor;
			GUIStyle.DrawTextShadow(WeightText, PosX + IconSize*1.5, PosY, 1, Sc);
			tempXL.Remove(0,1);
			PosY += tempYL[0];
			tempYL.Remove(0,1);

			// Owner
			if (CDDP.OriginalOwnerPlayerName != "")
			{
				C.SetDrawColor(250, 250, 250, 255);
				Avatar = CDDP.OriginalOwner.Avatar;
				if( (Avatar != none && Avatar == class'KFScoreBoard'.default.DefaultAvatar) ||
					(Avatar == none && !CDDP.OriginalOwner.bBot) )
				{
					class'KFScoreBoard'.static.CheckAvatar(KFPlayerReplicationInfo(CDDP.OriginalOwner), CDPC);
				}

				PosX = ScreenPos.X - (tempXL[0] + IconSize*1.5)*0.5;
				C.SetPos(PosX, PosY);
				C.DrawTile(Avatar, IconSize, IconSize, 0, 0, CDDP.OriginalOwner.Avatar.SizeX, CDDP.OriginalOwner.Avatar.SizeY);
				GUIStyle.DrawTextShadow(OwnerText, PosX + IconSize*1.5, PosY, 1, Sc);
			}
		}
	}
}	

/* ====================================================================
	 Wave Info
	==================================================================== */

function DrawWaveInfo()
{
	local float RX, RY;
	local string WaveInfoText;
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
	C.Font = GUIStyle.PickFont(FontScale);
	FontScale = class'KFGame.KFGameEngine'.static.GetKFFontScale() * TextScale;
	C.TextSize(WaveInfoText, TextWidth, TextHeight, FontScale, FontScale);
	TextOffsetY = (WaveInfoSize.Y - TextHeight) * 0.5;

	// Draw the info box
	C.SetDrawColor(0, 0, 0, 255);
	GUIStyle.DrawRectBox(WaveInfoLoc.X, WaveInfoLoc.Y, WaveInfoSize.X, WaveInfoSize.Y, 8.f, 0);
	
	// And the text
	C.SetDrawColor(255, 255, 255, 255);
	GUIStyle.DrawTextShadow(WaveInfoText, WaveInfoLoc.X + (0.04 * WaveInfoSize.X), WaveInfoLoc.Y + TextOffsetY, 1, FontScale);
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

function DrawTips()
{
	local float Sc, XL, YL, X, Y, W;

	Canvas.Font = GUIStyle.PickFont(Sc);

	if(CurTipIndex == INDEX_NONE)
	{
		CurTipIndex = 0;
		LastTipReloadTime = WorldInfo.TimeSeconds;
	}
	if(WorldInfo.TimeSeconds - LastTipReloadTime > TIP_REFRESH_DELAY)
	{
		CurTipIndex = Rand(CDTips.length);
		LastTipReloadTime = WorldInfo.TimeSeconds;
	}

	Canvas.TextSize(CDTips[CurTipIndex], XL, YL, Sc, Sc);
	X = Canvas.ClipX * 0.333;
	Y = Canvas.ClipY * 0.92;
	W = Canvas.ClipX * 0.401;
	Canvas.SetDrawColor(0, 0, 0, 250);
	GUIStyle.DrawRectBox(X, Y, W, YL*1.5, 8.f, 0);
	Canvas.SetDrawColor(250, 250, 250, 255);
	DrawTextShadowHVCenter(CDTips[CurTipIndex], X, Y+YL*0.25, W, Sc);
}

function string TestSize(string S)
{
	local float XL, YL;

	Canvas.TextSize(S, XL, YL);
	return S @ string(XL);
}

function string test()
{
	local float XL, YL, Sc;
	local string s;
	GUIStyle.PickFont(Sc);
	s = "Scalar=" $ string(Sc);
	Canvas.TextSize("ABC", XL, YL, Sc, Sc);
	s $= "\nYL=" $ string(YL);
	s $= "\nCanvas.ClipY=" $ string(Canvas.ClipY);
	s $= "\nHUD.SizeY=" $ string(SizeY);
	s $= "\nDefaultHeight=" $ string(GUIStyle.DefaultHeight);
	return s;
}

defaultproperties
{
	ScoreboardClass=class'KFScoreBoard'
	ConsoleClass=class'CombinedCD2.xUI_Console'
	BackgroundTexture=Texture2D'EngineResources.WhiteSquareTexture'
	WeaponAmmoIcon=Texture2D'UI_FireModes_TEX.UI_FireModeSelect_BulletSingle'
	WeaponWeightIcon=Texture2D'UI_Menus.TraderMenu_SWF_I26'

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
	CurTipIndex=INDEX_NONE

	HUDClass=class'CD_GFxMoviePlayer_HUD'
}