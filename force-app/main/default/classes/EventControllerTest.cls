@IsTest
public with sharing class EventControllerTest {
  
  private static Datetime TEST_DATETIME = System.today();

  private static String INVALID_FIELDS_AMOUNT = 'Expected fields info length not be null';
  private static String INVALID_FIELDS_LIST_AMOUNT = 'Expected fields list length not be null';
  private static String INVALID_EVENTS_AMOUNT = 'Expected events amount doesn\'t equal to expected';
  private static String INVALID_LABEL = 'Expected field label not be null';
  private static String INVALID_API_NAME = 'Expected field api name not be null';
  private static String INVALID_DATATYPE = 'Expected field datatype not be null';
  private static String INVALID_EVENT_ID = 'Expected event id doesn\'t equal to expected';
  
  @TestSetup
  static void makeData(){
    Event event = new Event();
    event.StartDateTime = TEST_DATETIME;
    event.EndDateTime = TEST_DATETIME;
    insert event; 
  }

  @IsTest
  public static void getFieldsInfoTest() {
    Event event = [SELECT Id FROM Event LIMIT 1];

    List<Field> fields = EventController.getFieldsInfo(event.Id);

    System.assertNotEquals(0, fields.size(), INVALID_FIELDS_AMOUNT);

    for(Integer i = 0; i < fields.size(); i++) {
      System.assertNotEquals(null, fields[0].label, INVALID_LABEL);
      System.assertNotEquals(null, fields[0].apiName, INVALID_API_NAME);
      System.assertNotEquals(null, fields[0].dataType, INVALID_DATATYPE);
    }
  }

  @IsTest
  public static void getFieldsTest() {
    List<Schema.FieldSetMember> fields = EventController.getFields();

    System.assertNotEquals(0, fields.size(), INVALID_FIELDS_AMOUNT);
  }

  @IsTest
  public static void getEventTest() {
    Event event = [SELECT Id FROM Event LIMIT 1];

    List<Schema.FieldSetMember> rawFields = EventController.getFields();
    List<Field> fields = new List<Field>();

    for(Integer i = 0; i < rawFields.size(); i++) {
      fields.add(new Field(rawFields[i]));
    }

    List<Field> resultFields = EventController.getEventValues(event.Id, fields);

    System.assertNotEquals(0, fields.size(), INVALID_FIELDS_AMOUNT);
    System.assertEquals(fields.size(), resultFields.size(), INVALID_FIELDS_LIST_AMOUNT);
  }

  @IsTest
  public static void insertEvent() {
    Event event = new Event();
    event.StartDateTime = TEST_DATETIME;
    event.EndDateTime = TEST_DATETIME;
    
    EventController.upsertEvent(event);

    List<Event> events = [SELECT Id FROM Event];

    System.assertEquals(2, events.size(), INVALID_EVENTS_AMOUNT);
  }

  @IsTest
  public static void updateEvent() {
    Event event = [SELECT Id FROM Event LIMIT 1];
    
    String eventId = EventController.upsertEvent(event);

    List<Event> events = [SELECT Id FROM Event];

    System.assertEquals(1, events.size(), INVALID_EVENTS_AMOUNT);
    System.assertEquals(eventId, events[0].Id, INVALID_EVENT_ID);
  }
}
