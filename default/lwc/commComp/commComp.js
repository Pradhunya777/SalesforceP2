import { LightningElement, api, track, wire } from 'lwc';
import getCommissions from '@salesforce/apex/CommRecords.getCommissions';
import deleteSelectedCommission from '@salesforce/apex/CommRecords.deleteSelectedCommission';
import { updateRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'; 


export default class CommComp extends LightningElement {
    @track data;
    @api showDeleteButton=false;
    @track columns = [     
        /*{label: 'Sales Agent', fieldName: 'Name',type: 'url',
        typeAttributes: {label: { fieldName: 'Name' }, 
        target: '_blank'}, }, 
        {label: 'Default Rate', fieldName: 'Default_Commission_Rate__c', type: 'Percent', editable: true},*/      
        {label: 'Commission Name', fieldName: 'Name', type: 'Text' }, 
        {label: 'Sales Agent', fieldName: 'Sales_Agent__c', type: 'url' ,
        typeAttributes: {label: { fieldName: 'Sales_Agent__c' }, 
        target: '_blank'}, }, 
        {label: 'OverRidden Rate', fieldName: 'Overridden_Rate__c', type: 'text', editable: true},
        {label: 'Commission Amount', fieldName: 'Commission_Amount__c', type: 'Formula'},    
    ]; 

     


    @api recordId;  
    connectedCallback(){
        getCommissions({lwcRecordId : this.recordId})
        .then( Response => { 
            this.data = Response;  
        } )
        .catch(error => {
            console.log("error occured:"+error);
        })
    } lwcRecordId


    @wire (getCommissions) commissionRecords({error,data}){
        if(data){
            this.data = data;  
        } 
        else if(error){
            this.error = undefined;  
        } 
    }
    
    @wire(getCommissions) Commissions;
    @track selectedCommissionIdList = [];
    fldsItemValues = [];
    

    saveHandleAction(event) { 
        this.fldsItemValues = event.detail.draftValues;
        const inputsItems = this.fldsItemValues.slice().map(draft => {
            const fields = Object.assign({}, draft);
            return { fields };
        });

       
        const promises = inputsItems.map(recordInput => updateRecord(recordInput));
        Promise.all(promises).then(res => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Records Updated Successfully!!',
                    variant: 'success'
                })
            );
            this.fldsItemValues = [];
            return this.refresh();
        }).catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                   /* title: 'Error',
                    message: 'An Error Occured!!',
                    variant: 'error'*/
                })
            );
        }).finally(() => {
            this.fldsItemValues = [];
        });  
    }
    

    deleteSelRecords(){
        deleteSelectedCommission({selCommissionId:this.selectedCommissionIdList})
        .then(result => {               
            this.dispatchEvent( 
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Selected Commissions are deleted!',
                    variant: 'success',
                }),
            );    
              //for clearing selected row indexs 
            this.template.querySelector('lightning-datatable').selectedRows = [];

            return refreshApex(this.Commissions);        
        })
        .catch(error => {
            this.message = undefined;
            this.error = error; 
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error creating records',
                    message: error.body.pageErrors[0].message,
                    variant: 'error',     
                }),
            );
            console.log("error", JSON.stringify(this.error));
        });
 
    }

    prepareSelectedRows(event){
        
        const selectedRows=event.detail.selectedRows; 
        if(selectedRows.length > 0){
            this.showDeleteButton = true;
        }else if(selectedRows.length  <= 0){
            this.showDeleteButton = false;
        }
        this.selectedCommissionIdList = []; 
        for (let i = 0; i < selectedRows.length; i++){           
            this.selectedCommissionIdList.push(selectedRows[i].Id);
        }  
        console.log(this.selectedCommissionIdList);   
    }
   

}