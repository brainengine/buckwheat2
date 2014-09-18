/*
 * controller.js
 *
 * Main product picker controller script.
 *
 * 13 May 2011 Andrew Couch migrated from OpportunityProductPicker.cls
 *
 */


    var $j = jQuery.noConflict();

    var $comboElem, $globalDiscountElem, $saveButton ;

    /*
        Onload
    */

    jQuery(document).ready(function(){

        // initialize Wrappers;
		var base = '#ProductPicker\\:mainForm\\:ProductBlock\\:';
		$comboElem = $j( base+ "selectProductAutoComplete");
        $globalDiscountElem = $j( 'input[id$="oppGlobalDiscount"]' );

        $saveButton = $j('input[id$="saveButton"]');
	    jQuery("#familySelect").change();
        renderSearchCombobox();
     	addValidations();
    	initializedProductDescriptionToolTip();
        calculateGrandTotal();

    });


    function initializedProductDescriptionToolTip (){
    	$j("#ProductDescriptionIcon").simpletip(
		{
    		onBeforeShow: function(){
	    		var apiCallback = this;
	        	var currentId = $comboElem.val();
	        	var cacheId = $comboElem.data('cacheId');

	        	if ( cacheId &&  currentId == cacheId ){
	                apiCallback.update( $comboElem.data('cacheValue') );
	                return;
	        	}

	        	apiCallback.update( 'Loading' );
	        	$comboElem.data('cacheId', currentId);

	        	OpportunityProductPickerContExt.getProductDescription( $comboElem.val() , function(result, event){
	        			var value = ( result ) ?  result : 'No description available';
	                	apiCallback.update( value );
	        			$comboElem.data('cacheValue', value)
	        	});
    		},
    		onShow:function(){
    			var elem = $j("#ProductDescriptionIcon");
    			var x = (elem.outerWidth() / 2) + elem.offset().left;
				var position ={pageX: x , pageY: 240 };
    			this.updatePos( position )
    		},
    		content: 'Loading'
		});
    }




    function addValidations (){

    return ;
    	$j("#oliList input.numberPrecisionFive").live('keyup', function() {
	    		 var $input = $j(this);
	    		 $saveButton.removeAttr("disabled");
	   			 $input.next('div').hide();
	    		 var inputVal = $input.val();
	    		 var numericReg = /^\d*[0-9](\.{0,1}[0-9]{0,5})$/;
	    		 if( inputVal && !numericReg.test(inputVal) ) {
	           		 $input.next('div').show();
	           		 $saveButton.attr("disabled", "disabled");
				}
			});

    }

    function initUI(){
        $j('#oliList').find('input[id$="oliIsDelete"], input[value$="true"]').each( function ( index ){
            deleteProduct ( this.id  );
        });
        //cause parent Package to show dates
        $j('#oliList').find('.parentproduct').each( function(index){
        	jQuery(this).next().find("input.childTime").change();
        });

		var $elems = jQuery('#oliList input[id$="oliProductStartTime"],input[id$="oliProductEndTime"],input[id$="oliStartTime"],input[id$="oliEndTime"]' ).each(function(index) {
			jQuery( this ).data("original", this.value ).blur( function(){
				if (jQuery(this).data('original') != this.value ){
			           setRowHasChanged ( this.id )	;
				};

			} );
		});
		

        // Bind an onChage event to all the input fields
		$j('#oliList').find("input:not([type='hidden'])").each(function(index) {
	  			jQuery(this).bind('change',  function (){ setRowHasChanged( this.id ) });
		});

		jQuery( "#oliList input[id$='oliDiscount']:.nonDiscountable" ).attr('disabled', 'disabled');
    }


    function setRowHasChanged ( elemId ) {
    	var index = elemId.lastIndexOf ('childProductsRepeat');
	  	if (index < 0 ) index = elemId.lastIndexOf(':') + 1;
		var baseId = elemId.substring(0, index );
		var hasChangedEl	= document.getElementById(baseId + 'hasChanged');
		if (hasChangedEl)
			hasChangedEl.value ="true";
    }

    /*
        Activate the AutoSearch Functionality
    */
    function renderSearchCombobox (){
        $comboElem.combobox(  { source: productSuggestions} );
        jQuery("#ProductPicker\\:mainForm\\:ProductBlock\\:combobox\\:input").val("") ;
        $comboElem.val("") ;

        initUI();

    }

    /**
    * Block page
    **/
    function BlockUI(strMessage)
    {
       jQuery.blockUI({
            css:{
                 border: 'none',
                 padding: '15px',
                 backgroundColor: '#000000',
                 '-webkit-border-radius': '10px',
                 '-moz-border-radius': '10px',
                 opacity: .5,
                 color: '#fff'
            },
            message: strMessage
      });

    }


    /**
    * Unblock page
    **/
    function UnBlockUI(){
        jQuery.unblockUI()  ;
    }

    function blockElement (  ) {
         jQuery("#mainPageBlock").block({
                message: null,
                 overlayCSS:  { backgroundColor: '#ffffff',
                 				opacity: .5
                 			 }
            });
    }

    function unblockElement() {
        jQuery("#mainPageBlock").unblock();
    }

        function ascDateSort( date1, date2 ) {

            if(date1 > date2) return 1;
            if(date1 < date2) return -1;
            return 0;

        }

        function descDateSort( date1, date2 ) {

            if(date1 < date2) return 1;
            if(date1 > date2) return -1;
            return 0;

        }

        function dateFormat( dateTime ) {
            return (dateTime.getMonth() + 1) + '/' + dateTime.getDate() + '/' + dateTime.getFullYear();
        }

        function setPackageStartDate( hiddenParentId, packageStartDate ) {

            var parentStartDateId, parentStartDateElement;

            parentStartDateId = hiddenParentId + 'startTime';
            parentStartDateElement = document.getElementById(parentStartDateId).parentNode.firstChild;
            parentStartDateElement.innerHTML = dateFormat(packageStartDate);

            $j ( parentStartDateElement ).next().find('input').val( parentStartDateElement.innerHTML  );

        }

        function setPackageEndDate( hiddenParentId, packageEndDate ) {

            var parentEndDateId, parentEndDateElement;
            parentEndDateId = hiddenParentId + 'endTime';
            parentEndDateElement = document.getElementById(parentEndDateId).parentNode.firstChild;
            parentEndDateElement.innerHTML = dateFormat(packageEndDate);
            $j( parentEndDateElement ).next().find('input').val( parentEndDateElement.innerHTML );

        }

        function updatePackageStartDate( hiddenParentId ) {

            var allPackageComponents, componentStartDates, dateString, i;
            componentStartDates = [];

            allPackageComponents = jQuery('#oliList .'+hiddenParentId).filter(':not(.parentproduct)');

            allPackageComponents.each( function(index){

                dateString = jQuery(this).find('.dateInput').first().find('input').val();
                if((dateString !== '') && (dateString != undefined)) {
                    componentStartDates.push(new Date(dateString));
                }

            } );

            setPackageStartDate(hiddenParentId, componentStartDates.sort(ascDateSort)[0]);

        }

        function updatePackageEndDate( hiddenParentId ) {

            var allPackageComponents, componentEndDates, date, i;
            componentEndDates = [];

            allPackageComponents = jQuery('#oliList .'+hiddenParentId).filter(':not(.parentproduct)');

            allPackageComponents.each( function(index){

                dateString = jQuery(this).find('.dateInput').last().find('input').val();
                if((dateString !== '') && (dateString != undefined)) {
                    componentEndDates.push(new Date(dateString));
                }

            } );

            setPackageEndDate(hiddenParentId, componentEndDates.sort(descDateSort)[0]);

        }

    // Run effect when adding new row
    function runAddEffect (){
        window.scrollTo(0, jQuery(document).height() );

        var rowId =  jQuery("#oliList tr:last").attr("class");
        rowId = rowId.split(" ")[0];
        jQuery( "#oliList ." + rowId ).effect( "highlight", null, 1000, null );

    }

    // Lock the Pricebook select box when a product is added
    function lockPricebook(){
    	jQuery('#productPickerTable').find('select').first().attr('disabled','disabled');
    }

    // Unlock the Pricebook select box if no product is added
    //   Note: NOT ACTUALLY CALLED AT THE MOMENT
    function unlockPricebook(){
    	jQuery('#productPickerTable').find('select').first().attr('disabled','');
    }

    function editProduct  ( vfRowId ) {

        //get base Id
        var endIndex = vfRowId.lastIndexOf(':') + 1;
        var baseId = vfRowId.substring(0, endIndex);

        //get Elements
        var idEl    = document.getElementById(baseId + 'oliRowId');
        var isDeleteHiddenEl    = document.getElementById(baseId + 'oliIsDelete');

        window.scrollTo(0, 0);

        if ( isDeleteHiddenEl.value == 'false' ) {
            jQuery( "#oliList  ." + idEl.value + " td" ).css( {'color': 'black'} ).removeClass( "deletedRow" );
            jQuery('#oliList input[id^="'+ baseId +'"]').attr("disabled", false );
            calculateGrandTotal ();
        }

        var hasChangedEl	= document.getElementById(baseId + 'hasChanged');
		hasChangedEl.value ="true";

        // Block element
        blockElement();

    	setTimeout("blockElement()", 250);

    }

    function deleteProduct ( vfRowId ) {

        //get base Id
        var endIndex = vfRowId.lastIndexOf(':') + 1;
        var baseId = vfRowId.substring(0, endIndex);

        //get Elements
        var idEl    = document.getElementById(baseId + 'oliRowId');
        var isDeleteHiddenEl    = document.getElementById(baseId + 'oliIsDelete');

        if ( isDeleteHiddenEl.value == 'true' ) {
            jQuery( "#oliList").find('input[id^="'+ baseId +'"]').attr("disabled", true );
            jQuery( "#oliList").find("." + idEl.value + " td" ).addClass( "deletedRow" ).css( {'color': 'red'} );
        }else{
            jQuery( "#oliList").find("." + idEl.value + " td" ).css( {'color': 'black'} ).removeClass( "deletedRow" );
            jQuery( "#oliList").find('input[id^="'+ baseId +'"]').attr("disabled", false );
        }

    }


    function calculateDiscount( vfRowId ) {

        var endIndex, baseId, widhtEl, heightEl, quantity, priceEl, discount, totalEl, total, discountToBeApplied,
            discountPercentage, discountAmount, discountedPrice, contractLevel;

        //get base Id
        endIndex = vfRowId.lastIndexOf(':') + 1;
        baseId   = vfRowId.substring(0, endIndex);

        //get Elements
        
        quantity = document.getElementById(baseId + 'oliQuantity');
        priceEl  = document.getElementById(baseId + 'oliUnitPrice');
        discount = document.getElementById(baseId + 'oliDiscount');
        //contractLevel = document.getElementById(baseId + 'oliContractLevel');

        totalEl  = document.getElementById(baseId + 'oliTotal');
		standardPriceEl  = document.getElementById(baseId + 'oliStandardPrice');

		// Calculate new price
        var standPrice = standardPriceEl.value;
        if ( standPrice > 0 && discount.value) {
        	discountToBeApplied = (100 - parseFloat(discount.value.replace(/[^0-9\.\-]/g, ''))) / 100;
        	discountToBeApplied= parseFloat(discountToBeApplied).toFixed(2);
			contractLevelDiscountVal = parseFloat(contractLevel.innerHTML).toFixed(2);

        	if ( contractLevel && contractLevelDiscountVal  == discountToBeApplied ){
        		discount.value=0;
        	}

        	discountedPrice = parseFloat(standardPriceEl.value.replace(/[^0-9\.]/g, '')) * discountToBeApplied;
        	priceEl.value = new BigNumber(discountedPrice, 2, BigNumber.ROUND_HALF_UP).round() ;
        } else {
        	discountedPrice = priceEl.value;
        	discount.value=0;
        }

        var quantity   = parseFloat(quantity.value.replace(/[^0-9\.]/g, ''));


		// Calculate Total
        total =  quantity * discountedPrice;	// * widthValue * heightValue;
        totalEl.innerHTML =  addCommas( new BigNumber(total, 2, BigNumber.ROUND_HALF_UP).round() );

        calculateGrandTotal();
    };


    function calculateTotal( vfRowId ) {

        //var widhtEl, heightEl,
        var endIndex, baseId, quantity, priceEl, discount, totalEl, total, standardPriceEl;

        //get base Id
        endIndex = vfRowId.lastIndexOf(':') + 1;
        baseId   = vfRowId.substring(0, endIndex);

        //get Elements
       
        quantity = document.getElementById(baseId + 'oliQuantity');
        priceEl  = document.getElementById(baseId + 'oliUnitPrice');
        discount = document.getElementById(baseId + 'oliDiscount');
        //discountType = document.getElementById(baseId + 'oliContractLevelType');
        totalEl  = document.getElementById(baseId + 'oliTotal');
		standardPriceEl  = document.getElementById(baseId + 'oliStandardPrice');

        var standPrice = standardPriceEl.value;
        var unitPrice  = parseFloat(priceEl.value.replace(/[^0-9\.]/g, ''));
        var quantity   = parseFloat(quantity.value.replace(/[^0-9\.]/g, ''));
      

        total =  quantity * unitPrice;	

        totalEl.innerHTML =  addCommas( new BigNumber(total, 2, BigNumber.ROUND_HALF_UP).round() );

        var newDiscountPercentage = (standPrice > 0 )?(1 - (unitPrice / standPrice)) * 100 : 0;

        var defaultDiscount;
        if ( contractLevel.innerHTML  ) {
        		defaultDiscount = (1- contractLevel.innerHTML) * 100  ;
        }

        discount=parseFloat(discount).toFixed(2);
        discount.value = ( newDiscountPercentage !=  defaultDiscount ) ? new BigNumber( newDiscountPercentage, 2, BigNumber.ROUND_HALF_UP).round() :0 ;


        calculateGrandTotal ( );

    }


    /*
        Calculate Grand Total
    */
    function calculateGrandTotal ( ) {
        var grandTotal = 0;

        jQuery('#oliList td:not(.deletedRow):not(.childTotal)').children('span[id$="oliTotal"]').each(function(index) {
            grandTotal += parseFloat ( jQuery(this).text().replace(/,/g, '') );
        });

        var totalElId = "#" + jQuery.escape( 'ProductPicker:mainForm:totalPanel:grandTotal' );
        var discountElId = "#" + jQuery.escape( 'ProductPicker:mainForm:totalPanel:oppDiscountPercentage' );
        var discountedAmountElId = "#" + jQuery.escape( 'ProductPicker:mainForm:totalPanel:oppDiscountedAmount' );
        var discountPercentage = 1-( $globalDiscountElem.val() * .01);
        discountPercentage=parseFloat(discountPercentage).toFixed(2);
        1-( $globalDiscountElem.val() * .01);
        var discountedTotal =  grandTotal * discountPercentage ;

        jQuery( 'input:text#oppDiscountPercentage' ).text (addCommas(new BigNumber(discountedTotal, 2, BigNumber.ROUND_HALF_UP).round()));
        var discountAmount = grandTotal * ( $globalDiscountElem.val() * .01)
        discountAmount = Math.round(discountAmount*100)/100 ;

        if(jQuery('input:text#oppDiscountAmount').attr('value') == 0){
            jQuery('input:text#oppDiscountAmount').attr({value: discountAmount });
        }
        jQuery( totalElId ).text (
                addCommas( new BigNumber(grandTotal, 2, BigNumber.ROUND_HALF_UP).round() )
            );

    }

    function calculateDiscountFromAmount ( ) {
        var discountAmount = jQuery('input:text#oppDiscountAmount').attr('value');
        var discountedAmountElId = "#" + jQuery.escape( 'ProductPicker:mainForm:totalPanel:oppDiscountedAmount' );
        var discountElId = "#" + jQuery.escape( 'ProductPicker:mainForm:totalPanel:oppDiscountPercentage' );
        var totalElId = "#" + jQuery.escape( 'ProductPicker:mainForm:totalPanel:grandTotal' );
        //set row discounts to 0 to get "raw" price
        jQuery( ".oliDiscountCell" ).attr ({value: '0'}).change() ;
        calculateGrandTotal();

        var totalBeforeDiscount = jQuery(totalElId).text().replace(/,/g, '');
        //confirm("total " + totalBeforeDiscount);
        var newDiscountPercentage = (discountAmount / totalBeforeDiscount) * 100 ;
        //var newDiscountPercentage = '20';
        $globalDiscountElem.val( newDiscountPercentage ).change();

        calculateGrandTotal();
    }

    function updateOliDiscounts ( ) {
        //when global discount changes, change the OLI discount fields to match

        if(confirm("This will overwrite all line item discounts.  Continue?")){

            var totalElId = "#ProductPicker\\:mainForm\\:totalPanel\\:grandTotal";

            calculateGrandTotal();
            var totalBeforeDiscount = jQuery(totalElId).text().replace(/,/g, '');


            var newDiscountPercentage = $globalDiscountElem.val();

			var $context = jQuery( "#oliList");

            $context.find ("input.oliDiscountCell:not(.nonDiscountable):not(.oliPreDiscountCell)" ).val( newDiscountPercentage ).change();

            $context.find ("input.oliPreDiscountCell:not(.nonDiscountable)" ).each ( function (index) {
				if (newDiscountPercentage==0) {
					//get base Id
        			var baseId   = this.id.substring(0, this.id.lastIndexOf(':') + 1);
	        		
	        		//get Elements
        			var contractLevelElem = document.getElementById(baseId + 'oliContractLevel');
					var defaultVal = (contractLevelElem.innerHTML) ? (1 - contractLevelElem.innerHTML) *100: 0;
					jQuery(this).val( defaultVal ).change();

				}else{
	        		jQuery(this).val( newDiscountPercentage ).change();
				}

      		});

            $context.find ("input[id$='oliDiscount']:.nonDiscountable" ).attr('disabled', 'disabled');

            calculateGrandTotal();

            if ( newDiscountPercentage !=  0 ){
            	var totalAfterDiscount = jQuery(totalElId).text().replace(/,/g, '');
            	var dollarDiscount = totalBeforeDiscount - totalAfterDiscount;
            	dollarDiscount = addCommas( new BigNumber(dollarDiscount, 2, BigNumber.ROUND_HALF_UP).round() )
            }else{
            	dollarDiscount= 0;
            }

            jQuery( '#oppDiscountAmount' ).val( dollarDiscount );
        }
    }

    function addCommas(nStr)
    {
         nStr += '';
         x = nStr.split('.');
         x1 = x[0];
         x2 = x.length > 1 ? '.' + x[1] : '';
         var rgx = /(\d+)(\d{3})/;
         while (rgx.test(x1)) {
          x1 = x1.replace(rgx, '$1' + ',' + '$2');
         }
         return x1 + x2;
    }

    function isNumberKey(evt) {
         var charCode = (evt.which) ? evt.which : event.keyCode
         if (charCode > 31 && (charCode < 48 || charCode > 57))
            return false;
         return true;
     }

