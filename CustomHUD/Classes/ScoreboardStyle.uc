class ScoreboardStyle extends Object
	dependson(Types)
	config(YAS);

`include(Build.uci)
`include(Logger.uci)

var config int       EdgeSize;
var config int       ShapeServerNameBox;
var config int       ShapeGameInfoBox;
var config int       ShapeWaveInfoBox;
var config int       ShapePlayersCountBox;
var config int       ShapeHeaderBox;
var config int       ShapeLeftStateBoxTopPlayer;
var config int       ShapeLeftStateBoxMidPlayer;
var config int       ShapeLeftStateBoxBottomPlayer;
var config int       ShapePlayerBoxTopPlayer;
var config int       ShapePlayerBoxMidPlayer;
var config int       ShapePlayerBoxBottomPlayer;
var config int       ShapeStatsBoxTopPlayer;
var config int       ShapeStatsBoxMidPlayer;
var config int       ShapeStatsBoxBottomPlayer;
var config ColorRGBA ServerNameBoxColor;
var config ColorRGBA ServerNameTextColor;
var config ColorRGBA GameInfoBoxColor;
var config ColorRGBA GameInfoTextColor;
var config ColorRGBA WaveBoxColor;
var config ColorRGBA WaveTextColor;
var config ColorRGBA PlayerCountBoxColor;
var config ColorRGBA PlayerCountTextColor;
var config ColorRGBA ListHeaderBoxColor;
var config ColorRGBA ListHeaderTextColor;
var config ColorRGBA LeftStateBoxColor;
var config ColorRGBA LeftStateBoxColorDead;
var config ColorRGBA LeftStateBoxColorLow;
var config ColorRGBA LeftStateBoxColorMid;
var config ColorRGBA LeftStateBoxColorHigh;
var config ColorRGBA PlayerOwnerBoxColor;
var config ColorRGBA PlayerBoxColor;
var config ColorRGBA StatsBoxColor;
var config ColorRGBA RankTextColor;
var config ColorRGBA ZedTextColor;
var config ColorRGBA PerkTextColor;
var config ColorRGBA LevelTextColor;
var config ColorRGBA PlayerNameTextColor;
var config ColorRGBA KillsTextColor;
var config ColorRGBA AssistsTextColor;
var config ColorRGBA DoshTextColor;
var config ColorRGBA StateTextColorLobby;
var config ColorRGBA StateTextColorReady;
var config ColorRGBA StateTextColorNotReady;
var config ColorRGBA StateTextColor;
var config ColorRGBA StateTextColorSpectator;
var config ColorRGBA StateTextColorDead;
var config ColorRGBA StateTextColorLowHP;
var config ColorRGBA StateTextColorMidHP;
var config ColorRGBA StateTextColorHighHP;
var config ColorRGBA PingTextColor;
var config ColorRGBA PingTextColorLow;
var config ColorRGBA PingTextColorMid;
var config ColorRGBA PingTextColorHigh;

