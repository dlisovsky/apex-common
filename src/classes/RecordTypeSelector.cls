public class RecordTypeSelector extends DynamicSelector {

    public RecordTypeSelector(){
        super(RecordType.getSObjectType());
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