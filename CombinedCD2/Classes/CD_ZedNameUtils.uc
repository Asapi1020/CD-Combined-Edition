//=============================================================================
// CD_ZedNameUtils
//=============================================================================
// Static helper methods for manipulating zed name strings and their
// equivalent EAIType enum values
//=============================================================================

class CD_ZedNameUtils extends Object
	Abstract;

`include(CD_Log.uci)

/**
    Get a zed EAIType from the name.

    This is based on the LoadMonsterByName from KFCheatManager, but I have a separate copy here
    for several reasons:
    0. I need EAIType instead of a class, and there does not seem to be an easy way to convert those
    1. To allow for a few more abbreviations than KFCheatManager knows (e.g. for clots: CC, CA, CS)
    2. To accept a slightly smaller universe of legal input strings, so that the effective API
       created by this function is as small as possible.
    3. So that a hypothetical future KF2 update that might change KFCheatManager's zed abbreviations
       will not change the behavior of this method, which is used to parse wave squad schedules and
       generally represents a public API that must not change.
    5. I have no need for the "friendly-to-player" zed AI names here, and I want to accept the absolute
       minimum universe of correct inputs, so that this is easy to maintain.  Same for "TestHusk".
*/

enum ECDZedNameResolv
{
	ZNR_OK,
	ZNR_INVALID_NAME,
	ZNR_INVALID_SPECIAL,
	ZNR_INVALID_RAGE
};

enum ECDZedGroup
{
	ZG_Clots,
	ZG_Gorefasts,
	ZG_CR_ST,
	ZG_SC,
	ZG_Pounds,
	ZG_Robots,
	ZG_Others
};

enum ECDClassSet
{
	RegularClass,
	SpecialClass,
	RagedClass
};

enum ECDNameLenSet
{
	FullName,
	ShortName,
	TinyName
};

struct RangeStr
{
	var byte min;
	var string val;
};

struct CycleName
{
	var array<string> Names;
	var RangeStr RangeName;
};

struct ZedInfo
{
	var array< class<KFPawn_Monster> >	OG_ZedClasses;
	var array< class<KFPawn_Monster> >	CD_ZedClasses;
	var EAIType							ZedType;
	var EBossAIType						BossType;
	var CycleName						ZedName_Cycle;
	var array<string>					ZedName_Wave;
	var ECDZedGroup						ZedGroup;
	var bool							bAlbino;
};

var array<ZedInfo> ZedInfoArray;

static function bool MatchCycleName(CycleName Target, string ZedName) // ZedName must be Caps() maybe
{
	local int NameLen;

	if(Target.Names.Find(ZedName) != INDEX_NONE)
	{
		return true;
	}

	NameLen = Len(ZedName);
	return Target.RangeName.min <= NameLen && NameLen <= Len(Target.RangeName.val) && ZedName ~= Left(Target.RangeName.val, NameLen);
}

static function ECDZedNameResolv GetZedType(
	/* Input parameters */
	const out string ZedName, const bool IsSpecial, const bool IsRagedOnSpawn,
	/* Output parameters */
	out EAIType ZedType, out class<KFPawn_Monster> ZedClass )
{
	local int i;
	local bool ZedTypeCanBeSpecial, ZedTypeCanBeRaged;
	local string CapZedName;

	ZedClass = None;
	ZedTypeCanBeSpecial = false;
	ZedTypeCanBeRaged = false;
	CapZedName = Caps(ZedName);

	for(i=0; i<default.ZedInfoArray.length; i++)
	{
		if( MatchCycleName(default.ZedInfoArray[i].ZedName_Cycle, CapZedName) )
		{
			ZedType = default.ZedInfoArray[i].ZedType;
			if(default.ZedInfoArray[i].CD_ZedClasses.length == 0)
			{
				ZedClass = default.ZedInfoArray[i].OG_ZedClasses[RegularClass];
			}
			else if(IsSpecial)
			{
				ZedClass = default.ZedInfoArray[i].CD_ZedClasses[SpecialClass];
				ZedTypeCanBeSpecial = true;
			}
			else if(IsRagedOnSpawn)
			{
				ZedClass = default.ZedInfoArray[i].CD_ZedClasses[RagedClass];
				ZedTypeCanBeRaged = true;
			}
			else
			{
				ZedClass = default.ZedInfoArray[i].CD_ZedClasses[RegularClass];
			}
			break;
		}
	}

	if(ZedClass == none)
	{
		return ZNR_INVALID_NAME;
	}

	// Return OK only if this zed type is allowed to be raged/albino

	if ( IsSpecial && !ZedTypeCanBeSpecial )
	{
		return ZNR_INVALID_SPECIAL;
	}

	if ( IsRagedOnSpawn && !ZedTypeCanBeRaged )
	{
		return ZNR_INVALID_RAGE;
	}

	return ZNR_OK;
}

static function GetZedName( const string Verbosity, const AISquadElement SquadElement, out string ZedName )
{
	local int i, j;

	ZedName = "";

	i = default.ZedInfoArray.Find('ZedType', SquadElement.Type);

	//	I suppose this condition for boss zeds doesn't work because SquadElement.Type is always EAIType, not EBossAIType
	if(i == INDEX_NONE)
	{
		for(i=0; i<default.ZedInfoArray.length; i++)
		{
			if(int(SquadElement.Type) == int(default.ZedInfoArray[i].BossType))
				break;
		}
		i = INDEX_NONE;
	}

	if(Verbosity == "full")
	{
		j = 0;
	}
	else if(Verbosity == "tiny")
	{
		j = 2;
	}
	else
	{
		j = 1;
	}

	j = Min(default.ZedInfoArray[i].ZedName_Wave.length-1, j);
	ZedName = default.ZedInfoArray[i].ZedName_Wave[j];
	AppendModifierChars( SquadElement.CustomClass, ZedName );
}

static function class<KFPawn> GetZedClassFromName( string ZedName, bool albino, bool rage, optional bool vs)
{
	local int i;

	ZedName = Caps(ZedName);

	for(i=0; i<default.ZedInfoArray.length; i++)
	{
		if( MatchCycleName(default.ZedInfoArray[i].ZedName_Cycle, ZedName))
		{
			if(vs)
			{
				// This case may be only for Versus Rioter
				if(albino)
				{
					return default.ZedInfoArray[i].OG_ZedClasses[3];
				}
				return default.ZedInfoArray[i].OG_ZedClasses[2];
			}
			if(albino)
			{
				// Albino Stalker and Husk are converted to random EDAR
				if(default.ZedInfoArray[i].OG_ZedClasses[SpecialClass] == class'KFPawn_ZedDAR')
				{
					return RandEDAR();
				}
				// Generally returns original albio class
				return default.ZedInfoArray[i].OG_ZedClasses[SpecialClass];
			}
			if(rage)
			{
				return default.ZedInfoArray[i].CD_ZedClasses[RagedClass];
			}
			if(default.ZedInfoArray[i].CD_ZedClasses.length == 0)
			{
				return default.ZedInfoArray[i].OG_ZedClasses[RegularClass];
			}
			return default.ZedInfoArray[i].CD_ZedClasses[RegularClass];
		}
	}
	return none;
}

static function class<KFPawn> RandEDAR()
{
	local float RandV;
	RandV = FRand();
	if(RandV < 0.33) return class'KFPawn_ZedDAR_EMP';
	else if (RandV >= 0.33 && RandV < 0.66) return class'KFPawn_ZedDAR_Laser';
	else return class'KFPawn_ZedDAR_Rocket';
}

static function AppendModifierChars( const class CustomClass, out string ZedName )
{
	local string s;

	if ( CustomClass != None )
	{
	 	s = Locs( string( CustomClass.name ) );

		if ( Left(s, 7) != "cd_pawn")
		{
			return;
		}

		if ( 0 < InStr( s, "_spec" ) )
		{
			ZedName = ZedName $ "*";
		}

		if ( 0 < InStr( s, "_rs" ) )
		{
			ZedName = ZedName $ "!";
		}
	}
}

static function class CheckClassRemap( const class OrigClass, const string InstigatorName, const bool EnableLogging )
{
	local class<KFPawn_Monster> MonsterClass;

	if ( ClassIsChildOf( OrigClass, class'KFPawn_Monster' ) )
	{
		MonsterClass = class<KFPawn_Monster>( OrigClass );
		return CheckMonsterClassRemap( MonsterClass, InstigatorName, EnableLogging );
	}

	`cdlog("Letting non-monster class "$OrigClass$" stand via "$InstigatorName, EnableLogging );
	return OrigClass;
}

