import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import getFieldsInfo from '@salesforce/apex/EventController.getFieldsInfo';
import upsertEvent from '@salesforce/apex/EventController.upsertEvent';

import ID_FIELD from '@salesforce/schema/Event.Id';

export default class EventForm extends LightningElement {

  SUCCESS_TITLE = 'Success';
  ERROR_CREATE_TITLE = 'Error creating record';
  ERROR_UPDATE_TITLE = 'Error updating record';
  ERROR_GET_FIELDS = 'Error while getting fields info';

  SUCCESS_CREATE_MESSAGE = 'Event created';
  SUCCESS_UPDATE_MESSAGE = 'Event updated';

  SUCCESS_VARIANT = 'success';
  ERROR_VARIANT = 'error';

  @api recordId;

  @track fields = [];

  @track error;

  connectedCallback() {
    this.loadFields();
  }

  loadFields() {
    getFieldsInfo({recordId: this.recordId})
      .then((result) => {
        this.fields = result;

        console.log(result);

        this.updateDatatypes();
      })
      .catch(error => {
        this.showToastEvent(this.ERROR_GET_FIELDS,
                            error.body.message,
                            this.ERROR_VARIANT);
      });
  }

  updateDatatypes() {
    for(let i = 0; i < this.fields.length; i++) {
      this.fields[i].isPicklist = this.fields[i].dataType == 'PICKLIST';
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

  submit() {
    const inputs = [...this.template.querySelectorAll('lightning-input')];
    const allValid = inputs.reduce((validSoFar, inputFields) => {
                        inputFields.reportValidity();
                        return validSoFar && inputFields.checkValidity();
                      }, true);

    if(!allValid) {
      return;
    }

    let record = {};

    inputs.forEach((input) => {
      let value;

      switch(input.type) {
        case 'checkbox': {
          value = input.checked;
        } break;
        case 'number': {
          value = +input.value;
        } break;
        default: {
          value = input.value;
        }
      }

      record[input.name] = value;
    });
    
    const picklists = [...this.template.querySelectorAll('lightning-combobox')];
    picklists.forEach((picklist) => {
      record[picklist.name] = picklist.value;
    })

    if(this.recordId != null) record[ID_FIELD.fieldApiName] = this.recordId;

    this.makeUpsertRequest(record);
  }

  makeUpsertRequest(record) {

    console.log(5, record);

    upsertEvent({event : record})
      .then(() => {
        this.showToastEvent(this.SUCCESS_TITLE,
                            this.SUCCESS_UPDATE_MESSAGE,
                            this.SUCCESS_VARIANT)
      })
      .catch(error => {
        console.log(error);
        this.showToastEvent(this.ERROR_UPDATE_TITLE, 
                            error.body.message,
                            this.ERROR_VARIANT);
      });
  }

  showToastEvent(title, message, variant) {
    this.dispatchEvent(
      new ShowToastEvent({
        title,
        message,
        variant
      })
    );
  }
}