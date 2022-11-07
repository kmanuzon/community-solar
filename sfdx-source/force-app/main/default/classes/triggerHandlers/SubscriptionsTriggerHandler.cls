/**
 * SubscriptionsTriggerHandler
 *
 * @group Trigger Handlers
 */
public inherited sharing class SubscriptionsTriggerHandler extends ApplicationSObjectDomain
{
    public SubscriptionsTriggerHandler(List<Subscription__c> records)
    {
        super(records);
    }

    public override void onAfterInsert()
    {
        validateEffectivityDates(getRecords());
    }

    public override void onAfterUpdate(Map<Id, SObject> existingRecords)
    {
        onChangeEffectivityDates();
    }

    private void onChangeEffectivityDates()
    {
        Set<Schema.SObjectField> fields = new Set<Schema.SObjectField>
        {
            Schema.Subscription__c.Start_Date__c,
            Schema.Subscription__c.End_Date__c
        };

        List<Subscription__c> changedRecords = getChangedRecords(fields);

        if (changedRecords.isEmpty() == false)
        {
            validateEffectivityDates(changedRecords);
        }
    }

    private void validateEffectivityDates(List<Subscription__c> records)
    {
        List<Subscription__c> existingSubscriptions =
            SubscriptionsSelector.newInstance().selectByCustomerAndSharedSolarSystem(records);

        Set<Id> recordIdsWithStartDateOverlap = new Set<Id>();
        Set<Id> recordIdsWithEndDateOverlap = new Set<Id>();

        for (Subscription__c record : records)
        {
            Boolean hasExistingSubscriptionWithStartDateOverlap =
                Subscriptions.newInstance(existingSubscriptions)
                    .selectByIdNotInValue(record.Id)
                    .selectByCustomer(record.Customer__c)
                    .selectBySharedSolarSystem(record.Shared_Solar_System__c)
                    .selectByStartDateLessThanOrEqualToValue(record.Start_Date__c)
                    .selectByEndDateGreaterThanOrEqualToValue(record.Start_Date__c)
                    .isNotEmpty();

            if (hasExistingSubscriptionWithStartDateOverlap)
            {
                recordIdsWithStartDateOverlap.add(record.Id);
            }

            Boolean hasExistingSubscriptionWithEndDateOverlap =
                Subscriptions.newInstance(existingSubscriptions)
                    .selectByIdNotInValue(record.Id)
                    .selectByCustomer(record.Customer__c)
                    .selectBySharedSolarSystem(record.Shared_Solar_System__c)
                    .selectByStartDateLessThanOrEqualToValue(record.End_Date__c)
                    .selectByEndDateGreaterThanOrEqualToValue(record.End_Date__c)
                    .isNotEmpty();

            if (hasExistingSubscriptionWithEndDateOverlap)
            {
                recordIdsWithEndDateOverlap.add(record.Id);
            }
        }

        Subscriptions.newInstance(records).selectById(recordIdsWithStartDateOverlap).addStartDateOverlapError();
        Subscriptions.newInstance(records).selectById(recordIdsWithEndDateOverlap).addEndDateOverlapError();
    }

    public class Constructor implements fflib_SObjectDomain.IConstructable
    {
        public fflib_SObjectDomain construct(List<SObject> sObjects)
        {
            return new SubscriptionsTriggerHandler(sObjects);
        }
    }
}
