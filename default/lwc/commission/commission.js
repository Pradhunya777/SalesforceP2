import { LightningElement, track, wire } from 'lwc';
import getCommission from '@salesforce/apex/CommissionController.getCommission';

export default class Commission extends LightningElement {
    @track Data;
    @track Columns = [
        {label: 'Id', fieldName: 'Id', Type: 'Text'}
    ];
    @wire (getCommission) CommissionRecords({Error, Data}){
        if(Data){
            this.Data=Data;
        }
        else if(Error){
            this.Data=undefined;
        }
    }
}