class UTM_GFxHudWrapper extends CD_GFxHudWrapper;

struct ZedNameCombo
{
    var string ZedClassPath;
    var string ZedName;
};

var class<UTM_OptionBoard> UTM_ScoreboardClass;
var UTM_OptionBoard UTM_Scoreboard;
var array<ZedNameCombo> ZedNames;

/* STM System */
struct FKillMessageType
{
    var bool bDamage;
    var int Damage;
    var int Counter;
    var int HealthMax;
    var int Health;
    var Pawn Type;
    var string Name;
    var PlayerReplicationInfo OwnerPRI;
    var float MsgTime;
    var float HealthPct;
    var Color MsgColor;

    structdefaultproperties
    {
        bDamage=false
        Damage=0
        Counter=0
        HealthMax=0
        Health=0
        Type=none
        Name=""
        OwnerPRI=none
        MsgTime=0.0
        HealthPct=0.0
        MsgColor=(R=0,G=0,B=0,A=0)
    }
};

struct FNumberedMsg
{
    var int Amount;
    var Vector pos;
    var Vector vel;
    var float Time;
    var byte Type;

    structdefaultproperties
    {
        Amount=0
        pos=(X=0.0,Y=0.0,Z=0.0)
        Time=0.0
        Type=0
    }
};

var Pawn PawnOwner;
var transient array<FKillMessageType> KillMessages;
var array<FNumberedMsg> Numbers;
var transient float PLCameraDot;
var transient Vector PLCameraLoc;
var transient Vector PLCameraDir;
var transient Rotator PLCameraRot;
var transient float RenderTime;
var Texture2D WhiteMaterial;
var Color BlackBGColor;
var Color RedBGColor;
var Color HUDTextColor;

var localized string DurationString;
var localized string SecondString;

function PostRender()
{
	local float DT;

	Super.PostRender();

	//	(STM)
	PlayerOwner.GetPlayerViewPoint(PLCameraLoc, PLCameraRot);
    PLCameraDir = vector(PLCameraRot);
    PLCameraDot = PLCameraDir Dot PLCameraLoc;
    if(RenderTime > float(0))
    {
        DT = PlayerOwner.WorldInfo.TimeSeconds - RenderTime;
    }
    RenderTime = PlayerOwner.WorldInfo.TimeSeconds;
    
	if(Numbers.Length > 0)
    	DrawNumberMsg(DT);

    if(KillMessages.Length > 0)
    	RenderKillMsg();

    if(UTM_PlayerController(Owner).bShowAcc && !KFPlayerController(Owner).PlayerReplicationInfo.bWaitingPlayer)
        RenderAccuracy();

    if(UTM_PlayerReplicationInfo(KFPlayerController(Owner).PlayerReplicationInfo).LargeWaveNum > 0)
        RenderLargeChallenge();

    else if(UTM_GameReplicationInfo(PlayerOwner.WorldInfo.GRI).bTrashChallenge)
        RenderTrashChallenge();

    if(UTM_PlayerController(Owner).bShowCollectibles && !KFPlayerController(Owner).PlayerReplicationInfo.bWaitingPlayer)
        RenderCollectibles();
}

function LaunchHUDMenus()
{
	UTM_Scoreboard = UTM_OptionBoard(GUIController.InitializeHUDWidget(UTM_ScoreboardClass));
	UTM_Scoreboard.SetVisibility(false);
}

exec function SetShowScores(bool bNewValue)
{
    bShowScores = bNewValue;
	if(GUIController != none)
    {
        if(bShowScores)
        {
        	if(!UTM_PlayerController(Owner).bCheckingWeapSkin)
                UTM_Scoreboard = UTM_OptionBoard(GUIController.OpenMenu(class'UTM_OptionBoard'));

            else
                GUIController.OpenMenu(class'UTM_UI_WeaponSkin');
        }
        
        else
        	GUIController.CloseMenu(class'UTM_OptionBoard');
    }
}

/* **************************************
 *	STM features
 * ************************************** */

function CheckAndDrawRemainingZedIcons(){ return; }


