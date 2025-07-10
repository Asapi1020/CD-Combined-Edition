class CD_PlayerReplicationInfo extends KFPlayerReplicationInfo;

var int DmgD;
var int AuthorityLevel;
var bool bIsReadyForNextWave;
var float PlayTimeSeconds;

replication
{
	if(bNetDirty)
		DmgD, AuthorityLevel, bIsReadyForNextWave;
}

defaultproperties
{	
	bIsReadyForNextWave=false
	AuthorityLevel=0
}
