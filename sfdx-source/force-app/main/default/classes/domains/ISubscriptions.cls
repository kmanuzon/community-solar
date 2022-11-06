/**
 * ISubscriptions
 *
 * @group Domain Interfaces
 */
public interface ISubscriptions extends IApplicationSObjects
{
    ISubscriptions selectByCustomer(Id customerId);
    ISubscriptions selectByEndDateGreaterThanOrEqualToValue(Date value);
    ISubscriptions selectByIdNotInValue(Id value);
    ISubscriptions selectBySharedSolarSystem(Id solarSystemId);
    ISubscriptions selectByStartDateLessThanOrEqualToValue(Date value);
}