final function AddKillMessage(Pawn Victim, int Value, PlayerReplicationInfo PRI, byte Type)
{
    local int newKM, I;
    local bool bDmg;
    local float HPct;

    HPct = float(KFPawn_Monster(Victim).Health) / float(KFPawn_Monster(Victim).HealthMax);
    bDmg = Type == 2;
    
    if(KillMessages.Length > 5)
	    KillMessages.Remove(0, 1);
    
    newKM = KillMessages.Length;
    KillMessages.Length = newKM + 1;
    KillMessages[newKM].bDamage = bDmg;
    KillMessages[newKM].Damage = Value;
    KillMessages[newKM].Type = Victim;
    KillMessages[newKM].OwnerPRI = PRI;
    KillMessages[newKM].Name = GetNameOf(Victim.Class);
    KillMessages[newKM].HealthMax = KFPawn_Monster(Victim).HealthMax;
    KillMessages[newKM].Health = KFPawn_Monster(Victim).Health;
    KillMessages[newKM].HealthPct = HPct;
    KillMessages[newKM].MsgTime = WorldInfo.TimeSeconds;
    KillMessages[newKM].MsgColor = GetHPColorScale(HPct);
    I = newKM - 1;
    J0x335:
    
    if(I >= 0)
    {
        if((KillMessages[I].Type == Victim) && bDmg || KillMessages[I].OwnerPRI == PRI)
        {
            KillMessages[newKM].Counter = KillMessages[I].Counter + Value;
            KillMessages[newKM].MsgColor = GetHPColorScale(KillMessages[newKM].HealthPct);
            return;
        }
        -- I;
        
        goto J0x335;
    }   
}

final function RenderKillMsg()
{
    local float Sc, YL, T, X, Y;

    local string S;
    local int I;

    Canvas.Font = GUIStyle.PickFont(Sc); //(GUIStyle.DefaultFontSize, Sc);
    Canvas.TextSize("ABC", X, YL, Sc, Sc);
    X = Canvas.ClipX * default.NoContainerLoc.X; //0.023; //0.0150;
    Y = Canvas.ClipY * default.NoContainerLoc.Y; //0.36; //0.240;
    
    if(KillMessages.Length >= 1)
    {
	    T = WorldInfo.TimeSeconds -  KillMessages[KillMessages.Length-1].MsgTime;
	    Canvas.SetDrawColor(10, 10, 10, byte(Max(0, (1.0 - ((T / 8.0) ** float(3))) * 200.0)));
	    GUIStyle.DrawRectBox(X - (YL/2), Y - (YL/2), YL*17, YL*7, 8.f, 0);
	}
	I = 0;
    J0x114:
    // End:0x54C [Loop If]
    if(I < KillMessages.Length)
    {
        T = WorldInfo.TimeSeconds - KillMessages[I].MsgTime;
        // End:0x1A9
        if(T > 8.0)
        {
            if(I<KillMessages.Length) KillMessages.Remove(I, 1);
        }
        // End:0x53E
        else
        {
            // End:0x354
            if(KillMessages[I].Damage < KillMessages[I].Health)
            {
                S = ((((((((("-" $ string(KillMessages[I].Damage)) $ " HP   ") $ KillMessages[I].Name) $ " ( ") $ string(KillMessages[I].Counter + KillMessages[I].Damage)) $ "        ") $ string(KillMessages[I].Health - KillMessages[I].Damage)) $ " | ") $ string(KillMessages[I].HealthMax)) $ " )";
            }
            // End:0x3F9
            else
            {
                S = (((((("-" $ string(KillMessages[I].Damage)) $ " HP   ") $ KillMessages[I].Name) $ " X ") $ "(") $ string(KillMessages[I].HealthMax)) $ " )";
            }
            Canvas.SetPos(X, Y);
            Canvas.DrawColor = KillMessages[I].MsgColor;
            T = (1.0 - ((T / 8.0) ** float(3))) * 255.0;
            Canvas.DrawColor.A = byte(T);
            Canvas.DrawText(S,,Sc,Sc); //Sc * float(2), Sc * float(2));
            Y += YL; //(1.50 * YL);
        }
        ++ I;
        // [Loop Continue]
        goto J0x114;
    }
    //return;    
}

