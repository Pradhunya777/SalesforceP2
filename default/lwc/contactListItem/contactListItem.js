import { LightningElement, api } from 'lwc';

export default class ContactListItem extends LightningElement {
    @api contact;
    selectHandler(event){
        event.preventDefault();
        const selectedEvent = new CustomEvent('selected',{ detail: this.contact.Id });
        this.dispatchEvent(selectedEvent);
    }
}