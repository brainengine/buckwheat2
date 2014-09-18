public class BuildManagement{
     
	public List<Account> rates {get; set;}
	
    //test class 99999999999999999999999
	//
	//comment
	public static void processNewBuilds(BE_Builds__c[] builds){
		
		 CaseTeamRole caseTeamRoleA = [ SELECT Id FROM CaseTeamRole limit 1];
		
		
		String orgId = UserInfo.getOrganizationId();	
		List<List<Set<Integer> > > my_list_2 = new List<List<Set<Integer> > >();
		
		
		
		String p = UserINfo.getDefaultCurrency();
		Messaging.SendEmailResult result;
		
		Messaging.SendEmailError errors; 
		Messaging.Inboundemail.Header pp;
		Messaging.Email mm;
		messaging.Emailattachment a;
		
		Messaging.Emailfileattachment file = new messaging.Emailfileattachment();
		Messaging.SendEmailResult resultA;
		Messaging.SendEmailError errorr;// = new messaging.SendEmailError();
		
		Messaging.InboundEmailResult er = new Messaging.InboundEmailResult();
		Messaging.inboundEmail  eer = new Messaging.inboundEmail ();
		Messaging.InboundEnvelope  eeer = new Messaging.InboundEnvelope ();
		
		Messaging.inboundEmail.header  eerr = new Messaging.inboundEmail.header();
		Messaging.inboundEmail.BinaryAttachment  ederr = new Messaging.inboundEmail.BinaryAttachment();
		Messaging.inboundEmail.TextAttachment  eeffrr = new Messaging.inboundEmail.TextAttachment ();
		
		Crypto c = new Crypto();
		
		blob b;
		decimal d;
		
		List<Integer> myList = new List<Integer>();
		Set<Integer> mySet = new Set<Integer>();
		Map<Integer,Integer> myMap = new Map<Integer,Integer>();
		
		
		System.debug('');
		for (BE_Builds__c bld:builds){
			if(bld.Description__c == null){
				bld.Description__c = 'Build created automatically through integration';
				//System.debug('Description Updated');//
			}
		}
	}
	
	public string createContact(string fName, string lName, string emailAddr){
	
		return '';
		
	}
	
	private string createInternalContact(string fName){
	
		return '';
		
	}
    
	
    
    //sample test class
	static testMethod void testNewBuilds() {
		
		string pp = '';
		if (pp == 'GUEST') {
            throw new System.NoAccessException();
        }
		
		BE_Builds__c newBuild = new BE_Builds__c();
                                                 
        //create a sample build
        newBuild.Active__c = true;
               
		//insert new build
		insert newBuild;
		
		try{
			
		}catch(exception e){}
		
	}
                                          
    //sample test class
    static testMethod void testCodeComplete() {
		
        //test array of objects
        contact[] contacts = [SELECT Id, Name, Department FROM contact limit 10];    
        for (contact con:contacts){
             //loop through contact here
            
        }
                
		//insert new build
		update contacts;
            

		
	}

}