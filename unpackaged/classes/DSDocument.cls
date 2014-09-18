/*
 * DSDocument.cls
 *
 */
public with sharing class DSDocument implements DSSerializeable {
	public string name;
	public integer documentId	= 1;
	public string apexPathURL; //Example: '/apex/ordertemplate'
	public string sobjectId;
	public List<string> errors	= new List<string>();
	
	public boolean isValid(){
		this.errors.clear();
		if(this.apexPathURL == null){
			this.errors.add('Missing apexPathURL');
		}
		if(this.sobjectId == null){
			this.errors.add('Missing sobjectId');
		}
		
		return this.errors.size() == 0;
	}
	
	public JSONGenerator serialize(JSONGenerator gen){
		gen.writeStartObject();
		gen.writeStringField('name', this.name);
		gen.writeStringField('documentId', String.valueOf(this.documentId));
		gen.writeEndObject();
		return gen;
	}
	
	private Blob m_binaryContent = null;
	public Blob binaryContent{
		get{
			if(m_binaryContent == null && this.isValid()){
				PageReference pageRef = new PageReference(this.apexPathURL);
	        	pageRef.getParameters().put('id',this.sobjectId);
	        	m_binaryContent = pageRef.getContentAsPDF();
			}
			return m_binaryContent;
		}
	}
	
	private string m_encodedContent = null;
	public string encodedContent{
		get{
			if(binaryContent != null){				
	        	return EncodingUtil.base64Encode(binaryContent);
			}
			else{
				return null;
			}
		}
	}
	
	public integer contentLength{
		get{
			if(encodedContent != null){
				return encodedContent.length();
			}
			else{
				return 0;
			}
		}
	}
	
	private static testmethod void tests(){
		DSDocument doc = new DSDocument();
		doc.name = 'test';
		System.assertEquals('test', doc.name);
		System.assertEquals(false, doc.isValid());
		
		JSONGenerator gen = JSON.createGenerator(false);		
		string EXPECTED_JSON = '{"name":"test","documentId":"1"}';
		System.assertEquals(EXPECTED_JSON, doc.serialize(gen).getAsString());
		
		System.assertEquals(null, doc.binaryContent);
		System.assertEquals(null, doc.encodedContent);
		System.assertEquals(0, doc.contentLength);
		
		Account acct = new Account();
		acct.Name = 'Test Account';
		insert acct;
				
		Order__c testOrder = new Order__c();
		testOrder.Account__c = acct.Id;
		insert testOrder;
		doc.sobjectId = testOrder.Id;
		doc.apexPathURL = '/apex/ordertemplate';
		System.assertNotEquals(null, doc.binaryContent);
		System.assertNotEquals(null, doc.encodedContent);
		System.assert(doc.contentLength > 0);	
	}
}