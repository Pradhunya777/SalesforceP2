import { LightningElement,track} from 'lwc';

export default class Calc extends LightningElement {
    @track N1; 
    @track N2;
    @track result;
    handleChanges(event){ 
        if(event.target.name === 'fnumber'){ 
            this.N1 = event.target.value;
        }       
        if(event.target.name === 'snumber'){ 
            this.N2 = event.target.value;     
        }      
             
        this.result = parseInt(this.N1) + parseInt(this.N2);
    }
}