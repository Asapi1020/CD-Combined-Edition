class CD_ClassNameUtils extends Object
	abstract;

`include(CD_Log.uci)

static function string ExtractIndexStringFromInstanceNameString(string InstanceNameString, string ClassName)
{
	local int PrefixLength;

	PrefixLength = Len(ClassName) + 1;

	if (Left( Locs(InstanceNameString), PrefixLength ) == ( Locs(ClassName) $ "_" ))
	{
		return Mid(InstanceNameString, PrefixLength);
	}
	
	`cdlog("CD_ClassUtils.ExtractIndexStringFromInstanceNameString: InstanceNameString does not start with " $ ClassName $ "_: " $ InstanceNameString);
	return "";
}

static function string ExtractIndexStringFromInstance(Object Instance, string ClassName)
{
	return ExtractIndexStringFromInstanceNameString(string(Instance.name), ClassName);
}

static function int ExtractIndexFromInstance(Object Instance, string ClassName)
{
	return int(ExtractIndexStringFromInstance(Instance, ClassName));
}
