var $j = jQuery.noConflict();

function showOtherBusinessType() {
    if ($j( "[id$='businessType'] option:selected" ).text() == 'Other') {
        $j( "[id$='otherBusinessType']" ).show();
    }
    else {
        $j( "[id$='otherBusinessType']" ).hide();
        $j( "[id$='otherBusinessType']" ).val('');
    }
}

function showTickerSymbol() {
    if ($j( "[id$='publiclyTraded']" ).attr('checked') == 'checked') {
        $j( "[id$='tickerSymbol']" ).show();
    }
    else {
        $j( "[id$='tickerSymbol']" ).hide();
        $j( "[id$='tickerSymbol']" ).val('');
    }
}

function showOtherContractType() {
    if ($j( "[id$='contractType'] option:selected ").text() == 'Other') {
        $j( "[id$='otherContractType']" ).show();
    }
    else {
        $j( "[id$='otherContractType']" ).hide();
        $j( "[id$='otherContractType']" ).val('');
    }
}

function showRFPAwardedToTMobile() {
    if ($j( "[id$='resultOfRFP'] option:selected" ).text() == 'Yes') {
        $j( "[id$='RFPAwardedToTMobile']" ).show();
    }
    else {
        $j( "[id$='RFPAwardedToTMobile']" ).hide();
        $j( "[id$='RFPAwardedToTMobile']" ).val('');
    }
}

function showWaiver() {
    if ($j( "[id$='cancellationFee'] option:selected" ).text() == '% Waiver - Provide Details') {
        $j( "[id$='waiver']" ).show();
        $j( "[id$='waiverLabel']" ).show();
        $j( "[id$='waiverPercent']" ).show();
    }
    else {
        $j( "[id$='waiver']" ).hide();
        $j( "[id$='waiverLabel']" ).hide();
        $j( "[id$='waiverPercent']" ).hide();
        $j( "[id$='waiver']" ).val('');
    }
}

function markRequiredFields() {
    $j( ".required" ).parent().prepend("<div class='requiredDiv'/>");
}

function preparePage() {
    showOtherBusinessType();
    showTickerSymbol();
    showOtherContractType();
    showRFPAwardedToTMobile();
    showWaiver();
    markRequiredFields();
}

$j(document).ready(preparePage);