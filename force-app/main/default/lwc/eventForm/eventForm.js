import { LightningElement, api, track } from 'lwc';

import getFieldsInfo from '@salesforce/apex/EventController.getFieldsInfo';

export default class EventForm extends LightningElement {

  @api recordId;

  @track fields = [];
  @track event;

  @track error;

  connectedCallback() {
    this.loadFields();
  }

  loadFields() {
    getFieldsInfo({recordId: this.recordId})
      .then((result) => {
        console.log(result);
        //result = this.glueResult(result);
        //console.log(result);
        this.fields = result;
        this.glueResult();
        
        console.log(this.fields);
      })
      .catch(error => {
        //this.error = error;
        console.log(error);
      });
  }

  glueResult() {
    for(let i = 0; i < this.fields.length; i++) {
      this.fields[i].dataType = this.convertDatatype(this.fields[i].dataType);
    }
  }

  convertDatatype(datatype) {
    switch(datatype) {
      case 'INTEGER': return 'number';
      case 'DATETIME': return 'datetime';
      case 'DATE': return 'date';
      case 'TEXTAREA': return 'text';
      case 'BOOLEAN': return 'checkbox';
      default: return datatype;
    }
  }
}