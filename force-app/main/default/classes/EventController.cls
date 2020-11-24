public with sharing class EventController {
  @AuraEnabled(Cacheable=False)
  public static List<Field> getFieldsInfo(String recordId) {
    List<Field> fields = new List<Field>();

    for(Schema.FieldSetMember fieldSetMember : EventController.getFields()) {
      Field field = new Field(fieldSetMember);
      fields.add(field);
    }

    if(recordId != null) {
      fields = EventController.getEventValues(recordId, fields);
    }

    return fields;
  }

  @TestVisible
  private static List<Schema.FieldSetMember> getFields() {
    return SObjectType.Event.FieldSets.CustomEventForm.getFields();
  }

  @TestVisible
  private static List<Field> getEventValues(String recordId, List<Field> fields) {
    String query = 'SELECT ';
    for(Field field : fields) {
      query += field.apiName + ', ';
    }
    query += 'Id FROM Event WHERE Id = :recordId';

    sObject[] result = Database.query(query);
    Event event = (Event) result[0];

    for(Field field : fields) {
      field.value = event.get(field.apiName);
    }

    return fields;
  }

  @AuraEnabled(Cacheable=False)
  public static void upsertEvent(Event event) {
    Database.upsert(event);
  }
}
