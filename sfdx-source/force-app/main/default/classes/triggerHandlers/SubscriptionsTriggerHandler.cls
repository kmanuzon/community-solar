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

    public override void onBeforeInsert()
    {
        validateEffectivityDates((List<Subscription__c>) getRecords());
    }

    public override void onBeforeUpdate(Map<Id,SObject> existingRecords)
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

        List<Subscription__c> changedRecords = (List<Subscription__c>) getChangedRecords(fields);

        if (!changedRecords.isEmpty())
        {
            validateEffectivityDates(changedRecords);
        }
    }

    private void validateEffectivityDates(List<Subscription__c> records)
    {
        // query subscriptions based on customer and shared solar system
        // store in domain
        // loop through records in trigger
        // select only customer
        // select only shared solar system
        // select new start date between existing start date and end date

        List<Subscription__c> otherSubscriptions =
            SubscriptionsSelector.newInstance()
                .selectByCustomerAndSharedSolarSystem(records);

        for (Subscription__c record : records)
        {
            String errorMessage = 'Customer has an existing subscription to Shared Solar System on this date.';
            String errorMessage2 = error(errorMessage, record, Schema.Subscription__c.Start_Date__c);
            record.Start_Date__c.addError(errorMessage2);
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
