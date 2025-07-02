/**
 * Adding this class to dependency allows to use structs or enums across classes.
 */
class CD_Domain extends Object
	abstract;

struct WeaponPickupRegistryInfo
{
	var PlayerReplicationInfo OrigOwnerPRI;
	var PlayerController CurrCarrier;
	var CD_DroppedPickup KFDP;
	var class<KFWeapon> KFWClass;
	var bool bLocked;
};

struct CDPickupInfo
{
	var int ID;
	var class<KFWeapon> KFWClass;
	var string IconPath;
	var string MagazineAmmoText;
	var string SpareAmmoText;
};

enum DownloadStage
{
	DS_None,
	DS_Starting,
	DS_Downloading,
	DS_Downloaded,
	DS_Completed
};
