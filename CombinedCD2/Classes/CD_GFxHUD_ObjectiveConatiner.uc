class CD_GFxHUD_ObjectiveConatiner extends KFGFxHUD_ObjectiveConatiner;

simulated function SetObjectiveContainer(string title, string body)
{
	local GFxObject TextObject;

	SetVisible(true);

	TextObject = CreateObject("Object");
	TextObject.SetString("objectiveTitle", title);
	TextObject.SetBool("HideBonus", true);
	TextObject.SetString("objectiveDesc", body);
	SetObject("localizedText", TextObject);
}