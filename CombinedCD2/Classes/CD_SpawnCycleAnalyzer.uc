class CD_SpawnCycleAnalyzer extends Object
	within Actor
	DependsOn(CD_Domain);

`include(CD_Log.uci)

var array< class<KFPawn_Monster> > CDZedClass;
var array<int> Count;
var array<float> WSMulti, DMod;
var int TrashAmount, MediumAmount, LargeAmount;
var CD_SpawnCycleCatalog SpawnCycleCatalog;

struct BZNum
{
	var array<int> Num;
};
var array<BZNum> BZNumArray;

/**
 * Analyzes a spawn cycle.
 * @param CycleName The name of the spawn cycle to analyze.
 * @param TargetWave The specific wave to analyze (0 for all waves).
 * @param TargetWSF The target wave size fakes (number of players).
 * @param GameLength The length of the game (0-Short, 1-Normal, 2-Long).
 * @param Messages Output array for messages.
 * @param bBrief If true, prints a brief analysis.
 * @return struct SpawnCycleAnalysis with analysis results. @ref CD_Domain.SpawnCycleAnalysis
 */
public function SpawnCycleAnalysis Analyze(string CycleName, int TargetWave, int TargetWSF, int GameLength, int GameDifficulty, optional bool bBrief, optional bool bForList)
{
	local SpawnCycleAnalysis Analysis;
	local CD_SpawnCycle_Preset SCP;
	local int wave;

	if (SpawnCycleCatalog == None)
	{
		SpawnCycleCatalog = new class'CD_SpawnCycleCatalog';
		SpawnCycleCatalog.ClientSetup();
	}

	if(!(SpawnCycleCatalog.ExistThisCycle(CycleName, SCP)))
	{
		Analysis.ErrorMessage = "<local>CD_SpawnCycleAnalyzer.MissCycleMsg</local>";
		Analysis.bFailed = true;
		return Analysis;
	}

	Count.length=0;
	Count.length=default.CDZedClass.Length;

	if(TargetWave > 0)
	{
		Analysis = AnalyzeWave(SCP, TargetWave-1, TargetWSF, GameLength, GameDifficulty);

		if (Analysis.bFailed)
		{
			return Analysis;
		}
	}
	else if(TargetWave == 0)
	{
		for(wave=0; wave < ((GameLength * 3) + 4); wave++)
		{
			Analysis = AnalyzeWave(SCP, wave, TargetWSF, GameLength, GameDifficulty);

			if (Analysis.bFailed)
			{
				return Analysis;
			}
		}
	}

	return bForList
		? GenerateAnalysisForList(CycleName, TargetWave, TargetWSF)
		: GenerateAnalysis(CycleName, TargetWave, TargetWSF, bBrief);
}

protected function SpawnCycleAnalysis GenerateAnalysis(string Cycle, int Wave, int WSF, optional bool bBrief)
{
	local int Total, i, Large, Medium, Trash, Bosses, T, M, L;
	local string Header, LargeDetails, LargeBrief, MediumBrief, TrashBrief;
	local SpawnCycleAnalysis Analysis;

	T = TrashAmount;
	M = T + MediumAmount;
	L = M + LargeAmount;

	for(i=0; i<Count.length; i++)
	{
		Total += Count[i];
		if(i<T) Trash += Count[i];
		else if(i<M) Medium += Count[i];
		else if(i<L) Large += Count[i];
		else Bosses += Count[i];
	}

	LargeDetails = "SC=" $ string(Count[M]) $ " | FP=" $ string(Count[M+3] + Count[M+4]) $ " | QP=" $ string(Count[M+1] + Count[M+2]);
	LargeBrief = "Large(" $ string(Round(Large*100/Total)) $ "%)";
	MediumBrief = "Medium(" $ string(Round(Medium*100/Total)) $ "%)";

	if(bBrief)
	{
		Analysis.ShortMessage = LargeDetails $ "\n" $ LargeBrief @ MediumBrief;
		return Analysis;
	}
	
	TrashBrief = "Trash(" $ string(Round(Trash*100/Total)) $ "%)";

	Header = "[" $ Cycle  $ ( (Wave==0) ? "" : (" Wave" $ string(Wave)) ) $ " WSF" $ string(WSF) $ "]";

	Analysis.MediumMessage = Header $ "\n" $ LargeBrief $ "\n" $ MediumBrief $ "\n" $ TrashBrief;
	Analysis.LongMessage = (
		"------------------------------------" $ "\n" $ 
		Header $ "\n" $ 
		"------------------------------------" $ "\n" $ 
		"Large=" $ string(Large) $ "(" $ string(Large*100/Total) $ "%)\n" $
		"Medium=" $ string(Medium) $ "(" $ string(Medium*100/Total) $ "%)\n" $
		"Trash=" $ string(Trash) $ "(" $ string(Trash*100/Total) $ "%)\n" $
		"------------------------------------" $ "\n" $ 
		"Fleshpound=" $ string(Count[M+3] + Count[M+4]) $ "(" $ string((Count[M+3] + Count[M+4])*100/Total) $ "%)\n" $
		"--RagedSpawn(" $ string( (Count[M+4]*100)/(Count[M+3] + Count[M+4]) ) $ "%)\n" $
		"Quarterpound=" $ string(Count[M+1] + Count[M+2]) $ "(" $ string((Count[M+1] + Count[M+2])*100/Total) $ "%)\n" $
		"--RagedSpawn(" $ string( (Count[M+2]*100)/(Count[M+1] + Count[M+2]) ) $ "%)\n" $
		"Scrake=" $ string(Count[M]) $ "(" $ string(Count[M]*100/Total) $ "%)\n" $
		"------------------------------------" $ "\n" $ 
		"Bloat=" $ string(Count[T]) $ "(" $ string(Count[T]*100/Total) $ "%)\n" $
		"Siren=" $ string(Count[T+1]) $ "(" $ string(Count[T+1]*100/Total) $ "%)\n" $
		"Husk=" $ string(Count[T+2]) $ "(" $ string(Count[T+2]*100/Total) $ "%)\n" $
		"EDARTrapper=" $ string(Count[T+3]) $ "(" $ string(Count[T+3]*100/Total) $ "%)\n" $
		"EDARBlaster=" $ string(Count[T+4]) $ "(" $ string(Count[T+4]*100/Total) $ "%)\n" $
		"EDARBomber=" $ string(Count[T+5]) $ "(" $ string(Count[T+5]*100/Total) $ "%)\n" $
		"EDARRandom=" $ string(Count[T+6]+Count[T+7]) $ "(" $ string((Count[T+6]+Count[T+7])*100/Total) $ "%)\n" $
		"------------------------------------" $ "\n" $ 
		"Cyst=" $ string(Count[0]) $ "(" $ string(Count[0]*100/Total) $ "%)\n" $
		"AlphaClot=" $ string(Count[1]) $ "(" $ string(Count[1]*100/Total) $ "%)\n" $
		"Slasher=" $ string(Count[2]) $ "(" $ string(Count[2]*100/Total) $ "%)\n" $
		"Rioter=" $ string(Count[3]) $ "(" $ string(Count[3]*100/Total) $ "%)\n" $
		"Gorefast=" $ string(Count[4]) $ "(" $ string(Count[4]*100/Total) $ "%)\n" $
		"Gorefiend=" $ string(Count[5]) $ "(" $ string(Count[5]*100/Total) $ "%)\n" $
		"Crawler=" $ string(Count[6]) $ "(" $ string(Count[6]*100/Total) $ "%)\n" $
		"EliteCrawler=" $ string(Count[7]) $ "(" $ string(Count[7]*100/Total) $ "%)\n" $
		"Stalker=" $ string(Count[8]) $ "(" $ string(Count[8]*100/Total) $ "%)\n" $
		"------------------------------------"
	);

	if(Bosses > 0)
	{
		Analysis.AdditionalMessage = (
			"Boss=" $ string(Bosses) $ "(" $ string(Bosses*100/Total) $ "%)\n" $
			"AbominationSpawn=" $ string(Count[L]) $ "(" $ string(Count[L]*100/Total) $ "%)\n" $
			"Dr.HansVolter=" $ string(Count[L+1]) $ "(" $ string(Count[L+1]*100/Total) $ "%)\n" $
			"Patriarch=" $ string(Count[L+2]) $ "(" $ string(Count[L+2]*100/Total) $ "%)\n" $
			"KingFleshpound=" $ string(Count[L+3]) $ "(" $ string(Count[L+3]*100/Total) $ "%)\n" $
			"Abomination=" $ string(Count[L+4]) $ "(" $ string(Count[L+4]*100/Total) $ "%)\n" $
			"Matriarch=" $ string(Count[L+5]) $ "(" $ string(Count[L+5]*100/Total) $ "%)\n" $
			"------------------------------------"
		);
	}

	return Analysis;
}

protected function SpawnCycleAnalysis GenerateAnalysisForList(string Cycle, int Wave, int WSF)
{
	local int ClotsNum, GorefastsNum, CrawlersAndStalkersNum, ScrakesNum, PoundsNum, AlbinoNum, RobotsNum, BossesNum, OthersNum;
	local int TrashNum, MediumNum, LargeNum, TotalNum;
	local int RandomEDARNum, QPNum, FPNum;
	local SpawnCycleAnalysis Analysis;

	ClotsNum = Count[0] + Count[1] + Count[2] + Count[3];
	GorefastsNum = Count[4] + Count[5];
	CrawlersAndStalkersNum = Count[6] + Count[7] + Count[8];
	ScrakesNum = Count[17];
	QPNum = Count[18] + Count[19];
	FPNum = Count[20] + Count[21];
	PoundsNum = QPNum + FPNum;
	AlbinoNum = Count[3] + Count[5] + Count[7];
	RandomEDARNum = Count[15] + Count[16];
	RobotsNum = Count[12] + Count[13] + Count[14] + RandomEDARNum;
	BossesNum = Count[22] + Count[23] + Count[24] + Count[25] + Count[26] + Count[27];
	OthersNum = Count[9] + Count[10] + Count[11];

	TrashNum = ClotsNum + GorefastsNum + CrawlersAndStalkersNum;
	MediumNum = OthersNum + RobotsNum;
	LargeNum = ScrakesNum + PoundsNum;
	TotalNum = TrashNum + MediumNum + LargeNum + BossesNum;

	if (TotalNum == 0)
	{
		return Analysis;
	}

	Analysis.Categories.AddItem("Trash" $ "\n" $ string(TrashNum) $ "\n" $ CalcPercent(TrashNum, TotalNum));
	Analysis.Categories.AddItem("Medium" $ "\n" $ string(MediumNum) $ "\n" $ CalcPercent(MediumNum, TotalNum));
	Analysis.Categories.AddItem("Large" $ "\n" $ string(LargeNum) $ "\n" $ CalcPercent(LargeNum, TotalNum));
	if (BossesNum > 0)
	{
		Analysis.Categories.AddItem("Bosses" $ "\n" $ string(BossesNum) $ "\n" $ CalcPercent(BossesNum, TotalNum));
	}
	Analysis.Categories.AddItem("Total" $ "\n" $ string(TotalNum) $ "\n" $ "100%");

	Analysis.Groups.AddItem("Clots" $ "\n" $ string(ClotsNum) $ "\n" $ CalcPercent(ClotsNum, TotalNum));
	Analysis.Groups.AddItem("Gorefasts" $ "\n" $ string(GorefastsNum) $ "\n" $ CalcPercent(GorefastsNum, TotalNum));
	Analysis.Groups.AddItem("Crawlers / Stalkers" $ "\n" $ string(CrawlersAndStalkersNum) $ "\n" $ CalcPercent(CrawlersAndStalkersNum, TotalNum));
	Analysis.Groups.AddItem("Scrakes" $ "\n" $ string(ScrakesNum) $ "\n" $ CalcPercent(ScrakesNum, TotalNum));
	Analysis.Groups.AddItem("Fleshpounds" $ "\n" $ string(PoundsNum) $ "\n" $ CalcPercent(PoundsNum, TotalNum));
	Analysis.Groups.AddItem("Albino" $ "\n" $ string(AlbinoNum) $ "\n" $ CalcPercent(AlbinoNum, TotalNum));
	if (RobotsNum > 0)
	{
		Analysis.Groups.AddItem("Robots" $ "\n" $ string(RobotsNum) $ "\n" $ CalcPercent(RobotsNum, TotalNum));
	}
	if (BossesNum > 0)
	{
		Analysis.Groups.AddItem("Bosses" $ "\n" $ string(BossesNum) $ "\n" $ CalcPercent(BossesNum, TotalNum));
	}
	Analysis.Groups.AddItem("Others" $ "\n" $ string(OthersNum) $ "\n" $ CalcPercent(OthersNum, TotalNum));

	Analysis.Types.AddItem("Cyst" $ "\n" $ string(Count[0]) $ "\n" $ CalcPercent(Count[0], TotalNum));
	Analysis.Types.AddItem("AlphaClot" $ "\n" $ string(Count[1]) $ "\n" $ CalcPercent(Count[1], TotalNum));
	Analysis.Types.AddItem("Slasher" $ "\n" $ string(Count[2]) $ "\n" $ CalcPercent(Count[2], TotalNum));
	Analysis.Types.AddItem("Rioter" $ "\n" $ string(Count[3]) $ "\n" $ CalcPercent(Count[3], TotalNum));
	Analysis.Types.AddItem("Gorefast" $ "\n" $ string(Count[4]) $ "\n" $ CalcPercent(Count[4], TotalNum));
	Analysis.Types.AddItem("Gorefiend" $ "\n" $ string(Count[5]) $ "\n" $ CalcPercent(Count[5], TotalNum));
	Analysis.Types.AddItem("Crawler" $ "\n" $ string(Count[6]) $ "\n" $ CalcPercent(Count[6], TotalNum));
	Analysis.Types.AddItem("EliteCrawler" $ "\n" $ string(Count[7]) $ "\n" $ CalcPercent(Count[7], TotalNum));
	Analysis.Types.AddItem("Stalker" $ "\n" $ string(Count[8]) $ "\n" $ CalcPercent(Count[8], TotalNum));
	Analysis.Types.AddItem("Bloat" $ "\n" $ string(Count[9]) $ "\n" $ CalcPercent(Count[9], TotalNum));
	Analysis.Types.AddItem("Siren" $ "\n" $ string(Count[10]) $ "\n" $ CalcPercent(Count[10], TotalNum));
	Analysis.Types.AddItem("Husk" $ "\n" $ string(Count[11]) $ "\n" $ CalcPercent(Count[11], TotalNum));
	if (Count[12] > 0)
	{
		Analysis.Types.AddItem("EDARTrapper" $ "\n" $ string(Count[12]) $ "\n" $ CalcPercent(Count[12], TotalNum));
	}
	if (Count[13] > 0)
	{
		Analysis.Types.AddItem("EDARBlaster" $ "\n" $ string(Count[13]) $ "\n" $ CalcPercent(Count[13], TotalNum));
	}
	if (Count[14] > 0)
	{
		Analysis.Types.AddItem("EDARBomber" $ "\n" $ string(Count[14]) $ "\n" $ CalcPercent(Count[14], TotalNum));
	}
	if (RandomEDARNum > 0)
	{
		Analysis.Types.AddItem("EDARRandom" $ "\n" $ string(RandomEDARNum) $ "\n" $ CalcPercent(RandomEDARNum, TotalNum));
	}
	Analysis.Types.AddItem("Scrake" $ "\n" $ string(Count[17]) $ "\n" $ CalcPercent(Count[17], TotalNum));
	Analysis.Types.AddItem("Quarterpound" $ "\n" $ string(QPNum) $ "\n" $ CalcPercent(QPNum, TotalNum));
	Analysis.Types.AddItem("Fleshpound" $ "\n" $ string(FPNum) $ "\n" $ CalcPercent(FPNum, TotalNum));
	if (BossesNum > 0)
	{
		Analysis.Types.AddItem("AbominationSpawn" $ "\n" $ string(Count[22]) $ "\n" $ CalcPercent(Count[22], TotalNum));
		Analysis.Types.AddItem("Dr.HansVolter" $ "\n" $ string(Count[23]) $ "\n" $ CalcPercent(Count[23], TotalNum));
		Analysis.Types.AddItem("Patriarch" $ "\n" $ string(Count[24]) $ "\n" $ CalcPercent(Count[24], TotalNum));
		Analysis.Types.AddItem("KingFleshpound" $ "\n" $ string(Count[25]) $ "\n" $ CalcPercent(Count[25], TotalNum));
		Analysis.Types.AddItem("Abomination" $ "\n" $ string(Count[26]) $ "\n" $ CalcPercent(Count[26], TotalNum));
		Analysis.Types.AddItem("Matriarch" $ "\n" $ string(Count[27]) $ "\n" $ CalcPercent(Count[27], TotalNum));
		Analysis.Types.AddItem("BossesTotal" $ "\n" $ string(BossesNum) $ "\n" $ CalcPercent(BossesNum, TotalNum));
	}
	Analysis.Types.AddItem("Total" $ "\n" $ string(TotalNum) $ "\n" $ "100%");

	return Analysis;
}

private function string CalcPercent(int TargetCount, int Total)
{
	local float Percent, FixedPercent;

	Percent = (float(TargetCount) / float(Total)) * 100.f;
	FixedPercent = Round(Percent * 100.f) / 100.f;
	return string(FixedPercent) $ "%";
}

/**
 * Analyzes a spawn cycle definition and stores the counts in the global count array.
 * @param Def The spawn cycle definition string. e.g. "2SC_1CY,3SC_2CY,1SC_3CY"
 * @param WaveSize The total amount of zeds in a wave to analyze.
 */
protected function AnalyzeDef(string Def, int WaveSize)
{
	local int i, j, k, ElemCount, TotalCount;
	local array<string> SquadDefs, Group;
	local string ZedName;
	local bool bSpecial, bRage;
	local EAIType ZedType;
	local class<KFPawn_Monster> ZedClass;

	ParseStringIntoArray(Def, SquadDefs, ",", true);
	TotalCount = 0;

	do
	{
		for(i=0; i<SquadDefs.length; i++)
		{
			ParseStringIntoArray(SquadDefs[i], Group, "_", true);
			for(j=0; j<Group.length; j++)
			{
				//	Amount of zeds in this group
				ElemCount = GetNumber(Group[j], ZedName);

				//	Check if zeds count is fewer than wave size
				if(TotalCount + ElemCount > WaveSize)
					ElemCount = WaveSize - TotalCount;
				TotalCount += ElemCount;

				//	Handle specialty
				bSpecial = HandleZedMod(ZedName, "*");
				bRage = (!bSpecial && HandleZedMod(ZedName, "!"));
				
				class'CD_ZedNameUtils'.static.GetZedType(ZedName, bSpecial, bRage, ZedType, ZedClass);

				for(k=0; k<CDZedClass.length; k++)
				{
					if(CDZedClass[k] == ZedClass)
						Count[k] += ElemCount;
				}

				if(TotalCount >= WaveSize)
					return;
			}
		}
	}until(TotalCount >= WaveSize);
}

protected function SpawnCycleAnalysis AnalyzeWave(CD_SpawnCycle_Preset SCP, int WaveIdx, int PlayerCount, int GameLength, int GameDifficulty)
{
	local SpawnCycleAnalysis Analysis;
	local int WaveSize;
	local array<string> CycleDefs;

	WaveSize = GetWaveSize(WaveIdx, PlayerCount, GameLength, GameDifficulty);

	switch( GameLength )
	{
		case GL_Short:  SCP.GetShortSpawnCycleDefs( CycleDefs );  break;
		case GL_Normal: SCP.GetNormalSpawnCycleDefs( CycleDefs ); break;
		case GL_Long:   SCP.GetLongSpawnCycleDefs( CycleDefs );   break;
	};

	if ( 0 == CycleDefs.length )
	{
		Analysis.ErrorMessage = "<local>CD_SpawnCycleAnalyzer.LengthMissMatchMsg</local>";
		Analysis.bFailed = true;
		return Analysis;
	}

	AnalyzeDef(CycleDefs[WaveIdx], WaveSize);

	Analysis.bFailed = false;
	return Analysis;
}

public function SpawnCycleAnalysis VanillaAnalyze(int WaveIdx, int PlayerCount, int GameLength, int GameDifficulty, optional int TryNum=1)
{
	local int i, j;
	local float TimeSeconds;

	TryNum = Max(1, TryNum);

	Count.length=0;
	Count.length=default.CDZedClass.Length;
	TimeSeconds = Outer.WorldInfo.TimeSeconds;

	for(i=0; i<TryNum; i++)
	{
		if(WaveIdx > 0)
		{
			VanillaAnalyzePerWave(WaveIdx-1, PlayerCount, GameLength, GameDifficulty);
		}
		else if(WaveIdx == 0)
		{
			for(j=0; j<((GameLength*3)+4); j++)
			{
				VanillaAnalyzePerWave(j, PlayerCount, GameLength, GameDifficulty);
			}
		}
		`cdlog("Analyzing..." @ string(100*(float(i)/float(TryNum))) $ "%");
	}
	TimeSeconds = Outer.WorldInfo.TimeSeconds - TimeSeconds;
	`cdlog("Analysis took" @ string(TimeSeconds) $ "s.");

	return GenerateAnalysis("vanilla (" $ string(TryNum) $ ")", WaveIdx, PlayerCount, false);
}

function VanillaAnalyzePerWave(int WaveIdx, int PlayerCount, int GameLength, int GameDifficulty)
{
	local int WaveSize;
	local string VanillaCycle;

	VanillaCycle = GetVanillaCycle(WaveIdx, PlayerCount, GameLength, GameDifficulty, WaveSize);
	AnalyzeDef(VanillaCycle, WaveSize);
}

function string GetVanillaCycle(int WaveIdx, int PlayerCount, int GameLength, int GameDifficulty, out int WaveSize)
{
	local int LeftSize, NumCycles, NumSpecialRecycles, TotalCount, TotalZedsInSquads;
	local int i, j, RandNum;
	local bool bNeedsSpecial, bForceSpecial;
	local KFAIWaveInfo WaveInfo;
	local array<KFAISpawnSquad> AvailableSquads;
	local array< class<KFPawn_Monster> > NewSquad, SpecialSquad;
	local array<string> Squads;
	local string Cycle;

	// Setup Wave Info
	WaveSize = GetWaveSize(WaveIdx, PlayerCount, GameLength, GameDifficulty);
	TotalCount = 0;
	NumCycles = 0;
	WaveInfo = class'KFGameInfo_Survival'.default.SpawnManagerClasses[GameLength].default.DifficultyWaveSettings[GameDifficulty].Waves[WaveIdx-1];

	do
	{
		if(AvailableSquads.length == 0)
		{
			// Call AI Wave Info
			bNeedsSpecial = class'KFGame.KFAISpawnManager'.default.RecycleSpecialSquad[GameDifficulty] && NumCycles % 2 == 1;
			NumCycles++;
			WaveInfo.GetNewSquadList(AvailableSquads);
			if(bNeedsSpecial)
			{
				WaveInfo.GetSpecialSquad(AvailableSquads);
				for(i=0; i<AvailableSquads.length; i++)
				{
					for(j=0; j<AvailableSquads[i].MonsterList.length; j++)
					{
						TotalZedsInSquads += AvailableSquads[i].MonsterList[j].Num;
					}
				}

				if(WaveSize < TotalZedsInSquads)
				{
					bForceSpecial = true;
				}
				++NumSpecialRecycles;
			}
		}

		// Setup Squad by random choosing
		RandNum = Rand(AvailableSquads.length);
		if(bForceSpecial && RandNum == (AvailableSquads.Length - 1))
		{
			bForceSpecial = false;
		}

		GetListFromSquad(RandNum, AvailableSquads, NewSquad);

		// Special Squad Chance
		if(bForceSpecial)
		{
			GetListFromSquad(AvailableSquads.Length-1, AvailableSquads, SpecialSquad);
			if(TotalCount + NewSquad.length + SpecialSquad.length > WaveSize)
			{
				NewSquad = SpecialSquad;
				RandNum = AvailableSquads.Length-1;
				bForceSpecial = false;
			}
		}

		AvailableSquads.Remove(RandNum, 1);
		LeftSize = WaveSize - TotalCount;

		if(LeftSize < NewSquad.length)
		{
			NewSquad.length = LeftSize;
		}

		Squads.AddItem(GetSquadDefFromPawn(NewSquad, GameDifficulty));
		TotalCount += NewSquad.length;
	}until(TotalCount >= WaveSize);

	JoinArray(Squads, Cycle, ",");
	//`cdlog("Cycle=" $ Cycle);
	return Cycle;
}

