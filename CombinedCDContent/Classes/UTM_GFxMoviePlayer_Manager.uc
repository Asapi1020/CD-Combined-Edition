class UTM_GFxMoviePlayer_Manager extends CD_GFxManager
    config(UI);

defaultproperties
{
    WidgetBindings(10)=(WidgetName="startMenu",WidgetClass=class'UTM_GFxMenu_StartGame')
    WidgetBindings(21)=(WidgetName="traderMenu",WidgetClass=class'UTM_GFxMenu_Trader')
}