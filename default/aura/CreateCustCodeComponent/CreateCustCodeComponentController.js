({
    doInit : function(component, event, helper) {
      let action = component.get("c.debugStatusMessage");
                action.setCallback(this,function(response) {
                    let state = response.getState();
                    if (state === "SUCCESS") {
                        let data = response.getReturnValue(); 
                        console.log('#DATA',data);
                        var resultsToast = $A.get("e.force:showToast"); 
						resultsToast.setParams({ 
						"title": "TEST " , 
						"message":  data,
                        "type": 'success',
            			"mode": 'pester'
                    	}); 

        			resultsToast.fire(); 
                    } else if (state === "ERROR") {
                        let errors = response.getError();             
                        console.log('#ERROR',errors);
                        var resultsToast = $A.get("e.force:showToast"); 
						resultsToast.setParams({ 
						"title": "TEST " , 
						"message":  data,
                        "type": 'error',
            			"mode": 'pester'
                    	}); 
        				resultsToast.fire(); 
                    }
                });
                var dismissActionPanel = $A.get("e.force:closeQuickAction"); 
        		dismissActionPanel.fire(); 
                $A.enqueueAction(action);
    },
                              
})