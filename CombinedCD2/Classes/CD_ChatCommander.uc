//=============================================================================
// CD_ChatCommander
//=============================================================================
// Manages the ChatCommand datastructures; matches incoming !cd... command
// chat strings and dispatches to the appropriate function.
//=============================================================================

class CD_ChatCommander extends Object
	within CD_Survival
	DependsOn(CD_Survival)
	config( CombinedCD );

`include(CD_BuildInfo.uci)
`include(CD_Log.uci)

struct StructChatCommand
{
	var array<string> Names; 
	var array<string> ParamHints; 
	var delegate<ChatCommandNullaryImpl> NullaryImpl;
	var delegate<ChatCommandParamsImpl> ParamsImpl;
	var delegate<ChatCommandSenderImpl> SenderImpl;
	var CD_Setting CDSetting;
	var string Description;
	var byte AuthLevel;
	var bool ModifiesConfig;
	var bool bNeedSender;
};

struct ExCmdCombo
{
	var string Key;
	var string Res;
};

var array<StructChatCommand> ChatCommands;
var config array<ExCmdCombo> ExtraCommands;
var class<CD_ChatCommandPresets> PresetClass;

const AdminLevel = 4;
const OngshimiVideoChance = 0.05f;

delegate string ChatCommandNullaryImpl();
delegate string ChatCommandParamsImpl( const out array<string> params );
delegate string ChatCommandSenderImpl( const array<string> params, CD_PlayerController CDPC);

function PrintCDChatHelp()
{
	local string HelpString;
	local int CCIndex, NameIndex, ParamIndex;

	GameInfo_CDCP.Print("Controlled Difficulty Chat Commands", false);
	GameInfo_CDCP.Print("----------------------------------------------------", false);
	GameInfo_CDCP.Print("CD knows the following chat commands.  Type any command in global chat.", false);
	GameInfo_CDCP.Print("Commands typed in team chat are ignored.  Commands marked CDAUTH_READ ", false);
	GameInfo_CDCP.Print("are usable by anyone.  Dedicated server admins may optionally restrict ", false);
	GameInfo_CDCP.Print("access to commands marked CDAUTH_WRITE.", false);

	for ( CCIndex = 0; CCIndex < ChatCommands.Length; CCIndex++ )
	{
		HelpString = "  " $ ChatCommands[CCIndex].Names[0];

		for ( ParamIndex = 0; ParamIndex < ChatCommands[CCIndex].ParamHints.Length; ParamIndex++ )
		{
			HelpString $= " <" $ ChatCommands[CCIndex].ParamHints[ParamIndex] $ ">";
		}

		if ( 1 < ChatCommands[CCIndex].Names.Length )
		{
			HelpString $= " (alternate name(s): ";

			for ( NameIndex = 1; NameIndex < ChatCommands[CCIndex].Names.Length; NameIndex++ )
			{
				if ( 1 < NameIndex )
				{
					HelpString $= ", ";
				}
				HelpString $= ChatCommands[CCIndex].Names[NameIndex];
			}

			HelpString $= ")";
		}

		HelpString $= " [" $ string(ChatCommands[CCIndex].AuthLevel) $ "]";

		GameInfo_CDCP.Print(HelpString, false);
		GameInfo_CDCP.Print("    " $ ChatCommands[CCIndex].Description, false);
	}
}

function RunCDChatCommandIfAuthorized( Actor Sender, string CommandString )
{
	local CD_PlayerController CDPC;
	local byte AuthLevel;
	local string ResponseMessage;
	local array<string> CommandTokens;
	local name GameStateName;
	local StructChatCommand Cmd;
	local CD_Setting CDSetting;
	local string TempString;
	local name EchoType;

	local delegate<ChatCommandNullaryImpl> CNDeleg;
	local delegate<ChatCommandParamsImpl> CPDeleg;
	local delegate<ChatCommandSenderImpl> CSDeleg;

	CDPC = CD_PlayerController(Sender);

	if (CDPC == none)
	{
		return;
	}

	AuthLevel = CDPC.GetCDPRI().AuthorityLevel;
	ParseStringIntoArray( CommandString, CommandTokens, " ", true );
	ResponseMessage = "";
	EchoType = 'CDEcho';

	if ( MatchChatCommand( CommandTokens[0], Cmd, AuthLevel, CommandTokens.Length - 1 ) )
	{
		CNDeleg = Cmd.NullaryImpl;
		CPDeleg = Cmd.ParamsImpl;
		CSDeleg = Cmd.SenderImpl;

		if ( Cmd.bNeedSender )
		{
			CommandTokens.Remove( 0, 1 );
			ResponseMessage = CSDeleg( CommandTokens, CDPC );
		}
		else if ( Cmd.ParamHints.Length == 0 )
		{
			ResponseMessage = CNDeleg();
		}
		else
		{
			CommandTokens.Remove( 0, 1 );
			ResponseMessage = CPDeleg( CommandTokens );
		}

		if ( Cmd.ModifiesConfig )
		{
			GameStateName = Outer.GetStateName();
			if ( GameStateName == 'PendingMatch' || GameStateName == 'MatchEnded' || GameStateName == 'TraderOpen' )
			{
				CDSetting = CD_Setting( Cmd.CDSetting );
				if ( None != CDSetting )
				{
					TempString = CDSetting.CommitStagedChanges( WaveNum + 1 );
					if ( TempString != "" )
					{
						ResponseMessage = TempString;
						Outer.SaveConfig();
						RefleshWebInfo();
					}
				}
			}
		}
	}
	else
	{
		ResponseMessage = GetExtraCommand(CommandTokens[0], EchoType);
	}

	if ( "" != ResponseMessage )
	{
		BroadcastLocalizedEcho( ResponseMessage, EchoType );
		return;
	}
	`cdlog("Discarding unknown or unauthorized command: "$ CommandString, bLogControlledDifficulty);
}

private function bool MatchChatCommand( const string CmdName, out StructChatCommand Cmd, const byte AuthLevel, const int ParamCount )
{
	local int CCIndex;
	local int NameIndex;

	for ( CCIndex = 0; CCIndex < ChatCommands.length; CCIndex++ )
	{
		if ( ParamCount > ChatCommands[CCIndex].ParamHints.Length )
		{
			continue;
		}

		for ( NameIndex = 0; NameIndex < ChatCommands[CCIndex].Names.Length; NameIndex++ )
		{
			if ( ChatCommands[CCIndex].Names[NameIndex] == CmdName )
			{
				if ( AuthLevel < ChatCommands[CCIndex].AuthLevel )
				{
					BroadCastLocalizedEcho("<local>CD_ChatCommander.AuthorityShortageMsg</local>", 'UMEcho');
					return false;
				}		

				Cmd = ChatCommands[CCIndex];
				return true;
				`cdlog("MatchChatCommand["$ CCIndex $"]: found Name="$ CmdName $" ParamCount="$ ParamCount $" AuthLevel="$ AuthLevel, bLogControlledDifficulty);
			}
		}
	}

	return false;
}

