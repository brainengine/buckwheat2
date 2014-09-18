/*
 * DSTab.cls
 *
 */
public with sharing class DSTab implements DSSerializeable {
	public string name			= 'Sign here';
	public string value			= '';
	public string tabId			= '1';
	public string tabLabel		= '';
	
	public string documentId	= '1';
	public integer pageNumber	= 1;
	public string recipientId	= '';
	public integer xPosition	= 0;
	public integer yPosition	= 0;
	public string scaleValue	= '1.0';
	
	public boolean useAnchorProperties = false;
	public string anchorUnits	= 'pixels';
	public integer anchorXOffset=0;
	public integer anchorYOffset=0;
	public string anchorString	= '';
	
	public boolean bold			= false;
	public boolean italic		= false;
	public boolean underline	= false;
	public string font			= 'arial';
	public string fontColor		= null;
	public string fontSize		= null;
		
	public DSTabType tabType 	= DSTabType.SIGN_HERE;
    
	public enum DSTabType {SIGN_HERE, INITIAL_HERE, FULL_NAME, EMAIL, TEXT, TITLE, COMPANY, DATESIGNED}
   
    public JSONGenerator serialize(JSONGenerator gen){
    	gen.writeStartObject();
    	gen.writeStringField('name', this.name);
    	gen.writeStringField('tabId', this.tabId);
    	gen.writeStringField('tabLabel', this.tabLabel);
		gen.writeStringField('recipientId', this.recipientId);
		
		gen.writeStringField('anchorIgnoreIfNotPresent', 'false');
    	
    	if(this.useAnchorProperties){
    		gen.writeStringField('anchorUnits', this.anchorUnits );
    		gen.writeStringField('anchorXOffset', String.valueOf(this.anchorXOffset) );
    		gen.writeStringField('anchorYOffset', String.valueOf(this.anchorYOffset) );
    		gen.writeStringField('anchorString', this.anchorString );
    	}
    	else{
	    	gen.writeStringField('documentId', this.documentId);
	    	gen.writeStringField('pageNumber', String.valueOf(this.pageNumber));
	    	gen.writeStringField('xPosition', String.valueOf(this.xPosition));
	    	gen.writeStringField('yPosition', String.valueOf(this.yPosition));
    	}
    	gen.writeBooleanField('bold', this.bold);
    	
    	gen.writeEndObject();
    	return gen;
    }
    
	private static testMethod void tests(){
		DSTab tab = new DSTab();
		System.assertEquals('1', tab.documentId);
		System.assertEquals(1, tab.pageNumber);
		System.assertEquals(DSTabType.SIGN_HERE, tab.tabType);
		
		tab.name 		= 'test tab';
		tab.tabId 		= 'id';
		tab.tabLabel	= 'tab label';
		
		JSONGenerator gen = JSON.createGenerator(false);
		gen = tab.serialize(gen);
		System.assertEquals('{"name":"test tab","tabId":"id","tabLabel":"tab label","documentId":"1","pageNumber":"1","xPosition":"0","yPosition":"0","bold":false}', 
			gen.getAsString());
		
		tab.useAnchorProperties = true;
		tab.anchorString = 'signature';
		gen = JSON.createGenerator(false);
		gen = tab.serialize(gen);
		System.assertEquals('{"name":"test tab","tabId":"id","tabLabel":"tab label","anchorUnits":"pixels","anchorXOffset":"0","anchorYOffset":"0","anchorString":"signature","bold":false}', 
			gen.getAsString());
	}
}