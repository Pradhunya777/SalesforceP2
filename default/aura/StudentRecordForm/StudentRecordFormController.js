({
	doInit : function(component, event, helper) {
		component.set('v.columns',[
			{label:'Name', fieldName:'Full_Name__c', editable:'true', type:'text'},
			{label:'Email', fieldName:'Email__c', type:'text'},
			{label:'Phone', fieldName:'Phone__c', editable:'true', type:'number'},
			{label:'Total Fees', fieldName:'Total_Fees__c', type:'number'},
			{label:'Action', type:'button', initialwidth:135,
				typeAttributes:{label:'view', name:'view_details',title:'click to view edit details'}}
		]);
		helper.getStudents(component, helper);
	}, 
	handleRowAction : function(component,event,helper){
		var action = event.getParam('action');
		var stud = event.getParam('row');
		switch(action.name){
			case 'view_details':
				component.set("v.recordId",stud.Id);
				break;
			default :
			   component.set("v.recordId",stud.Id);				
		}
		if(component.get("v.recordId")){
			component.set("v.showDetails",true)
		}
	},
	onSave : function(component, event, helper){
		console.log('Save');
	}
})