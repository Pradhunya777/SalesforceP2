import { LightningElement, track, api} from 'lwc';
import getSumResult from '@salesforce/apex/calculateNumbers.getSumResult';
export default class CalculateNumbers extends LightningElement {
    @track fnumber;
    @track snumber;
    @track sum;
    @track errors;

    @api title;
    @api greetings;
  
    handleClick(){
        getSumResult({firstNumber:this.fnumber, secondNumber:this.snumber})
        .then(result=>{
            this.sum = result;
        })
        .catch(error=>{ 
            this.errors = error;
        });
    }
    handleChange(event){  
        if(event.target.name === 'firstNumber'){
            this.fnumber = event.target.value;
        }
        else if(event.target.name === 'secondNumber'){
            this.snumber = event.target.value;
        }
    } 
}