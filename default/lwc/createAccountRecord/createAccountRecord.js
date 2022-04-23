import { LightningElement, track } from 'lwc';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import NAME_FIELD from '@salesforce/schema/Account.Name';
import PHONE_FIELD from '@salesforce/schema/Account.Phone';
import {ShowToastEvent } from 'lightning/platformShowToastEvent';
import { createRecord } from 'lightning/uiRecordApi';
import Title from '@salesforce/schema/Contact.Title';

export default class CreateAccountRecord extends  LightningElement {
    @track name=''; 
    @track phone='';  
    handleChange(event){
        if(event.target.label=='Name'){
            this.name = event.target.value;
        }
        if(event.target.label=='Phone'){
            this.phone = event.target.value;
        }
    }
    createAccount(){
        const fields = {};
        fields[NAME_FIELD.fieldApiName] = this.name;
        fields[PHONE_FIELD.fieldApiName] = this.phone;
        const recordInput = { apiName : ACCOUNT_OBJECT.objectApiName, fields };
        createRecord(recordInput)
        .then(account => {
            this.accountId = account.Id;
            this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Account Created',
                variant: 'success',
            }),
            ); 
             
        })
    }
}