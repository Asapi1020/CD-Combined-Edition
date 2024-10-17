Class xUI_MapVote extends xUI_MenuBase;

var xVotingReplication RepInfo;

var KFGUI_ColumnList CurrentVotes, MapList, GameModeList;
var KFGUI_ColumnList StatsList, CategoryKillList, WeapDmgList, ZedKillList;
var KFGUI_RightClickMenu MapRClicker;
var editinline export KFGUI_RightClickMenu MapRightClick;
var KFGUI_Button TeamAward, PlayerStats, MapVote, CloseButton;
var KFGUI_ComboBox GameModeCombo;

var int SelectedMapIndex, SelectedModeIndex;
var bool bListUpdate;
var bool bFirstTime;
var name CurState;

/*** Localization ***/
//	MapVote
var localized string CloseButtonToolTip;
var localized string ColumnMapName;
var localized string ColumnGame;
var localized string ColumnNumVotes;
var localized string ColumnGameMode;
var localized string MatchResultButtonText;
var localized string ResultButtonToolTip;
var localized string VoteMapString;
var localized string AdminForceString;
var localized string GameModeLableString;
var localized string GameModeToolTip;

//	Result
var localized string TeamAwardButtonText;
var localized string PlayerStatsButtonText;
var localized string MapVoteButtonText;
var localized string DamageDealtString;
var localized string HitAccuracyString;
var localized string KillsString;
var localized string HuskKillsString;
var localized string HealthString;
var localized string HSAccuracyString;
var localized string LargeKillsString;
var localized string DamageTakenString;
var localized string DamageDealerString;
var localized string PrecisionString;
var localized string ZedSlayerString;
var localized string HuskSlayerString;
var localized string MedicineMasterString;
var localized string HeadPopperString;
var localized string GiantSlayerString;
var localized string GuardianString;
var localized string HealsGivenString;
var localized string HealsReceivedString;
var localized string RobotKillsString;
var localized string BossKillsString;
var localized string TotalKillsString;
var localized string MediumKillsString;
var localized string TrashKillsString;

//	PlayerStats
var localized string StatsString;
var localized string CategoryString;
var localized string DeathsString;

function InitMenu()
{
	GameModeCombo = KFGUI_ComboBox(FindComponentID('Filter'));
	GameModeCombo.LableString = GameModeLableString;
	GameModeCombo.ToolTip = GameModeToolTip;

	Super.InitMenu();

	//	Player Stats
	StatsList        = KFGUI_ColumnList(FindComponentID('Stats'));
	CategoryKillList = KFGUI_ColumnList(FindComponentID('CategoryKill'));
	WeapDmgList 	 = KFGUI_ColumnList(FindComponentID('WeapDmg'));
	ZedKillList      = KFGUI_ColumnList(FindComponentID('ZedKill'));

	StatsList.Columns.AddItem(newFColumnItem(StatsString, 0.5));
	StatsList.Columns.AddItem(newFColumnItem("", 0.5));
	CategoryKillList.Columns.AddItem(newFColumnItem(CategoryString, 0.4));
	CategoryKillList.Columns.AddItem(newFColumnItem(KillsString, 0.25));
	CategoryKillList.Columns.AddItem(newFColumnItem("%", 0.25));
	WeapDmgList.Columns.AddItem(newFColumnItem(class'xUI_AdminMenu'.default.WeaponHeader, 0.4));
	WeapDmgList.Columns.AddItem(newFColumnItem(ParseLocalizedPropertyPath("CombinedCD2.CD_StatsSystem.DamageString"), 0.15));
	WeapDmgList.Columns.AddItem(newFColumnItem(ParseLocalizedPropertyPath("KFGame.EphemeralMatchStats.EPB_HeadShotsValue"), 0.15));
	WeapDmgList.Columns.AddItem(newFColumnItem(LargeKillsString, 0.15));
	WeapDmgList.Columns.AddItem(newFColumnItem(KillsString, 0.15));
	ZedKillList.Columns.AddItem(newFColumnItem("ZED", 0.5));
	ZedKillList.Columns.AddItem(newFColumnItem(KillsString, 0.25));
	ZedKillList.Columns.AddItem(newFColumnItem("%", 0.25));

	//	MapVote
	CurrentVotes = KFGUI_ColumnList(FindComponentID('Votes'));
	MapList      = KFGUI_ColumnList(FindComponentID('Maps'));
	//GameModeList = KFGUI_ColumnList(FindComponentID('Modes'));
	
	MapRClicker = KFGUI_RightClickMenu(FindComponentID('RClick'));
	
	MapList.Columns.AddItem(newFColumnItem(ColumnMapName,1.f));
	GameModeList.Columns.AddItem(newFColumnItem(ColumnGameMode,1.f));
	CurrentVotes.Columns.AddItem(newFColumnItem(ColumnGame,0.3));
	CurrentVotes.Columns.AddItem(newFColumnItem(ColumnMapName,0.47));
	CurrentVotes.Columns.AddItem(newFColumnItem(ColumnNumVotes,0.23));

	MapRightClick.ItemRows.Add(2);
	MapRightClick.ItemRows[0].Text=VoteMapString;
	MapRightClick.ItemRows[1].Text=AdminForceString;
	MapRightClick.ItemRows[1].bDisabled = true;

	// Button
	TeamAward = KFGUI_Button(FindComponentID('TeamAward'));
	TeamAward.ButtonText = TeamAwardButtonText;

	PlayerStats = KFGUI_Button(FindComponentID('PlayerStats'));
	PlayerStats.ButtonText = PlayerStatsButtonText;

	MapVote = KFGUI_Button(FindComponentID('MapVote'));
	MapVote.ButtonText = MapVoteButtonText;

	CloseButton = KFGUI_Button(FindComponentID('Close'));
	CloseButton.ButtonText=CloseButtonText;
	CloseButton.ToolTip=CloseButtonToolTip;
}

