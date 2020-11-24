public with sharing class PicklistItem {
  @AuraEnabled
  public String label {get;set;}

  @AuraEnabled
  public String value {get;set;}

  public PicklistItem(String label, String value) {
    this.label = label;
    this.value = value;
  }
}
