import { LightningElement,wire } from 'lwc';
import getAccounts from '@salesforce/apex/accController.getAccounts';

export default class AccountRecordList extends LightningElement {
    @wire(getAccounts) accounts;
    accountidFromParent; 
  
    handleClick(event){
        event.preventDefault();
        this.accountidFromParent = event.target.dataset.accountid;
    }
}