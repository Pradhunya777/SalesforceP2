import { LightningElement, api, track, wire } from 'lwc';
import getSalesAgents from '@salesforce/apex/SalesAgentRecords.getSalesAgents';
import createCommissions from '@salesforce/apex/SalesAgentRecords.createCommissions';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const columns = [    
    {label: 'Sales Agents', fieldName: 'Name', type: 'text'},
    {label: 'Default Rate', fieldName: 'Default_Commission_Rate__c', type: 'text', editable: true}
]

export default class SalesAgentComp extends LightningElement {
   
    @track showSalesAgents = 'Show Sales Agents';
    @api showCreateButton=false;
    @track isVisible = false;       
    columns = columns;
    @track data = [];  
    @api recordId;   

    @track isModalOpen = false;
    openModal() {
        // to open modal set isModalOpen tarck value as true
        this.isVisible = true;
        this.isModalOpen = true;  
    }
    closeModal() { 
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
    }
 
    connectedCallback(){
        getSalesAgents({lwcRecordId : this.recordId})
        .then( Response => { 
            this.data = Response;
        } )
        .catch(error => {
            console.log("error occured:"+error);
        })
    }

   @wire(createCommissions) Commissions; 
   @track selectedCommissionIdList = [];
   @track message;

   createSelRecords(){
    createCommissions({selCommissionId:this.selectedCommissionIdList, lwcRecordId : this.recordId})
    .then(result => {               
        this.dispatchEvent( 
            new ShowToastEvent({
                title: 'Success',
                message: 'Selected Sales Agents Commission is Created!',
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
 
   prepareSelRows(event){
    const selectedRows=event.detail.selectedRows; 
    if(selectedRows.length > 0){
        this.showCreateButton = true;
    }else if(selectedRows.length  <= 0){
        this.showCreateButton = false;
    }
    this.selectedCommissionIdList = []; 
    for (let i = 0; i < selectedRows.length; i++){            
        this.selectedCommissionIdList.push(selectedRows[i].Id);
    }  
    console.log(this.selectedCommissionIdList);   
   }
}