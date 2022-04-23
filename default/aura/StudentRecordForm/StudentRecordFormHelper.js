({
	getStudents : function(component, helper) {
		var action = component.get("c.searchStudent");
		action.setCallback(this,function(Response){
			var state = Response.getReturnValue();
            component.set('v.data',state);			
		},'SUCCESS');
		$A.enqueueAction(action); 
	}
})