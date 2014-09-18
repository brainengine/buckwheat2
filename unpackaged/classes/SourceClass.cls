public with sharing class SourceClass{
	
	//User information
	public string firstName {get;Set;}
	public string lastName {get;Set;}
	
	//address information
	public string streetName {get;Set;}
	public string city {get;Set;}
	public string state {get;Set;}
	public string zip {get;Set;}
	
	public String createPerson(String fName, String lName){
		return 	fName + ' ' + lName;
	}
	
	public String createNewAccount(){
		
		//make a sample call to the method
		createPerson('sam','jomes');
		return 	'Account created';
	}

}