function string GetExtraCommand(string Key, out name EchoType)
{
	local int i, j, index;
	local float Chance;

	//	Preset
	for(i=0; i<PresetClass.default.Commands.length; i++)
	{
		if(PresetClass.default.Commands[i].Key.Find(Key) == INDEX_NONE)
			continue;

		Chance = FRand();
		
		for(j=0; j<PresetClass.default.Commands[i].ResList.length; j++)
		{
			if(Chance < PresetClass.default.Commands[i].ResList[j].Chance)
			{
				EchoType = PresetClass.default.Commands[i].ResList[j].Type;
				return PresetClass.default.Commands[i].ResList[j].Res;
			}
			else
			{
				Chance -= PresetClass.default.Commands[i].ResList[j].Chance;
			}
		}
	}

	//	Config
	if(Left(Key, 3) == "!cd")
	{
		index = ExtraCommands.Find('Key', Mid(Key, 3));
		if(index != INDEX_NONE)
		{
			return ExtraCommands[index].Res;
		}
	}

	return "";
}

function SetupChatCommands()
{
	local StructChatCommand scc;
	local int i;

	ChatCommands.Length = 0;

	// Info
	SetupSimpleCommand("!cdversion", "", "Display mod version", GetCDVersionChatString);
	SetupSimpleCommand("!cdpi", "!cdplayerinfo", "Display Players' skills and weapons info", DisplayPlayerInfo);
	SetupParamCommand("!cdinfo", "", "full|basic|dynamic|albino|start|boss", "Display CD config", GetCDInfoChatStringCommand);
	SetupParamCommand("!cdsca", "!cdspawncycleanalyze", "cycle name\nwaveX\nwsfX", "Display Spawn Cycle Analysis", SCACommand);
	SetupParamCommand("!cds", "!cdstats", "acc|dmgd|dmgt|dosh|hs|hsacc|healsg|healsr|larg|hu|shotsf|shotsh", "Display players stats", GetCDStats);
	SetupSenderCommand("!rpwinfo", "", "Display restricions info", LogRPWInfo, "perk|skill|level|weapon");
	SetupSenderCommand("!cdh", "!cdhelp", "Display some help about CD", DisplayCDHelp, "cdr|ini");
	SetupSenderCommand("!cdal", "!cdauthoritylevel", "Display player's authority level", DisplayAuthorityLevel);

	// Server Interact
	SetupSimpleCommand("!cdpt", "!cdpausetrader", "Pause TraderTime countdown", PauseTraderTime);
	SetupSimpleCommand("!cdupt", "!cdunpausetrader", "Unpause TraderTime countdown", UnpauseTraderTime);
	SetupSimpleCommand("!cdst", "!cdskiptrader", "Skip trader time without countdown", HandleSkipTrader, AdminLevel);
	SetupSenderCommand("!cdr", "!cdready", "Ready up to begin the wave", ReadyUp);
	SetupSenderCommand("!cdur", "!cdunready", "Cancel your ready state", Unready);
	SetupSenderCommand("!cdahpf", "!cdallhpfakes", "Set HP Fakes for all categories", SetAllHPFakes, "int");
	SetupSenderCommand("!cdsr", "!cdswitchrole", "Switch roles between an active player and a spectator", SwitchRole);
	SetupSenderCommand("!cdfs", "!cdfillspares", "Buy ammo for dropped weapons", FillSparesCommand, "fal");
	SetupSenderCommand("!tdd", "!toggledisabledual", "Toggle if you disable to pickup dual pistols", ToggleDisableDual);
	SetupSenderCommand("!cdmuc", "!cdmaxupgradecount", "Check or change upgrade limit", HandleMaxUpgradeCount, "int");
	SetupSenderCommand("!cdaoc", "!cdantiovercap", "Check or change AntiOverCap", HandleAntiOverCap, "bool");
	SetupSenderCommand("!cdat", "!cdautotrader", "Automatically purchase registered loadout", AutoTraderCommand);
	
	// Client Interact
	SetupSenderCommand("!cdms", "!cdmystats", "Display your detailed stats", OpenPlayerStats);
	SetupSenderCommand("!ot", "!cdot", "Open trader menu", OpenTraderCommand);
	SetupSenderCommand("!cdm", "!cdmenu", "Open your client option menu", OpenClientMenu);
	SetupSenderCommand("!mv", "!cdmv", "Open the map vote menu", OpenMapVote);
	SetupSenderCommand("!mr", "!cdmr", "Open the match result menu", OpenTeamAward);
	SetupSenderCommand("!cdam", "!cdadminmenu", "Open the admin menu", OpenAdminMenu, , AdminLevel);
	SetupSenderCommand("!cdwho", "", "Display participants info", OpenPlayersMenu);
	SetupSenderCommand("!cdrs", "!cdresetsettings", "Reset strange CD settings", ResetSettings);
	SetupSenderCommand("!cdscp", "!cdspawncyclepreset", "Display Spawn Cycle Presets", OpenCycleMenu);
	
	// Omake
	SetupSimpleCommand("!cdmia", "", "Play meow sound", PlayMeowSound);	
	SetupSenderCommand("!cdsz", "!cdspawnzed", "Spawn brain-dead zed", SpawnZedCommand, "zed code");
	SetupSenderCommand("!cdsa", "!cdspawnai", "Spawn AI zed", SpawnAICommand, "zed code");
	SetupSenderCommand("!cdkz", "!cdkillzeds", "Kill all existing zeds", HandleKillZeds);
	SetupSenderCommand("!cddosh", "", "Get Doshinegun or spawn Dosh Drone for fun", DoshPlayCommand, "drone");
	SetupSenderCommand("!cdongshimi", "!cdongsimi", "Display a part of ongshimi lyrics", OngshimiCommand);

	// CD settings
	for ( i = 0; i < AllSettings.Length; i++ )
	{
		if ( AllSettings[i].GetChatReadCommand( scc ) )
		{
			ChatCommands.AddItem( scc );
		}

		if ( AllSettings[i].GetChatWriteCommand( scc ) )
		{
			ChatCommands.AddItem( scc );
		}
	}
}

