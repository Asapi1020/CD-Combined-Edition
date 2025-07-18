Class xVoteWebApp extends Object implements(IQueryHandler);

var WebAdmin webadmin;
var string MapVoterURL;
var string StatsBoardURL;
var string CDInfoURL;
var string CDSettingsURL;
var int EditSettingLine;
var xVotingHandler xVH;

function cleanup()
{
	webadmin = None;
}

function init(WebAdmin webapp)
{
	webadmin = webapp;
}

function registerMenuItems(WebAdminMenu menu)
{
	menu.addMenu(StatsBoardURL, "CD RECORDS", self, "Display CD records", -97);
	menu.addMenu(CDInfoURL, "CD INFO", self, "Display CD Information", -98);
	menu.addMenu(MapVoterURL, "CD MAP VOTE", self, "Modify settings of mapvote.", -88);
//	menu.addMenu(CDSettingsURL, "CD SETTINGS", self, "Modify settings of CD.", -89);
}

function bool handleQuery(WebAdminQuery q)
{
	switch (q.request.URI)
	{
		case MapVoterURL:
			handleMapVotes(q);
			return true;
		case StatsBoardURL:
			handleStatsBoard(q);
			return true;
		case CDInfoURL:
			handleCDInfo(q);
			return true;
		case CDSettingsURL:
			handleCDSettings(q);
			return true;
	}
	return false;
}

final function IncludeFile(WebAdminQuery q, string file)
{
	local string S;
	
	if (webadmin.HTMLSubDirectory!="")
	{
		S = webadmin.Path $ "/" $ webadmin.HTMLSubDirectory $ "/" $ file;
		if (q.response.FileExists(S))
		{
			q.response.IncludeUHTM(S);
			return;
		}
	}
	q.response.IncludeUHTM(webadmin.Path $ "/" $ file);
}

final function SendHeader(WebAdminQuery q, string Title)
{
	local IQueryHandler handler;
	
	q.response.Subst("page.title", Title);
	q.response.Subst("page.description", "");
	foreach webadmin.handlers(handler)
	{
		handler.decoratePage(q);
	}
	q.response.Subst("messages", webadmin.renderMessages(q));
	if (q.session.getString("privilege.log") != "")
	{
		q.response.Subst("privilege.log", webadmin.renderPrivilegeLog(q));
	}
	IncludeFile(q,"header.inc");
	q.response.SendText("<div id=\"content\">");
}

final function SendFooter(WebAdminQuery q)
{
	IncludeFile(q,"navigation.inc");
	IncludeFile(q,"footer.inc");
	q.response.ClearSubst();
}

final function AddConfigEditbox(WebAdminQuery q, string InfoStr, string CurVal, int MaxLen, string ResponseVar, string Tooltip, optional bool bNoTR)
{
	local string S;
	
	S = "<dt title=\""$Tooltip$"\"><label>"$InfoStr$":</label></dt><dd><input type=\"text\" name=\""$ResponseVar$"\" size=\""$Min(100,MaxLen)$"\" value=\""$CurVal$"\" maxlength=\""$MaxLen$"\"></dd>";
	q.response.SendText(S);
}

final function AddInLineEditbox(WebAdminQuery q, string CurVal, int MaxLen, string ResponseVar, string Tooltip)
{
	q.response.SendText("<abbr title=\""$Tooltip$"\"><TD><input type=\"text\" class=\"text\" name=\""$ResponseVar$"\" size=\""$Min(100,MaxLen)$"\" value=\""$CurVal$"\" maxlength=\""$MaxLen$"\"></TD></abbr>");
}

