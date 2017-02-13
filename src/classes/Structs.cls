global class Structs {

    /*******************************************************************************************************
    
        Shared.
    
    *******************************************************************************************************/

    global abstract class ViewModel{

        public String getJSON(){
            return JSON.serialize(this);
        }

    }


    global class SelectOption{
        
        public Object value;
        public String label;
        
        public SelectOption(Object value, String label){
            this.value = value;
            this.label = label;
        }
    }

    global class LookupOption{
        public String id;
        public String label;

        public LookupOption(String id, String label){
            this.id= id;
            this.label = label;
        }
    }
    
    public virtual class LookupOptionRequest {
        public String searchTerm;
        public String parentId;
    }
    
    public static LookupOption convertSObjetToLookupOtion(sObject obj, String idFieldName, String labelFieldname){        
        return new LookupOption(
            (String)obj.get(idFieldName),
            (String)obj.get(labelFieldname)
        );    
    }

    public static LookupOption convertSObjetToLookupOtion(sObject obj, String labelFieldname){        
        return new LookupOption(
            (String)obj.get('Id'),
            (String)obj.get(labelFieldname)
        );    
    }

    public static LookupOption convertSObjetToLookupOtion(sObject obj){        
        return new LookupOption(
            (String)obj.get('Id'),
            (String)obj.get('Name')
        );    
    }

    public static List<LookupOption> convertSObjetsToLookupOtions(List<sObject> sObjects, String idFieldName, String labelFieldname){
        List<LookupOption> options = new List<LookupOption>();

        for(SObject obj : sObjects){
            options.add(convertSObjetToLookupOtion(obj, idFieldName, labelFieldname));
        }

        return options;
    }

    public static List<LookupOption> convertSObjetsToLookupOtions(List<sObject> sObjects, String labelFieldname){
        return convertSObjetsToLookupOtions(sObjects, 'Id', labelFieldname);
    }

    public static List<LookupOption> convertSObjetsToLookupOtions(List<sObject> sObjects){
        return convertSObjetsToLookupOtions(sObjects, 'Id', 'Name');
    }




    /*******************************************************************************************************
    
        Custom.
    
    *******************************************************************************************************/

}
