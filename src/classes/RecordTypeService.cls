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
	    return selectRecordTypesAsMapByKey(sObjectType, RecordType.Name);
	}
	
	public static Map<String, RecordType> selectRecordTypesAsMapByApiName(Schema.SobjectType sObjectType){
	    return selectRecordTypesAsMapByKey(sObjectType, RecordType.DeveloperName);
	}
	
	private static Map<String, RecordType> selectRecordTypesAsMapByKey(Schema.SobjectType sObjectType, Schema.SobjectField keyField){
	    List<RecordType> recordTypes = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SobjectType = :sObjectType AND IsActive = true];
	    
	    Map<String, RecordType> result = new Map<String, RecordType>();
	
	    String keyFieldName = '' + keyField;
	
	    for(RecordType recType : recordTypes){
	        String keyFieldValue = (String)recType.get(keyFieldName);
	        result.put(keyFieldValue, recType);
	    }
	    
	    return result;
	}
	
	public static Id getRecordTypeId(Schema.sObjectType sObjectType, String name){
		Map<String, RecordType> recordTypesMap = RecordTypeService.selectRecordTypesAsMapByName(sObjectType);
		RecordType recordTypeVar = recordTypesMap.get(name);
		if(recordTypeVar == null){
			throw new Exceptions.MissingDataException('No ' + sObjectType + ' RecordType with Name: ' + name);
		}	
		return recordTypeVar.Id;
	}
	
	public static Id getRecordTypeIdByApiName(Schema.sObjectType sObjectType, String apiName){
		Map<String, RecordType> recordTypesMap = RecordTypeService.selectRecordTypesAsMapByApiName(sObjectType);
		RecordType recordTypeVar = recordTypesMap.get(apiName);
		if(recordTypeVar == null){
			throw new Exceptions.MissingDataException('No ' + sObjectType + ' RecordType with Name: ' + apiName);
		}	
		return recordTypeVar.Id;
	}

}
