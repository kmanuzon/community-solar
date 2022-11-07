/**
 * SubscriptionsSelector
 *
 * @group Selectors
 */
public class SubscriptionsSelector extends fflib_SObjectSelector
    implements ISubscriptionsSelector
{
    public static ISubscriptionsSelector newInstance()
    {
        return (ISubscriptionsSelector) Application.Selector.newInstance(Schema.Subscription__c.SObjectType);
    }

    public override String getOrderBy()
    {
        return 'Name ASC NULLS LAST';
    }

    public List<Schema.SObjectField> getSObjectFieldList()
    {
        return new List<Schema.SObjectField>
        {
            Schema.Subscription__c.Id,
            Schema.Subscription__c.Customer__c,
            Schema.Subscription__c.End_Date__c,
            Schema.Subscription__c.Name,
            Schema.Subscription__c.Shared_Solar_System__c,
            Schema.Subscription__c.Start_Date__c,
            Schema.Subscription__c.Status__c
        };
    }

    public Schema.SObjectType getSObjectType()
    {
        return Schema.Subscription__c.SObjectType;
    }

    public List<Subscription__c> selectById(Set<Id> ids)
    {
        return (List<Subscription__c>) selectSObjectsById(ids);
    }

    public List<Subscription__c> selectByCustomerAndSharedSolarSystem(List<Subscription__c> records)
    {
        ISubscriptions domain = Subscriptions.newInstance(records);

        return selectByCustomerAndSharedSolarSystem(domain.getCustomerIds(), domain.getSharedSolarSystemIds());
    }

    public List<Subscription__c> selectByCustomerAndSharedSolarSystem(Set<Id> customerIds, Set<Id> sharedSolarSystemIds)
    {
        fflib_QueryFactory queryFactory =
            newQueryFactory(false, false, true)
                .setCondition('Customer__c IN :customerIds AND Shared_Solar_System__c IN :sharedSolarSystemIds');

        return Database.query(queryFactory.toSOQL());
    }
}
