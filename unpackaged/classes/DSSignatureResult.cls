/*
 * DSSignatureResult
 *
 */
global with sharing class DSSignatureResult {
	public String envelopeId;
	public String status;
	public DateTime statusDateTime;
	public string uri;
	
	public static DSSignatureResult deserialize(HttpResponse response){
		return (DSSignatureResult)JSON.deserialize(response.getBody(), DSSignatureResult.class); 
	}
	
	private static testMethod void persistenceTests(){
		DSSignatureResult result = new DSSignatureResult();
		result.envelopeId	= 'foo';
		result.status		= 'foo';
		result.uri			= 'foo';
		result.statusDateTime = DateTime.now();
		
		System.assertNotEquals(null, result);
	}
	
	private static testMethod void serializationTests(){
		string jsonResult = '{' +
  			'"envelopeId": "de6077b0-bdec-4249-bc6e-7a419973ce5c",' +
  			'"status": "created",' +
  			'"statusDateTime": "2012-10-29T18:27:34.0130000Z",' +
  			'"uri": "/envelopes/de6077b0-bdec-4249-bc6e-7a419973ce5c"' +
			'}';
		
		HttpResponse response = new HttpResponse();
		response.setBody(jsonResult);
		DSSignatureResult result = DSSignatureResult.deserialize(response);
		System.assertEquals('de6077b0-bdec-4249-bc6e-7a419973ce5c', result.envelopeId);
	}
}