function CloseMenu()
{
	Super.CloseMenu();
	RepInfo = None;
}

function InitMapvote(xVotingReplication R)
{
	RepInfo = R;
}

function DrawMenu()
{
	local float X, Y, W, H, XL, YL, FontScalar, BorderSize, gap, sc;
	local string S;
	local string WeapName;
	local CDInfoForFrontend CDI;
	local array<WeaponDamage> WDL;
	local array<ZedKillType> ZedKills;
	local int i, TotalKills, Headshots;

	//	BackGround
	Canvas.SetDrawColor(0, 0, 0, 100);
	Owner.CurrentStyle.DrawRectBox(0, 0, Canvas.ClipX, Canvas.ClipY, 0.f, 0);

	Super.DrawMenu();

	//	Setup
	Canvas.Font = Owner.CurrentStyle.PickFont(FontScalar);
	Canvas.TextSize("ABC", XL, YL, FontScalar, FontScalar);
	BorderSize = Owner.HUDOwner.ScaledBorderSize;
	ToggleComponents();

	//	Header General Info
	X = 0.332 * Canvas.ClipX;
	Y = 0.059 * Canvas.ClipY;
	W = 0.352 * Canvas.ClipX;
	H = 0.097 * Canvas.ClipY;
	FontScalar = (H / (4.5*YL))*FontScalar;
	Canvas.SetDrawColor(30, 30, 30, 200);
	Owner.CurrentStyle.DrawRectBox(X, Y, W, H+BorderSize, 8.f, 151);
	S = class'KFCommon_LocalizedStrings'.static.GetFriendlyMapName(GetCDPC().WorldInfo.GetMapName(true));
	S = class'CD_Object'.static.GetCustomMapName(S);
	Canvas.SetDrawColor(250, 250, 250, 255);
	DrawTextShadowHLeftVCenter(S, X+YL, Y+(BorderSize/2), FontScalar);
	CDI = GetCDGRI().bMatchIsOver ? GetCDGRI().CDFinalParams : GetCDGRI().CDInfoParams;
	DrawTextShadowHLeftVCenter(CDI.SC, X+YL, Y+(BorderSize/2)+(H*0.25), FontScalar);
	DrawTextShadowHLeftVCenter( "MaxMonsters -"   @ CDI.MM, X+YL, Y+(BorderSize/2)+(H*0.5), FontScalar );
	DrawTextShadowHLeftVCenter( "CohortSize -"    @ CDI.CS @ "|" @
								"SpawnPoll -"     @ CDI.SP @ "|" @
								"WaveSizeFakes -" @ CDI.WSF, X+YL, Y+(BorderSize/2)+(H*0.75), FontScalar);
	X += W;
	W = 0.224 * Canvas.ClipX;
	Canvas.SetDrawColor(0, 0, 0, 200);
	Owner.CurrentStyle.DrawRectBox(X, Y, W, H+BorderSize, 8.f, 0);
	Canvas.SetDrawColor(250, 250, 250, 255);
	if(GetCDGRI().bMatchIsOver)
	{
		if(GetCDGRI().bMatchVictory)
		{
			S = class'KFGame.KFGFxMenu_PostGameReport'.default.VictoryString;
			DrawTextShadowBoxCenter(S, X+BorderSize, Y+(BorderSize/2), W, H, FontScalar*1.5);
		}
		else
		{
			S = class'KFGame.KFGFxMenu_PostGameReport'.default.DefeatString;
			if(GetCDGRI().IsBossWave())
			{
				DrawTextShadowBoxCenter(S, X+BorderSize, Y+(BorderSize/2), W, H, FontScalar*1.5);
			}
			else
			{
				DrawTextShadowBoxCenter(S, X+BorderSize, Y-YL/2, W, H, FontScalar*1.5);
				S = class'KFGame.KFGFxMenu_PostGameReport'.default.WaveString @ GetCDGRI().WaveNum $ ": " $
					class'CD_SpawnManager'.static.FormatFloatToTwoDecimalPlaces(100*(1.f - ( float(GetCDGRI().AIRemaining)/float(GetCDGRI().WaveTotalAICount ) )) ) $ "%";
				DrawTextShadowBoxCenter(S, X+BorderSize, Y+YL, W, H, FontScalar);
			}
		}
	}
	else if(!GetCDGRI().bMatchHasBegun)
	{
		S = class'KFGFxMenu_ServerBrowser'.default.InLobbyString;
		DrawTextShadowBoxCenter(S, X+BorderSize, Y+(BorderSize/2), W, H, FontScalar*1.5);
	}
	else
	{
		S = class'KFGame.KFGFxMenu_PostGameReport'.default.WaveString @ GetCDGRI().WaveNum;
		DrawTextShadowBoxCenter(S, X+BorderSize, Y+(BorderSize/2), W, H, FontScalar*1.5);
	}

	//	Main Frame
	X = 0.332 * Canvas.ClipX;
	Y = 0.175 * Canvas.ClipY; //+= H + YL;
	W = 0.576 * Canvas.ClipX;
	H = YL * 0.5;
	Canvas.SetDrawColor(30, 30, 30, 200);
	Owner.CurrentStyle.DrawRectBox(X, Y, W, H, 8.f, 150);
	Y += H;
	H = 0.896 * Canvas.ClipY - YL - Y;
	Canvas.SetDrawColor(0, 0, 0, 200);
	Owner.CurrentStyle.DrawRectBox(X, Y, W, H+BorderSize, 8.f, 0);

	X += YL;
	Y += YL;
	if(CurState == 'TeamAward')        S = TeamAwardButtonText;
	else if(CurState == 'PlayerStats') S = PlayerStatsButtonText;
	else if(CurState == 'MapVote')     S = MapVoteButtonText;
	else CurState = 'MapVote';
	Canvas.SetDrawColor(250, 250, 250, 255);
	DrawTextShadowHLeftVCenter(S, X, Y, FontScalar*1.5);

	bListUpdate = bListUpdate && CurState=='PlayerStats';

	//	Team Award
	if(CurState == 'TeamAward')
	{
		X += YL;
		Y += 3 * YL;
		gap = (H+BorderSize)/4 - YL;
		sc = gap/6;

		DrawAwardFrame(X, Y, sc);
		DrawAwardFrame(X, Y+gap, sc);
		DrawAwardFrame(X, Y+2*gap, sc);
		DrawAwardFrame(X, Y+3*gap, sc);
		Canvas.SetDrawColor(250, 250, 250, 255);
		DrawTeamAwardIcon("UI_Award_Team.UI_Award_Team-Damage", X, Y, sc);
		DrawTeamAwardIcon("UI_Award_Team.UI_Award_Team-Headshots", X, Y+gap, sc);
		DrawTeamAwardIcon("UI_Award_Team.UI_Award_Team-Kills", X, Y+2*gap, sc);
		DrawTeamAwardIcon("UI_Endless_TEX.ZEDs.UI_ZED_Endless_Husk", X, Y+3*gap, sc);
		
		X += sc*5;
		DrawTextShadowHLeftVCenter(GetCDGRI().DamageDealer.PlayerName, X, Y+sc*2, FontScalar);
		DrawTextShadowHLeftVCenter(string(GetCDGRI().DamageDealer.Value)@DamageDealtString, X, Y+sc*3, FontScalar);
		DrawTextShadowHLeftVCenter(GetCDGRI().Precision.PlayerName, X, Y+sc*2+gap, FontScalar);
		DrawTextShadowHLeftVCenter(HitAccuracyString$":"@string(GetCDGRI().Precision.Value)$"%", X, Y+sc*3+gap, FontScalar);
		DrawTextShadowHLeftVCenter(GetCDGRI().ZedSlayer.PlayerName, X, Y+sc*2+2*gap, FontScalar);
		DrawTextShadowHLeftVCenter(string(GetCDGRI().ZedSlayer.Value)@KillsString, X, Y+sc*3+2*gap, FontScalar);
		DrawTextShadowHLeftVCenter(GetCDGRI().HuskKiller.PlayerName, X, Y+sc*2+3*gap, FontScalar);
		DrawTextShadowHLeftVCenter(string(GetCDGRI().HuskKiller.Value)@HuskKillsString, X, Y+sc*3+3*gap, FontScalar);
		Canvas.SetDrawColor(255, 213, 0, 255);
		DrawTextShadowBoxLeft(DamageDealerString, X, Y, sc*2, FontScalar*1.5);
		DrawTextShadowBoxLeft(PrecisionString, X, Y+gap, sc*2, FontScalar*1.5);
		DrawTextShadowBoxLeft(ZedSlayerString, X, Y+2*gap, sc*2, FontScalar*1.5);
		DrawTextShadowBoxLeft(HuskSlayerString, X, Y+3*gap, sc*2, FontScalar*1.5);

		X = 0.62 * Canvas.ClipX + YL;
		DrawAwardFrame(X, Y, sc);
		DrawAwardFrame(X, Y+gap, sc);
		DrawAwardFrame(X, Y+2*gap, sc);
		DrawAwardFrame(X, Y+3*gap, sc);
		Canvas.SetDrawColor(250, 250, 250, 255);
		DrawTeamAwardIcon("UI_Award_Team.UI_Award_Team-Healing", X, Y, sc);
		DrawTeamAwardIcon("WeeklyObjective_UI.UI_Weeklies_Zombies", X, Y+gap, sc);
		DrawTeamAwardIcon("UI_Award_Team.UI_Award_Team-Giants", X, Y+2*gap, sc);
		DrawTeamAwardIcon("UI_Award_ZEDs.UI_Award_ZED_RawDmg", X, Y+3*gap, sc);
		
		X += sc*5;
		DrawTextShadowHLeftVCenter(GetCDGRI().Healer.PlayerName, X, Y+sc*2, FontScalar);
		DrawTextShadowHLeftVCenter(string(GetCDGRI().Healer.Value)@HealthString, X, Y+sc*3, FontScalar);
		DrawTextShadowHLeftVCenter(GetCDGRI().HeadPopper.PlayerName, X, Y+sc*8, FontScalar);
		DrawTextShadowHLeftVCenter(HSAccuracyString$":"@string(GetCDGRI().HeadPopper.Value)$"%", X, Y+sc*9, FontScalar);
		DrawTextShadowHLeftVCenter(GetCDGRI().LargeKiller.PlayerName, X, Y+sc*14, FontScalar);
		DrawTextShadowHLeftVCenter(string(GetCDGRI().LargeKiller.Value)@ParseLocalizedPropertyPath("CombinedCD2.CD_StatsSystem.LargeKillsString"), X, Y+sc*15, FontScalar);
		DrawTextShadowHLeftVCenter(GetCDGRI().Guardian.PlayerName, X, Y+sc*20, FontScalar);
		DrawTextShadowHLeftVCenter(string(GetCDGRI().Guardian.Value)@DamageTakenString, X, Y+sc*21, FontScalar);
		Canvas.SetDrawColor(255, 213, 0, 255);
		DrawTextShadowBoxLeft(MedicineMasterString, X, Y, sc*2, FontScalar*1.5);
		DrawTextShadowBoxLeft(HeadPopperString, X, Y+gap, sc*2, FontScalar*1.5);
		DrawTextShadowBoxLeft(GiantSlayerString, X, Y+2*gap, sc*2, FontScalar*1.5);
		DrawTextShadowBoxLeft(GuardianString, X, Y+3*gap, sc*2, FontScalar*1.5);
	}

	//	Player Stats
	else if(CurState == 'PlayerStats')
	{
		if(!bListUpdate)
		{
			bListUpdate = true;
			TotalKills = GetCDPC().GetCDPRI().Kills;

			//	Stats
			StatsList.EmptyList();
			if(GetCDPC().ShotsFired > 0)
			{
				StatsList.AddLine(HitAccuracyString $ "\n" $
					class'CD_SpawnManager'.static.FormatFloatToTwoDecimalPlaces(100*(float(GetCDPC().ShotsHit))/(float(GetCDPC().ShotsFired))) $ "%");
			}
			if(GetCDPC().ShotsHit > 0)
			{
				if(CDI.CHSPP) Headshots = GetCDPC().ShotsHitHeadshot;
				else Headshots = GetCDPC().MatchStats.TotalHeadShots + GetCDPC().MatchStats.GetHeadShotsInWave();
				
				StatsList.AddLine(HSAccuracyString $ "\n" $
					class'CD_SpawnManager'.static.FormatFloatToTwoDecimalPlaces(100*float(Headshots)/float(GetCDPC().ShotsFired)) $ "%");
			}
			StatsList.AddLine(DamageDealtString $ "\n" $
				class'CD_Object'.static.AddCommaToInt( GetCDPC().MatchStats.TotalDamageDealt + GetCDPC().MatchStats.GetDamageDealtInWave() ));
			StatsList.AddLine(DamageTakenString $ "\n" $
				class'CD_Object'.static.AddCommaToInt( GetCDPC().MatchStats.TotalDamageTaken + GetCDPC().MatchStats.GetDamageTakenInWave() ));
			StatsList.AddLine(HealsGivenString $ "\n" $
				class'CD_Object'.static.AddCommaToInt( GetCDPC().MatchStats.TotalAmountHealGiven + GetCDPC().MatchStats.GetHealGivenInWave() ));
			StatsList.AddLine(HealsReceivedString $ "\n" $
				class'CD_Object'.static.AddCommaToInt( GetCDPC().MatchStats.TotalAmountHealReceived + GetCDPC().MatchStats.GetHealReceivedInWave() ));
			StatsList.AddLine(ParseLocalizedPropertyPath("KFGame.EphemeralMatchStats.EPB_Dosh") $ "\n" $
				class'CD_Object'.static.AddCommaToInt( GetCDPC().MatchStats.TotalDoshEarned + GetCDPC().MatchStats.GetDoshEarnedInWave() ));
			StatsList.AddLine(DeathsString $ "\n" $ string(GetCDPC().GetCDPRI().Deaths));

			if(TotalKills > 0)
			{
				//	Category Kills
				CategoryKillList.EmptyList();
				CategoryKillList.AddLine(TotalKillsString $ "\n" $ string(TotalKills));
				i = GetCDPC().MatchStats.TotalLargeZedKills;
				CategoryKillList.AddLine(LargeKillsString $ "\n" $ string(i) $ "\n" $
										 class'CD_SpawnManager'.static.FormatFloatToOneDecimalPlace(float(i*100)/float(TotalKills)));
				i = CD_EphemeralMatchStats(GetCDPC().MatchStats).MediumKills;
				CategoryKillList.AddLine(MediumKillsString $ "\n" $ string(i) $ "\n" $
										 class'CD_SpawnManager'.static.FormatFloatToOneDecimalPlace(float(i*100)/float(TotalKills)));
				i = CD_EphemeralMatchStats(GetCDPC().MatchStats).TrashKills;
				CategoryKillList.AddLine(TrashKillsString $ "\n" $ string(i) $ "\n" $
										 class'CD_SpawnManager'.static.FormatFloatToOneDecimalPlace(float(i*100)/float(TotalKills)));
				i = CD_EphemeralMatchStats(GetCDPC().MatchStats).RobotKills;
				if(i>0)
				{
					CategoryKillList.AddLine(RobotKillsString $ "\n" $ string(i) $ "\n" $
										 	 class'CD_SpawnManager'.static.FormatFloatToOneDecimalPlace(float(i*100)/float(TotalKills)));
				}
				i = CD_EphemeralMatchStats(GetCDPC().MatchStats).BossKills;
				if(i>0)
				{
					CategoryKillList.AddLine(BossKillsString $ "\n" $ string(i) $ "\n" $
										 	 class'CD_SpawnManager'.static.FormatFloatToOneDecimalPlace(float(i*100)/float(TotalKills)));
				}

				//	Zed Kills
				ZedKillList.EmptyList();
				ZedKills = GetCDPC().MatchStats.ZedKillsArray;
				for(i=0; i<ZedKills.length; i++)
				{
					ZedKillList.AddLine(ZedKills[i].MonsterClass.static.GetLocalizedName() $ "\n" $
										string(ZedKills[i].KillCount) $ "\n" $
										class'CD_SpawnManager'.static.FormatFloatToOneDecimalPlace(float(ZedKills[i].KillCount*100)/float(TotalKills)));
				}
			}

			//	Weapon Damage
			WeapDmgList.EmptyList();
			WDL = GetCDPC().MatchStats.WeaponDamageList;
			for(i=0; i<WDL.length; i++)
			{
				WeapName = class'CD_Object'.static.GetWeapName(WDL[i].WeaponDef);

				if(WeapName == "")
				{
					continue;
				}

				WeapDmgList.AddLine(WeapName $ "\n" $ class'CD_Object'.static.AddCommaToInt(WDL[i].DamageAmount) $ "\n" $
									string(WDL[i].Headshots) $ "\n" $ string(WDL[i].LargeZedKills) $ "\n" $ string(WDL[i].Kills));
			}
		}
	}

	//	Map Vote
	else if(CurState == 'MapVote')
	{
		// Lists
		if (RepInfo!=None && RepInfo.bListDirty)
		{
			RepInfo.bListDirty = false;
			UpdateList();
		}

		// Map Preview
		Canvas.Font = Owner.CurrentStyle.PickFont(FontScalar);
		Canvas.TextSize("ABC", XL, YL, FontScalar, FontScalar);
		X = 0.37 * Canvas.ClipX;
		Y += YL*2;

		Canvas.SetDrawColor(75, 0, 0, 250);
		Owner.CurrentStyle.DrawRectBox(X-XL/3,  Y,      XL/3, 3*YL, 8.f, 132);
		Owner.CurrentStyle.DrawRectBox(X-XL/3,  Y+3*YL, XL/3, 4*YL, 8.f, 133);
		Owner.CurrentStyle.DrawRectBox(X+YL*14, Y,      XL/3, 3*YL, 8.f, 131);
		Owner.CurrentStyle.DrawRectBox(X+YL*14, Y+3*YL, XL/3, 4*YL, 8.f, 130);

		Canvas.SetDrawColor(250, 250, 250, 255);
		if(MapList.SelectedRowIndex != INDEX_NONE)
			DrawMapPreview(GetMapPreviewPath(RepInfo.Maps[MapList.SelectedRowIndex].MapName), X, Y, YL);

		else
			DrawMapPreview("UI_MapPreview_TEX.UI_MapPreview_Placeholder", X, Y, YL);
	}

	//	Button Side
	X = 0.332 * Canvas.ClipX;
	Y = TeamAward.CompPos[1];
	W = 0.032 * Canvas.ClipX;
	H = TeamAward.CompPos[3];
	Canvas.SetDrawColor(30, 30, 30, 200);
	Owner.CurrentStyle.DrawRectBox(X, Y, W, H, 8.f, 151);
	X = 0.908 * Canvas.ClipX - W;
	Owner.CurrentStyle.DrawRectBox(X, Y, W, H, 8.f, 153);

	//	Server Name and IP
	if(GetCDPC().WorldInfo.NetMode != NM_StandAlone)
	{
		Y += H + 0.005 * Canvas.ClipY;
		Canvas.SetDrawColor(250, 250, 250, 255);
		DrawTextShadowHRightVCenter(class'WorldInfo'.static.GetWorldInfo().GetAddressURL(), X, Y, W, FontScalar);
	}
}

