public with sharing class DynamicSearch {
	public String objectType{get;set;}
	
	private Map <String, Schema.SObjectType> schemaMap {
		get{
			if (schemaMap == null){
				//schemaMap = new Map<String,Schema.SObjectType>();
				// TODO: Delete the line directly above that reads:  schemaMap = new Map<String,Schema.SObjectType>();
				// TODO: Write a line here that sets the schemaMap property equal to the Map of SObjectTypes in the current org
				schemaMap = Schema.getGlobalDescribe();
				
			}	
			return schemaMap;
		}
		set;
	}
	
   public ID recordId {get; set;}
   public String searchText{get; set;}
   public List<Row> results{get; set;}
   private Map<ID,Row> resultMap {
   	get{
   		if (resultMap == null){
   			Map<ID,Row> tmpMap = new Map<ID,Row>();
   			for(Row r : results){
   				if (!tmpMap.containsKey(r.record.id)) tmpMap.put(r.record.id,r);
   			}
   			resultMap = tmpMap;
   		}
   		return resultMap;
   	}
   	set;
   }
   
   public List<String> fieldLabels {
   		get{
   			if (fieldLabels==null){
   				List<String> results = new List<String>();
   				List<String> tmpList = fields.split(',');
   				System.debug('tmpList=' + tmpList);
   				Map <String, Schema.SObjectField> fieldMap = schemaMap.get(objectType).getDescribe().fields.getMap();
				// "f" will contain the name of each field to be displayed
   				for (String f : tmpList){  					 
   					if (fieldMap.containsKey(f)) {	
   						System.debug('f=' + f);
					//	schema.describefieldresult df = new schema.describefieldresult();
						// TODO: Delete the line directly above that reads: schema.describefieldresult df = new schema.describefieldresult();
   						// TODO: Write a line that retrieves the DescribeFieldResult of the field named "f".  Name the DescribeFieldResult "df".
						Schema.DescribeFieldResult df = fieldMap.get(f).getDescribe();
   						System.debug(df);
   						results.add(df.getLabel());
   					}
   				}
   				fieldLabels = results;
   			}
   			return fieldLabels;
   		}
   		set;
   }
   
   public String fields{
   	get{
   		if (fields == null){
   			Search_Config__c config = [select fields__c from Search_Config__c where active__c = true and object_name__c = :objectType];
   			if (config != null){
   				fields = config.fields__c;
   			}
   		}
   		return fields;	
   	}
   	set;
   }
  
	
   // action method
   public PageReference doSearch() {  
   	String queryString = 'select id,' + fields + ' from ' + objectType + ' where ' + searchText;
    System.debug(queryString);
    //queryString = String.escapeSingleQuotes(queryString);
    try{
	   	List<sobject> lst = database.query(queryString);
	    System.debug(lst);  
	    List<Row> tmp = new List<Row>();
	     for(sobject l:lst) {
	     	Row r = new Row();
		    r.record = l;
			for(String field : fields.split(',')){
				Row.Cell c = new Row.Cell();
				c.fieldName = field;	
				c.fieldVal = l.get(field.trim())+'';
				r.cells.add(c);
			} 
		    tmp.add(r);       
	     }
	     results = tmp;        
	 } catch (DMLException e){
    	ApexPages.addMessages(e);	
    	return null;
     } catch (QueryException ex){
    	ApexPages.addMessages(ex);
    	return null;	
     } catch (Exception exx){
     	ApexPages.addMessages(exx);	
     	return null;
     }
     return null;
   }
   
   // action method
   public PageReference gotoRecord() { 
   	 // not sure if we can do this with a controller since this is dynamic
	 PageReference pageRef = new PageReference('/' + recordId);
   	 pageRef.setRedirect(true);
   	 return pageRef;
   }
}