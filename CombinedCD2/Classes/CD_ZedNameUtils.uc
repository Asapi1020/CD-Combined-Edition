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

struct ZedInfo
{
	var class<KFPawn_Monster> 		   OG_ZedClass;
	var array< class<KFPawn_Monster> > CD_ZedClasses;
	var EAIType						   ZedType;
	var EBossAIType					   BossType;
	var array<string>				   ZedName_Cycle;
	var array<string>				   ZedName_Wave;
	var ECDZedGroup					   ZedGroup;
	var bool						   bAlbino;
};

var array<ZedInfo> ZedInfoArray;

static function ECDZedNameResolv GetZedType(
	/* Input parameters */
	const out string ZedName, const bool IsSpecial, const bool IsRagedOnSpawn,
	/* Output parameters */
	out EAIType ZedType, out class<KFPawn_Monster> ZedClass )
{
	local int ZedLen;
	local bool ZedTypeCanBeSpecial, ZedTypeCanBeRaged;

	ZedLen = Len( ZedName );
	ZedClass = None;
	ZedTypeCanBeSpecial = false;
	ZedTypeCanBeRaged = false;
	
	if ( ZedName ~= "CLOTA" || ZedName ~= "CA" || (2 <= ZedLen && ZedLen <= 5 && ZedName ~= Left("ALPHA", ZedLen)) )
	{
		ZedType = AT_AlphaClot;
		ZedClass = IsSpecial ?
			class'CD_Pawn_ZedClot_Alpha_Special' :
			class'CD_Pawn_ZedClot_Alpha_Regular' ;
		ZedTypeCanBeSpecial = true;
	}
	else if ( ZedName ~= "CLOTS" || ZedName ~= "CS" || (2 <= ZedLen && ZedLen <= 7 && ZedName ~= Left("SLASHER", ZedLen)) )
	{
		ZedType = AT_SlasherClot;
		ZedClass = class'KFGameContent.KFPawn_ZedClot_Slasher';
	}
	else if ( ZedName ~= "CLOTC" || ZedName ~= "CC" || (2 <= ZedLen && ZedLen <= 4 && ZedName ~= Left("CYST", ZedLen)) )
	{
		ZedType = AT_Clot;
		ZedClass = class'KFGameContent.KFPawn_ZedClot_Cyst';
	}
	else if ( ZedName ~= "FP" || (1 <= ZedLen && ZedLen <= 10 && ZedName ~= Left("FLESHPOUND", ZedLen)) )
	{
		ZedType = AT_FleshPound;
		ZedClass = IsRagedOnSpawn ?
			class'CD_Pawn_ZedFleshpound_RS' :
			class'CD_Pawn_ZedFleshpound_NRS' ;
		ZedTypeCanBeRaged = true;
	}
	else if ( ZedName ~= "MF" || ZedName ~= "MFP" || (2 <= ZedLen && ZedLen <= 14 && ZedName ~= Left("MINIFLESHPOUND", ZedLen)) )
	{
		ZedType = AT_FleshpoundMini;
		ZedClass = IsRagedOnSpawn ?
			class'CD_Pawn_ZedFleshpoundMini_RS' :
			class'CD_Pawn_ZedFleshpoundMini_NRS' ;
		ZedTypeCanBeRaged = true;
	}
	else if ( ZedName ~= "G" || ZedName ~= "GF" || (1 <= ZedLen && ZedLen <= 8 && ZedName ~= Left("GOREFAST", ZedLen)) )
	{
		ZedType = AT_GoreFast;
		ZedClass = IsSpecial ?
			class'CD_Pawn_ZedGorefast_Special' :
			class'CD_Pawn_ZedGorefast_Regular' ;
		ZedTypeCanBeSpecial = true;
	}
	else if ( 2 <= ZedLen && ZedLen <= 7 && ZedName ~= Left("STALKER", ZedLen) )
	{
		ZedType = AT_Stalker;
		ZedClass = IsSpecial ?
			class'CD_Pawn_ZedStalker_Special' :
			class'CD_Pawn_ZedStalker_Regular' ;
		ZedTypeCanBeSpecial = true;
	}
	else if ( 1 <= ZedLen && ZedLen <= 5 && ZedName ~= Left("BLOAT", ZedLen) )
	{
		ZedType = AT_Bloat;
		ZedClass = class'KFGameContent.KFPawn_ZedBloat';
	}
	else if ( 2 <= ZedLen && ZedLen <= 6 && ZedName ~= Left("SCRAKE", ZedLen) )
	{
		ZedType = AT_Scrake;
		ZedClass = class'KFGameContent.KFPawn_ZedScrake';
	}
	else if ( 2 <= ZedLen && ZedLen <= 7 && ZedName ~= Left("CRAWLER", ZedLen) )
	{
		ZedType = AT_Crawler;
		ZedClass = IsSpecial ?
			class'CD_Pawn_ZedCrawler_Special' :
			class'CD_Pawn_ZedCrawler_Regular' ;
		ZedTypeCanBeSpecial = true;
	}
	else if ( 1 <= ZedLen && ZedLen <= 4 && ZedName ~= Left("HUSK", ZedLen) )
	{
		ZedType = AT_Husk;
		ZedClass = IsSpecial ?
			class'CD_Pawn_ZedHusk_Special' :
			class'CD_Pawn_ZedHusk_Regular' ;
		ZedTypeCanBeSpecial = true;
	}
	else if ( 2 <= ZedLen && ZedLen <= 5 && ZedName ~= Left("SIREN", ZedLen) )
	{
		ZedType = AT_Siren;
		ZedClass = class'KFGameContent.KFPawn_ZedSiren';
	}
	else if ( ZedName ~= "TR" || ZedName ~= "Trapper" || ZedName ~= "DE" || 4 <= ZedLen && ZedLen <= 6 && ZedName ~= Left("DAREMP", ZedLen) )
    {
		ZedType = AT_EDAR_EMP;
        ZedClass = class'KFPawn_ZedDAR_EMP';
    }
    else if ( ZedName ~= "BO" || ZedName ~= "Boomer" || ZedName ~= "DR" || 4 <= ZedLen && ZedLen <= 9 && ZedName ~= Left("DARROCKET", ZedLen) )
    {
		ZedType = AT_EDAR_Rocket;
        ZedClass = class'KFPawn_ZedDAR_Rocket';
    }
    else if ( ZedName ~= "BA" || ZedName ~= "Blaster" || ZedName ~= "DL" || 4 <= ZedLen && ZedLen <= 8 && ZedName ~= Left("DARLASER", ZedLen) )
    {
		ZedType = AT_EDAR_Laser;
        ZedClass = class'KFPawn_ZedDAR_Laser';
    }
    else if ( ZedName ~= "HV" || ZedName ~= "Hans" || (2<= ZedLen && ZedLen <= 4 && ZedName ~= Left("HANS", ZedLen))){
    	//ZedType = BAT_Hans;
    	ZedClass = class'KFPawn_ZedHans';
    }
    else if ( ZedName ~= "PT" || ZedName ~= "Pat" || (2<= ZedLen && ZedLen <= 9 && ZedName ~= Left("PATRIARCH", ZedLen))){
    	//ZedType = BAT_Patriarch;
    	ZedClass = class'KFPawn_ZedPatriarch';
    }
    else if ( ZedName ~= "KF" || ZedName ~= "KFP" || (2<= ZedLen && ZedLen <= 6 && ZedName ~= Left("KINGFP", ZedLen))){
    	//ZedType = BAT_KingFleshpound;
    	ZedClass = class'KFPawn_ZedFleshpoundKing';
    }
    else if ( ZedName ~= "AB" || ZedName ~= "Abom" || (2<= ZedLen && ZedLen <= 11 && ZedName ~= Left("ABOMINATION", ZedLen))){
    	//BossType = BAT_KingBloat;
    	ZedClass = class'KFPawn_ZedBloatKing';
    }
    else if ( ZedName ~= "MT" || ZedName ~= "Mat" || (2<= ZedLen && ZedLen <= 9 && ZedName ~= Left("MATRIARCH", ZedLen))){
    	//BossType = BAT_Matriarch;
    	ZedClass = class'KFPawn_ZedMatriarch';
    }
    else if ( ZedName ~= "AS" || ZedName ~= "Poo" || (2<= ZedLen && ZedLen <= 16 && ZedName ~= Left("ABOMINATIONSPAWN", ZedLen))){
    	//ZedType = 
    	ZedClass = class'KFPawn_ZedBloatKingSubspawn';
    }
/*
    else if ( ZedName ~= "OSC" || (3<= ZedLen && ZedLen <= 11 && ZedName ~= Left("SCRAKEOMEGA", ZedLen))){
    	//ZedType = 
    	ZedClass = GetOmega("Scrake_Omega");
    }
    else if ( ZedName ~= "OFP" || (3<= ZedLen && ZedLen <= 15 && ZedName ~= Left("FLESHPOUNDOMEGA", ZedLen))){
    	//ZedType = 
    	ZedClass = GetOmega("Fleshpound_Omega");
    }
    else if ( ZedName ~= "OSL" ){
    	//ZedType = 
    	ZedClass = GetOmega("Clot_Slasher_Omega");
    }
    else if ( ZedName ~= "OGF" ){
    	//ZedType = 
    	ZedClass = GetOmega("Gorefast_Omega");
    }
    else if ( ZedName ~= "OST" ){
    	//ZedType = 
    	ZedClass = GetOmega("Stalker_Omega");
    }
    else if ( ZedName ~= "OSI" ){
    	//ZedType = 
    	ZedClass = GetOmega("Siren_Omega");
    }
    else if ( ZedName ~= "OHU" ){
    	//ZedType = 
    	ZedClass = GetOmega("Husk_Omega");
    }
*/
	else
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

static function class<KFPawn_Monster> GetOmega(string Path)
{
	return class<KFPawn_Monster>( DynamicLoadObject("ZedternalJP.WMPawn_Zed" $ Path, class'Class') );
}

static function GetZedFullName( const AISquadElement SquadElement, out string ZedName )
{
	ZedName = "";

	if ( SquadElement.Type == AT_AlphaClot )
	{
		ZedName = "Alpha";
	}
	else if ( SquadElement.Type == AT_SlasherClot )
	{
		ZedName = "Slasher";
	}
	else if ( SquadElement.Type == AT_Clot ) 
	{
		ZedName = "Cyst";
	}
	else if ( SquadElement.Type == AT_FleshPound )
	{
		ZedName = "Fleshpound";
	}
	else if ( SquadElement.Type == AT_FleshpoundMini )
	{
		ZedName = "MiniFleshpound";
	}
	else if ( SquadElement.Type == AT_Gorefast )
	{
		ZedName = "Gorefast";
	}
	else if ( SquadElement.Type == AT_Stalker )
	{
		ZedName = "Stalker";
	}
	else if ( SquadElement.Type == AT_Bloat )
	{
		ZedName = "Bloat";
	}
	else if ( SquadElement.Type == AT_Scrake )
	{
		ZedName = "Scrake";
	}
	else if ( SquadElement.Type == AT_Crawler )
	{
		ZedName = "Crawler";
	}
	else if ( SquadElement.Type == AT_Husk )
	{
		ZedName = "Husk";
	}
	else if ( SquadElement.Type == AT_Siren )
	{
		ZedName = "Siren";
	}
	else if ( SquadElement.Type == AT_EDAR_EMP )
    {
        ZedName = "Trapper";
    }
    else if ( SquadElement.Type == AT_EDAR_Rocket )
    {
        ZedName = "Boomer";
    }
    else if ( SquadElement.Type == AT_EDAR_Laser )
    {
        ZedName = "Blaster";
    }
    else if ( SquadElement.Type == BAT_Patriarch )
    {
        ZedName = "Patriarch";
    }
    else if ( SquadElement.Type == BAT_Hans )
    {
        ZedName = "Hans";
    }
    else if ( SquadElement.Type == BAT_KingFleshpound )
    {
        ZedName = "KingFleshpound";
    }
    else if ( SquadElement.Type == BAT_KingBloat )
    {
        ZedName = "Abomination";
    }
    else if ( SquadElement.Type == BAT_Matriarch )
    {
        ZedName = "Matriarch";
    }

	AppendModifierChars( SquadElement.CustomClass, ZedName );
}

static function GetZedTinyName( const AISquadElement SquadElement, out string ZedName )
{
	ZedName = "";

	if ( SquadElement.Type == AT_AlphaClot )
	{
		ZedName = "AL";
	}
	else if ( SquadElement.Type == AT_SlasherClot )
	{
		ZedName = "SL";
	}
	else if ( SquadElement.Type == AT_Clot ) 
	{
		ZedName = "CY";
	}
	else if ( SquadElement.Type == AT_FleshPound )
	{
		ZedName = "F";
	}
	else if ( SquadElement.Type == AT_FleshpoundMini )
	{
		ZedName = "MF";
	}
	else if ( SquadElement.Type == AT_Gorefast )
	{
		ZedName = "G";
	}
	else if ( SquadElement.Type == AT_Stalker )
	{
		ZedName = "ST";
	}
	else if ( SquadElement.Type == AT_Bloat )
	{
		ZedName = "B";
	}
	else if ( SquadElement.Type == AT_Scrake )
	{
		ZedName = "SC";
	}
	else if ( SquadElement.Type == AT_Crawler )
	{
		ZedName = "CR";
	}
	else if ( SquadElement.Type == AT_Husk )
	{
		ZedName = "H";
	}
	else if ( SquadElement.Type == AT_Siren )
	{
		ZedName = "SI";
	}
	else if (  SquadElement.Type == AT_EDAR_EMP  )
    {
        ZedName = "DE";
    }
    else if (  SquadElement.Type == AT_EDAR_Rocket  )
    {
        ZedName = "DR";
    }
    else if (  SquadElement.Type == AT_EDAR_Laser  )
    {
        ZedName = "DL";
    }
    else if ( SquadElement.Type == BAT_Patriarch )
    {
        ZedName = "PT";
    }
    else if ( SquadElement.Type == BAT_Hans )
    {
        ZedName = "HV";
    }
    else if ( SquadElement.Type == BAT_KingFleshpound )
    {
        ZedName = "KF";
    }
    else if ( SquadElement.Type == BAT_KingBloat )
    {
        ZedName = "AB";
    }
    else if ( SquadElement.Type == BAT_Matriarch )
    {
        ZedName = "MT";
    }

	AppendModifierChars( SquadElement.CustomClass, ZedName );
}

static function GetZedShortName( const AISquadElement SquadElement, out string ZedName )
{
	ZedName = "";

	if ( SquadElement.Type == AT_AlphaClot )
	{
		ZedName = "AL";
	}
	else if ( SquadElement.Type == AT_SlasherClot )
	{
		ZedName = "SL";
	}
	else if ( SquadElement.Type == AT_Clot ) 
	{
		ZedName = "CY";
	}
	else if ( SquadElement.Type == AT_FleshPound )
	{
		ZedName = "FP";
	}
	else if ( SquadElement.Type == AT_FleshpoundMini )
	{
		ZedName = "MF";
	}
	else if ( SquadElement.Type == AT_Gorefast )
	{
		ZedName = "GF";
	}
	else if ( SquadElement.Type == AT_Stalker )
	{
		ZedName = "ST";
	}
	else if ( SquadElement.Type == AT_Bloat )
	{
		ZedName = "BL";
	}
	else if ( SquadElement.Type == AT_Scrake )
	{
		ZedName = "SC";
	}
	else if ( SquadElement.Type == AT_Crawler )
	{
		ZedName = "CR";
	}
	else if ( SquadElement.Type == AT_Husk )
	{
		ZedName = "HU";
	}
	else if ( SquadElement.Type == AT_Siren )
	{
		ZedName = "SI";
	}
	else if ( SquadElement.Type == AT_EDAR_EMP )
    {
        ZedName = "TR";
    }
    else if ( SquadElement.Type == AT_EDAR_Rocket )
    {
        ZedName = "BO";
    }
    else if ( SquadElement.Type == AT_EDAR_Laser )
    {
        ZedName = "BA";
    }
    else if ( SquadElement.Type == BAT_Patriarch )
    {
        ZedName = "PAT";
    }
    else if ( SquadElement.Type == BAT_Hans )
    {
        ZedName = "HANS";
    }
    else if ( SquadElement.Type == BAT_KingFleshpound )
    {
        ZedName = "KFP";
    }
    else if ( SquadElement.Type == BAT_KingBloat )
    {
        ZedName = "ABOM";
    }
    else if ( SquadElement.Type == BAT_Matriarch )
    {
        ZedName = "MAT";
    }

	AppendModifierChars( SquadElement.CustomClass, ZedName );
}

static function class<KFPawn> GetZedClassFromName( string ZedName, bool albino, bool rage)
{
	if ( ZedName ~= "AL" )
	{
		if(albino) return class'KFPawn_ZedClot_AlphaKing';
		else return class'CD_Pawn_ZedClot_Alpha_Regular';

	}
	else if ( ZedName ~= "SL" )
	{
		return class'KFPawn_ZedClot_Slasher';
	}
	else if ( ZedName ~= "CY" ) 
	{
		return class'KFPawn_ZedClot_Cyst';
	}
	else if ( ZedName ~= "FP" )
	{
		if(rage) return class'CD_Pawn_ZedFleshpound_RS';
		else return class'CD_Pawn_ZedFleshpound_NRS';
	}
	else if ( ZedName ~= "MF" || ZedName ~="QP")
	{
		if(rage) return class'CD_Pawn_ZedFleshpoundMini_RS';
		else return class'CD_Pawn_ZedFleshpoundMini_NRS';
	}
	else if ( ZedName ~= "GF" )
	{
		if(albino) return class'KFPawn_ZedGorefastDualBlade';
		else return class'CD_Pawn_ZedGorefast_Regular';
	}
	else if ( ZedName ~= "ST" )
	{
		if(albino) return RandEDAR();
		else return class'CD_Pawn_ZedStalker_Regular';
	}
	else if ( ZedName ~= "BL" )
	{
		return class'KFPawn_ZedBloat';
	}
	else if ( ZedName ~= "SC" )
	{
		return class'KFPawn_ZedScrake';
	}
	else if ( ZedName ~= "CR" )
	{
		if(albino) return class'KFPawn_ZedCrawlerKing';
		else return class'CD_Pawn_ZedCrawler_Regular';
	}
	else if ( ZedName ~= "HU" )
	{
		if(albino) return RandEDAR();
		else return class'CD_Pawn_ZedHusk_Regular';
	}
	else if ( ZedName ~= "SI" )
	{
		return class'KFPawn_ZedSiren';
	}
	else if ( ZedName ~= "TR" || ZedName ~= "DE" )
    {
        return class'KFPawn_ZedDAR_EMP';
    }
    else if ( ZedName ~= "BO" || ZedName ~= "DR" )
    {
        return class'KFPawn_ZedDAR_Rocket';
    }
    else if ( ZedName ~= "BA" || ZedName ~= "DL" )
    {
        return class'KFPawn_ZedDAR_Laser';
    }
    else if ( ZedName ~= "AS" || ZedName ~= "POO" ){
    	return class'KFPawn_ZedBloatKingSubspawn';
    }
    else if ( ZedName ~= "HV" || ZedName ~= "HANS" ){
    	return class'KFPawn_ZedHans';
    }
    else if ( ZedName ~= "PAT"){
    	return class'KFPawn_ZedPatriarch';
    }
    else if ( ZedName ~= "KFP"){
    	return class'KFPawn_ZedFleshpoundKing';
    }
    else if ( ZedName ~= "ABOM" || ZedName ~= "KB"){
    	return class'KFPawn_ZedBloatKing';
    }
    else if ( ZedName ~= "MAT"){
    	return class'KFPawn_ZedMatriarch';
    }

    else if ( ZedName ~= "VSBL" )
    {
    	return class'KFPawn_ZedBloat_Versus';
    }
    else if ( ZedName ~= "VSAL" )
    {
    	if(albino) return class'KFPawn_ZedClot_AlphaKing_Versus';
    	else return class'KFPawn_ZedClot_Alpha_Versus';
    }
    else if ( ZedName ~= "VSSL" )
    {
    	return class'KFPawn_ZedClot_Slasher_Versus';
    }
    else if ( ZedName ~= "VSCR" )
    {
    	return class'KFPawn_ZedCrawler_Versus';
    }
    else if ( ZedName ~= "VSFP")
    {
    	return class'KFPawn_ZedFleshpound_Versus';
    }
    else if ( ZedName ~= "VSGF" )
    {
    	return class'KFPawn_ZedGorefast_Versus';
    }
    else if ( ZedName ~= "VSHU" )
    {
    	return class'KFPawn_ZedHusk_Versus';
    }
    else if ( ZedName ~= "VSSC" )
    {
    	return class'KFPawn_ZedScrake_Versus';
    }
    else if ( ZedName ~= "VSSI" )
    {
    	return class'KFPawn_ZedSiren_Versus';
    }
    else if ( ZedName ~= "VSST" )
    {
    	return class'KFPawn_ZedStalker_Versus';
    }

    else{
    	return none;
    }
}

static function class<KFPawn> RandEDAR(){
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

	NewClass = OrigClass;

	if ( OrigClass == class'CD_Pawn_ZedCrawler_Regular' )
	{
		NewClass = class'KFPawn_ZedCrawler';
	}
	else if ( OrigClass == class'CD_Pawn_ZedCrawler_Special')
	{
		NewClass = class'KFPawn_ZedCrawlerKing';
	}
	else if ( OrigClass == class'CD_Pawn_ZedClot_Alpha_Regular' )
	{
		NewClass = class'KFPawn_ZedClot_Alpha';
	}
	else if ( OrigClass == class'CD_Pawn_ZedClot_Alpha_Special' )
	{
		NewClass = class'KFPawn_ZedClot_AlphaKing';
	}
	else if ( OrigClass == class'CD_Pawn_ZedGorefast_Regular' )
	{
		NewClass = class'KFPawn_ZedGorefast';
	}
	else if ( OrigClass == class'CD_Pawn_ZedGorefast_Special' )
	{
		NewClass = class'KFPawn_ZedGorefastDualBlade';
	}
	else if ( OrigClass == class'CD_Pawn_ZedStalker_Special' ||
	          OrigClass == class'CD_Pawn_ZedStalker_Regular' )
	{
		NewClass = class'KFPawn_ZedStalker';
	}
	else if ( OrigClass == class'CD_Pawn_ZedHusk_Special' ||
	          OrigClass == class'CD_Pawn_ZedHusk_Regular' )
	{
		NewClass = class'KFPawn_ZedHusk';
	}
	else if ( OrigClass == class'CD_Pawn_ZedFleshpound_NRS' ||
	          OrigClass == class'CD_Pawn_ZedFleshpound_RS' )
	{
		NewClass = class'KFPawn_ZedFleshpound';
	}
	else if ( OrigClass == class'CD_Pawn_ZedFleshpoundMini_NRS' ||
	          OrigClass == class'CD_Pawn_ZedFleshpoundMini_RS' )
	{
		NewClass = class'KFPawn_ZedFleshpoundMini';
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
	ZedInfoArray.Add((OG_ZedClass=class'KFPawn_ZedClot_Cyst', ZedType=AT_Clot, ZedName_Cycle=("CLOTC", "CC", "CY", "CYS", "CYST")))
}