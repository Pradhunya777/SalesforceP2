import { LightningElement, track } from 'lwc';
import saveContact from '@salesforce/apex/MyContacts.addNewContact';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AddContact extends LightningElement {
    @track error;
    @track fname;
    @track lname;
    @track email;
    @track phone;
    @track title;
    
    fnameChange(event){
        this.fname=event.target.value;
    }
    lnameChange(event){  
        this.lname=event.target.value;
    }
    emailChange(event){
        this.email=event.target.value;   
    }
    phoneChange(event){
        this.phone=event.target.value
    }

    submitContact(){

        saveContact({
            fname:this.fname,
            lname:this.lname,
            email:this.email,
            phone:this.phone
        })
        .then(successResponse=>{
            this.fname='';
            this.lname='';
            this.email='';
            this.phone='';
            this.dispatchEvent(new ShowToastEvent({
                title:'success',
                message:successResponse+' Contact Created Successfully.',
                variant:'success'
            }));
            const saveEvent = new CustomEvent('addContact');
            this.dispatchEvent(saveEvent);
        })
        .catch(successResponse=>{
            this.error=errorResponse;
        });
    }    

}