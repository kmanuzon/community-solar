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

        if (!changedRecords.isEmpty())
        {
            validateEffectivityDates(changedRecords);
        }
    }

    private void validateEffectivityDates(List<Subscription__c> records)
    {
        List<Subscription__c> existingSubscriptions =
            SubscriptionsSelector.newInstance().selectByCustomerAndSharedSolarSystem(records);

        ISubscriptions existingSubscriptionsDomain = Subscriptions.newInstance(existingSubscriptions);

        for (Subscription__c record : records)
        {
            // count existing records that overlap with start date
            Integer startDateOverlapCount =
                existingSubscriptionsDomain
                    .selectByIdNotInValue(record.Id)
                    .selectByCustomer(record.Customer__c)
                    .selectBySharedSolarSystem(record.Shared_Solar_System__c)
                    .selectByStartDateLessThanOrEqualToValue(record.Start_Date__c)
                    .selectByEndDateGreaterThanOrEqualToValue(record.Start_Date__c)
                    .getRecords()
                    .size();

            if (startDateOverlapCount > 0)
            {
                Schema.SObjectField startDateField = Schema.Subscription__c.Start_Date__c;
                String startDateOverlapError = System.Label.Community_Solar_Subscription_Start_Date_Overlap;

                record.addError(startDateField, error(startDateOverlapError, record, startDateField));
            }

            // count existing records that overlap with end date
            Integer endDateOverlapCount =
                existingSubscriptionsDomain
                    .selectByIdNotInValue(record.Id)
                    .selectByCustomer(record.Customer__c)
                    .selectBySharedSolarSystem(record.Shared_Solar_System__c)
                    .selectByStartDateLessThanOrEqualToValue(record.End_Date__c)
                    .selectByEndDateGreaterThanOrEqualToValue(record.End_Date__c)
                    .getRecords()
                    .size();

            if (endDateOverlapCount > 0)
            {
                Schema.SObjectField endDateField = Schema.Subscription__c.End_Date__c;
                String endDateOverlapError = System.Label.Community_Solar_Subscription_End_Date_Overlap;

                record.addError(endDateField, error(endDateOverlapError, record, endDateField));
            }
        }
    }

    public class Constructor implements fflib_SObjectDomain.IConstructable
    {
        public fflib_SObjectDomain construct(List<SObject> sObjects)
        {
            return new SubscriptionsTriggerHandler(sObjects);
        }
    }
}
