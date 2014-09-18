public class DSSignatureInfo implements DSSerializeable {
	public string signatureName;
	public string signatureInitials;
	public string fontStyle = 'Rage Italic';
	/*
	Supported Font Styles
	"1_DocuSign", "2_DocuSign", "3_DocuSign", "4_DocuSign", 
	"5_DocuSign", "6_DocuSign", "7_DocuSign", "8_DocuSign", 
	"Mistral", "Rage Italic"
	*/
	
	public DSSignatureInfo(){}
	
	public DSSignatureInfo(string name, string initials){
		this.signatureName 		= name;
		this.signatureInitials	= initials;
	}
	
	public JSONGenerator serialize(JSONGenerator gen){
		gen.writeStartObject();
		gen.writeStringField('signatureName', this.signatureName);
		gen.writeStringField('signatureInitials', this.signatureInitials);
		gen.writeStringField('fontStyle', this.fontStyle);
		gen.writeEndObject();
		return gen;
	}
	
	private static testMethod void tests(){
		DSSignatureInfo sigInfo = new DSSignatureInfo();
		System.assertEquals(null, sigInfo.signatureName);
		System.assertEquals('Rage Italic', sigInfo.fontStyle);
		
		sigInfo = new DSSignatureInfo('signature', 'initials');
		System.assertEquals('signature', sigInfo.signatureName);
		System.assertEquals('initials', sigInfo.signatureInitials);
		System.assertEquals('Rage Italic', sigInfo.fontStyle);
		
		string EXPECTED_JSON = '{"signatureName":"signature","signatureInitials":"initials","fontStyle":"Rage Italic"}';
		JSONGenerator gen = JSON.createGenerator(false);
		System.assertEquals(EXPECTED_JSON, sigInfo.serialize(gen).getAsString());
	}
}