/********************* Auto complete functionality ****************************/


	/* Note: implement catch to improve performance   */
	var productSuggestions = function(request, response) {

		  var base = '#ProductPicker\\:mainForm\\:ProductBlock\\:';
		  var $comboElem = $j( base+ "selectProductAutoComplete");
          var $familyElem= $j(base + 'familySelect');
          //var $publicationElem= $j(base + 'pubSelect');
          //var $categoryElem= $j(base + 'categorySelect');
          var $productTypeElem= $j(base + 'prodType');
          //var $colorElem= $j(base + 'colorType');
          //var $adTypeElem= $j(base + 'adType');

		  var selectedPricebook = $j('#selectedPricebook2Id').val();

          var $isMichiganUser = $j('#isMichiganUser');
          var contractLevel = 'all.types';

          if( $isMichiganUser.val() !== "true" )
          	contractLevel = $j(base + 'contractType').val();

		  var searchTerm = request.term;
		  var data  = new Array();

		  OpportunityProductPickerContExt.searchProducts(
		  	selectedPricebook,
		  	$familyElem.val(),
		  	$productTypeElem.val(),
		  	searchTerm,
		  	function(result, event) {
	            	if (event.status) {

	                	for (i=0;i < result.length;i++){
							obj = {
                                        id: result[i].value,
                                        label: result[i].label,
                                        value: result[i].label
                            };
                            data[i] = obj;

	                	}
	                }else{
						alert ( ' Cannot find any product. Contact the System administrator if the problem persist.' );
	                }

	                response(data);
		  });
	};