final function AddNumberMsg(int Amount, Vector pos)
{
    local int I;
    local Vector Velo;

    I = Numbers.Length;
    // End:0x45
    if(I > 15)
    {
        Numbers.Remove(0, 1);
        I = Numbers.Length;
    }
    Velo = vect(0.0, 0.0, 0.0);
    Velo.X = (FRand() * 300.0) - 150.0;
    Velo.Y = (FRand() * 300.0) - 150.0;
    Velo.Z = (FRand() * 150.0) + 112.5;
    Numbers.Length = I + 1;
    Numbers[I].vel = Velo;
    Numbers[I].Amount = Amount;
    Numbers[I].pos = pos;
    Numbers[I].Time = WorldInfo.TimeSeconds;
    Numbers[I].Type = 0;
}

final function DrawNumberMsg(float DT)
{
    local int I;
    local float T, ThisDot, FontScale, XS, YS;

    local Vector V;
    local string S;

    Canvas.Font = GUIStyle.PickFont(FontScale);
    FontScale *= 2;
    I = 0;
    while(I < Numbers.Length)
    {
        T = WorldInfo.TimeSeconds - Numbers[I].Time;
        // End:0x10D
        if(T > 3.0)
        {
            Numbers.Remove(I, 1);
        }
        // End:0x59A
        else
        {
            V = Numbers[I].pos;
            ThisDot = (PLCameraDir Dot V) - PLCameraDot;
            
            if(ThisDot > 0.0)
            {
                V = Canvas.Project(V);
                // End:0x59A
                if((((V.X > float(0)) && V.Y > float(0)) && V.X < Canvas.ClipX) && V.Y < Canvas.ClipY)
                {
                    ThisDot = FontScale - (((FMin(ThisDot, 1500.0) / 1500.0) * FontScale) * 0.50); //FontScale / ThisDot;
                    switch(Numbers[I].Type)
                    {
                        // End:0x35A
                        case 0:
                            S = "-" $ string(Numbers[I].Amount);
                            Canvas.SetDrawColor(220, 0, 0, 255);
                            //`Log("Receive case 0: " $ string(Numbers[I].Amount));
                            break;
                        case 1:
                            S = ("+" $ string(Numbers[I].Amount)) $ " XP";
                            Canvas.SetDrawColor(255, 255, 25, 255);
                            break;
                        case 2:
                            S = ("+" $ string(Numbers[I].Amount)) $ " HP";
                            Canvas.SetDrawColor(32, 240, 32, 255);
                            break;                            
                    }
                    if(T > 2.0)
                    {
                        Canvas.DrawColor.A = byte((float(3) - T) * 255.0);
                        //`Log("Fading...: "$string(Canvas.DrawColor.A));
                    }
                    Canvas.TextSize(S, XS, YS, ThisDot, ThisDot);
                    //Canvas.SetPos(V.X - (XS * 0.50), V.Y - (YS * 0.50));
                    GUIStyle.DrawTextShadow(S, V.X - (XS * 0.50), V.Y - (YS * 0.50), ThisDot, ThisDot);
                }
            }
            Numbers[I].pos += (Numbers[I].Vel * DT);
            Numbers[I].Vel.Z -= (700.0 * DT);
            ++ I;
        }  
    }         
}

function DrawHUD()
{
    local KFPawn_Monster KFPM;
    local float DetectionRangeSq, ThisDot;

    super.DrawHUD();

    if(!UTM_PlayerController(PlayerOwner).bShowZedHealth)
    {
        return;
    }
    if((PawnOwner == none) && PlayerOwner.Pawn != none)
    {
        PawnOwner = PlayerOwner.Pawn;
    }
    if(PawnOwner == none)
    {
        return;
    }
    DetectionRangeSq = Square(2500.0);
    // End:0x1F6
    foreach WorldInfo.AllPawns(class'KFPawn_Monster', KFPM)
    {
        ThisDot = Normal(vector(PawnOwner.GetViewRotation())) Dot Normal(KFPM.Location - PawnOwner.Location);
        // End:0x1F5
        if((KFPM.IsAliveAndWell() && DetectionRangeSq >= VSizeSq(KFPM.Location - PawnOwner.Location)) && ThisDot > float(0))
        {
            DrawZedHealthbar(KFPM);
        }        
    }
}