final function ToggleComponents()
{
	TeamAward.bDisabled   = CurState == 'TeamAward' || !GetCDGRI().bMatchIsOver;
	PlayerStats.bDisabled = CurState == 'PlayerStats' || GetCDGRI().WaveNum < 1;
	MapVote.bDisabled     = CurState == 'MapVote';

	StatsList.bVisible        = CurState == 'PlayerStats';
	CategoryKillList.bVisible = CurState == 'PlayerStats';
	WeapDmgList.bVisible      = CurState == 'PlayerStats';
	ZedKillList.bVisible      = CurState == 'PlayerStats';

	CurrentVotes.bVisible  = CurState == 'MapVote';
	MapList.bVisible       = CurState == 'MapVote';
	GameModeCombo.bVisible = CurState == 'MapVote';
}

function DrawTeamAwardIcon(string IconPath, float X, float Y, float YL)
{
	Canvas.SetPos(X, Y);
	Canvas.DrawTile(Texture(class'CD_Object'.static.SafeLoadObject(IconPath, class'Texture')), 4*YL, 4*YL, 0, 0, 256, 256);
}

function DrawAwardFrame(float X, float Y, float YL)
{
	local float Width, Height;
	Width = YL/2;
	Height = Width;

	Canvas.SetDrawColor(241, 166, 0, 200);
	Owner.CurrentStyle.DrawRectBox(X-Width, Y-Width, Width, Height, Width/2, 110); // <^
	Owner.CurrentStyle.DrawRectBox(X+4*YL, Y+4*YL, Width, Height, Width/2, 110); // >v
	Owner.CurrentStyle.DrawRectBox(X+4*YL, Y-Width, Width, Height, Width/2, 111); // >^
	Owner.CurrentStyle.DrawRectBox(X-Width, Y+4*YL, Width, Height, Width/2, 111); // <v
	Owner.CurrentStyle.DrawRectBox(X, Y-Width, 4*YL, Height/2, 0, 100); // ^
	Owner.CurrentStyle.DrawRectBox(X-Width, Y, Width/2, 4*YL, 0, 100); // <
	Owner.CurrentStyle.DrawRectBox(X, Y+4*YL+Width/2, 4*YL, Height/2, 0, 100); // v
	Owner.CurrentStyle.DrawRectBox(X+4*YL+Width/2, Y, Width/2, 4*YL, 0, 100); // >

	Owner.CurrentStyle.DrawRectBox(X+4*YL+Width, Y-Width/2, 12*YL, Width/2, 0, 100);
	Owner.CurrentStyle.DrawRectBox(X+16*YL+Width, Y-Width/2, Width, Height, Width/2, 111);
	Owner.CurrentStyle.DrawRectBox(X+16*YL+Width*1.5, Y+Width/2, Width/2, 4*YL-Width, 0, 100);
	Owner.CurrentStyle.DrawRectBox(X+16*YL+Width, Y+4*YL-Width/2, Width, Height, Width/2, 110);
	Owner.CurrentStyle.DrawRectBox(X+4*YL+Width, Y+4*YL, 12*YL, Width/2, 0, 100);
}