function GetListFromSquad(byte SquadIdx, out array<KFAISpawnSquad> SquadsList, out array< class<KFPawn_Monster> > PawnList)
{
	local KFAISpawnSquad Squad;
	local int i, j;
	local array< class<KFPawn_Monster> > TempList;

	// Read squad as Pawn Class
	Squad = SquadsList[SquadIdx];

	for(i=0; i<Squad.MonsterList.length; i++)
	{
		for(j=0; j<Squad.MonsterList[i].Num; j++)
		{
			if( Squad.MonsterList[i].CustomClass != None )
			{
				TempList.AddItem(Squad.MonsterList[i].CustomClass);
			}
			else
			{
				TempList.AddItem(SpawnCycleCatalog.GetAIClassList()[Squad.MonsterList[i].Type]);
			}
		}
	}

	// Shuffle
	while(TempList.length > 0)
	{
		i = Rand(TempList.length);
		PawnList.AddItem(TempList[i]);
		TempList.Remove(i, 1);
	}
}

function string GetSquadDefFromPawn(out array< class<KFPawn_Monster> > Squad, int GameDifficulty)
{
	local int i, RandNum, GroupSize;
	local string ZedCode, Def;
	local array<string> Elements;

	for(i=0; i<Squad.length; i++)
	{
		ZedCode = "";
		if( Squad[i].default.ElitePawnClass.length > 0 && FRand() < Squad[i].default.DifficultySettings.default.ChanceToSpawnAsSpecial[GameDifficulty])
		{
			if(Squad[i].default.ElitePawnClass.length == 1)
			{
				ZedCode = "*";
			}
			else
			{
				RandNum = Rand(Squad[i].default.ElitePawnClass.length);
				Squad[i] = Squad[i].default.ElitePawnClass[RandNum];
			}
		}
		ZedCode = class'CD_ZedNameUtils'.static.GetCycleNameFromOGClass(Squad[i]) $ ZedCode;
		Elements.AddItem(ZedCode);
	}

	GroupSize = 1;
	for(i=Elements.length-1; i>=0; i--)
	{
		if(i != 0 && Elements[i] ~= Elements[i-1])
		{
			++GroupSize;
		}
		else
		{
			Elements[i] = string(GroupSize) $ Elements[i];
			if(GroupSize > 1)
			{
				Elements.Remove(i+1, GroupSize-1);
				GroupSize = 1;
			}
		}
	}

	JoinArray(Elements, Def, "_");
	//`cdlog("Squad=" $ Def);
	return Def;
}

