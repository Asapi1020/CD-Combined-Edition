class CD_DynamicSetting_QuarterPoundHPFakes extends CD_DynamicSetting
	within CD_Survival;

protected function string ReadIndicator()
{
	return Outer.QuarterPoundHPFakes;
}

protected function WriteIndicator( const out string Ind )
{
	Outer.QuarterPoundHPFakes = Ind;
}

protected function float ReadValue()
{
	return float(Outer.QuarterPoundHPFakesInt);
}

protected function WriteValue( const out float Val )
{
	Outer.QuarterPoundHPFakesInt = Round(Val);
}

protected function string PrettyValue( const float RawValue )
{
	return string(Round(RawValue));
}

defaultproperties
{
	IniDefsArrayName="QuarterPoundHPFakesDefs"
	OptionName="QuarterPoundHPFakes"
	DefaultSettingValue=6
	MinSettingValue=1
	MaxSettingValue=32

	ChatCommandNames=("!cdquarterpoundhpfakes","!cdqphpf")
	ChatWriteParamHintFragment="int"
}