private function SetupCommandBase( int i, const string CmdName, const string SecondName, const string Desc, const byte level, const bool bModCfg)
{
	ChatCommands[i].Names.AddItem(CmdName);
	if(SecondName != "")
	{
		ChatCommands[i].Names.AddItem(SecondName);
	}
	ChatCommands[i].Description = Desc;
	ChatCommands[i].AuthLevel = level;
	ChatCommands[i].ModifiesConfig = bModCfg;
}

private function SetupSimpleCommand( const string CmdName, const string SecondName, const string Desc, const delegate<ChatCommandNullaryImpl> Impl, optional const byte level, optional const bool bModCfg )
{
	local int i;

	i = ChatCommands.length;
	ChatCommands.Add(1);
	SetupCommandBase(i, CmdName, SecondName, Desc, level, bModCfg);
	ChatCommands[i].NullaryImpl = Impl;
}

//	ParamHints should be parsed by "\n"
private function SetupParamCommand( const string CmdName, const string SecondName, const string ParamHints, const string Desc, const delegate<ChatCommandParamsImpl> Impl, optional const byte level, optional const bool bModCfg )
{
	local int i;
	local array<string> splitbuf;

	ParseStringIntoArray(ParamHints, splitbuf, "\n", true);
	i = ChatCommands.length;
	ChatCommands.Add(1);
	SetupCommandBase(i, CmdName, SecondName, Desc, level, bModCfg);
	ChatCommands[i].ParamHints = splitbuf;
	ChatCommands[i].ParamsImpl = Impl;
}

private function SetupSenderCommand( const string CmdName, const string SecondName, const string Desc, const delegate<ChatCommandSenderImpl> Impl, optional const string ParamHints, optional const byte level, optional const bool bModCfg)
{
	local int i;
	local array<string> splitbuf;

	ParseStringIntoArray(ParamHints, splitbuf, "\n", true);
	i = ChatCommands.length;
	ChatCommands.Add(1);SetupCommandBase(i, CmdName, SecondName, Desc, level, bModCfg);
	ChatCommands[i].ParamHints = splitbuf;
	ChatCommands[i].SenderImpl = Impl;
	ChatCommands[i].bNeedSender = true;
}

