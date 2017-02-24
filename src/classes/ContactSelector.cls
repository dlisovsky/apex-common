/**
 * Created by Vlad Khitrik on 25.02.2017.
 */

public with sharing class ContactSelector extends DynamicSelector {

    public ContactSelector() {
        super(Contact.SObjectType);
    }

    public List<Contact> selectByEmails(Set<String> emails) {
        fflib_QueryFactory queryFactory = newQueryFactory()
                .setCondition('Email IN :emails');

        String soql = queryFactory.toSOQL();

        System.debug('ContactSelector: selectByEmails: ' + soql);

        return Database.query(soql);
    }

}