final function DrawMapPreview(string IconPath, float X, float Y, float YL)
{
	Canvas.SetPos(X, Y);
	Canvas.DrawTile(Texture(class'CD_Object'.static.SafeLoadObject(IconPath, class'Texture')), 14*YL, 7*YL, 0, 0, 512, 256);
}

static function string GetMapPreviewPath(string MapName)
{
	local KFMapSummary MapData;

	MapData = class'KFUIDataStore_GameResource'.static.GetMapSummaryFromMapName(MapName);

	if ( MapData != none && MapData.ScreenshotPathName != "")
	{
		return MapData.ScreenshotPathName;
	}
	else
	{
     	return "UI_MapPreview_TEX.UI_MapPreview_Placeholder";
	}
}

final function UpdateList()
{
	local int i,g,m,Sel;
	local float V;
	local KFGUI_ListItem Item,SItem;

	//	GameModeList
	/*
	if (GameModeList.Columns.Length!=RepInfo.GameModes.Length)
	{
		GameModeList.Columns.Length = RepInfo.GameModes.Length;
		for (i=0; i<GameModeList.Columns.Length; ++i)
		{
			GameModeList.AddLine(RepInfo.GameModes[i].GameName);
		}
		if (!bFirstTime)
		{
			bFirstTime = true;
			SelectedModeIndex = RepInfo.ClientCurrentGame;
		}
		ChangeToMaplist(SelectedModeIndex);
	}
	GameModeList.SelectedRowIndex = SelectedModeIndex;
	*/

	if (GameModeCombo.Values.Length!=RepInfo.GameModes.Length)
	{
		GameModeCombo.Values.Length = RepInfo.GameModes.Length;
		for (i=0; i<GameModeCombo.Values.Length; ++i)
			GameModeCombo.Values[i] = RepInfo.GameModes[i].GameName;
		if (!bFirstTime)
		{
			bFirstTime = true;
			GameModeCombo.SelectedIndex = RepInfo.ClientCurrentGame;
		}
		ModeChanged(GameModeCombo);
	}

	//	CurrentVotes
	Item = CurrentVotes.GetFromIndex(CurrentVotes.SelectedRowIndex);
	Sel = (Item!=None ? Item.Value : -1);
	CurrentVotes.EmptyList();
	for (i=0; i<RepInfo.ActiveVotes.Length; ++i)
	{
		g = RepInfo.ActiveVotes[i].GameIndex;
		m = RepInfo.ActiveVotes[i].MapIndex;
		if (RepInfo.Maps[m].NumPlays==0)
			Item = CurrentVotes.AddLine(RepInfo.GameModes[g].GameName$"\n"$RepInfo.Maps[m].MapTitle$"\n"$RepInfo.ActiveVotes[i].NumVotes$"\n** NEW **",m,
										RepInfo.GameModes[g].GameName$"\n"$RepInfo.Maps[m].MapTitle$"\n"$MakeSortStr(RepInfo.ActiveVotes[i].NumVotes)$"\n"$MakeSortStr(0));
		else
		{
			V = (float(RepInfo.Maps[m].UpVotes) / float(RepInfo.Maps[m].UpVotes+RepInfo.Maps[m].DownVotes)) * 100.f;
			Item = CurrentVotes.AddLine(RepInfo.GameModes[g].GameName$"\n"$RepInfo.Maps[m].MapTitle$"\n"$RepInfo.ActiveVotes[i].NumVotes$"\n"$int(V)$"% ("$RepInfo.Maps[m].UpVotes$"/"$(RepInfo.Maps[m].UpVotes+RepInfo.Maps[m].DownVotes)$")",m,
										RepInfo.GameModes[g].GameName$"\n"$RepInfo.Maps[m].MapTitle$"\n"$MakeSortStr(RepInfo.ActiveVotes[i].NumVotes)$"\n"$MakeSortStr(int(V*100.f)));
		}
		if (Sel>=0 && Sel==m)
			SItem = Item;
	}

	// Keep same row selected if possible.
	CurrentVotes.SelectedRowIndex = (SItem!=None ? SItem.Index : -1);
}