/***** Info and Help *****/
	private function string GetCDChatHelpReferralString()
	{
		return "Type CDChatHelp in console for chat command info";
	}

	private function string GetCDInfoChatStringCommand( const out array<string> params)
	{
		if(params.length == 0)
		{
			return GetCDInfoChatString( "brief" );
		}

		return GetCDInfoChatString( params[0] );
	}

	function string GetCDInfoChatString( const string Verbosity )
	{
		local int i;
		local string Result;
		
		if ( Verbosity == "full" )
		{
			Result = "";

			for ( i = 0; i < AllSettings.Length; i++ )
			{
				if ( 0 < i )
				{
					Result $= "\n";
				}
				Result $= AllSettings[i].GetChatLine();
			}
		}
		else if ( Verbosity == "basic" )
		{
			Result = "";

			for ( i = 0; i < BasicSettings.Length; i++ )
			{
				if ( 0 < i )
				{
					Result $= "\n";
				}
				Result $= BasicSettings[i].GetChatLine();
			}
		}
		else if ( Verbosity == "dynamic" )
		{
			Result = "";

			for ( i = 0; i < DynamicSettings.Length; i++ )
			{
				if ( 0 < i )
				{
					Result $= "\n";
				}
				Result $= DynamicSettings[i].GetChatLine();
			}
		}
		else if ( Verbosity == "albino" )
		{
			Result = AlbinoAlphasSetting.GetBriefChatLine() $ "\n" $
					 AlbinoCrawlersSetting.GetBriefChatLine() $ "\n" $
					 AlbinoGorefastsSetting.GetBriefChatLine() $ "\n" $
					 DisableRobotsSetting.GetBriefChatLine();

		}
		else if ( Verbosity == "start" )
		{
			Result = StartingWeaponTierSetting.GetBriefChatLine() $ "\n" $
					 StartwithFullAmmoSetting.GetBriefChatLine() $ "\n" $
					 StartwithFullGrenadeSetting.GetBriefChatLine() $ "\n" $
					 StartwithFullArmorSetting.GetBriefChatLine();
		}
		else if ( Verbosity == "boss" )
		{
			Result = DisableBossSetting.GetBriefChatLine() $ "\n" $
					 BossSetting.GetBriefChatLine() $ "\n" $
					 BossHPFakesSetting.GetBriefChatLine() $ "\n" $
					 BossDifficultySetting.GetBriefChatLine() $ "\n" $
					 DisableBossMinionsSetting.GetBriefChatLine();
		}
		else
		{
			Result = MaxMonstersSetting.GetBriefChatLine() $ "\n" $
					 CohortSizeSetting.GetBriefChatLine() $ "\n" $
					 WaveSizeFakesSetting.GetBriefChatLine() $ "\n";

			if(SpawnModFloat > 0.f)
				Result $= SpawnModSetting.GetBriefChatLine() $ "\n";

			Result $= SpawnPollSetting.GetBriefChatLine() $ "\n" $
					  SpawnCycleSetting.GetBriefChatLine();
		
			// if it's bosswave, include bosshpfakes
			if ( MyKFGRI.IsBossWave() )
			{
				Result = Result $ "\n" $ BossHPFakesSetting.GetBriefChatLine();
			}

			if (ScrakeHPFakesInt != 6 ||
				FleshpoundHPFakesInt != 6 ||
				QuarterpoundHPFakesInt != 6 ||
				TrashHPFakesInt != 6)
			{
				Result $= "\nAllHPFakes≠6";
			}
		}

		return Result;
	}

	private function string GetCDWhoChatString()
	{
		local KFPlayerController KFPC;
		local string Result, Code;
		local int TotalCount;
		local name GameStateName;
		

		Result = "";
		GameStateName = Outer.GetStateName();

	        foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC)
			{
				Code = "";

				if ( !KFPC.bIsPlayer || KFPC.bDemoOwner )
				{
					continue;
				}

				if ( KFPC.PlayerReplicationInfo.bOnlySpectator )
				{
					Code = "S";
				}
			
				if ( GameStateName == 'TraderOpen' )
				{
					if ( !KFPC.PlayerReplicationInfo.bOnlySpectator )
					{
						Code = CD_PlayerReplicationInfo(KFPC.PlayerReplicationInfo).bIsReadyForNextWave ? "R" : "  ";
					}
				}
			
				if ( GameStateName == 'PendingMatch' )
				{
					if ( !KFPC.PlayerReplicationInfo.bOnlySpectator )
					{
						Code = KFPC.PlayerReplicationInfo.bReadyToPlay ? "R" : "  ";
					}
				}
			
				else if ( GameStateName == 'PlayingWave' && !KFPC.PlayerReplicationInfo.bOnlySpectator )
				{
					Code = KFPC.Pawn.IsAliveAndWell() ? "L" : "D";
				}
			
				if ( 0 < TotalCount )
				{
					Result $= "\n";
				}

				if ( Code != "" )
				{
					Result $= "["$ Code $"] ";
				}

				Result $= KFPC.PlayerReplicationInfo.PlayerName;

				TotalCount++;		
	        }
			
		return Result;
	}

	private function string SCPCommand( const out array<string> params)
	{
		if(params.length == 0)
		{
			return GetSCP("main");
		}

		return GetSCP( params[0] );
	}

	function string GetSCP( const string key )
	{
		local string Result;
		local int i;

		Result = "";	
		
		if(key == "full")
		{
			for(i=0; i<SpawnCycleCatalog.SpawnCyclePresetList.length; i++)
				Result $= SpawnCycleCatalog.SpawnCyclePresetList[i].GetName() $ "\n";
		}

		else if(key == "main")
		{
			Result $= "asp_v3" $"\n"$
					  "asp_fp_v2" $"\n"$
					  "ts_mig_v3" $"\n"$
					  "doom_v2_plus_rmk" $"\n"$
					  "asp_v2" $"\n"$
					  "ts_mig_v2" $"\n"$
					  "osffi_v1" $"\n"$
					  "dtf_pm" $"\n"$
					  "ts_mig_v1" $"\n"$
					  "bl_v2" $"\n"$
					  "asp_v1" $"\n"$
					  "bl_light" $"\n"$
					  "nam_pro_v5" $"\n"$
					  "nam_pro_v3" $"\n"$
					  "(Type \"!cdscp full\" to print in detail)";
		}

		return Result;
	}

	private function string SCACommand( const out array<string> params)
	{
		local string CycleName;
		local int TargetWave, TargetWSF;

		SpawnCycleAnalyzer.SetSCAOption(params, CycleName, TargetWave, TargetWSF);
		SpawnCycleAnalyzer.TrySCACore(CycleName, TargetWave, TargetWSF);
		return "";
	}

	private function string DisplayPlayerInfo()
	{
		local array<PlayerInvInfo> PInfo;
		local CD_PlayerController CDPC;
		local Inventory Inv;
		local int i, j, k;
		local bool bHide;
		local string Result;

		//	All players perk, skills and possessed weapons
		foreach WorldInfo.AllControllers(class'CD_PlayerController', CDPC)
		{
			if(CDPC.PlayerReplicationInfo.bOnlySpectator)
				continue;

			PInfo.Add(1);
			i = PInfo.length - 1;
			PInfo[i].PRI = CDPC.PlayerReplicationInfo;
			PInfo[i].Perk = CDPC.GetPerk().GetPerkClass();
			PInfo[i].Skill = "";

			for(j=0; j<10; j+=2)
				PInfo[i].Skill $= (CDPC.GetPerk().PerkSkills[j].bActive) ? "L" : "R";
			
			for(Inv=CDPC.Pawn.InvManager.InventoryChain; Inv!=None; Inv=Inv.Inventory)
			{
				switch(Inv.ItemName)
				{
					case class'KFGameContent.KFWeap_Healer_Syringe'.default.ItemName:
					case class'KFGameContent.KFWeap_Knife_Berserker'.default.ItemName:
					case class'KFGameContent.KFWeap_Knife_Commando'.default.ItemName:
					case class'KFGameContent.KFWeap_Knife_Demolitionist'.default.ItemName:
					case class'KFGameContent.KFWeap_Knife_FieldMedic'.default.ItemName:
					case class'KFGameContent.KFWeap_Knife_Firebug'.default.ItemName:
					case class'KFGameContent.KFWeap_Knife_Gunslinger'.default.ItemName:
					case class'KFGameContent.KFWeap_Knife_Sharpshooter'.default.ItemName:
					case class'KFGameContent.KFWeap_Knife_Support'.default.ItemName:
					case class'KFGameContent.KFWeap_Knife_Survivalist'.default.ItemName:
					case class'KFGameContent.KFWeap_Knife_SWAT'.default.ItemName:
					case class'KFGameContent.KFWeap_Pistol_9mm'.default.ItemName:
					case class'KFGameContent.KFWeap_Welder'.default.ItemName:
						bHide = true;
				}

				if(!bHide)
				{
					if(Inv.ItemName != "")
					{
						PInfo[i].Inv.Add(1);
						j = PInfo[i].Inv.length - 1;
						PInfo[i].Inv[j].WeapName = Inv.ItemName;
						PInfo[i].Inv[j].UpgradeCount = KFWeapon(Inv).CurrentWeaponUpgradeIndex;
						PInfo[i].Inv[j].WeapCount = 1;
					}
				}
				else
					bHide = false;
			}
		}

		// All dropped pickup
		for(i=0; i<PickupTracker.WeaponPickupRegistry.length; i++)
		{
			j = PInfo.Find('PRI', PickupTracker.WeaponPickupRegistry[i].OrigOwnerPRI);

			if(j == INDEX_NONE)
				continue;

			k = PInfo[j].Inv.Find('WeapName', PickupTracker.WeaponPickupRegistry[i].KFWClass.default.ItemName);

			if(k == INDEX_NONE)
			{
				if(PickupTracker.WeaponPickupRegistry[i].KFWClass.default.ItemName == "")
					continue;

				PInfo[j].Inv.Add(1);
				k = PInfo[j].Inv.length - 1;
				PInfo[j].Inv[k].WeapName = PickupTracker.WeaponPickupRegistry[i].KFWClass.default.ItemName;
				PInfo[j].Inv[k].UpgradeCount = KFWeapon(PickupTracker.WeaponPickupRegistry[i].KFDP.Inventory).CurrentWeaponUpgradeIndex;
				PInfo[j].Inv[k].WeapCount = 1;
			}

			else
			{
				PInfo[j].Inv[k].UpgradeCount = Max(PInfo[j].Inv[k].UpgradeCount, KFWeapon(PickupTracker.WeaponPickupRegistry[i].KFDP.Inventory).CurrentWeaponUpgradeIndex);
				PInfo[j].Inv[k].WeapCount ++;
			}
		}
		
		//	Compile Message
		for(i=0; i<PInfo.length; i++)
		{
			Result $= "\n\n" $ PInfo[i].PRI.PlayerName @ "|" @  Mid(string(PInfo[i].Perk), 7) @ "|" @ PInfo[i].Skill;

			for(j=0; j<PInfo[i].Inv.length; j++)
			{
				Result $= "\n" $ string(PInfo[i].Inv[j].WeapCount) @ PInfo[i].Inv[j].WeapName;

				if(PInfo[i].Inv[j].UpgradeCount > 0)
					Result $= " (+" $ string(PInfo[i].Inv[j].UpgradeCount) $ ")";
			}
		}

		BroadcastLocalizedEcho("<local>CD_Survival.SeeConsoleString</local>");
		foreach WorldInfo.AllControllers(class'CD_PlayerController', CDPC)
			CDPC.PrintConsole(Result);

		return "";
	}

	private function string GetCDStats( const out array<string> params)
	{
		return StatsSystem.CDStatsCommand(params);
	}

	private function string LogRPWInfo(const array<string> Params, CD_PlayerController CDPC)
	{
		local string Result;
		local int i;

		Result = "";

		if (Params.length == 0 || Params[0] == "perk")
		{
			Result $= "[Perk Restrictions]\n";
			for(i=0; i<AuthorityHandler.PerkRestrictions.length; i++)
			{
				if(AuthorityHandler.PerkRestrictions[i].RequiredLevel > 0)
					Result $= Mid(string(AuthorityHandler.PerkRestrictions[i].Perk), 7) $ ": only available for authorized users.\n";
			}
		}
		if (Params.length == 0 || Params[0] == "skill")
		{
			Result $= "[Banned Skills]\n";
			for(i=0; i<AuthorityHandler.SkillRestrictions.length; i++)
			{
				Result $= Mid(string(AuthorityHandler.SkillRestrictions[i].Perk), 7) $ ": ";
				Result $= CDPC.SkillBanMessage(AuthorityHandler.SkillRestrictions[i].Perk, AuthorityHandler.SkillRestrictions[i].Skill) $ "\n";
			}
		}
		if (Params.length == 0 || Params[0] == "level")
		{
			Result $= "[Level Restrictions]\n";
			Result $= (AuthorityHandler.bRequireLv25) ? "Level 25 is required" : "No restrictions";
		}
		if (Params.length == 0 || Params[0] == "weapon")
		{
			Result $= "\n[Weapon Restrictions]\nAll weapons seen in trader are available.\n " $
					"Max Upgrade Count: " $ string(MaxUpgrade) $ "\n" $
					"Anti Over Cap: " $ string(AuthorityHandler.bAntiOvercap);
		}

		BroadcastRPWEcho(Result);
		return "";
	}

	private function string DisplayCDHelp(const array<string> Params, CD_PlayerController CDPC)
	{
		if(Params[0] == "ini")
		{
			BroadcastLocalizedEcho("<local>CD_Survival.IniHelpHeader</local>");
			return	"1. Go to the following directory in your documents:\n" $
					"  C:\Documents\My Games\KillingFloor2\KFGame\Config\n" $
					"2. Find the KFEngine file in the Config folder and open it using Notepad\n" $
					"3. Find the following lines in the KFEngine file:\n" $
					"  MaxObjectsNotConsideredByGC=179220\n" $
					"  SizeOfPermanentObjectPool=179220\n" $
					"4. Change the values of these parameters to:\n" $
					"  MaxObjectsNotConsideredByGC=33476\n" $
					"  SizeOfPermanentObjectPool=0\n" $
					"5. Save the KFEngine file and enjoy.";
		}
		else if (Params[0] == "cdr")
		{
			return "<local>CD_Survival.ReadyHelpHeader</local>";
		}
		else
		{
			CDPC.ClientOpenURL(HelpURL);
		}
		return "";
	}

	private function string DisplayAuthorityLevel(const array<string> Params, CD_PlayerController CDPC)
	{
		CDPC.ShowAuthorityLevel();
		return "";
	}

