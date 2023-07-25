class xUI_ResultMenu extends xUI_MenuBase;

var KFGUI_Button TeamAward;
var KFGUI_Button PlayerStats;
var KFGUI_Button MapVote;
var KFGUI_Button Close;

var name CurState;

//var localized string Title;
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

function SetWindowDrag(bool bDrag)
{
	bDragWindow = false;
}

function DrawMenu()
{
//	Setup
	local float X, Y, XL, YL, Width, Height, FontScalar, BorderSize, gap, ratio;
	local string S;
	local CD_GameReplicationInfo CDGRI;
	local CD_PlayerController CDPC;
	local KFPlayerController KFPC;
	local array<ZedKillType> PersonalStats;
	local ZedKillType Status;
	local int i, sc, fp, qp, hu, bl, si, de, dr, dl, gf, gf2, st, cr, ecr, sl, al, cy, ri, as, hans, pat, kfp, abom, mat;
	local float f;

	Super.DrawMenu();

	WindowTitle=Title @ "v1.2";
	Canvas.Font = Owner.CurrentStyle.PickFont(FontScalar);
	Canvas.TextSize("ABC", XL, YL, FontScalar, FontScalar);
	BorderSize = Owner.HUDOwner.ScaledBorderSize;
	ratio = 0.161*CompPos[3]/(6*YL);
	YL *= ratio;
	FontScalar *= ratio;
	gap = 6*YL;

	CDGRI = CD_GameReplicationInfo(GetCDPC().Worldinfo.GRI);
	CDPC = GetCDPC();
	KFPC = KFPlayerController(GetPlayer());
	
//	Buttom button
	TeamAward = KFGUI_Button(FindComponentID('TeamAward'));
	TeamAward.ButtonText = TeamAwardButtonText;
	TeamAward.bDisabled = (CurState == 'TeamAward') ? true : false;

	PlayerStats = KFGUI_Button(FindComponentID('PlayerStats'));
	PlayerStats.ButtonText = PlayerStatsButtonText;
	PlayerStats.bDisabled = (CurState == 'PlayerStats') ? true : false;

	MapVote = KFGUI_Button(FindComponentID('MapVote'));
	MapVote.ButtonText = MapVoteButtonText;
	Close = KFGUI_Button(FindComponentID('Close'));
	Close.ButtonText = CloseButtonText;

//	Header General Information
	X = 0.05*CompPos[2];
	Y = 0.05*CompPos[3];
	Width = 0.55*CompPos[2];
	Height = 4*YL;
	Canvas.SetDrawColor(30, 30, 30, 200);
	Owner.CurrentStyle.DrawRectBox(X, Y, Width, Height+BorderSize, 8.f, 151);
	Canvas.SetDrawColor(250, 250, 250, 255);
	S = class'KFCommon_LocalizedStrings'.static.GetFriendlyMapName(GetCDPC().WorldInfo.GetMapName(true));
	S = class'CD_Object'.static.GetCustomMapName(S);
	DrawTextShadowHLeftVCenter(S, X+YL, Y+(BorderSize/2), FontScalar);
	DrawTextShadowHLeftVCenter(CDGRI.CDFinalParams.SC, X+YL, Y+(BorderSize/2)+YL, FontScalar);
	DrawTextShadowHLeftVCenter("MaxMonsters -" @ CDGRI.CDFinalParams.MM, X+YL, Y+(BorderSize/2)+(YL*2), FontScalar);
	DrawTextShadowHLeftVCenter( "CohortSize -" @ CDGRI.CDFinalParams.CS @ "|" @
								"SpawnPoll -" @ CDGRI.CDFinalParams.SP @ "|" @
								"WaveSizeFakes -" @ CDGRI.CDFinalParams.WSF, X+YL, Y+(BorderSize/2)+(YL*3), FontScalar);
	X += Width;
	Width = 0.35*CompPos[2];
	Canvas.SetDrawColor(0, 0, 0, 200);
	Owner.CurrentStyle.DrawRectBox(X, Y, Width, Height+BorderSize, 8.f, 0);
	Canvas.SetDrawColor(250, 250, 250, 255);
	if(CDGRI.bMatchVictory)
	{
		S = class'KFGame.KFGFxMenu_PostGameReport'.default.VictoryString;
		DrawTextShadowBoxCenter(S, X+BorderSize, Y+(BorderSize/2), Width, Height, FontScalar*1.5);
	}
	else
	{
		S = class'KFGame.KFGFxMenu_PostGameReport'.default.DefeatString;
		if(CDGRI.IsBossWave())
		{
			DrawTextShadowBoxCenter(S, X+BorderSize, Y+(BorderSize/2), Width, Height, FontScalar*1.5);
		}
		else
		{
			DrawTextShadowBoxCenter(S, X+BorderSize, Y-YL/2, Width, Height, FontScalar*1.5);
			S = class'KFGame.KFGFxMenu_PostGameReport'.default.WaveString @ CDGRI.WaveNum $ ": " $
				class'CD_SpawnManager'.static.FormatFloatToTwoDecimalPlaces(100*(1.f - ( float(CDGRI.AIRemaining)/float(CDGRI.WaveTotalAICount ) )) ) $ "%";
			DrawTextShadowBoxCenter(S, X+BorderSize, Y+YL, Width, Height, FontScalar);
		}
	}
	

//	Current State
	X = 0.05*CompPos[2];
	Y += Height+YL;
	Width = 0.90*CompPos[2];
	Height = YL*0.5;
	Canvas.SetDrawColor(30, 30, 30, 200);
	Owner.CurrentStyle.DrawRectBox(X, Y, Width, Height, 8.f, 150);
	Y += Height;
	Height = TeamAward.CompPos[1] - YL - Y - CompPos[1];
	Canvas.SetDrawColor(0, 0, 0, 200);
	Owner.CurrentStyle.DrawRectBox(X, Y, Width, Height+BorderSize, 8.f, 0);
	X += YL;
	Y += YL;
	if(CurState == 'TeamAward') S = TeamAwardButtonText;
	else if(CurState == 'PlayerStats') S = PlayerStatsButtonText;
	Canvas.SetDrawColor(250, 250, 250, 255);
	DrawTextShadowHLeftVCenter(S, X, Y, FontScalar*1.5);

//	Team Award
	if(CurState == 'TeamAward')
	{
		Y += 3*YL;
		X += YL;

		DrawAwardFrame(X, Y, YL);
		DrawAwardFrame(X, Y+gap, YL);
		DrawAwardFrame(X, Y+2*gap, YL);
		DrawAwardFrame(X, Y+3*gap, YL);
		Canvas.SetDrawColor(250, 250, 250, 255);
		DrawTeamAwardIcon("UI_Award_Team.UI_Award_Team-Damage", X, Y, YL);
		DrawTeamAwardIcon("UI_Award_Team.UI_Award_Team-Headshots", X, Y+gap, YL);
		DrawTeamAwardIcon("UI_Award_Team.UI_Award_Team-Kills", X, Y+2*gap, YL);
		DrawTeamAwardIcon("UI_Endless_TEX.ZEDs.UI_ZED_Endless_Husk", X, Y+3*gap, YL);
		X += YL*5; //YL*ratio*5;
		DrawTextShadowHLeftVCenter(CDGRI.DamageDealer.PlayerName, X, Y+YL*2, FontScalar);
		DrawTextShadowHLeftVCenter(string(CDGRI.DamageDealer.Value)@DamageDealtString, X, Y+YL*3, FontScalar);
		DrawTextShadowHLeftVCenter(CDGRI.Precision.PlayerName, X, Y+YL*2+gap, FontScalar);
		DrawTextShadowHLeftVCenter(HitAccuracyString$":"@string(CDGRI.Precision.Value)$"%", X, Y+YL*3+gap, FontScalar);
		DrawTextShadowHLeftVCenter(CDGRI.ZedSlayer.PlayerName, X, Y+YL*2+2*gap, FontScalar);
		DrawTextShadowHLeftVCenter(string(CDGRI.ZedSlayer.Value)@KillsString, X, Y+YL*3+2*gap, FontScalar);
		DrawTextShadowHLeftVCenter(CDGRI.HuskKiller.PlayerName, X, Y+YL*2+3*gap, FontScalar);
		DrawTextShadowHLeftVCenter(string(CDGRI.HuskKiller.Value)@HuskKillsString, X, Y+YL*3+3*gap, FontScalar);
		Canvas.SetDrawColor(255, 213, 0, 255);
		DrawTextShadowBoxLeft(DamageDealerString, X, Y, YL*2, FontScalar*1.5);
		DrawTextShadowBoxLeft(PrecisionString, X, Y+gap, YL*2, FontScalar*1.5);
		DrawTextShadowBoxLeft(ZedSlayerString, X, Y+2*gap, YL*2, FontScalar*1.5);
		DrawTextShadowBoxLeft(HuskSlayerString, X, Y+3*gap, YL*2, FontScalar*1.5);
		
		X = 0.5*CompPos[2] + YL;
		DrawAwardFrame(X, Y, YL);
		DrawAwardFrame(X, Y+6*YL, YL);
		DrawAwardFrame(X, Y+12*YL, YL);
		DrawAwardFrame(X, Y+18*YL, YL);
		Canvas.SetDrawColor(250, 250, 250, 255);
		DrawTeamAwardIcon("UI_Award_Team.UI_Award_Team-Healing", X, Y, YL);
		DrawTeamAwardIcon("WeeklyObjective_UI.UI_Weeklies_Zombies", X, Y+6*YL, YL);
		DrawTeamAwardIcon("UI_Award_Team.UI_Award_Team-Giants", X, Y+12*YL, YL);
		DrawTeamAwardIcon("UI_Award_ZEDs.UI_Award_ZED_RawDmg", X, Y+18*YL, YL);
		X += YL*5;
		DrawTextShadowHLeftVCenter(CDGRI.Healer.PlayerName, X, Y+YL*2, FontScalar);
		DrawTextShadowHLeftVCenter(string(CDGRI.Healer.Value)@HealthString, X, Y+YL*3, FontScalar);
		DrawTextShadowHLeftVCenter(CDGRI.HeadPopper.PlayerName, X, Y+YL*8, FontScalar);
		DrawTextShadowHLeftVCenter(HSAccuracyString$":"@string(CDGRI.HeadPopper.Value)$"%", X, Y+YL*9, FontScalar);
		DrawTextShadowHLeftVCenter(CDGRI.LargeKiller.PlayerName, X, Y+YL*14, FontScalar);
		DrawTextShadowHLeftVCenter(string(CDGRI.LargeKiller.Value)@LargeKillsString, X, Y+YL*15, FontScalar);
		DrawTextShadowHLeftVCenter(CDGRI.Guardian.PlayerName, X, Y+YL*20, FontScalar);
		DrawTextShadowHLeftVCenter(string(CDGRI.Guardian.Value)@DamageTakenString, X, Y+YL*21, FontScalar);
		Canvas.SetDrawColor(255, 213, 0, 255);
		DrawTextShadowBoxLeft(MedicineMasterString, X, Y, YL*2, FontScalar*1.5);
		DrawTextShadowBoxLeft(HeadPopperString, X, Y+6*YL, YL*2, FontScalar*1.5);
		DrawTextShadowBoxLeft(GiantSlayerString, X, Y+12*YL, YL*2, FontScalar*1.5);
		DrawTextShadowBoxLeft(GuardianString, X, Y+18*YL, YL*2, FontScalar*1.5);
	}
//	PlayerStats
	else if(CurState == 'PlayerStats')
	{
		Y += 3*YL;
		X += YL;
		Width = 0.3*CompPos[2];

		DrawTextShadowHLeftVCenter(HitAccuracyString $ ":", X, Y, FontScalar);
		if(KFPC.ShotsFired == 0)
		{
			f = 0;
		}
		else
		{
			f = (float(KFPC.ShotsHit))/(float(KFPC.ShotsFired));
		}
		DrawTextShadowHRightVCenter(string(round(f*100))$"% ("$string(KFPC.ShotsHit)$"/"$string(KFPC.ShotsFired)$")", X, Y, Width, FontScalar);

		DrawTextShadowHLeftVCenter(HSAccuracyString $ ":", X, Y+YL, FontScalar);
		if(CDGRI.CDFinalParams.CHSPP) i = KFPC.ShotsHitHeadshot;
		else i = CDPC.MatchStats.TotalHeadShots + CDPC.MatchStats.GetHeadShotsInWave();
		if(KFPC.ShotsHit == 0) f = 0;
		else f = float(i)/float(KFPC.ShotsHit);
		DrawTextShadowHRightVCenter(string(round(f*100))$"% ("$string(i)$"/"$string(KFPC.ShotsHit)$")", X, Y+YL, Width, FontScalar);
		
		DrawTextShadowHLeftVCenter(DamageDealtString $ ":", X, Y+YL*3, FontScalar);
		i = CDPC.MatchStats.TotalDamageDealt + CDPC.MatchStats.GetDamageDealtInWave();
		DrawTextShadowHRightVCenter(string(i), X, Y+YL*3, Width, FontScalar);
		DrawTextShadowHLeftVCenter(DamageTakenString $ ":", X, Y+YL*4, FontScalar);
		i = CDPC.MatchStats.TotalDamageTaken + CDPC.MatchStats.GetDamageTakenInWave();
		DrawTextShadowHRightVCenter(string(i), X, Y+YL*4, Width, FontScalar);

		DrawTextShadowHLeftVCenter(HealsGivenString $ ":", X, Y+YL*6, FontScalar);
		i = CDPC.MatchStats.TotalAmountHealGiven + CDPC.MatchStats.GetHealGivenInWave();
		DrawTextShadowHRightVCenter(string(i), X, Y+YL*6, Width, FontScalar);
		DrawTextShadowHLeftVCenter(HealsReceivedString $ ":", X, Y+YL*7, FontScalar);
		i = CDPC.MatchStats.TotalAmountHealReceived + CDPC.MatchStats.GetHealReceivedInWave();
		DrawTextShadowHRightVCenter(string(i), X, Y+YL*7, Width, FontScalar);

		PersonalStats = CDPC.MatchStats.ZedKillsArray;
		foreach PersonalStats(Status)
		{
			switch(Status.MonsterClass)
			{
				case class'KFGameContent.KFPawn_ZedScrake':
					sc = Status.KillCount;
					break;
				case class'KFGameContent.KFPawn_ZedFleshpound':
					fp = Status.KillCount;
					break;
				case class'KFGameContent.KFPawn_ZedFleshpoundMini':
					qp = Status.KillCount;
					break;
				case class'KFGameContent.KFPawn_ZedHusk':
					hu = Status.KillCount;
					break;
				case class'KFGameContent.KFPawn_ZedBloat':
					bl = Status.KillCount;
					break;
				case class'KFGameContent.KFPawn_ZedSiren':
					si = Status.KillCount;
					break;
				case class'KFGameContent.KFPawn_ZedDAR_EMP':
					de = Status.KillCount;
					break;
				case class'KFGameContent.KFPawn_ZedDAR_Rocket':
					dr = Status.KillCount;
					break;
				case class'KFGameContent.KFPawn_ZedDAR_Laser':
					dl = Status.KillCount;
					break;
				case class'KFGameContent.KFPawn_ZedGorefast':
					gf = Status.KillCount;
					break;
				case class'KFGameContent.KFPawn_ZedGorefastDualBlade':
				case class'CD_Pawn_ZedGorefast_Special':
					gf2 = Status.KillCount;
					break;
				case class'KFGameContent.KFPawn_ZedStalker':
					st = Status.KillCount;
					break;
				case class'KFGameContent.KFPawn_ZedCrawler':
					cr = Status.KillCount;
					break;
				case class'KFGameContent.KFPawn_ZedCrawlerKing':
				case class'CD_Pawn_ZedCrawler_Special' :
					ecr = Status.KillCount;
					break;
				case class'KFGameContent.KFPawn_ZedClot_AlphaKing':
				case class'CD_Pawn_ZedClot_Alpha_Special':
					ri = Status.KillCount;
					break;
				case class'KFGameContent.KFPawn_ZedClot_Slasher':
					sl = Status.KillCount;
					break;
				case class'KFGameContent.KFPawn_ZedClot_Alpha':
					al = Status.KillCount;
					break;
				case class'KFGameContent.KFPawn_ZedClot_Cyst':
					cy = Status.KillCount;
					break;
				case class'KFGameContent.KFPawn_ZedBloatKingSubspawn':
					as = Status.KillCount;
					break;
				case class'KFGameContent.KFPawn_ZedHans':
					hans = Status.KillCount;
					break;
				case class'KFGameContent.KFPawn_ZedPatriarch':
					pat = Status.KillCount;
					break;
				case class'KFGameContent.KFPawn_ZedFleshpoundKing':
					kfp = Status.KillCount;
					break;
				case class'KFGameContent.KFPawn_ZedBloatKing':
				case class'KFGameContent.KFPawn_ZedBloatKing_SantasWorkshop':
					abom = Status.KillCount;
					break;
				case class'KFGameContent.KFPawn_ZedMatriarch':
					mat = Status.KillCount;
					break;
			}
		}

		i = 0;
		if(de+dr+dl > 0)
		{
			i += 1;
			DrawTextShadowHLeftVCenter(RobotKillsString $ ":", X, Y+YL*(8+i), FontScalar);
			DrawTextShadowHRightVCenter(string(de+dr+dl), X, Y+YL*(8+i), Width, FontScalar);
			if(de > 0)
			{
				i += 1;
				DrawTextShadowHLeftVCenter("  " $ class'KFGameContent.KFPawn_ZedDAR_EMP'.static.GetLocalizedName() $ ":", X, Y+YL*(8+i), FontScalar);
				DrawTextShadowHRightVCenter(string(de), X, Y+YL*(8+i), Width, FontScalar);
			}
			if(dr > 0)
			{
				i += 1;
				DrawTextShadowHLeftVCenter("  " $ class'KFGameContent.KFPawn_ZedDAR_Rocket'.static.GetLocalizedName() $ ":", X, Y+YL*(8+i), FontScalar);
				DrawTextShadowHRightVCenter(string(dr), X, Y+YL*(8+i), Width, FontScalar);
			}
			if(dl > 0)
			{
				i += 1;
				DrawTextShadowHLeftVCenter("  " $ class'KFGameContent.KFPawn_ZedDAR_Laser'.static.GetLocalizedName() $ ":", X, Y+YL*(8+i), FontScalar);
				DrawTextShadowHRightVCenter(string(dl), X, Y+YL*(8+i), Width, FontScalar);
			}
			i += 1;
		}
		if(as+hans+pat+kfp+abom+mat > 0)
		{
			i += 1;
			DrawTextShadowHLeftVCenter(BossKillsString $ ":", X, Y+YL*(8+i), FontScalar);
			DrawTextShadowHRightVCenter(string(as+hans+pat+kfp+abom+mat), X, Y+YL*(8+i), Width, FontScalar);
			if(as > 0)
			{
				i += 1;
				DrawTextShadowHLeftVCenter("  " $ class'KFGameContent.KFPawn_ZedBloatKingSubspawn'.static.GetLocalizedName() $ ":", X, Y+YL*(8+i), FontScalar);
				DrawTextShadowHRightVCenter(string(as), X, Y+YL*(8+i), Width, FontScalar);
			}
			if(hans > 0)
			{
				i += 1;
				DrawTextShadowHLeftVCenter("  " $ class'KFGameContent.KFPawn_ZedHans'.static.GetLocalizedName() $ ":", X, Y+YL*(8+i), FontScalar);
				DrawTextShadowHRightVCenter(string(hans), X, Y+YL*(8+i), Width, FontScalar);
			}
			if(pat > 0)
			{
				i += 1;
				DrawTextShadowHLeftVCenter("  " $ class'KFGameContent.KFPawn_ZedPatriarch'.static.GetLocalizedName() $ ":", X, Y+YL*(8+i), FontScalar);
				DrawTextShadowHRightVCenter(string(pat), X, Y+YL*(8+i), Width, FontScalar);
			}
			if(kfp > 0)
			{
				i += 1;
				DrawTextShadowHLeftVCenter("  " $ class'KFGameContent.KFPawn_ZedFleshpoundKing'.static.GetLocalizedName() $ ":", X, Y+YL*(8+i), FontScalar);
				DrawTextShadowHRightVCenter(string(kfp), X, Y+YL*(8+i), Width, FontScalar);
			}
			if(abom > 0)
			{
				i += 1;
				DrawTextShadowHLeftVCenter("  " $ class'KFGameContent.KFPawn_ZedBloatKing'.static.GetLocalizedName() $ ":", X, Y+YL*(8+i), FontScalar);
				DrawTextShadowHRightVCenter(string(abom), X, Y+YL*(8+i), Width, FontScalar);
			}
			if(mat > 0)
			{
				i += 1;
				DrawTextShadowHLeftVCenter("  " $ class'KFGameContent.KFPawn_ZedMatriarch'.static.GetLocalizedName() $ ":", X, Y+YL*(8+i), FontScalar);
				DrawTextShadowHRightVCenter(string(mat), X, Y+YL*(8+i), Width, FontScalar);
			}
		}

		X = 0.5*CompPos[2] + YL;
		DrawTextShadowHLeftVCenter(TotalKillsString $ ":", X, Y, FontScalar);
		DrawTextShadowHRightVCenter(string(CDPC.PlayerReplicationInfo.Kills), X, Y, Width, FontScalar);

		DrawTextShadowHLeftVCenter(LargeKillsString $ ":", X, Y+YL*2, FontScalar);
		DrawTextShadowHRightVCenter(string(sc+fp+qp), X, Y+YL*2, Width, FontScalar);
		DrawTextShadowHLeftVCenter("  " $ class'KFGameContent.KFPawn_ZedScrake'.static.GetLocalizedName() $ ":", X, Y+YL*3, FontScalar);
		DrawTextShadowHRightVCenter(string(sc), X, Y+YL*3, Width, FontScalar);
		DrawTextShadowHLeftVCenter("  " $ class'KFGameContent.KFPawn_ZedFleshpound'.static.GetLocalizedName() $ ":", X, Y+YL*4, FontScalar);
		DrawTextShadowHRightVCenter(string(fp), X, Y+YL*4, Width, FontScalar);
		DrawTextShadowHLeftVCenter("  " $ class'KFGameContent.KFPawn_ZedFleshpoundMini'.static.GetLocalizedName() $ ":", X, Y+YL*5, FontScalar);
		DrawTextShadowHRightVCenter(string(qp), X, Y+YL*5, Width, FontScalar);

		DrawTextShadowHLeftVCenter(MediumKillsString $ ":", X, Y+YL*7, FontScalar);
		DrawTextShadowHRightVCenter(string(hu+si+bl), X, Y+YL*7, Width, FontScalar);
		DrawTextShadowHLeftVCenter("  " $ class'KFGameContent.KFPawn_ZedHusk'.static.GetLocalizedName() $ ":", X, Y+YL*8, FontScalar);
		DrawTextShadowHRightVCenter(string(hu), X, Y+YL*8, Width, FontScalar);
		DrawTextShadowHLeftVCenter("  " $ class'KFGameContent.KFPawn_ZedSiren'.static.GetLocalizedName() $ ":", X, Y+YL*9, FontScalar);
		DrawTextShadowHRightVCenter(string(si), X, Y+YL*9, Width, FontScalar);
		DrawTextShadowHLeftVCenter("  " $ class'KFGameContent.KFPawn_ZedBloat'.static.GetLocalizedName() $ ":", X, Y+YL*10, FontScalar);
		DrawTextShadowHRightVCenter(string(bl), X, Y+YL*10, Width, FontScalar);
				
		DrawTextShadowHLeftVCenter(TrashKillsString $ ":", X, Y+YL*(12), FontScalar);
		DrawTextShadowHRightVCenter(string(gf+gf2+st+cr+ecr+ri+sl+al+cy), X, Y+YL*(12), Width, FontScalar);
		DrawTextShadowHLeftVCenter("  " $ class'KFGameContent.KFPawn_ZedStalker'.static.GetLocalizedName() $ ":", X, Y+YL*(13), FontScalar);
		DrawTextShadowHRightVCenter(string(st), X, Y+YL*(13), Width, FontScalar);
		DrawTextShadowHLeftVCenter("  " $ class'KFGameContent.KFPawn_ZedCrawler'.static.GetLocalizedName() $ ":", X, Y+YL*(14), FontScalar);
		DrawTextShadowHRightVCenter(string(cr), X, Y+YL*(14), Width, FontScalar);
		DrawTextShadowHLeftVCenter("  " $ class'KFGameContent.KFPawn_ZedCrawlerKing'.static.GetLocalizedName() $ ":", X, Y+YL*(15), FontScalar);
		DrawTextShadowHRightVCenter(string(ecr), X, Y+YL*(15), Width, FontScalar);
		DrawTextShadowHLeftVCenter("  " $ class'KFGameContent.KFPawn_ZedGorefast'.static.GetLocalizedName() $ ":", X, Y+YL*(16), FontScalar);
		DrawTextShadowHRightVCenter(string(gf), X, Y+YL*(16), Width, FontScalar);
		DrawTextShadowHLeftVCenter("  " $ class'KFGameContent.KFPawn_ZedGorefastDualBlade'.static.GetLocalizedName() $ ":", X, Y+YL*(17), FontScalar);
		DrawTextShadowHRightVCenter(string(gf2), X, Y+YL*(17), Width, FontScalar);
		DrawTextShadowHLeftVCenter("  " $ class'KFGameContent.KFPawn_ZedClot_AlphaKing'.static.GetLocalizedName() $ ":", X, Y+YL*(18), FontScalar);
		DrawTextShadowHRightVCenter(string(ri), X, Y+YL*(18), Width, FontScalar);
		DrawTextShadowHLeftVCenter("  " $ class'KFGameContent.KFPawn_ZedClot_Slasher'.static.GetLocalizedName() $ ":", X, Y+YL*(19), FontScalar);
		DrawTextShadowHRightVCenter(string(sl), X, Y+YL*(19), Width, FontScalar);
		DrawTextShadowHLeftVCenter("  " $ class'KFGameContent.KFPawn_ZedClot_Alpha'.static.GetLocalizedName() $ ":", X, Y+YL*(20), FontScalar);
		DrawTextShadowHRightVCenter(string(al), X, Y+YL*(20), Width, FontScalar);
		DrawTextShadowHLeftVCenter("  " $ class'KFGameContent.KFPawn_ZedClot_Cyst'.static.GetLocalizedName() $ ":", X, Y+YL*(21), FontScalar);
		DrawTextShadowHRightVCenter(string(cy), X, Y+YL*(21), Width, FontScalar);
	}
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

function ButtonClicked(KFGUI_Button Sender)
{
	switch (Sender.ID)
	{
		case 'TeamAward':
			CurState = 'TeamAward';
			break;
		case 'PlayerStats':
			CurState = 'PlayerStats';
			break;
		case 'MapVote':
			GetCDPC().OpenMapVote();
			DoClose();
			break;
		case 'Close':
			DoClose();
			break;
	}
}

defaultproperties
{
	XPosition=0.18
	YPosition=0.05
	XSize=0.64
	YSize=0.9

//	Buttons
	Begin Object Class=KFGUI_Button Name=TeamAward
		XPosition=0.05
		YPosition=0.94
		XSize=0.2
		YSize=0.05
		FontScale=1.5
		ID="TeamAward"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Begin Object Class=KFGUI_Button Name=PlayerStats
		XPosition=0.275
		YPosition=0.94
		XSize=0.2
		YSize=0.05
		FontScale=1.5
		ID="PlayerStats"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Begin Object Class=KFGUI_Button Name=MapVote
		XPosition=0.50
		YPosition=0.94
		XSize=0.2
		YSize=0.05
		FontScale=1.5
		ID="MapVote"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Begin Object Class=KFGUI_Button Name=Close
		XPosition=0.725
		YPosition=0.94
		XSize=0.2
		YSize=0.05
		FontScale=1.5
		ID="Close"
		OnClickLeft=ButtonClicked
		TextColor=(R=255, G=255, B=255, A=255)
	End Object

	Components.Add(TeamAward)
	Components.Add(PlayerStats)
	Components.Add(MapVote)
	Components.Add(Close)
}