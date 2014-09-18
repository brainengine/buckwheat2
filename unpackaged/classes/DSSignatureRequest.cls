/*
 * DSSignatureRequest.cls
 * 
 * Structured class passed to the DSClient.requestSignature() method.
 * Note: Currently does not support Tabs
 */
global with sharing class DSSignatureRequest implements DSSerializeable {
	public DocumentSource docSource				= DocumentSource.TEMPLATE;
	public string emailSubject;
	public string emailBlurb;
	public string templateId;
	public boolean createDraftOnly				= false;
	public List<DSDocument> documents			= new List<DSDocument>();
	public List<DSCustomField> customFields		= new List<DSCustomField>();
	public List<DSTemplateRole> templateRoles	= new List<DSTemplateRole>();
	public List<DSRecipient> recipients			= new List<DSRecipient>();
	public List<string> errors					= new List<string>();
	
	public enum DocumentSource {TEMPLATE, DOCUMENT}
	
	public DSSignatureRequest(DocumentSource source){
		this.docSource = source;
	}
	
	public boolean isValid(){		
		this.errors.clear();
		if(this.emailSubject == null){
			this.errors.add('Missing emailSubject');
		}
		if(this.emailBlurb == null){
			this.errors.add('Missing emailBlurb');
		}
		if(this.docSource == DocumentSource.TEMPLATE){
			if(this.templateId == null){
				this.errors.add('Missing templateId');
			}
			if(this.templateRoles.size() == 0){
				this.errors.add('Missing a DSTemplateRole');	
			}
		}
		if(this.docSource == DocumentSource.DOCUMENT){
			if(this.documents.size() == 0){
				this.errors.add('Missing a DSDocument');
			}
			if(this.recipients.size() == 0){
				this.errors.add('Missing a DSRecipient');
			}
			for(DSDocument doc : this.documents){
				if(doc.name == null){
					this.errors.add('Document is missing name');
				}
			}
		}
		return this.errors.size() == 0;
	}
	
	public JSONGenerator serialize(JSONGenerator gen){
		gen.writeStartObject();
		gen.writeStringField('emailSubject', this.emailSubject);
		gen.writeStringField('emailBlurb', this.emailBlurb);
		gen.writeStringField('status', (this.createDraftOnly ? 'created':'sent') );
		
		if(this.docSource == DocumentSource.TEMPLATE){
			gen = this.serializeTemplate(gen);
		}
		else{
			gen = this.serializeDocuments(gen);
		}
		
		gen.writeEndObject();
		gen.close();
		return gen;
	}
	
	private JSONGenerator serializeTemplate(JSONGenerator gen){
		gen.writeStringField('templateId', this.templateId);
		
		gen = this.serializeCustomFields(gen);
		gen = this.serializeTemplateRoles(gen);
		gen = this.serializeRecipients(gen);
		
		return gen;
	}
	
	private JSONGenerator serializeDocuments(JSONGenerator gen){
		if(this.documents.size() == 0){
			throw new DSException('DSSignatureRequest requires at least one document when docSource=DOCUMENT');
			return gen;
		}
		
		gen.writeFieldName('documents');
		gen.writeStartArray();
		for(DSDocument doc : this.documents){
			gen.writeStartObject();
			gen.writeStringField('name', doc.name);
			gen.writeStringField('documentId', String.valueOf(doc.documentId));
			gen.writeEndObject();
		}
		gen.writeEndArray();
		
		gen = this.serializeCustomFields(gen);
		gen = this.serializeRecipients(gen);
		
		return gen;	
	}
	
	private JSONGenerator serializeCustomFields(JSONGenerator gen){
		if(this.customFields.size() == 0){
			return gen;
		}
		
		gen.writeFieldName('customFields');
		gen.writeStartObject();
		gen = this.serializeField(gen, DSCustomField.DSCustomFieldType.LIST_FIELD, 'listCustomFields');
		gen = this.serializeField(gen, DSCustomField.DSCustomFieldType.TEXT_FIELD, 'textCustomFields');
		gen.writeEndObject();
		return gen;
	}
	
	private JSONGenerator serializeField(JSONGenerator gen, DSCustomField.DSCustomFieldType fieldType, string fName){
		List<DSCustomField> fieldList = this.getFieldsByType(fieldType);
		if(fieldList.size() == 0){
			return gen;
		}
		gen.writeFieldName(fName);
		gen.writeStartArray();
		for(DSCustomField f : fieldList){
			gen = f.serialize(gen);
		}
		gen.writeEndArray();
		
		return gen;
	}
	
	private JSONGenerator serializeTemplateRoles(JSONGenerator gen){
		if(this.templateRoles.size() == 0){
			return gen;
		}
		gen.writeFieldName('templateRoles');
		gen.writeStartArray();
		for(DSTemplateRole role : this.templateRoles){
			gen = role.serialize(gen);
		}
		gen.writeEndArray();
		return gen;
	}
	
	private JSONGenerator serializeRecipients(JSONGenerator gen){
		if(this.recipients.size() == 0){
			//throw exception
			return gen;
		}
		gen.writeFieldName('recipients');
		gen.writeStartObject();
				
		gen = this.serializeRecipientRole(gen, DSRecipient.DSRecipientRole.SIGNER, 'signers');
		gen = this.serializeRecipientRole(gen, DSRecipient.DSRecipientRole.IN_PERSON_SIGNER, 'inPersonSigners');
		gen = this.serializeRecipientRole(gen, DSRecipient.DSRecipientRole.EDITOR, 'editors');
		gen = this.serializeRecipientRole(gen, DSRecipient.DSRecipientRole.AGENT, 'agents');
		gen = this.serializeRecipientRole(gen, DSRecipient.DSRecipientRole.INTERMEDIARY, 'intermediaries');
		gen = this.serializeRecipientRole(gen, DSRecipient.DSRecipientRole.CARBON_COPY, 'carbonCopies');
		
		gen.writeEndObject();
		return gen;
	}
	
	private JSONGenerator serializeRecipientRole(JSONGenerator gen, DSRecipient.DSRecipientRole roleType, string roleName){
		List<DSRecipient> recipientList = this.getRecipientsByRole(roleType);
		if(recipientList.size() > 0){
			gen.writeFieldName(roleName);
			gen.writeStartArray();
			for(DSRecipient r : recipientList){
				gen = r.serialize(gen);
			}
			gen.writeEndArray();
		}
		return gen;
	}
	
	private List<DSCustomField> getFieldsByType(DSCustomField.DSCustomFieldType fieldType){
		List<DSCustomField> result = new List<DSCustomField>();
		for(DSCustomField f : this.customFields){
			if(f.fieldType == fieldType){
				result.add(f);
			}
		}
		return result;
	}
	
	private List<DSRecipient> getRecipientsByRole( DSRecipient.DSRecipientRole role){
		List<DSRecipient> result = new List<DSRecipient>();
		for(DSRecipient r : this.recipients){
			if(r.role == role){
				result.add(r);
			}
		}
		return result;
	}
	
	private static testMethod void persistenceTests(){
		DSSignatureRequest request = new DSSignatureRequest(DocumentSource.TEMPLATE);
		request.emailBlurb = 'foo';
		request.emailSubject = 'foo';
		request.templateId = 'foo';
		
		System.assertEquals('foo', request.emailBlurb);
		System.assertEquals('foo', request.emailSubject);
		System.assertEquals(0, request.customFields.size());
		System.assertEquals(0, request.templateRoles.size());
	}
	
	private static testMethod void getFieldByTypeTests(){
		DSSignatureRequest request = new DSSignatureRequest(DocumentSource.TEMPLATE);
		request.customFields.add( new DSCustomField('name', 'value') );
		
		DSCustomField listField = new DSCustomField('name', 'value');
		listField.fieldType = DSCustomField.DSCustomFieldType.LIST_FIELD;
		listField.listItems.add('item1');
		listField.listItems.add('item2');
		request.customFields.add( listField );
		
		System.assertEquals(1, request.getFieldsByType(DSCustomField.DSCustomFieldType.LIST_FIELD).size() );
		System.assertEquals(1, request.getFieldsByType(DSCustomField.DSCustomFieldType.TEXT_FIELD).size() );
	}
	
	private static testMethod void getRecipientsByRoleTests(){
		DSSignatureRequest request = new DSSignatureRequest(DocumentSource.DOCUMENT);
		
		DSRecipient recipient = new DSRecipient();
		recipient.email = 'name@domain.com';
		recipient.name = 'First Last';
		request.recipients.add(recipient);		
		
		System.assertEquals(1, request.getRecipientsByRole(DSRecipient.DSRecipientRole.SIGNER).size() );
	}
	
	private static testMethod void serializeTests(){
		DSSignatureRequest request = new DSSignatureRequest(DocumentSource.TEMPLATE);
		request.emailSubject = 'please sign';
		request.emailBlurb = 'click here';
		request.templateId = 'template id';
		
		request.customFields.add( new DSCustomField('fname1', 'fvalue1') );
		request.customFields.add( new DSCustomField('fname2', 'fvalue2') );
		
		DSCustomField listField = new DSCustomField('fname3', 'fvalue3');
		listField.fieldType = DSCustomField.DSCustomFieldType.LIST_FIELD;
		listField.listItems.add('item1');
		listField.listItems.add('item2');
		listField.listItems.add('item3');
		request.customFields.add( listField );
		
		request.templateRoles.add( new DSTemplateRole('name@domain.com', 'name', 'Signer'));
		
		string expectedJSON = '{"emailSubject":"please sign","emailBlurb":"click here","status":"sent","templateId":"template id","customFields":{"listCustomFields":[{"name":"fname3","value":"fvalue3","show":false,"required":false,"listItems":["item1,item2,item3"]}],"textCustomFields":[{"name":"fname1","value":"fvalue1","show":false,"required":false},{"name":"fname2","value":"fvalue2","show":false,"required":false}]},"templateRoles":[{"email":"name@domain.com","name":"name","roleName":"Signer"}]}';
		JSONGenerator gen = JSON.createGenerator(false);
		gen = request.serialize(gen);
		System.assertEquals(expectedJSON, gen.getAsString());
		
		request = new DSSignatureRequest(DocumentSource.DOCUMENT);
		request.emailSubject = 'please sign';
		request.emailBlurb = 'click here';
		
		Account acct = new Account();
		acct.Name = 'Test Account';
		insert acct;
		
		Order__c testOrder = new Order__c();
		testOrder.Account__c = acct.Id;
		insert testOrder;
		DSDocument doc = new DSDocument();
		doc.name = 'testOrder.pdf';
		doc.sobjectId = testOrder.Id;
		doc.apexPathURL = '/apex/ordertemplate';
		
		request.documents.add(doc);
		
		DSRecipient recipient = new DSRecipient();
		recipient.email = 'name@domain.com';
		recipient.name = 'First Last';
		
		request.recipients.add(recipient);
		
		expectedJSON = '{"emailSubject":"please sign","emailBlurb":"click here","status":"sent","documents":[{"name":"testOrder.pdf","documentId":"1"}],"recipients":{"signers":[{"email":"name@domain.com","name":"First Last","recipientId":"1"}]}}';
		gen = JSON.createGenerator(false);
		gen = request.serialize(gen);
		System.assertEquals(expectedJSON, gen.getAsString());
	}
}