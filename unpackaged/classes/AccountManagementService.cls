public with sharing class AccountManagementService{

	//User information 99
	public string firstName {get;Set;}
	public string lastName {get;Set;}
	
	//address information
	public string streetName {get;Set;}
	public string city {get;Set;}
	public string state {get;Set;}
	public string zip {get;Set;}
	
	//address information
	public boolean inProcess {get;Set;}
	
	public String createAccountPerson(String fName, String lName, String email){
		//comment
		String fullName = firstName + ' ' + lastName;
		return 	fullName;
	}
	
	public String createNewAccount(){
		//address information
		//make a sample call to the method
		createAccountPerson('sam','jomes','');
		return 	'Account created';
	}

}