import { LightningElement, track } from 'lwc';

export default class TrackDecorator extends LightningElement {
    @track greetings;
    handlegreetingschanges(event){
        this.greetings = event.target.value; 
    } 
}