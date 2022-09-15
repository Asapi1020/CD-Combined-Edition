class CustomRanks extends Object
	dependson(Types)
	config(YAS);
	
`include(Build.uci)
`include(Logger.uci)

var config array<RankInfo> Rank;