function GetVanillaCycleDefs(byte GL, byte Dif, byte Wave, out array<string> result)
{
	local KFAIWaveInfo WaveInfo;

	WaveInfo = class'KFGameInfo_Survival'.default.SpawnManagerClasses[GL].default.DifficultyWaveSettings[Dif].Waves[Wave-1];
	result.length = 2;
	result[0] = GetCycleDef(WaveInfo.Squads);
	result[1] = GetCycleDef(WaveInfo.SpecialSquads);
}

function string GetCycleDef(array<KFAISpawnSquad> SpawnSquads)
{
	local int i, j;
	local AISquadElement Elem;
	local class<KFPawn_Monster> ZedClass;
	local array<string> Elems, Squads;
	local string TempString;

	for(i=0; i<SpawnSquads.length; i++)
	{
		for(j=0; j<SpawnSquads[i].MonsterList.length; j++)
		{
			Elem = SpawnSquads[i].MonsterList[j];
			ZedClass = (Elem.CustomClass == None) ? SpawnCycleCatalog.GetAIClassList()[Elem.Type] : Elem.CustomClass;
			Elems.AddItem(string(Elem.Num) $ "-" $ class'CD_ZedNameUtils'.static.GetCycleNameFromOGClass(ZedClass));
		}
		JoinArray(Elems, TempString, "_");
		Squads.AddItem(TempString);
	}
	JoinArray(Squads, TempString, ",");
	return TempString;
}

