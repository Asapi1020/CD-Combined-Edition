class CD_SpawnCycleAnalyzer extends Object
	within CD_Survival
	DependsOn(CD_Survival);

`include(CD_Log.uci)

var array< class<KFPawn_Monster> > CDZedClass;
var array<int> Count;
var array<float> WSMulti, DMod;
var int TrashAmount, MediumAmount, LargeAmount;

struct BZNum
{
	var array<int> Num;
};
var array<BZNum> BZNumArray;

function TrySCA(string s, optional bool bBrief)
{
	//	s = "!cdsca cyclename wavex wsfxx"
	local array<string> splitbuf;
	local string CycleName;
	local int TargetWave, TargetWSF;
	
	ParseStringIntoArray(s, splitbuf, " ", true);
	SetSCAOption(splitbuf, CycleName, TargetWave, TargetWSF);
	TrySCACore(CycleName, TargetWave, TargetWSF, bBrief);
}

function SetSCAOption(array<string> options, out string cycle, out int wave, out int wsf)
{
	local string option;
	local CD_SpawnCycle_Preset SCP;

	foreach options(option)
	{
		if (Left(option, 4) == "wave") wave = Clamp(int(Mid(option, 4)), 0, 11);
		else if (Left(option, 3) == "wsf") wsf = Max(int(Mid(option, 3)), 1);
		else if (SpawnCycleCatalog.ExistThisCycle(option, SCP)) cycle = option;
	}

	if(cycle == "") cycle = SpawnCycle;
	if(wsf < 1) wsf = Max(1, WaveSizeFakesInt);
}

function TrySCACore(string CycleName, int TargetWave, int TargetWSF, optional bool bBrief)
{
	local int i;
	local CD_SpawnCycle_Preset SCP;

	if(!(SpawnCycleCatalog.ExistThisCycle(CycleName, SCP)))
	{
		BroadcastLocalizedEcho("<local>CD_SpawnCycleAnalyzer.MissCycleMsg</local>");
		return;
	}

	Count.length=0;
	Count.length=default.CDZedClass.Length;
	if(TargetWave > 0) CycleAnalyzePerWave(SCP, TargetWave-1, TargetWSF);
	else if(TargetWave == 0)
	{
		for(i=0; i<((GameLength*3)+4); i++) CycleAnalyzePerWave(SCP, i, TargetWSF);
	}
	PrintAnalisis(CycleName, TargetWave, TargetWSF, bBrief);
}

function PrintAnalisis(string Cycle, int Wave, int WSF, optional bool bBrief)
{
	local int Total, i, Large, Medium, Trash, Bosses, T, M, L;
	local string s, s1, s2;

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

	s = "SC=" $ string(Count[M]) $ " | FP=" $ string(Count[M+3] + Count[M+4]) $ " | QP=" $ string(Count[M+1] + Count[M+2]) $ "\n" $ 
		"Large(" $ string(Round(Large*100/Total)) $ "%)";
	s1 = "Medium(" $ string(Round(Medium*100/Total)) $ "%)";
	s2 = "Trash(" $ string(Round(Trash*100/Total)) $ "%)";

	if(bBrief)
	{
		DisplayCycleAnalisisInHUD(Cycle, s @ s1);
		return;
	}

	s = "[" $ Cycle  $ ( (Wave==0) ? "" : (" Wave" $ string(Wave)) ) $ " WSF" $ string(WSF) $ "]\n" $
		s $ "\n" $ s1 $ "\n" $ s2;

	BroadcastCDEcho(s);
	BroadcastCDEcho( "------------------------------------" $ "\n" $ 
					 "[" $ Cycle $  ( (Wave==0) ? "" : (" Wave" $ string(Wave)) ) $ " WSF" $ string(WSF) $ "]\n" $
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
					 "------------------------------------");
	if(Bosses>0)
	{
		BroadcastCDEcho("Boss=" $ string(Bosses) $ "(" $ string(Bosses*100/Total) $ "%)\n" $
						"AbominationSpawn=" $ string(Count[L]) $ "(" $ string(Count[L]*100/Total) $ "%)\n" $
						"Dr.HansVolter=" $ string(Count[L+1]) $ "(" $ string(Count[L+1]*100/Total) $ "%)\n" $
						"Patriarch=" $ string(Count[L+2]) $ "(" $ string(Count[L+2]*100/Total) $ "%)\n" $
						"KingFleshpound=" $ string(Count[L+3]) $ "(" $ string(Count[L+3]*100/Total) $ "%)\n" $
						"Abomination=" $ string(Count[L+4]) $ "(" $ string(Count[L+4]*100/Total) $ "%)\n" $
						"Matriarch=" $ string(Count[L+5]) $ "(" $ string(Count[L+5]*100/Total) $ "%)\n" $
						"------------------------------------");
	}
}

function AnalyzeDef(string Def, int WaveSize)
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
				//	Amout of zeds in this group
				ElemCount = GetNumber(Group[j], ZedName);

				//	Check if zeds count is fewer than wave size
				if(TotalCount + ElemCount > WaveSize)
					ElemCount = WaveSize - TotalCount;
				TotalCount += ElemCount;

				//	Handle speciality
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

function CycleAnalyzePerWave(CD_SpawnCycle_Preset SCP, int WaveIdx, int PlayerCount)
{
	local int WaveSize;
	local array<string> CycleDefs;

	WaveSize = GetWaveSize(WaveIdx, PlayerCount);

	switch( GameLength )
	{
		case GL_Short:  SCP.GetShortSpawnCycleDefs( CycleDefs );  break;
		case GL_Normal: SCP.GetNormalSpawnCycleDefs( CycleDefs ); break;
		case GL_Long:   SCP.GetLongSpawnCycleDefs( CycleDefs );   break;
	};

	if ( 0 == CycleDefs.length )
	{
		BroadcastLocalizedEcho("<local>CD_SpawnCycleAnalyzer.LengthMissMatchMsg</local>");
		return;
	}

	AnalyzeDef(CycleDefs[WaveIdx], WaveSize);
}

function VanillaAnalyze(int WaveIdx, int PlayerCount, optional int TryNum=1)
{
	local int i, j;
	local float TimeSeconds;

	TryNum = Max(1, TryNum);

	Count.length=0;
	Count.length=default.CDZedClass.Length;
	TimeSeconds = WorldInfo.TimeSeconds;

	for(i=0; i<TryNum; i++)
	{
		if(WaveIdx > 0)
		{
			VanillaAnalyzePerWave(WaveIdx-1, PlayerCount);
		}
		else if(WaveIdx == 0)
		{
			for(j=0; j<((GameLength*3)+4); j++)
			{
				VanillaAnalyzePerWave(j, PlayerCount);
			}
		}
		`cdlog("Analyzing..." @ string(100*(float(i)/float(TryNum))) $ "%");
	}
	TimeSeconds = WorldInfo.TimeSeconds - TimeSeconds;
	`cdlog("Analysis took" @ string(TimeSeconds) $ "s.");

	PrintAnalisis("vanilla (" $ string(TryNum) $ ")", WaveIdx, PlayerCount, false);
}

function VanillaAnalyzePerWave(int WaveIdx, int PlayerCount)
{
	local int WaveSize;
	local string VanillaCycle;

	VanillaCycle = GetVanillaCycle(WaveIdx, PlayerCount, WaveSize);
	AnalyzeDef(VanillaCycle, WaveSize);
}

function string GetVanillaCycle(int WaveIdx, int PlayerCount, out int WaveSize)
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
	WaveSize = GetWaveSize(WaveIdx, PlayerCount);
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

		Squads.AddItem(GetSquadDefFromPawn(NewSquad));
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
				TempList.AddItem(GetAISpawnType(Squad.MonsterList[i].Type));
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

function string GetSquadDefFromPawn(out array< class<KFPawn_Monster> > Squad)
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
			ZedClass = Elem.CustomClass == none ? GetAISpawnType(Elem.Type) : Elem.CustomClass;
			Elems.AddItem(string(Elem.Num) $ "-" $ class'CD_ZedNameUtils'.static.GetCycleNameFromOGClass(ZedClass));
		}
		JoinArray(Elems, TempString, "_");
		Squads.AddItem(TempString);
	}
	JoinArray(Squads, TempString, ",");
	return TempString;
}

function string SpawnOrderOverview(string CycleName)
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
	WaveSize = GetWaveSize(9, 12);
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

function int GetWaveSize(int WaveIdx, int PlayerCount)
{
	local float WaveSizeMulti, BaseZedNum, DifficultyMod;

	if(PlayerCount <= 6) WaveSizeMulti = WSMulti[PlayerCount-1];
	else WaveSizeMulti = WSMulti[5] + (float(PlayerCount - 6)*0.211718f);

	BaseZedNum = BZNumArray[GameLength].Num[WaveIdx];
	DifficultyMod = DMod[GameDifficulty];

	return Round(BaseZedNum * DifficultyMod * WaveSizeMulti);
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