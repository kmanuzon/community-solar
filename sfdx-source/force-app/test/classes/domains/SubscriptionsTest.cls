@IsTest
private class SubscriptionsTest
{
    @IsTest
    private static void itShouldAddEndDateOverlapError()
    {
        // given
        String expectedErrorMessage = System.Label.Community_Solar_Subscription_End_Date_Overlap;
        Schema.SObjectField expectedErrorField = Schema.Subscription__c.End_Date__c;
        List<Subscription__c> initialRecords = new List<Subscription__c> { new Subscription__c() };

        // when
        ISubscriptions domain = Subscriptions.newInstance(initialRecords).addEndDateOverlapError();

        // then
        List<fflib_SObjects.Error> errors = fflib_SObjects.Errors.getAll();

        System.assertEquals(1, errors.size());

        fflib_SObjects.FieldError error = (fflib_SObjects.FieldError) errors.get(0);

        System.assertEquals(expectedErrorMessage, error.message);
        System.assertEquals(expectedErrorField, error.field);
    }

    @IsTest
    private static void itShouldAddStartDateOverlapError()
    {
        // given
        String expectedErrorMessage = System.Label.Community_Solar_Subscription_Start_Date_Overlap;
        Schema.SObjectField expectedErrorField = Schema.Subscription__c.Start_Date__c;
        List<Subscription__c> initialRecords = new List<Subscription__c> { new Subscription__c() };

        // when
        ISubscriptions domain = Subscriptions.newInstance(initialRecords).addStartDateOverlapError();

        // then
        List<fflib_SObjects.Error> errors = fflib_SObjects.Errors.getAll();

        System.assertEquals(1, errors.size());

        fflib_SObjects.FieldError error = (fflib_SObjects.FieldError) errors.get(0);

        System.assertEquals(expectedErrorMessage, error.message);
        System.assertEquals(expectedErrorField, error.field);
    }

    @IsTest
    private static void itShouldGetCustomerIds()
    {
        // given
        Id customerId = fflib_IDGenerator.generate(Schema.Account.SObjectType);

        List<Subscription__c> initialRecords = new List<Subscription__c>
        {
            new Subscription__c(Customer__c = customerId)
        };

        // when
        Set<Id> customerIds = Subscriptions.newInstance(initialRecords).getCustomerIds();

        // then
        System.assertEquals(false, customerIds.isEmpty());
        System.assertEquals(true, customerIds.contains(customerId));
    }

    @IsTest
    private static void itShouldGetSharedSolarSystemIds()
    {
        // given
        Id sharedSolarSystemId = fflib_IDGenerator.generate(Schema.Shared_Solar_System__c.SObjectType);

        List<Subscription__c> initialRecords = new List<Subscription__c>
        {
            new Subscription__c(Shared_Solar_System__c = sharedSolarSystemId)
        };

        // when
        Set<Id> sharedSolarSystemIds = Subscriptions.newInstance(initialRecords).getSharedSolarSystemIds();

        // then
        System.assertEquals(false, sharedSolarSystemIds.isEmpty());
        System.assertEquals(true, sharedSolarSystemIds.contains(sharedSolarSystemId));
    }

    @IsTest
    private static void itShouldSelectByCustomer()
    {
        // given
        Id customerId01 = fflib_IDGenerator.generate(Schema.Account.SObjectType);
        Id customerId02 = fflib_IDGenerator.generate(Schema.Account.SObjectType);
        Id customerId03 = fflib_IDGenerator.generate(Schema.Account.SObjectType);

        List<Subscription__c> initialRecords = new List<Subscription__c>
        {
            new Subscription__c(Customer__c = customerId01),
            new Subscription__c(Customer__c = customerId02),
            new Subscription__c(Customer__c = customerId03)
        };

        ISubscriptions domain = Subscriptions.newInstance(initialRecords);

        // when
        List<Subscription__c> actualRecords = domain.selectByCustomer(customerId02).getRecords();

        // then
        System.assertEquals(1, actualRecords.size());
        System.assertEquals(customerId02, actualRecords.get(0).Customer__c);
    }

    @IsTest
    private static void itShouldSelectByEndDateGreaterThanOrEqualToValue()
    {
        // given
        Date endDate01 = Date.newInstance(2001, 6, 6);
        Date endDate02 = Date.newInstance(2001, 12, 4);
        Date endDate03 = Date.newInstance(2001, 3, 30);

        List<Subscription__c> initialRecords = new List<Subscription__c>
        {
            new Subscription__c(End_Date__c = endDate01),
            new Subscription__c(End_Date__c = endDate02),
            new Subscription__c(End_Date__c = endDate03)
        };

        ISubscriptions domain = Subscriptions.newInstance(initialRecords);

        // when
        List<Subscription__c> actualRecords = domain.selectByEndDateGreaterThanOrEqualToValue(endDate02).getRecords();

        // then
        System.assertEquals(1, actualRecords.size());
        System.assertEquals(endDate02, actualRecords.get(0).End_Date__c);
    }

