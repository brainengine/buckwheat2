/*
 * DSTemplateRole.cls
 *
 */
global with sharing class DSTemplateRole implements DSSerializeable{
	public string email;
	public string name;
	public string roleName;
	public List<DSTab> tabs = new List<DSTab>();
	
	public DSTemplateRole(){}
	
	public DSTemplateRole(string inputEmail, string inputName, string inputRoleName){
		this.email 		= inputEmail;
		this.name		= inputName;
		this.roleName 	= inputRoleName;
	}
	
	public JSONGenerator serialize(JSONGenerator gen){
		gen.writeStartObject();
		gen.writeStringField('email', this.email);
		gen.writeStringField('name', this.name);		
		gen.writeStringField('roleName', this.roleName);
		gen = this.serializeTabs(gen);
		gen.writeEndObject();
		return gen;
	}
	
	private JSONGenerator serializeTabs(JSONGenerator gen){
		if(this.tabs.size() == 0){
			return gen;
		}
		gen.writeFieldName('tabs');
		gen.writeStartObject();
		
		gen = this.serializeTab(gen, DSTab.DSTabType.SIGN_HERE, 'signHereTabs');
		gen = this.serializeTab(gen, DSTab.DSTabType.INITIAL_HERE, 'initialHereTabs');
		gen = this.serializeTab(gen, DSTab.DSTabType.FULL_NAME, 'fullNameTabs');
		gen = this.serializeTab(gen, DSTab.DSTabType.EMAIL, 'emailTabs');
		gen = this.serializeTab(gen, DSTab.DSTabType.TEXT, 'textTabs');
		gen = this.serializeTab(gen, DSTab.DSTabType.TITLE, 'titleTabs');
		gen = this.serializeTab(gen, DSTab.DSTabType.COMPANY, 'companyTabs');
		
		gen.writeEndObject();
		return gen;
	}
	
	private JSONGenerator serializeTab(JSONGenerator gen, DSTab.DSTabType tabType, string tabName){
		List<DSTab> tabList = this.getTabsByRole(tabType);
		if(tabList.size() > 0){
			gen.writeFieldName(tabName);
			gen.writeStartArray();
			for(DSTab t : tabList){
				gen = t.serialize(gen);
			}
			gen.writeEndArray();
		}
		return gen;
	}
	
	private List<DSTab> getTabsByRole( DSTab.DSTabType tabType){
		List<DSTab> result = new List<DSTab>();
		for(DSTab t : this.tabs){
			if(t.tabType == tabType){
				result.add(t);
			}
		}
		return result;
	}
	
	private static testMethod void serializeTests(){
		DSTemplateRole role = new DSTemplateRole();
		role.name 		= 'name';
		role.email 		= 'name@domain.com';		
		role.roleName 	= 'Signer';
		
		string expectedJSON = '{"email":"name@domain.com","name":"name","roleName":"Signer"}';
		JSONGenerator gen = JSON.createGenerator(false);
		gen = role.serialize(gen);
		string actualJSON = gen.getAsString();
		System.assertEquals(expectedJSON, actualJSON);
	}
	
	private static testMethod void persistenceTests(){
		DSTemplateRole role = new DSTemplateRole();
		role.email = 'foo';
		role.name = 'foo';
		role.roleName = 'foo';
		
		System.assertEquals('foo', role.email);
		System.assertEquals('foo', role.name);
		System.assertEquals('foo', role.roleName);
		
		role = new DSTemplateRole('name@domain.com', 'name', 'role name');
		System.assertEquals('name@domain.com', role.email);
		System.assertEquals('name', role.name);
		System.assertEquals('role name', role.roleName);
	}
}