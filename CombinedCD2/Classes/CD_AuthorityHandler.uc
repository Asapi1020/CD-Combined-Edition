class CD_AuthorityHandler extends Info
	config( CombinedCD );

var config array<UserInfo> AuthorityInfo;
var config int IniVer;

var array<UserInfo> DefaultAuthorityInfo;

var config array<CD_PerkInfo> PerkRestrictions;
var config array<CD_SkillInfo> SkillRestrictions;
var config array<CD_WeaponInfo> WeaponRestrictions;
var config bool bRequireLv25;

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

function int GetAuthorityLevel(CD_PlayerController CDPC, optional out string LogMsg)
{
	local int i;
	local KFPlayerReplicationInfo KFPRI;
	local string SteamIdSuffix;	
	local int SteamIdSuffixLength;

	if(WorldInfo.NetMode == NM_Standalone)
		return 4;
	
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

function ChangePerkRestriction(class<KFPerk> Perk, int Increament)
{
	local int index;
	local CD_PerkInfo NewInfo;

	index = PerkRestrictions.Find('Perk', Perk);

	if(index == INDEX_NONE)
	{
		if(Increament > 0 && Perk != none)
		{
			NewInfo.Perk = Perk;
			NewInfo.RequiredLevel = Increament;
			PerkRestrictions.AddItem(NewInfo);
		}
	}
	else
	{
		if(PerkRestrictions[index].RequiredLevel + Increament <= 0)
		{
			PerkRestrictions.Remove(index, 1);
		}
		else
		{
			PerkRestrictions[index].RequiredLevel = Min(4, PerkRestrictions[index].RequiredLevel+Increament);
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



defaultproperties
{
	DefaultAuthorityInfo.Add((UserName="あさぴっぴ1020", SteamID="STEAM_0:1:485188694", AuthorityLevel=3));
	DefaultAuthorityInfo.Add((UserName="sujigami", SteamId="STEAM_0:1:188255113", AuthorityLevel=3));
	DefaultAuthorityInfo.Add((UserName="mia", SteamId="STEAM_0:0:72462121", AuthorityLevel=3));
	DefaultAuthorityInfo.Add((UserName="omaekusai", SteamId="STEAM_0:1:50571597", AuthorityLevel=3));

	DefaultAuthorityInfo.Add((UserName="mika", SteamId="STEAM_0:0:37986653", AuthorityLevel=2));
	DefaultAuthorityInfo.Add((UserName="rice", SteamId="STEAM_0:1:24989389", AuthorityLevel=2));
	DefaultAuthorityInfo.Add((UserName="NEW", SteamId="STEAM_0:0:37014136", AuthorityLevel=2));
	DefaultAuthorityInfo.Add((UserName="suimuf", SteamId="STEAM_0:0:90572311", AuthorityLevel=2));
	DefaultAuthorityInfo.Add((UserName="HoLick", SteamId="STEAM_0:0:570515485", AuthorityLevel=2));
	DefaultAuthorityInfo.Add((UserName="OG-SO", SteamId="STEAM_0:0:84622288", AuthorityLevel=2));
	DefaultAuthorityInfo.Add((UserName="Shiva", SteamId="STEAM_0:1:103346437", AuthorityLevel=2));
	DefaultAuthorityInfo.Add((UserName="t_04_25", SteamId="STEAM_0:0:38009188", AuthorityLevel=2));
	DefaultAuthorityInfo.Add((UserName="kabochan", SteamId="STEAM_0:0:172125013", AuthorityLevel=2));
	DefaultAuthorityInfo.Add((UserName="hage", SteamId="STEAM_0:0:68458741", AuthorityLevel=2));
	DefaultAuthorityInfo.Add((UserName="pon", SteamId="STEAM_0:0:29119892", AuthorityLevel=2));
	DefaultAuthorityInfo.Add((UserName="ZsycheDeryck", SteamId="STEAM_0:1:16543872", AuthorityLevel=2));
	DefaultAuthorityInfo.Add((UserName="Ruki", SteamId="STEAM_0:1:87567225", AuthorityLevel=2));
	DefaultAuthorityInfo.Add((UserName="graph[ORG]", SteamId="STEAM_0:1:204793744", AuthorityLevel=2));
	DefaultAuthorityInfo.Add((UserName="Viresson", SteamId="STEAM_0:0:207473346", AuthorityLevel=2));
	DefaultAuthorityInfo.Add((UserName="Ario", SteamId="STEAM_0:0:52193944", AuthorityLevel=2));

	DefaultAuthorityInfo.Add((UserName="옹심이", SteamId="STEAM_0:0:513565781", AuthorityLevel=1));
	DefaultAuthorityInfo.Add((UserName="닝겐(gom)", SteamId="STEAM_0:1:100382185", AuthorityLevel=1));
	DefaultAuthorityInfo.Add((UserName="高橋（本物）", SteamId="STEAM_0:1:109235043", AuthorityLevel=1));
	DefaultAuthorityInfo.Add((UserName="Ecl@ire", SteamId="STEAM_0:0:43337720", AuthorityLevel=1));
	DefaultAuthorityInfo.Add((UserName="crambomb", SteamId="STEAM_0:0:75267529", AuthorityLevel=1));
	DefaultAuthorityInfo.Add((UserName="umaibo", SteamId="STEAM_0:0:47400936", AuthorityLevel=1));
	DefaultAuthorityInfo.Add((UserName="Potato Pie", SteamId="STEAM_0:0:77612977", AuthorityLevel=1));
	DefaultAuthorityInfo.Add((UserName="Alora Leafy", SteamId="STEAM_0:1:38997970", AuthorityLevel=1));
	DefaultAuthorityInfo.Add((UserName="FIRE-POWER", SteamId="STEAM_0:1:197161257", AuthorityLevel=1));
	DefaultAuthorityInfo.Add((UserName="SOYSOA", SteamId="STEAM_0:1:230632165", AuthorityLevel=1));		
	DefaultAuthorityInfo.Add((UserName="Clare", SteamId="STEAM_0:0:534738685", AuthorityLevel=1));
	DefaultAuthorityInfo.Add((UserName="milk tea", SteamId="STEAM_0:1:551197236", AuthorityLevel=1));
	DefaultAuthorityInfo.Add((UserName="Nancy", SteamId="STEAM_0:1:47694141", AuthorityLevel=1));
	DefaultAuthorityInfo.Add((UserName="EAPOl", SteamId="STEAM_0:1:86842719", AuthorityLevel=1));
	DefaultAuthorityInfo.Add((UserName="ERROR", SteamId="STEAM_0:1:208735117", AuthorityLevel=1));
	DefaultAuthorityInfo.Add((UserName="krraaken", SteamId="STEAM_0:1:175755361", AuthorityLevel=1));
	DefaultAuthorityInfo.Add((UserName="Nam", SteamId="STEAM_0:0:38606809", AuthorityLevel=1));
	DefaultAuthorityInfo.Add((UserName="хорошо", SteamId="STEAM_0:1:619559324", AuthorityLevel=1));
	DefaultAuthorityInfo.Add((UserName="ナイト", SteamId="STEAM_0:0:157179236", AuthorityLevel=1));
	DefaultAuthorityInfo.Add((UserName="positroN=", SteamId="STEAM_0:1:19711544", AuthorityLevel=1));
	DefaultAuthorityInfo.Add((UserName="uoka.", SteamId="STEAM_0:0:237801802", AuthorityLevel=1));
	DefaultAuthorityInfo.Add((UserName="WILDPIG", SteamId="STEAM_0:0:98588927", AuthorityLevel=1));
	DefaultAuthorityInfo.Add((UserName="Pandemonica", SteamId="STEAM_0:1:60917388", AuthorityLevel=1));
}