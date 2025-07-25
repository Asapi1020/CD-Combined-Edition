class CD_AuthorityHandler extends Info
	config( CombinedCD );

var config array<UserInfo> AuthorityInfo;
var config int IniVer;

var config array<CD_PerkInfo> PerkRestrictions;
var config array<CD_SkillInfo> SkillRestrictions;
var config array<CD_WeaponInfo> WeaponRestrictions;
var config bool bRequireLv25;
var config bool bAntiOvercap;

const ADMIN_LEVEL = 4;
const BAN_LEVEL = 5;

public simulated function bool SafeDestroy()
{
	return (bPendingDelete || bDeleteMe || Destroy());
}

public event PreBeginPlay()
{
	if (WorldInfo.NetMode == NM_Client)
	{
		SafeDestroy();
		return;
	}

	super.PreBeginPlay();
}

public event PostBeginPlay()
{
	if (bPendingDelete || bDeleteMe) return;
	
	Super.PostBeginPlay();
}

function AuthorizeUser(string SteamID, int AuthorityLevel, optional string UserName)
{
	local UserInfo UInfo;

	if(UserName != "")
		UInfo.UserName = UserName;

	UInfo.SteamID = SteamID;
	UInfo.AuthorityLevel = AuthorityLevel;
	ChangeUserAuthority(UInfo);
}

function ChangeUserAuthority(UserInfo ChangedUser)
{
	local int index;

	index = AuthorityInfo.Find('SteamID', ChangedUser.SteamID);

	if(index == INDEX_NONE)
	{
		AuthorityInfo.AddItem(ChangedUser);
	}
	else
	{
		AuthorityInfo[index] = ChangedUser;
	}

	SaveConfig();
}

function RemoveAuthorityInfo(UserInfo User)
{
	AuthorityInfo.RemoveItem(User);
	SaveConfig();
}

function int GetAuthorityLevel(CD_PlayerController CDPC, optional out string LogMsg)
{
	local int i;
	local KFPlayerReplicationInfo KFPRI;
	local string SteamIdSuffix;	
	local int SteamIdSuffixLength;

	if(WorldInfo.NetMode == NM_Standalone)
		return ADMIN_LEVEL;
	
	KFPRI = KFPlayerReplicationInfo(CDPC.PlayerReplicationInfo);
	if(KFPRI == none)
	{
		LogMsg = "KFPRI = none";
		return 0;
	}

	SteamIdSuffix = Mid(class'CD_Object'.static.GetSteamID(CDPC.GetCDPRI().UniqueId), Len("STEAM_0"));
	SteamIdSuffixLength = Len( SteamIdSuffix );

	for(i=0; i<AuthorityInfo.length; i++)
	{
		if( Len(AuthorityInfo[i].SteamID) < SteamIdSuffixLength )
			continue;

		if( Right(AuthorityInfo[i].SteamID, SteamIdSuffixLength) == SteamIdSuffix)
			return AuthorityInfo[i].AuthorityLevel;
	}
	return 0;
}

function ChangePerkRestriction(class<KFPerk> Perk, int Increment)
{
	local int index;
	local CD_PerkInfo NewInfo;

	index = PerkRestrictions.Find('Perk', Perk);

	if(index == INDEX_NONE)
	{
		if(Increment > 0 && Perk != none)
		{
			NewInfo.Perk = Perk;
			NewInfo.RequiredLevel = Increment;
			PerkRestrictions.AddItem(NewInfo);
		}
	}
	else
	{
		if(PerkRestrictions[index].RequiredLevel + Increment <= 0)
		{
			PerkRestrictions.Remove(index, 1);
		}
		else
		{
			PerkRestrictions[index].RequiredLevel = Min(BAN_LEVEL, PerkRestrictions[index].RequiredLevel+Increment);
		}
	}

	SaveConfig();
}

function ChangeWeaponRestriction(CD_WeaponInfo CDWI)
{
	local int index;

	index = WeaponRestrictions.Find('WeapDef', CDWI.WeapDef);

	if(CDWI.RequiredLevel == 0 && !CDWI.bOnlyForBoss && index != INDEX_NONE)
	{
		WeaponRestrictions.Remove(index, 1);
	}
	else if(index != INDEX_NONE)
	{
		WeaponRestrictions[index] = CDWI;
	}
	else if(CDWI.WeapDef != none)
	{
		WeaponRestrictions.AddItem(CDWI);
	}

	SaveConfig();
}
