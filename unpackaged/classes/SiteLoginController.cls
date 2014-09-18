/**
 * An apex page controller that exposes the site login functionality
* modified 10/12/2012
 */
global class SiteLoginController {
	
	//user parameters
    global String username {get; set;}
    global String password {get; set;}

	//login method
    global PageReference login() {
        String startUrl = System.currentPageReference().getParameters().get('startURL');
        return Site.login(username, password, startUrl);
    }
    
   	global SiteLoginController () {}
    
    global static testMethod void testSiteLoginController () {
        // Instantiate a new controller with all parameters in the page
        SiteLoginController controller = new SiteLoginController ();
        controller.username = 'test@salesforce.com';
        controller.password = '123456'; 
                
        System.assertEquals(controller.login(),null);                           
    }    
}