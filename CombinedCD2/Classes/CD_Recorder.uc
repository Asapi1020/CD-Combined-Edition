class CD_Recorder extends Info
	config( CombinedCD );

var config array<string> CDRecords;
var config int MaxStrage;
var config int IniVer;

function PostBeginPlay()
{
	local int i;

	super.PostBeginPlay();

	InitConfig();

	if(CDRecords.length == MaxStrage)
		CDRecords.RemoveItem(CDRecords[0]);

	else if(CDRecords.length > MaxStrage)
	{
		for(i=0; i<CDRecords.length-MaxStrage; i++)
			CDRecords.RemoveItem(CDRecords[0]);
	}

	SaveConfig();
}

function RegisterRecord(string Record)
{
	CDRecords.AddItem(Record);
	SaveConfig();
}

function InitConfig()
{
	if(IniVer < 1)
	{
		MaxStrage=30;
		IniVer=1;
	}
}