function handleMapVotes(WebAdminQuery q)
{
	local int i;
	local string S;

	S = q.request.getVariable("edit");
	if (S=="Submit")
	{
		class'xVotingHandler'.Default.VoteTime = int(q.request.getVariable("VT",string(class'xVotingHandler'.Default.VoteTime)));
		class'xVotingHandler'.Default.MidGameVotePct = float(q.request.getVariable("MV",string(class'xVotingHandler'.Default.MidGameVotePct)));
		class'xVotingHandler'.Default.MapWinPct = float(q.request.getVariable("VP",string(class'xVotingHandler'.Default.MapWinPct)));
		class'xVotingHandler'.Default.MapChangeDelay = float(q.request.getVariable("SD",string(class'xVotingHandler'.Default.MapChangeDelay)));
		class'xVotingHandler'.Static.StaticSaveConfig();
		EditSettingLine = -1;
	}
	else if (S=="New")
	{
		i = class'xVotingHandler'.Default.GameModes.Length;
		class'xVotingHandler'.Default.GameModes.Length = i+1;
		class'xVotingHandler'.Default.GameModes[i].GameName = "Killing Floor";
		class'xVotingHandler'.Default.GameModes[i].GameShortName = "KF";
		class'xVotingHandler'.Default.GameModes[i].GameClass = "KFGameContent.KFGameInfo_Survival";
		EditSettingLine = i;
		class'xVotingHandler'.Static.StaticSaveConfig();
	}
	else if (S=="Save")
	{
		if (EditSettingLine>=0 && EditSettingLine<class'xVotingHandler'.Default.GameModes.Length)
		{
			i = EditSettingLine;
			class'xVotingHandler'.Default.GameModes[i].GameName = q.request.getVariable("GN",class'xVotingHandler'.Default.GameModes[i].GameName);
			class'xVotingHandler'.Default.GameModes[i].GameShortName = q.request.getVariable("GS",class'xVotingHandler'.Default.GameModes[i].GameName);
			class'xVotingHandler'.Default.GameModes[i].GameClass = q.request.getVariable("GC",class'xVotingHandler'.Default.GameModes[i].GameName);
			class'xVotingHandler'.Default.GameModes[i].Mutators = q.request.getVariable("MM",class'xVotingHandler'.Default.GameModes[i].GameName);
			class'xVotingHandler'.Default.GameModes[i].Options = q.request.getVariable("OP",class'xVotingHandler'.Default.GameModes[i].GameName);
			class'xVotingHandler'.Default.GameModes[i].ServerName = q.request.getVariable("SN",class'xVotingHandler'.Default.GameModes[i].GameName);
			class'xVotingHandler'.Static.StaticSaveConfig();
		}
		EditSettingLine = -1;
	}
	else
	{
		for (i=0; i<class'xVotingHandler'.Default.GameModes.Length; ++i)
		{
			S = q.request.getVariable("edit"$i);
			if (S=="Delete")
			{
				class'xVotingHandler'.Default.GameModes.Remove(i,1);
				class'xVotingHandler'.Static.StaticSaveConfig();
				EditSettingLine = -1;
				break;
			}
			else if (S=="Edit")
			{
				EditSettingLine = i;
				break;
			}
		}
	}

	SendHeader(q,"X - Mapvote");
	q.response.SendText("<form method=\"post\" action=\""$webadmin.Path$MapVoterURL$"\">");
	q.response.SendText("<fieldset>");
	q.response.SendText("<legend>Mapvote Settings</legend>");
	q.response.SendText("<div class=\"section\">");
	q.response.SendText("<dl>");
	AddConfigEditbox(q,"Mapvote time",string(class'xVotingHandler'.Default.VoteTime),8,"VT","Time in seconds people have to cast mapvote");
	AddConfigEditbox(q,"Mid-Game vote pct",string(class'xVotingHandler'.Default.MidGameVotePct),12,"MV","Number of people in percent needs to vote to make game initiate mid-game mapvote");
	AddConfigEditbox(q,"Map win vote pct",string(class'xVotingHandler'.Default.MapWinPct),12,"VP","Number of people in percent needs to vote for same map for mapvote instantly switch to it");
	AddConfigEditbox(q,"Map switch delay",string(class'xVotingHandler'.Default.MapChangeDelay),12,"SD","Time in seconds delay after a mapvote has passed, when server actually switches map");
	q.response.SendText("</dl></div>");
	q.response.SendText("<input class=\"button\" type=\"submit\" name=\"edit\" value=\"Submit\">");
	q.response.SendText("</fieldset></form>");

	q.response.SendText("<form method=\"post\" action=\""$webadmin.Path$MapVoterURL$"\">");
	q.response.SendText("<h3>Mapvote game modes</h3>");
	q.response.SendText("<div class=\"section\">");
	q.response.SendText("<table class=\"grid\" width=\"100%\"><thead><tr><th>Game Name</th><th>Game Short Name</th><th>Game Class</th><th>Mutators</th><th>Options</th><th>Server Name</th><th></th></tr></thead>");
	q.response.SendText("<tbody>");
	for (i=0; i<class'xVotingHandler'.Default.GameModes.Length; ++i)
	{
		if (EditSettingLine==i)
		{
			q.response.SendText("<tr>",false);
			AddInLineEditbox(q,class'xVotingHandler'.Default.GameModes[i].GameName,48,"GN","Game type long display name");
			AddInLineEditbox(q,class'xVotingHandler'.Default.GameModes[i].GameShortName,12,"GS","Game type short display name");
			AddInLineEditbox(q,class'xVotingHandler'.Default.GameModes[i].GameClass,38,"GC","Game type class name to run");
			AddInLineEditbox(q,class'xVotingHandler'.Default.GameModes[i].Mutators,120,"MM","List of mutators to run along with this game option (separated with commas)");
			AddInLineEditbox(q,class'xVotingHandler'.Default.GameModes[i].Options,100,"OP","List of options to run along with this game option (separated with question mark)");
			AddInLineEditbox(q,class'xVotingHandler'.Default.GameModes[i].ServerName,50,"SN","Server name that will be set when this mode is selected ");
			q.response.SendText("</td><td><input class=\"button\" type=\"submit\" name=\"edit\" value=\"Save\"><input class=\"button\" type=\"submit\" name=\"edit"$i$"\" value=\"Delete\"></td></tr>");
		}
		else
		{
			q.response.SendText("<tr><td>"$class'xVotingHandler'.Default.GameModes[i].GameName$
								"</td><td>"$class'xVotingHandler'.Default.GameModes[i].GameShortName$
								"</td><td>"$class'xVotingHandler'.Default.GameModes[i].GameClass$
								"</td><td>"$class'xVotingHandler'.Default.GameModes[i].Mutators$
								"</td><td>"$class'xVotingHandler'.Default.GameModes[i].Options$
								"</td><td>"$class'xVotingHandler'.Default.GameModes[i].ServerName$
								"</td><td><input class=\"button\" type=\"submit\" name=\"edit"$i$"\" value=\"Edit\"><input class=\"button\" type=\"submit\" name=\"edit"$i$"\" value=\"Delete\"></td></tr>");
		}
	}
	q.response.SendText("</tbody></table></div>");
	q.response.SendText("<input class=\"button\" type=\"submit\" name=\"edit\" value=\"New\">");
	q.response.SendText("</form>");
	q.response.SendText("</div></body></html>");
	SendFooter(q);
}