    @IsTest
    private static void itShouldSelectById()
    {
        // given
        Id subscriptionId01 = fflib_IDGenerator.generate(Schema.Subscription__c.SObjectType);
        Id subscriptionId02 = fflib_IDGenerator.generate(Schema.Subscription__c.SObjectType);
        Id subscriptionId03 = fflib_IDGenerator.generate(Schema.Subscription__c.SObjectType);

        Set<Id> subscriptionIds = new Set<Id> { subscriptionId02 };

        List<Subscription__c> initialRecords = new List<Subscription__c>
        {
            new Subscription__c(Id = subscriptionId01),
            new Subscription__c(Id = subscriptionId02),
            new Subscription__c(Id = subscriptionId03)
        };

        ISubscriptions domain = Subscriptions.newInstance(initialRecords);

        // when
        List<Subscription__c> actualRecords = domain.selectById(subscriptionIds).getRecords();

        // then
        System.assertEquals(1, actualRecords.size());
        System.assertEquals(subscriptionId02, actualRecords.get(0).Id);
    }

    @IsTest
    private static void itShouldSelectByIdNotInValue()
    {
        // given
        Id subscriptionId01 = fflib_IDGenerator.generate(Schema.Subscription__c.SObjectType);
        Id subscriptionId02 = fflib_IDGenerator.generate(Schema.Subscription__c.SObjectType);
        Id subscriptionId03 = fflib_IDGenerator.generate(Schema.Subscription__c.SObjectType);

        List<Subscription__c> initialRecords = new List<Subscription__c>
        {
            new Subscription__c(Id = subscriptionId01),
            new Subscription__c(Id = subscriptionId02),
            new Subscription__c(Id = subscriptionId03)
        };

        ISubscriptions domain = Subscriptions.newInstance(initialRecords);

        // when
        List<Subscription__c> actualRecords = domain.selectByIdNotInValue(subscriptionId02).getRecords();

        // then
        System.assertEquals(2, actualRecords.size());
        System.assertNotEquals(subscriptionId02, actualRecords.get(0).Id);
        System.assertNotEquals(subscriptionId02, actualRecords.get(1).Id);
    }

    @IsTest
    private static void itShouldSelectBySharedSolarSystem()
    {
        // given
        Id sharedSolarSystemId01 = fflib_IDGenerator.generate(Schema.Shared_Solar_System__c.SObjectType);
        Id sharedSolarSystemId02 = fflib_IDGenerator.generate(Schema.Shared_Solar_System__c.SObjectType);
        Id sharedSolarSystemId03 = fflib_IDGenerator.generate(Schema.Shared_Solar_System__c.SObjectType);

        List<Subscription__c> initialRecords = new List<Subscription__c>
        {
            new Subscription__c(Shared_Solar_System__c = sharedSolarSystemId01),
            new Subscription__c(Shared_Solar_System__c = sharedSolarSystemId02),
            new Subscription__c(Shared_Solar_System__c = sharedSolarSystemId03)
        };

        ISubscriptions domain = Subscriptions.newInstance(initialRecords);

        // when
        List<Subscription__c> actualRecords = domain.selectBySharedSolarSystem(sharedSolarSystemId02).getRecords();

        // then
        System.assertEquals(1, actualRecords.size());
        System.assertEquals(sharedSolarSystemId02, actualRecords.get(0).Shared_Solar_System__c);
    }

    @IsTest
    private static void itShouldSelectByStartDateLessThanOrEqualToValue()
    {
        // given
        Date startDate01 = Date.newInstance(2001, 6, 6);
        Date startDate02 = Date.newInstance(2001, 12, 4);
        Date startDate03 = Date.newInstance(2001, 3, 30);

        List<Subscription__c> initialRecords = new List<Subscription__c>
        {
            new Subscription__c(Start_Date__c = startDate01),
            new Subscription__c(Start_Date__c = startDate02),
            new Subscription__c(Start_Date__c = startDate03)
        };

        ISubscriptions domain = Subscriptions.newInstance(initialRecords);

        // when
        List<Subscription__c> actualRecords = domain.selectByStartDateLessThanOrEqualToValue(startDate03).getRecords();

        // then
        System.assertEquals(1, actualRecords.size());
        System.assertEquals(startDate03, actualRecords.get(0).Start_Date__c);
    }
}
