public virtual class DynamicSelector extends fflib_SObjectSelector {

    private final Set<Schema.sObjectField> excludeFields;
    private final sObjectType sObjectTypeVar;

    public DynamicSelector(sObjectType sObjectTypeVar){
        this(sObjectTypeVar, new Set<Schema.sObjectField>());
    }

    public DynamicSelector(sObjectType sObjectTypeVar, Set<Schema.sObjectField> excludeFields){
        this.sObjectTypeVar = sObjectTypeVar;
        this.excludeFields = excludeFields;
    }

    private List<Schema.SObjectField> FIELDS {
        get {
            if (FIELDS == null) {

                List<Schema.SObjectField> allFields = DescribeCache.getSObjectDescribe(this.sObjectTypeVar).fields.getMap().values();

                FIELDS = new List<Schema.SObjectField>();
                for(Schema.SObjectField field : allFields){
                    if(!this.excludeFields.contains(field)){
                        FIELDS.add(field);
                    }
                }
            }
            return FIELDS;
        }
        private set;
    }

    public Schema.SObjectType getSObjectType() {
        return this.sObjectTypeVar;
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return FIELDS;
    }

}