function ChangeToMaplist(int Index)
{
	local int i,g;
	local float V;

	if (RepInfo!=None)
	{
		MapList.EmptyList();
		g = Index;
		for (i=0; i<RepInfo.Maps.Length; ++i)
		{
			if (!BelongsToPrefix(RepInfo.Maps[i].MapName,RepInfo.GameModes[g].Prefix))
				continue;
			if (RepInfo.Maps[i].NumPlays==0)
				MapList.AddLine(RepInfo.Maps[i].MapTitle$"\n"$RepInfo.Maps[i].Sequence$"\n"$RepInfo.Maps[i].NumPlays$"\n** NEW **",i,
								RepInfo.Maps[i].MapTitle$"\n"$MakeSortStr(RepInfo.Maps[i].Sequence)$"\n"$MakeSortStr(RepInfo.Maps[i].NumPlays)$"\n"$MakeSortStr(0));
			else
			{
				V = RepInfo.Maps[i].UpVotes+RepInfo.Maps[i].DownVotes;
				if (V==0)
					V = 100.f;
				else V = (float(RepInfo.Maps[i].UpVotes) / V) * 100.f;
				MapList.AddLine(RepInfo.Maps[i].MapTitle$"\n"$RepInfo.Maps[i].Sequence$"\n"$RepInfo.Maps[i].NumPlays$"\n"$int(V)$"% ("$RepInfo.Maps[i].UpVotes$"/"$(RepInfo.Maps[i].UpVotes+RepInfo.Maps[i].DownVotes)$")",i,
								RepInfo.Maps[i].MapTitle$"\n"$MakeSortStr(RepInfo.Maps[i].Sequence)$"\n"$MakeSortStr(RepInfo.Maps[i].NumPlays)$"\n"$MakeSortStr(int(V*100.f)));
			}
		}
	}
}

