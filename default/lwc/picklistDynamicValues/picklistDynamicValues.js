import { LightningElement, wire } from 'lwc';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import TYPE_FIELD from '@salesforce/schema/Account.Type'; 
import LEAD_SOURCE from '@salesforce/schema/Contact.LeadSource';

export default class PicklistDynamicValues extends LightningElement {
    selectedAccountType;
    selectedLeadSource;
  
    /* Retrieve picklist values from account type field */
    @wire(getPicklistValues, {
        recordTypeId: '012000000000000AAA', 
        fieldApiName: TYPE_FIELD            
    }) typeValues; 

    /* Retrieve picklist values from contact type field */
    @wire(getPicklistValues, { 
        recordTypeId: '0125g000000Qy1OAAS', 
        fieldApiName: LEAD_SOURCE 
    }) leadSourceValues;  

    handleTypeChange(event){
        this.selectedAccountType = event.target.value;
    }

    handleLeadSourceChange(event){
        this.selectedLeadSource = event.target.value;
    }

}