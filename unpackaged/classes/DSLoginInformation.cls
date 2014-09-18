/*
 * DSLoginInformation.cls
 *
 */
global class DSLoginInformation {
	public string accountId;
	public string baseUrl;
	public string email;
	public string isDefault;
	public string name;
	public string siteDescription;
	public string userId;
	public string userName;
	public boolean hasError = true;
	public string errorMessage = '';
	
	public static DSLoginInformation deserialize(HttpResponse httpResponse){
		DSLoginInformation loginInfoResult = new DSLoginInformation();
		
		try{
			LoginInformationResult result = (LoginInformationResult) JSON.deserialize(httpResponse.getBody(), 
									LoginInformationResult.class);
			if( result == null || 
				result.loginAccounts == null ||
				result.loginAccounts.size() == 0){
					loginInfoResult.hasError = true;
					loginInfoResult.errorMessage = 'Failed to deserialize JSON response from call to login_information';
					return loginInfoResult;
			}
			
			for(DSLoginInformation loginInfo : result.loginAccounts){
				if(loginInfo.isDefault.toLowerCase() == 'true'){
					loginInfoResult = loginInfo;
					loginInfoResult.hasError = false;
					break;
				}
			}
			
			if(loginInfoResult.hasError){
				loginInfoResult.errorMessage = 'At least 1 login account must be flagged as isDefault';
			}
		}
		catch(System.JSONException ex){
			loginInfoResult.hasError = true;
			loginInfoResult.errorMessage = 'JSON Parsing error deserializing Login Information: ' + ex.getMessage();
			return loginInfoResult;
		}
		return loginInfoResult;
	}
	
	private class LoginInformationResult{
		public string apiPassword;
		public List<DSLoginInformation> loginAccounts;
	}
	
	private static testMethod void basicGetSetTests(){
		DSLoginInformation info = new DSLoginInformation();
		info.accountId 	= 'foo';
		info.baseUrl 	= 'foo';
		info.email 		= 'foo';
		info.isDefault 	= 'foo';
		info.name 		= 'foo';
		info.siteDescription = 'foo';
		info.userId 	= 'foo';
		info.userName 	= 'foo';
		info.errorMessage = 'foo';
		info.hasError  	= true;
		System.assertEquals('foo', info.accountId);
		System.assertEquals('foo', info.baseUrl);
		System.assertEquals('foo', info.email);
		System.assertEquals('foo', info.isDefault);
		System.assertEquals('foo', info.name);
		System.assertEquals('foo', info.siteDescription);
		System.assertEquals('foo', info.userId);
		System.assertEquals('foo', info.userName);
		System.assertEquals('foo', info.errorMessage);
		System.assert(info.hasError);
		
		LoginInformationResult response = new LoginInformationResult();
		response.apiPassword = 'foo';
		System.assertEquals('foo', response.apiPassword);
		response.loginAccounts = new List<DSLoginInformation>();
		response.loginAccounts.add(info);
		System.assertEquals(1, response.loginAccounts.size());
	}
	
	private static testMethod void deserializationTests(){
		HttpResponse testResponse = new HttpResponse();
		DSLoginInformation nullLoginInfo = (DSLoginInformation)DSLoginInformation.deserialize(testResponse);
		System.assertEquals(true, nullLoginInfo.hasError);
		
		testResponse.setBody(TEST_DATA);
		LoginInformationResult loginResponse = (LoginInformationResult) JSON.deserialize(testResponse.getBody(), 
									LoginInformationResult.class);
		System.assertNotEquals(null, loginResponse);
		System.assertEquals('super-secret-password', loginResponse.apiPassword);
		System.assertNotEquals(null, loginResponse.loginAccounts);
		System.assertEquals(2, loginResponse.loginAccounts.size());
		System.assertEquals('654321', loginResponse.loginAccounts[0].accountId);
		System.assertEquals('12345678-82a2-4d6c-891c-f2f667654321', loginResponse.loginAccounts[0].userId);
		
		System.assertEquals('123456', loginResponse.loginAccounts[1].accountId);
		System.assertEquals('12345678-82a2-4d6c-891c-f2f661234567', loginResponse.loginAccounts[1].userId);
		
		DSLoginInformation loginInfo = (DSLoginInformation)DSLoginInformation.deserialize(testResponse);
		System.assertEquals(false, loginInfo.hasError);
		System.assertEquals('123456', loginInfo.accountId);
		System.assertEquals('https://demo.docusign.net/restapi/v2/accounts/123456', loginInfo.baseUrl);
		System.assertEquals('user@domain.com', loginInfo.email);
		System.assertEquals('true', loginInfo.isDefault);
		System.assertEquals('DocuSign', loginInfo.name);
		System.assertEquals('', loginInfo.siteDescription);
		System.assertEquals('12345678-82a2-4d6c-891c-f2f661234567', loginInfo.userId);
		System.assertEquals('First Last', loginInfo.userName);
		//LoginInformationResult r = (LoginInformationResult)DSLoginInformation.deserialize(testResponse);
		
		testResponse.setBody('{"foo":"bad');
		DSLoginInformation badLoginInfo = (DSLoginInformation)DSLoginInformation.deserialize(testResponse);
		System.assertEquals(true, badLoginInfo.hasError);
		
		testResponse.setBody('{}');
		badLoginInfo = (DSLoginInformation)DSLoginInformation.deserialize(testResponse);
		System.assertEquals(true, badLoginInfo.hasError);
		
		testResponse.setBody(TEST_DATA_NO_DEFAULT);
		badLoginInfo = (DSLoginInformation)DSLoginInformation.deserialize(testResponse);
		System.assertEquals(true, badLoginInfo.hasError);	
	}
	
	private static string TEST_DATA = '{' + 
	  '"apiPassword": "super-secret-password",' +
	  '"loginAccounts": [' +
	    '{' +
	      '"accountId": "654321",' +
	      '"baseUrl": "https://demo.docusign.net/restapi/v2/accounts/654321",' +
	      '"email": "user@domain.com",' +
	      '"isDefault": "false",' +
	      '"name": "DocuSign",' +
	      '"siteDescription": "",' +
	      '"userId": "12345678-82a2-4d6c-891c-f2f667654321",' +
	      '"userName": "First Last"' +
	    '},' +
	    '{' +
	      '"accountId": "123456",' +
	      '"baseUrl": "https://demo.docusign.net/restapi/v2/accounts/123456",' +
	      '"email": "user@domain.com",' +
	      '"isDefault": "true",' +
	      '"name": "DocuSign",' +
	      '"siteDescription": "",' +
	      '"userId": "12345678-82a2-4d6c-891c-f2f661234567",' +
	      '"userName": "First Last"' +
	    '}' +
	  ']' +
	'}';
	
	private static string TEST_DATA_NO_DEFAULT = '{' + 
	  '"apiPassword": "super-secret-password",' +
	  '"loginAccounts": [' +
	    '{' +
	      '"accountId": "654321",' +
	      '"baseUrl": "https://demo.docusign.net/restapi/v2/accounts/654321",' +
	      '"email": "user@domain.com",' +
	      '"isDefault": "false",' +
	      '"name": "DocuSign",' +
	      '"siteDescription": "",' +
	      '"userId": "12345678-82a2-4d6c-891c-f2f667654321",' +
	      '"userName": "First Last"' +
	    '}' +
	  ']' +
	'}';
}