public class RecordTypeService { 

	
	/*
		Maps Record Type from two objects by names.
	*/
	/*
	public static Map<Id, RecordType> mapRecordTypesByName(Schema.SobjectType sourceSObjectType, Schema.SobjectType destSObjectType){
		
		List<RecordType> sourceRecordTypes = RecordTypeSelector.selectActiveBySObjectType(sourceSObjectType);
		List<RecordType> destRecordTypes = RecordTypeSelector.selectActiveBySObjectType(destSObjectType);

		return mapRecordTypesByName(
		    sourceSObjectType, 
		    destSObjectType,
		    sourceRecordTypes,
		    destRecordTypes
		);
	}	
	
	public static Map<Id, RecordType> mapRecordTypesByName(
	    Schema.SobjectType sourceSObjectType, 
	    Schema.SobjectType destSObjectType,
	    List<RecordType> sourceRecordTypes,
	    List<RecordType> destRecordTypes
	){
	    Map<Id, RecordType> result = new Map<Id, RecordType>();

		for(RecordType sourceRecordType : sourceRecordTypes){			
			for(RecordType destRecordType : destRecordTypes){
				if (sourceRecordType.Name.equalsIgnoreCase(destRecordType.Name)){
					result.put(sourceRecordType.Id, destRecordType);
				}
			}				
		}

		return result;
	}
	*/


	public static Map<String, RecordType> selectRecordTypesAsMapByName(Schema.SobjectType sObjectType){
	    List<RecordType> recordTypes = new RecordTypeSelector().selectActiveBySObjectType(sObjectType);
	    
	    Map<String, RecordType> result = new Map<String, RecordType>();
	
	    for(RecordType recType : recordTypes){
	        result.put(recType.Name, recType);
	    }
	    
	    return result;
	}

}