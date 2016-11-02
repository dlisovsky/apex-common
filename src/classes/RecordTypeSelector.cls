public class RecordTypeSelector extends fflib_SObjectSelector {

    private static List<Schema.SObjectField> FIELDS {get {
        if (FIELDS == null){
            FIELDS = Schema.SObjectType.RecordType.fields.getMap().values();
        }
        return FIELDS;
    } private set;}

    public Schema.SObjectType getSObjectType(){
        return RecordType.getSObjectType();
    }
    
    public List<Schema.SObjectField> getSObjectFieldList(){
        return FIELDS;
    }

    public List<RecordType> selectActiveBySObjectType(Schema.SobjectType sobjectType){

        final String sObjectTypeStr = '' + sobjectType;

        String soql = newQueryFactory()
            .setCondition('SobjectType = :sObjectTypeStr AND IsActive = true')
            .toSoql();

        System.debug('RecordTypeSelector.selectActiveBySObjectType: ' + soql);

        return (List<RecordType>)Database.query(soql);
    } 
    
}