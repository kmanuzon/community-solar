@IsTest
private class SubscriptionsSelectorTest
{
    @TestSetup
    private static void makeData()
    {
        Account accountRecord = new Account(Name = 'Orlando20221106');
        insert accountRecord;

        Shared_Solar_System__c sharedSolarSystemRecord = new Shared_Solar_System__c(
            Name = 'SunshineStateSolarSystem20221106'
        );
        insert sharedSolarSystemRecord;

        Subscription__c subscriptionRecord = new Subscription__c(
            Customer__c = accountRecord.Id,
            Shared_Solar_System__c = sharedSolarSystemRecord.Id,
            Start_Date__c = Date.newInstance(2001, 12, 4),
            End_Date__c = Date.newInstance(2002, 1, 4)
        );
        insert subscriptionRecord;
    }

    @IsTest
    private static void itShouldSelectById()
    {
        // given
        List<Subscription__c> initialRecords = [SELECT Id FROM Subscription__c ORDER BY Name ASC NULLS LAST];

        Set<Id> recordIds = new Set<Id> { initialRecords.get(0).Id };

        ISubscriptionsSelector selector = SubscriptionsSelector.newInstance();

        // when
        List<Subscription__c> finalRecords = selector.selectById(recordIds);

        // then
        System.assertEquals(false, finalRecords.isEmpty());
        System.assertEquals(initialRecords.get(0).Id, finalRecords.get(0).Id);
    }

    @IsTest
    private static void itShouldSelectByCustomerAndSharedSolarSystem()
    {
        // given
        List<Subscription__c> initialRecords = [
            SELECT Id, Customer__c, Shared_Solar_System__c
            FROM Subscription__c
            ORDER BY Name ASC NULLS LAST
        ];

        ISubscriptionsSelector selector = SubscriptionsSelector.newInstance();

        // when
        List<Subscription__c> finalRecords = selector.selectByCustomerAndSharedSolarSystem(initialRecords);

        // then
        System.assertEquals(false, finalRecords.isEmpty());
        System.assertEquals(initialRecords.get(0).Id, finalRecords.get(0).Id);
    }
}
