class CD_CosmeticHandler extends Object
	DependsOn(CD_Domain);

var protected array<string> HatMeshPaths;
var protected transient LinearColor ZC_MonoChromeValue, ZC_ColorValue;

var protected transient array<KFPawn_Monster> HatWearingZeds;

public simulated function AddHatToZed(KFPawn_Monster KFPM, byte ZedHatType)
{
	local StaticAttachments NewAttachment;
	local StaticMeshComponent StaticAttachment;
	local MaterialInstanceConstant NewMIC;
	local string HatPath;

	if (HatWearingZeds.Find(KFPM) != INDEX_NONE)
		return;

	HatPath = ChooseHatMeshPath(ZedHatType);
	if (HatPath == "")
		return;

	NewAttachment.StaticAttachment = StaticMesh(DynamicLoadObject(HatPath, class'StaticMesh'));
	NewAttachment.AttachSocketName = KFPM.ZEDCowboyHatAttachName;

	StaticAttachment = new (KFPM) class'StaticMeshComponent';
	if (StaticAttachment != none)
	{
		KFPM.StaticAttachList.AddItem(StaticAttachment);
		StaticAttachment.SetActorCollision(false, false);
		StaticAttachment.SetStaticMesh(NewAttachment.StaticAttachment);
		StaticAttachment.SetShadowParent(KFPM.Mesh);
		StaticAttachment.SetLightingChannels(KFPM.PawnLightingChannel);
		NewMIC = StaticAttachment.CreateAndSetMaterialInstanceConstant(0);
		NewMIC.SetVectorParameterValue('color_monochrome', ZC_MonoChromeValue);
		NewMIC.SetVectorParameterValue('Black_White_switcher', ZC_ColorValue);
		KFPM.AttachComponent(StaticAttachment);
		KFPM.Mesh.AttachComponentToSocket(StaticAttachment, NewAttachment.AttachSocketName);
		KFPM.CharacterMICs.AddItem(NewMIC);

		HatWearingZeds.AddItem(KFPM);
	}
}

protected function string ChooseHatMeshPath(byte ZedHatType)
{
	local int Index;

	switch (ZedHatType)
	{
		case ZHT_Cowboy:
			Index = 0;
			break;
		case ZHT_Xmas:
			Index = 1 + Rand(8);
			break;
		case ZHT_Halloween:
			Index = 9 + Rand(8);
			break;
		case ZHT_Random:
			Index = Rand(default.HatMeshPaths.Length);
			break;
		default:
			return "";
	}

	if (Index < 0 || Index >= default.HatMeshPaths.Length)
		return "";

	return HatMeshPaths[Index];
}

defaultproperties
{ 
	HatMeshPaths(0) = "CHR_CosmeticSet01_MESH.cowboyhat.CHR_CowboyHat_Alberts_Cosmetic";
    HatMeshPaths(1) = "CHR_Cosmetic_XMAS_MESH.CHR_PoinsettaHat_Cosmetic";
    HatMeshPaths(2) = "CHR_Cosmetic_XMAS_MESH.CHR_Ushanka_Cosmetic";
    HatMeshPaths(3) = "CHR_CosmeticSet_XMAS_02_MESH.CHR_Cosmetic_Halloween_ChimneyHat";
    HatMeshPaths(4) = "CHR_CosmeticSet_XMAS_02_MESH.CHR_Cosmetic_Halloween_Treeyhat";
    HatMeshPaths(5) = "CHR_CosmeticSet_XMAS_02_MESH.CHR_Cosmetic_Halloween_Penguinhat";
    HatMeshPaths(6) = "CHR_CosmeticSet_XMAS_03_MESH.snowmancap.CHR_Cosmetic_XMas19_SnowmanCap_LOD1";
    HatMeshPaths(7) = "CHR_CosmeticSet_XMAS_03_MESH.TopHat.CHR_Cosmetic_XMas19_TopHat_LOD0";
    HatMeshPaths(8) = "CHR_CosmeticSet_XMAS_03_MESH.clotthat.CHR_Cosmetic_XMas19_ClotHat_LOD0";
    HatMeshPaths(9) = "CHR_CosmeticSet_Halloween_01_MESH.CHR_Cosmetic_Halloween_Axed";
    HatMeshPaths(10) = "CHR_CosmeticSet_Halloween_02_MESH.CHR_Cosmetic_Halloween_PirateHat";
    HatMeshPaths(11) = "CHR_CosmeticSet_Halloween_02_MESH.CHR_Cosmetic_Halloween_WitchHat";
    HatMeshPaths(12) = "CHR_CosmeticSet_Halloween_03_MESH.batcathat.CHR_Cosmetic_Halloween19_BatCatHat";
    HatMeshPaths(13) = "CHR_CosmeticSet_Halloween_03_MESH.biohazardhat.CHR_Cosmetic_Halloween19_BiohazardHat";
    HatMeshPaths(14) = "CHR_CosmeticSet_Halloween_03_MESH.monsterwitchhat.CHR_Cosmetic_Halloween19_MonsterWitchHat";
    HatMeshPaths(15) = "CHR_CosmeticSet_Halloween_03_MESH.pumpkinhat.CHR_Cosmetic_Halloween19_PumpkinHat";
    HatMeshPaths(16) = "CHR_CosmeticSet_Halloween_05_MESH.muertos_tophat.CHR_MuertosTopHat_Cosmetic";
    HatMeshPaths(17) = "CHR_CosmeticSet_Spring_01_MESH.cyborg_brainhelmet.CHR_CyborgBrainHelmet_Cosmetic";
    HatMeshPaths(18) = "CHR_CosmeticSet_SS_01_MESH.CHR_Clown_Hat";
    HatMeshPaths(19) = "CHR_CosmeticSet_SS_01_MESH.CHR_Tiny_Hat_Alberts";
    HatMeshPaths(20) = "CHR_CosmeticSet_SS_01_MESH.CHR_Witchdoctor_Hat";
    HatMeshPaths(21) = "CHR_CosmeticSet_Steampunk01_MESH.flatcap.SP_FlatCap_Mesh";
    HatMeshPaths(22) = "CHR_CosmeticSet_Steampunk01_MESH.TopHat.SP_TopHat_Mesh";
    HatMeshPaths(23) = "CHR_CosmeticSet01_MESH.chefhat.CHR_ChefHat_Alberts_Cosmetic_LOD0_LOD0";

	ZC_MonoChromeValue = (R=1.0f,G=0.0f,B=0.0f)
	ZC_ColorValue = (R=1.0f,G=0.0f,B=0.0f)
}
