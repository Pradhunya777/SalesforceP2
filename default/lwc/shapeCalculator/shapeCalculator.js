import { LightningElement, track } from 'lwc';

export default class ShapeCalculator extends LightningElement {
    @track ResultSquare;
    @track ResultRectangle;
    @track ResultRhombus
    side;
    length;
    breadth;
    diagonal1;
    diagonal2;

    sideChangeHandler(event){
        this.side=parseInt(event.target.value);
    }
    lenghtChangeHandler(event){
        this.length=parseInt(event.target.value);
    }
    breadthChangeHandler(event){
        this.breadth=parseInt(event.target.value);
    }
    diagonalOneChangeHandler(event){
        this.diagonal1=parseInt(event.target.value);
    }
    diagonalTwoChangeHandler(event){
        this.diagonal2=parseInt(event.target.value);
    }

    calculateAreaOfSquare(){
        this.ResultSquare='Area of Square is : '+(this.side*this.side);
    }
    calculateAreaOfRectangle(){
        this.ResultRectangle='Area of Rectangle is : '+(this.length*this.breadth);
    }
    calculateAreaOfRhombus(){
        this.ResultRhombus='Area of Rhombus is : '+(this.diagonal1*this.diagonal2)/2;
    }
}