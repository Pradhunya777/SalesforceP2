({
	getRecordType : function(component, caseLineItemID ) {
        var action = component.get("c.getMataDataValues");
        action.setParams({ 
            caseLineItemID : caseLineItemID
        });
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state == "SUCCESS") {
                console.log('response',response.getReturnValue());
                
                component.set('v.recordSage', response.getReturnValue());
            }
        });
        // Send action off to be executed
        $A.enqueueAction(action);
    },
})