function string SpawnOrderOverview(string CycleName, int GameLength, int GameDifficulty)
{
	local CD_SpawnCycle_Preset SCP;
	local array<string> CycleDefs, SquadDefs, Group;
	local string FinalDef, ZedName, Result, TempGroup;
	local int i, j, ElemCount, TempTotal, WaveSize, TotalCount;
	local EAIType ZedType;
	local class<KFPawn_Monster> ZedClass;

	if(!(SpawnCycleCatalog.ExistThisCycle(CycleName, SCP)))
	{
		return "\nError";
	}
	SCP.GetLongSpawnCycleDefs( CycleDefs );
	FinalDef = CycleDefs[9];
	ParseStringIntoArray(FinalDef, SquadDefs, ",", true);
	WaveSize = GetWaveSize(9, 12, GameLength, GameDifficulty);
	Result = "\n";
	TotalCount = 0;

	do
	{
		for(i=0; i<SquadDefs.length; i++)
		{
			ParseStringIntoArray(SquadDefs[i], Group, "_", true);
			for(j=0; j<Group.length; j++)
			{
				ElemCount = GetNumber(Group[j], ZedName);

				if(TotalCount + ElemCount > WaveSize)
					ElemCount = WaveSize - TotalCount;
				TotalCount += ElemCount;

				class'CD_ZedNameUtils'.static.GetZedType(ZedName, false, false, ZedType, ZedClass);

				if( ZedClass == CDZedClass[11] || 
					ZedClass == CDZedClass[17] ||
					ZedClass == CDZedClass[18] ||
					ZedClass == CDZedClass[19] ||
					ZedClass == CDZedClass[20] ||
					ZedClass == CDZedClass[21] )
				{
					if(TempGroup != "")
						TempGroup $= "_";
					TempGroup $= Group[j];
				}
				else
				{
					TempTotal += ElemCount;
				}	
				
				if(TotalCount >= WaveSize)
				{
					if(TempTotal > 0)
						Result $= string(TempTotal) $ "\n";
					if(TempGroup != "")
						Result $= TempGroup $ "\n";
					return Result;
				}
			}

			if(TempGroup != "")
			{
				Result $= string(TempTotal) $ "\n" $ TempGroup $ "\n";
				TempTotal = 0;
				TempGroup = "";
			}
		}
	}until(TotalCount >= WaveSize);

	return Result;
}

