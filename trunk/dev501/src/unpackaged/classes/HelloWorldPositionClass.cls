public class HelloWorldPositionClass {
	
	/*TODO: Declare a static method that takes a list of positions*/  
	public static void takePositions (List<Position__c> positions){
			for (Position__c p:positions){
				if (p.Hello__c != 'World') {
		
					 p.Hello__c += 'World';
				}
			}
	}
}