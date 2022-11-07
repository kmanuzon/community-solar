/**
 * ISubscriptions
 *
 * @group Domain Interfaces
 */
public interface ISubscriptions extends IApplicationSObjects
{
    ISubscriptions addEndDateOverlapError();
    ISubscriptions addStartDateOverlapError();
    Set<Id> getCustomerIds();
    Set<Id> getSharedSolarSystemIds();
    ISubscriptions selectByCustomer(Id value);
    ISubscriptions selectByEndDateGreaterThanOrEqualToValue(Date value);
    ISubscriptions selectById(Set<Id> values);
    ISubscriptions selectByIdNotInValue(Id value);
    ISubscriptions selectBySharedSolarSystem(Id value);
    ISubscriptions selectByStartDateLessThanOrEqualToValue(Date value);
}
