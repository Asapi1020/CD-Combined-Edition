class KFScoreBoard extends KFScoreboard_Base
	dependson(Types);

var transient float RankXPos, LevelXPos, PerkXPos, PlayerXPos, HealthXPos, TimeXPos, KillsXPos, AssistXPos, CashXPos, DeathXPos, PingXPos, AccXPos, HuXPos;
var transient float SCXPos, MMXPos, WSFXPos, CSXPos, SPXPos, SMXPos, SCWBox, MMWBox, WSFWBox, CSWBox, SPWBox, SMWBox;
var transient float StatusWBox, PlayerWBox, LevelWBox, PerkWBox, CashWBox, KillsWBox, AssistWBox, HealthWBox, PingWBox, AccWBox, HuWBox;
var transient float NextScoreboardRefresh;

var int PlayerIndex;

var array<KFPlayerReplicationInfo> KFPRIArray;

var Color PingColor;
var float PingBars;

// Ranks
var array<RankInfo> CustomRanks;
var array<UIDRankRelation> RankRelations;

var YASSettings Settings;

// Localization
var localized string Players;
var localized string Spectators;
var localized string Rank;
var localized string State;
var localized string NoPerk;
var localized string Ready;
var localized string NotReady;
var localized string Unknown;
var localized string Dead;
var localized string Kills;
var localized string DamageDealt;
var localized string Dosh;
var localized string Ping;
var localized string SoloGameString;