/***** Open Menu *****/
	private function string OpenTraderCommand(const array<string> Params, CD_PlayerController CDPC)
	{
		if(MyKFGRI.bTraderIsOpen)
		{
			CDPC.OpenTraderMenu();			
		}
		return "";
	}

	private function string OpenPlayerStats(const array<string> Params, CD_PlayerController CDPC)
	{
		if(WaveNum < 1)
		{
			CDPC.ShowLocalizedPopup("ERROR", "<local>CD_StatsSystem.BeforeStartError</local>");
		}
		else
		{
			ShowMapVote('PlayerStats', CDPC);
		}

		return "";
	}

	private function string OpenClientMenu(const array<string> Params, CD_PlayerController CDPC)
	{
		CDPC.ClientOption();
		return "";
	}

	private function string OpenMapVote(const array<string> Params, CD_PlayerController CDPC)
	{
		ShowMapVote('MapVote', CDPC);
		return "";
	}

	private function string OpenTeamAward(const array<string> Params, CD_PlayerController CDPC)
	{
		if(MyKFGRI.bMatchIsOver)
		{
			ShowMapVote('TeamAward', CDPC);
		}
		else
		{
			CDPC.ShowLocalizedPopup("ERROR", "<local>CD_Survival.CurrentlyUnavailableMsg</local>");
		}
		return "";
	}

	private function string OpenAdminMenu(const array<string> Params, CD_PlayerController CDPC)
	{
		CDPC.AdminMenu();
		return "";
	}

	private function string OpenPlayersMenu(const array<string> Params, CD_PlayerController CDPC)
	{
		CDPC.OpenPlayersMenu();
		return "";
	}

	private function string OpenCycleMenu(const array<string> Params, CD_PlayerController CDPC)
	{
		CDPC.CycleOption();
		return "";
	}

