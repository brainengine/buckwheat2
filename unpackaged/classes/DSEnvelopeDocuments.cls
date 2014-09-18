public with sharing class DSEnvelopeDocuments{

	public List<document> envelopeDocuments;
	
	public static DSEnvelopeDocuments deserialize(HttpResponse response){
		return (DSEnvelopeDocuments)JSON.deserialize(response.getBody(), DSEnvelopeDocuments.class); 
	}
	
	public class document {
		public string documentId;
		public string name;
		public string type;
		public string uri;
		public string order;
		public string pages;
	}

}