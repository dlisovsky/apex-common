public with sharing class DescribeCache{
    
	private final static Map<Schema.SObjectType, Schema.DescribeSObjectResult> objectDescibeCache = 
		new  Map<Schema.SObjectType, Schema.DescribeSObjectResult>();
		
	private final static Map<Schema.SObjectType, Map<Schema.SObjectField, Schema.DescribeFieldResult>> filedsDescribeCache = 
		new Map<Schema.SObjectType, Map<Schema.SObjectField, Schema.DescribeFieldResult>>();


	public static Schema.DescribeSObjectResult getSObjectDescribe(Schema.SObjectType sObjetcType){
		Schema.DescribeSObjectResult describeResult = objectDescibeCache.get(sObjetcType);
		
		if (describeResult == null){
			describeResult = sObjetcType.getDescribe();
			objectDescibeCache.put(sObjetcType, describeResult);
		}
			
		return describeResult;
	}
	
	public static Schema.DescribeFieldResult getFieldDescribe(Schema.SObjectType sObjetcType, Schema.SObjectField fieldType){
		Map<Schema.SObjectField, Schema.DescribeFieldResult> objectFields = filedsDescribeCache.get(sObjetcType);
			
		Schema.DescribeFieldResult describeFieldResult;
			
		if (objectFields == null){
			objectFields = new Map<Schema.SObjectField, Schema.DescribeFieldResult>();			
		} else {
			describeFieldResult = objectFields.get(fieldType);			
		}			
		
		if (describeFieldResult == null){		    
			describeFieldResult = fieldType.getDescribe();
			objectFields.put(fieldType, describeFieldResult);
		}
			
		return describeFieldResult;
	}
}