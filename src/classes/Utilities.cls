public class Utilities {
	
	
	public static List<Structs.SelectOption> getPickListValuesAsSelectOptions(Schema.SObjectField sObjectField){
        return getPickListValuesAsSelectOptions(sObjectField, null);
    }
    
    public static List<Structs.SelectOption> getPickListValuesAsSelectOptions(Schema.SObjectField sObjectField, Set<String> excuding){
        List<Structs.SelectOption> selectOptions = new List<Structs.SelectOption>();
        List<Schema.PicklistEntry> pickListEntries = sObjectField.getDescribe().getPicklistValues();
                
        for( Schema.PicklistEntry pickListEntry : pickListEntries){
            if (excuding == null || !excuding.contains(pickListEntry.getValue())){
                selectOptions.add(new  Structs.SelectOption(pickListEntry.getValue(), pickListEntry.getLabel()));   
            }
        }       
        return selectOptions;
    }

}