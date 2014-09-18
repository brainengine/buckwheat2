/*
 * DSTemplate.cls
 */
global with sharing class DSTemplate {
	public string name;
	public string templateId;
	public string description;
	public DateTime lastModified;
	public integer pageCount;
	public string shared;
	public string uri;
	
	public static List<DSTemplate> deserialize(HttpResponse httpResponse){
		try{
			DSTemplateResult result = (DSTemplateResult) JSON.deserialize(httpResponse.getBody(), 
										DSTemplateResult.class);
			if(result == null || result.envelopeTemplates == null){
				return new List<DSTemplate>();
			}
			else{
				return result.envelopeTemplates;
			}
		}
		catch(System.JSONException ex){
			System.debug('JSON Parsing error deserializing DSTemplate: ' + ex.getMessage());
		}
		
		return null;
	}
	
	private class DSTemplateResult {
		public List<DSTemplate> envelopeTemplates;
	}
	
	private static testMethod void persistenceTests(){
		DSTemplate template = new DSTemplate();
		template.description = 'foo';
		template.name = 'foo';
		template.pageCount = 1;
		template.shared = 'true';
		template.templateId = 'foo';
		template.uri = 'foo';
		
		System.assertEquals('foo', template.description);
		System.assertEquals('foo', template.name);
		System.assertEquals('true', template.shared);
		System.assertEquals('foo', template.templateId);
		System.assertEquals('foo', template.uri);
		System.assertEquals(1, template.pageCount);
		
		DSTemplateResult result = new DSTemplateResult();
		result.envelopeTemplates = new List<DSTemplate>();
		System.assertEquals(0, result.envelopeTemplates.size());
	}
	
	private static testMethod void deserializeTests(){
		HttpResponse testResponse = new HttpResponse();
		//DSLoginInformation nullLoginInfo = (DSLoginInformation)DSLoginInformation.deserialize(testResponse);
		//System.assertEquals(null, nullLoginInfo);
		
		testResponse.setBody(TEST_DATA);
		DSTemplateResult response = (DSTemplateResult) JSON.deserialize(testResponse.getBody(), 
									DSTemplateResult.class);
		System.assertEquals(2, response.envelopeTemplates.size());
		System.assertEquals('Invoice Template', response.envelopeTemplates[0].name);
		System.assertEquals(1, response.envelopeTemplates[0].pageCount);
		
		List<DSTemplate> templates = DSTemplate.deserialize(testResponse);
		System.assertEquals(2, templates.size());
	}
	
	private static testMethod void injectionTests(){
		HttpResponse testResponse = new HttpResponse();		
		testResponse.setBody('{"foo": "value"}');
		List<DSTemplate> templates = DSTemplate.deserialize(testResponse);
		System.assertNotEquals(null, templates);
		
		testResponse.setBody('{"foo": "value');
		templates = DSTemplate.deserialize(testResponse);
		System.assertEquals(null, templates);
	}
	
	private static string TEST_DATA = '{' + 		
		'"envelopeTemplates": [' +
			'{' +
				'"description": "Template description",' +
				'"lastModified": "2012-10-24T19:34:41.3630000Z",' +
				'"name": "Invoice Template",' +
				'"pageCount": 1,' +
				'"shared": "true",' +
				'"templateId": "37e8f7d9-8502-4134-bec0-02388b874101",' +
				'"uri": "/templates/37e8f7d9-8502-4134-bec0-02388b874101"' +
			'},' +
	        '{' +
	            '"description": "",' +
	            '"lastModified": "2012-10-29T23:42:10.5630000Z",' +
	            '"name": "Mock Template",' +
	            '"pageCount": 1,' +
	            '"shared": "true",' +
	            '"templateId": "c214c9e7-c737-4b50-aa01-fe4d7f0e2434",' +
	            '"uri": "/templates/c214c9e7-c737-4b50-aa01-fe4d7f0e2434"' +
	        '}' +
	    ']' +
		'}';
}