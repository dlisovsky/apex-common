public virtual class DynamicSelector extends fflib_SObjectSelector {

    private final Set<Schema.sObjectField> excludeFields;
    private final sObjectType sObjectTypeVar;
    private String orderBy;

    public DynamicSelector(sObjectType sObjectTypeVar){
        this(sObjectTypeVar, new Set<Schema.sObjectField>());
    }

    public DynamicSelector(sObjectType sObjectTypeVar, Set<Schema.sObjectField> excludeFields){
        super(false, false, false, false);
        this.sObjectTypeVar = sObjectTypeVar;
        this.excludeFields = excludeFields;
    }

    private List<Schema.SObjectField> FIELDS {
        get {
            if (FIELDS == null) {

                List<Schema.SObjectField> allFields = DescribeCache.getSObjectDescribe(this.sObjectTypeVar).fields.getMap().values();

                FIELDS = new List<Schema.SObjectField>();
                for(Schema.SObjectField field : allFields){
                    if(!this.excludeFields.contains(field) && field.getDescribe().isAccessible()){
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

    public DynamicSelector setOrderBy(String orderBy) {
        this.orderBy = orderBy;
        return this;
    }

    public override String getOrderBy() {
        return String.isNotBlank(this.orderBy) ? this.orderBy : super.getOrderBy();
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return FIELDS;
    }

    public sObject selectSingle(Id id){

        List<sObject> records = this.selectSObjectsById(new Set<Id>{id});

        if (records.isEmpty()){
            throw new Exceptions.MissingDataException('No record with Id: ' + id);
        }

        return records.get(0);

    }

    public List<SObject> selectAll() {

        fflib_QueryFactory queryFactory = newQueryFactory()
                .setLimit(50000);

        String soql = queryFactory.toSOQL();

        return Database.query(soql);
    }

    public List<sObject> selectByName(String name, Integer limitVar){

        name = String.format('%{0}%', new List<String>{String.isBlank(name) ? '' : name});

        fflib_QueryFactory queryFactory = newQueryFactory()
                .setCondition('Name LIKE :name')
                .setLimit(limitVar);

        String soql = queryFactory.toSOQL();

        return Database.query(soql);

    }


    public fflib_QueryFactory queryFactoryByAndConditions(List<String> conditions, Integer limitVar){
        return queryFactoryByCondition(
                String.join(conditions, ' AND '),
                limitVar
        );
    }

    public fflib_QueryFactory queryFactoryByCondition(String conditionString, Integer limitVar){
        return newQueryFactory()
                .setCondition(conditionString)
                .setLimit(limitVar);
    }

    public static String allOrLikeStringCondition(String name){
        return String.format('%{0}%', new List<String>{String.isBlank(name) ? '' : name});
    }


    public List<Structs.LookupOption> selectLookupOptions(Structs.LookupOptionRequest lookupOptionRequest, String parentField){

        String name = allOrLikeStringCondition(lookupOptionRequest.searchTerm);
        String parentId = lookupOptionRequest.parentId;

        List<String> conditions = new List<String>{
                'Name LIKE :name'
        };

        if(parentField != null && lookupOptionRequest.parentId != null){
            conditions.add(parentField + ' = :parentId');
        }

        fflib_QueryFactory queryFactory = this.queryFactoryByAndConditions(
                conditions,
                Constants.DEFAULT_LOOKUP_QUERY_LIMIT
        );

        String soql = queryFactory.toSOQL();

        System.debug('DynamicSelector: selectLookupOptions: ' + soql);

        List<sObject> options = Database.query(soql);

        return Structs.convertSObjetsToLookupOtions(options);
    }
}