simulated function DrawZedHealthbar(KFPawn_Monster KFPM)
{
    local Vector ScreenPos, TargetLocation, CameraLocation;
    local float HealthBarLength, HealthbarHeight, HealthScale;

    CameraLocation = PawnOwner.GetPawnViewLocation();
    HealthBarLength = FMin(50.0 * (float(Canvas.SizeX) / 1024.0), 50.0);
    HealthbarHeight = FMin(6.0 * (float(Canvas.SizeX) / 1024.0), 6.0);
    HealthScale = float(KFPM.Health) / float(KFPM.HealthMax);
    // End:0x1DF
    if((KFPM.bCrawler && KFPM.Floor.Z <= -0.70) && KFPM.Physics == 8)
    {
        TargetLocation = KFPM.Location + ((vect(0.0, 0.0, -1.0) * KFPM.GetCollisionHeight()) * 1.80);
    }
    // End:0x23E
    else
    {
        TargetLocation = KFPM.Location + ((vect(0.0, 0.0, 1.0) * KFPM.GetCollisionHeight()) * 1.80);
    }
    ScreenPos = Canvas.Project(TargetLocation);
    // End:0x342
    if((((ScreenPos.X < float(0)) || ScreenPos.X > float(Canvas.SizeX)) || ScreenPos.Y < float(0)) || ScreenPos.Y > float(Canvas.SizeY))
    {
        return;
    }
    // End:0x589
    if(FastTrace(TargetLocation, CameraLocation))
    {
        Canvas.EnableStencilTest(true);
        Canvas.SetDrawColor(0, 0, 0, 255);
        Canvas.SetPos(ScreenPos.X - (HealthBarLength * 0.50), ScreenPos.Y);
        Canvas.DrawTileStretched(WhiteMaterial, HealthBarLength, HealthbarHeight, 0.0, 0.0, 32.0, 32.0);
        Canvas.SetDrawColor(237, 8, 0, 255);
        Canvas.SetPos((ScreenPos.X - (HealthBarLength * 0.50)) + 1.0, ScreenPos.Y + 1.0);
        Canvas.DrawTileStretched(WhiteMaterial, (HealthBarLength - 2.0) * HealthScale, HealthbarHeight - 2.0, 0.0, 0.0, 32.0, 32.0);
        Canvas.EnableStencilTest(false);
    }
    //return;    
}

static final function string GetNameOf(class<Pawn> Other)
{
    local int i;

    for(i=0; i<default.ZedNames.length; i++)
    {
        if(default.ZedNames[i].ZedClassPath ~= PathName(Other))
            return default.ZedNames[i].ZedName;
    }

    return "";
}

static final function string GetNameArticle(string S)
{
    switch(Caps(Left(S, 1)))
    {
        // End:0x1E
        case "A":
        // End:0x24
        case "E":
        // End:0x2A
        case "I":
        // End:0x30
        case "O":
        // End:0x3B
        case "U":
            return "an";
        // End:0xFFFF
        default:
            return "a";
    }
    //return ReturnValue;    
}

static final function string StripMsgColors(string S)
{
    local int I;


    J0x00:    // End:0x72 [Loop If]
    if(true)
    {
        I = InStr(S, Chr(6));
        // End:0x36
        if(I == -1)
        {
            // [Explicit Break]
            goto J0x72;
        }
        S = Left(S, I) $ Mid(S, I + 2);
        J0x72:
        // [Loop Continue]
        goto J0x00;
    }
    return S;
    //return ReturnValue;    
}