function handleStatsBoard(WebAdminQuery q)
{
	local int i, j;
	local array<string> splitbuf;

	SendHeader(q,"X - StatsBoard");
	q.response.SendText("<form method=\"post\" action=\""$webadmin.Path$StatsBoardURL$"\">");
	q.response.SendText("<legend>CD Record</legend>");
	q.response.SendText("<div class=\"section\">");
	q.response.SendText("<table id=\"settings\" class=\"grid\">");
	q.response.SendText("<thead><tr><th>Time</th><th>Map Name</th><th>SpawnCycle</th><th>MaxMonsters</th><th>Other Settings</th><th></th><th></th><th colspan=\"2\">Team</th><th></th><th></th></thead>");
	q.response.SendText("<tbody>");

	for(i=0; i<class'CD_Recorder'.Default.CDRecords.length; i++)
	{
		ParseStringIntoArray(class'CD_Recorder'.Default.CDRecords[i], splitbuf, "|", true);

		q.response.SendText("<tr>");
		for(j=0; j<splitbuf.length; j++)
		{
			q.response.SendText("<td>" $ splitbuf[j] $ "</td>");
		}
		q.response.SendText("</tr>");
 	}

 	q.response.SendText("</tbody></table></div></form>");
	q.response.SendText("</div></body></html>");
	SendFooter(q);
}