function DrawMenu()
{
//	Setup
	local string S;
	local PlayerController PC;
	local KFPlayerReplicationInfo KFPRI;
	local array<KFPlayerReplicationInfo> SpectatorsArray;
	local CD_GameReplicationInfo CDGRI;
	local PlayerReplicationInfo PRI;
	local float XPos, YPos, YL, XL, FontScalar, XPoYASnter, BoxW, BoxX, BoxH, MinBoxW, DoshSize;
	local int i, j, NumSpec, NumPlayer, NumAlivePlayer, Width;
	local float BorderSize;

	PC = GetPlayer();
	if (KFGRI == None)
	{
		KFGRI = KFGameReplicationInfo(PC.WorldInfo.GRI);
		
		if (KFGRI == None)
			return;
	}
	CDGRI = CD_GameReplicationInfo(KFGRI);
//	Sort player list.
	if (NextScoreboardRefresh < PC.WorldInfo.TimeSeconds)
	{
		NextScoreboardRefresh = PC.WorldInfo.TimeSeconds + 0.1;

		for (i=(KFGRI.PRIArray.Length-1); i > 0; --i)
		{
			for (j=i-1; j >= 0; --j)
			{
				if (!InOrder(KFPlayerReplicationInfo(KFGRI.PRIArray[i]), KFPlayerReplicationInfo(KFGRI.PRIArray[j])))
				{
					PRI = KFGRI.PRIArray[i];
					KFGRI.PRIArray[i] = KFGRI.PRIArray[j];
					KFGRI.PRIArray[j] = PRI;
				}
			}
		}
	}

//	Check players.
	PlayerIndex = -1;
	NumPlayer = 0;
	for (i=(KFGRI.PRIArray.Length-1); i >= 0; --i)
	{
		KFPRI = KFPlayerReplicationInfo(KFGRI.PRIArray[i]);
		if (KFPRI == None)
			continue;
		if (KFPRI.bOnlySpectator)
		{
			++NumSpec;
			continue;
		}
		if (KFPRI.PlayerHealth > 0 && KFPRI.PlayerHealthPercent > 0 && KFPRI.GetTeamNum() == 0)
			++NumAlivePlayer;
		++NumPlayer;
	}

	KFPRIArray.Length = NumPlayer;
	j = KFPRIArray.Length;
	for (i=(KFGRI.PRIArray.Length-1); i >= 0; --i)
	{
		KFPRI = KFPlayerReplicationInfo(KFGRI.PRIArray[i]);
		if(KFPRI != None)
		{
			if (!KFPRI.bOnlySpectator)
			{
				KFPRIArray[--j] = KFPRI;
				if (KFPRI == PC.PlayerReplicationInfo)
					PlayerIndex = j;
			}
			else
			{
				SpectatorsArray.AddItem(KFPRI);
			}
		}
	}

	Canvas.Font = Owner.CurrentStyle.PickFont(FontScalar);
	Canvas.TextSize("ABC", XL, YL, FontScalar, FontScalar);
	BorderSize = Owner.HUDOwner.ScaledBorderSize;
	
//	Server Info
	XPoYASnter = Canvas.ClipX * 0.5;
	Width = Canvas.ClipX * 0.4; // Full Box Width
	XPos = XPoYASnter - Width * 0.5;
	YPos = YL;
	
	BoxW = Width;
	BoxX = XPos;
	BoxH = YL + BorderSize;
	
//	Top Rect (Server name)
	SetDrawColor(Canvas, Settings.Style.ServerNameBoxColor);
	Owner.CurrentStyle.DrawRectBox(BoxX, YPos, BoxW, BoxH, Settings.Style.EdgeSize, Settings.Style.ShapeServerNameBox);
	
	SetDrawColor(Canvas, Settings.Style.ServerNameTextColor);
	S = (PC.WorldInfo.NetMode == NM_StandAlone) ? SoloGameString : KFGRI.ServerName;
	DrawTextShadowHVCenter(S, BoxX, YPos, BoxW, FontScalar);
	
	YPos += BoxH;
	
//	Mid Left Rect (Info)
	BoxW = Width * 0.7;
	BoxH = YL * 2 + BorderSize * 2;
	SetDrawColor(Canvas, Settings.Style.GameInfoBoxColor);
	Owner.CurrentStyle.DrawRectBox(BoxX, YPos, BoxW, BoxH, Settings.Style.EdgeSize, Settings.Style.ShapeGameInfoBox);
	
	SetDrawColor(Canvas, Settings.Style.GameInfoTextColor);
	S = class'KFCommon_LocalizedStrings'.static.GetFriendlyMapName(PC.WorldInfo.GetMapName(true));
	S = class'CD_Object'.static.GetCustomMapName(S);
	DrawTextShadowHLeftVCenter(S, BoxX + Settings.Style.EdgeSize, YPos, FontScalar);
	
	S = KFGRI.GameClass.default.GameName $ " - " $ class'KFCommon_LocalizedStrings'.Static.GetDifficultyString(KFGRI.GameDifficulty);
	DrawTextShadowHLeftVCenter(S, BoxX + Settings.Style.EdgeSize, YPos + YL, FontScalar);
	
//	Mid Right Rect (Wave)
	BoxX = BoxX + BoxW;
	BoxW = Width - BoxW;
	SetDrawColor(Canvas, Settings.Style.WaveBoxColor);
	Owner.CurrentStyle.DrawRectBox(BoxX, YPos, BoxW, BoxH, Settings.Style.EdgeSize, Settings.Style.ShapeWaveInfoBox);
	
	SetDrawColor(Canvas, Settings.Style.WaveTextColor);
	S = class'KFGFxHUD_ScoreboardMapInfoContainer'.default.WaveString; 
	DrawTextShadowHVCenter(S, BoxX, YPos, BoxW, FontScalar);
	DrawTextShadowHVCenter(WaveText(), BoxX, YPos + YL, BoxW, FontScalar);
	
	YPos += BoxH;
	
//	Bottom Rect (Players count)
	BoxX = XPos;
	BoxW = Width;
	BoxH = YL + BorderSize;
	SetDrawColor(Canvas, Settings.Style.PlayerCountBoxColor);
	Owner.CurrentStyle.DrawRectBox(BoxX, YPos, BoxW, BoxH, Settings.Style.EdgeSize, Settings.Style.ShapePlayersCountBox);
	
	SetDrawColor(Canvas, Settings.Style.PlayerCountTextColor);
	S = Players$": " $ NumPlayer $ " / " $ KFGRI.MaxHumanCount $ "    " $ Spectators $ ": " $ NumSpec; 
	Canvas.TextSize(S, XL, YL, FontScalar, FontScalar);
	DrawTextShadowHLeftVCenter(S, BoxX + Settings.Style.EdgeSize, YPos, FontScalar);
	
	S = Owner.CurrentStyle.GetTimeString(KFGRI.ElapsedTime);
	DrawTextShadowHVCenter(S, XPos + Width * 0.7, YPos, Width * 0.3, FontScalar);
	
	YPos += BoxH;

//	CDInfo
	Width = Canvas.ClipX * 0.55;
	XPos = Canvas.ClipX * 0.225;
	YPos += YL;
	SetDrawColor(Canvas, Settings.Style.ListHeaderBoxColor);
		Owner.CurrentStyle.DrawRectBox(	XPos - BorderSize * 2,
		YPos,
		Width + BorderSize * 4,
		BoxH,
		Settings.Style.EdgeSize,
		Settings.Style.ShapeHeaderBox);

	MinBoxW = Width * 0.166; // minimum width for column 
	Canvas.TextSize("SpawnMod ", XL, YL, FontScalar, FontScalar);
	SMXPos = Width - (XL < MinBoxW ? MinBoxW : XL);
	Canvas.TextSize("SpawnPoll ", XL, YL, FontScalar, FontScalar);
	SPXPos = SMXPos - (XL < MinBoxW ? MinBoxW : XL);
	Canvas.TextSize("CohortSize ", XL, YL, FontScalar, FontScalar);
	CSXPos = SPXPos - (XL < MinBoxW ? MinBoxW : XL);
	Canvas.TextSize("WaveSizeFakes ", XL, YL, FontScalar, FontScalar);
	WSFXPos = CSXPos - (XL < MinBoxW ? MinBoxW : XL);
	Canvas.TextSize("MaxMonsters ", XL, YL, FontScalar, FontScalar);
	MMXPos = WSFXPos - (XL < MinBoxW ? MinBoxW : XL);
	Canvas.TextSize("SpawnCycle ", XL, YL, FontScalar, FontScalar);
	SCXPos = MMXPos - (XL < MinBoxW ? MinBoxW : XL);	
		
	SCWBox  = MMXPos - SCXPos;
	MMWBox  = WSFXPos - MMXPos;
	WSFWBox = CSXPos - WSFXPos;
	CSWBox  = SPXPos - CSXPos;
	SPWBox  = SMXPos - SPXPos;
	SMWBox  = Width - SMXPos;

//	Header texts
	SetDrawColor(Canvas, Settings.Style.ListHeaderTextColor);
	DrawTextShadowHVCenter("SpawnCycle", XPos + SCXPos, YPos, SCWBox, FontScalar);
	DrawTextShadowHVCenter("MaxMonsters", XPos + MMXPos, YPos, MMWBox, FontScalar);
	DrawTextShadowHVCenter("WaveSizeFakes", XPos + WSFXPos, YPos, WSFWBox, FontScalar);
	DrawTextShadowHVCenter("CohortSize", XPos + CSXPos, YPos, CSWBox, FontScalar);
	DrawTextShadowHVCenter("SpawnPoll", XPos + SPXPos, YPos, SPWBox, FontScalar);
	DrawTextShadowHVCenter("SpawnMod", XPos + SMXPos, YPos, SMWBox, FontScalar);

	YPos += BoxH;

	Canvas.SetDrawColor(30,30,30,200);
		Owner.CurrentStyle.DrawRectBox(	XPos - BorderSize * 2,
		YPos,
		Width + BorderSize * 4,
		BoxH,
		Settings.Style.EdgeSize,
		0);

	SetDrawColor(Canvas, Settings.Style.ListHeaderTextColor);
	DrawTextShadowHVCenter(CDGRI.CDInfoParams.SC, XPos + SCXPos, YPos, SCWBox, FontScalar);
	DrawTextShadowHVCenter(CDGRI.CDInfoParams.MM, XPos + MMXPos, YPos, MMWBox, FontScalar);
	DrawTextShadowHVCenter(CDGRI.CDInfoParams.WSF, XPos + WSFXPos, YPos, WSFWBox, FontScalar);
	DrawTextShadowHVCenter(CDGRI.CDInfoParams.CS, XPos + CSXPos, YPos, CSWBox, FontScalar);
	DrawTextShadowHVCenter(CDGRI.CDInfoParams.SP, XPos + SPXPos, YPos, SPWBox, FontScalar);
	DrawTextShadowHVCenter(CDGRI.CDInfoParams.SM, XPos + SMXPos, YPos, SMWBox, FontScalar);

	YPos += BoxH;

//	Player Info Header
	Width = Canvas.ClipX * 0.7;
	XPos = (Canvas.ClipX - Width) * 0.5;
	YPos += YL;
	BoxH = YL + BorderSize;
	SetDrawColor(Canvas, Settings.Style.ListHeaderBoxColor);
		Owner.CurrentStyle.DrawRectBox(	XPos - BorderSize * 2,
		YPos,
		Width + BorderSize * 4,
		BoxH,
		Settings.Style.EdgeSize,
		Settings.Style.ShapeHeaderBox);

//	Calc X offsets
	MinBoxW    = Width * 0.09; // minimum width for column 
	
	RankXPos   = Owner.HUDOwner.ScaledBorderSize * 8 + Settings.Style.EdgeSize;
	PlayerXPos = Width * 0.20;
	
	Canvas.TextSize("Ping ", XL, YL, FontScalar, FontScalar);
	PingXPos = Width - (XL < MinBoxW ? MinBoxW : XL);
	
	Canvas.TextSize("State ", XL, YL, FontScalar, FontScalar);
	HealthXPos = PingXPos - (XL < MinBoxW ? MinBoxW : XL);

	Canvas.TextSize("Damage ", XL, YL, FontScalar, FontScalar);
	AssistXPos = HealthXPos - (XL < MinBoxW ? MinBoxW : XL);
	
	Canvas.TextSize("Kills ", XL, YL, FontScalar, FontScalar);
	KillsXPos = AssistXPos - (XL < MinBoxW ? MinBoxW : XL);
	
	Canvas.TextSize("Dosh ", XL, YL, FontScalar, FontScalar);
	Canvas.TextSize("999999", DoshSize, YL, FontScalar, FontScalar);
	CashXPos = KillsXPos - (XL < DoshSize ? DoshSize : XL);
	
	BoxW = 0;
	foreach PerkNames(S)
	{
		Canvas.TextSize(S$"A", XL, YL, FontScalar, FontScalar);
		if (XL > BoxW) BoxW = XL;
	}
	PerkXPos = CashXPos - (BoxW < MinBoxW ? MinBoxW : BoxW);
	
	Canvas.TextSize("000", XL, YL, FontScalar, FontScalar);
	LevelXPos = PerkXPos - XL;
	
	StatusWBox = PlayerXPos - RankXPos;
	PlayerWBox = LevelXPos  - PlayerXPos;
	LevelWBox  = PerkXPos   - LevelXPos;
	PerkWBox   = CashXPos   - PerkXPos;
	CashWBox   = KillsXPos  - CashXPos;
	KillsWBox  = AssistXPos - KillsXPos;
	AssistWBox = HealthXPos - AssistXPos;
	HealthWBox = PingXPos   - HealthXPos;
	PingWBox   = Width	    - PingXPos;

//	Header texts
	SetDrawColor(Canvas, Settings.Style.ListHeaderTextColor);
	DrawTextShadowHLeftVCenter(Rank, XPos + RankXPos, YPos, FontScalar);
	DrawTextShadowHLeftVCenter(class'KFGFxHUD_ScoreboardWidget'.default.PlayerString, XPos + PlayerXPos, YPos, FontScalar);
	DrawTextShadowHLeftVCenter(class'KFGFxMenu_Inventory'.default.PerkFilterString, XPos + PerkXPos, YPos, FontScalar);
	DrawTextShadowHVCenter(Kills, XPos + KillsXPos, YPos, KillsWBox, FontScalar);
	DrawTextShadowHVCenter(DamageDealt, XPos + AssistXPos, YPos, AssistWBox, FontScalar);
	DrawTextShadowHVCenter(Dosh, XPos + CashXPos, YPos, CashWBox, FontScalar);
	DrawTextShadowHVCenter(State, XPos + HealthXPos, YPos, HealthWBox, FontScalar);
	DrawTextShadowHVCenter(Ping, XPos + PingXPos, YPos, PingWBox, FontScalar);

//	Player List
	PlayersList.XPosition = ((Canvas.ClipX - Width) * 0.5) / InputPos[2];
	PlayersList.YPosition = (YPos + YL + BorderSize * 4) / InputPos[3];
	PlayersList.YSize = ((1.f - PlayersList.YPosition) - 0.15)*6/7;

	PlayersList.ChangeListSize(KFPRIArray.Length);

//	Spectators Info
	if(PC.WorldInfo.NetMode != NM_Standalone)
	{
		Width = Canvas.ClipX * 0.55;
		XPos = Canvas.ClipX * 0.225;
		YPos += YL*2 + BorderSize*4 + PlayersList.CompPos[3];
		SetDrawColor(Canvas, Settings.Style.ListHeaderBoxColor);
			Owner.CurrentStyle.DrawRectBox(	XPos - BorderSize * 2,
			YPos,
			Width + BorderSize * 4,
			BoxH,
			Settings.Style.EdgeSize,
			0);

		SetDrawColor(Canvas, Settings.Style.ListHeaderTextColor);
		S = Spectators $ ":";
		for(i=0; i<SpectatorsArray.length; i++)
		{
			if(i>0)
				S $= ",";
				
			S @= SpectatorsArray[i].PlayerName;
		}
		
		DrawTextShadowHLeftVCenter(S, XPos, YPos, FontScalar);
	}
}

