class DynamicLevelColor extends Object
	dependson(Types)
	config(YAS);

`include(Build.uci)
`include(Logger.uci)

var config bool bEnabled;
var config int Normal_Low;
var config int Normal_High;
var config int Hard_Low;
var config int Hard_High;
var config int Suicide_Low;
var config int Suicide_High;
var config int HellOnEarth_Low;
var config int HellOnEarth_High;

public static function YASSettingsLevel DefaultSettings()
{
	local YASSettingsLevel Settings;
	
	`callstack_static("DefaultSettings");
	
	return Settings;
}

public static function YASSettingsLevel Settings()
{
	local YASSettingsLevel Settings;
	
	`callstack_static("Settings");
	
	Settings.Dynamic = default.bEnabled;
	Settings.Low[0] = default.Normal_Low;
	Settings.High[0] = default.Normal_High;
	Settings.Low[1] = default.Hard_Low;
	Settings.High[1] = default.Hard_High;
	Settings.Low[2] = default.Suicide_Low;
	Settings.High[2] = default.Suicide_High;
	Settings.Low[3] = default.HellOnEarth_Low;
	Settings.High[3] = default.HellOnEarth_High;

	return Settings;
}

public static function WriteSettings(YASSettingsLevel Settings)
{
	`callstack_static("WriteSettings");
	
	default.bEnabled = Settings.Dynamic;
	default.Normal_Low = Settings.Low[0];
	default.Normal_High = Settings.High[0];
	default.Hard_Low = Settings.Low[1];
	default.Hard_High = Settings.High[1];
	default.Suicide_Low = Settings.Low[2];
	default.Suicide_High = Settings.High[2];
	default.HellOnEarth_Low = Settings.Low[3];
	default.HellOnEarth_High = Settings.High[3];
	
	StaticSaveConfig();
}

DefaultProperties
{

}