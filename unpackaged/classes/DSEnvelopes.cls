/**
	* DSEnvelopes - <description>
	* Created by BrainEngine Cloud Studio
	* @author: Bob Sampson
	* @version: 1.0
*/

public with sharing class DSEnvelopes{
	
	public List<envelope> envelopes;
	
	public static DSEnvelopes deserialize(HttpResponse response){
		return (DSEnvelopes)JSON.deserialize(response.getBody(), DSEnvelopes.class); 
	}
	
	public class envelope {
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
		
	}
	
}