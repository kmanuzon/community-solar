/**
 * Application
 *
 * @group Applications
 */
public class Application
{
    public static final fflib_Application.UnitOfWorkFactory UnitOfWork =
        new fflib_Application.UnitOfWorkFactory(
            new List<SObjectType>
            {
                Schema.Account.SObjectType,
                Schema.Shared_Solar_System__c.SObjectType,
                Schema.Subscription__c.SObjectType
            }
        );

    public static final fflib_Application.ServiceFactory Service =
        new fflib_Application.ServiceFactory(new Map<Type, Type> {});

    public static final fflib_Application.SelectorFactory Selector =
        new fflib_Application.SelectorFactory(
            new Map<SObjectType, Type>
            {
                Schema.Subscription__c.SObjectType => SubscriptionsSelector.class
            }
        );

    public static final fflib_Application.DomainFactory Domain =
        new fflib_Application.DomainFactory(
            Application.Selector,
            new Map<SObjectType, Type> {}
        );
}
