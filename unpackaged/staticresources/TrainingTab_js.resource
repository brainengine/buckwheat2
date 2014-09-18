var $j = jQuery.noConflict();

var domReady = false;
var youtubeReady = false;

var prepYouTubes = function()
{
	    // the map we will use to correctly associate a link with the correct video
    var videoMap = {};

    // iterate over each flash element
    $j('div[id$="flash"]').each(function(index, Element) {
        var playerId = $j(Element).data("playerid");
        
        var player = new YT.Player(playerId, {
            events: {}
        });
        
        // make each of them a jQuery UI dialog box
        $j(Element).dialog({
            width: 955,
            autoOpen: false,
            modal: true,
            resizable: false,
            draggable: false,
            close: function() {
                player.stopVideo();
            }
        });
       
       // also populate our lookup table
       videoMap[index] = Element;
    });
    
    // when an image is clicked, open the associated flash div
    $j('.tutImage').each(function(index, Element) {
        $j(Element).click(function(event) {
            $j(videoMap[index]).dialog('open');
       });
    });
}

function onYouTubeIframeAPIReady() {
	youtubeReady = true;
	
	if(domReady)
	{
		prepYouTubes();
	}
}

$j(function() {
	domReady = true;
	
	if(youtubeReady)
	{
		prepYouTubes();
	}
});