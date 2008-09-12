trigger OfferTrigger on Offer__c (after insert, after update) {
	// TODO: Create a List called "jobApps" to hold the JobApps to be updated
	List<Job_Application__c> jobApps = new List<Job_Application__c>();
	
	// There is a validation rule on the Offer__c object that requires Job_Application__c
	//	to be specified.  Therefore we can assume all offers have a valid JobApplication.
	for(List<Offer__c> offers:[select id,job_application__c,job_application__r.stage__c,job_application__r.status__c,job_application__r.name 
			from offer__c where id IN :Trigger.newMap.keySet()]){
		// TODO: Create an inner for loop to loop through the offers list
		for (Offer__c offer:offers){
			//TODO: Inside that loop, set the Stage to "Offer Extended" and the status to "Hold"
			offer.Job_Application__r.stage__c = 'Offer Extended';
			//TODO: Then add the related job app to the jobApps list and close the loop
			offer.Job_Application__r.Status__c = 'hold';
			jobApps.add(offer.job_application__r);
		}


	}
	// perform the update of job application records
	if (jobApps.size() > 0){
		try{
			//TODO: Update the jobApps and put the results in a SaveResult list called "saveResults"
			//List<SaveResult> saveResults = new List<SaveResult>();
			Database.SaveResult[] saveResults = Database.update(jobApps, false);
			// Now go through the results and send errors to the debug log
			Integer x = 0;
			for(Database.SaveResult result:saveResults){				
				if(!result.isSuccess()){
					// Get the first save result error
					Database.Error err = result.getErrors()[0];	
					System.debug('Unable to update Job Application, ' + jobApps[x].name + '.  Error:'+ err.getMessage());				
				}
				x++;			
			}
		} catch (Exception e){
			System.debug('error updating job applications:' + e);	
		}
	}
}