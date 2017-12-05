@IsTest
private class UtilitiesTest {

	static testMethod void testBehavior() {
		System.assert(Utilities.picklistExtentions.getPicklistValuesAsSelectOptions(Contact.LeadSource) != null);

		Utilities.dateExtentions.dateToDateTime(Date.today());
		Utilities.dateExtentions.totalWorkingDays(Date.today(), Date.today().addDays(10));
		Utilities.dateExtentions.isWorkingDay(Date.today());
		Utilities.dateExtentions.timeStringToTime('2:10');
		Utilities.dateExtentions.timeStringAMPMToTime('2:10 AM');
		Utilities.dateExtentions.getStartOfDay(Datetime.now());
		Utilities.dateExtentions.getEndOfDay(Datetime.now());
		Utilities.dateExtentions.getStartDateOfWeek(Datetime.now());
		Utilities.dateExtentions.getEndDateOfWeek(Datetime.now());
		Utilities.dateExtentions.isDateInCurrectWeekOrInFuture(Date.today());
		Utilities.dateExtentions.getLastDayInMonth(Date.today());
		Utilities.dateExtentions.getLastWorkingDay(Date.today());
		Utilities.dateExtentions.getLastDayInFortnight(Date.today().addDays(10), Date.today());
		Utilities.dateExtentions.getFirstDayInFortnight(Date.today().addDays(10), Date.today());
		Utilities.dateExtentions.dateInRange(Date.today(), Date.today().addDays(-10), Date.today().addDays(10));


		Utilities.stringExtentions.emptyStringIfNull(null);
		Utilities.stringExtentions.removeNonNumeric('qwe123');
		Utilities.stringExtentions.pad(123, 2, 't');
		Utilities.stringExtentions.safeSplit('test:test', ':');
		Utilities.stringExtentions.newGuid();
		Utilities.stringExtentions.joinNonBlank(new List<String>{'test', null, 't'}, ',');


		Utilities.userExtentions.GetProfileIdByName('System Administrator');


		Utilities.sObjectExtentions.getSobjectsFromIds(User.SObjectType, new Set<Id>{UserInfo.getUserId()});
		Utilities.sObjectExtentions.getIdFieldValues(new List<User>{new User(ProfileId = UserInfo.getProfileId())}, User.ProfileId);

		Map<String, sObject> mappedRecords = new Map<String, sObject>();
		Utilities.sObjectExtentions.putAllRecordsByKeyField(
				new List<User>{new User(ProfileId = UserInfo.getProfileId())},
				'ProfileId',
				mappedRecords
		);
	}

}