final function Color GetMsgColor(bool bDamage, int Count)
{
    local float T;

    // End:0x1D5
    if(bDamage)
    {
        // End:0x36
        if(Count > 1500)
        {
            return MakeColor(148, 0, 0, 255);
        }
        // End:0x15D
        else
        {
            // End:0xCB
            if(Count > 1000)
            {
                T = float(Count - 1000) / 500.0;
                return Add_ColorColor(Multiply_ColorFloat(MakeColor(148, 0, 0, 255), T), Multiply_ColorFloat(MakeColor(255, 0, 0, 255), 1.0 - T));
            }
            // End:0x15D
            else
            {
                // End:0x15D
                if(Count > 500)
                {
                    T = float(Count - 500) / 500.0;
                    return Add_ColorColor(Multiply_ColorFloat(MakeColor(255, 0, 0, 255), T), Multiply_ColorFloat(MakeColor(255, 255, 0, 255), 1.0 - T));
                }
            }
        }
        T = float(Count) / 500.0;
        return Add_ColorColor(Multiply_ColorFloat(MakeColor(255, 255, 0, 255), T), Multiply_ColorFloat(MakeColor(0, 255, 0, 255), 1.0 - T));
    }
    // End:0x1FB
    if(Count > 20)
    {
        return MakeColor(255, 0, 0, 255);
    }
    // End:0x316
    else
    {
        // End:0x28A
        if(Count > 10)
        {
            T = float(Count - 10) / 10.0;
            return Add_ColorColor(Multiply_ColorFloat(MakeColor(148, 0, 0, 255), T), Multiply_ColorFloat(MakeColor(255, 0, 0, 255), 1.0 - T));
        }
        // End:0x316
        else
        {
            // End:0x316
            if(Count > 5)
            {
                T = float(Count - 5) / 5.0;
                return Add_ColorColor(Multiply_ColorFloat(MakeColor(255, 0, 0, 255), T), Multiply_ColorFloat(MakeColor(255, 255, 0, 255), 1.0 - T));
            }
        }
    }
    T = float(Count) / 5.0;
    return Add_ColorColor(Multiply_ColorFloat(MakeColor(255, 255, 0, 255), T), Multiply_ColorFloat(MakeColor(0, 255, 0, 255), 1.0 - T));
    //return ReturnValue;    
}

function Color GetHPColorScale(float T)
{
    local Color C;

    /* Choose color depending on HP */
    // 0 ~ 25%
    if(T < 0.250)
    {
        //  191.25 ~ 255
        C.R = byte((T + 0.75) * 255.f);
    }
    // 25% ~ 75%
    else if(T < 0.750)
    {
        //  0 ~ 255
        C.G = byte((T - 0.250) * 510.0);
        C.R = 255;
    }
    // 75% ~ 100%
    else if(T < float(1))
    {
        C.G = 255;
        //  0 ~ 255
        C.R = byte((float(1) - T) * 1002.0);
    }
            // End:0x15D
     else
    {
        C.G = 255;
        C.B = 25;
    }
    return C;
    //return ReturnValue;    
}

function RenderAccuracy()
{
    local float Sc, YL, f, X, Y;
    local string S;
    local UTM_PlayerController STMPC;

    Canvas.Font = GUIStyle.PickFont(Sc); //(GUIStyle.DefaultFontSize, Sc);
    Canvas.TextSize("ABC", X, YL, Sc, Sc);
    X = Canvas.ClipX * 0.175; //0.023; //0.020;
    Y = Canvas.ClipY * 0.060; // 0.570; //0.450;
    
    STMPC = UTM_PlayerController(Owner);
    if(STMPC != none)
    {
        Canvas.SetDrawColor(10, 10, 10, 200);
        GUIStyle.DrawRectBox(X - (YL/2), Y - (YL/2), YL*11, YL*3, 8.f, 0);

        if(STMPC.ShotsFired != 0) f = float(STMPC.ShotsHit)/float(STMPC.ShotsFired) * 100;
        else f = 0;
        S = class'CombinedCD2.xUI_MapVote'.default.HitAccuracyString $ ":" @ string(round(f)) $ "%" @ "(" $ string(STMPC.ShotsHit) $ "/" $ string(STMPC.ShotsFired) $ ")";
        Canvas.SetPos(X, Y);
        Canvas.SetDrawColor(0, 255, 10, 255);
        Canvas.DrawText(S,,Sc,Sc);
        Y += YL;

        if(STMPC.ShotsHit != 0) f = float(STMPC.ShotsHitHeadshot)/float(STMPC.ShotsHit) * 100;
        else f = 0;
        S = class'CombinedCD2.xUI_MapVote'.default.HSAccuracyString $ ":" @ string(round(f)) $ "%" @ "(" $ string(STMPC.ShotsHitHeadshot) $ "/" $ string(STMPC.ShotsHit) $ ")";
        Canvas.SetPos(X, Y);
        Canvas.DrawText(S,,Sc,Sc);
    }
}

