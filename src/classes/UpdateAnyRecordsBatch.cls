global class UpdateAnyRecordsBatch implements Database.Batchable<sObject> {

    global SObjectType sObjectType;
    global List<String> conditions;

    global UpdateAnyRecordsBatch(SObjectType sObjectType, String condition) {
        this(sObjectType, new List<String>{condition});
    }

    global UpdateAnyRecordsBatch(SObjectType sObjectType, List<String> conditions) {
        this.sObjectType = sObjectType;
        this.conditions = conditions;
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        String queryString = 'SELECT Id FROM ' + sObjectType.getDescribe().getLocalName();
        if (conditions != null && conditions.size() > 0) {
            queryString += ' WHERE ' + String.join(conditions, ' AND ');
        }
        return Database.getQueryLocator(queryString);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        Database.update(scope, false);
    }

    global void finish(Database.BatchableContext BC) {}

}