public class UserSelector extends DynamicSelector {

    public UserSelector(){
        super(User.SObjectType, new Set<Schema.sObjectField>{
                User.SmallBannerPhotoUrl,
                User.MediumBannerPhotoUrl
        });
    }
    
}
