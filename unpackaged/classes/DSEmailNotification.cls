public with sharing class DSEmailNotification implements DSSerializeable{
	public string emailSubject;
	public string emailBody;	
	public string supportedLanguage	= 'en';
	
	public DSEmailNotification(){}
	
	public DSEmailNotification(string subject, string body){
		this.emailSubject	= subject;
		this.emailBody		= body;
	}
	
	public DSEmailNotification(string subject, string body, string language){
		this.emailSubject	= subject;
		this.emailBody		= body;
		this.supportedLanguage = language;
	}
	
	public JSONGenerator serialize(JSONGenerator gen){
		gen.writeStartObject();
		gen.writeStringField('emailBody', this.emailBody);
		gen.writeStringField('emailSubject', this.emailSubject);
		gen.writeStringField('supportedLanguage', this.supportedLanguage);
		gen.writeEndObject();
		return gen;
	}
	
	private static testMethod void tests(){
		DSEmailNotification n = new DSEmailNotification();
		System.assertEquals(null, n.emailSubject);
		System.assertEquals('en', n.supportedLanguage);
		
		n = new DSEmailNotification('test subject', 'test body');
		System.assertEquals('test subject', n.emailSubject);
		System.assertEquals('test body', n.emailBody);		
		System.assertEquals('en', n.supportedLanguage);
		
		n = new DSEmailNotification('test subject', 'test body', 'fr');
		System.assertEquals('test subject', n.emailSubject);
		System.assertEquals('test body', n.emailBody);		
		System.assertEquals('fr', n.supportedLanguage);
		
		JSONGenerator gen = JSON.createGenerator(false);
		string EXPECTED_JSON = '{"emailBody":"test body","emailSubject":"test subject","supportedLanguage":"fr"}';
		System.assertEquals(EXPECTED_JSON, n.serialize(gen).getAsString());
	}
}