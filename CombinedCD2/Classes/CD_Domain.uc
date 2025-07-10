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

struct SpawnCycleAnalysis
{
	var bool bFailed;
	var string ErrorMessage; // If bFailed is true, this message will contain the reason for failure.
	var string ShortMessage; // A short message mainly for object container.
	var string MediumMessage; // A medium message mainly for chat line.
	var string LongMessage; // A long message mainly for console output.
	var string AdditionalMessage;
	var array<string> Categories; // for KFGUI_ColumnList (Large, Medium, Small)
	var array<string> Groups; // for KFGUI_ColumnList (Clots, Albino, etc.)
	var array<string> Types; // for KFGUI_ColumnList (for each type of Zed)
};

enum DownloadStage
{
	DS_None,
	DS_Starting,
	DS_Downloading,
	DS_Downloaded,
	DS_Completed
};
