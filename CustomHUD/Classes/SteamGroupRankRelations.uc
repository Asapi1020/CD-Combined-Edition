class SteamGroupRankRelations extends Object
	dependson(Types)
	config(YAS);

`include(Build.uci)
`include(Logger.uci)

var config array<RankRelation> Relation;

DefaultProperties
{

}