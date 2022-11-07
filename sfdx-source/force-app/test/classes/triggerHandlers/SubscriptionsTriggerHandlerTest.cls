@IsTest
private class SubscriptionsTriggerHandlerTest
{
    @IsTest
    private static void itShouldValidateEffectivityDatesOnUpdate()
    {
        // given
        Id subscriptionId01 = fflib_IDGenerator.generate(Schema.Subscription__c.SObjectType);
        Id subscriptionId02 = fflib_IDGenerator.generate(Schema.Subscription__c.SObjectType);
        Id subscriptionId03 = fflib_IDGenerator.generate(Schema.Subscription__c.SObjectType);
        Id customerId01 = fflib_IDGenerator.generate(Schema.Account.SObjectType);
        Id sharedSolarSystemId01 = fflib_IDGenerator.generate(Schema.Shared_Solar_System__c.SObjectType);

        Date startDate01 = Date.newInstance(2022, 3, 1);
        Date startDate02 = Date.newInstance(2022, 4, 1);
        Date startDate03 = Date.newInstance(2022, 5, 1);
        Date startDate04 = Date.newInstance(2022, 4, 15);

        Date endDate01 = Date.newInstance(2022, 3, 31);
        Date endDate02 = Date.newInstance(2022, 4, 30);
        Date endDate03 = Date.newInstance(2022, 5, 31);
        Date endDate04 = Date.newInstance(2022, 4, 16);

        List<Subscription__c> existingRecords = new List<Subscription__c>
        {
            new Subscription__c(
                Id = subscriptionId01,
                Customer__c = customerId01,
                Shared_Solar_System__c = sharedSolarSystemId01,
                Start_Date__c = startDate01,
                End_Date__c = endDate01
            ),
            new Subscription__c(
                Id = subscriptionId02,
                Customer__c = customerId01,
                Shared_Solar_System__c = sharedSolarSystemId01,
                Start_Date__c = startDate02,
                End_Date__c = endDate02
            ),
            new Subscription__c(
                Id = subscriptionId03,
                Customer__c = customerId01,
                Shared_Solar_System__c = sharedSolarSystemId01,
                Start_Date__c = startDate03,
                End_Date__c = endDate03
            )
        };

        Map<Id, Subscription__c> existingRecordById = new Map<Id, Subscription__c>(existingRecords);

        List<Subscription__c> updatedRecords = new List<Subscription__c> { existingRecords.get(0).clone(true) };
        updatedRecords.get(0).Start_Date__c = startDate04;
        updatedRecords.get(0).End_Date__c = endDate04;

        // given mock
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        ISubscriptionsSelector selectorMock = (ISubscriptionsSelector) mocks.mock(ISubscriptionsSelector.class);

        mocks.startStubbing();
        mocks.when(selectorMock.sObjectType()).thenReturn(Schema.Subscription__c.SObjectType);
        mocks.when(selectorMock.selectByCustomerAndSharedSolarSystem(updatedRecords)).thenReturn(existingRecords);
        mocks.stopStubbing();

        Application.Selector.setMock(selectorMock);

        fflib_SObjectDomain.Test.Database.onUpdate(updatedRecords, existingRecordById);

        // when
        fflib_SObjectDomain.triggerHandler(SubscriptionsTriggerHandler.class);

        // then mock
        ((ISubscriptionsSelector) mocks.verify(selectorMock, 1)).selectByCustomerAndSharedSolarSystem(updatedRecords);

        // then errors
        List<fflib_SObjects.Error> errors = fflib_SObjects.Errors.getAll();

        System.assertEquals(2, errors.size());

        String startDateErrorMessage = System.Label.Community_Solar_Subscription_Start_Date_Overlap;
        String endDateErrorMessage = System.Label.Community_Solar_Subscription_End_Date_Overlap;

        Schema.SObjectField startDateField = Schema.Subscription__c.Start_Date__c;
        Schema.SObjectField endDateField = Schema.Subscription__c.End_Date__c;

        fflib_SObjects.FieldError startDateError = (fflib_SObjects.FieldError) errors.get(0);
        fflib_SObjects.FieldError endDateError = (fflib_SObjects.FieldError) errors.get(1);

        System.assertEquals(startDateErrorMessage, startDateError.message);
        System.assertEquals(startDateField, startDateError.field);

        System.assertEquals(endDateErrorMessage, endDateError.message);
        System.assertEquals(endDateField, endDateError.field);
    }
}
