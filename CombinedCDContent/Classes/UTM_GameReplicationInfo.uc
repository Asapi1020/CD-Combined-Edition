class UTM_GameReplicationInfo extends CD_GameReplicationInfo
    config(Game)
    hidecategories(Navigation,Movement,Collision);

var int nFakedPlayers;
var int nMonsters;
var bool bDisableZedTime;
var bool bSpawnRaged;
var bool bDisableRobots;
var bool bLargeLess;
var bool bHSOnly;
var bool bTrashChallenge;

replication
{
    if((Role == ROLE_Authority) && bNetDirty)
        nMonsters, nFakedPlayers, bDisableZedTime, bSpawnRaged, bDisableRobots, bLargeLess, bHSOnly, bTrashChallenge;
}

simulated function OpenAllTraders()
{
    local KFTraderTrigger KFTrader;

    foreach DynamicActors(class'KFTraderTrigger', KFTrader)
    {
        OpenedTrader = KFTrader;
        KFTrader.OpenTrader();        
    }
}

simulated function ForceNewMusicTrack(KFMusicTrackInfo ForcedTrackInfo)
{

}

simulated function bool ShouldSetBossCamOnBossSpawn()
{
    return false;
}

simulated function bool ShouldSetBossCamOnBossDeath()
{
    return false;
}

simulated event bool CanChangePerks()
{
    return true;
}
