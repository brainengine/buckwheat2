trigger beforeInsert on Account bulk (before insert) {
	
	public List <Account> dhsList = new List<Account>();
    public List <Account> accounts = new List <Account>();
    public List <Task> tasks = new List <Task>();
    public List <RecordType> recTypes = new List<RecordType>();
    public List <User> users = new List<User>();
    public List <Profile>profiles = new List<Profile>();

	//comment goes here
	private string pp;
	try{
		if (Trigger.isBefore) {
			for (Account a : Trigger.old) {
				
				if (a.Site == 'Houston') {
					a.addError('You can\'t delete this record!');
					
				
				} 
			}
			
		}
		   
	}catch(Exception ex){
		
	}

}