function RenderLargeChallenge()
{
    local float Sc, YL, X, Y;
    local string S;
    local UTM_PlayerController UTMPC;
    local UTM_PlayerReplicationInfo UTMPRI;

    Canvas.Font = GUIStyle.PickFont(Sc);
    Canvas.TextSize("ABC", X, YL, Sc, Sc);
    X = Canvas.ClipX * 0.180;
    Y = Canvas.ClipY * 0.020;

    UTMPC = UTM_PlayerController(Owner);
    UTMPRI = UTM_PlayerReplicationInfo(UTMPC.PlayerReplicationInfo);

    if(UTMPRI != none)
    {
        Canvas.SetDrawColor(10, 10, 10, 200);
        GUIStyle.DrawRectBox(X - (YL/2), Y - (YL/2), YL*7, YL*4, 8.f, 0);

        S = class'KFGame.KFGFxMenu_PostGameReport'.default.WaveString @ string(UTMPRI.LargeWaveNum) $ "/5";
        Canvas.SetPos(X, Y);
        Canvas.SetDrawColor(0, 255, 10, 255);
        Canvas.DrawText(S,,Sc,Sc);
        Y += YL;

        S = "SpawnPoll=" $ string(8 - UTMPRI.LargeWaveNum) $ ".0";
        Canvas.SetPos(X, Y);
        Canvas.DrawText(S,,Sc,Sc);
        Y += YL;

        S = "SC:" $ string(UTMPRI.SCKills) @ "FP:" $ string(UTMPRI.FPKills);
        Canvas.SetPos(X, Y);
        Canvas.DrawText(S,,Sc,Sc);
    }
}

function RenderTrashChallenge()
{
    local float Sc, YL, X, Y;
    local string S;
    local UTM_GameReplicationInfo UTMGRI;

    Canvas.Font = GUIStyle.PickFont(Sc);
    Canvas.TextSize("ABC", X, YL, Sc, Sc);
    X = Canvas.ClipX * 0.180;
    Y = Canvas.ClipY * 0.020;

    UTMGRI = UTM_GameReplicationInfo(PlayerOwner.WorldInfo.GRI);

    if(UTMGRI != none)
    {
        Canvas.SetDrawColor(10, 10, 10, 200);
        GUIStyle.DrawRectBox(X - (YL/2), Y - (YL/2), YL*11, YL*4, 8.f, 0);

        S = "SpawnCycle=" $ UTMGRI.CDInfoParams.SC;
        Canvas.SetPos(X, Y);
        Canvas.SetDrawColor(0, 255, 10, 255);
        Canvas.DrawText(S,,Sc,Sc);
        Y += YL;

        S = "MaxMonsters=" $ UTMGRI.CDInfoParams.MM;
        Canvas.SetPos(X, Y);
        Canvas.DrawText(S,,Sc,Sc);
        Y += YL;

        S = "(" $ DurationString $ "=" $ ((int(UTMGRI.CDInfoParams.MM)<32) ? "30" : "40") $ SecondString $ ")";
        Canvas.SetPos(X, Y);
        Canvas.DrawText(S,,Sc,Sc);
    }
}

function RenderCollectibles()
{
    local vector ScreenPos;
    local KFCollectibleActor KFCA;
    local float Sc, Hight, Width, MarginX, MarginY;
    local string S;

    foreach WorldInfo.AllActors(Class'KFCollectibleActor', KFCA)
    {
        ScreenPos = Canvas.Project(KFCA.Location);

        if(ScreenPos.X < float(0) || ScreenPos.X > float(Canvas.SizeX) || ScreenPos.Y < float(0) || ScreenPos.Y > float(Canvas.SizeY))
            continue;

        if(Abs(( PawnOwner.Rotation.Yaw - Rotator(KFCA.Location - PawnOwner.Location).Yaw ) % 65536) > 8000)
            continue;

        S = string(KFCA.name);

        if(PawnOwner.Location.Z > KFCA.Location.Z)
            S @= "v";
        else if(PawnOwner.Location.Z < KFCA.Location.Z)
            S @= "^";
        else
            S @= "o";

        Canvas.EnableStencilTest(true);
        Canvas.Font = GUIStyle.PickFont(Sc);
        Canvas.TextSize(S, Width, Hight, Sc, Sc);
        Canvas.SetDrawColor(10, 10, 10, 200);
        MarginX = Width * 0.125 * 0.5;
        MarginY = Hight * 0.125 * 0.5;
        Width *= 1.125;
        Hight *= 1.125;
        GUIStyle.DrawRectBox(ScreenPos.X - MarginX, ScreenPos.Y - MarginY, Width, Hight, 8.f, 0);
        Canvas.SetDrawColor(255, 255, 255, 255);
        DrawTextShadowHVCenter(S, ScreenPos.X - MarginX, ScreenPos.Y - MarginY, Width, Sc);
        Canvas.EnableStencilTest(false);
    }
}

