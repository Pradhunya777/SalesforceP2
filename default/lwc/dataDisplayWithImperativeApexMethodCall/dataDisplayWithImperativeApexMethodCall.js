import { LightningElement, track } from 'lwc';
import getAccountRecords from '@salesforce/apex/accountController2.getAccountRecords';

export default class DataDisplayWithImperativeApexMethodCall extends LightningElement {
    @track accountRecords;
    @track errors;
    @track columns = [ 
        {label: 'Id', fieldName: 'Id', Type: 'Text'},
        {label: 'Name', fieldName: 'Name', Type: 'Text'},
        {label: 'Website', fieldName: 'Website', Type: 'Text'},  
    ];
    connectedCallback(){
        getAccountRecords()
            .then(result=>{
                this.accountRecords = result;
            })
            .catch(error =>{
                this.errors = error;
            });  
    }
}