public static function YASStyle DefaultSettings()
{
	local YASStyle Settings;
	
	`callstack_static("DefaultSettings");
	
	return Settings;
}

public static function YASStyle Settings()
{
	local YASStyle Settings;
	
	`callstack_static("Settings");
	
	Settings.EdgeSize = default.EdgeSize;
	Settings.ShapeServerNameBox = default.ShapeServerNameBox;
	Settings.ShapeGameInfoBox = default.ShapeGameInfoBox;
	Settings.ShapeWaveInfoBox = default.ShapeWaveInfoBox;
	Settings.ShapePlayersCountBox = default.ShapePlayersCountBox;
	Settings.ShapeHeaderBox = default.ShapeHeaderBox;
	Settings.ShapeLeftStateBoxTopPlayer = default.ShapeLeftStateBoxTopPlayer;
	Settings.ShapeLeftStateBoxMidPlayer = default.ShapeLeftStateBoxMidPlayer;
	Settings.ShapeLeftStateBoxBottomPlayer = default.ShapeLeftStateBoxBottomPlayer;
	Settings.ShapePlayerBoxTopPlayer = default.ShapePlayerBoxTopPlayer;
	Settings.ShapePlayerBoxMidPlayer = default.ShapePlayerBoxMidPlayer;
	Settings.ShapePlayerBoxBottomPlayer = default.ShapePlayerBoxBottomPlayer;
	Settings.ShapeStatsBoxTopPlayer = default.ShapeStatsBoxTopPlayer;
	Settings.ShapeStatsBoxMidPlayer = default.ShapeStatsBoxMidPlayer;
	Settings.ShapeStatsBoxBottomPlayer = default.ShapeStatsBoxBottomPlayer;
	Settings.ServerNameBoxColor = default.ServerNameBoxColor;
	Settings.ServerNameTextColor = default.ServerNameTextColor;
	Settings.GameInfoBoxColor = default.GameInfoBoxColor;
	Settings.GameInfoTextColor = default.GameInfoTextColor;
	Settings.WaveBoxColor = default.WaveBoxColor;
	Settings.WaveTextColor = default.WaveTextColor;
	Settings.PlayerCountBoxColor = default.PlayerCountBoxColor;
	Settings.PlayerCountTextColor = default.PlayerCountTextColor;
	Settings.ListHeaderBoxColor = default.ListHeaderBoxColor;
	Settings.ListHeaderTextColor = default.ListHeaderTextColor;
	Settings.LeftStateBoxColor = default.LeftStateBoxColor;
	Settings.LeftStateBoxColorDead = default.LeftStateBoxColorDead;
	Settings.LeftStateBoxColorLow = default.LeftStateBoxColorLow;
	Settings.LeftStateBoxColorMid = default.LeftStateBoxColorMid;
	Settings.LeftStateBoxColorHigh = default.LeftStateBoxColorHigh;
	Settings.PlayerOwnerBoxColor = default.PlayerOwnerBoxColor;
	Settings.PlayerBoxColor = default.PlayerBoxColor;
	Settings.StatsBoxColor = default.StatsBoxColor;
	Settings.RankTextColor = default.RankTextColor;
	Settings.ZedTextColor = default.ZedTextColor;
	Settings.PerkTextColor = default.PerkTextColor;
	Settings.LevelTextColor = default.LevelTextColor;
	Settings.PlayerNameTextColor = default.PlayerNameTextColor;
	Settings.KillsTextColor = default.KillsTextColor;
	Settings.AssistsTextColor = default.AssistsTextColor;
	Settings.DoshTextColor = default.DoshTextColor;
	Settings.StateTextColorLobby = default.StateTextColorLobby;
	Settings.StateTextColorReady = default.StateTextColorReady;
	Settings.StateTextColorNotReady = default.StateTextColorNotReady;
	Settings.StateTextColor = default.StateTextColor;
	Settings.StateTextColorSpectator = default.StateTextColorSpectator;
	Settings.StateTextColorDead = default.StateTextColorDead;
	Settings.StateTextColorLowHP = default.StateTextColorLowHP;
	Settings.StateTextColorMidHP = default.StateTextColorMidHP;
	Settings.StateTextColorHighHP = default.StateTextColorHighHP;
	Settings.PingTextColor = default.PingTextColor;
	Settings.PingTextColorLow = default.PingTextColorLow;
	Settings.PingTextColorMid = default.PingTextColorMid;
	Settings.PingTextColorHigh = default.PingTextColorHigh;

	return Settings;
}

