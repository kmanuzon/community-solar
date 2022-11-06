/**
 * ISubscriptionsSelector
 *
 * @group Selector Interfaces
 */
public interface ISubscriptionsSelector extends fflib_ISObjectSelector
{
    List<Subscription__c> selectById(Set<Id> ids);
    List<Subscription__c> selectByCustomerAndSharedSolarSystem(List<Subscription__c> subscriptions);
    List<Subscription__c> selectByCustomerAndSharedSolarSystem(Set<Id> customerIds, Set<Id> sharedSolarSystemIds);
}
