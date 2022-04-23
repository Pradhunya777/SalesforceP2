import { LightningElement, wire, track } from 'lwc';
import getContactList from '@salesforce/apex/MyContacts.getContactList';
import { refreshApex } from '@salesforce/apex';

export default class ContactList1 extends LightningElement {
    @track selectedContact;
    @wire(getContactList) contacts;

    addContactHandler(){
        refreshApex(this.contacts);
    }
    contactSelected(event){
        const contactId = event.detail;
        this.selectedContact = this.contacts.data.find(contact => contact.Id === contactId);
    }
}