/***** Server Interact *****/
	function string ResetSettings(const array<string> Params, CD_PlayerController CDPC)
	{
		local array<string> PendingCommands;
		local int i;

		if(AlbinoAlphasBool			!= DefaultCDSettings.AlbinoAlphas)		PendingCommands.AddItem("!cdaa" @ string(DefaultCDSettings.AlbinoAlphas));
		if(AlbinoCrawlersBool		!= DefaultCDSettings.AlbinoCrawlers)	PendingCommands.AddItem("!cdac" @ string(DefaultCDSettings.AlbinoCrawlers));
		if(AlbinoGorefastsBool		!= DefaultCDSettings.AlbinoGorefasts)	PendingCommands.AddItem("!cdag" @ string(DefaultCDSettings.AlbinoGorefasts));
		if(bDisableRobots			!= DefaultCDSettings.DisableRobots)		PendingCommands.AddItem("!cddr" @ string(DefaultCDSettings.DisableRobots));
		if(bDisableSpawners			!= DefaultCDSettings.DisableSpawners)	PendingCommands.AddItem("!cdds" @ string(DefaultCDSettings.DisableSpawners));
		if(FleshpoundRageSpawnsBool	!= DefaultCDSettings.FPRageSpawns)		PendingCommands.AddItem("!cdfprs" @ string(DefaultCDSettings.FPRageSpawns));
		if(StartingWeaponTierInt	!= DefaultCDSettings.StartingWeapTier)	PendingCommands.AddItem("!cdswt" @ string(DefaultCDSettings.StartingWeapTier));
		if(bStartwithFullAmmo		!= DefaultCDSettings.StartwithFullAmmo)	PendingCommands.AddItem("!cdswfa" @ string(DefaultCDSettings.StartwithFullAmmo));
		if(bStartwithFullArmor		!= DefaultCDSettings.StartwithFullArmor)PendingCommands.AddItem("!cdswfar" @ string(DefaultCDSettings.StartwithFullArmor));
		if(bStartwithFullGrenade	!= DefaultCDSettings.StartwithFullGrenade)PendingCommands.AddItem("!cdswfg" @ string(DefaultCDSettings.StartwithFullGrenade));
		if(FleshpoundHPFakesInt		!= DefaultCDSettings.HPFakes)			PendingCommands.AddItem("!cdfphpf" @ string(DefaultCDSettings.HPFakes));
		if(ScrakeHPFakesInt			!= DefaultCDSettings.HPFakes)			PendingCommands.AddItem("!cdschpf" @ string(DefaultCDSettings.HPFakes));
		if(QuarterpoundHPFakesInt	!= DefaultCDSettings.HPFakes)			PendingCommands.AddItem("!cdqphpf" @ string(DefaultCDSettings.HPFakes));
		if(TrashHPFakesInt			!= DefaultCDSettings.HPFakes)			PendingCommands.AddItem("!cdthpf" @ string(DefaultCDSettings.HPFakes));
		if(ZedsTeleportCloserBool	!= DefaultCDSettings.ZedsTeleportCloser)PendingCommands.AddItem("!cdztc" @ string(DefaultCDSettings.ZedsTeleportCloser));
		
		if(PendingCommands.length > 0)
		{
			for(i=0; i<PendingCommands.length; i++)
			{
				`cdlog(PendingCommands[i]);
				RunCDChatCommandIfAuthorized(CDPC, PendingCommands[i]);
			}
			return "<local>CD_ChatCommander.ResetSettingsMsg</local>";
		}
		return "<local>CD_ChatCommander.ResetNothingMsg</local>";
	}

	function string SetAllHPFakes( const array<string> Params, CD_PlayerController CDPC)
	{
		ChatCommander.RunCDChatCommandIfAuthorized( CDPC, "!cdfphpf " $ params[0] );
		ChatCommander.RunCDChatCommandIfAuthorized( CDPC, "!cdqphpf " $ params[0] );
		ChatCommander.RunCDChatCommandIfAuthorized( CDPC, "!cdschpf " $ params[0] );
		ChatCommander.RunCDChatCommandIfAuthorized( CDPC, "!cdthpf " $ params[0] );
		return "";
	}

	private function string SwitchRole(const array<string> Params, CD_PlayerController CDPC)
	{
		local string result;

		//	Check Server Capacity
		if( AtCapacity(!CDPC.PlayerReplicationInfo.bOnlySpectator, CDPC.PlayerReplicationInfo.UniqueId) )
		{
			BroadCastLocalizedEcho("<local>CD_PlayerController.CapacityErrorMsg</local>", 'RPWEcho');
			return "";
		}

		//	for active players
		if(!CDPC.PlayerReplicationInfo.bOnlySpectator)
		{
			if(CDPC.Pawn != none)
			{
				CDPC.ServerSuicide();
				CDPC.Pawn.Destroy();
			}
		}
	   
		//	for everyone
		if(CDPC.Role == ROLE_Authority)
		{
			//	spectators
			if(!CDPC.PlayerReplicationInfo.bOnlySpectator)
			{
			   if(NumSpectators != MaxSpectators)
				{
				    CDPC.GotoState('Spectating');
				    CDPC.PlayerReplicationInfo.bOnlySpectator = true;
				    CDPC.PlayerReplicationInfo.bIsSpectator = true;
				    CDPC.PlayerReplicationInfo.bOutOfLives = true;
				    -- NumPlayers;
				    ++ NumSpectators;
				    result = CDPC.PlayerReplicationInfo.GetHumanReadableName() @ "<local>CD_PlayerController.BeSpectatorString</local>";
				}
			}

			//	active players
			else
			{
			   CDPC.PlayerReplicationInfo.bOnlySpectator = false;
			   CDPC.PlayerReplicationInfo.bReadyToPlay = CDGRI.bMatchHasBegun;
			   CDPC.GotoState('PlayerWaiting');
			   CDPC.ServerRestartPlayer();
			   CDPC.ServerChangeTeam(0);
			   ++ NumPlayers;
			   -- NumSpectators;
			   result = CDPC.PlayerReplicationInfo.GetHumanReadableName() @ "<local>CD_PlayerController.BePlayerString</local>";
			}

			CDPC.UpdateSpectateURL(CDPC.PlayerReplicationInfo.bOnlySpectator);
		}
		return result;
	}

	private function string HandleSkipTrader()
	{
		if(!MyKFGRI.bTraderIsOpen)
		{
			return "<local>CD_Survival.UnavailableInWaveMsg</local>";
		}
		else
		{
			SkipTrader(1);
			return "<local>CD_Survival.AdminSkipTraderMsg</local>";
		}
	}

	private function string FillSparesCommand(const array<string> Params, CD_PlayerController CDPC)
	{
		CD_BuyAmmo((Params.length==0 ? "" : Params[0]), CDPC);
		return "";
	}

	private function string ToggleDisableDual(const array<string> Params, CD_PlayerController CDPC)
	{
		CDPC.bDisableDual = !CDPC.bDisableDual;
		BroadcastPersonalEcho("DisableDual=" $ string(CDPC.bDisableDual), 'CDEcho', CDPC);
		//CheckUnglowPickupForPlayer(CD_Pawn_Human(CDPC.Pawn));
		return "";
	}

	private function string HandleMaxUpgradeCount(const array<string> Params, CD_PlayerController CDPC)
	{
		if(Params.length == 0)
		{
			return "MaxUpgradeCount=" $ string(CDGRI.MaxUpgrade);
		}

		if(CDPC.GetCDPRI().AuthorityLevel < AdminLevel)
		{
			BroadcastLocalizedEcho("<local>CD_Survival.AccessDeniedString</local>MaxUpgradeCount\n" $
								   "MaxUpgradeCount=" $ string(CDGRI.MaxUpgrade), 'UMEcho');
			return "";
		}

		return SetMaxUpgrade(int(Params[0]));
	}

	private function string HandleAntiOverCap(const array<string> Params, CD_PlayerController CDPC)
	{
		if(Params.length == 0)
		{
			return "AntiOvercap=" $ string(AuthorityHandler.bAntiOvercap);
		}

		if(CDPC.GetCDPRI().AuthorityLevel < AdminLevel)
		{
			BroadcastLocalizedEcho("<local>CD_Survival.AccessDeniedString</local>AntiOvercap.\n" $
								   "AntiOvercap=" $ string(AuthorityHandler.bAntiOvercap), 'UMEcho');
			return "";
		}

		SetAntiOvercap(bool(Params[0]));
		return "AntiOvercap=" $ string(AuthorityHandler.bAntiOvercap);
	}

	private function string AutoTraderCommand(const array<string> Params, CD_PlayerController CDPC)
	{
		if(MyKFGRI.bTraderIsOpen)
		{
			CDPC.DoAutoTrader();
		}
		return "";
	}

/***** Ready System *****/
	private function string ReadyUp(const array<string> Params, CD_PlayerController CDPC)
	{
		local CD_PlayerReplicationInfo CDPRI;
		local name GameStateName;
		GameStateName = Outer.GetStateName();	
		CDPRI = CDPC.GetCDPRI();

		if (!bEnableReadySystem)
		{
			CDPC.LocalizedClientMessage("<local>CD_Survival.ReadySystemDisabledMsg</local>");
		}
		else
		{
			if ( GameStateName != 'TraderOpen' )
			{
				CDPC.LocalizedClientMessage("<local>CD_Survival.ReadyWaveErrorMsg</local>");
			}
			else if ( !MyKFGRI.bStopCountDown )
			{
				CDPC.LocalizedClientMessage("<local>CD_Survival.ReadyNotPausedErrorMsg</local>");
			}
			else if (CDPRI.bOnlySpectator)
			{
				CDPC.LocalizedClientMessage("<local>CD_Survival.ReadySpectatorErrorMsg</local>");
			}
			else if (CDPRI.bIsReadyForNextWave)
			{
				CDPC.LocalizedClientMessage("<local>CD_Survival.ReadyAlreadyDoneMsg</local>");
			}
			else
			{
				CDPRI.bIsReadyForNextWave = true;
				CDPC.NotifyClientReadyState(true);
				NotifyFHUDReadyState(CDPC);
				BroadCastLocalizedEcho( CDPC.PlayerReplicationInfo.PlayerName $ "<local>CD_Survival.ReadyUpString</local>" );
				if( bAllPlayersAreReady() )
				{
					BroadCastLocalizedEcho( "<local>CD_Survival.AllReadyMsg</local>" );
					UnpauseTraderTime();
				}
			}
		}

		return "";
	}

	private function string Unready(const array<string> Params, CD_PlayerController CDPC)
	{
		local CD_PlayerReplicationInfo CDPRI;
		local name GameStateName;
		GameStateName = Outer.GetStateName();

		CDPRI = CDPC.GetCDPRI();

		if (!bEnableReadySystem)
		{
			CDPC.LocalizedClientMessage("<local>CD_Survival.ReadySystemDisabledMsg</local>");
		}
		else
		{
			if ( GameStateName != 'TraderOpen' )
			{
				CDPC.LocalizedClientMessage("<local>CD_Survival.ReadyWaveErrorMsg</local>");
			}
			else if (CDPRI.bOnlySpectator)
			{
				CDPC.LocalizedClientMessage("<local>CD_Survival.ReadySpectatorErrorMsg</local>");
			}
			else if (!CDPRI.bIsReadyForNextWave)
			{
				CDPC.LocalizedClientMessage("<local>CD_Survival.ReadyYetString</local>");
			}
			else if (WorldInfo.NetMode != NM_StandAlone && MyKFGRI.RemainingTime <= 5)
			{
				CDPC.LocalizedClientMessage("<local>CD_Survival.UnreadyTimeErrorMsg</local>");
			}
			else
			{
				CDPRI.bIsReadyForNextWave = false;
				CDPC.NotifyClientReadyState(false);
				NotifyFHUDReadyState(CDPC);
				BroadcastLocalizedEcho( CDPC.PlayerReplicationInfo.PlayerName $ "<local>CD_Survival.UnreadyString</local>" );
				if ( !MyKFGRI.bStopCountDown )
				{
					PauseTraderTime();
					BroadcastLocalizedEcho("<local>CD_Survival.AutoPauseMsg</local>");
				}
			}
		}
		return "";
	}

	function UnreadyAllPlayers()
	{
		local CD_PlayerController CDPC;
		local CD_PlayerReplicationInfo CDPRI;
		
		foreach WorldInfo.AllControllers(class'CD_PlayerController', CDPC)
		{
			if ( CDPC.bIsPlayer && !CDPC.PlayerReplicationInfo.bOnlySpectator && !CDPC.bDemoOwner )
			{
				CDPRI = CDPC.GetCDPRI();
				CDPRI.bIsReadyForNextWave = false;
				CDPC.NotifyClientReadyState(false);
				NotifyFHUDReadyState(CDPC);
			}
		}
	}

	private function bool bAllPlayersAreReady()
	{
		local CD_PlayerController CDPC;
		local CD_PlayerReplicationInfo CDPRI;
	    local int TotalPlayerCount;
	    local int SpectatorCount;
	    local int ReadyCount;
		
		TotalPlayerCount = 0;
		SpectatorCount = 0;
		ReadyCount = 0;
		
	    foreach WorldInfo.AllControllers(class'CD_PlayerController', CDPC)
		{
	        CDPRI = CDPC.GetCDPRI();

			if ( !CDPC.bIsPlayer || CDPC.bDemoOwner )
			{
				continue;
			}
			else
			{
				TotalPlayerCount++;
			}

			if ( CDPC.PlayerReplicationInfo.bOnlySpectator )
			{
				SpectatorCount++;
			}
			else if ( CDPRI.bIsReadyForNextWave && !CDPC.PlayerReplicationInfo.bOnlySpectator)
			{
				ReadyCount++;
			}
	    }
		
	    if (TotalPlayerCount == ReadyCount + SpectatorCount)
		{
			return true;
	    }
		else
		{
			return false;
		}
	}

	private function Mutator GetFHUDCompatController()
	{
		local Mutator M;

		foreach WorldInfo.DynamicActors( class'Mutator', M )
		{
			if ( PathName( M.class ) ~= "FriendlyHUD.FriendlyHUDCDCompatController")
			{
				return M;
			}
		}

		return None;
	}

	private function NotifyFHUDReadyState( CD_PlayerController CDPC )
	{
		local Mutator FHUDCompatController;
		local CD_PlayerReplicationInfo CDPRI;

		FHUDCompatController = GetFHUDCompatController();
		CDPRI = CD_PlayerReplicationInfo(CDPC.PlayerReplicationInfo);
		
		if ( FHUDCompatController == None ) return;

		FHUDCompatController.Mutate("FHUDSetCDStateReady" @ CDPRI.PlayerID @ CDPRI.bIsReadyForNextWave, None);
	}

/***** Omake *****/
	function string PlayMeowSound()
	{
		local CD_PlayerController CDPC;

		foreach WorldInfo.AllControllers(class'CD_PlayerController', CDPC)
			CDPC.PlayMeowSound();

		if(Rand(100) == 0) return PresetClass.const.JAPANESE_MEOW;
		return "";
	}

	private function string OngshimiCommand(const array<string> Params, CD_PlayerController CDPC)
	{
		if(FRand() < OngshimiVideoChance)
		{
			CDPC.ClientOpenURL("https://youtu.be/Rlb_gYjSASY");
		}
		return PresetClass.const.ONGSHIMI_LYRIC;
	}

	private function string SpawnZedCommand(const array<string> Params, CD_PlayerController CDPC)
	{
		if(MyKFGRI.bTraderIsOpen)
		{
			CD_SpawnZed(Params[0], CDPC);
			return "";
		}
		else
		{
			return "<local>CD_Survival.UnavailableInWaveMsg</local>";
		}
	}

	private function string SpawnAICommand(const array<string> Params, CD_PlayerController CDPC)
	{
		if(MyKFGRI.bTraderIsOpen)
		{
			CD_SpawnAI(Params[0], CDPC);
			return "";
		}
		else
		{
			return "<local>CD_Survival.UnavailableInWaveMsg</local>";
		}
	}

	private function string HandleKillZeds(const array<string> Params, CD_PlayerController CDPC)
	{
		if(MyKFGRI.bTraderIsOpen)
		{
			Ext_KillZeds();
		}
		else if(CDPC.GetCDPRI().AuthorityLevel < 1)
		{
			return "<local>CD_Survival.KillZedsAuthorityError</local>";
		}
		else if(MyKFGRI.AIRemaining <= 3)
		{
			if(MyKFGRI.bWaveIsActive)
				EndCurrentWave();
			else
				Ext_KillZeds();
		}
		else
		{
			return "<local>CD_Survival.CurrentlyUnavailableMsg</local>";
		}

		return "";
	}

	private function string DoshPlayCommand(const array<string> Params, CD_PlayerController CDPC)
	{
		if(Params.length > 0 && Params[0] == "drone")
		{
			SpawnDoshDrone(CDPC);
		}
		else
		{
			GetDoshinegun(CDPC);
		}
		return "";
	}

defaultproperties
{
	PresetClass=class'CD_ChatCommandPresets'
}
