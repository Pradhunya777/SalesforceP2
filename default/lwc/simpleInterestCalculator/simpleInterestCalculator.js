import { LightningElement, track } from 'lwc';

export default class SimpleInterestCalculator extends LightningElement {
    @track currentOutput;
    principle;
    rateOfInterest;
    noOfYears; 

    principleChangeHandler(event){
        this.principle=parseInt(event.target.value);
    }
    timeChangeHandler(event){  
        this.noOfYears=parseInt(event.target.value);
    }
    rateChangeHandler(event){
        this.rateOfInterest=parseInt(event.target.value);
    } 

    calculateSiHandler(){
        this.currentOutput='Simple Interest Is :'+(this.principle*this.rateOfInterest*this.noOfYears)/100;
    }
}