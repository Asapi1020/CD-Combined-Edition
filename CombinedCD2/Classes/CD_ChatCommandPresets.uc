/**
 * @brief Defines a set of chat command presets. UTF-16LE encoded.
 */
class CD_ChatCommandPresets extends Object
	abstract;

struct ChanceResCombo
{
	var float Chance;
	var string Res;
	var name Type;

	structdefaultproperties
	{
		Chance = 1.f;
		Type = "CDEcho";
	}
};

struct PreCmdCombo
{
	var array<string> Key;
	var array<ChanceResCombo> ResList;
};

var array<PreCmdCombo> Commands;

const ONGSHIMI_LYRIC = "뽀얗고 동그란 넌 나의 옹심이";
const JAPANESE_MEOW = "にゃ～ん♡";

defaultProperties
{
	Commands.Add((Key=("!cdnam"),	ResList=((Res="nam_pro_v5は神サイクル"))))
	Commands.Add((Key=("!cdgom"),	ResList=((Res="人間（くま）"))))
	Commands.Add((Key=("!cdshiva"),	ResList=((Res="魅力的ですね"))))
	Commands.Add((Key=("!cdfatcat"),ResList=((Res="美の骨頂"))))
	Commands.Add((Key=("!cdnew"),	ResList=((Res="このゲームにメディックは要らないよ。"))))
	Commands.Add((Key=("!cdsoysoa"),ResList=((Res="Vinusnana"))))
	Commands.Add((Key=("!cdvinusnana"),ResList=((Res="Soysoa"))))
	Commands.Add((Key=("!cdhansoy"),ResList=((Res="(Soa)"))))
	Commands.Add((Key=("!cdmako"),	ResList=((Res="イケメンですね～"))))
	Commands.Add((Key=("!cdlilill"),ResList=((Res="これは限界バトル"))))
	Commands.Add((Key=("!cdyg"),	ResList=((Res="Go Go Yellow Grapes!!"))))
	Commands.Add((Key=("!cdmufty"),	ResList=((Res="閃光のお兄ちゃん")	)))
	Commands.Add((Key=("!cdario"),	ResList=((Res="ありお隊長～～"))))
	Commands.Add((Key=("!cdhelo"),	ResList=((Res="Hello Hero"))))
	Commands.Add((Key=("!cdgodtail"),ResList=((Res="神様の尻尾"))))
	Commands.Add((Key=("!cdrice"),	ResList=((Chance=0.1f, Res="洗濯物干し干しライス"), (Chance=0.1f, Res="タバコさんライス\nゆっくりしような。"), (Chance=0.01f, Res="わきがさんライス（みあの大好物）"), (Res="tabako san rice"))))
	Commands.Add((Key=("!cdsu"),	ResList=((Chance=0.94f,Res="Poop shooter!"), (Chance=0.05f, Res="Best Poop Shooter!"), (Res="suことsujigamiはあさぴの一番古いフレンドです。"))))
	Commands.Add((Key=("hagepippi"),ResList=((Chance=0.33f,Res="ツルツルぴっぴ！"),	 (Chance=0.33f, Res="テカテカぴっぴ！"), (Res="ツルテカぴっぴ！"))))
	Commands.Add((Key=("!cdmika"),	ResList=((Chance=0.9f, Res="miruna"), (Res="SONY CORPORATION"))))
	Commands.Add((Key=("!cduoka"),	ResList=((Chance=0.98f,Res="200%の確率で 延長失敗です。"), (Res="今回は延長成功です。"))))
	Commands.Add((Key=("!cdholick"),ResList=((Chance=0.8f, Res="Rhinoです"), (Res="KFして仕事サボります"))))
	Commands.Add((Key=("!cdhage"),	ResList=((Chance=0.3f, Res="Hair=false"), (Chance=0.3f, Res="DisableHair=true"), (Chance=0.3f, Res="Hage=true"), (Res="Hage鯖は2021年頃まで存在した日本CD鯖の一つです。"))))
	Commands.Add((Key=("!cdkabochan"),ResList=((Chance=0.5f, Res="たくちゃんです"), (Res="だれかさんです"))))
	Commands.Add((Key=("!cdsome"),	ResList=((Chance=0.5f, Res="そうね。"), (Res="そうよ。"))))
	Commands.Add((Key=("!cdmanul"),	ResList=((Chance=0.8f, Res="モンゴル語で小さい山猫という意味"), (Res="韓国語でニンニクという意味"))))
	Commands.Add((Key=("!cdrakasna"),ResList=((Chance=0.5f, Res="MIG3는 단독으로 클리어할 수 있습니다"), (Res="mig3はソロでクリアできます"))))
	Commands.Add((Key=("!cdzetsu"),	ResList=((Chance=0.5f, Res="ZETSU鯖は2023年4月から2025年2月まで常設されていました。"), (Chance=0.4f, Res="ZETSU鯖の存在はCombined Editionの発展に大きく寄与しました。"), (Chance=0.09f, Res="ZETSUさん、ありがとう!!!"), (Res="や～い、や～い、ZETSUさんのう～～んち！（最低！）"))))
	Commands.Add((Key=("!cdgraph", "!cdgraphite"),	ResList=((Chance=0.5f, Res="止まるんじゃねぇぞ"), (Res="Graphさんは2021年頃までEternal Editionによる日本常設鯖を提供していました。"))))
	Commands.Add((Key=("!cdoops", "!cdoops!"),		ResList=((Res="おっとっと"))))
	Commands.Add((Key=("!cdmachine", "!cdmig"), 	ResList=((Res="Machine is God"))))
	Commands.Add((Key=("!cdomakusa", "!cdomaekusai"),	ResList=((Chance=0.7f, Res="Zedtime中はご飯食べられるよ"), (Chance=0.1f, Res="CompoundBow?めっちゃ倒せるじゃん"), (Chance=0.1f, Res="ハスクの攻撃が痛い？倒せばいいじゃん"), (Chance=0.05f, Res="omakusaさんは非常説のOT鯖の管理者です。"), (Res="omakusaさんは、いにしえのエリート集団RED ANALの管理者です。"))))
	Commands.Add((Key=("!cdsuimuf", "!cdsuimu"),		ResList=((Chance=0.7f, Res="マグナムを信じるんだよ"), (Chance=0.15f, Res="延長のコツ？気合で延ばすんだよ"),	 (Res="KFは大晦日にしかやらないよ"))))
	Commands.Add((Key=("!cdnight", "!cdknight", "!cdnaito"), ResList=((Res="ナイト内藤naitonightknight"))))
	Commands.Add((Key=("!cdasp", "!cdasapi", "!cdasapippi"), ResList=((Chance=0.89f, Res="KF2はおもちゃ"), (Chance=0.1f, Res="あさぴ鯖は2021年7月から2023年2月まで常設されていました。") , (Res="あさぴ鯖の運営に毎月3850円かかっていました"))))
	
	Commands.Add((Key=("!monyo"),	ResList=((Res="もにょもにょもにょ～！"))))
	Commands.Add((Key=("!mocho"),	ResList=((Res="もちょもちょ"))))
	Commands.Add((Key=("!wacha"),	ResList=((Chance=0.5f, Res="わちゃわちゃ"), (Res="ワチャはメカメカ"))))
	Commands.Add((Key=("!cdrhino"),	ResList=((Res="HoLickです"))))
	Commands.Add((Key=("!cdtopokki"),ResList=((Res="나는 떡볶이를 좋아한다"))))
	Commands.Add((Key=("!cdztmy"),	ResList=((Res="永遠是深夜有多好"))))
	Commands.Add((Key=("!cdtantan"),ResList=((Res="我要吃丹参面"))))
	Commands.Add((Key=("!cdjpn"),	ResList=((Res="I'm Japanese so can't understand English."))))
	Commands.Add((Key=("!cdnuked"),	ResList=((Res="ここが実家。"))))
	Commands.Add((Key=("!cdmuseum"),ResList=((Res="おまくさの接待会場"))))
	Commands.Add((Key=("!cdmiasma"),ResList=((Res="みあ様！"))))
	Commands.Add((Key=("!cdamb"),	ResList=((Res="ALL MY BAD"))))
	Commands.Add((Key=("!cdayg"),	ResList=((Res="ALL YOUR GOOD"))))
	Commands.Add((Key=("!cdsry"),	ResList=((Res="Sony"))))
	Commands.Add((Key=("!cdsony"),	ResList=((Res="Sorry"))))
	Commands.Add((Key=("!cdoc"),	ResList=((Res="惜しい！"))))
	Commands.Add((Key=("!cdikeru"),	ResList=((Res="ikeru"))))
	Commands.Add((Key=("!cdikura"),	ResList=((Res="天才的なアイドル様"))))
	Commands.Add((Key=("!cdha?"),	ResList=((Res="は？"))))
	Commands.Add((Key=("!cde?"),	ResList=((Res="え？"))))
	Commands.Add((Key=("!cdmorahara"),ResList=((Res="あんまり押されない方が良いよ"))))
	Commands.Add((Key=("!cdsurvive"),ResList=((Res="死ぬの地雷プレイですよ"))))
	Commands.Add((Key=("!wc"),		ResList=((Res="お花摘みに行ってきます。", Type="MapVote"))))
	Commands.Add((Key=("!iteration"),ResList=((Res="行ってらっしゃい。", Type="MapVote"))))
	Commands.Add((Key=("!brb"),		ResList=((Res="すぐ戻る。しばし待て。", Type="MapVote"))))
	Commands.Add((Key=("!back"),	ResList=((Res="只今戻りました。", Type="MapVote"))))
	Commands.Add((Key=("!wb"),		ResList=((Res="おかえりなさい。", Type="MapVote"))))
	Commands.Add((Key=("!o2"),		ResList=((Res="おつおつ～。", Type="MapVote"))))
	Commands.Add((Key=("!ddzte"),	ResList=((Res="<local>CD_Survival.HateDisturbanceMsg</local>"))))
	Commands.Add((Key=("!cdmagnum"),ResList=((Res="<local>CD_Survival.BelieveMagnumMsg</local>"))))
	Commands.Add((Key=("!cdfal"),	ResList=((Res="<local>CD_Survival.FalIsBestMsg</local>"))))
	Commands.Add((Key=("!cddeserteagle"),ResList=((Res="<local>CD_Survival.TeasingUpgradeMsg</local>"))))
	Commands.Add((Key=("!cddrunk"),	ResList=((Res="<local>CD_Survival.DrunkMsg</local>"))))
	Commands.Add((Key=("!cdzt", "!cdzedtime"),	ResList=((Res="<local>CD_Survival.TeasingZTMsg</local>"))))
	Commands.Add((Key=("!cdrun"),	ResList=((Res="<local>CD_Survival.TeasingRunMsg</local>"))))
	Commands.Add((Key=("!cdfm", "!cdfakesmode"), ResList=((Res="<local>CD_Survival.FakesModeNotifyMsg</local>", Type="UMEcho"))))
}
