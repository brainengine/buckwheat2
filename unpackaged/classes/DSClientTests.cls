@IsTest
public with sharing class DSClientTests {

	public static testMethod void requestSignatureTests(){
        //DSClient client = new DSClient();
    }
    
    public static testMethod void testRESTGet(){
        DSCredentials credentials = new DSCredentials();
        credentials.BaseURL         = 'https://demo.docusign.net/';
        credentials.Username        = 'username';
        credentials.Password        = 'password';
        credentials.IntegratorKey   = 'key';
        
        DSClient client = new DSClient(credentials);
        client.testResponseData = '{"agents":[],"carbonCopies":[],"certifiedDeliveries":[],"editors":[],"inPersonSigners":[{"note":"","recipientId":"1","requireIdLookup":"false","roleName":"Signer 1","routingOrder":"1","status":"sent","hostEmail":"john.doe@docusign.com","hostName":"John Doe","signerName":"Fred Flintstone"}],"intermediaries":[],"recipientCount":"2","signers":[{"note":"","recipientId":"2","requireIdLookup":"false","roleName":"Signer 2","routingOrder":"1","status":"sent","email":"jane.doe@gmail.com","name":"Jane Doe"}]}';
        HttpResponse httpResponse = client.Get( client.BaseEndpointURL + 'accounts/someAccountID/envelopes/someEnvelopeID/recipients');   
		
		httpResponse = client.GetDocument( client.BaseEndpointURL + 'accounts/someAccountID/envelopes/someEnvelopeID/recipients');  
		
		Account acct = new Account();
        acct.Name = 'test';
        insert acct;
		
		Contact con = new Contact();
		con.FirstName = 'bob';
		con.LastName = 'jones';
		con.Email = 'bjones@bjones.io';
		con.AccountId = acct.Id;
		
		insert con;
		
		try{
			client.getTemplates();
		}catch(Exception ex){}
		
		try{
			client.getEnvelopeInformation('x');
		}catch(Exception ex){}
		
		try{
			client.getRecipientStatus('x');
		}catch(Exception ex){}
		
		try{
			client.getDocuments('x');
		}catch(Exception ex){}
		
		try{
			client.downloadDocument('x',con.Id,'5555');
		}catch(Exception ex){}
		
		
		
		
		
    }
    
    public static testMethod void testRESTPost(){
        DSCredentials credentials = new DSCredentials();
        credentials.Username        = 'username';
        credentials.Password        = 'password';
        credentials.IntegratorKey   = 'key';
        
        DSClient client = new DSClient(credentials);
        
        string reqBody = '{"authenticationMethod":"email","returnUrl":"https://dsfs.na7.visual.force.com/apex/dsfs__docusign_signnowdone?DSEID=dseid&envelopeId=envId&event=Sent&signNow=1&SourceID=sourceid","recipientId":"1","email":"jane.doe@gmail.com","userName":Jane Doe"}';
        client.testResponseData = '{"url":"https://test1.docusign.net/Member/StartInSession.aspx?t=fc1c34c2-23ac-44e0-b41c-136f3468b75d"}';
        HttpResponse httpResponse = client.Post(
                                                client.BaseEndpointURL + 'accounts/someAccountID/envelopes/someEnvelopeID/views/recipient.json',
                                                reqBody);
    }
    
    public static testMethod void requestDocumentSignatureTests(){
        Account acct = new Account();
        acct.Name = 'test';
        insert acct;
		
		Contact con = new Contact();
		con.FirstName = 'bob';
		con.LastName = 'jones';
		con.Email = 'bjones@bjones.io';
		con.AccountId = acct.Id;
		
		insert con;
        
        Order__c order = new Order__c();
        order.Account__c = acct.Id;
        insert order;
        
        Order_Line_Item__c item = new Order_Line_Item__c();     
        item.Quantity__c = 2;
        item.Order__c = order.Id;
        item.Price__c = 100.0;
        insert item;
        
        DSCredentials credentials = new DSCredentials();
        credentials.Username = 'name@domain.com';
        credentials.Password = 'password';
        credentials.IntegratorKey = 'key';
        
        DSLoginInformation loginInfo = new DSLoginInformation();
        loginInfo.accountId = '12345';
        loginInfo.baseUrl = 'https://demo.docusign.net';
        loginInfo.email = 'name@domain.com';
        loginInfo.name = 'test';
        
        DSClient client = new DSClient(credentials);
        client.LoginInfo = loginInfo;               
        
        DSSignatureRequest request = new DSSignatureRequest(DSSignatureRequest.DocumentSource.DOCUMENT);
        request.emailSubject    = 'subject';
        request.emailBlurb      = 'blurb';
        
        DSDocument doc = new DSDocument();
        doc.name    = 'testOrder.pdf';
        doc.sobjectId = order.Id;
        doc.apexPathURL = '/apex/ordertemplate';
        request.documents.add(doc);
        
        DSSignatureResult result = client.requestSignature(request);
		
		/*DSClient client = new DSClient(credentials);
        client.LoginInfo = loginInfo;               */
        DSSignatureRequest requestA = new DSSignatureRequest(DSSignatureRequest.DocumentSource.TEMPLATE);
		result = client.requestSignature(request);
        /*request.emailSubject    = parms.DocuSign_Email_Subject__c;//'Docusign ';
        request.emailBlurb      = parms.DocuSign_Email_Blurb__c;//'Blurb';
        request.templateId = parms.DocuSign_Template_Id__c;//'6544805E-28D7-4F3F-BEB5-BF2A7D6410C1';   */
		
		
    }   
	
	public static testMethod void requestDocumentSignatureTestsB(){
        Account acct = new Account();
        acct.Name = 'test';
        insert acct;
		
		Contact con = new Contact();
		con.FirstName = 'bob';
		con.LastName = 'jones';
		con.Email = 'bjones@bjones.io';
		con.AccountId = acct.Id;
		
		insert con;
        
        Order__c order = new Order__c();
        order.Account__c = acct.Id;
        insert order;
        
        Order_Line_Item__c item = new Order_Line_Item__c();     
        item.Quantity__c = 2;
        item.Order__c = order.Id;
        item.Price__c = 100.0;
        insert item;
        
        DSCredentials credentials = new DSCredentials();
        credentials.Username = 'name@domain.com';
        credentials.Password = 'password';
        credentials.IntegratorKey = 'key';
        
        DSLoginInformation loginInfo = new DSLoginInformation();
        loginInfo.accountId = '12345';
        loginInfo.baseUrl = 'https://demo.docusign.net';
        loginInfo.email = 'name@domain.com';
        loginInfo.name = 'test';
        
        DSClient client = new DSClient(credentials);
        client.LoginInfo = loginInfo;               
        
        DSSignatureRequest request = new DSSignatureRequest(DSSignatureRequest.DocumentSource.TEMPLATE);
        request.emailSubject    = 'subject';
        request.emailBlurb      = 'blurb';
        
        DSDocument doc = new DSDocument();
        doc.name    = 'testOrder.pdf';
        doc.sobjectId = order.Id;
        doc.apexPathURL = '/apex/ordertemplate';
        request.documents.add(doc);
        
        DSSignatureResult result = client.requestSignature(request);
		
		
		
		
    }   
}