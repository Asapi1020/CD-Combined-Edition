class CD_DynamicSetting_ScrakeHPFakes extends CD_DynamicSetting
	within CD_Survival;

protected function string ReadIndicator()
{
	return Outer.ScrakeHPFakes;
}

protected function WriteIndicator( const out string Ind )
{
	Outer.ScrakeHPFakes = Ind;
}

protected function float ReadValue()
{
	return float(Outer.ScrakeHPFakesInt);
}

protected function WriteValue( const out float Val )
{
	Outer.ScrakeHPFakesInt = Round(Val);
}

protected function string PrettyValue( const float RawValue )
{
	return string(Round(RawValue));
}

defaultproperties
{
	IniDefsArrayName="ScrakeHPFakesDefs"
	OptionName="ScrakeHPFakes"
	DefaultSettingValue=6
	MinSettingValue=1
	MaxSettingValue=32

	ChatCommandNames=("!cdscrakehpfakes","!cdschpf")
	ChatWriteParamHintFragment="int"
}