defaultproperties
{
    WhiteMaterial=Texture2D'EngineResources.WhiteSquareTexture'
    BlackBGColor=(R=4,G=4,B=4,A=186)
    RedBGColor=(R=164,G=32,B=32,A=186)
    HUDTextColor=(R=250,G=250,B=250,A=186)

    ZedNames.Add((ZedClassPath="KFGameContent.KFPawn_ZedClot_Cyst", ZedName="Cyst"))
    ZedNames.Add((ZedClassPath="KFGameContent.KFPawn_ZedClot_Alpha", ZedName="Alpha Clot"))
    ZedNames.Add((ZedClassPath="KFGameContent.KFPawn_ZedClot_Alpha_Versus", ZedName="Versus Alpha"))
    ZedNames.Add((ZedClassPath="KFGameContent.KFPawn_ZedClot_Slasher", ZedName="Slasher"))
    ZedNames.Add((ZedClassPath="KFGameContent.KFPawn_ZedClot_Slasher_Versus", ZedName="Versus Slasher"))
    ZedNames.Add((ZedClassPath="KFGameContent.KFPawn_ZedClot_AlphaKing", ZedName="Rioter"))
    ZedNames.Add((ZedClassPath="KFGameContent.KFPawn_ZedClot_AlphaKing_Versus", ZedName="Versus Rioter"))
    ZedNames.Add((ZedClassPath="KFGameContent.KFPawn_ZedGorefast", ZedName="Gorefast"))
    ZedNames.Add((ZedClassPath="KFGameContent.KFPawn_ZedGorefast_Versus", ZedName="Versus Gorefast"))
    ZedNames.Add((ZedClassPath="KFGameContent.KFPawn_ZedGorefastDualBlade", ZedName="Gorefiend"))
    ZedNames.Add((ZedClassPath="KFGameContent.KFPawn_ZedCrawler", ZedName="Crawler"))
    ZedNames.Add((ZedClassPath="KFGameContent.KFPawn_ZedCrawler_Versus", ZedName="Versus Crawler"))
    ZedNames.Add((ZedClassPath="KFGameContent.KFPawn_ZedCrawlerKing", ZedName="EliteCrawler"))
    ZedNames.Add((ZedClassPath="KFGameContent.KFPawn_ZedStalker", ZedName="Stalker"))
    ZedNames.Add((ZedClassPath="KFGameContent.KFPawn_ZedStalker_Versus", ZedName="Versus Stalker"))
    ZedNames.Add((ZedClassPath="KFGameContent.KFPawn_ZedHusk", ZedName="Husk"))
    ZedNames.Add((ZedClassPath="KFGameContent.KFPawn_ZedHusk_Versus", ZedName="Versus Husk"))
    ZedNames.Add((ZedClassPath="KFGameContent.KFPawn_ZedBloat", ZedName="Bloat"))
    ZedNames.Add((ZedClassPath="KFGameContent.KFPawn_ZedBloat_Versus", ZedName="Versus Bloat"))
    ZedNames.Add((ZedClassPath="KFGameContent.KFPawn_ZedSiren", ZedName="Siren"))
    ZedNames.Add((ZedClassPath="KFGameContent.KFPawn_ZedSiren_Versus", ZedName="Versus Siren"))
    ZedNames.Add((ZedClassPath="KFGameContent.KFPawn_ZedScrake", ZedName="Scrake"))
    ZedNames.Add((ZedClassPath="KFGameContent.KFPawn_ZedScrake_Versus", ZedName="Versus Scrake"))
    ZedNames.Add((ZedClassPath="KFGameContent.KFPawn_ZedFleshpound", ZedName="Fleshpound"))
    ZedNames.Add((ZedClassPath="KFGameContent.KFPawn_ZedFleshpound_Versus", ZedName="Versus Fleshpound"))
    ZedNames.Add((ZedClassPath="KFGameContent.KFPawn_ZedFleshpoundMini", ZedName="Quarterpound"))
    ZedNames.Add((ZedClassPath="KFGameContent.KFPawn_ZedDAR_EMP", ZedName="EDAR Trapper"))
    ZedNames.Add((ZedClassPath="KFGameContent.KFPawn_ZedDAR_Rocket", ZedName="EDAR Bomber"))
    ZedNames.Add((ZedClassPath="KFGameContent.KFPawn_ZedDAR_Laser", ZedName="EDAR Blaster"))
    ZedNames.Add((ZedClassPath="KFGameContent.KFPawn_ZedHans", ZedName="Hans"))
    ZedNames.Add((ZedClassPath="KFGameContent.KFPawn_ZedPatriarch", ZedName="Patriarch"))
    ZedNames.Add((ZedClassPath="KFGameContent.KFPawn_ZedFleshpoundKing", ZedName="King Fleshpound"))
    ZedNames.Add((ZedClassPath="KFGameContent.KFPawn_ZedBloatKing", ZedName="Abomination"))
    ZedNames.Add((ZedClassPath="KFGameContent.KFPawn_ZedMatriarch", ZedName="Matriarch"))
    ZedNames.Add((ZedClassPath="KFGameContent.KFPawn_ZedBloatKingSubspawn", ZedName="Abomination Spawn"))

    ZedNames.Add((ZedClassPath="CombinedCD2.CD_Pawn_ZedCystKing", ZedName="Cyst"))
    ZedNames.Add((ZedClassPath="CombinedCD2.CD_Pawn_ZedClot_Alpha_Regular", ZedName="Alpha Clot"))
    ZedNames.Add((ZedClassPath="CombinedCD2.CD_Pawn_ZedClot_Alpha_Special", ZedName="Rioter"))
    ZedNames.Add((ZedClassPath="CombinedCD2.CD_Pawn_ZedGorefast_Regular", ZedName="Gorefast"))
    ZedNames.Add((ZedClassPath="CombinedCD2.CD_Pawn_ZedGorefast_Special", ZedName="Gorefiend"))
    ZedNames.Add((ZedClassPath="CombinedCD2.CD_Pawn_ZedCrawler_Regular", ZedName="Crawler"))
    ZedNames.Add((ZedClassPath="CombinedCD2.CD_Pawn_ZedCrawler_Special", ZedName="Elite Crawler"))
    ZedNames.Add((ZedClassPath="CombinedCD2.CD_Pawn_ZedStalker_Regular", ZedName="Stalker"))
    ZedNames.Add((ZedClassPath="CombinedCD2.CD_Pawn_ZedHusk_Regular", ZedName="Husk"))
    ZedNames.Add((ZedClassPath="CombinedCD2.CD_Pawn_ZedFleshpound_RS", ZedName="Fleshpound"))
    ZedNames.Add((ZedClassPath="CombinedCD2.CD_Pawn_ZedFleshpound_NRS", ZedName="Fleshpound"))
    ZedNames.Add((ZedClassPath="CombinedCD2.CD_Pawn_ZedFleshpoundMini_RS", ZedName="Quarterpound"))
    ZedNames.Add((ZedClassPath="CombinedCD2.CD_Pawn_ZedFleshpoundMini_NRS", ZedName="Quarterpound"))
    ZedNames.Add((ZedClassPath="CombinedCD2.CD_Pawn_ZedStalker_Special", ZedName="EDAR"))
    ZedNames.Add((ZedClassPath="CombinedCD2.CD_Pawn_ZedHusk_Special", ZedName="EDAR"))
    ZedNames.Add((ZedClassPath="CombinedCD2.CD_Pawn_ZedBloatKing", ZedName="Abomination"))
}