trigger PromoCodesTrigger on Promo_Codes__c bulk (before insert) {
	
	
		try{
				for (Promo_Codes__c c : Trigger.new) {
					Opportunity oppty;
					Opportunity newOppty;
					oppty = [Select Id, Name, CloseDate,  StageName from Opportunity where Id =:c.Template__c];
					newOppty = oppty.clone(false,true);
					newOppty.Name = newOppty.Name + ' - clone';
					insert(newOppty);
					system.debug('************* RUNNING newOppty if: ' + newOppty.Id);
					
					List<OpportunityLineItem> items = new List<OpportunityLineItem>();
		             for (OpportunityLineItem pi : [Select O.ServiceDate, O.Description, O.Id, O.ListPrice, O.OpportunityId, O.PricebookEntryId, O.Quantity, O.UnitPrice, O.SortOrder from OpportunityLineItem O where OpportunityId = :oppty.id]) {
		                 system.debug('************* FOUND RECORD: ' + pi.Id); 
						 OpportunityLineItem newPI = pi.clone(false,true);
						 system.debug('************* FOUND RECORD: ' + pi); 
		                 newPI.OpportunityId = newOppty.id;
		                 items.add(newPI);
		             }
		             insert items;
					
					c.Opportunity__c = newOppty.Id;
				}
		}catch(Exception e){
				system.debug('************* RUNNING SELECT RATE: ' + e.getMessage());
		}
}