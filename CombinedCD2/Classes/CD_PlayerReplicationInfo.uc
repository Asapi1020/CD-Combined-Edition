class CD_PlayerReplicationInfo extends KFPlayerReplicationInfo;

var int DmgD;
var int AuthorityLevel;
var bool bIsReadyForNextWave;
//var bool bAllReceived;
//var array<string> CycleNames;
var float PlayTimeSeconds;

replication
{
	if(bNetDirty)
		DmgD, AuthorityLevel, bIsReadyForNextWave/*, bAllReceived*/;
}

defaultproperties
{	
	bIsReadyForNextWave=false
	AuthorityLevel=0
}
/*
reliable client simulated function ReceiveCycle(int index, string CycleName)
{
    if(CycleNames.length <= index)
        CycleNames.length = index + 1;

    CycleNames[index] = CycleName;
}
*/