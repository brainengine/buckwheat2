public with sharing class AgreementControllerExtension {
	private final Agreement__c m_agreement;
	
	public AgreementControllerExtension(ApexPages.StandardController stdController) {
		this.m_agreement = (Agreement__c)stdController.getRecord();
	}
}