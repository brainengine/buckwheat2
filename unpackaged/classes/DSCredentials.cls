/*
 * DSCredentials.cls
 * Class structure for managing authentication credentials to the DocuSign REST API.
 * Optionally hard code credentials into this class or dynamically load them from
 * custom settings.
 *
 * TO CREATE DEVELOPER ACCOUNT CREDENTIALS
 * Visit http://www.docusign.com/developer-center
 */
global with sharing class DSCredentials {
	public string BaseURL		= 'https://demo.docusign.net/';
	public string Username  	= '';
	public string Password  	= '';
	public string IntegratorKey = '';
	
	public DSCredentials(){	
		if(this.Settings != null){
			this.BaseURL	= Settings.DocuSign_API_URL__c;
			this.Username	= Settings.DocuSign_Account_Email__c;
			this.Password	= Settings.DocuSign_Account_Password__c;
			this.IntegratorKey = Settings.DocuSign_Integrator_Key__c;
		}
	}
	
	public boolean areConfigured(){
		return this.Settings != null;
	}
	
	public string toXML(){
		return '<DocuSignCredentials>'+
			'<Username>' + this.Username + '</Username>'+
			'<Password>' + this.Password + '</Password>'+
			'<IntegratorKey>' + this.IntegratorKey + '</IntegratorKey>'+
			'</DocuSignCredentials>';
	}
	
	private DocuSign_SDK_Setting__c m_settings = null;
	private DocuSign_SDK_Setting__c Settings{
		get{
			if(m_settings == null){
				try{
					m_settings = [SELECT DocuSign_API_URL__c, DocuSign_Account_Email__c,DocuSign_Account_Password__c,DocuSign_Integrator_Key__c 
								  FROM DocuSign_SDK_Setting__c 
								  LIMIT 1];
				}
				catch(Exception ex){
					return null;
				}
			}
			return m_settings;
		}
	}
	
	private static testMethod void persistenceTests(){
		DSCredentials credentials = new DSCredentials();
		credentials.BaseURL	 = 'https://demo.docusign.net';
		credentials.Username = 'zzz';
		credentials.Password = 'yyy';
		credentials.IntegratorKey = 'aaa';
		
		System.assertEquals('https://demo.docusign.net', credentials.BaseURL);
		System.assertEquals('zzz', credentials.Username);
		System.assertEquals('yyy', credentials.Password);
		System.assertEquals('aaa', credentials.IntegratorKey);
		System.assert(credentials.toXML().contains('zzz') && credentials.toXML().contains('yyy'));
	}
	
	private static testMethod void settingTests(){
		DSCredentials credentials = new DSCredentials();
		System.assertEquals(null, credentials.Settings);
		System.assert(credentials.areConfigured() == false);
		
		DocuSign_SDK_Setting__c setting = new DocuSign_SDK_Setting__c();
		setting.Name						= 'DeveloperAccount';
		setting.DocuSign_API_URL__c			= 'https://demo.docusign.net';
		setting.DocuSign_Account_Email__c	= 'name@domain.com';
		setting.DocuSign_Account_Password__c = 'password';
		setting.DocuSign_Integrator_Key__c	= 'DOCU-key';
		insert setting;
		
		System.assertNotEquals(null, credentials.Settings);
		System.assert(credentials.areConfigured() == true);
		
		credentials = new DSCredentials();
		System.assert(credentials.areConfigured() == true);
	}
}