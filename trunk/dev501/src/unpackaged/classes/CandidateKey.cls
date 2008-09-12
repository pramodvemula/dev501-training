public class CandidateKey {

	// This method acts as a uniqueness checker for the Candidate object based on the Email__c field
	public static void hasCandidateDuplicates(Candidate__c[] candidates){
	
        	//TODO: Define a map for unique Candidates called "candidateMap" that maps a String to the Candidate
			Map<String, Candidate__c> candidateMap = new Map<String, Candidate__c>();
			
		//TODO: Declare a for loop to cycle through the candidates.
		for ( Candidate__c candidate:candidates){

            		// TODO: Within that loop, check to verify that the email is not null and if it has a value, store the lastName+email in a String called "uKey"
            		if (candidate.email__c != null){
            			String uKey = (candidate.last_name__c).toLowerCase() + (candidate.email__c).toLowerCase();
            			
			// and then check to see if there are duplicate uKeys within this batch of records.  If there are, use addError to prevent them,
						if (candidateMap.containsKey(uKey))
							candidate.addError('Duplicate lastname+email found');
						
			// and if not, add the uKey/candidate combo to the candidateMap.	
						else
							candidateMap.put(uKey, candidate);
            		}
		}

		
  		//Now hit the DB looking for dupes
  		if (!candidateMap.isEmpty()){
	  		for(Candidate__c[] candidatesCheck:[select Id, unique_key__c from Candidate__c where unique_key__c IN :candidateMap.keySet()]) {
				for(Candidate__c candidate:candidatesCheck) {
	  				String currentCandidateId = candidate.Id;
	  				//if there's a dupe and this isn't the current record, then add the error.
	  				if(candidateMap.containsKey(candidate.unique_key__c) && (currentCandidateId != candidateMap.get(candidate.unique_key__c).Id)) {
	     				candidateMap.get(candidate.unique_key__c).addError('Duplicate LastName + Email found in salesforce(id: ' + candidate.id + ')');
	  				}
	  			}
	    		}
  		} 
  	} 
}