function handleCDInfo(WebAdminQuery q)
{
	local string s;
	local int i;
	local PlayerReplicationInfo PRI;
	local array<PlayerReplicationInfo> PlayersPRI, SpectatorsPRI;

	SendHeader(q,"CD Info");

	s = "";
	s $= "<form method=\"post\" action=\"" $ webadmin.Path $ CDInfoURL $ "\">";
	s $= "<table width=\"100%\" id=\"cdinfo\">";
	s $= "<colgroup><col width=\"25%\"><col width=\"25%\"><col width=\"30%\"><col width=\"20%\"></colgroup>";
	q.response.SendText(s);

	//	Current Game
	s = "";
	s $= "<tbody><tr><td><legend>Current Game</legend>";
	s $= "<div class=\"section\"><dl id=\"currentGame\">";
	s $= "<dt>Server Name</dt><dd id=\"servername\">" $ xVH.KF.ServerName $ "</dd>";
	s $= "<dt>Map</dt><dd id=\"mapname\">" $ xVH.WorldInfo.GetMapName( true ) $ "</dd>";
	s $= "<dt>Wave</dt><dd id=\"wavenum\">";

	if(xVH.KF.WaveNum < xVH.KF.WaveMax)
		s $= string(xVH.KF.WaveNum);
	else if(xVH.KF.WaveNum == xVH.KF.WaveMax)
		s $= "Boss";
	else
		s $= "?";

	s $= "</dd></dl></div></td>";
	q.response.SendText(s);

	//	CD Info
	s = "";
	s $= "<td><h3>CD Info</h3>";
	s $= "<div class=\"section\"><dl id=\"cdinfo\">";
	s $= "<dt>Max Monsters</dt><dd id=\"cd_mm\">" $ class'CD_Survival'.Default.MaxMonsters $ "</dd>";
	s $= "<dt>Cohort Size</dt><dd id=\"cd_cs\">" $ class'CD_Survival'.Default.CohortSize $ "</dd>";
	s $= "<dt>Wave Size Fakes</dt><dd id=\"cd_wsf\">" $ class'CD_Survival'.Default.WaveSizeFakes $ "</dd>";
	s $= "<dt>Spawn Mod</dt><dd id=\"cd_sm\">" $ class'CD_Survival'.Default.SpawnMod $ "</dd>";
	s $= "<dt>Spawn Poll</dt><dd id=\"cd_sp\">" $ class'CD_Survival'.Default.SpawnPoll $ "</dd>";
	s $= "<dt>Spawn Cycle</dt><dd id=\"cd_sc\">" $ class'CD_Survival'.Default.SpawnCycle $ "</dd>";
	s $= "</dl></div></td>";
	q.response.SendText(s);

	PlayersPRI.Remove(0, PlayersPRI.length);
	SpectatorsPRI.Remove(0, SpectatorsPRI.length);

	foreach xVH.KF.PRIArray(PRI)
	{
		if(PRI.bBot || PRI.PlayerId == 0)
			continue;

		if(PRI.bOnlySpectator)
			SpectatorsPRI.AddItem(PRI);

		else
			PlayersPRI.AddItem(PRI);
	}

	//	Players
	s = "";
	s $= "<td><h3 id=\"playersnum\">Players " $ string(xVH.WorldInfo.Game.NumPlayers) $ "/" $ string(xVH.WorldInfo.Game.MaxPlayers) $ "</h3>";
	s $= "<div class=\"section narrow\">";

	s $= "<table id=\"players\" class=\"grid\" width=\"100%\">";
	s $= "<thead><tr><th>Name</th><th>Perk</th><th>ID3</th></tr></thead>";	
	s $= "<tbody>";
	if(PlayersPRI.length > 0)
	{
		for(i=0; i<PlayersPRI.length; i++)
		{
			s $= "<tr><td>" $ PlayersPRI[i].PlayerName $ "</td>";
			s $= "<td>" $ Mid(string(KFPlayerReplicationInfo(PlayersPRI[i]).CurrentPerkClass), 7) $ "</td>";
			s $= "<td>" $ class'CD_Survival'.static.ConvertID(KFPlayerReplicationInfo(PlayersPRI[i]).UniqueID) $ "</td></tr>";
		}
	}
	else
	{
		s $= "<tr><td colspan=\"3\" class=\"center\"><em>There are no players</em></td></tr>";
	}
	s $= "</tbody></table></div></td>";
	q.response.SendText(s);

	//	Spectators
	s = "";
	s $= "<td><h3 id=\"spectatorsnum\">Spectators " $ string(xVH.WorldInfo.Game.NumSpectators) $ "/" $ string(xVH.WorldInfo.Game.MaxSpectators) $ "</h3>";
	s $= "<div class=\"section narrow\">";
	s $= "<table id=\"spectators\" class=\"grid\" width=\"100%\">";
	s $= "<thead><tr><th>Name</th><th>ID3</th></tr></thead>";
	s $= "<tbody>";
	if(SpectatorsPRI.length > 0)
	{
		for(i=0; i<SpectatorsPRI.length; i++)
		{
			s $= "<tr><td>" $ SpectatorsPRI[i].PlayerName $ "</td>";
			s $= "<td>" $ class'CD_Survival'.static.ConvertID(KFPlayerReplicationInfo(SpectatorsPRI[i]).UniqueID) $ "</td></tr>";
		}
	}
	else
	{
		s $= "<tr><td colspan=\"2\" class=\"center\"><em>There are no spectators</em></td></tr>";
	}
	s $= "<tbody></table></div></td>";
	s $= "</form></div></body></html>";
	q.response.SendText(s);
	SendFooter(q);
}

