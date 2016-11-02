@isTest
@testVisible
private class TestUtils
{
	
	@testVisible
	private static Contact testContact {get {
		if(testContact == null){
			testContact = createContact();
			insert testContact;
		}
		return testContact;
	} private set;}


	@testVisible
	private static Contact createContact(){
		return new Contact(
			FirstName = 'test',
			LastName = 'test'
		);
	}


	@testVisible
	private static Opportunity createOpportunity(Id contactId){

		return new Opportunity(
			Name = 'test',
			StageName = 'Initial',			
			CloseDate = Date.today().addDays(5)
		);

	}

}