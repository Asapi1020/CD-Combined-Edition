class DynamicStateColor extends Object
	dependson(Types)
	config(YAS);

`include(Build.uci)
`include(Logger.uci)

var config bool bEnabled;
var config int Low;
var config int High;

public static function YASSettingsState DefaultSettings()
{
	local YASSettingsState Settings;
	
	`callstack_static("DefaultSettings");
	
	return Settings;
}

public static function YASSettingsState Settings()
{
	local YASSettingsState Settings;
	
	`callstack_static("Settings");
	
	Settings.Dynamic = default.bEnabled;
	Settings.Low = default.Low;
	Settings.High = default.High;
	
	return Settings;
}

public static function WriteSettings(YASSettingsState Settings)
{
	`callstack_static("WriteSettings");
	
	default.bEnabled = Settings.Dynamic;
	default.Low = Settings.Low;
	default.High = Settings.High;
	
	StaticSaveConfig();
}

DefaultProperties
{

}