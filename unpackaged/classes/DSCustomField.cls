/*
 * DSCustomField.cls
 *
 *
 */
global with sharing class DSCustomField {
	public string name;
	public string value;
	public boolean show		= false;
	public boolean required	= false;
	public DSCustomFieldType fieldType = DSCustomFieldType.TEXT_FIELD;
	public List<string> listItems = new List<string>();
	
	public enum DSCustomFieldType {TEXT_FIELD, LIST_FIELD}
	
	public DSCustomField(){}
	
	public DSCustomField(string inputName, string inputValue){
		this.name = inputName;
		this.value = inputValue;
	}
	
	public JSONGenerator serialize(JSONGenerator gen){
		gen.writeStartObject();
		gen.writeStringField('name', this.name);
		gen.writeStringField('value', this.value);
		gen.writeBooleanField('show', this.show);
		gen.writeBooleanField('required', this.required);
		
		if(this.fieldType == DSCustomFieldType.LIST_FIELD){
			if(this.listItems.size() == 0){
				throw new DSException('LIST_MISSING_ITEMS: DSCustomField of type LIST_FIELD requires at least one list item in collection.');
			}
			gen.writeFieldName('listItems');
			gen.writeStartArray();
			string items = '';
			for(string li : this.listItems){
				items += li + ',';
			}
			
			if(items.endsWith(',')){
				items = items.substring(0, items.length() - 1);
			}
			
			gen.writeString(items);
			gen.writeEndArray();
		}
		
		gen.writeEndObject();
		return gen;
	}
		
	private static testMethod void persistenceTests(){
		DSCustomField field = new DSCustomField();
		field.name = 'foo';
		field.show = true;
		field.required = true;
		field.value = 'foo';
		
		System.assertEquals('foo', field.name);
		System.assertEquals('foo', field.value);
		System.assertEquals(true, field.show);
		System.assertEquals(true, field.required);
		System.assertEquals(DSCustomFieldType.TEXT_FIELD, field.fieldType);
		System.assertEquals(0, field.listItems.size());
		
		field = new DSCustomField('n', 'v');
		field.fieldType = DSCustomFieldType.LIST_FIELD;
		field.listItems.add('item1');
		field.listItems.add('item2');
		System.assertEquals('n', field.name);
		System.assertEquals('v', field.value);
		System.assertEquals(false, field.show);
		System.assertEquals(false, field.required);
		System.assertEquals(DSCustomFieldType.LIST_FIELD, field.fieldType);
		System.assertEquals(2, field.listItems.size());
	}
	
	private static testMethod void serializeTests(){
		DSCustomField field = new DSCustomField();
		field.name = 'foo';
		field.value = 'foo';
		field.show = true;
		field.required = true;
		
		string expectedJSON = '{"name":"foo","value":"foo","show":true,"required":true}';
		JSONGenerator gen = JSON.createGenerator(false);
		gen = field.serialize(gen);
		string actualJSON = gen.getAsString();
		System.assertEquals(expectedJSON, actualJSON);
		
		field.fieldType = DSCustomFieldType.LIST_FIELD;
		field.listItems.add('item1');
		field.listItems.add('item2');
		field.listItems.add('item3');
		
		expectedJSON = '{"name":"foo","value":"foo","show":true,"required":true,"listItems":["item1,item2,item3"]}';
		
		gen = JSON.createGenerator(false);
		gen = field.serialize(gen);
		actualJSON = gen.getAsString();
		System.assertEquals(expectedJSON, actualJSON);
	}
	
	private static testMethod void validationTests(){
		DSCustomField field = new DSCustomField('n', 'v');
		field.fieldType = DSCustomFieldType.LIST_FIELD;
		
		boolean exceptionThrown = false;
		try{
			field.serialize(JSON.createGenerator(false));	
		}
		catch(DSException ex){
			exceptionThrown = true;
		}
		System.assertEquals(true, exceptionThrown);
	}
}