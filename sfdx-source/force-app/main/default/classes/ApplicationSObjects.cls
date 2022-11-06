/**
 * ApplicationSObjects
 *
 * @group Applications
 */
public virtual inherited sharing class ApplicationSObjects extends fflib_SObjects
    implements IApplicationSObjects
{
    public ApplicationSObjects(List<SObject> sObjects)
    {
        super(sObjects);
    }

    public ApplicationSObjects(List<SObject> sObjects, Schema.SObjectType sObjectType)
    {
        super(sObjects, sObjectType);
    }

    protected virtual List<SObject> getRecordsByFieldGreaterThanOrEqualToValue(Schema.SObjectField field, Date value)
    {
        List<SObject> result = new List<SObject>();

        for (SObject record : getRecords())
        {
            if ((Date) record.get(field) >= value)
            {
                result.add(record);
            }
        }

        return result;
    }

    protected virtual List<SObject> getRecordsByFieldLessThanOrEqualToValue(Schema.SObjectField field, Date value)
    {
        List<SObject> result = new List<SObject>();

        for (SObject record : getRecords())
        {
            if ((Date) record.get(field) <= value)
            {
                result.add(record);
            }
        }

        return result;
    }

    protected virtual List<SObject> getRecordsByFieldNotInValue(Schema.SObjectField field, Id value)
    {
        return getRecordsByFieldNotInValue(field, new Set<Id> { value });
    }

    protected virtual List<SObject> getRecordsByFieldNotInValue(Schema.SObjectField field, Set<Id> values)
    {
        List<SObject> result = new List<SObject>();

        for (SObject record : getRecords())
        {
            if (values?.contains((Id) record.get(field)) != true)
            {
                result.add(record);
            }
        }

        return result;
    }

    protected virtual List<SObject> getRecordsByFieldValue(Schema.SObjectField field, Id value)
    {
        return getRecordsByFieldValue(field, new Set<Id> { value });
    }

    protected virtual List<SObject> getRecordsByFieldValue(Schema.SObjectField field, Set<Id> values)
    {
        List<SObject> result = new List<SObject>();

        for (SObject record : getRecords())
        {
            if (values?.contains((Id) record.get(field)) == true)
            {
                result.add(record);
            }
        }

        return result;
    }
}
