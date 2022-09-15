class DynamicPingColor extends Object
	dependson(Types)
	config(YAS);

`include(Build.uci)
`include(Logger.uci)

var config bool bEnabled;
var config int Low;
var config int High;
var config bool bShowPingBars;

public static function YASSettingsPing DefaultSettings()
{
	local YASSettingsPing Settings;
	
	`callstack_static("DefaultSettings");
	
	return Settings;
}

public static function YASSettingsPing Settings()
{
	local YASSettingsPing Settings;
	
	`callstack_static("Settings");
	
	Settings.Dynamic = default.bEnabled;
	Settings.Low = default.Low;
	Settings.High = default.High;
	Settings.ShowPingBars = default.bShowPingBars;
	
	return Settings;
}

public static function WriteSettings(YASSettingsPing Settings)
{
	`callstack_static("WriteSettings");
	
	default.bEnabled = Settings.Dynamic;
	default.Low = Settings.Low;
	default.High = Settings.High;
	default.bShowPingBars = Settings.ShowPingBars;
	
	StaticSaveConfig();
}

DefaultProperties
{

}