static final function bool BelongsToPrefix(string MN, string Prefix)
{
	return (Prefix=="" || Left(MN,Len(Prefix))~=Prefix);
}

function ButtonClicked(KFGUI_Button Sender)
{
	switch (Sender.ID)
	{
		case 'Close':
			DoClose();
			break;
		case 'TeamAward':
			CurState = 'TeamAward';
			break;
		case 'PlayerStats':
			CurState = 'PlayerStats';
			break;
		case 'MapVote':
			CurState = 'MapVote';
			break;
	}
}

function ClickedRow(int RowNum)
{
	if (RowNum==0) // Vote this map.
	{
		RepInfo.ServerCastVote(SelectedModeIndex,SelectedMapIndex,false);
	}
	else // Admin force this map.
	{
		RepInfo.ServerCastVote(SelectedModeIndex,SelectedMapIndex,true);
	}
}

function SelectedVoteRow(KFGUI_ListItem Item, int Row, bool bRight, bool bDblClick)
{
	if (bRight)
	{
		SelectedMapIndex = Item.Value;
		MapRightClick.ItemRows[1].bDisabled = (!GetPlayer().PlayerReplicationInfo.bAdmin);
		MapRightClick.OpenMenu(Self);
	}
	else if (bDblClick)
		RepInfo.ServerCastVote(SelectedModeIndex,Item.Value,false);
}

