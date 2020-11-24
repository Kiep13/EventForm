public with sharing class Field {
  @AuraEnabled
  public String label {get;set;}

  @AuraEnabled
  public String apiName {get;set;}

  @AuraEnabled
  public Boolean required {get;set;}

  @AuraEnabled
  public String helpText {get;set;}

  @AuraEnabled
  public String dataType {get;set;}

  @AuraEnabled
  public Object value {get;set;}

  public Field(FieldSetMember fieldSetMember) {
    this.label = fieldSetMember.getLabel();
    this.apiName = fieldSetMember.getFieldPath();
    this.required = fieldSetMember.getRequired();
    this.dataType = fieldSetMember.getType().name();
  }
}
