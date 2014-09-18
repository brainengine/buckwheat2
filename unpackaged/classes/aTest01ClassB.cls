/**
	* aTest01ClassB - <description>
	* @author: Bob Sampson
	* @version: */

global class aTest01ClassB implements Messaging.InboundEmailHandler {
	global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
		Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
		//comment
		return result;
	}
}