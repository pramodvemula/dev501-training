public class HelloWorldTestClass {

	//TODO: Create a test method
	static testMethod void myTestMethod(){ 
		List<Position__c> positions = new List<Position__c>();
		for (Integer i=0; i < 10; i++){
			Position__c p = new Position__c();
			p.Name = 'testName' + i;
			p.Job_Description__c = 'testDescription' + i;
			positions.add(p);
		}
		
		//TODO: Wrap the following section in a try block
		try{
			System.debug('Attempting to insert positions');
			//TODO: Insert Positions
			insert(positions);
			System.debug('Insert complete');

			// refresh the Position list to include the Hello__c field after the insert
			
			//TODO: Create a position map to hold position IDs
			Map<ID, Position__c> posMap = new Map<ID, position__c>(positions);

			//TODO: Write a SOQL statement to retrieve id, name and Hello_c into positions based on the IDs in the position map
			positions = [select id, name, hello__c from position__c where id IN: posMap.keySet()];

			//TODO: Write a loop to iterate through the positions object
			for (Position__c position:positions){
			//TODO: Inside the loop: ensure position id is not null and hello field contains 'World'
				System.assertNotEquals(position.id, null);
				System.assertEquals(position.hello__c, 'World'); 
			//TODO: Inside the loop: write position id, name and Hello__c value to the debug log
				System.debug('' + position.id + position.name + position.hello__c); 
			}
			} catch (Exception e){
			//TODO: Wrap the following section in a catch block
			System.debug('We caught a DML exception: ' + e.getDmlMessage(0));	
		
			}
		
	}
	
}