function SelectedModeRow(KFGUI_ListItem Item, int Row, bool bRight, bool bDblClick)
{
	if(Row>=0)
	{
		SelectedModeIndex = Row;
		ChangeToMaplist(SelectedModeIndex);
	}
	GameModeList.SelectedRowIndex = SelectedModeIndex;
}

function SetWindowDrag(bool bDrag)
{
	bDragWindow = false;
}

function DoClose()
{
	bListUpdate=false;
	super.DoClose();
}

function IgnoreClick(int Index, bool bRight, int MouseX, int MouseY)
{
	return;
}

function ModeChanged(KFGUI_ComboBox Sender)
{
	SelectedModeIndex = Sender.SelectedIndex;
	ChangeToMaplist(Sender.SelectedIndex);
}

defaultproperties
{
	XPosition=0
	YPosition=0
	XSize=1
	YSize=1
	bHide=true
	
//	Player Stats
	Begin Object Class=KFGUI_ColumnList Name=StatsList
		XPosition=0.340
		YPosition=0.295
		XSize=0.183
		YSize=0.277
		ID="Stats"
		bCanSortColumn=false
		OnClickedItem=IgnoreClick
		OnDblClickedItem=IgnoreClick
	End Object
	Begin Object Class=KFGUI_ColumnList Name=CategoryKillList
		XPosition=0.533
		YPosition=0.295
		XSize=0.174
		YSize=0.277
		ID="CategoryKill"
		bCanSortColumn=false
		OnClickedItem=IgnoreClick
		OnDblClickedItem=IgnoreClick
	End Object
	Begin Object Class=KFGUI_ColumnList Name=WeapDmgList
		XPosition=0.340
		YPosition=0.583
		XSize=0.367
		YSize=0.277
		ID="WeapDmg"
		bCanSortColumn=false
		OnClickedItem=IgnoreClick
		OnDblClickedItem=IgnoreClick
	End Object
	Begin Object Class=KFGUI_ColumnList Name=ZedKillList
		XPosition=0.717
		YPosition=0.200
		XSize=0.183
		YSize=0.660
		ID="ZedKill"
		bCanSortColumn=false
		OnClickedItem=IgnoreClick
		OnDblClickedItem=IgnoreClick
	End Object

//	MapVote
	Begin Object Class=KFGUI_ColumnList Name=CurrentVotesList
		XPosition=0.340 //0.015
		YPosition=0.495 //0.075
		XSize=0.280 //0.98
		YSize=0.365 //0.25
		ID="Votes"
		OnSelectedRow=SelectedVoteRow
		bShouldSortList=true
		bLastSortedReverse=true
		LastSortedColumn=2
	End Object
	Begin Object Class=KFGUI_ColumnList Name=MapList
		XPosition=0.630 //0.015
		YPosition=0.280 //0.165 //0.375
		XSize=0.270 //0.58
		YSize=0.580 //0.56
		ID="Maps"
		OnSelectedRow=SelectedVoteRow
		bCanSortColumn=false
	End Object
	Begin Object Class=KFGUI_ColumnList Name=GameModeList
		XPosition=0.630 //0.6
		YPosition=0.200 //0.375
		XSize=0.270 //0.39
		YSize=0.073 //0.28
		ID="Modes"
		OnSelectedRow=SelectedModeRow
		bCanSortColumn=false
	End Object
	Begin Object Class=KFGUI_ComboBox Name=GameModeCombo
		XPosition=0.630
		YPosition=0.220
		XSize=0.270
		YSize=0.073
		OnComboChanged=ModeChanged
		ID="Filter"
	//	LableString="Game mode:"
		//ToolTip="Select game mode to vote for."
	End Object
	
//	Button
	Begin Object Class=KFGUI_Button Name=TeamAward
		XPosition=0.369
		YPosition=0.896
		XSize=0.124
		YSize=0.045
		FontScale=1.5
		ID="TeamAward"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Begin Object Class=KFGUI_Button Name=PlayerStats
		XPosition=0.495
		YPosition=0.896
		XSize=0.124
		YSize=0.045
		FontScale=1.5
		ID="PlayerStats"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Begin Object Class=KFGUI_Button Name=MapVote
		XPosition=0.621
		YPosition=0.896
		XSize=0.124
		YSize=0.045
		FontScale=1.5
		ID="MapVote"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Begin Object Class=KFGUI_Button Name=Close
		XPosition=0.747
		YPosition=0.896
		XSize=0.124
		YSize=0.045
		FontScale=1.5
		ID="Close"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

//	Components
	Components.Add(StatsList)
	Components.Add(CategoryKillList)
	Components.Add(WeapDmgList)
	Components.Add(ZedKillList)
	Components.Add(CurrentVotesList)
	Components.Add(MapList)
	Components.Add(GameModeCombo)
	Components.Add(TeamAward)
	Components.Add(PlayerStats)
	Components.Add(MapVote)
	Components.Add(Close)

//	Right Clicker
	Begin Object Class=KFGUI_RightClickMenu Name=MapRClicker
		ID="RClick"
		OnSelectedItem=ClickedRow
	End Object
	MapRightClick=MapRClicker
}