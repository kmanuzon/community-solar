/**
 * Subscriptions
 *
 * @group Domains
 */
public inherited sharing class Subscriptions extends ApplicationSObjects
    implements ISubscriptions
{
    public static ISubscriptions newInstance(List<Subscription__c> records)
    {
        return (ISubscriptions) Application.Domain.newInstance(records, Schema.Subscription__c.SObjectType);
    }

    public static ISubscriptions newInstance(Set<Id> recordIds)
    {
        return (ISubscriptions) Application.Domain.newInstance(recordIds);
    }

    public Subscriptions(List<Subscription__c> records)
    {
        super(records);
    }

    public ISubscriptions selectByCustomer(Id customerId)
    {
        return newInstance(getRecordsByFieldValue(Schema.Subscription__c.Customer__c, customerId));
    }

    public ISubscriptions selectByEndDateGreaterThanOrEqualToValue(Date value)
    {
        return newInstance(getRecordsByFieldGreaterThanOrEqualToValue(Schema.Subscription__c.End_Date__c, value));
    }

    public ISubscriptions selectByIdNotInValue(Id value)
    {
        return newInstance(getRecordsByFieldNotInValue(Schema.Subscription__c.Id, value));
    }

    public ISubscriptions selectBySharedSolarSystem(Id solarSystemId)
    {
        return newInstance(getRecordsByFieldValue(Schema.Subscription__c.Shared_Solar_System__c, solarSystemId));
    }

    public ISubscriptions selectByStartDateLessThanOrEqualToValue(Date value)
    {
        return newInstance(getRecordsByFieldLessThanOrEqualToValue(Schema.Subscription__c.Start_Date__c, value));
    }

    public class Constructor implements fflib_IDomainConstructor
    {
        public fflib_SObjects construct(List<Object> objects)
        {
            return new Subscriptions((List<SObject>) objects);
        }
    }
}
