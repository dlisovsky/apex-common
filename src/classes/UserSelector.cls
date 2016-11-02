public class UserSelector extends fflib_SObjectSelector {

    private static List<Schema.SObjectField> FIELDS {get {
        if (FIELDS == null){
            FIELDS = Schema.SObjectType.User.fields.getMap().values();
        }
        return FIELDS;
    } private set;}

    public Schema.SObjectType getSObjectType(){
        return User.sObjectType;
    }
    
    public List<Schema.SObjectField> getSObjectFieldList(){
        return FIELDS;
    }
    
}