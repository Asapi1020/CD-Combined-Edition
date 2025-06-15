/**
 * @file CD_RPCHandler.uc
 * @brief Handles remote procedure call functionality for CD_PlayerController.
 */
class CD_RPCHandler extends ReplicationInfo;

`include(CD_Log.uci)

var private CD_PlayerController CDPC;

public function PostBeginPlay()
{
	CDPC = CD_PlayerController(Owner);
}

public function Tick(float Delta)
{
	if(CDPC == None || CDPC.Player == None)
	{
		`cdlog("CD_RPCHandler.Tick: CDPC or Player is None, destroying CD_RPCHandler.");
		Destroy();
		return;
	}
}

private simulated function CD_PlayerController GetCDPC()
{
	if( CDPC == None )
	{
		CDPC = CD_PlayerController(GetALocalPlayerController());
	}
	
	return CDPC;
}

private reliable server simulated function CD_Survival GetCD()
{
	local CD_Survival CD;
	
	CD = CD_Survival(GetCDPC().WorldInfo.Game);
	
	if (CD == None)
	{
		`cdlog("CD_RPCHandler.GetCD: CD_Survival is None, returning None.");
		return None;
	}

	return CD;
}

public reliable server simulated function CheckPlayerStartForCurMap()
{
	local string JoinedPathNodesIndexString;
	
	JoinedPathNodesIndexString = GetCD().xMut.GetPlayerStartForCurMap();
	ReceivePathNodesIndex(JoinedPathNodesIndexString);
}

private reliable client simulated function ReceivePathNodesIndex(string JoinedPathNodesIndexString)
{
	local array<string> PathNodesIndexString;
	local KF2GUIController GUIController;
	local KFGUI_Page FoundMenu;
	local xUI_AdminMenu AdminMenu;

	PathNodesIndexString = SplitString(JoinedPathNodesIndexString);
	GUIController = GetCDPC().GetGUIController();
	FoundMenu = GUIController.FindActiveMenu('AdminMenu');
	AdminMenu = xUI_AdminMenu(FoundMenu);

	if ( AdminMenu != None )
	{
		AdminMenu.UpdatePlayerStartList(PathNodesIndexString);
		return;
	}

	`cdlog("Admin Menu is not active");
}

public reliable server simulated function GotoPathNode(int NodeIndex)
{
	local KFPathnode PathNode;

	PathNode = FindPathNodeByIndex(NodeIndex);

	if (PathNode != None)
	{
		GetCDPC().Pawn.SetLocation(PathNode.Location);
	}
}

public reliable server simulated function RequestEveryoneGotoPathNode(int NodeIndex)
{
	local KFPathnode PathNode;
	local CD_PlayerController Player;

	PathNode = FindPathNodeByIndex(NodeIndex);

	if (PathNode == None)
	{
		return;
	}

	forEach GetCDPC().WorldInfo.AllControllers(class'CD_PlayerController', Player)
	{
		Player.Pawn.SetLocation(PathNode.Location);
	}
}

private reliable server simulated function KFPathnode FindPathNodeByIndex(int NodeIndex)
{
	local KFPathnode PathNode;
	local array<string> splitNodeName;

	forEach AllActors(class'KFPathnode', PathNode)
	{
		ParseStringIntoArray(string(PathNode), splitNodeName, "_", true);

		if (splitNodeName.length > 1 &&  splitNodeName[1] == string(NodeIndex))
		{
			return PathNode;
		}
	}

	`cdlog("CD_RPCHandler.FindPathNodeByIndex: No PathNode found with index " $ NodeIndex);
	return None;
}

public reliable server simulated function GetDisableCustomStarts()
{
	local bool bDisableCustomStarts;

	bDisableCustomStarts = GetCD().xMut.DisableCustomStarts;

	ReceiveDisableCustomStarts(bDisableCustomStarts);
}

private reliable client simulated function ReceiveDisableCustomStarts(bool bDisable)
{
	local KFGUI_Page FoundMenu;
	local xUI_AdminMenu AdminMenu;

	FoundMenu = GetCDPC().GetGUIController().FindActiveMenu('AdminMenu');
	AdminMenu = xUI_AdminMenu(FoundMenu);

	if ( AdminMenu != None )
	{
		AdminMenu.ReceiveDisableCustomStarts(bDisable);
		return;
	}

	`cdlog("Admin Menu is not active");
}

public reliable server simulated function SetDisableCustomStarts(bool bDisable)
{
	GetCD().xMut.DisableCustomStarts = bDisable;
}

defaultproperties
{
	bAlwaysRelevant=false
	bOnlyRelevantToOwner = true
}
