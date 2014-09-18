public class MyController {

	//this is a comment
    private final Account account;
	public String theValue {get;Set;}
	
    public MyController() {
        string beStart = '';
        account = [SELECT Description, Type, Id, Name, Site FROM Account 
                   WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
        system.debug('******** stop bebugging');
        string accountName = account.Name;
        string accountType = account.Type;
		string accountType2 = account.Type;
        string legalType = getLegalType(account.Type);
        account.Description = 'Legal Type: ' + legalType;
        string status = 'ready';
		
		theValue = 'Test value';
    }

    public Account getAccount() {
		//just return the account;
        return account;
    }
    
    private string getLegalType(string type){
     	return 'LLC';   
    }

    public PageReference save() {
        update account;
        return null;
    }
    
}