function bool HandleZedMod(out string ZedName, string Key)
{
	local int KeyLen;

	KeyLen = Len(Key);

	if(Right(ZedName, KeyLen) ~= Key)
	{
		ZedName = Left(ZedName, Len(ZedName)-KeyLen);
		return true;
	}

	if(Left(ZedName, KeyLen) ~= Key)
	{
		ZedName = Right(ZedName, Len(ZedName)-KeyLen);
		return true;
	}
	return false;
}

static function int GetWaveSize(int WaveIdx, int PlayerCount, int GameLength, int GameDifficulty)
{
	local float WaveSizeMulti, BaseZedNum, DifficultyMod;

	WaveSizeMulti = (PlayerCount <= 6)
		? default.WSMulti[PlayerCount-1]
		: default.WSMulti[5] + (float(PlayerCount - 6)*0.211718f);

	BaseZedNum = default.BZNumArray[GameLength].Num[WaveIdx];
	DifficultyMod = default.DMod[GameDifficulty];

	return Round(BaseZedNum * DifficultyMod * WaveSizeMulti);
}

function int GetNumber(string s, out string ZedName)
{
	local int i, UnicodePoint;

	for(i=0; i<Len(s); i++)
	{
		UnicodePoint = Asc( Mid( s, i, 1 ) );
		if ( !( 48 <= UnicodePoint && UnicodePoint <= 57 ) ) break;
	}
	ZedName = Mid(s,i);
	return (i == 0) ? 0 : int(Mid(s, 0, i));
}

