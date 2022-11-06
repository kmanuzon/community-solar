/**
 * ApplicationSObjectDomain
 *
 * @group Applications
 */
public virtual inherited sharing class ApplicationSObjectDomain extends fflib_SObjectDomain
    implements IApplicationSObjectDomain
{
    public ApplicationSObjectDomain(List<SObject> sObjects)
    {
        super(sObjects);
    }
}
