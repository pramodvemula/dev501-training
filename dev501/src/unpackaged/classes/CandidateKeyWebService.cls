global class CandidateKeyWebService {

	 webservice static Boolean submitEmployeeReferral(String posId, Candidate__c c){
		// this webservice receives a position Id, JobApplication and Candidate and creates the
		// JobApplication and optionally the Candidate, depending on whether or not it already exists
		
		// first we check to see if we'll need to create a candidate or not
		boolean cCreate = true; // default to true
		if (c.Email__c != null){
			String uKey = c.Last_Name__c.toLowerCase() + c.Email__c.toLowerCase();
			// query to find dupes
			if ([select count() from Candidate__c where unique_key__c = :uKey] >= 1) {
				cCreate=false;
				// set c to be the dupe candidate so we can get the Id value of the candidate later
				c = [select Id from Candidate__c where unique_key__c = :uKey limit 1];
			}
		}
		
		// create a boolean to catch any errors in case we need to rollback
		boolean err = false;
		
		// create the candidate if necessary based off previous check
		if (cCreate){
			try{
				insert c;
			} catch (System.DmlException e) {
				//update our err flag
				err = true;
				System.debug('error bulk inserting new candidate record');
				for (Integer k = 0; k < e.getNumDml(); k++) {
					// Process exception here
					System.debug(e.getDmlMessage(k));
				}
			}
		}
		
		// if there has been no error then create the Job Application
		if (!err){
			Job_Application__c j = new Job_Application__c();
			j.Status__c = 'Open';
			j.Stage__c = 'New';
			j.Position__c = posId;
			j.Candidate__c = c.id;
			
			try{
				insert j;
			} catch (System.DmlException e) {
				System.debug('error bulk inserting new job application');
				for (Integer k = 0; k < e.getNumDml(); k++) {
					// Process exception here
					System.debug(e.getDmlMessage(k));
				}
			}
		}
		
		// check for errors and return the success flag
		if (!err) {
			return true;
		} else {
		//	further error handling here
			return false;
		}	
	}
}