/*
 * DSEnvelope.cls
 *
 */
global with sharing class DSEnvelope {
	public string certificateUri;
	public string customFieldsUri;
	public string documentsCombinedUri;
	public string documentsUri;
	public string envelopeId;
	public string envelopeUri;
	public string notificationUri;
	public string recipientsUri;
	public string status;
	public string emailSubject;
	public string emailBlurb;
	public DateTime statusChangedDateTime;
	
	public static DSEnvelope deserialize(string jsonBody){
		return (DSEnvelope)JSON.deserialize(jsonBody, DSEnvelope.class);
	}
	
	public static DSEnvelope deserialize(HttpResponse response){
		return (DSEnvelope)JSON.deserialize(response.getBody(), DSEnvelope.class); 
	}
	
	private static testMethod void tests(){
		DSEnvelope envelope = new DSEnvelope();
		envelope.status = 'sent';
		System.assertEquals('sent', envelope.status);
		System.assertNotEquals(null, DSEnvelope.deserialize('{"status": "sent"}'));
	}
}