global  class DARTWizardContExt{
	
	//CLASS NEEDS TO BE CLEANED UP BIG TIME AND SOME LISTS COMBINED
	//NEED TO OUTPUT ERRORS/MESSAGES TO THE MESSAGES SECTION
	//NEED TO OUTPUT ERRORS/MESSAGES TO THE MESSAGES SECTION
	//NEED TO OUTPUT ERRORS/MESSAGES TO THE MESSAGES SECTION
	
	
	//NEED TO OUTPUT ERRORS/MESSAGES TO THE MESSAGES SECTION
	//NEED TO OUTPUT ERRORS/MESSAGES TO THE MESSAGES SECTION
	//NEED TO OUTPUT ERRORS/MESSAGES TO THE MESSAGES SECTION
	
	//NEED TO OUTPUT ERRORS/MESSAGES TO THE MESSAGES SECTION
	
	//****************
	//NEED TO OUTPUT ERRORS/MESSAGES TO THE MESSAGES SECTION
	//NEED TO OUTPUT ERRORS/MESSAGES TO THE MESSAGES SECTION
	//NEED TO OUTPUT ERRORS/MESSAGES TO THE MESSAGES SECTION
	//NEED TO OUTPUT ERRORS/MESSAGES TO THE MESSAGES SECTION
	
	public static final String  ACCESS_ERROR_MSG = 'You cannot access this page directly. Please go to the opportunity view page.';
    public static final String  NO_OPP_ERROR_MSG = 'Cannot find this opportunity.';
    public static final String  NO_PB_ERROR_MSG =  'Please choose a Pricebook before adding products to this opportunity.';
    public static final String  APPROVAL_IN_PROGESS_MSG = 'The approval status  is "In Progress" for this opportunity. You cannot make changes at this time.';
    public static final String  NO_PRODUCT_SELECTED_MSG = 'No product was seleted. Please select a product.';
    public static final String  APPROVAL_STATUS_IN_PROGRESS = 'In Progress';
    
	//TODO change this later
    //public static final String  ALL_PT = ProductPicker.ALL_PRODUCT_TYPES;         // All Product Families
    public static final String  ALL_LABEL = 'All';
    public static final String  NO_CONTRACT = 'No Contract (Any)';

    public String selectedProductId {get; set;}                   // Selected found product
    public String rowToEdit {get; set;}                       // The row to edit
    public String childComponentToEdit {get; set;}            // The child id to edit
    public String rowToDelete {get; set;}                     // The row to delete
    public String selectedProductType {get; set;}  			// Selected Product Family. Use in the product search
    
	public String selectedPrice { get; set; }           
	
	public String selectedFamilyType { get; set; }           
    public String selectedRateType {get; set;}
    public String selectedrequiredFeatureType {get; set;}
    public String selectedoptionalFeatureType {get; set;}
	
    public String selectedCategoryType {get; set;}
    public String selectedContractType { get; set; }
    public String selectedColorType { get; set; }
    public String selectedAdType { get; set; }
    public double selectedContractDiscount; //added to populate contract discount from related account (Vinay)
    public double selectedContractLevelDiscount{ get; set;} //added to populate text box on page (Ian)
	
	 public String selectedPriceBookName { get; set; }
	 public String fillerValue { get; set; }

    //public ProductPickerAppModel productPickerModel {get; private set;}
    public Boolean showMainFrame {get; private set;}           // Flag to render mainFrame
	
	public Boolean showNewDevices {get; private set;}           // Flag to render mainFrame
	public Boolean showUpgrades {get; private set;}           // Flag to render mainFrame

    public final Id opportunityId;                      //changed private to public      // Opportunity Id
    public Opportunity opportunity  { get; set; }                        //changed private to public      // Oportunity

    private String selectedPriceBookType;
    private List<SelectOption> typesItems;
    //private ProductPickerPermission__c permissions;
	
	public List<FeatureRateWrapper> rates {get; set;}
	public List<FeatureRateWrapper> selectedRates {get; set;}
	public List<FeatureRateWrapper> selectedFeatures {get; set;}
	public List<OpportunityLineItem> selectedAccessories {get; set;}
	
	private List<OpportunityLineItem> oLineItems;
	private List<PriceBookEntry> dartProducts;
	private List<PriceBookEntry> dartTempProducts;
	private List<PriceBookEntry> dartRates;
	private List<PriceBookEntry> dartFeatures;
	public List<ProductWrapper> selectedProducts { get; set; }
	public List<String> theList { get; set; }
	
	public String selectedRateDevice { get; set; }           
	public String selectedRatePlan { get; set; }           
	public String selectedRatePrice { get; set; }
	public String selectedRatePercent { get; set; }
	public String selectedRateLines { get; set; }
	public String selectedRateCode { get; set; }
	public String selectedRateComments { get; set; }
	public Boolean selectedRateFlag { get; set; }
	public List<FeatureRateWrapper> selectedFeaturesList {get; set;}  
	
	public String selectedFeatureDevice { get; set; }           
	public String selectedFeaturePlan { get; set; }           
	public String selectedFeaturePrice { get; set; }
	public String selectedFeaturePercent { get; set; }
	public String selectedFeatureLines { get; set; }
	public String selectedFeatureCode { get; set; }
	public String selectedFeatureComments { get; set; }	
	public String selectedRateFeatures { get; set; }	
	public String selectedDeleteFeature { get; set; }	
	public String selectedDeleteRate { get; set; }	
	
	public String selectedAccDesc { get; set; }	
	public double selectedAccSRP { get; set; }	
	public integer selectedAccUnits { get; set; }	
	
	public String selectedSearchText { get; set; }
	public String selectedSearchDevice { get; set; }
	public String selectedSearchBrand { get; set; }
	public String selectedSearchType { get; set; }
	public String selectedFeatureAddOn { get; set; }
	public String selectedRateAddOn { get; set; }
	public String selectedDeleteFeatureAddOn { get; set; }
	
	public String selectedProductQty {get; set;}            
	public boolean showRatePlans {get; set;}
	public boolean showFeaturePlans {get; set;}
	public boolean showAccessories {get; set;}
	public static boolean showInputs {get; set;}
	public String displaySystemNotice {get; set;}
	public String searchCount {get; set;} 
	public boolean selectedIsUpgrade {get; set;} 
	//public DARTDealMetricsModel model {get; set;} 
	
	
	private PricebookEntry entry;
	
	public boolean featureFlag {get; set;} 
	
	public boolean enterpriseFlag {get; set;} 
	public boolean isChannelSteering {get; set;} 
	
	
	private integer deviceIndex = 0;
	private integer rateIndex = 0;
	
	private string systemMessage = '';
	private string roleName = '';
	
	public DARTWizardContExt (ApexPages.StandardController stdController) {
		
		//get 
		string pricebookName = '';//System.Label.PriceBookName;
    	
		String opportunityIdString = stdController.getId();
		this.opportunity = (opportunity)stdController.getRecord();
		opportunityId = stdController.getId();
		showMainFrame =  true;
		
		isChannelSteering = true;
		/*roleName = getRoleName(UserInfo.getUserRoleId());
		if(roleName == 'Channel Steering'){
			isChannelSteering = true;
		}*/
		
		//process assumes that both new and upgrades are shown
		showNewDevices = true;	
		showUpgrades = true;
		
		if(opportunity.Type == 'New Line Acquisition Opportunity'){
			showNewDevices = true;	
			showUpgrades = false;
			
		}
		
		if(opportunity.Type == 'Retention/Renewal Opportunity'){
			showNewDevices = false;	
			showUpgrades = true;
		}
		
		featureFlag = true;
		
		//rates.add(new FeatureRateWrapper('PMR', '$19.99', '0%','','PMR50',''));
		
		soc_codeA = 'SMSUNL10';
		soc_codeB = 'ACE';
		displaySystemNotice ='0.00';
		showInputs = true;
		selectedRateFlag = true;
		enterpriseFlag = false;
		
		searchCount = '0';
		
		selectedAccUnits = 0;
		selectedAccSRP = 0.00;
		selectedAccDesc = '';
		
		//this is only used for testing
		selectedRates = new List<FeatureRateWrapper>();
		selectedProducts = new List<ProductWrapper>();
		selectedFeatures = new List<FeatureRateWrapper>();
		selectedAccessories = new List<OpportunityLineItem>();
		
		
		
		//model = new DARTDealMetricsModel();
		
		theList = new List<String>();
		theList.add('Buckwheat');
		theList.add('Spanky');
		
		selectedFeaturesList = new List<FeatureRateWrapper>();

		selectedSearchBrand = 'All';
		selectedSearchType = 'All';
		dartProducts = new List<PriceBookEntry>();
		dartProducts = [SELECT P.IsActive, P.CreatedById, P.CreatedDate, P.IsDeleted, P.LastModifiedById, P.LastModifiedDate, P.UnitPrice, P.Id, P.Pricebook2Id, P.Product2.Non_Discountable__c, 
								P.ProductCode, P.Product2Id, P.Product2.Image__c, P.Product2.Minimum_Price__c, P.Product2.Family, P.Product2.Id, P.Product2.Name, P.Product2.SOC__c, P.Product2.Product_Category__c,
								P.Product2.Product_Type__c, P.Product2.Standard_Price__c, P.Name, P.SystemModstamp, P.UseStandardPrice,  P.Pricebook2.Name, P.Product2.OEM__c,
								P.Product2.Acq_1_Year_Net_Director__c, P.Product2.Acq_1_Year_Net_Gov__c, P.Product2.Acq_1_Year_Net_Mgr__c, P.Product2.Acq_1_Year_Net_Rep__c, P.Product2.Acq_1_Year_Pos__c, 
								P.Product2.Acq_2_Year_Net_Director__c, P.Product2.Acq_2_Year_Net_Gov__c, P.Product2.Acq_2_Year_Net_Mgr__c, P.Product2.Acq_2_Year_Net_Rep__c, P.Product2.Acq_2_Year_Pos__c, P.Product2.Upgrade_1_Year_Price__c, P.Product2.Upgrade_2_year_price__c
								FROM PricebookEntry P
								WHERE  P.Pricebook2.Name = 'B2B Products'
								AND P.Product2.Family = 'Device' 
								AND P.Product2.Product_Type__c != 'License' 
								AND P.IsActive != false
								ORDER BY P.CreatedDate DESC ];
								//ORDER BY P.Name ASC ];
		
		//need to combine the following sql statements into one
		//need to combine the following sql statements into one
								
		dartRates = new List<PriceBookEntry>();
		dartRates = [SELECT P.IsActive, P.CreatedById, P.CreatedDate, P.IsDeleted, P.LastModifiedById, P.LastModifiedDate, P.UnitPrice, P.Id, P.Pricebook2Id, P.Product2.Non_Discountable__c, 
								P.ProductCode, P.Product2Id, P.Product2.Image__c, P.Product2.Minimum_Price__c, P.Product2.Family, P.Product2.Id, P.Product2.Name, P.Product2.SOC__c, P.Product2.Product_Category__c, P.Product2.OEM__c,
								P.Product2.Product_Type__c, P.Product2.Standard_Price__c, P.Name, P.SystemModstamp, P.UseStandardPrice,  P.Pricebook2.Name, 
								P.Product2.Acq_1_Year_Net_Director__c, P.Product2.Acq_1_Year_Net_Gov__c, P.Product2.Acq_1_Year_Net_Mgr__c, P.Product2.Acq_1_Year_Net_Rep__c, P.Product2.Acq_1_Year_Pos__c, 
								P.Product2.Acq_2_Year_Net_Director__c, P.Product2.Acq_2_Year_Net_Gov__c, P.Product2.Acq_2_Year_Net_Mgr__c, P.Product2.Acq_2_Year_Net_Rep__c, P.Product2.Acq_2_Year_Pos__c, P.Product2.Upgrade_1_Year_Price__c, P.Product2.Upgrade_2_year_price__c
								FROM PricebookEntry P
								WHERE  P.Pricebook2.Name = 'B2B Products'
								AND P.IsActive != false
								AND P.Product2.Family = 'Rate'
								ORDER BY P.Name ASC];
								
		dartFeatures = new List<PriceBookEntry>();
		dartFeatures = [SELECT P.IsActive, P.CreatedById, P.CreatedDate, P.IsDeleted, P.LastModifiedById, P.LastModifiedDate, P.UnitPrice, P.Id, P.Pricebook2Id, P.Product2.Non_Discountable__c, 
								P.ProductCode, P.Product2Id, P.Product2.Image__c, P.Product2.Minimum_Price__c, P.Product2.Family, P.Product2.Id, P.Product2.Name, P.Product2.SOC__c, P.Product2.Product_Category__c, P.Product2.OEM__c,
								P.Product2.Product_Type__c, P.Product2.Standard_Price__c, P.Name, P.SystemModstamp, P.UseStandardPrice,  P.Pricebook2.Name,
								P.Product2.Acq_1_Year_Net_Director__c, P.Product2.Acq_1_Year_Net_Gov__c, P.Product2.Acq_1_Year_Net_Mgr__c, P.Product2.Acq_1_Year_Net_Rep__c, P.Product2.Acq_1_Year_Pos__c, 
								P.Product2.Acq_2_Year_Net_Director__c, P.Product2.Acq_2_Year_Net_Gov__c, P.Product2.Acq_2_Year_Net_Mgr__c, P.Product2.Acq_2_Year_Net_Rep__c, P.Product2.Acq_2_Year_Pos__c, P.Product2.Upgrade_1_Year_Price__c, P.Product2.Upgrade_2_year_price__c
								FROM PricebookEntry P
								WHERE  P.Pricebook2.Name = 'B2B Products'
								AND P.IsActive != false
								AND P.Product2.Family = 'Feature'
								ORDER BY P.Name ASC];
		
		entry = [SELECT P.IsActive, P.CreatedById, P.CreatedDate, P.IsDeleted, P.LastModifiedById, P.LastModifiedDate, P.UnitPrice, P.Id, P.Pricebook2Id, P.Product2.Non_Discountable__c, 
								P.ProductCode, P.Product2Id, P.Product2.Image__c, P.Product2.Minimum_Price__c, P.Product2.Family, P.Product2.Id, P.Product2.Name, P.Product2.SOC__c, P.Product2.Product_Category__c, P.Product2.OEM__c,
								P.Product2.Product_Type__c, P.Product2.Standard_Price__c, P.Name, P.SystemModstamp, P.UseStandardPrice,  P.Pricebook2.Name,
								P.Product2.Acq_1_Year_Net_Director__c, P.Product2.Acq_1_Year_Net_Gov__c, P.Product2.Acq_1_Year_Net_Mgr__c, P.Product2.Acq_1_Year_Net_Rep__c, P.Product2.Acq_1_Year_Pos__c, 
								P.Product2.Acq_2_Year_Net_Director__c, P.Product2.Acq_2_Year_Net_Gov__c, P.Product2.Acq_2_Year_Net_Mgr__c, P.Product2.Acq_2_Year_Net_Rep__c, P.Product2.Acq_2_Year_Pos__c, P.Product2.Upgrade_1_Year_Price__c, P.Product2.Upgrade_2_year_price__c
								FROM PricebookEntry P
								WHERE  P.Pricebook2.Name = 'B2B Products'
								AND P.IsActive != false
								AND P.Product2.Family = 'Accessory' 
								LIMIT 1];
		
		 oLineItems = [Select O.ServiceDate, O.Feature__c, O.Image__c, O.index__c, O.IsUpgrade__c, O.Description, O.Id, O.ListPrice, O.Minimum_Price__c,  O.PricebookEntry.Product2Id, O.PricebookEntry.Name, O.Is_Promo_Code__c, O.Non_Discountable__c,
																O.OEM__c, O.OpportunityId, O.PricebookEntryId, O.Product_Category__c, O.Product_Family__c, O.Product_Type__c, O.Quantity, O.Percent__c, O.SOC_Code__c, O.Device__c, O.Device__r.Name, O.Price_Override__c, Rep_Price__c,
																O.Rate__c,  O.Rate__r.Name , O.UnitPrice, O.Standard_Price__c from OpportunityLineItem O
																WHERE  O.OpportunityId =:opportunityId
																ORDER BY O.Product_Family__c asc];
		
		//loop through the line items and set the caches
		for(OpportunityLineItem item: oLineItems){
			if(item.Product_Family__c == 'Accessory'){
				selectedAccessories.add(item);
			}
			
			if(item.Product_Family__c == 'Device'){
				
				ProductWrapper product = new ProductWrapper();
				product.index = deviceIndex;
				product.selected = false;
				product.isUpgrade = true;
				product.quantity =1;
				product.opptyLineItem = item;
				product.productId = item.PricebookEntry.Product2Id + '/' + String.valueOf(item.isUpgrade__c);
				product.productName = item.PricebookEntry.Name;
				if(item.isUpgrade__c){
					product.productName = item.PricebookEntry.Name + ' - Upgrade';
				}
				selectedProducts.add(product);
				system.debug('************* wrapper item added');
				showRatePlans = true;
				
				deviceIndex += 1;
				
			}
			
			if(item.Product_Family__c == 'Rate'){
				FeatureRateWrapper newItem = new FeatureRateWrapper();
				newItem.index = rateIndex;
				newItem.rateProductId = item.PricebookEntry.Product2Id;
				newItem.deviceId = item.Device__c;
				newItem.planId =item.PricebookEntry.Id;
				newItem.device = item.Device__r.Name; 
				
				if(item.isUpgrade__c){
					newItem.device = item.Device__r.Name + ' - Upgrade';
				}
				
				newItem.plan = item.PricebookEntry.Name;
				if(item.PricebookEntry.Name.Contains('Pool')){
					showInputs = false;
					if(item.PricebookEntry.Name.Contains('Small Business Pooling')){
						enterpriseFlag = true;
					}
				}
				
				newItem.IsUpgrade = item.isUpgrade__c;
				newItem.percentage = '0';
				newItem.lines = string.valueOf(item.Quantity);
				newItem.socCode = selectedRateCode;
				newItem.comments = selectedRateComments;
				newItem.features = selectedRateFeatures;
				newItem.productId = item.Device__c + '/' + String.valueOf(item.isUpgrade__c);
				newItem.productName = item.PricebookEntry.Name;
				newItem.ratesList = new List<SelectOption>();
				newItem.ratesList.add(new SelectOption('0','-- select --'));
				newItem.rateFeatures = new List<FeatureRateWrapper>();
				newItem.opptyLineItem = item;
				selectedRates.add(newItem);
				showRatePlans = true;
				
				rateIndex += 1;
				
			}
			
			if(item.Product_Family__c == 'Feature'){
				FeatureRateWrapper newItem = new FeatureRateWrapper();
				newItem.index = 0;
				newItem.deviceId = item.Device__c;
				newItem.featureId = item.PricebookEntry.Id;
				newItem.planId = '';
				newItem.featureName = item.PricebookEntry.Name;
				newItem.featureId = item.PricebookEntry.Id;
				newItem.lines = selectedRateLines;
				newItem.socCode = selectedRateCode;
				newItem.comments = selectedRateComments;
				newItem.features = selectedRateFeatures;
				newItem.productId = item.Device__c + '/' + String.valueOf(item.isUpgrade__c);
				newItem.productName = item.PricebookEntry.Name;
				newItem.ratesList = new List<SelectOption>();
				newItem.ratesList.add(new SelectOption('0','-- select --'));
				newItem.rateFeatures = new List<FeatureRateWrapper>();
				newItem.opptyLineItem = item;
				for(FeatureRateWrapper rate : selectedRates){
					//go find the assocaited rate
					if(rate.opptyLineItem.PricebookEntry.Name ==  item.Rate__r.Name){
						if(rate.opptyLineItem.PricebookEntry.Product2Id == item.Rate__c){
							if(rate.opptyLineItem.Device__r.Name == item.Device__r.Name){
								rate.rateFeatures.add(newItem);
							}
						}
					}
				}
			}
		}
		
		//calculate the percentages for rate plans
		calculatePercentages();
		 
		//calculate the dart details
		if((selectedProducts.size() > 0) || (selectedRates.size() > 0)){
			RefreshDetails(false);
			
			//set the value flags again
			ResetValueFlag();
		}
								
	}
	
	public List<PriceBookEntry> getRates(){
	
		dartRates = new List<PriceBookEntry>();
		dartRates = [SELECT P.IsActive, P.CreatedById, P.CreatedDate, P.IsDeleted, P.LastModifiedById, P.LastModifiedDate, P.UnitPrice, P.Id, P.Pricebook2Id, P.Product2.Non_Discountable__c, 
								P.ProductCode, P.Product2Id, P.Product2.Image__c, P.Product2.Minimum_Price__c, P.Product2.Family, P.Product2.Id, P.Product2.Name, P.Product2.SOC__c, P.Product2.Product_Category__c, P.Product2.OEM__c,
								P.Product2.Product_Type__c, P.Product2.Standard_Price__c, P.Name, P.SystemModstamp, P.UseStandardPrice,  P.Pricebook2.Name, 
								P.Product2.Acq_1_Year_Net_Director__c, P.Product2.Acq_1_Year_Net_Gov__c, P.Product2.Acq_1_Year_Net_Mgr__c, P.Product2.Acq_1_Year_Net_Rep__c, P.Product2.Acq_1_Year_Pos__c, 
								P.Product2.Acq_2_Year_Net_Director__c, P.Product2.Acq_2_Year_Net_Gov__c, P.Product2.Acq_2_Year_Net_Mgr__c, P.Product2.Acq_2_Year_Net_Rep__c, P.Product2.Acq_2_Year_Pos__c, P.Product2.Upgrade_1_Year_Price__c, P.Product2.Upgrade_2_year_price__c
								FROM PricebookEntry P
								WHERE  P.Pricebook2.Name = 'B2B Products'
								AND P.IsActive != false
								AND P.Product2.Family = 'Rate'
								ORDER BY P.Name ASC];
		
//		[SELECT P.IsActive, P.CreatedById, P.CreatedDate, P.IsDeleted, P.LastModifiedById, P.LastModifiedDate, P.UnitPrice, P.Id, P.Pricebook2Id, 
//								P.ProductCode, P.Product2Id, P.Product2.Image__c, P.Product2.Minimum_Price__c, P.Product2.Family, P.Product2.Id, P.Product2.Name, 
//								P.Product2.Product_Type__c, P.Product2.Standard_Price__c, P.Name, P.SystemModstamp, P.UseStandardPrice,  P.Pricebook2.Name, P.Product2.OEM__c
//								FROM PricebookEntry P
//								WHERE  P.Pricebook2.Name = 'B2B Products'
//								AND P.Product2.Family = 'Rate' 
//								LIMIT 10];
								
		return dartRates;
		
	}
	
	public List<PriceBookEntry> getFeatures(){
		return dartFeatures;
	}
	
	public List<PriceBookEntry> getProducts(){

		if((selectedSearchType == 'All') && (selectedSearchBrand == 'All') && ((selectedSearchText == null) || (selectedSearchText == ''))){
			searchCount = string.valueof(dartProducts.size());
			return dartProducts;
		}else{
			integer index = 0;
			dartTempProducts = new List<PricebookEntry>();
			for( PricebookEntry pbe : dartProducts){
				if((selectedSearchText == null) || (selectedSearchText == '')){
					boolean bDoAdd = false;
					if(selectedSearchBrand == 'All'){
						bDoAdd = true;
					}else{
						bDoAdd = false;
						if(pbe.Product2.OEM__c == selectedSearchBrand){
							bDoAdd = true;
						}
					}
					
					boolean bDoAddType = false;
					if(selectedSearchType == 'All'){
						bDoAddType = true;
					}else{
						bDoAddType = false;
						if(pbe.Product2.Product_Type__c == selectedSearchType){
							bDoAddType = true;
						}
					}
					
					if((bDoAdd) && (bDoAddType)){
						system.debug('************* GET items added');
						dartTempProducts.add(pbe);
					}
				}else{
					string tempName = pbe.Name;
					system.debug('************* GET PRODUCTS2: ' + tempName.toLowerCase());
					system.debug('************* GET PRODUCTS3: ' + selectedSearchText.toLowerCase());
					if(tempName.toLowerCase().contains(selectedSearchText.toLowerCase())){
						dartTempProducts.add(pbe);
					}
				}
				
			}
			searchCount = string.valueof(dartTempProducts.size());
			return dartTempProducts;
		}

	}
	
	    /*
        @return String
    */
    public String getOpportunityName(){ return opportunity.Name; }
	
	public Decimal getTotalAmount () {
        //return productPickerModel.getTotalAmount() ;
		return 0;
    }
	
	 public PageReference goBack(){
			PageReference pageRef = new PageReference('/' + opportunityId);
	 		return pageRef;
	 }
	
	/*
		@return Decimal
	*/
	public Decimal getGlobalDiscount (){
		//return opportunity.Global_Discount__c;
		return 0;
	}

	/*
		@param Decimal
	*/
	public void setGlobalDiscount ( Decimal discount ){
		//opportunity.Global_Discount__c = discount ;

	}
	
	public void deleteProduct () {
        //productPickerModel.deleteOliRowModel( rowToDelete );
		
    }
	
	 public List<SelectOption> familyTypes{
        get {
                if ( familyTypes == null ){
                	familyTypes = new List<SelectOption>{new SelectOption('PMR','PMR')};
                }
            return familyTypes;
        } 
        private set;
    }
	
	public List<SelectOption> rateTypes{
        get {
                if ( rateTypes == null ){
					rateTypes = new List<SelectOption>();
					for(PriceBookEntry pbe: dartRates){
						rateTypes.add(new SelectOption(pbe.Id,pbe.Name));
					}
                }
            return rateTypes;
        }
        private set;
    }
	
	public List<SelectOption> featurePrices{
        get {
                if ( featurePrices == null ){
                	featurePrices = new List<SelectOption>{new SelectOption('9.99','$9.99')};
                }
            return featurePrices;
        }
        private set;
    }
	
	public List<SelectOption> addFeatures{
        get {
                if ( addFeatures == null ){
                	addFeatures = new List<SelectOption>{new SelectOption('Unlimited Messaging','Unlimited Messaging')};
                }
            return addFeatures;
        }
        private set;
    }
	
	public List<SelectOption> requiredfeatureTypes{
        get {
                if ( requiredfeatureTypes == null ){
                	//requiredfeatureTypes = new List<SelectOption>{new SelectOption(ALL_PT,ALL_LABEL)};
                }
            return requiredfeatureTypes;
        }
        private set;
    }
	
	        /*
        Get all the Product Feature Select Options
        @return List<SelectOption>
    */
    public List<SelectOption> optionalfeatureTypes{
        get {
                if ( optionalfeatureTypes == null ){
                	//optionalfeatureTypes = new List<SelectOption>{new SelectOption(ALL_PT,ALL_LABEL)};
                }
            return optionalfeatureTypes;
        }
        private set;
    }
	
	public Decimal OperatingMargin {get; set;}        
	public String selectedRate {get; set;}  
	public String numberLines {get; set;}  
	public String comments {get; set;}  
	public string accessoriesSold {get; set;}  
	public string accessoryDiscount {get; set;}  
	public string additionalNotes {get; set;}  
	public string configurationlNotes {get; set;}  
	
	public string soc_codeA {get; set;}  
	public string soc_codeB {get; set;}  
	
	//wrapper for devices
	public class ProductWrapper{
		public integer index {get; set;}
		public boolean selected {get; set;}
		public PricebookEntry lineItem {get; set;}
		public OpportunityLineItem opptyLineItem {get; set;}  
		public integer quantity {get; set;}
		public string nodes {get; set;}
		public boolean isUpgrade {get; set;}  
		public string deviceId {get; set;}  
		public string productId {get; set;}  
		public string productName {get; set;}  
	}
	
	//wrapper for rates and features
	public class FeatureRateWrapper{
		public integer index {get; set;}  
		public String deviceId {get; set;}
		public String deviceDesc {get; set;}
		public String planId {get; set;}
		public String rateProductId {get; set;}
		public String featureId {get; set;}
		public String device {get; set;}  
		public String plan {get; set;}  
		public double rate {get; set;}  
		public String percentage {get; set;}  
		public String featureName {get; set;}  
		public String newFeaturePlan {get; set;}  
		public String lines {get; set;}  
		public String socCode {get; set;}  
		public String comments {get; set;}  
		public String features {get; set;}  
		public boolean hasChanged {get; set;}  
		public boolean isUpgrade {get; set;}  
		public string productId {get; set;}  
		public string productName {get; set;}  
		public OpportunityLineItem opptyLineItem {get; set;}  
		public List<FeatureRateWrapper> rateFeatures {get; set;}  
		public List<SelectOption> ratesList {get; set;}  
	}
	
	private void RefreshDetails(boolean doSave){
		//DARTService svc = new DARTService();
		try{
			//model = svc.createDARTDealMetricsModel(opportunity.id);
			//opportunity.Operating_Margin__c = model.OperatingMargin * 100;
			//opportunity.Payback_Months__c = model.PayBackMonths;
			//opportunity.Market_Invest_per_Line__c = model.MarketInvest;
			//opportunity.Final_Approver__c = model.Approver;
			if(doSave){
				update opportunity;
			}
		}catch(Exception ex){			
			//need to add a custom error message here
			ApexPages.addMessages(ex);
		}
	}
	
	public PageReference  calculateDetails(){
		//function called by the button
		RefreshDetails(true);
		return null;
	}
	
	//drop down for devices
	public List<SelectOption> rateDevices{
        get {
            	rateDevices = new List<SelectOption>();
				rateDevices.add(new SelectOption('0','-- select --'));
				for(ProductWrapper item: selectedProducts){
					if(item.lineItem != null){
					}
					if(item.opptyLineItem.IsUpgrade__c){
						rateDevices.add(new SelectOption(item.productId,item.productName));
					}else{
						rateDevices.add(new SelectOption(item.productId,item.productName));
					}
				}
            return rateDevices;
        }
        private set;
    }
	
	//drop down for rates
	public List<SelectOption> ratePlans{
        get {
                if ( ratePlans == null ){
					ratePlans = new List<SelectOption>();
					ratePlans.add(new SelectOption('0','-- select --'));
					for(PriceBookEntry pbe: dartRates){
						ratePlans.add(new SelectOption(pbe.Id,pbe.Name));
					}
                }
            return ratePlans;
        }
        private set;
    }
	
	//devices drop down
	public List<SelectOption> featureDevices{
        get {
            	featureDevices = new List<SelectOption>();
				featureDevices.add(new SelectOption('0','-- select --'));
				for(ProductWrapper item: selectedProducts){
					featureDevices.add(new SelectOption(item.opptyLineItem.PricebookEntry.Id,item.opptyLineItem.PricebookEntry.Name));
				}
            return featureDevices;
        }
        private set;
    }
	
	//features drop down
	public List<SelectOption> featurePlans{
        get {
                if ( featurePlans == null ){
                	featurePlans = new List<SelectOption>();
					featurePlans.add(new SelectOption('0','-- select --'));
					for(PriceBookEntry pbe: dartFeatures){
						if(pbe.Product2.SOC__c != null){
							featurePlans.add(new SelectOption(pbe.Id,pbe.Name + ' - ' + pbe.Product2.SOC__c));
						}else{
							featurePlans.add(new SelectOption(pbe.Id,pbe.Name));
						}
					}
                }
            return featurePlans;
        }
        private set;
    }
	
	//sets the brand drop down list
	public List<SelectOption> searchBrand{
        get {
					set<String> tmpList = new set<String>();
                	searchBrand = new List<SelectOption>();
					searchBrand.add(new SelectOption('All','All'));
					
					for(PricebookEntry item: dartProducts){
						Boolean contains = tmpList.contains(item.Product2.OEM__c);
						if((!contains) && (item.Product2.OEM__c != null)){
							searchBrand.add(new SelectOption(item.Product2.OEM__c,item.Product2.OEM__c));
							tmpList.add(item.Product2.OEM__c);
						}
					}
					
            return searchBrand;
        }
        private set;
    }
	
	//sets the product type drop down list
	public List<SelectOption> searchType{
        get {
					set<String> tmpList = new set<String>();
                	searchType = new List<SelectOption>();
					searchType.add(new SelectOption('All','All'));
					
					for(PricebookEntry item: dartProducts){
						Boolean contains = tmpList.contains(item.Product2.Product_Type__c);
						if((!contains) && (item.Product2.Product_Type__c != null)){
							searchType.add(new SelectOption(item.Product2.Product_Type__c,item.Product2.Product_Type__c));
							tmpList.add(item.Product2.Product_Type__c);
						}
					}
					
            return searchType;
        }
        private set;
    }
	
	//remove the selected product
	 public PageReference  removeProduct(){
			integer index = 0;
		 	integer deleteIndex = -1;
		 	system.debug('************delete find rowid: ' + selectedProductId);
		 	for(ProductWrapper item: selectedProducts){
				if(item.index == integer.valueOf(selectedProductId)){
					deleteIndex = index; 
					//determine if the wrapper item as a line item attached
					if(item.opptyLineItem != null){
						//check to see if the item is a real record
						if(item.opptyLineItem.Id != null){
							try{
							//just in case the item has been deleted somewhere else
							delete item.opptyLineItem;
							}catch(Exception ex){}
						}
					}
					deleteAssociatedRatePlans(item.productId);
				}
				index += 1;
			}
			if(deleteIndex >= 0){
				selectedProducts.remove(deleteIndex);
			}
		 	return null;
	 }
	 
	 //when deleting a device, remove it's associated rate plan and featue(s)
	 private void deleteAssociatedRatePlans(string key){
		 try{
		 		string dId =  key.substring(0, 18);
				boolean bUpgrade = boolean.valueOf(key.substring(19));
			 
			 	//now lets go get the associated rate plan by they key
			 	integer index = 0;
		 		integer deleteIndex = -1;
			 	for(FeatureRateWrapper item: selectedRates){
						IF( (dId ==  item.deviceId) && (bUpgrade == item.isUpgrade)){
							deleteIndex = index; 
							
							if(item.opptyLineItem != null){
									if(item.opptyLineItem.Id != null){
										try{
											//just in case the record has been deleted somewhere else
											delete item.opptyLineItem;
										}catch(exception ee){}
									}
								}
								//process the features
								if(item.rateFeatures.size() > 0){
									for(FeatureRateWrapper feature : item.rateFeatures){
											if(feature.opptyLineItem != null){
												if(feature.opptyLineItem.Id != null){
													try{
														//just in case the record has been deleted somewhere else
														delete feature.opptyLineItem;
													}catch(exception ee){}
												}
											}
									}
								}
							
						}
						index += 1;
				}
				
				if(deleteIndex >= 0){
					selectedRates.remove(deleteIndex);
				}
		 }catch(Exception ex){	 }
	 }
	 
	 //remove the selected rate
	 public PageReference  removeRate(){
			integer index = 0;
		 	integer deleteIndex = -1;
		 	for(FeatureRateWrapper item: selectedRates){
				if(item.index == integer.valueOf(selectedDeleteRate)){
					deleteIndex = index; 
					
					if(item.opptyLineItem != null){
						if(item.opptyLineItem.Id != null){
							try{
								delete item.opptyLineItem;
							}catch(exception ee){}
						}
					}
					//process the features
					if(item.rateFeatures.size() > 0){
						for(FeatureRateWrapper feature : item.rateFeatures){
								if(feature.opptyLineItem != null){
									if(feature.opptyLineItem.Id != null){
										try{
											delete feature.opptyLineItem;
										}catch(exception ee){}
									}
								}
						}
					}
				}
				
				index += 1;
				
			}
			if(deleteIndex >= 0){
				selectedRates.remove(deleteIndex);
			}
			
			//set the value flags again
			ResetValueFlag();
			
		 	return null;
	 }
	 
	 public PageReference  addNewFeature(){
		 system.debug('************* addNewFeature: ' + selectedFeaturePlan);
		 if(selectedFeaturePlan == '0'){
			 ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please select a valid feature'));
			return null;
		 }
		 for(PriceBookEntry pbe: dartFeatures){
			 system.debug('************* addNewFeature pbe: ' + pbe.Id);
				if(pbe.Id == selectedFeaturePlan){
					if(!isFeatureSelectedThere(selectedFeaturePlan)){
					FeatureRateWrapper feature = new FeatureRateWrapper();
					 feature.featureId = selectedFeaturePlan;
					feature.featureName = pbe.Name;
					selectedFeaturesList.add(feature);
					}
				}
		 }
		 return null;
	 }
	 
	 //make sure that we are not selected a feature that is already in our list
	 private boolean isFeatureSelectedThere(string id){
			boolean result = false;
		 	for(FeatureRateWrapper feature: selectedFeaturesList){
					if(feature.featureId == id){
						return true;
					}
			}
		 	return result;
	 }
	 
	 //remove the feature from the list
	 public PageReference  removeNewFeature(){
		 integer index = 0;
		 integer deleteIndex = -1;
		 for(FeatureRateWrapper feature: selectedFeaturesList){
			 if(feature.featureId == selectedDeleteFeature){
				deleteIndex = index; 
			 }
			 index += 1;
		 }
		 
		 if(deleteIndex >= 0){
			 selectedFeaturesList.remove(deleteIndex);
		 }
		 return null;
	 }
	 
	 //add the accessory to the list
	 public PageReference  selectAccessory(){
		 try{
		 	OpportunityLineItem opptyLineItem = new OpportunityLineItem();
			opptyLineItem.PricebookEntryId = entry.Id;
			opptyLineItem.Quantity =  integer.valueOf(selectedAccUnits);
			opptyLineItem.OpportunityId = opportunityId;
			opptyLineItem.UnitPrice = selectedAccSRP;
			opptyLineItem.Standard_Price__c = entry.Product2.Standard_Price__c;
			opptyLineItem.ServiceDate = date.today();
			opptyLineItem.Product_Type__c = entry.Product2.Product_Type__c;
			opptyLineItem.IsUpgrade__c = false;
			opptyLineItem.OEM__c = entry.Product2.OEM__c;
			opptyLineItem.Product_Category__c = entry.Product2.Product_Category__c;
			opptyLineItem.Product_Family__c = entry.Product2.Family;
			opptyLineItem.Description =  selectedAccDesc;
			opptyLineItem.Non_Discountable__c =  entry.Product2.Non_Discountable__c; //selectedRateComments;
		 	selectedAccessories.add(opptyLineItem);
			
			 //reset the selection information
			selectedAccUnits = 0;
			selectedAccSRP = 0.00;
			selectedAccDesc = '';
		 }catch(Exception ex){}
		 return null;
		 
	 }
	
	 //add the device to the shopping cart
	 public PageReference  selectProduct(){
	 	
		//first check to see if we already have this in our selected list
		for(ProductWrapper item: selectedProducts){
			if((item.opptyLineItem.PricebookEntry.Id == selectedProductId) && (item.opptyLineItem.isUpgrade__c == selectedIsUpgrade)){
				item.quantity += integer.valueOf(selectedProductQty);
				item.opptyLineItem.Quantity += integer.valueOf(selectedProductQty);
				return null;
			}
		}
		
		//let's go find the line item from the cache
		for(PriceBookEntry pbe: dartProducts){
			system.debug('************* pbe Id: ' + pbe.Id);
			if(pbe.Id == selectedProductId){
				ProductWrapper product = new ProductWrapper();
				product.index = deviceIndex;
				deviceIndex += 1;
				product.selected = false;
				product.lineItem = pbe;
				product.isUpgrade = selectedIsUpgrade;
				product.quantity = integer.valueOf(selectedProductQty);
				product.productId = pbe.Product2Id + '/' + String.valueOf(selectedIsUpgrade);
				product.productName = pbe.Name;
				if(selectedIsUpgrade){
					product.productName = pbe.Name + ' - Upgrade';
				}
				selectedProducts.add(product);
				system.debug('************* wrapper item added');
				showRatePlans = true;
				
				//let's create a new opportunity line item
				OpportunityLineItem opptyLineItem = new OpportunityLineItem();
				opptyLineItem.PricebookEntryId = selectedProductId;
				opptyLineItem.Quantity =  integer.valueOf(selectedProductQty);
				opptyLineItem.OpportunityId = opportunityId;
				opptyLineItem.UnitPrice = pbe.Product2.Standard_Price__c; //getDynamicDevicePrice(pbe.Id);
				opptyLineItem.Standard_Price__c = pbe.Product2.Standard_Price__c;
				opptyLineItem.Rep_Price__c = pbe.Product2.Standard_Price__c; //getDynamicDevicePrice(pbe.Id);
				opptyLineItem.ServiceDate = date.today();
				opptyLineItem.Product_Type__c = pbe.Product2.Product_Type__c;
				opptyLineItem.IsUpgrade__c = selectedIsUpgrade;
				opptyLineItem.OEM__c = pbe.Product2.OEM__c;
				opptyLineItem.Product_Category__c = pbe.Product2.Product_Category__c;
				opptyLineItem.Product_Family__c = pbe.Product2.Family;
				opptyLineItem.Description =  '';
				opptyLineItem.Non_Discountable__c =  pbe.Product2.Non_Discountable__c; 
				product.opptyLineItem = opptyLineItem;
				
				return null;
			}
		}
		
		//we need to update the percentages
		calculatePercentages();
		
	 	return null;
	 }
	 
	 //go back the opportunity
	 public PageReference  Cancel(){
		 PageReference pageRef = new PageReference('/' + opportunityId);
		 return pageRef;
	 }
	 
	 
	 public PageReference  saveClose(){
		 //save the dart and if true return the user back to the opportunity
		 if(doSave()){
			 PageReference pageRef = new PageReference('/' + opportunityId);
		 return pageRef;
		 }else{
			 return null;
		 }
	 }
	 
	 public boolean  doSave(){
	 
		//let's save the rescords
		boolean result = true;
	 	system.debug('************* RUNNING SAVE' );
		Savepoint sp = Database.setSavepoint();
		List<OpportunityLineItem> lineItems = new List<OpportunityLineItem>();  
		try{
			
			string errorMessage = validateDART();
			if(errorMessage != null){
				ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, errorMessage));
				return null;
			}else{

			upsert selectedAccessories;
			
			for(ProductWrapper item: selectedProducts){
				
//				system.debug('************* item.opptyLineItem.PricebookEntryId: ' + item.opptyLineItem.PricebookEntryId);
//				system.debug('************* item.opptyLineItem.Quantity: ' + item.opptyLineItem.Quantity);
//				system.debug('************* item.opptyLineItem.OpportunityId: ' + item.opptyLineItem.OpportunityId);
//				system.debug('************* item.opptyLineItem.UnitPrice: ' + item.opptyLineItem.UnitPrice);
//				system.debug('************* item.opptyLineItem.Standard_Price__c: ' + item.opptyLineItem.Standard_Price__c);
				
				system.debug('************* PRODUCT ITEM: ' + item.opptyLineItem);
				item.opptyLineItem.Discount__c = opportunity.AVD_Final__c;
				lineItems.add(item.opptyLineItem);
			}
			
			if(lineItems.size() > 0){
				upsert lineItems;
			}
			lineItems = new List<OpportunityLineItem>();  
			
			for(FeatureRateWrapper item: selectedRates){
				
//				system.debug('************* item.opptyLineItem.PricebookEntryId: ' + item.opptyLineItem.PricebookEntryId);
//				system.debug('************* item.opptyLineItem.Quantity: ' + item.opptyLineItem.Quantity);
//				system.debug('************* item.opptyLineItem.OpportunityId: ' + item.opptyLineItem.OpportunityId);
//				system.debug('************* item.opptyLineItem.UnitPrice: ' + item.opptyLineItem.UnitPrice);
//				system.debug('************* item.opptyLineItem.Standard_Price__c: ' + item.opptyLineItem.Standard_Price__c);
				
				system.debug('************* RATE ITEM: ' + item.opptyLineItem);
				item.opptyLineItem.Discount__c = opportunity.AVD_Final__c;
				
				//check to see if this is a pooling plan
				//National Enterprise Pooling 
				
				if(item.plan.contains('National Enterprise Pooling')){
					//calculate the number
					decimal linePrice = CalculatePoolingPrice(item.opptyLineItem.Quantity, 'Enterprise');
					item.opptyLineItem.UnitPrice = linePrice;
				}
				
				if(item.plan.contains('Small Business Pooling')){
					//calculate the number
					decimal linePrice = CalculatePoolingPrice(item.opptyLineItem.Quantity, 'Small Business');
					item.opptyLineItem.UnitPrice = linePrice;
				}
				
				
				lineItems.add(item.opptyLineItem);
				
				if(item.rateFeatures != null){
					for(FeatureRateWrapper featureItem: item.rateFeatures){
						system.debug('************* FEATURE ITEM: ' + featureItem.opptyLineItem);
						featureItem.opptyLineItem.Quantity = item.opptyLineItem.Quantity;
						featureItem.opptyLineItem.Discount__c = opportunity.AVD_Final__c;
						
						lineItems.add(featureItem.opptyLineItem);
					}
				}
				
			}
			}
			if(lineItems.size() > 0){
				upsert lineItems;
			}
			
			update opportunity;
			RefreshDetails(true);
			
		}catch(Exception ex){
			result = false;
			Database.rollback(sp);
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getMessage()));
			return null;
		}
		return result;
	  }
	 
	 public decimal CalculatePoolingPrice(decimal qty, string type){
		
		 decimal cost = 0.0;
		 
		 decimal totalMinutes  = 0.0;
		 decimal numberBANS  = 0.0;
		
		decimal poolingLineCount = 0.0;
		decimal totalLineCount = 0.0;
		decimal estimatedMinutes = 0.0;
		 decimal estimatedLines = 0.0;
		decimal avgPerUser = 0.0;
		
		decimal subtotalLines  = 0.0;
		decimal subtotalMRC  = 0.0;		
		 integer subtotalMinutes  = 0;     
		 
		 
		 try{
			  if(opportunity.Existing_Pooling_Lines__c == null){
				 opportunity.Existing_Pooling_Lines__c = 0;
			 }
			 estimatedLines = opportunity.Existing_Pooling_Lines__c;
			  
			 	List<Pooling_Plan__c> promoLines; 
			 	promoLines = new List<Pooling_Plan__c>();
				promoLines = [Select P.Lines_Included__c, P.Minutes__c, P.MRC__c, P.Name, P.Opportunity__c, P.Plan_Qty__c, Data__c ,
				 						P.Rate_Plan_Name__c, P.Id from Pooling_Plan__c P 
				 						WHERE Opportunity__c =: opportunity.Id
				 						AND Pooling_Type__c =: type ];
			 
			  poolingLineCount = 0;
			 for(OpportunityLineItem item : [Select O.ServiceDate, O.Feature__c, O.Image__c, O.index__c, O.IsUpgrade__c, O.Description, O.Id, O.ListPrice, O.Minimum_Price__c,  O.PricebookEntry.Product2Id, O.PricebookEntry.Name, O.Is_Promo_Code__c, O.Non_Discountable__c,
																	O.OEM__c, O.OpportunityId, O.PricebookEntryId, O.Product_Category__c, O.Product_Family__c, O.Product_Type__c, O.Quantity, O.Percent__c, O.SOC_Code__c, O.Device__c, O.Device__r.Name,
																	O.Rate__c,  O.Rate__r.Name , O.UnitPrice, O.Standard_Price__c from OpportunityLineItem O
																	WHERE  O.OpportunityId =:opportunity.Id
			 														AND O.PricebookEntry.Name like '%Pooling%'
																	ORDER BY O.Product_Family__c asc]){
			
						poolingLineCount += item.Quantity;											
			}	
																	
			totalLineCount = poolingLineCount +  estimatedLines;													
			 
			 
			List<Usage_Assumption__c> usageLines = new List<Usage_Assumption__c>();
			usageLines = [Select U.Avg_Per_User__c, U.B2B_Standard__c, U.Name, U.Opportunity__c, U.Id, U.Type_of_Usage__c, 
			 														U.Usage_Notes__c from Usage_Assumption__c U
			 														WHERE Opportunity__c =: opportunity.Id
			 														AND Type_of_Usage__c = 'Billable MOU (Peak Minutes)' limit 1];
			if(usageLines.size() > 0){															
				avgPerUser = usageLines.get(0).Avg_Per_User__c;
			}
			estimatedMinutes = avgPerUser * totalLineCount;														
			
			totalMinutes = 0;
			numberBANS = 0;
			for(Pooling_Plan__c plan : promoLines){
				if(plan.Plan_Qty__c > 0){
					totalMinutes += (plan.Plan_Qty__c * plan.Minutes__c);
					numberBANS += (plan.Plan_Qty__c *1);
					subtotalLines += (plan.Plan_Qty__c * plan.Lines_Included__c);
					subtotalMRC += (plan.Plan_Qty__c * plan.MRC__c);
					system.debug('************* RUNNING totalMinutes: ' + totalMinutes );
				}
			}
			
			//((Existing Lines + New lines – Included Lines) * 9.99  + PoolingPlan MRC) / (Existing Lines + New lines)
			system.debug('************* PROCESSING subtotalMRC: ' + subtotalMRC );
			system.debug('************* PROCESSING qty: ' + qty );
			system.debug('************* PROCESSING estimatedLines: ' + estimatedLines );
			//let's go get the updated value
			Opportunity newOppty = [SELECT Id, Name, Existing_Pooling_Lines__c FROM opportunity WHERE Id =: opportunity.Id];
			opportunity.Existing_Pooling_Lines__c = newOppty.Existing_Pooling_Lines__c;
			cost = ((9.99 + subtotalMRC) * qty)/ (opportunity.Existing_Pooling_Lines__c + qty);
			cost = cost.setScale(2);
			 
		 }catch(Exception ex){
			 
		 }
		 
		 return cost;
		 
	 }
	 
	  public PageReference  saveItems(){
	 	//save the dart
		doSave();
		return null;
	  }
	 
	 public PageReference updateRateLineProperties(){
	 	//update the % and SOC Code	 	
	
		selectedRateFlag = true;
		//let's go get the data from the cache
		for(PriceBookEntry pbe: dartRates){
			if(pbe.Id == selectedRatePlan){
				selectedRateCode = pbe.Product2.SOC__c;
				selectedRatePercent = '0%';	
				featureFlag = false;
				if(pbe.Name.contains('Other')){
					selectedRateFlag = false;
				}
			}	
		}
		return null;
	 }
	 
	  public PageReference UpdateSearchItems(){
	 	//old method
		return null;
	 }
	  
	  public boolean HavePooling(string planName){
		  boolean result = false;
		  for(FeatureRateWrapper rate : selectedRates){
			  if(rate.plan.Contains('Pool')){
				  if(rate.plan != planName){
						return true;  
				  }
			  }
		  }
		  return result;
	  }
	  
	  private void calculatePercentages(){
		
		  //method to determine the values in the percentages column
		  
		  //get the number of devices
		  decimal numberDevices = 0;
		  for(ProductWrapper product : selectedProducts){
			  numberDevices += product.opptyLineItem.Quantity;
		  }
		  
		  //calculate the percentages
		  for(FeatureRateWrapper rate : selectedRates){
			decimal dValue =  rate.opptyLineItem.Quantity / numberDevices;
			rate.opptyLineItem.Percent__c = dValue.setScale(2) * 100;
		  }
		  
	  }
	  
	  private void SetValueFlag(string productName){
		  system.debug('************* RUNNING SetValueFlag FIND: ' + productName);
		  for(ProductWrapper product : selectedProducts){
			  system.debug('************* RUNNING SetValueFlag VALUE:' + product.productName);
			  if(product.productName == productName){
				product.selected = true;  
				product.opptyLineItem.UnitPrice = product.opptyLineItem.ListPrice;
				product.opptyLineItem.Rep_Price__c = product.opptyLineItem.ListPrice;
			  }
		  }
	  }
	  
	private void ResetValueFlag(){
		system.debug('************* RUNNING ResetSetValueFlag FIND');
			for(ProductWrapper product : selectedProducts){
			product.selected = false;
		}
			
		for(FeatureRateWrapper rate : selectedRates){
			if(rate.plan.Contains('Value')){
				SetValueFlag(rate.device);
			}
		}
	}
	 
	  public PageReference  selectRate(){
	  
	  		system.debug('************* RUNNING SELECT RATE');
		  	for(PriceBookEntry pbe: dartRates){
				if(pbe.Id == selectedRatePlan){
					
					string featureRateId = pbe.Product2Id;
					
					string tmpPlanName = getRateName(selectedRatePlan);
					if(tmpPlanName.Contains('Pool')){
							if(HavePooling(tmpPlanName)){
								ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You can only select one type of pooling plan within an Opportunity.'));
								return null;
							}
					}
					
					if(tmpPlanName.Contains('Small Business Pooling')){
						enterpriseFlag = true;
					}else{
						enterpriseFlag = false;
					}
					
					system.debug('************* adding new wrapper item');
					FeatureRateWrapper newItem = new FeatureRateWrapper();

					newItem.index = rateIndex;
					rateIndex += 1;
					
					system.debug('************* DEVICE ID: ' + selectedRateDevice);
					
					string dId =  selectedRateDevice.substring(0, 18);
					system.debug('************* DEVICE ID2: ' + dId);
					boolean bUpgrade = boolean.valueOf(selectedRateDevice.substring(19));
					
					newItem.rateProductId = featureRateId;
					newItem.productId = selectedRateDevice;
					newItem.deviceId = dId;
					newItem.planId = selectedRatePlan;
					newItem.device = getDeviceName(dId);
					if(bUpgrade){
						newItem.device = getDeviceName(dId) + ' - Upgrade';
					}
					if(tmpPlanName.Contains('Value')){
						if(bUpgrade){
							SetValueFlag(getDeviceName(dId) + ' - Upgrade');
						}else{
							SetValueFlag(getDeviceName(dId));
						}
					}
					newItem.plan = getRateName(selectedRatePlan);
					newItem.rate = pbe.Product2.Standard_Price__c;
					newItem.percentage = '0';
					newItem.lines = selectedRateLines;
					newItem.socCode = selectedRateCode;
					newItem.comments = selectedRateComments;
					newItem.features = selectedRateFeatures;
					newItem.isUpgrade = bUpgrade;
					selectedRates.add(newItem);
					
					system.debug('************* newItem.plan: ' + newItem.plan);
					if(newItem.plan.Contains('Pool')){
						system.debug('************* setting showInputs: ' + showInputs);
						showInputs = false;
						system.debug('************* setting showInputs2: ' + showInputs);
						displaySystemNotice = 'true';
					}
					//showInputs = true;
					system.debug('************* wrapper item added');
					
					//let's create a new opportunity line item
					OpportunityLineItem opptyLineItem = new OpportunityLineItem();
					opptyLineItem.PricebookEntryId = selectedRatePlan;
					opptyLineItem.Quantity = integer.valueOf(selectedRateLines);
					opptyLineItem.OpportunityId = opportunityId;
					opptyLineItem.UnitPrice = pbe.Product2.Standard_Price__c;
					if(pbe.Product2.Standard_Price__c == null){
						opptyLineItem.UnitPrice = 0.0;
					}
					opptyLineItem.Standard_Price__c = pbe.Product2.Standard_Price__c;
					opptyLineItem.ServiceDate = date.today();
					opptyLineItem.Product_Type__c = pbe.Product2.Product_Type__c;
					opptyLineItem.OEM__c = pbe.Product2.OEM__c;
					opptyLineItem.Product_Category__c = pbe.Product2.Product_Category__c;
					opptyLineItem.Product_Family__c = pbe.Product2.Family;
					opptyLineItem.Device__c = dId;
					opptyLineItem.IsUpgrade__c = bUpgrade;
					opptyLineItem.Percent__c = integer.valueOf(newItem.percentage);
					opptyLineItem.Description =  ''; 
					opptyLineItem.Non_Discountable__c =  pbe.Product2.Non_Discountable__c; 
					opptyLineItem.SOC_Code__c = selectedRateCode;
					
					newItem.opptyLineItem = opptyLineItem;
					
					newItem.rateFeatures = new List<FeatureRateWrapper>();
					
					//section add all the selected features to the shopping cart
					if(selectedFeaturesList.size() > 0){
						for(FeatureRateWrapper feature: selectedFeaturesList){
							system.debug('************* feature wrapper item: ' + feature.featureId);
							
							for(PriceBookEntry pbee: dartFeatures){
								if(pbee.Id == feature.featureId){
									OpportunityLineItem featureLineItem = new OpportunityLineItem();
									featureLineItem.PricebookEntryId = feature.featureId;
									featureLineItem.Quantity = integer.valueOf(selectedRateLines);
									featureLineItem.OpportunityId = opportunityId;
									
									//featureLineItem.UnitPrice = pbee.Product2.Standard_Price__c;
									if(pbee.Product2.Standard_Price__c != null){
										featureLineItem.UnitPrice = pbee.Product2.Standard_Price__c;
									}else{
										featureLineItem.UnitPrice = 0.0;	
									}
								
									//featureLineItem.Standard_Price__c = pbee.Product2.Standard_Price__c;
									if(pbee.Product2.Standard_Price__c != null){
										featureLineItem.Standard_Price__c = pbee.Product2.Standard_Price__c;
									}else{
										featureLineItem.Standard_Price__c = 0.0;	
									}
								
									featureLineItem.ServiceDate = date.today();
									featureLineItem.Product_Type__c = pbee.Product2.Product_Type__c;
									featureLineItem.OEM__c = pbee.Product2.OEM__c;
									featureLineItem.Product_Category__c = pbee.Product2.Product_Category__c;
									featureLineItem.Product_Family__c = pbee.Product2.Family;
									featureLineItem.Device__c = dId;
									featureLineItem.Rate__c = featureRateId;
									featureLineItem.IsUpgrade__c = bUpgrade;
									featureLineItem.Percent__c = integer.valueOf(newItem.percentage);
									featureLineItem.Description =  pbe.Product2.Name; 
									featureLineItem.Non_Discountable__c =  pbe.Product2.Non_Discountable__c; 
									
									feature.opptyLineItem = featureLineItem;
									newItem.rateFeatures.add(feature);
								}
							}
						}
					}else{
						//maybe the user didn't add any features, but still had a feature selected in the drop down
						for(PriceBookEntry pbee: dartFeatures){
								if(selectedFeaturePlan != '0'){
								if(pbee.Id == selectedFeaturePlan){
									
									FeatureRateWrapper wrapper = new FeatureRateWrapper();
									wrapper.featureId = selectedFeaturePlan;
									wrapper.featureName = pbee.Name;
									
									OpportunityLineItem featureLineItem = new OpportunityLineItem();
									featureLineItem.PricebookEntryId = selectedFeaturePlan;
									featureLineItem.Quantity = integer.valueOf(selectedRateLines);
									featureLineItem.OpportunityId = opportunityId;
									
									//featureLineItem.UnitPrice = pbee.Product2.Standard_Price__c;
									if(pbee.Product2.Standard_Price__c != null){
										featureLineItem.UnitPrice = pbee.Product2.Standard_Price__c;
									}else{
										featureLineItem.UnitPrice = 0.0;	
									}
									
									//featureLineItem.Standard_Price__c = pbee.Product2.Standard_Price__c;
									if(pbee.Product2.Standard_Price__c != null){
										featureLineItem.Standard_Price__c = pbee.Product2.Standard_Price__c;
									}else{
										featureLineItem.Standard_Price__c = 0.0;	
									}
									
									featureLineItem.ServiceDate = date.today();
									featureLineItem.Product_Type__c = pbee.Product2.Product_Type__c;
									featureLineItem.OEM__c = pbee.Product2.OEM__c;
									featureLineItem.Product_Category__c = pbee.Product2.Product_Category__c;
									featureLineItem.Product_Family__c = pbee.Product2.Family;
									featureLineItem.Device__c = dId;
									featureLineItem.Rate__c = featureRateId;
									featureLineItem.IsUpgrade__c = bUpgrade;
									featureLineItem.Percent__c = integer.valueOf(newItem.percentage);
									featureLineItem.Description =  pbee.Product2.Name; 
									featureLineItem.Non_Discountable__c =  pbee.Product2.Non_Discountable__c; 
									
									wrapper.opptyLineItem = featureLineItem;
									newItem.rateFeatures.add(wrapper);
								}
								}
							}
					}
				}
			}
			
			//reset all the selection values
			featureFlag = true;
			selectedFeaturePlan = '0';
			selectedRatePlan = '0';
			selectedRateDevice = '0';
			selectedRateCode = '';
			selectedRateLines = '';
			selectedRateComments = '';
			selectedFeaturesList.clear();
			theList.clear();
			showFeaturePlans = true;		
			
			//we need to update the percentages
			calculatePercentages();
			
	  		return null;
	  }
	  
	  public PageReference updateFeatureLineProperties(){
		//update the percentage and the SOC code
		//when a new rate plan is selected
		for(PriceBookEntry pbe: dartRates){
			if(pbe.Id == selectedFeaturePlan){
				selectedFeatureCode = pbe.Product2.SOC__c;
				selectedFeaturePercent = '0%';	
			}
		}
		return null;
	 }
	  
	  public PageReference  selectFeature(){
		//adds a feature to the list
		//old version
	  	system.debug('************* RUNNING SELECT FEATURE: ' + selectedFeaturePlan);
		  	for(PriceBookEntry pbe: dartFeatures){
				if(pbe.Id == selectedFeaturePlan){
					FeatureRateWrapper newItem = new FeatureRateWrapper();
					newItem.index = 0;
					newItem.deviceId = selectedFeatureDevice;
					newItem.planId = selectedFeaturePlan; 
					newItem.device = getDeviceName(selectedFeatureDevice);
					newItem.plan = getRateName(selectedFeaturePlan);
					newItem.rate = pbe.Product2.Standard_Price__c;
					newItem.percentage = '0';
					newItem.lines = selectedFeatureLines;
					newItem.socCode = selectedFeatureCode;
					newItem.comments = selectedFeatureComments;
					
					selectedFeatures.add(newItem);
				}
			}
			
			//reset the selected values
			selectedFeaturePlan = '0';
			selectedFeatureDevice = '0';
			selectedFeatureCode = '';
			selectedFeatureLines = '';
			selectedFeatureComments = '';
			showFeaturePlans = true;		
			
	  		return null;
	  }
	  
	  public PageReference  removeNewFeatureItem(){
		//removes a feature from the list
		
		 for(FeatureRateWrapper rate : selectedRates){
				if(rate.rateProductId ==  selectedRateAddOn){
					integer index = 0;
					integer deleteIndex = -1;
					for(FeatureRateWrapper feature : rate.rateFeatures){
						
						if(feature.featureName  == selectedDeleteFeatureAddOn){
								deleteIndex = index;
								
								//check to see if the wrapper has a line item
								if(feature.opptyLineItem != null){
									//check to see line item has a valid rowId
									if(feature.opptyLineItem.Id != null){
										try{
											//delete the item. the try is here just in case it is artifact from a previous delete operation
											system.debug('************* DELETING FEATURE: ' + feature.opptyLineItem);
											delete feature.opptyLineItem;
										}catch(Exception ex){}
									}
								}
						}
						
						index += 1;
					}
					 if(deleteIndex >= 0){
						 rate.rateFeatures.remove(deleteIndex);
					 }
				}
		 }
		return null;
	  }
	  
	  public PageReference  addNewFeatureItem(){
	  	//adds a new feature from the selected rate list
		  if(selectedFeatureAddOn == '0'){
			 ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please select a valid feature'));
			return null;
		 }
		  FeatureRateWrapper wrapper = new FeatureRateWrapper();
		  for(FeatureRateWrapper rate : selectedRates){
					if(rate.rateProductId ==  selectedRateAddOn){
						system.debug('************* found rate: ' + rate.plan);
						for(PriceBookEntry pbee: dartFeatures){
							if(pbee.Id == selectedFeatureAddOn){
								system.debug('************* found feature: ' + pbee.Name);
								//set the wrapper header info
								wrapper.featureId = selectedFeatureAddOn;
								wrapper.featureName = pbee.Name;
								
								//create the oppty line item
								OpportunityLineItem featureLineItem = new OpportunityLineItem();
								featureLineItem.PricebookEntryId = selectedFeatureAddOn;
								featureLineItem.Quantity =  integer.valueOf(rate.lines);
								featureLineItem.OpportunityId = opportunityId;
								if(pbee.Product2.Standard_Price__c != null){
									featureLineItem.UnitPrice = pbee.Product2.Standard_Price__c;
								}else{
									featureLineItem.UnitPrice = 0.0;	
								}
								if(pbee.Product2.Standard_Price__c != null){
									featureLineItem.Standard_Price__c = pbee.Product2.Standard_Price__c;
								}else{
									featureLineItem.Standard_Price__c = 0.0;	
								}
								//featureLineItem.Standard_Price__c = pbee.Product2.Standard_Price__c;
								featureLineItem.ServiceDate = date.today();
								featureLineItem.Product_Type__c = pbee.Product2.Product_Type__c;
								featureLineItem.OEM__c = pbee.Product2.OEM__c;
								featureLineItem.Product_Category__c = pbee.Product2.Product_Category__c;
								featureLineItem.Product_Family__c = pbee.Product2.Family;
								featureLineItem.Device__c = rate.deviceId;
								featureLineItem.Rate__c = selectedRateAddOn;
								featureLineItem.IsUpgrade__c = rate.isUpgrade;
								featureLineItem.Percent__c = integer.valueOf(rate.percentage);
								featureLineItem.Description =  pbee.Product2.Name; 
								featureLineItem.Non_Discountable__c =  pbee.Product2.Non_Discountable__c; 
								
								wrapper.opptyLineItem = featureLineItem;
								rate.rateFeatures.add(wrapper);
							}
						}
					}
				}
		 return null;
	  }
	  
	public string getDeviceName(string rowId){
		//this function parsers out the key in order
		//to the real product name
		string result = '';
		for(PriceBookEntry pbe: dartProducts){
			if(pbe.Product2.Id == rowId){
				result = pbe.Name;
			}
		}
		return result;
	}
	
	public string getProductName(string rowId){
		//this function parsers out the key in order
		//to the real product name
		string result = '';
		for(ProductWrapper item: selectedProducts){
			
			if(item.productId == rowId){
				return item.productName;	
			}
		}
		return result;
	}
	
	public string getRateName(string rowId){
	  	//this function parsers out the key in order
		//to the real rate name
		string result = '';
		for(PriceBookEntry pbe: dartRates){
			if(pbe.Id == rowId){
				result = pbe.Name;
			}
		}
		return result;
	}
	
	public decimal  getDynamicRatePrice(string rowId){
		//this function gets the price when adding a feature 
		//to the shopping cart
		decimal result;
		try{
			for(PriceBookEntry pbe: dartRates){
				if(pbe.Id == rowId){
					if((opportunity.Contract_Term_Months__c == '12') && (!roleName.toLowerCase().contains('govt'))){
						return pbe.Product2.Acq_1_Year_Net_Rep__c;
					}else if(((opportunity.Contract_Term_Months__c == '24') || (opportunity.Contract_Term_Months__c == '36')) && (!roleName.toLowerCase().contains('govt'))){
						return pbe.Product2.Acq_2_Year_Net_Rep__c;
					}else if(roleName.toLowerCase().contains('govt')){
						return pbe.Product2.Acq_1_Year_Net_Gov__c;
					}else{
						return pbe.Product2.Minimum_Price__c;
					}
				}
			}
		}catch(Exception ex){}
		return result;
	}
	
	public decimal  getDynamicFeaturePrice(string rowId){
		//this function gets the price when adding a feature 
		//to the shopping cart
		decimal result;
		try{
			for(PriceBookEntry pbe: dartFeatures){
				if(pbe.Id == rowId){
					//get the role name
					if((opportunity.Contract_Term_Months__c == '12') && (!roleName.toLowerCase().contains('govt'))){
						return pbe.Product2.Acq_1_Year_Net_Rep__c;
					}else if(((opportunity.Contract_Term_Months__c == '24') || (opportunity.Contract_Term_Months__c == '36')) && (!roleName.toLowerCase().contains('govt'))){
						return pbe.Product2.Acq_2_Year_Net_Rep__c;
					}else if(roleName.toLowerCase().contains('govt')){
						return pbe.Product2.Acq_1_Year_Net_Gov__c;
					}else{
						return pbe.Product2.Minimum_Price__c;
					}
				}
			}
		}catch(Exception ex){}
		return result;
	}
	
	public decimal  getDynamicDevicePrice(string rowId){
		//this function gets the price when adding a device 
		//to the shopping cart
		decimal result;
		try{
			for(PriceBookEntry pbe: dartProducts){
				if(pbe.Id == rowId){
					if((opportunity.Contract_Term_Months__c == '12') && (!roleName.toLowerCase().contains('govt'))){
						return pbe.Product2.Acq_1_Year_Net_Rep__c;
					}else if(((opportunity.Contract_Term_Months__c == '24') || (opportunity.Contract_Term_Months__c == '36')) && (!roleName.toLowerCase().contains('govt'))){
						return pbe.Product2.Acq_2_Year_Net_Rep__c;
					}else if(roleName.toLowerCase().contains('govt')){
						return pbe.Product2.Acq_1_Year_Net_Gov__c;
					}else{
						return pbe.Product2.Minimum_Price__c;
					}		
				}
			}
		}catch(Exception ex){	}
		return result;
	}
	
	public string getRoleName(string roleId){
		UserRole role = [Select Name from UserRole where id =: roleId];
		return role.Name;
	}
	
	public string  validateDART(){
		//this method will make sure that the DART lines number match up
		string message;
		decimal numberDevices = 0;
		decimal numberRates = 0;
		for(ProductWrapper product : selectedProducts){
			numberDevices = product.opptyLineItem.Quantity;
			for(FeatureRateWrapper rate : selectedRates){
				if(rate.device == product.productName){
					numberRates += rate.opptyLineItem.Quantity;
				}
			}
			
			if(numberRates != numberDevices){
				if(message == null){
					message ='The number of rate plans does not equal the number of devices for: ';	
				}
				message += ' ' + product.productName + ':';	
			}
			numberRates = 0;
		}
		return message;	
	}
		
	public List<string> getPriceField(){
		//function used for dynamic pricing.
		//need to move rules to custom settings
		List <String> fields = new List<String>();
		try{			
			if(showNewDevices){
				if((opportunity.Contract_Term_Months__c == '12') && (!roleName.toLowerCase().contains('govt'))){
					fields.add('Acq_1_Year_Net_Rep__c');
				}else if(((opportunity.Contract_Term_Months__c == '24') || (opportunity.Contract_Term_Months__c == '36')) && (!roleName.toLowerCase().contains('govt'))){
					fields.add('Acq_2_Year_Net_Rep__c');
				}else if(roleName.toLowerCase().contains('govt')){
					fields.add('Acq_1_Year_Net_Gov__c');
				}else{
					fields.add('Minimum_Price__c');
				}
			}
				
			if(showUpgrades){
			}	
			
		}catch(Exception ex){
		}
		return fields;
	}
	
}