class CD_HTTPRequestHandler extends object
	config( CombinedCD );

`include(CD_Log.uci)

//var config string token;
const BASE_PATH = "https://cd-eapi.vercel.app/api/";

public function CheckStatus(){
	Get("status", CommonResponse);
}

public function PostRecord(MatchInfo MI, array<UserStats> USArray){
	local JsonObject Json;
	local string body;

	Json = class'CD_Object'.static.GetJsonForRecord(MI, USArray);
	body = class'CD_Object'.static.EncodeJsonIncludingList(Json);
	Post("records", body , CommonResponse);
}

private function Get(string uri, delegate<HttpRequestInterface.OnProcessRequestComplete> response){
	if (class'HttpFactory'.static.CreateRequest()
		.SetURL(BASE_PATH $ uri)
		.SetVerb("GET")
		.SetProcessRequestCompleteDelegate(response)
		.ProcessRequest()){
		`cdlog("Succeeded to send request");
	} else {
		`cdlog("Failed to send request");
	}
}

private function Post(string uri, string body , delegate<HttpRequestInterface.OnProcessRequestComplete> response){
	if (class'HttpFactory'.static.CreateRequest()
		.SetURL(BASE_PATH $ uri)
		.SetVerb("POST")
		.SetHeader("Content-Type", "application/json")
		.SetContentAsString(body)
		.SetProcessRequestCompleteDelegate(response)
		.ProcessRequest()){
		`cdlog("Succeeded to send request");
	} else {
		`cdlog("Failed to send request");
	}
}

private function CommonResponse(HttpRequestInterface OriginalRequest, HttpResponseInterface Response, bool bDidSucceed){
	local String Payload;
	local int PayloadIndex;

	if (Response != None)
	{
		`cdlog("Response Code="@Response.GetResponseCode());

		Payload = Response.GetContentAsString();
		if (Len(Payload) > 1024)
		{
			PayloadIndex = 0;
			`cdlog("Payload:");
			while (PayloadIndex < Len(Payload))
			{
				`cdlog("    "@Mid(Payload, PayloadIndex, 1024));
				PayloadIndex = PayloadIndex + 1024;
			}
		}
		else
		{
			`cdlog("Payload:"@Payload);
		}
	}
}