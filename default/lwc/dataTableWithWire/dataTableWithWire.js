import Type from '@salesforce/schema/Account.Type';
import { LightningElement, track,wire } from 'lwc';
import getAccounts from '@salesforce/apex/accountController.getAccounts';

export default class DataTableWithWire extends LightningElement {
    @track data;
    @track columns = [
        {label: 'Id', fieldName: 'Id', Type: 'Text'},
        {label: 'Name', fieldName: 'Name', Type: 'Text'},
        {label: 'Website', fieldName: 'Website', Type: 'Text'},
    ]; 
    @wire (getAccounts) accountRecords({error,data}){    
        if(data){
            this.data=data;
        }
        else if(error){
            this.data=undefined;
        }
    }
}