(function($) {
        jQuery.widget("ui.combobox", {
             options: {
	             delay: 250,
	             minLength: 0
             },
             reset: function() {
	                this.element.val("");
	                this.input.val("");
	         },
	         focus: function() {
	                    this.input.focus();
             },
            _create: function() {
                var self = this;
                //var select = this.element.hide();
                var select = this.element;
                var input = jQuery("<input>")
                    .insertAfter(select)
                    .attr("id", this.element[0].id + ":input")
                    .autocomplete({
                        delay:  self.options.delay,
                        minLength: self.options.minLength,
                        source: self.options.source,
                        change: function(event, ui) {
                            if (!ui.item) {
                                // remove invalid value, as it didn't match anything
                                select.val("");
                                return false;
                            }
                            select.val(ui.item.id);
                            self._trigger("selected", event, {
                                item: select.find("[value='" + ui.item.id + "']")
                            });

                        },
                        select: function(event, ui) {
 							if (ui.item && select.val() != ui.item.value) {
                               select.val(ui.item.id);
	                           this.value = ui.item.label.replace("amp;","");
	                           self.options.onchange && self.options.onchange();
							}
                           return false;
                        }
                    })
                    .addClass("ui-widget ui-widget-content ui-corner-left");
                jQuery("<button>&nbsp;</button>")
                .attr("tabIndex", -1)
                .attr("title", "Show All Items")
                .insertAfter(input)
                .button({
                    icons: {
                        primary: "ui-icon-triangle-1-s"
                    },
                    text: false
                }).removeClass("ui-corner-all")
                .addClass("ui-corner-right ui-button-icon")
                .click(function() {
                     // close if already visible
                    if (input.autocomplete("widget").is(":visible")) {
                        input.autocomplete("close");
                        return false;
                    }
                    // pass empty string as value to search for, displaying all results
                    input.autocomplete("search", "");
                    input.focus();
                    return false;
                });
            }
        });

    })(jQuery);



/******************************************************************************/
