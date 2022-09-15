class UTM_PlayerReplicationInfo extends CD_PlayerReplicationInfo
    hidecategories(Navigation,Movement,Collision);

var bool bAutoSpawn;
var int LargeWaveNum;
var int SCKills;
var int FPKills;
var KFPawn PendingZed;

replication
{
    if(bNetDirty)
        bAutoSpawn, LargeWaveNum, SCKills, FPKills, PendingZed;
}