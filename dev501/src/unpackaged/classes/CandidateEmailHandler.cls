global class CandidateEmailHandler implements Messaging.InboundEmailHandler {

    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        // declare the result variable
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        // declare a string variable to catch our custom debugging messages
        String myErr;
        try{       
            // extract the email body : either the htmlBody or the plainTextBody
            String theBody;       
            List<String> fieldList = new List<String>();
            if (email.plainTextBody != null){
            	myErr = 'plainTextBody=' + email.plainTextBody;
            	theBody = email.plainTextBody;
            	
            } else {
            	myErr = 'htmlBody=' + email.htmlBody;
                theBody = email.htmlBody;
            }
            // parse the body by the expected delimiters
            theBody = theBody.substring(theBody.indexOf('[STARTBODY]')+11,theBody.indexOf('[ENDBODY]'));
            fieldList = theBody.split(':',0);  
            // record the values in myErr in case of an Exception somewhere
            myErr += '\ntheBody=' + theBody;            
            myErr += '\nfieldList=' + fieldList;
            
            // create a Map for the field values: key=field name, value=field value
            Map<String,String> fieldMap = new Map<String,String>();
            for(String field : fieldList){
            	// the email contains name/value pairs like "firstname=mike", split them up
            	//	and if a value is present then add that field to the Map
                if (field.split('=',0).size() == 2){
                    fieldMap.put(field.split('=',0)[0],field.split('=',0)[1]);  
                }
            }
            
            // check for a matching candidate in the DB based on lastname + email
            Candidate__c candidate;
            try{
                candidate = [select id,first_name__c,last_name__c,phone__c,email__c,ownerid from candidate__c where last_name__c =:fieldMap.get('lastname') and email__c =:email.fromAddress];
            } catch (QueryException qe){
                if (candidate == null){
                    candidate = new Candidate__c();
                }
                // continue on...don't throw an error nor return result...we've handled the error we were expecting
            }
            // update or insert the field values that came in the email
            candidate.first_name__c = fieldMap.containsKey('firstname') ? EncodingUtil.urlDecode(fieldMap.get('firstname'),'UTF-8') : null;
            candidate.last_name__c = fieldMap.containsKey('lastname') ? EncodingUtil.urlDecode(fieldMap.get('lastname'),'UTF-8') : null;
            candidate.phone__c = fieldMap.containsKey('phone') ? EncodingUtil.urlDecode(fieldMap.get('phone'),'UTF-8') : null;
            candidate.email__c = email.fromAddress;
            
            try{
                if (candidate.id == null) {
                    insert candidate;   
                } else {
                    update candidate;
                }
            } catch (DMLException e){
            	// To keep a record of errors we've created a custom object called Error_Log__c for logging purposes
            	//	-Remember to clean out old log records regularly so as not to use up valuable storage
                Error_Log__c log = new Error_Log__c();
                log.trace__c = e.getTypeName() + '\n' + e.getCause() + '\n' + e.getMessage() + '\n\nfieldMap=' + fieldMap + '\n\nmyErr=' + myErr;
                insert log;
                // return false
                result.success = false;
                return result;
            }
            
            // create a new Note on the candidate containing the email comment
            if (fieldMap.containsKey('comment')){
                Note cNote = new Note();
                cNote.body = EncodingUtil.urlDecode(fieldMap.get('comment'),'UTF-8');
                cNote.parentId = candidate.id;
                cNote.title = 'CandidateEmail:' + System.now();
                try{
                    insert cNote;
                } catch (DMLException e){
                    Error_Log__c log = new Error_Log__c();
	                log.trace__c = e.getTypeName() + '\n' + e.getCause() + '\n' + e.getMessage() + '\n\nfieldMap=' + fieldMap + '\n\nmyErr=' + myErr;
	                insert log;
                    result.success = false; 
                    return result;
                }
            }
            
            // create a new attachment
            //  attachment may be text or binary
            List<Attachment> attachments = new List<Attachment>();
            if (email.binaryAttachments != null){
                for (Messaging.InboundEmail.BinaryAttachment emailAttachment:email.binaryAttachments){
                    Attachment attachment = new Attachment();
                    attachment.parentId = candidate.id;
                    attachment.body = emailAttachment.body;
                    attachment.name = emailAttachment.fileName; 
                    attachments.add(attachment);
                }
            }
            if (email.textAttachments != null){
                for (Messaging.InboundEmail.TextAttachment emailAttachment:email.textAttachments){
                    Attachment attachment = new Attachment();
                    attachment.parentId = candidate.id;
                    attachment.body = blob.valueOf(emailAttachment.body);
                    attachment.name = emailAttachment.fileName; 
                    attachments.add(attachment);
                }
            }
            // insert the attachments
            if (attachments.size() > 0){
                try{
                    insert attachments;
                } catch (DMLException e){
                    Error_Log__c log = new Error_Log__c();
	                log.trace__c = e.getTypeName() + '\n' + e.getCause() + '\n' + e.getMessage() + '\n\nfieldMap=' + fieldMap + '\n\nmyErr=' + myErr;
	                insert log;
                    result.success = false;
                    return result;
                }    
            }
            
            // Now send an email acknowledgement to the fromAddress
            // Reference the page, pass in a parameter to force PDF
		    // PageReference templatePage =  Page.CandidateEmailResponseTemplate;
		    // templatePage.getParameters().put('id',candidate.id); 
		    // templatePage.setRedirect(true);
		    // Grab the Page content as our "template"! 
		    // AW: This should work but there is a bug.  In Summer'08 I can't think of a workaround. 
		    //		I would factor the body generation out to a method that can easily be swapped for a Visualforce  page although in the next release we should have Visualforce email templates anyway
		    // String htmlBody = templatePage.getContent().toString();
			String htmlBody = buildOutboundEmailBody(candidate.first_name__c);
			
		    // Create an outbound email
		    Messaging.SingleEmailMessage emailOut = new Messaging.SingleEmailMessage(); 
		    emailOut.setSubject('Thank You for Your Email');

		    // TODO: Add the address that the inbound email came from to the ToAddresses of the outbound email

		    emailOut.setHtmlBody(htmlBody);
		    
		    try{
			// TODO: write the line that sends the outbound email and returns the email results
				Messaging.SendEmailResult[] mailResults = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{emailOut});
				// process the results	 
				//	Messaging.SendEmailResult[] mailResults = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailOut});
				// process the results	    	
	    		for (Messaging.SendEmailResult mailResult:mailResults){
	    			List<Error_Log__c> logs = new List<Error_Log__c>();
	    			if (!mailResult.isSuccess()){
	    				Error_Log__c log = new Error_Log__c();
	            		log.trace__c = 'Error sending email to candidate ' + candidate.id + ', ' + candidate.last_name__c + '\n' + mailResult;
	            		logs.add(log);
	    			}
	    			if (logs.size() > 0) insert logs;
	    		}		    	
			// TODO: loop through the mail results and write any errors to the Error_Log__c object in the trace__c field		    	
		    } catch (Exception e){
		    	Error_Log__c log = new Error_Log__c();
	            log.trace__c = e.getTypeName() + '\n' + e.getCause() + '\n' + e.getMessage() + '\n\nfieldMap=' + fieldMap + '\n\nmyErr=' + myErr;
	            insert log;
	            
	            // the inbound processing is still considered a success if the outbound email fails
                result.success = true;
                return result;
		    }
        } catch (Exception e){
            Error_Log__c log = new Error_Log__c();
            log.trace__c = e.getTypeName() + '\n' + e.getCause() + '\n' + e.getMessage() + '\n\nmyErr=' + myErr;
            insert log;
            
            result.success = false;         
            result.message = e.getTypeName() + '\n' + e.getCause() + '\n' + e.getMessage() + '\n\nmyErr=' + myErr;
            return result;
        }
         
        return result;
    }
    
    private String buildOutboundEmailBody(String candidateName){
    	// since the vforce html templates aren't working...
    	//	build the html here...when the bug is fixed we'll
    	//	swap out this method for the correct way
    	String body = '<html><body><center><h1>';
    	body += UserInfo.getOrganizationName() + '</h1></center><p>';
		body += 'Dear ' + candidateName + ',</p><p>';
		body += 'Thank you for your interest in Universal Containers.  Your email has been received and a recruiter will evaluate it for potential opportunities within the organization.';
        body += 'We will keep your information on file, including any resume submitted, for one year.  During that time our recruiters will regularly search our pool of resumes for potential matches ';
        body += 'within our open positions.  You may be contacted by one of our recruiters during the next year.  There is no need to respond to this email.';
        body += '</p><p>Once again, we thank you for your submission and interest.</p>';
        body += 'Best Regards,</p><p>Recruiting Dept., Universal Containers</p></p></body></html>';
    	
    	return body;	
    }
}