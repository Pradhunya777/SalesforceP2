import { LightningElement } from 'lwc';

export default class PicklistExample extends LightningElement {
    selectedValue;
    /* static Values */
    get options(){
        return [ 
            { label: 'New', value: 'New' },
            { label: 'In Progress', value: 'In Progress' }, 
            { label: 'Finished', value: 'Finished' },
            { label: 'Close', value: 'Close'},
           
        ];
    }
    handleChange(event){    
        this.selectedValue = event.target.value;
    }
}