function handleCDSettings(WebAdminQuery q)
{
	local string s;
	local int i;
	local array<bool> BannedSkills;

	BannedSkills.length = 10;
	for(i=0; i<class'CD_AuthorityHandler'.Default.SkillRestrictions.length; i++)
	{
		if(class'CD_AuthorityHandler'.Default.SkillRestrictions[i].Perk == class'KFPerk_Commando')
			BannedSkills[class'CD_AuthorityHandler'.Default.SkillRestrictions[i].Skill] = true;
	}
	i = class'CD_AuthorityHandler'.Default.PerkRestrictions.Find('Perk', class'KFPerk_Commando');

	s = q.request.getVariable("action");
	if(s ~= "save")
	{
		class'CD_AuthorityHandler'.Default.PerkRestrictions[i].RequiredLevel = int(q.request.getVariable("CommandoAuthLevel", string(class'CD_AuthorityHandler'.Default.PerkRestrictions[i].RequiredLevel)));
		class'CD_AuthorityHandler'.static.StaticSaveConfig();
	}

	SendHeader(q, "CD Settings");

	s = "";
	s $= "<form method=\"post\" action=\"" $ webadmin.Path $ CDSettingsURL $ "\">";
	s $= "<fieldset><legend>CD Settings</legend>";
	s $= "<div id=\"settingsWrapper\">";

	s $= "<div id=\"CD_Commando\" class=\"SettingsGroup ui-tabs-panel\" style=\"display: block;\">";
	s $= "<dl><dt title=\"AuthorityLevel\"><label>Authority Level</table></dt>";
	s $= "<dd class><input type=\"text\" id=\"settings_CommandoAuthLevel\" name=\"CommandoAuthLevel\" value=\"" $ class'CD_AuthorityHandler'.Default.PerkRestrictions[i].RequiredLevel $ "\" class=\"spin-button\">";
	s $= "<script type=\"text/javascript\">//<![CDATA[\n$(document).ready(function(){\n  var elm = $('#settings_CommandoAuthLevel');\n  if (true) elm.numeric(\"\\n\");\n  else elm.numeric();\n  elm.SpinButton({min: 0, max: 4, step: 1, page: 1*10, asint: true});\n});\n//]]></script></dd>";
	
	s $= "<dt title=\"Skill_Lv5\"><label>Lv5 Skill</label></dt>";
	s $= "<dd class><input type=\"checkbox\" name=\"skill\" value=\"0\" id=\"skill_0\"";
	if(BannedSkills[0])
		s $= " checked=\"checked\"";
	s $= "><label for=\"skill_0\">" $ class'KFPerk_Commando'.default.PerkSkills[0].Name $ "</label>";
	s $= "<input type=\"checkbox\" name=\"skill\" value=\"1\" id=\"skill_1\"";
	if(BannedSkills[1])
		s $= " checked=\"checked\"";
	s $= "><label for=\"skill_1\">" $ class'KFPerk_Commando'.default.PerkSkills[1].Name $ "</label></dd>";

	s $= "</dl></div>";

	s $= "<button type=\"submit\" name=\"action\" value=\"save\" id=\"btnsave\">save settings</button>";

	s $= "</div>";

	s $= "</fieldset></form></div></body></html>";

	q.response.SendText(s);
	SendFooter(q);
}

function bool producesXhtml()
{
	return true;
}

function bool unhandledQuery(WebAdminQuery q);
function decoratePage(WebAdminQuery q);

defaultproperties
{
	MapVoterURL="/settings/xMapVoter"
	StatsBoardURL="/current/xStatsBoard"
	CDInfoURL="/current/xCDInfo"
	CDSettingsURL="/settings/xCDSettings"
	EditSettingLine=-1
}
