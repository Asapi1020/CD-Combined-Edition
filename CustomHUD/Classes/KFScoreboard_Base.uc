class KFScoreboard_Base extends KFGUI_Page
	dependson(Types);

`include(Build.uci)
`include(Logger.uci)

var KFGUI_List PlayersList;
var KFPlayerController OwnerPC;
var KFGameReplicationInfo KFGRI;
var Texture2D DefaultAvatar;
var array<String> PerkNames;

function InitMenu()
{
	`callstack();
	
	Super.InitMenu();
	PlayersList = KFGUI_List(FindComponentID('PlayerList'));
	OwnerPC = KFPlayerController(GetPlayer());
	
	if (PerkNames.Length == 0)
	{
		PerkNames.AddItem(class'KFGFxMenu_Inventory'.default.PerkFilterString);
		PerkNames.AddItem(class'KFPerk_Berserker'.default.PerkName);
		PerkNames.AddItem(class'KFPerk_Commando'.default.PerkName);
		PerkNames.AddItem(class'KFPerk_Support'.default.PerkName);
		PerkNames.AddItem(class'KFPerk_FieldMedic'.default.PerkName);
		PerkNames.AddItem(class'KFPerk_Demolitionist'.default.PerkName);
		PerkNames.AddItem(class'KFPerk_Firebug'.default.PerkName);
		PerkNames.AddItem(class'KFPerk_Gunslinger'.default.PerkName);
		PerkNames.AddItem(class'KFPerk_Sharpshooter'.default.PerkName);
		PerkNames.AddItem(class'KFPerk_SWAT'.default.PerkName);
		PerkNames.AddItem(class'KFPerk_Survivalist'.default.PerkName);
	}
}

static function CheckAvatar(KFPlayerReplicationInfo KFPRI, KFPlayerController PC)
{
	local Texture2D Avatar;

	if (KFPRI.Avatar == None || KFPRI.Avatar == default.DefaultAvatar)
	{
		Avatar = FindAvatar(PC, KFPRI.UniqueId);
		if (Avatar == None)
			Avatar = default.DefaultAvatar;

		KFPRI.Avatar = Avatar;
	}
}

function string WaveText()
{
	local int CurrentWaveNum;

	if (KFGRI == None)
	{
		KFGRI = KFGameReplicationInfo(GetPlayer().WorldInfo.GRI);
		
		if (KFGRI == None)
			return "";
	}
	
	CurrentWaveNum = KFGRI.WaveNum;
    if (KFGRI.IsBossWave())
    {
		return class'KFGFxHUD_WaveInfo'.default.BossWaveString;
    }
	else if (KFGRI.IsFinalWave())
	{
		return class'KFGFxHUD_ScoreboardMapInfoContainer'.default.FinalString;
	}
    else
    {
		if (KFGRI.default.bEndlessMode)
		{
    		return "" $ CurrentWaveNum;
		}
		else
		{
			return CurrentWaveNum $ " / " $ KFGRI.GetFinalWaveNum();
		}
    }
}

function DrawTextShadowHVCenter(string Str, float XPos, float YPos, float BoxWidth, float FontScalar)
{
	local float TextWidth;
	local float TextHeight;

	Canvas.TextSize(Str, TextWidth, TextHeight, FontScalar, FontScalar);

	Owner.CurrentStyle.DrawTextShadow(Str, XPos + (BoxWidth - TextWidth)/2 , YPos, 1, FontScalar);
}

function DrawTextShadowHLeftVCenter(string Str, float XPos, float YPos, float FontScalar)
{
	Owner.CurrentStyle.DrawTextShadow(Str, XPos, YPos, 1, FontScalar);
}

function DrawTextShadowHRightVCenter(string Str, float XPos, float YPos, float BoxWidth, float FontScalar)
{
	local float TextWidth;
	local float TextHeight;

	Canvas.TextSize(Str, TextWidth, TextHeight, FontScalar, FontScalar);
	
	Owner.CurrentStyle.DrawTextShadow(Str, XPos + BoxWidth - TextWidth, YPos, 1, FontScalar);
}

function SetDrawColor(Canvas C, ColorRGBA RGBA)
{
	C.SetDrawColor(RGBA.R, RGBA.G, RGBA.B, RGBA.A);
}

static final function Texture2D FindAvatar(KFPlayerController PC, UniqueNetId ClientID)
{
	local string S;

	S = PC.GetSteamAvatar(ClientID);
	if (S == "")
		return None;
	return Texture2D(PC.FindObject(S, class'Texture2D'));
}

final static function string GetNiceSize(int Num)
{
	if (Num < 1000 ) return string(Num);
	else if (Num < 1000000 ) return (Num / 1000) $ "K";
	else if (Num < 1000000000 ) return (Num / 1000000) $ "M";

	return (Num / 1000000000) $ "B";
}

function ScrollMouseWheel(bool bUp)
{
	PlayersList.ScrollMouseWheel(bUp);
}

defaultproperties
{
	DefaultAvatar=Texture2D'UI_HUD.ScoreBoard_Standard_SWF_I26'
}
