import { LightningElement } from 'lwc';
import Account_Name from '@salesforce/schema/Account.Name';
import Account_Type from '@salesforce/schema/Account.Type';
import Account_Industry from '@salesforce/schema/Account.Industry';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class AccountCreateSample extends LightningElement {   
    objectApiName = 'Account';
    fieldsList = [Account_Name, Account_Type, Account_Industry];
    
    handleAccountCreate(event){            
        const evt = new ShowToastEvent({
            title: "Account Created",
            message: "Account Record:"+event.detail.fields.Name.value+" Is Successfully Created",
            variant: "success",
        });                              
        this.dispatchEvent(evt);  
        
    }

}