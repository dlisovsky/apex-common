public class Utilities {

    /*******************************************************************************************************
    
        Lazy props.
    
    *******************************************************************************************************/
    
    public static PicklistExtentions picklistExtentions {get {
        if (picklistExtentions == null){
            picklistExtentions = new PicklistExtentions();
        }
        return picklistExtentions;
    } private set;}


    public static DateExtentions dateExtentions {get {
        if (dateExtentions == null){
            dateExtentions = new DateExtentions();
        }
        return dateExtentions;
    } private set;}


    public static StringExtentions stringExtentions {get {
        if (stringExtentions == null){
            stringExtentions = new StringExtentions();
        }
        return stringExtentions;
    } private set;}


    public static UserExtentions userExtentions {get {
        if (userExtentions == null){
            userExtentions = new UserExtentions();
        }
        return userExtentions;
    } private set;}


    public static SObjectExtentions sObjectExtentions {get {
        if (sObjectExtentions == null){
            sObjectExtentions = new SObjectExtentions();
        }
        return sObjectExtentions;
    } private set;}


    public static URLExtentions URLExtentions {get {
        if (URLExtentions == null){
            URLExtentions = new URLExtentions();
        }
        return URLExtentions;
    } private set;}


    public static EmailExtentions emailExtentions {get {
        if (emailExtentions == null){
            emailExtentions = new EmailExtentions();
        }
        return emailExtentions;
    } private set;}

    
    public static EncodingExtentions encodingExtentions {get {
        if (encodingExtentions == null){
            encodingExtentions = new EncodingExtentions();
        }
        return encodingExtentions;
    } private set;}


    public static ArrayExtentions arrayExtentions {get {
        if (arrayExtentions == null){
            arrayExtentions = new ArrayExtentions();
        }
        return arrayExtentions;
    } private set;}


    public static FormatExtentions formatExtentions {get {
        if (formatExtentions == null){
            formatExtentions = new FormatExtentions();
        }
        return formatExtentions;
    } private set;}





    /*******************************************************************************************************
    
        Picklist extentions.
    
    *******************************************************************************************************/

    public class PicklistExtentions{

        public List<Structs.SelectOption> getPicklistValuesAsSelectOptions(Schema.SObjectField sObjectField){
            return getPicklistValuesAsSelectOptions(sObjectField, null);
        }
        
        public List<Structs.SelectOption> getPicklistValuesAsSelectOptions(Schema.SObjectField sObjectField, Set<String> excuding){
            List<Structs.SelectOption> selectOptions = new List<Structs.SelectOption>();
            List<Schema.PicklistEntry> pickListEntries = sObjectField.getDescribe().getPicklistValues();
                    
            for( Schema.PicklistEntry pickListEntry : pickListEntries){
                if (excuding == null || !excuding.contains(pickListEntry.getValue())){
                    selectOptions.add(new  Structs.SelectOption(pickListEntry.getValue(), pickListEntry.getLabel()));   
                }
            }       
            return selectOptions;
        }
        

        // http://titancronus.com/blog/2014/05/01/salesforce-acquiring-dependent-picklists-in-apex/
        public Map<String, List<Structs.SelectOption>> getDependentOptions(Schema.SObjectType pType, Schema.SObjectField controllingField, Schema.SObjectField dependentField){

            final String pControllingFieldName = controllingField.getDescribe().getName();
            final String pDependentFieldName = dependentField.getDescribe().getName();

            Map<String, List<Structs.SelectOption>> objResults = new Map<String, List<Structs.SelectOption>>();
            if (pType==null)
                return objResults;
            Bitset BitSetInstance = new Bitset();
            Map<String, Schema.SObjectField> objFieldMap = pType.getDescribe().fields.getMap();
            //verify field names
            if (!objFieldMap.containsKey(pControllingFieldName) || !objFieldMap.containsKey(pDependentFieldName))
                return objResults;     
            //get the control values   
            List<Schema.PicklistEntry> ctrl_ple = objFieldMap.get(pControllingFieldName).getDescribe().getPicklistValues();
            //get the dependent values
            List<Schema.PicklistEntry> dep_ple = objFieldMap.get(pDependentFieldName).getDescribe().getPicklistValues();
            objFieldMap = null;
            List<Integer> lstControllingIndexes = new List<Integer>();
            //iterate through the values and get the ones valid for the controlling field name
            //set up the results
            for(Integer pControllingIndex=0; pControllingIndex<ctrl_ple.size(); pControllingIndex++){           
                //get the pointer to the entry
                Schema.PicklistEntry ctrl_entry = ctrl_ple[pControllingIndex];
                //get the label
                String pControllingLabel = ctrl_entry.getLabel();
                //create the entry with the label
                objResults.put(pControllingLabel,new List<Structs.SelectOption>());
                //keep track of the controlling indexes
                lstControllingIndexes.add(pControllingIndex);
            }
            //cater for null and empty
            objResults.put('',new List<Structs.SelectOption>());
            objResults.put(null,new List<Structs.SelectOption>());
            //load all dep entries
            List<Schema.PicklistEntry> objEntries = new List<Schema.PicklistEntry>();
            List<TPicklistEntry> objDS_Entries = new List<TPicklistEntry>();
            //add all entries
            for(Integer pDependentIndex=0; pDependentIndex<dep_ple.size(); pDependentIndex++){          
                //get the pointer to the dependent index
                Schema.PicklistEntry dep_entry = dep_ple[pDependentIndex];
                objEntries.add(dep_entry);
                
            } 
            //serialize once        
            objDS_Entries = (List<TPicklistEntry>)JSON.deserialize(JSON.serialize(objEntries), List<TPicklistEntry>.class);
            List<Integer> validIndexes;
            for (TPicklistEntry objDepPLE : objDS_Entries){
                //if valid for is empty, skip    
                if (objDepPLE.validFor==null || objDepPLE.validFor==''){
                    continue;
                }
                //get the test for the controlling indexes
                validIndexes = BitSetInstance.testBits(objDepPLE.validFor,lstControllingIndexes);
                for (Integer validIndex : validIndexes){                
                    //get the label
                    String pControllingLabel = ctrl_ple[validIndex].getLabel();
                    objResults.get(pControllingLabel).add(new Structs.SelectOption(objDepPLE.value, objDepPLE.label));
                }
            }
            objEntries = null;
            objDS_Entries = null;
            objResults.remove('');
            objResults.remove(null);
            return objResults;
        }

    }




    
    /*******************************************************************************************************
    
        Date and DateTime extentions.
    
    *******************************************************************************************************/

    public class DateExtentions {            

        public DateTime dateToDateTime(Date d) {
            return DateTime.newInstance(d.year(), d.month(), d.day(), 0, 0, 0);
        }
        
        public Integer totalWorkingDays(Date startDate, Date endDate) {
            
            DateTime sdate = DateToDateTime(startDate);
            DateTime edate = DateToDateTime(endDate);
             
            Integer i = 0;
                         
            while (sdate <= edate) {
                if (IsWorkingDay(sdate) == true) {
                    i = i + 1;
                }
                sdate = sdate.addDays(1);
            }
                  
            return i;

        }
        
        public Boolean isWorkingDay(Date d) {
            DateTime dt = DateToDateTime(d);
            return IsWorkingDay(dt);
        }
        
        public Boolean isWorkingDay(DateTime dt) {
            return (dt.format('E') != 'Sat' && dt.format('E') != 'Sun');
        }
        
        public Time timeStringToTime(String t) {
            String[] arr = t.split(':');
            return Time.newInstance(
                Integer.valueOf(arr[0]),
                Integer.valueOf(arr[1]),
                0,
                0
            );
        }

        // 10:00 AM -> Time.
        public Time timeStringAMPMToTime(String t) {
            
            if (String.isBlank(t)){
                throw new Exceptions.MissingDataException('Argument is null');
            }
            
            List<String> timeParts = t.split(' ');
            List<String> hoursMinutes = timeParts.get(0).split(':');
            
            String amPMStr = timeParts.get(1);
            String hoursStr = hoursMinutes.get(0);
            String minutesStr = hoursMinutes.get(1);
            
            Integer hours = Integer.valueOf(hoursStr);
            Integer minutes = Integer.valueOf(minutesStr);
            
            if('AM'.equals(amPMStr)){
                if (hours == 12){
                    hours = 0;
                }
            } else if ('PM'.equals(amPMStr)) {
                if (hours != 12){
                    hours = hours + 12;   
                }
            }
            
            return Time.newInstance(
                hours,
                minutes,
                0,
                0
            );
        } 
                
        
        public DateTime getStartOfDay(DateTime dateTimeVar){
            return DateTime.newInstance(dateTimeVar.year(), dateTimeVar.month(), dateTimeVar.day(), 0, 0, 0);
        }
        
        public DateTime getEndOfDay(DateTime dateTimeVar){
            return DateTime.newInstance(dateTimeVar.year(), dateTimeVar.month(), dateTimeVar.day(), 23, 59, 9);
        }
        
        public DateTime getStartDateOfWeek(DateTime dateTimeVar){
            Integer dayOfWeek = Integer.valueOf(dateTimeVar.format('u'));    
            DateTime startDateOfWeek = dateTimeVar.addDays(-1 * (dayOfWeek - 1));
            return getStartOfDay(startDateOfWeek);
        }
        
        public Date getStartDateOfWeek(Date dateVar){
            return getStartDateOfWeek(DateToDateTime(dateVar)).date();
        }
        
        public DateTime getEndDateOfWeek(DateTime dateTimeVar){
            return getEndOfDay(getStartDateOfWeek(dateTimeVar).addDays(6));
        }
        
        public Date getEndDateOfWeek(Date dateVar){
            return getEndDateOfWeek(DateToDateTime(dateVar)).date();
        }
        
        public Boolean isDateInCurrectWeekOrInFuture(Date dateVar){    
            return dateVar >= getStartDateOfWeek(Date.today());
        }
        
        public Date getLastDayInMonth(Date dateVar){
            return dateVar.addMonths(1).toStartofMonth().addDays(-1);
        }
        
        public Date getLastWorkingDay(Date dateVar){
            while(!IsWorkingDay(dateVar)){
                dateVar = dateVar.addDays(-1);
            }
            return dateVar;
        }
        
        public Date getLastDayInFortnight(Date dateVar, Date startDate){
            
            if (dateVar < startDate){
                throw new Exceptions.UtilityException('getLastDayInFortnight error: Date should be greater than Period Start Date');
            }
            
            Date startOfThePeriod = getStartDateOfWeek(startDate);
            Date endOfThePeriod = startOfThePeriod.addDays(13);
            
            while(dateVar > endOfThePeriod){
                endOfThePeriod = endOfThePeriod.addDays(14);
            }
            
            return endOfThePeriod;
        }
        
        public Date getFirstDayInFortnight(Date dateVar, Date startDate){
            Date endOfThePeriod = getLastDayInFortnight(dateVar, startDate);
            return endOfThePeriod.addDays(-13);
        }
        
        public Date dateInRange(Date dateVar, Date startOfRange, Date endOfRange){
        
            dateVar = startOfRange > dateVar ? startOfRange : dateVar;
            dateVar = endOfRange < dateVar ? endOfRange : dateVar;
            
            return dateVar; 
        }
        
    }
    




    /*******************************************************************************************************
    
        String extentions.
    
    *******************************************************************************************************/

    public class StringExtentions {
        
        public String emptyStringIfNull(String str){
            return String.isBlank(str) ? '' : str;
        }

        public String removeNonNumeric(String str) {
            return String.isEmpty(str) ? str : str.replaceAll('[^0-9]*', '');
        }

        public String Pad(Integer source, Integer length, String value) {
            return this.Pad(String.valueOf(source), length, value);
        }
        
        public String Pad(String source, Integer length, String value)
        {
            if (value.length() != 1)
                throw new Exceptions.UtilityException('You can only pad using a single character.');
            
            if (source.length() < length)
            {
                for (Integer i = source.length(); i < length; i++) {
                    source = value + source;
                }
            }
            
            return source;
        }

        /**
        * Split a string of any size, while avoiding the dreaded 'Regex too complicated'
        * error, which the String.split(String) method causes on some large inputs.
        *
        * Note that this method does not avoid other errors, such as those related to 
        * excess heap size or CPU time.
        */
        public List<String> safeSplit(String inStr, String delim) {
            
            Integer regexFindLimit = 100;
            Integer regexFindCount = 0;
            
            List<String> output = new List<String>();
            
            Matcher matcher = Pattern.compile(delim).matcher(inStr);
            
            Integer lastEnd = 0;
        
            while(!matcher.hitEnd())
            {
                while(regexFindCount < regexFindLimit && !matcher.hitEnd())
                {
                    if(matcher.find())
                    {
                        output.add(inStr.substring(lastEnd, matcher.start()));  
                        lastEnd = matcher.end();
                    }
                    else
                    {
                        output.add(inStr.substring(lastEnd));
                        lastEnd = inStr.length();
                    }
                    
                    regexFindCount++;
                }
        
                // Note: Using region() to advance instead of substring() saves 
                // drastically on heap size. Nonetheless, we still must reset the 
                // (unmodified) input sequence to avoid a 'Regex too complicated' 
                // error.
                matcher.reset(inStr);        
                matcher.region(lastEnd, matcher.regionEnd());
                
                regexFindCount = 0;
            }
            
            return output;
        }
        
    }
    




    /*******************************************************************************************************
    
        User extentions.
    
    *******************************************************************************************************/

    public class UserExtentions {
        
        public final String LICENCE_PROFILE_CHATTER_FREE_USER = 'Chatter Free User';
        
        public Id GetProfileIdByName(string profileName)
        {
            Profile p = [SELECT Id FROM Profile WHERE Name = :profileName LIMIT 1];
            
            if (p != null)
                return p.Id;
                
            throw new Exceptions.MissingDataException('Could not find a profile named \'' + profileName + '\'.');
        }
        
        public User CreateUser(fflib_ISObjectUnitOfWork uow, String firstName, String lastName, String email, String communityNickname, 
            String userName, String alias, String employeeNumber, Id profileId, Boolean isActive)
        {
            User u = new User();
            u.CommunityNickname = communityNickname; 
            u.Username = userName;
            u.Email = email;
                
            /// Need to make dynamic.
            u.EmailEncodingKey = 'UTF-8';
            u.LanguageLocaleKey = 'en_US';
            u.LocaleSidKey = 'en_AU';
            u.TimeZoneSidKey = 'Australia/Sydney';
                
            u.FirstName = firstName;
            u.LastName = lastName;
            u.ProfileId = profileId;
                
            u.EmployeeNumber = employeeNumber;
            u.Alias = (alias.length() > 8) ? alias.substring(0, 7) : alias;
            u.IsActive = isActive;
            
            if (uow != null)
                uow.registerNew(u);
            
            return u;
        }
        
    }
    
    



    /*******************************************************************************************************
    
        sObject extentions.
    
    *******************************************************************************************************/

    public class SObjectExtentions{

        public List<sObject> getSobjectsFromIds(Schema.sObjectType sObjectType, Set<Id> ids){
            List<sObject> sObjects = new List<sObject>();
            for(Id idVar : ids){
                sObject obj = sObjectType.newsObject();
                obj.Id = idVar;
                sObjects.add(obj);
            }
            return sObjects;
        }

        public Set<Id> getIdFieldValues(List<sObject> records, Schema.SObjectField field){

            Set<Id> values = new Set<Id>();

            String fieldName = '' + field;

            for(sObject rec : records){
                Id value = (Id)rec.get(fieldName);
                if (value != null){
                    values.add(value);
                }
            }

            return values;

        }

    }

    
    


    /*******************************************************************************************************
    
        URL extentions.
    
    *******************************************************************************************************/
    
    public class URLExtentions{

        public PageReference listView(Schema.sObjectType destinationSObject) {
            Schema.DescribeSObjectResult destination = destinationSObject.getDescribe();
            PageReference pageRef = new PageReference('/' + destination.getKeyPrefix() );
            pageRef.setRedirect(true);
            return pageRef;
        } 

    }




    /*******************************************************************************************************
    
        Email extentions.
    
    *******************************************************************************************************/

    public class EmailExtentions{

        public Messaging.SingleEmailMessage createSingleEmail(Id targetId, Id whatId, Id templateId){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTargetObjectId(targetId);
            mail.setWhatId(whatId);    
            mail.setTemplateId(templateId);
            mail.setSaveAsActivity(false);
            return mail;
        }

        public Id getEmailTemplateIdByName(String templateName){
            List<EmailTemplate> templates = [
                SELECT Id, Name, DeveloperName FROM EmailTemplate WHERE DeveloperName = :templateName
            ];
            
            return templates.isEmpty() ? null : templates[0].Id;
        }
    }





    /*******************************************************************************************************
    
        Encoding extentions.
    
    *******************************************************************************************************/

    public class EncodingExtentions{

        // map to application/x-www-form-urlencoded.
        public String mapToFormUrlEncoded(Map<String, String> dataMap){
            List<String> keyValuePairsEncoded = new List<String>();
            for(String key : dataMap.keySet()){
                keyValuePairsEncoded.add(String.format('{0}={1}', new List<String>{
                    System.EncodingUtil.urlEncode(key, 'UTF-8'),
                    System.EncodingUtil.urlEncode(dataMap.get(key), 'UTF-8')
                }));
            }

            return String.join(keyValuePairsEncoded, '&');
        }

        // application/x-www-form-urlencoded to map.
        public Map<String, String> formUrlEncodedToMap(String data){
            Map<String, String> dataMap = new Map<String, String>();

            List<String> paramsList = data.split('&');          

            for(String param : paramsList){
                List<String> keyValues = param.split('='); 
                if (keyValues.size() != 2){
                    throw new Exceptions.UtilityException('Parameter should contains key and value. ' + keyValues);
                }
                dataMap.put(
                    System.EncodingUtil.urlDecode(keyValues.get(0), 'UTF-8'), 
                    System.EncodingUtil.urlDecode(keyValues.get(1), 'UTF-8')
                );              
            }

            return dataMap;
        }

    }



    /*******************************************************************************************************
    
        Array extentions.
    
    *******************************************************************************************************/

    public class ArrayExtentions{

        public Object firstOrDefault(List<Object> records, Object defaultVar){
            return records.isEmpty() ? defaultVar : records[0];
        }

        public Object firstOrNull(List<Object> records){
            return firstOrDefault(records, null);
        }
        
        public String getMapFirstKey(Map<String, Object> mapVar){
            List<String> keys = new List<String>(mapVar.keySet());
            return (String)firstOrNull(keys);
        } 
        
        public List<Object> reverseList(List<Object> anArray){
            if (anArray == null) {
                return null;
            }
            Integer i = 0;
            Integer j = anArray.size() - 1;
            Object tmp;
            while (j > i) {
                tmp = anArray[j];
                anArray[j] = anArray[i];
                anArray[i] = tmp;
                j--;
                i++;
            }
            return anArray;
        }
    }

    



    /*******************************************************************************************************
    
        Format extentions.
    
    *******************************************************************************************************/

    public class FormatExtentions{

        public String formatAddress(sObject obj, String addressType){
            final List<String> addressFields = new List<String>{
                addressType + 'Street',  
                addressType + 'City',
                addressType + 'State',
                addressType + 'PostalCode',
                addressType + 'Country'
            };
            
            List<String> addressParts = new List<String>();
            for(String addressField : addressFields){
                String addressFieldValue = (String)obj.get(addressField);
                if (!String.isEmpty(addressFieldValue)){
                    addressParts.add(addressFieldValue);
                }
            }
            
            return String.join(addressParts, ', ');
        }


        /*
        formatPhoneNumbers(
            contacts, 
            new Map<Schema.sObjectField, IPhoneNumberFormatter> {
                Contact.Phone => new MobilePhoneNumberFormatter(),
                Contact.HomePhone => new HomePhoneNumberFormatter()
            },
            true
        )
        */
        public void formatPhoneNumbers(List<sObject> records, Map<Schema.sObjectField, IPhoneNumberFormatter> formatMapping, Boolean isOverride){
            
            for(sObject record : records){            

                for(Schema.sObjectField field: formatMapping.keySet()){

                    String fieldName = '' + field;
                    IPhoneNumberFormatter formater = formatMapping.get(field);

                    String oldValue = (String)record.get(fieldName);
                    if (String.isEmpty(oldValue) || isOverride == true){
                        record.put(fieldName, formater.format(oldValue));
                    }
                }
            }

        }

    }




    /*******************************************************************************************************
    
        Phone formatters.
    
    *******************************************************************************************************/

    public interface IPhoneNumberFormatter {
        String format(String phone);
    }
    
    // Formats Phone number to '0411 222 333'
    public class MobilePhoneNumberFormatter implements IPhoneNumberFormatter {
        
        public String format(String phone){
            if (String.isNotEmpty(phone)) {
                String phoneFormatted = stringExtentions.removeNonNumeric(phone);
                    
                phoneFormatted = phoneFormatted.replaceFirst('^(\\d{0,4})(\\d{0,3})(\\d{0,3})(\\d*)$', '$1 $2 $3 $4');
                    
                return phoneFormatted;
            }
            
            return phone; 
        }
        
    }
    
    // Formats phone to '+64 9 308 6200'
    public class HomePhoneNumberFormatter implements IPhoneNumberFormatter {
        
        public String format(String phone){
            if (String.isNotEmpty(phone)) {
                String phoneFormatted = stringExtentions.removeNonNumeric(phone);
                    
                phoneFormatted = phoneFormatted.replaceFirst('^(\\d{0,2})(\\d{0,4})(\\d{0,4})(\\d*)$', '$1 $2 $3 $4');
                    
                return phoneFormatted;
            }
            
            return phone;
        }
        
    }
    



    /*******************************************************************************************************
    
        Util.
    
    *******************************************************************************************************/

    private class TPicklistEntry{
        public string active {get;set;}
        public string defaultValue {get;set;}
        public string label {get;set;}
        public string value {get;set;}
        public string validFor {get;set;}
        public TPicklistEntry(){
            
        }
    }
    
    private class Bitset{
        public Map<String,Integer> AlphaNumCharCodes {get;set;}
        public Map<String, Integer> Base64CharCodes { get; set; }
        
        Bitset(){
            LoadCharCodes();
        }
        
        //Method loads the char codes
        private void LoadCharCodes(){
            AlphaNumCharCodes = new Map<String,Integer>{
                'A'=>65,'B'=>66,'C'=>67,'D'=>68,'E'=>69,'F'=>70,'G'=>71,'H'=>72,'I'=>73,'J'=>74,
                'K'=>75,'L'=>76,'M'=>77,'N'=>78,'O'=>79,'P'=>80,'Q'=>81,'R'=>82,'S'=>83,'T'=>84,
                'U'=>85,'V'=> 86,'W'=>87,'X'=>88,'Y'=>89,'Z'=>90    
            };
            Base64CharCodes = new Map<String, Integer>();
            //lower case
            Set<String> pUpperCase = AlphaNumCharCodes.keySet();
            for(String pKey : pUpperCase){
                //the difference between upper case and lower case is 32
                AlphaNumCharCodes.put(pKey.toLowerCase(),AlphaNumCharCodes.get(pKey)+32);
                //Base 64 alpha starts from 0 (The ascii charcodes started from 65)
                Base64CharCodes.put(pKey,AlphaNumCharCodes.get(pKey) - 65);
                Base64CharCodes.put(pKey.toLowerCase(),AlphaNumCharCodes.get(pKey) - (65) + 26);
            }
            //numerics
            for (Integer i=0; i<=9; i++){
                AlphaNumCharCodes.put(string.valueOf(i),i+48);
                //base 64 numeric starts from 52
                Base64CharCodes.put(string.valueOf(i), i + 52);
            }
        }
        
        /*
            Effect: Method takes a validFor string and tests it against a set of controlling indexes
            Postcondition: Returns a list of all controlling indexes for which the validFor string test True
        */
        public List<Integer> testBits(String pValidFor,List<Integer> nList){
            List<Integer> results = new List<Integer>();
            //the list of bytes (not derived from n)
            List<Integer> pBytes = new List<Integer>();
            //multiply by 6 since base 64 uses 6 bits (not derived form n)
            Integer bytesBeingUsed = (pValidFor.length() * 6)/8;
            //will be used to hold the full decimal value (not derived from n)
            Integer pFullValue = 0;
            //must be more than 1 byte
            if (bytesBeingUsed <= 1)
                return results;
            //get the base64bytes
            for(Integer i=0;i<pValidFor.length();i++){
                //get currenct character value
                pBytes.Add((Base64CharCodes.get((pValidFor.Substring(i, i+1)))));
            }   
            //calculate the full decimal value
            for (Integer i = 0; i < pBytes.size(); i++)
            {
                Integer pShiftAmount = (pBytes.size()-(i+1))*6;//used to shift by a factor 6 bits to get the value
                
                if (pBytes[i] != null){
                    pFullValue = pFullValue + (pBytes[i] << (pShiftAmount));   
                }
            }
            //now we don't want to always be declaring memory, so let's set the initial 
            //variables
            Integer bit;
            Integer targetOctet;
            Integer shiftBits;
            Integer tBitVal;
            Integer n;
            Integer nListSize = nList.size();
            for(Integer i=0; i<nListSize; i++){
                n = nList[i];
                //calculate the target bit for comparison
                bit = 7 - (Math.mod(n,8)); 
                //calculate the octet that has in the target bit
                targetOctet = (bytesBeingUsed - 1) - (n >> bytesBeingUsed); 
                //the number of bits to shift by until we find the bit to compare for true or false
                shiftBits = (targetOctet * 8) + bit;
                //& is to set the same set of bits for testing
                //shift to the bit which will dictate true or false
                //Math.Pow(2, shiftBits) == 2 << (shiftBits+1)
                tBitVal = ((Integer)(2 << (shiftBits-1)) & pFullValue) >> shiftBits;
                if (tBitVal==1)
                    results.add(n);
            }
            return results;
        }
    }
}
