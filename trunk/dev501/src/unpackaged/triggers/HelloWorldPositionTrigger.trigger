trigger HelloWorldPositionTrigger on Position__c (before insert, before update) {

	//TODO: Instantiate a list (array) of positions and assign the context of Trigger.new
	
	Position__c[] listPositions = Trigger.new;
	
	
	//TODO: Call the class in the HelloWorldPositionClass, passing in the list of positions
	HelloWorldPositionClass.takePositions(listPositions);
}