//=============================================================================
// CD_ChatCommander
//=============================================================================
// Manages the ChatCommand datastructures; matches incoming !cd... command
// chat strings and dispatches to the appropriate function.
//=============================================================================

class CD_ChatCommander extends Object
	within CD_Survival
	DependsOn(CD_Survival);

`include(CD_BuildInfo.uci)
`include(CD_Log.uci)

struct StructChatCommand
{
	var array<string> Names; 
	var array<string> ParamHints; 
	var delegate<ChatCommandNullaryImpl> NullaryImpl;
	var delegate<ChatCommandParamsImpl> ParamsImpl;
	var CD_Setting CDSetting;
	var string Description;
	var ECDAuthLevel AuthLevel;
	var bool ModifiesConfig;
};

var array<StructChatCommand> ChatCommands;

delegate string ChatCommandNullaryImpl();
delegate string ChatCommandParamsImpl( const out array<string> params );

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

		HelpString $= " [" $ ChatCommands[CCIndex].AuthLevel $ "]";

		GameInfo_CDCP.Print(HelpString, false);
		GameInfo_CDCP.Print("    " $ ChatCommands[CCIndex].Description, false);
	}
}

function RunCDChatCommandIfAuthorized( Actor Sender, string CommandString )
{
	local ECDAuthLevel AuthLevel;
	local string ResponseMessage;
	local array<string> CommandTokens;
	local name GameStateName;
	local StructChatCommand Cmd;
	local CD_Setting CDSetting;
	local string TempString;

	local delegate<ChatCommandNullaryImpl> CNDeleg;
	local delegate<ChatCommandParamsImpl> CPDeleg;

	// First, see if this chat message looks even remotely like a CD command
	if ( 3 > Len( CommandString ) || (!( Left( CommandString, 3 ) ~= "!cd") && !( Left( CommandString, 4 ) ~= "!rpw")) )
	{
		return;
	}

	AuthLevel = GetAuthorizationLevelForUser( Sender );

	// Split the chat command on spaces, dropping empty parts.
	ParseStringIntoArray( CommandString, CommandTokens, " ", true );

	ResponseMessage = "";

	if ( MatchChatCommand( CommandTokens[0], Cmd, AuthLevel, CommandTokens.Length - 1 ) )
	{
		`cdlog("ChatCommander: Invoking chat command via table match", bLogControlledDifficulty);
		CNDeleg = Cmd.NullaryImpl;
		CPDeleg = Cmd.ParamsImpl;
		if ( Cmd.ParamHints.Length == 0 )
		{
			`cdlog("Invoking nullary chat command: "$ CommandString, bLogControlledDifficulty);
			ResponseMessage = CNDeleg();
		}
		else
		{
			`cdlog("Invoking chat command with parameters: "$ CommandString, bLogControlledDifficulty);
			CommandTokens.Remove( 0, 1 );
			ResponseMessage = CPDeleg( CommandTokens );
		}

		if ( Cmd.ModifiesConfig )
		{
			// Check whether we're allowed to modify settings right now.
			// If so, change settings immediately and let ApplyStagedSettings()
			// format an appropriate notification message.
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
					}
				}
			}
		}
	}
	else
	{
		`cdlog("Discarding unknown or unauthorized command: "$ CommandString, bLogControlledDifficulty);
	}

	// An authorized command match was found; the command may or may not
	// have succeeded, but something was executed and a chat reply should
	// be sent to all connected clients
	if ( "" != ResponseMessage )
	{
		BroadcastCDEcho( ResponseMessage );
		return;
	}
}