public static function WriteSettings(YASStyle Settings)
{
	`callstack_static("WriteSettings");
	
	default.EdgeSize = Settings.EdgeSize;
	default.ShapeServerNameBox = Settings.ShapeServerNameBox;
	default.ShapeGameInfoBox = Settings.ShapeGameInfoBox;
	default.ShapeWaveInfoBox = Settings.ShapeWaveInfoBox;
	default.ShapePlayersCountBox = Settings.ShapePlayersCountBox;
	default.ShapeHeaderBox = Settings.ShapeHeaderBox;
	default.ShapeLeftStateBoxTopPlayer = Settings.ShapeLeftStateBoxTopPlayer;
	default.ShapeLeftStateBoxMidPlayer = Settings.ShapeLeftStateBoxMidPlayer;
	default.ShapeLeftStateBoxBottomPlayer = Settings.ShapeLeftStateBoxBottomPlayer;
	default.ShapePlayerBoxTopPlayer = Settings.ShapePlayerBoxTopPlayer;
	default.ShapePlayerBoxMidPlayer = Settings.ShapePlayerBoxMidPlayer;
	default.ShapePlayerBoxBottomPlayer = Settings.ShapePlayerBoxBottomPlayer;
	default.ShapeStatsBoxTopPlayer = Settings.ShapeStatsBoxTopPlayer;
	default.ShapeStatsBoxMidPlayer = Settings.ShapeStatsBoxMidPlayer;
	default.ShapeStatsBoxBottomPlayer = Settings.ShapeStatsBoxBottomPlayer;
	default.ServerNameBoxColor = Settings.ServerNameBoxColor;
	default.ServerNameTextColor = Settings.ServerNameTextColor;
	default.GameInfoBoxColor = Settings.GameInfoBoxColor;
	default.GameInfoTextColor = Settings.GameInfoTextColor;
	default.WaveBoxColor = Settings.WaveBoxColor;
	default.WaveTextColor = Settings.WaveTextColor;
	default.PlayerCountBoxColor = Settings.PlayerCountBoxColor;
	default.PlayerCountTextColor = Settings.PlayerCountTextColor;
	default.ListHeaderBoxColor = Settings.ListHeaderBoxColor;
	default.ListHeaderTextColor = Settings.ListHeaderTextColor;
	default.LeftStateBoxColor = Settings.LeftStateBoxColor;
	default.LeftStateBoxColorDead = Settings.LeftStateBoxColorDead;
	default.LeftStateBoxColorLow = Settings.LeftStateBoxColorLow;
	default.LeftStateBoxColorMid = Settings.LeftStateBoxColorMid;
	default.LeftStateBoxColorHigh = Settings.LeftStateBoxColorHigh;
	default.PlayerOwnerBoxColor = Settings.PlayerOwnerBoxColor;
	default.PlayerBoxColor = Settings.PlayerBoxColor;
	default.StatsBoxColor = Settings.StatsBoxColor;
	default.RankTextColor = Settings.RankTextColor;
	default.ZedTextColor = Settings.ZedTextColor;
	default.PerkTextColor = Settings.PerkTextColor;
	default.LevelTextColor = Settings.LevelTextColor;
	default.PlayerNameTextColor = Settings.PlayerNameTextColor;
	default.KillsTextColor = Settings.KillsTextColor;
	default.AssistsTextColor = Settings.AssistsTextColor;
	default.DoshTextColor = Settings.DoshTextColor;
	default.StateTextColorLobby = Settings.StateTextColorLobby;
	default.StateTextColorReady = Settings.StateTextColorReady;
	default.StateTextColorNotReady = Settings.StateTextColorNotReady;
	default.StateTextColor = Settings.StateTextColor;
	default.StateTextColorSpectator = Settings.StateTextColorSpectator;
	default.StateTextColorDead = Settings.StateTextColorDead;
	default.StateTextColorLowHP = Settings.StateTextColorLowHP;
	default.StateTextColorMidHP = Settings.StateTextColorMidHP;
	default.StateTextColorHighHP = Settings.StateTextColorHighHP;
	default.PingTextColor = Settings.PingTextColor;
	default.PingTextColorLow = Settings.PingTextColorLow;
	default.PingTextColorMid = Settings.PingTextColorMid;
	default.PingTextColorHigh = Settings.PingTextColorHigh;
	
	StaticSaveConfig();
}

defaultProperties
{

}