static function class<Pawn> CheckPawnClassRemap( const class<Pawn> OrigClass, const string InstigatorName, const bool EnableLogging )
{
	local class<KFPawn_Monster> MonsterClass;

	if ( ClassIsChildOf( OrigClass, class'KFPawn_Monster' ) )
	{
		MonsterClass = class<KFPawn_Monster>( OrigClass );
		return CheckMonsterClassRemap( MonsterClass, InstigatorName, EnableLogging );
	}

	`cdlog("Letting non-monster class "$OrigClass$" stand via "$InstigatorName, EnableLogging );
	return OrigClass;
}

static function class<KFPawn_Monster> CheckMonsterClassRemap( const class<KFPawn_Monster> OrigClass, const string InstigatorName, const bool EnableLogging )
{
	local class<KFPawn_Monster> NewClass;
	local int i, j;

	NewClass = OrigClass;

	for(i=0; i<default.ZedInfoArray.length; i++)
	{
		j = default.ZedInfoArray[i].CD_ZedClasses.Find(OrigClass);
		if(j != INDEX_NONE)
		{
			// The origins of raged classes are regular classes.
			if(j == RagedClass)
			{
				NewClass = default.ZedInfoArray[i].OG_ZedClasses[RegularClass];
			}
			else
			{
				NewClass = default.ZedInfoArray[i].OG_ZedClasses[j];
				if(NewClass == class'KFPawn_ZedDAR')
				{
					NewClass = class<KFPawn_Monster>( RandEDAR() );
				}
			}
			break;
		}
	}

	// Log what we just did
	if ( OrigClass != NewClass )
	{
		`cdlog("Masked monster class "$OrigClass$" with substitute class "$NewClass$" via "$InstigatorName, EnableLogging );
	}
	else
	{
		`cdlog("Letting monster class "$OrigClass$" stand via "$InstigatorName, EnableLogging );
	}

	return NewClass;
}

defaultproperties
{
	ZedInfoArray.Add((OG_ZedClasses=(class'KFPawn_ZedClot_Cyst'), ZedType=AT_Clot, ZedName_Cycle=(Names=("CLOTC", "CC"), RangeName=(min=2, val="CYST")),	ZedName_Wave=("Cyst", "CY")))
	ZedInfoArray.Add((OG_ZedClasses=(class'KFPawn_ZedClot_Slasher', none, class'KFPawn_ZedClot_Slasher_Versus'),ZedType=AT_SlasherClot,	ZedName_Cycle=(Names=("CLOTS", "CS"), RangeName=(min=2, val="SLASHER")),ZedName_Wave=("Slasher", "SL")))
	ZedInfoArray.Add((OG_ZedClasses=(class'KFPawn_ZedBloat', none, class'KFPawn_ZedBloat_Versus'),				ZedType=AT_Bloat,		ZedName_Cycle=(RangeName=(min=1, val="BLOAT")),	ZedName_Wave=("Bloat", "BL", "B")))
	ZedInfoArray.Add((OG_ZedClasses=(class'KFPawn_ZedSiren', none, class'KFPawn_ZedSiren_Versus'),				ZedType=AT_Siren,		ZedName_Cycle=(RangeName=(min=2, val="SIREN")),	ZedName_Wave=("Siren", "SI")))
	ZedInfoArray.Add((OG_ZedClasses=(class'KFPawn_ZedScrake', none, class'KFPawn_ZedScrake_Versus'),			ZedType=AT_Scrake,		ZedName_Cycle=(RangeName=(min=2, val="SCRAKE")),ZedName_Wave=("Scrake", "SC")))
	ZedInfoArray.Add((OG_ZedClasses=(class'KFPawn_ZedClot_Alpha', class'KFPawn_ZedClot_AlphaKing', class'KFPawn_ZedClot_Alpha_Versus', class'KFPawn_ZedClot_AlphaKing_Versus'),	CD_ZedClasses=(class'CD_Pawn_ZedClot_Alpha_Regular', class'CD_Pawn_ZedClot_Alpha_Special'),	ZedType=AT_AlphaClot,		ZedName_Cycle=(Names=("CLOTA", "CA"), RangeName=(min=2, val="ALPHA")),	ZedName_Wave=("Alpha", "AL")))
	ZedInfoArray.Add((OG_ZedClasses=(class'KFPawn_ZedGorefast', class'KFPawn_ZedGorefastDualBlade', class'KFPawn_ZedGorefast_Versus'),	CD_ZedClasses=(class'CD_Pawn_ZedGorefast_Regular', class'CD_Pawn_ZedGorefast_Special'),	ZedType=AT_GoreFast,ZedName_Cycle=(Names=("G", "GF"), RangeName=(min=1, val="GOREFAST")),	ZedName_Wave=("Gorefast", "GF", "G")))
	ZedInfoArray.Add((OG_ZedClasses=(class'KFPawn_ZedStalker', class'KFPawn_ZedDAR', class'KFPawn_ZedStalker_Versus'),					CD_ZedClasses=(class'CD_Pawn_ZedStalker_Regular', class'CD_Pawn_ZedStalker_Special'),	ZedType=AT_Stalker,	ZedName_Cycle=(RangeName=(min=2, val="STALKER")),	ZedName_Wave=("Stalker", "ST")))
	ZedInfoArray.Add((OG_ZedClasses=(class'KFPawn_ZedCrawler', class'KFPawn_ZedCrawlerKing', class'KFPawn_ZedCrawler_Versus'),			CD_ZedClasses=(class'CD_Pawn_ZedCrawler_Regular', class'CD_Pawn_ZedCrawler_Special'),	ZedType=AT_Crawler,	ZedName_Cycle=(RangeName=(min=2, val="CRAWLER")),	ZedName_Wave=("Crawler", "CR")))
	ZedInfoArray.Add((OG_ZedClasses=(class'KFPawn_ZedHusk', class'KFPawn_ZedDAR', class'KFPawn_ZedHusk_Versus'),						CD_ZedClasses=(class'CD_Pawn_ZedHusk_Regular', class'CD_Pawn_ZedHusk_Special'),			ZedType=AT_Husk,	ZedName_Cycle=(RangeName=(min=1, val="HUSK")),		ZedName_Wave=("Husk", "HU", "H")))
	ZedInfoArray.Add((OG_ZedClasses=(class'KFPawn_ZedFleshpound', none, class'KFPawn_ZedFleshpound_Versus'),	CD_ZedClasses=(class'CD_Pawn_ZedFleshpound_NRS', none, class'CD_Pawn_ZedFleshpound_RS'),			ZedType=AT_FleshPound,		ZedName_Cycle=(Names=("FP"), RangeName=(min=1, val="FLESHPOUND")),				ZedName_Wave=("Fleshpound", "FP", "F")))
	ZedInfoArray.Add((OG_ZedClasses=(class'KFPawn_ZedFleshpoundMini'),CD_ZedClasses=(class'CD_Pawn_ZedFleshpoundMini_NRS', none, class'CD_Pawn_ZedFleshpoundMini_RS'),	ZedType=AT_FleshPoundMini,	ZedName_Cycle=(Names=("MF", "MFP", "QP"), RangeName=(min=2, val="MINIFLESHPOUND")),	ZedName_Wave=("MiniFleshpound", "MF")))
	ZedInfoArray.Add((OG_ZedClasses=(class'KFPawn_ZedDAR_EMP'),		ZedType=AT_EDAR_EMP,	ZedName_Cycle=(Names=("TR", "TRAPPER", "DE"), RangeName=(min=4, val="DAREMP")),		ZedName_Wave=("Trapper", "DE")))
	ZedInfoArray.Add((OG_ZedClasses=(class'KFPawn_ZedDAR_Rocket'),	ZedType=AT_EDAR_Rocket,	ZedName_Cycle=(Names=("BO", "BOOMER", "DR"), RangeName=(min=4, val="DARROCKET")),	ZedName_Wave=("Boomer", "DR")))
	ZedInfoArray.Add((OG_ZedClasses=(class'KFPawn_ZedDAR_Laser'),	ZedType=AT_EDAR_Laser,	ZedName_Cycle=(Names=("BA", "BLASTER", "DL"), RangeName=(min=4, val="DARLASER")),	ZedName_Wave=("Blaster", "DL")))
	ZedInfoArray.Add((OG_ZedClasses=(class'KFPawn_ZedHans', class'KFPawn_ZedHansFriendlyTest', class'KFPawn_ZedHans_Versus'),			BossType=BAT_Hans,			ZedName_Cycle=(Names=("HV"), RangeName=(min=2, val="HANS")),				ZedName_Wave=("Hans", "HANS", "HV")))
	ZedInfoArray.Add((OG_ZedClasses=(class'KFPawn_ZedPatriarch'),		BossType=BAT_Patriarch,		ZedName_Cycle=(Names=("PT"), RangeName=(min=2, val="PATRIARCH")),			ZedName_Wave=("Patriarch", "PAT", "PT")))
	ZedInfoArray.Add((OG_ZedClasses=(class'KFPawn_ZedFleshpoundKing'),	BossType=BAT_KingFleshpound,ZedName_Cycle=(Names=("KF", "KFP"), RangeName=(min=2, val="KINGFP")),		ZedName_Wave=("KingFleshpound", "KFP", "KF")))
	ZedInfoArray.Add((OG_ZedClasses=(class'KFPawn_ZedBloatKing'),		BossType=BAT_KingBloat,		ZedName_Cycle=(Names=("AB", "KB"), RangeName=(min=2, val="ABOMINATION")),	ZedName_Wave=("Abomination", "ABOM", "AB")))
	ZedInfoArray.Add((OG_ZedClasses=(class'KFPawn_ZedMatriarch'),		BossType=BAT_Matriarch,		ZedName_Cycle=(Names=("MT"), RangeName=(min=2, val="MATRIARCH")),			ZedName_Wave=("Matriarch", "MAT", "MT")))
	ZedInfoArray.Add((OG_ZedClasses=(class'KFPawn_ZedBloatKingSubspawn'),							ZedName_Cycle=(Names=("AS", "POO"), RangeName=(min=2, val="ABOMINATIONSPAWN")), ZedName_Wave=("Abomination Spawn", "AS")))
}