defaultproperties
{
	TrashAmount = 9
	MediumAmount = 8
	LargeAmount = 5

//	Trash
	CDZedClass.Add(class'KFGameContent.KFPawn_ZedClot_Cyst') //0
	CDZedClass.Add(class'CD_Pawn_ZedClot_Alpha_Regular')
	CDZedClass.Add(class'KFGameContent.KFPawn_ZedClot_Slasher')
	CDZedClass.Add(class'CD_Pawn_ZedClot_Alpha_Special')
	CDZedClass.Add(class'CD_Pawn_ZedGorefast_Regular')
	CDZedClass.Add(class'CD_Pawn_ZedGorefast_Special')
	CDZedClass.Add(class'CD_Pawn_ZedCrawler_Regular')
	CDZedClass.Add(class'CD_Pawn_ZedCrawler_Special')
	CDZedClass.Add(class'CD_Pawn_ZedStalker_Regular')
//	Medium
	CDZedClass.Add(class'KFGameContent.KFPawn_ZedBloat') //9
	CDZedClass.Add(class'KFGameContent.KFPawn_ZedSiren')
	CDZedClass.Add(class'CD_Pawn_ZedHusk_Regular')
	CDZedClass.Add(class'KFPawn_ZedDAR_EMP')
	CDZedClass.Add(class'KFPawn_ZedDAR_Laser')
	CDZedClass.Add(class'KFPawn_ZedDAR_Rocket')
	CDZedClass.Add(class'CD_Pawn_ZedStalker_Special')
	CDZedClass.Add(class'CD_Pawn_ZedHusk_Special')
//	Large
	CDZedClass.Add(class'KFGameContent.KFPawn_ZedScrake') //17
	CDZedClass.Add(class'CD_Pawn_ZedFleshpoundMini_NRS')
	CDZedClass.Add(class'CD_Pawn_ZedFleshpoundMini_RS')
	CDZedClass.Add(class'CD_Pawn_ZedFleshpound_NRS')
	CDZedClass.Add(class'CD_Pawn_ZedFleshpound_RS')
//	Boss
	CDZedClass.Add(class'KFPawn_ZedBloatKingSubspawn')
	CDZedClass.Add(class'KFPawn_ZedHans')
	CDZedClass.Add(class'KFPawn_ZedPatriarch')
	CDZedClass.Add(class'KFPawn_ZedFleshpoundKing')
	CDZedClass.Add(class'KFPawn_ZedBloatKing')
	CDZedClass.Add(class'KFPawn_ZedMatriarch')

	WSMulti = (1.f, 2.f, 2.75f, 3.5f, 4.f, 4.5f)
	DMod = (0.85f, 1.f, 1.3f, 1.7f)
	BZNumArray.Add((Num=(25, 32, 35, 42)))
	BZNumArray.Add((Num=(25, 28, 32, 32, 35, 40, 42)))
	BZNumArray.Add((Num=(25, 28, 32, 32, 35, 35, 35, 40, 42, 42)))
}
