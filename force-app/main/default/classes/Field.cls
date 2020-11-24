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

  @AuraEnabled
  public List<PicklistItem> picklistValues {get;set;}

  public Field(FieldSetMember fieldSetMember) {
    this.label = fieldSetMember.getLabel();
    this.apiName = fieldSetMember.getFieldPath();
    this.required = fieldSetMember.getRequired();
    this.dataType = fieldSetMember.getType().name();
    this.helpText = fieldSetMember.getSObjectField().getDescribe().getInlineHelpText();

    if(this.dataType == 'PICKLIST') {
      this.picklistValues = new List<PicklistItem>();
      List<Schema.PicklistEntry> picklistEntries = fieldSetMember.getSObjectField().getDescribe().getPicklistValues();
      
      for(Schema.PicklistEntry picklistEntry : picklistEntries) {
        this.picklistValues.add(
          new PicklistItem(picklistEntry.getLabel(), picklistEntry.getValue())
          );
      }
    }
  }
}