function DrawPlayerEntry(Canvas C, int Index, float YOffset, float Height, float Width, bool bFocus)
{
	local string S, StrValue;
	local float FontScalar, TextYOffset, XL, YL, PerkIconPosX, PerkIconPosY, PerkIconSize, PrestigeIconScale;
	local float XPos, BoxWidth, RealPlayerWBox;
	local KFPlayerReplicationInfo KFPRI;
	local byte Level, PrestigeLevel;
	local bool bIsZED;
	local int PingInt;
	
	local RankInfo CurrentRank;
	local bool HasRank;
	local int PlayerInfoIndex, PlayerRankIndex;
	local int Shape;

	YOffset *= 1.05;
	KFPRI = KFPRIArray[Index];
	
	HasRank = false;

	PlayerInfoIndex = RankRelations.Find('UID', KFPRI.UniqueId);
	if (PlayerInfoIndex != INDEX_NONE && RankRelations[PlayerInfoIndex].RankID != INDEX_NONE)
	{
		PlayerRankIndex = CustomRanks.Find('ID', RankRelations[PlayerInfoIndex].RankID);
		if (PlayerRankIndex != INDEX_NONE)
		{
			HasRank = true;
			CurrentRank = CustomRanks[PlayerRankIndex];
		}
	}
	
	if (KFPRI.bAdmin || CD_PlayerReplicationInfo(KFPRI).AuthorityLevel > 3)
	{
		if (!HasRank || (HasRank && !CurrentRank.OverrideAdminRank))
		{
			CurrentRank.Rank = Settings.Admin.Rank;
			CurrentRank.TextColor = Settings.Admin.TextColor;
			CurrentRank.ApplyColorToFields = Settings.Admin.ApplyColorToFields;
			HasRank = true;
		}
	}
	else // Player
	{
		if (!HasRank)
		{
			CurrentRank.Rank = Settings.Player.Rank;
			CurrentRank.TextColor = Settings.Player.TextColor;
			CurrentRank.ApplyColorToFields = Settings.Player.ApplyColorToFields;
			HasRank = true;
		}
	}
	// Now all players belongs to 'Rank'

	if (KFGRI.bVersusGame)
		bIsZED = KFTeamInfo_Zeds(KFPRI.Team) != None;

	XPos = 0.f;

	C.Font = Owner.CurrentStyle.PickFont(FontScalar);

	Canvas.TextSize("ABC", XL, YL, FontScalar, FontScalar);
	
	// change rect color by HP
	if (!KFPRI.bReadyToPlay && KFGRI.bMatchHasBegun)
	{
		SetDrawColor(C, Settings.Style.LeftStateBoxColor);
	}
	else if (!KFGRI.bMatchHasBegun)
	{
		SetDrawColor(C, Settings.Style.LeftStateBoxColor);
	}
	else if (bIsZED && KFTeamInfo_Zeds(GetPlayer().PlayerReplicationInfo.Team) == None)
	{
		SetDrawColor(C, Settings.Style.LeftStateBoxColor);
	}
	else if (KFPRI.PlayerHealth <= 0 || KFPRI.PlayerHealthPercent <= 0)
	{
		SetDrawColor(C, Settings.Style.LeftStateBoxColorDead);
	}
	else
	{
		if (ByteToFloat(KFPRI.PlayerHealthPercent) >= float(Settings.State.High) / 100.0)
			SetDrawColor(C, Settings.Style.LeftStateBoxColorHigh);
		else if (ByteToFloat(KFPRI.PlayerHealthPercent) >= float(Settings.State.Low) / 100.0)
			SetDrawColor(C, Settings.Style.LeftStateBoxColorMid);
		else
			SetDrawColor(C, Settings.Style.LeftStateBoxColorLow);
	}
	
	if (!Settings.State.Dynamic)
		SetDrawColor(C, Settings.Style.LeftStateBoxColor);

	if (KFPRIArray.Length > 1 && Index == 0)
		Shape = Settings.Style.ShapeLeftStateBoxTopPlayer;
	else if (KFPRIArray.Length > 1 && Index == KFPRIArray.Length - 1)
		Shape = Settings.Style.ShapeLeftStateBoxBottomPlayer;
	else
		Shape = Settings.Style.ShapeLeftStateBoxMidPlayer;
	
	BoxWidth = Owner.HUDOwner.ScaledBorderSize * 8;
	Owner.CurrentStyle.DrawRectBox(	XPos,
		YOffset,
		BoxWidth,
		Height,
		Settings.Style.EdgeSize,
		Shape);
		
	XPos += BoxWidth;
	
	TextYOffset = YOffset + (Height * 0.5f) - (YL * 0.5f);
	if (PlayerIndex == Index)
		SetDrawColor(C, Settings.Style.PlayerOwnerBoxColor);
	else
		SetDrawColor(C, Settings.Style.PlayerBoxColor);

	if (KFPRIArray.Length > 1 && Index == 0)
		Shape = Settings.Style.ShapePlayerBoxTopPlayer;
	else if (KFPRIArray.Length > 1 && Index == KFPRIArray.Length - 1)
		Shape = Settings.Style.ShapePlayerBoxBottomPlayer;
	else
		Shape = Settings.Style.ShapePlayerBoxMidPlayer;

	BoxWidth = CashXPos - BoxWidth - Owner.HUDOwner.ScaledBorderSize * 2;
	Owner.CurrentStyle.DrawRectBox(XPos, YOffset, BoxWidth, Height, Settings.Style.EdgeSize, Shape);
	
	XPos += BoxWidth;
	
	// Right stats box
	if (KFPRIArray.Length > 1 && Index == 0)
		Shape = Settings.Style.ShapeStatsBoxTopPlayer;
	else if (KFPRIArray.Length > 1 && Index == KFPRIArray.Length - 1)
		Shape = Settings.Style.ShapeStatsBoxBottomPlayer;
	else
		Shape = Settings.Style.ShapeStatsBoxMidPlayer;
	
	BoxWidth = Width - XPos;
	SetDrawColor(C, Settings.Style.StatsBoxColor);
	Owner.CurrentStyle.DrawRectBox(	XPos,
		YOffset,
		BoxWidth,
		Height,
		Settings.Style.EdgeSize,
		Shape);

	// Rank
	if (CurrentRank.ApplyColorToFields.Rank)
		SetDrawColor(C, CurrentRank.TextColor);
	else
		SetDrawColor(C, Settings.Style.RankTextColor);
	S = CurrentRank.Rank;
	DrawTextShadowHLeftVCenter(S, RankXPos, TextYOffset, FontScalar);

	// Perk
	RealPlayerWBox = PlayerWBox;
	if (bIsZED)
	{
		if (CurrentRank.ApplyColorToFields.Perk)
			SetDrawColor(C, CurrentRank.TextColor);
		else
			SetDrawColor(C, Settings.Style.ZedTextColor);
		C.SetPos (PerkXPos, YOffset - ((Height-5) * 0.5f));
		C.DrawRect (Height-5, Height-5, Texture2D'UI_Widgets.MenuBarWidget_SWF_IF');

		S = class'KFCommon_LocalizedStrings'.default.ZedString;
		DrawTextShadowHLeftVCenter(S, PerkXPos + Height, TextYOffset, FontScalar);
		RealPlayerWBox = PerkXPos + Height - PlayerXPos;
	}
	else
	{
		if (KFPRI.CurrentPerkClass != None)
		{
			PrestigeLevel = KFPRI.GetActivePerkPrestigeLevel();
			Level = KFPRI.GetActivePerkLevel();

			PerkIconPosY = YOffset + (Owner.HUDOwner.ScaledBorderSize * 2);
			PerkIconSize = Height-(Owner.HUDOwner.ScaledBorderSize * 4);
			PerkIconPosX = LevelXPos - PerkIconSize - (Owner.HUDOwner.ScaledBorderSize*2);
			PrestigeIconScale = 0.6625f;

			RealPlayerWBox = PerkIconPosX - PlayerXPos;

			C.DrawColor = HUDOwner.WhiteColor;
			if (PrestigeLevel > 0)
			{
				C.SetPos(PerkIconPosX, PerkIconPosY);
				C.DrawTile(KFPRI.CurrentPerkClass.default.PrestigeIcons[PrestigeLevel - 1], PerkIconSize, PerkIconSize, 0, 0, 256, 256);

				C.SetPos(PerkIconPosX + ((PerkIconSize/2) - ((PerkIconSize*PrestigeIconScale)/2)), PerkIconPosY + ((PerkIconSize/2) - ((PerkIconSize*PrestigeIconScale)/1.75)));
				C.DrawTile(KFPRI.CurrentPerkClass.default.PerkIcon, PerkIconSize * PrestigeIconScale, PerkIconSize * PrestigeIconScale, 0, 0, 256, 256);
			}
			else
			{
				C.SetPos(PerkIconPosX, PerkIconPosY);
				C.DrawTile(KFPRI.CurrentPerkClass.default.PerkIcon, PerkIconSize, PerkIconSize, 0, 0, 256, 256);
			}
			
			if (CurrentRank.ApplyColorToFields.Level)
				SetDrawColor(C, CurrentRank.TextColor);
			else if (!Settings.Level.Dynamic)
				SetDrawColor(C, Settings.Style.LevelTextColor);
			else
			{
				if (Level < Settings.Level.Low[KFGRI.GameDifficulty])
					SetDrawColor(C, Settings.Style.LevelTextColorLow);
				else if (Level < Settings.Level.High[KFGRI.GameDifficulty])
					SetDrawColor(C, Settings.Style.LevelTextColorMid);
				else
					SetDrawColor(C, Settings.Style.LevelTextColorHigh);
			}
			S = String(Level);
			DrawTextShadowHLeftVCenter(S, LevelXPos, TextYOffset, FontScalar);

			if (CurrentRank.ApplyColorToFields.Level)
				SetDrawColor(C, CurrentRank.TextColor);
			else
				SetDrawColor(C, Settings.Style.LevelTextColor);
			S = KFPRI.CurrentPerkClass.default.PerkName;
			DrawTextShadowHLeftVCenter(S, PerkXPos, TextYOffset, FontScalar);
		}
		else
		{
			if (CurrentRank.ApplyColorToFields.Perk)
				SetDrawColor(C, CurrentRank.TextColor);
			else
				SetDrawColor(C, Settings.Style.PerkTextColor);
			S = NoPerk;
			DrawTextShadowHLeftVCenter(S, PerkXPos, TextYOffset, FontScalar);
			RealPlayerWBox = PerkXPos - PlayerXPos;
		}
	}

	// Avatar
	if (KFPRI.Avatar != None)
	{
		if (KFPRI.Avatar == default.DefaultAvatar)
			CheckAvatar(KFPRI, OwnerPC);

		C.SetDrawColor(255, 255, 255, 255);
		C.SetPos(PlayerXPos - (Height * 1.075), YOffset + (Height * 0.5f) - ((Height - 6) * 0.5f));
		C.DrawTile(KFPRI.Avatar, Height - 6, Height - 6, 0,0, KFPRI.Avatar.SizeX, KFPRI.Avatar.SizeY);
		Owner.CurrentStyle.DrawBoxHollow(PlayerXPos - (Height * 1.075), YOffset + (Height * 0.5f) - ((Height - 6) * 0.5f), Height - 6, Height - 6, 1);
	}
	else if (!KFPRI.bBot)
		CheckAvatar(KFPRI, OwnerPC);

	// Player
	if (CurrentRank.ApplyColorToFields.Player)
		SetDrawColor(C, CurrentRank.TextColor);
	else
		SetDrawColor(C, Settings.Style.PlayerNameTextColor);
	S = KFPRI.PlayerName;
	Canvas.TextSize(S, XL, YL, FontScalar, FontScalar);
	while (XL > RealPlayerWBox)
	{
		S = Left(S, Len(S)-1);
		Canvas.TextSize(S, XL, YL, FontScalar, FontScalar);
	}
	DrawTextShadowHLeftVCenter(S, PlayerXPos, TextYOffset, FontScalar);

	// Kill
	if (CurrentRank.ApplyColorToFields.Kills)
		SetDrawColor(C, CurrentRank.TextColor);
	else
		SetDrawColor(C, Settings.Style.KillsTextColor);
	DrawTextShadowHVCenter(string (KFPRI.Kills), KillsXPos, TextYOffset, KillsWBox, FontScalar);

	// Assist // Damage Dealt
	if (CurrentRank.ApplyColorToFields.Assists)
		SetDrawColor(C, CurrentRank.TextColor);
	else
		SetDrawColor(C, Settings.Style.AssistsTextColor);
	DrawTextShadowHVCenter(class'CD_Object'.static.AddCommaToInt(CD_PlayerReplicationInfo(KFPRI).DmgD), AssistXPos, TextYOffset, AssistWBox, FontScalar);

	// Cash
	if (bIsZED)
	{
		SetDrawColor(C, Settings.Style.ZedTextColor);
		StrValue = "-";
	}
	else
	{
		if (CurrentRank.ApplyColorToFields.Dosh)
			SetDrawColor(C, CurrentRank.TextColor);
		else
			SetDrawColor(C, Settings.Style.DoshTextColor);
		StrValue = String(int(KFPRI.Score)); //StrValue = GetNiceSize(int(KFPRI.Score));
	}
	DrawTextShadowHVCenter(StrValue, CashXPos, TextYOffset, CashWBox, FontScalar);

	// State
	if (!KFPRI.bReadyToPlay && KFGRI.bMatchHasBegun)
	{
		SetDrawColor(C, Settings.Style.StateTextColorLobby);
		S = class'KFGFxMenu_ServerBrowser'.default.InLobbyString;
	}
	else if (!KFGRI.bMatchHasBegun || KFPRI.bWaitingPlayer)
	{
		if (KFPRI.bReadyToPlay)
		{
			SetDrawColor(C, Settings.Style.StateTextColorReady);
			S = Ready;
		}
		else
		{
			SetDrawColor(C, Settings.Style.StateTextColorNotReady);
			S = NotReady;
		}
	}
	else if (KFGRI.bTraderIsOpen)
	{
		if (CD_PlayerReplicationInfo(KFPRI).bIsReadyForNextWave)
		{
			SetDrawColor(C, Settings.Style.PingTextColorLow);
			S = Ready;
		}
		else
		{
			SetDrawColor(C, Settings.Style.PingTextColorHigh);
			S = NotReady;
		}
	}
	else if (bIsZED && KFTeamInfo_Zeds(GetPlayer().PlayerReplicationInfo.Team) == None)
	{
		SetDrawColor(C, Settings.Style.StateTextColor);
		S = Unknown;
	}
	else if (KFPRI.PlayerHealth <= 0 || KFPRI.PlayerHealthPercent <= 0)
	{
		if (KFPRI.bOnlySpectator)
		{
			SetDrawColor(C, Settings.Style.StateTextColorSpectator);
			S = class'KFCommon_LocalizedStrings'.default.SpectatorString;
		}
		else
		{
			SetDrawColor(C, Settings.Style.StateTextColorDead);
			S = Dead;
		}
	}
	else
	{
		if (ByteToFloat(KFPRI.PlayerHealthPercent) >= float(Settings.State.High) / 100.0)
			SetDrawColor(C, Settings.Style.StateTextColorHighHP);
		else if (ByteToFloat(KFPRI.PlayerHealthPercent) >= float(Settings.State.Low) / 100.0)
			SetDrawColor(C, Settings.Style.StateTextColorMidHP);
		else
			SetDrawColor(C, Settings.Style.StateTextColorLowHP);
		S = string(KFPRI.PlayerHealth)@"HP";
	}
	
	if (CurrentRank.ApplyColorToFields.Health)
		SetDrawColor(C, CurrentRank.TextColor);
	else if (!Settings.State.Dynamic)
		SetDrawColor(C, Settings.Style.StateTextColor);
	DrawTextShadowHVCenter(S, HealthXPos, TextYOffset, HealthWBox, FontScalar);

	// Ping
	if (KFPRI.bBot)
	{
		SetDrawColor(C, Settings.Style.PingTextColor);
		S = "-";
	}
	else
	{
		PingInt = int(KFPRI.Ping * `PING_SCALE);

		if (CurrentRank.ApplyColorToFields.Ping)
			SetDrawColor(C, CurrentRank.TextColor);
		else if (PingInt <= Settings.Ping.Low)
			SetDrawColor(C, Settings.Style.PingTextColorLow);
		else if (PingInt <= Settings.Ping.High)
			SetDrawColor(C, Settings.Style.PingTextColorMid);
		else
			SetDrawColor(C, Settings.Style.PingTextColorHigh);

		S = string(PingInt);
	}

	C.TextSize(S, XL, YL, FontScalar, FontScalar);
	DrawTextShadowHVCenter(S, PingXPos, TextYOffset, Settings.Ping.ShowPingBars ? PingWBox/2 : PingWBox, FontScalar);
	C.SetDrawColor(250, 250, 250, 255);
	if (Settings.Ping.ShowPingBars)
		DrawPingBars(C, YOffset + (Height/2) - ((Height*0.5)/2), Width - (Height*0.5) - (Owner.HUDOwner.ScaledBorderSize*2), Height*0.5, Height*0.5, float(PingInt));
}

final function DrawPingBars(Canvas C, float YOffset, float XOffset, float W, float H, float PingFloat)
{
	local float PingMul, BarW, BarH, BaseH, XPos, YPos;
	local byte i;

	PingMul = 1.f - FClamp(FMax(PingFloat - Settings.Ping.Low, 1.f) / Settings.Ping.High, 0.f, 1.f);
	BarW = W / PingBars;
	BaseH = H / PingBars;

	PingColor.R = (1.f - PingMul) * 255;
	PingColor.G = PingMul * 255;

	for (i=1; i < PingBars; i++)
	{
		BarH = BaseH * i;
		XPos = XOffset + ((i - 1) * BarW);
		YPos = YOffset + (H - BarH);

		C.SetPos(XPos, YPos);
		C.SetDrawColor(20, 20, 20, 255);
		Owner.CurrentStyle.DrawWhiteBox(BarW, BarH);

		if (PingMul >= (i / PingBars))
		{
			C.SetPos(XPos, YPos);
			C.DrawColor = PingColor;
			Owner.CurrentStyle.DrawWhiteBox(BarW, BarH);
		}

		C.SetDrawColor(80, 80, 80, 255);
		Owner.CurrentStyle.DrawBoxHollow(XPos, YPos, BarW, BarH, 1);
	}
}

defaultproperties
{
	bEnableInputs=true

	PingColor=(R=255, G=255, B=60, A=255)
	PingBars=5.0

	Begin Object Class=KFGUI_List Name=PlayerList
		XSize=0.7
		OnDrawItem=DrawPlayerEntry
		ID="PlayerList"
		bClickable=false
		ListItemsPerPage=6 //16
	End Object
	Components.Add(PlayerList)	
}