function SetupChatCommands()
{
	local array<string> n;
	local array<string> h;
	local StructChatCommand scc;
	local int i;

	ChatCommands.Length = 0;

	// Setup pause commands
	n.Length = 2;
	h.Length = 0;
	n[0] = "!cdpausetrader";
	n[1] = "!cdpt";
	scc.Names = n;
	scc.ParamHints = h;
	scc.NullaryImpl = PauseTraderTime;
	scc.ParamsImpl = None;
	scc.CDSetting = None;
	scc.Description = "Pause TraderTime countdown";
	scc.AuthLevel = CDAUTH_WRITE;
	scc.ModifiesConfig = false;
	ChatCommands.AddItem( scc );

	n.Length = 2;
	h.Length = 0;
	n[0] = "!cdunpausetrader";
	n[1] = "!cdupt";
	scc.Names = n;
	scc.ParamHints = h;
	scc.NullaryImpl = UnpauseTraderTime;
	scc.ParamsImpl = None;
	scc.CDSetting = None;
	scc.Description = "Unpause TraderTime countdown";
	scc.AuthLevel = CDAUTH_WRITE;
	scc.ModifiesConfig = false;
	ChatCommands.AddItem( scc );

	// Setup info commands
	n.Length = 1;
	h.Length = 0;
	n[0] = "!cdinfo";
	scc.Names = n;
	scc.ParamHints = h;
	scc.NullaryImpl = GetCDInfoChatStringDefault;
	scc.ParamsImpl = None;
	scc.CDSetting = None;
	scc.Description = "Display CD config summary";
	scc.AuthLevel = CDAUTH_READ;
	scc.ModifiesConfig = false;
	ChatCommands.AddItem( scc );

	n.Length = 1;
	h.Length = 1;
	n[0] = "!cdinfo";
	h[0] = "full|abbrev|basic|dynamic";
	scc.Names = n;
	scc.ParamHints = h;
	scc.NullaryImpl = None;
	scc.ParamsImpl = GetCDInfoChatStringCommand;
	scc.CDSetting = None;
	scc.Description = "Display full CD config";
	scc.AuthLevel = CDAUTH_READ;
	scc.ModifiesConfig = false;
	ChatCommands.AddItem( scc );

	// Setup who command
	n.Length = 1;
	h.Length = 0;
	n[0] = "!cdwho";
	scc.Names = n;
	scc.ParamHints = h;
	scc.NullaryImpl = GetCDWhoChatString;
	scc.ParamsImpl = None;
	scc.CDSetting = None;
	scc.Description = "Display names of connected players";
	scc.AuthLevel = CDAUTH_READ;
	scc.ModifiesConfig = false;
	ChatCommands.AddItem( scc );

	n.Length = 1;
	h.Length = 0;
	n[0] = "!cdscp";
	scc.Names = n;
	scc.ParamHints = h;
	scc.NullaryImpl = DisplaySpawnCyclePresets;
	scc.ParamsImpl = None;
	scc.CDSetting = None;
	scc.Description = "Display Spawn Cycle Presets";
	scc.AuthLevel = CDAUTH_READ;
	scc.ModifiesConfig = false;
	ChatCommands.AddItem( scc );

	n.Length = 1;
	h.Length = 1;
	n[0] = "!cdscp";
	h[0] = "full|main|qpless";
	scc.Names = n;
	scc.ParamHints = h;
	scc.NullaryImpl = None;
	scc.ParamsImpl = SCPCommand;
	scc.CDSetting = None;
	scc.Description = "";
	scc.AuthLevel = CDAUTH_READ;
	scc.ModifiesConfig = false;
	ChatCommands.AddItem( scc );
/*
	n.Length = 1;
	h.Length = 0;
	n[0] = "!cdpi";
	scc.Names = n;
	scc.ParamHints = h;
	scc.NullaryImpl = DisplayPlayerInfo;
	scc.ParamsImpl = None;
	scc.CDSetting = None;
	scc.Description = "Display Player Info";
	scc.AuthLevel = CDAUTH_READ;
	scc.ModifiesConfig = false;
	ChatCommands.AddItem( scc );
*/
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

//	SetupSimpleReadCommand( scc, "!cdhelp", "Information about CD's chat commands", GetCDChatHelpReferralString );
	SetupSimpleReadCommand( scc, "!cdversion", "Display mod version", GetCDVersionChatString );
}

