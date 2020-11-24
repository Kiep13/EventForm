public with sharing class EventController {
  public static List<Schema.FieldSetMember> getFields() {
    return SObjectType.Event.FieldSets.CustomEventForm.getFields();
  }

  @AuraEnabled(Cacheable=False)
  public static List<Field> getFieldsInfo(String recordId) {
    List<Field> fields = new List<Field>();

    for(Schema.FieldSetMember fieldSetMember : EventController.getFields()) {
      Field field = new Field(fieldSetMember);
      fields.add(field);
    }

    if(recordId != null) {
      fields = EventController.getEvent(recordId, fields);
    }

    return fields;
  }

  private static List<Field> getEvent(String recordId, List<Field> fields) {
    String query = 'SELECT ';
    for(Field field : fields) {
      query += field.apiName + ', ';
    }
    
    query += 'Id FROM Event WHERE Id = :recordId';
    System.debug(recordId);
    System.debug(query);

    sObject[] result = Database.query(query);
    Event event = (Event) result[0];

    for(Field field : fields) {
      field.value = event.get(field.apiName);
    }

    return fields;
  }
  @AuraEnabled(Cacheable=False)
  public static List<String> getEventSubtipes() {
    List<String> picklist= new List<String>();
    Schema.DescribeFieldResult field = Event.EventSubtype.getDescribe();
    List<Schema.PicklistEntry> valuesSets = field.getPicklistValues();
    for( Schema.PicklistEntry valueSet : valuesSets){
        picklist.add(valueSet.getLabel());
    }     
    return picklist;
  }
}
