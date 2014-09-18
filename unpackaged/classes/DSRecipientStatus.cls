public with sharing class DSRecipientStatus{
	
	public List<signer> signers;
	
	public static DSRecipientStatus deserialize(HttpResponse response){
		return (DSRecipientStatus)JSON.deserialize(response.getBody(), DSRecipientStatus.class); 
	}

	public class signer {
		public string name;
        public string email;
		public string recipientId;
        public string recipientIdGuid;
		public String requireIdLookup;
		public string userId;
        public string routingOrder;
		public string roleName;
		public string status;
		public String declinedReason;
	}
}