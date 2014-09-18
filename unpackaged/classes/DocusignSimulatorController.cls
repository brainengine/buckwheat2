/**
	* DocusignSimulatorController - <description>
	* Created by BrainEngine Cloud Studio
	* @author: Bob Sampson
	* @version: 1.0
*/

public with sharing class DocusignSimulatorController{
	public string contactId {get;Set;}
	public string envId {get;Set;}
	public string response {get;Set;}
	
	public DocusignSimulatorController() {
		contactId = '003A000001TaJ7o';
	}
	
	public PageReference executeB() {
		
		//set the api credentials
		DSCredentials credentials = new DSCredentials();
        credentials.Username = '96d1c0fa-33c6-48ff-b312-6c8575179039';
        credentials.Password = 'summer45';
        credentials.IntegratorKey = 'BRAI-878b307a-c7bb-464e-a1d2-46e3f3e201f1';
        
		//set the api login information
		DSLoginInformation loginInfo = new DSLoginInformation();
        loginInfo.accountId = 'e17d5b12-06ec-45cd-b3e0-57aa40316e62';
        loginInfo.baseUrl = 'https://demo.docusign.net';
        loginInfo.email = 'bmatthews@brainengine.net';
        loginInfo.name = 'test user';
     
        //create the api client
        DSClient client = new DSClient(credentials);
        client.LoginInfo = loginInfo;               
		
		DSEnvelope env = client.getEnvelopeInformation('7c05fffc-37db-478f-a774-3d562a0cfcd0');
		response = env.status;
		return null;
	}
	
	public PageReference executeC() {
		
		if(envId == ''){
			response = 'Please specify a Envelope Id';
			return null;
		}
		
		//get the parms
		DocuSign_SDK_Setting__c parms = DocuSign_SDK_Setting__c.getValues('default');
		
		//set the api credentials
		DSCredentials credentials = new DSCredentials();
        credentials.Username = parms.DocuSign_Account_Username__c;// '96d1c0fa-33c6-48ff-b312-6c8575179039';
        credentials.Password = parms.DocuSign_Account_Password__c;//'summer45';
        credentials.IntegratorKey = parms.DocuSign_Integrator_Key__c;//'BRAI-878b307a-c7bb-464e-a1d2-46e3f3e201f1';
        
		//set the api login information
		DSLoginInformation loginInfo = new DSLoginInformation();
        loginInfo.accountId = parms.DocuSign_Account_Id__c;//'e17d5b12-06ec-45cd-b3e0-57aa40316e62';
        loginInfo.baseUrl = parms.DocuSign_API_URL__c;//'https://demo.docusign.net';
        loginInfo.email = parms.DocuSign_Account_Email__c;//'bmatthews@brainengine.net';
        loginInfo.name = parms.DocuSign_Sender_Name__c;//'test user';
     
        //create the api client
        DSClient client = new DSClient(credentials);
        client.LoginInfo = loginInfo;               
		
		DSRecipientStatus rc = client.getRecipientStatus(envId);
		System.debug('###### ' + rc);
		
		//now let's go find the matching recipient status
		Map<String, dsfs__DocuSign_Recipient_Status__c> mapRecipients = new Map<String, dsfs__DocuSign_Recipient_Status__c>();
		for(dsfs__DocuSign_Recipient_Status__c objRecipient : [Select Id, dsfs__Recipient_Status__c, dsfs__Decline_Reason__c, dsfs__Date_Declined__c, dsfs__Date_Signed__c, dsfs__DocuSign_Recipient_Id__c, dsfs__DocuSign_Routing_Order__c from dsfs__DocuSign_Recipient_Status__c where dsfs__Envelope_Id__c =: envId]){
			mapRecipients.put(objRecipient.dsfs__DocuSign_Recipient_Id__c, objRecipient);
			
			System.debug('###### FOUND RECORD');
		}
		
		//now process the results
		if(rc.signers.size() > 0){
			for(DSRecipientStatus.signer signr : rc.signers){
				System.debug('###### PROCESS RECORDS - ' + signr.status);
				mapRecipients.get(signr.recipientId).dsfs__Recipient_Status__c = signr.status;
				
				if(signr.status == 'completed'){
					mapRecipients.get(signr.recipientId).dsfs__Date_Signed__c = Datetime.now();
				}
				
				if(signr.status == 'declined'){
					mapRecipients.get(signr.recipientId).dsfs__Decline_Reason__c = signr.declinedReason;
					mapRecipients.get(signr.recipientId).dsfs__Date_Declined__c = Datetime.now();
				}
			}
		}
		
		System.debug('###### do update');
		update mapRecipients.values();
		System.debug('###### done update');
		response = 'done!!!!!!';
		
		return null;
	}
	
	public PageReference GetPeople(){
		
		try{
			//class needs to be restructured.
			
			response = 'RUNNING..';
			//get the parms
			DocuSign_SDK_Setting__c parms = DocuSign_SDK_Setting__c.getValues('default');
			
			//set the api credentials
			DSCredentials credentials = new DSCredentials();
	        credentials.Username = parms.DocuSign_Account_Username__c;// '96d1c0fa-33c6-48ff-b312-6c8575179039';
	        credentials.Password = parms.DocuSign_Account_Password__c;//'summer45';
	        credentials.IntegratorKey = parms.DocuSign_Integrator_Key__c;//'BRAI-878b307a-c7bb-464e-a1d2-46e3f3e201f1';
	        
			//set the api login information
			DSLoginInformation loginInfo = new DSLoginInformation();
	        loginInfo.accountId = parms.DocuSign_Account_Id__c;//'e17d5b12-06ec-45cd-b3e0-57aa40316e62';
	        loginInfo.baseUrl = parms.DocuSign_API_URL__c;//'https://demo.docusign.net';
	        loginInfo.email = parms.DocuSign_Account_Email__c;//'bmatthews@brainengine.net';
	        loginInfo.name = parms.DocuSign_Sender_Name__c;//'test user';
	     
	        //create the api client
	        DSClient client = new DSClient(credentials);
	        client.LoginInfo = loginInfo;               
			
			//now let's go find the matching recipient status
			Map<String, dsfs__DocuSign_Recipient_Status__c> mapRecipients = new Map<String, dsfs__DocuSign_Recipient_Status__c>();
			for(dsfs__DocuSign_Recipient_Status__c objRecipient : [Select Id, dsfs__Envelope_Id__c, dsfs__Recipient_Status__c, dsfs__Decline_Reason__c, dsfs__Date_Declined__c, dsfs__Date_Signed__c, dsfs__DocuSign_Recipient_Id__c, dsfs__DocuSign_Routing_Order__c from dsfs__DocuSign_Recipient_Status__c where dsfs__Recipient_Status__c = 'sent']){
				
				System.debug('###### PROCESSING RECORD' + objRecipient.Id);
				response += '###### PROCESSING RECORD' + objRecipient.Id;
				
				DSRecipientStatus rc = client.getRecipientStatus(objRecipient.dsfs__Envelope_Id__c);
				System.debug('###### ' + rc);
				
				//now process the results
				if(rc.signers.size() > 0){
					System.debug('###### PROCESSING RESULT');
					response += '###### PROCESSING RESULT';
					
					for(DSRecipientStatus.signer signr : rc.signers){
						
						response += '###### PROCESSING RESULT STATUS -- ' + signr.status;
						
						objRecipient.dsfs__Recipient_Status__c = signr.status;
							
						if(signr.status == 'completed'){
							objRecipient.dsfs__Date_Signed__c = Datetime.now();
						}
						
						if(signr.status == 'declined'){
							objRecipient.dsfs__Decline_Reason__c = signr.declinedReason;
							objRecipient.dsfs__Date_Declined__c = Datetime.now();
						}
					}
					
					System.debug('###### PROCESSING RESULT -- DONE');
					response += '###### PROCESSING RESULT -- DONE';
					
					mapRecipients.put(objRecipient.dsfs__DocuSign_Recipient_Id__c, objRecipient);
					
					//break;
				}
				
				System.debug('###### FOUND RECORD');
			}
			
			System.debug('###### do update');
			update mapRecipients.values();
			System.debug('###### done update');
			response += 'done!!!!!!';
			
		}catch(Exception ex){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error in sending the envelope   ' + ex.getMessage()));
			response = ex.getMessage();
		}
		
		return null;
	}
	
	public PageReference GetPeople2(){
		
		try{
			//get the parms
			DocuSign_SDK_Setting__c parms = DocuSign_SDK_Setting__c.getValues('default');
			
			//set the api credentials
			DSCredentials credentials = new DSCredentials();
	        credentials.Username = parms.DocuSign_Account_Username__c;// '96d1c0fa-33c6-48ff-b312-6c8575179039';
	        credentials.Password = parms.DocuSign_Account_Password__c;//'summer45';
	        credentials.IntegratorKey = parms.DocuSign_Integrator_Key__c;//'BRAI-878b307a-c7bb-464e-a1d2-46e3f3e201f1';
	        
			//set the api login information
			DSLoginInformation loginInfo = new DSLoginInformation();
	        loginInfo.accountId = parms.DocuSign_Account_Id__c;//'e17d5b12-06ec-45cd-b3e0-57aa40316e62';
	        loginInfo.baseUrl = parms.DocuSign_API_URL__c;//'https://demo.docusign.net';
	        loginInfo.email = parms.DocuSign_Account_Email__c;//'bmatthews@brainengine.net';
	        loginInfo.name = parms.DocuSign_Sender_Name__c;//'test user';
	     
	        //create the api client
	        DSClient client = new DSClient(credentials);
	        client.LoginInfo = loginInfo;               
			
			DSRecipientStatus rc = client.getRecipientStatus(envId);
			System.debug('###### ' + rc);
			
			//now let's go find the matching recipient status
			Map<String, dsfs__DocuSign_Recipient_Status__c> mapRecipients = new Map<String, dsfs__DocuSign_Recipient_Status__c>();
			for(dsfs__DocuSign_Recipient_Status__c objRecipient : [Select Id, dsfs__Recipient_Status__c, dsfs__Decline_Reason__c, dsfs__Date_Declined__c, dsfs__Date_Signed__c, dsfs__DocuSign_Recipient_Id__c, dsfs__DocuSign_Routing_Order__c from dsfs__DocuSign_Recipient_Status__c where dsfs__Recipient_Status__c = 'sent']){
				mapRecipients.put(objRecipient.dsfs__DocuSign_Recipient_Id__c, objRecipient);
				
				System.debug('###### FOUND RECORD');
			}
			
			//now process the results
			if(rc.signers.size() > 0){
				for(DSRecipientStatus.signer signr : rc.signers){
					System.debug('###### PROCESS RECORDS - ' + signr.status);
					mapRecipients.get(signr.recipientId).dsfs__Recipient_Status__c = signr.status;
					
					if(signr.status == 'completed'){
						mapRecipients.get(signr.recipientId).dsfs__Date_Signed__c = Datetime.now();
					}
					
					if(signr.status == 'declined'){
						mapRecipients.get(signr.recipientId).dsfs__Decline_Reason__c = signr.declinedReason;
						mapRecipients.get(signr.recipientId).dsfs__Date_Declined__c = Datetime.now();
					}
				}
			}
			
			System.debug('###### do update');
			update mapRecipients.values();
			System.debug('###### done update');
			response = 'done!!!!!!';
			
			
				
			}catch(Exception ex){
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error in sending the envelope   ' + ex.getMessage()));
				response = ex.getMessage();
			}
		return null;
	}
	
	public PageReference GetEnvelopes(){
		
		//get the parms
		DocuSign_SDK_Setting__c parms = DocuSign_SDK_Setting__c.getValues('default');
		
		//set the api credentials
		DSCredentials credentials = new DSCredentials();
        credentials.Username = parms.DocuSign_Account_Username__c;// '96d1c0fa-33c6-48ff-b312-6c8575179039';
        credentials.Password = parms.DocuSign_Account_Password__c;//'summer45';
        credentials.IntegratorKey = parms.DocuSign_Integrator_Key__c;//'BRAI-878b307a-c7bb-464e-a1d2-46e3f3e201f1';
        
		//set the api login information
		DSLoginInformation loginInfo = new DSLoginInformation();
        loginInfo.accountId = parms.DocuSign_Account_Id__c;//'e17d5b12-06ec-45cd-b3e0-57aa40316e62';
        loginInfo.baseUrl = parms.DocuSign_API_URL__c;//'https://demo.docusign.net';
        loginInfo.email = parms.DocuSign_Account_Email__c;//'bmatthews@brainengine.net';
        loginInfo.name = parms.DocuSign_Sender_Name__c;//'test user';
     
        //create the api client
        DSClient client = new DSClient(credentials);
        client.LoginInfo = loginInfo;               
        DSSignatureRequest request = new DSSignatureRequest(DSSignatureRequest.DocumentSource.TEMPLATE);
        request.emailSubject    = parms.DocuSign_Email_Subject__c;//'Docusign ';
        request.emailBlurb      = parms.DocuSign_Email_Blurb__c;//'Blurb';
        request.templateId = parms.DocuSign_Template_Id__c;//'6544805E-28D7-4F3F-BEB5-BF2A7D6410C1';   
		
		String curr_month = '08';
		String curr_day = '27';
		String curr_year = '2014';
		
		DSEnvelopeDocuments docs = client.getDocuments('from_date=' + curr_month + '%2F' + curr_day + '%2F' + curr_year);
		System.debug('******* docs: ' + docs);
		
		if(docs.envelopeDocuments.size() > 0){
			System.debug('******* found documents');
			for(DSEnvelopeDocuments.document doc : docs.envelopeDocuments){
				System.debug('******* processing document');
				String docName = doc.name;
				String docUrl = doc.uri;
				
				boolean status = client.downloadDocument(docUrl,'003A000001TaJ7o', docName);
				
				return null;
				
			}
		}
		
		
		return null;
		
	}
	
	public PageReference execute() {
		//contactId = '003f000000fnMzH';
		
		if(contactId == ''){
			response = 'Please specify a Contact Id';
			return null;
		}
		
		Contact con = [Select Id, Name, Email, AccountId from Contact where Id =:contactId limit 1];
		String contactName = con.Name;// 'Jimmy Mack';
		String contactEmail = con.Email;//'brian@brainengine.net';
		
		//get the parms
		DocuSign_SDK_Setting__c parms = DocuSign_SDK_Setting__c.getValues('default');
		
		//set the api credentials
		DSCredentials credentials = new DSCredentials();
        credentials.Username = parms.DocuSign_Account_Username__c;// '96d1c0fa-33c6-48ff-b312-6c8575179039';
        credentials.Password = parms.DocuSign_Account_Password__c;//'summer45';
        credentials.IntegratorKey = parms.DocuSign_Integrator_Key__c;//'BRAI-878b307a-c7bb-464e-a1d2-46e3f3e201f1';
        
		//set the api login information
		DSLoginInformation loginInfo = new DSLoginInformation();
        loginInfo.accountId = parms.DocuSign_Account_Id__c;//'e17d5b12-06ec-45cd-b3e0-57aa40316e62';
        loginInfo.baseUrl = parms.DocuSign_API_URL__c;//'https://demo.docusign.net';
        loginInfo.email = parms.DocuSign_Account_Email__c;//'bmatthews@brainengine.net';
        loginInfo.name = parms.DocuSign_Sender_Name__c;//'test user';
     
        //create the api client
        DSClient client = new DSClient(credentials);
        client.LoginInfo = loginInfo;               
        DSSignatureRequest request = new DSSignatureRequest(DSSignatureRequest.DocumentSource.TEMPLATE);
        request.emailSubject    = parms.DocuSign_Email_Subject__c;//'Docusign ';
        request.emailBlurb      = parms.DocuSign_Email_Blurb__c;//'Blurb';
        request.templateId = parms.DocuSign_Template_Id__c;//'6544805E-28D7-4F3F-BEB5-BF2A7D6410C1';   
		
		/*DSTab signatureTab = new DSTab();
        signatureTab.tabType = DSTab.DSTabType.SIGN_HERE;
        signatureTab.useAnchorProperties = true;
        signatureTab.anchorString = 'Signature';
        signatureTab.anchorXOffset = 100;
        signatureTab.anchorYOffset = 10;*/
       
		//add the person to send it to
        DSRecipient recipient = new DSRecipient();
        recipient.name  = contactName;
        recipient.email = contactEmail;
        //recipient.tabs.add(new DSTab());
		//recipient.tabs.add(signatureTab);
        //request.recipients.add(recipient);
		
		DSTab signatureTab = new DSTab();
        signatureTab.tabType = DSTab.DSTabType.SIGN_HERE;
        signatureTab.useAnchorProperties = false;
        signatureTab.anchorString = 's1';
		signatureTab.xPosition = 100;
        signatureTab.yPosition = 530;
		
		DSTab signatureTabA = new DSTab();
        signatureTabA.tabType = DSTab.DSTabType.FULL_NAME;
        signatureTabA.useAnchorProperties = false;
        signatureTabA.anchorString = 'n1';
		signatureTabA.xPosition = 100;
        signatureTabA.yPosition = 605;
		
		DSTab signatureTabB = new DSTab();
        signatureTabB.tabType = DSTab.DSTabType.TITLE;
        signatureTabB.useAnchorProperties = false;
        signatureTabB.anchorString = 'n1';
		signatureTabB.xPosition = 100;
        signatureTabB.yPosition = 640;
		
		DSTab signatureTabC = new DSTab();
        signatureTabC.tabType = DSTab.DSTabType.DATESIGNED;
        signatureTabC.useAnchorProperties = false;
        signatureTabC.anchorString = 'n1';
		signatureTabC.xPosition = 100;
        signatureTabC.yPosition = 200;
		
		DSTemplateRole role = new DSTemplateRole();
		role.email = contactEmail;
		role.name = contactName;
		role.roleName = 'Signer';
		role.tabs.add(signatureTab);
		role.tabs.add(signatureTabA);
		role.tabs.add(signatureTabB);
		//role.tabs.add(signatureTabC);
		request.templateRoles.add(role);
    
        //request.templateRoles.add( new DSTemplateRole(contactEmail, contactName, 'Signer'));                  
               
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Added Docusign Reciepients'));        
        DSSignatureResult result;
        
        try
        {
            result = client.requestSignature(request);
            System.debug('@@@@@ RESPONSE: ' + result);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Done Docusign Process' + result));  
			
			envId = result.envelopeId;
			response = 'Sent - ' + envId;
			envId = envId.capitalize();
			
			//go get the recipient status
			DSRecipientStatus rc = client.getRecipientStatus(envId);
			
			//create the envelope record
			dsfs__DocuSign_Envelope__c envelope = new dsfs__DocuSign_Envelope__c();
			envelope.dsfs__DocuSign_Envelope_ID__c = envId;
			envelope.dsfs__DocuSign_Email_Subject__c = parms.DocuSign_Email_Subject__c;
			envelope.dsfs__DocumentID__c = 'Select Document ID';
			envelope.dsfs__DocuSign_Email_Message__c = parms.DocuSign_Email_Blurb__c;
			envelope.dsfs__DocuSign_Envelope_Sent__c = Datetime.now();
			
			insert envelope;
			
			//create the envelope recipient
			dsfs__DocuSign_Envelope_Recipient__c rec = new dsfs__DocuSign_Envelope_Recipient__c();
			rec.dsfs__DocuSign_EnvelopeID__c = envelope.Id;
			rec.dsfs__DocuSign_Signer_Type__c = 'Signer';
			rec.dsfs__RoleName__c = 'Signer 1';
			rec.dsfs__RoleValue__c = 1;
			rec.dsfs__Salesforce_Recipient_Type__c = 'Contact';
			rec.dsfs__DocuSign_Recipient_Role__c = 'Customer 1';
			
			insert rec;
			
			//create the status record
			dsfs__DocuSign_Status__c objStatus = new dsfs__DocuSign_Status__c();
			objStatus.dsfs__DocuSign_Envelope_ID__c = envId;
			objStatus.dsfs__Sender_Email__c = parms.DocuSign_Account_Email__c;//'brian@brainengine.net';
			objStatus.dsfs__Sender__c = parms.DocuSign_Sender_Name__c;//'Brian Matthews';
			objStatus.dsfs__Subject__c = parms.DocuSign_Email_Subject__c;
			objStatus.dsfs__Envelope_Status__c = 'Sent';
			objStatus.dsfs__Sent_Date_Time__c = Datetime.now();
			objStatus.dsfs__Contact__c = con.Id;
			
			if(con.AccountId != null){
				objStatus.dsfs__Company__c = con.AccountId;
			}
			
			insert objStatus;
			
			List<dsfs__DocuSign_Recipient_Status__c> recipients = new List<dsfs__DocuSign_Recipient_Status__c>();
			if(rc.signers.size() > 0){
				for(DSRecipientStatus.signer signr : rc.signers){
					dsfs__DocuSign_Recipient_Status__c objRecipient = new dsfs__DocuSign_Recipient_Status__c();
					objRecipient.dsfs__Parent_Status_Record__c = objStatus.Id;
					objRecipient.dsfs__DocuSign_Recipient_Id__c = signr.recipientId;
					objRecipient.dsfs__Envelope_Id__c = envId;
					objRecipient.dsfs__Date_Sent__c = Datetime.now();
					objRecipient.dsfs__DocuSign_Recipient_Email__c = signr.email;
					objRecipient.dsfs__Recipient_Status__c = signr.status;
					objRecipient.dsfs__DocuSign_Routing_Order__c = Integer.valueOf(signr.routingOrder);
					objRecipient.Name = signr.name;
					objRecipient.dsfs__Contact__c = con.Id;
					
					if(con.AccountId != null){
						objRecipient.dsfs__Account__c = con.AccountId;
					}
					
					recipients.add(objRecipient);
				}
			}
			
			if(recipients.size() > 0){
				insert recipients;
			}
			
			response += ' COMPLETED';
			
        } catch (Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error in sending the envelope   ' + e.getMessage()));
			response = e.getMessage();
        }
			
        return null;
    }

}