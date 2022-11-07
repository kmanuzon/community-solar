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

    /**
     * Get records where its field value is greater than or equal to given
     * value.
     *
     * @param field Date field.
     * @param value Date value.
     * @return  `List<SObject>` List of SObject where its Date field >= value.
     */
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

    /**
     * Get records where its field value is less than or equal to given value.
     *
     * @param field Date field.
     * @param value Date value.
     * @return  `List<SObject>` List of SObject where its Date field <= value.
     */
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

    /**
     * Get records where its field value does not match the given value.
     *
     * @param field Id field.
     * @param value Id value.
     * @return  `List<SObject>` List of SObject where its field value does not
     * match the given value.
     */
    protected virtual List<SObject> getRecordsByFieldNotInValue(Schema.SObjectField field, Id value)
    {
        return getRecordsByFieldNotInValue(field, new Set<Id> { value });
    }

    /**
     * Get records where its field value does not match the given values.
     *
     * @param field Id field.
     * @param value Set of Id value.
     * @return  `List<SObject>` List of SObject where its field values does not
     * match the given values.
     */
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

    /**
     * Get records where its field value matches the given value.
     *
     * @param field Id field.
     * @param value Id value.
     * @return  `List<SObject>` List of SObject where its field value matches
     * the given value.
     */
    protected virtual List<SObject> getRecordsByFieldValue(Schema.SObjectField field, Id value)
    {
        return getRecordsByFieldValue(field, new Set<Id> { value });
    }

    /**
     * Get records where its field value matches the given values.
     *
     * @param field Id field.
     * @param value Set of Id value.
     * @return  `List<SObject>` List of SObject where its field value matches
     * the given values.
     */
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
