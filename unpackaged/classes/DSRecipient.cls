/*
 * DSRecipient.cls
 * 
 */
public with sharing class DSRecipient implements DSSerializeable {
	public enum DSRecipientRole {SIGNER, IN_PERSON_SIGNER, EDITOR, AGENT, INTERMEDIARY, CARBON_COPY}
	public DSRecipientRole role = DSRecipientRole.SIGNER;
	
	// Used by all roles
	public string email			= '';
	public string name			= '';
	public string recipientId 	= '1';
	
	// Variable use (enforced by validate() )	
	public string clientUserId	= '';
	public string routingOrder	= '';
	public string hostName		= '';
	
	public DSEmailNotification emailNotification;
	public DSSignatureInfo signatureInfo;
	public List<DSTab> tabs = new List<DSTab>();
		
	public JSONGenerator serialize(JSONGenerator gen){
		gen.writeStartObject();
		gen.writeStringField('email', this.email);
		gen.writeStringField('name', this.name);
		gen.writeStringField('recipientId', this.recipientId);
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
	
	private static testMethod void tests(){
		DSRecipient recipient = new DSRecipient();
		recipient.name	= 'First Last';
		recipient.email = 'name@domain.com';
		System.assertEquals('name@domain.com', recipient.email);
		System.assertEquals(DSRecipientRole.SIGNER, recipient.role);
		
		recipient.tabs.add(new DSTab());
		System.assertEquals(1, recipient.tabs.size());
		
		JSONGenerator gen = JSON.createGenerator(false);
		string EXPECTED_JSON = '{"email":"name@domain.com","name":"First Last","recipientId":"1","tabs":{"signHereTabs":[{"name":"Sign here","tabId":"1","tabLabel":"","documentId":"1","pageNumber":"1","xPosition":"0","yPosition":"0","bold":false}]}}';
		System.assertEquals(EXPECTED_JSON, recipient.serialize(gen).getAsString());
	}
}