private function bool MatchChatCommand( const string CmdName, out StructChatCommand Cmd, const ECDAuthLevel AuthLevel, const int ParamCount )
{
	local int CCIndex;
	local int NameIndex;

	for ( CCIndex = 0; CCIndex < ChatCommands.length; CCIndex++ )
	{
		if ( AuthLevel < ChatCommands[CCIndex].AuthLevel )
		{
			continue;
		}

		if ( ParamCount != ChatCommands[CCIndex].ParamHints.Length )
		{
			continue;
		}

		for ( NameIndex = 0; NameIndex < ChatCommands[CCIndex].Names.Length; NameIndex++ )
		{
			if ( ChatCommands[CCIndex].Names[NameIndex] == CmdName )
			{
				Cmd = ChatCommands[CCIndex];
				return true;
				`cdlog("MatchChatCommand["$ CCIndex $"]: found Name="$ CmdName $" ParamCount="$ ParamCount $" AuthLevel="$ AuthLevel, bLogControlledDifficulty);
			}
		}
	}

	return false;
}

private function SetupSimpleReadCommand( out StructChatCommand scc, const string CmdName, const string Desc, const delegate<ChatCommandNullaryImpl> Impl )
{
	local array<string> n;
	local array<string> empty;

	empty.length = 0;
	n.Length = 1;
	n[0] = CmdName;

	scc.Names = n;
	scc.ParamHints = empty;
	scc.NullaryImpl = Impl;
	scc.ParamsImpl = None;
	scc.CDSetting = None;
	scc.Description = Desc;
	scc.AuthLevel = CDAUTH_READ;
	scc.ModifiesConfig = false;

	ChatCommands.AddItem( scc );
}

// Info and Help

private function string GetCDChatHelpReferralString() {
	return "Type CDChatHelp in console for chat command info";
}

private function string GetCDInfoChatStringDefault()
{
	return GetCDInfoChatString( "brief" );
}

private function string GetCDInfoChatStringCommand( const out array<string> params)
{
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
				 WaveSizeFakesSetting.GetBriefChatLine() $ "\n" $
				 SpawnModSetting.GetBriefChatLine() $ "\n" $
				 SpawnPollSetting.GetBriefChatLine() $ "\n" $
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


// Tiger removed totals list as it was redundant and the addition 8th line would cause a single spectator to force
// cdwho results into console. This is undesirable as it creates confusion and an extra step if someone is spectating
// a 6-man team.
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

private function string DisplaySpawnCyclePresets()
{
	return GetSCP("main");
}

private function string SCPCommand( const out array<string> params)
{
	return GetSCP( params[0] );
}

function string GetSCP( const string key )
{
	local string Result;

	Result = "";	
	
	if(key == "full")
	{
		Result $= "asp_fp_v2" $"\n"$
				  "doomsday_v1" $"\n"$
				  "poopro_v1" $"\n"$
				  "ts_mig_v3" $"\n"$
				  "doom_v2_plus" $"\n"$
				  "mko_v1" $"\n"$
				  "doom_v2_plus_rmk" $"\n"$
				  "doom_v2" $"\n"$
				  "asp_v2" $"\n"$
				  "ts_mig_v2" $"\n"$
				  "nam_poundemonium" $"\n"$
				  "osffi_v1" $"\n"$
				  "osffi_v1_ms" $"\n"$
				  "dtf_pm" $"\n"$
				  "dtf_v1" $"\n"$
				  "pro_short" $"\n"$
				  "asp_fp_v1" $"\n"$
				  "rd_sam" $"\n"$
				  "fpp_v1" $"\n"$
				  "ts_mig_v1" $"\n"$
				  "pound420_v1" $"\n"$
				  "doom_v2_short" $"\n"$
				  "asl_v3" $"\n"$
				  "asl_v2" $"\n"$
				  "grand_v1" $"\n"$
				  "bl_v2" $"\n"$
				  "ts_lk313_stg" $"\n"$
				  "doom_v1" $"\n"$
				  "pro6_plus" $"\n"$
				  "pro6" $"\n"$
				  "asp_v1" $"\n"$
				  "bl_v1" $"\n"$
				  "asl_v1" $"\n"$
				  "classiczeds_v1" $"\n"$
				  "su_v1" $"\n"$
				  "bl_light" $"\n"$
				  "nam_pro_v5_plus" $"\n"$
				  "rd_odt" $"\n"$
				  "pubs_v1" $"\n"$
				  "machine_solo" $"\n"$
				  "nam_pro_v5" $"\n"$
				  "nba_v1" $"\n"$
				  "ncaa_v1" $"\n"$
				  "rd_kta" $"\n"$
				  "nam_pro_v4" $"\n"$
				  "nam_pro_v3" $"\n"$
				  "nam_pro_v2" $"\n"$
				  "nam_pro_v1" $"\n"$
				  "nam_semi_pro_v2" $"\n"$
				  "nam_semi_pro" $"\n"$
				  "albino_heavy" $"\n"$
				  "basic_heavy" $"\n"$
				  "basic_moderate" $"\n"$
				  "basic_light";
	}

	else if(key == "main")
	{
		Result $= "asp_fp_v2" $"\n"$
				  "poopro_v1" $"\n"$
				  "ts_mig_v3" $"\n"$
				  "doom_v2_plus_rmk" $"\n"$
				  "doom_v2" $"\n"$
				  "asp_v2" $"\n"$
				  "ts_mig_v2" $"\n"$
				  "osffi_v1" $"\n"$
				  "dtf_pm" $"\n"$
				  "fpp_v1" $"\n"$
				  "ts_mig_v1" $"\n"$
				  "asl_v3" $"\n"$
				  "bl_v2" $"\n"$
				  "asp_v1" $"\n"$
				  "asl_v1" $"\n"$
				  "bl_light" $"\n"$
				  "nam_pro_v5" $"\n"$
				  "nam_pro_v3" $"\n"$
				  "(Type \"!cdscp full\" to print in detail)";
	}

	else if(key == "poop")
	{
		Result $= "gso_v1" $"\n"$
				  "gso_v2" $"\n"$
				  "aio_v1" $"\n"$
				  "aio_v2" $"\n"$
				  "aio_zer0" $"\n"$
				  "gg_v1" $"\n"$
				  "su_v1_short";
	}

	else if (key == "new")
	{
		Result $= "[Name] (Larges on Wave10)" $"\n"$
				  "asp_v2 (23%: Rush)" $"\n"$
				  "poopro_v1 (27%: =mig3)" $"\n"$
				  "dtf_pm (20%: =dtf)" $"\n"$
				  "aio_zer0 (32%: =mko)" $"\n"$
				  "chaos_v1 (21%: No SC)" $"\n"$
				  "classiczeds_v1 (17% No QP)" $"\n"$
				  "dig_v1 (24%: Strange)" $"\n"$
				  "nba_v1 (9%: No Bloat)" $"\n"$
				  "ncaa_v1 (9%)" $"\n"$
				  "owo_v1 (15%: No QP & Husk)" $"\n"$
				  "pound420_v1 (18%: more QP)" $"\n"$
				  "xj9_v1 (23%: many mediums)";
	}

	return Result;
}
/*
private function string DisplayPlayerInfo()
{
	local string Result;
	local KFPlayerController KFPC;
	local int i;
	local bool bHide;
	local Inventory Inv;

	Result = "---------------------------------------\n";

	foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC)
	{
		if(KFPC.PlayerReplicationInfo.bOnlySpectator) continue;

		Result $= KFPC.PlayerReplicationInfo.PlayerName $ " | ";

		Result $= Mid(string(KFPC.GetPerk().GetPerkClass()), 7) $ " | ";
		
		for(i=0; i<10; i+=2)
		{	
			Result $= (KFPC.GetPerk().PerkSkills[i].bActive) ? "L" : "R";
		}
		Result $= "\n";

		for(Inv=KFPC.Pawn.InvManager.InventoryChain; Inv!=None; Inv=Inv.Inventory)
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
			if(!bHide) Result $= Inv.ItemName $ " | ";
			else bHide = false;
		}

		Result $= "\n\n";
	}

	return Result;
}
*/