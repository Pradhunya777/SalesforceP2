({
    doSave : function(component, event, helper) {
        var action = component.get('c.createContact');
        action.setParams({
            con : component.get('v.createContact'),
            AccountId : component.get('v.accountId')

        });
        action.setCallback(this,function(Response){
            var state = Response.getState();
            alert(state); 
            if(state === 'SUCCESS' || state === 'DRAFT'){
                var responseValue = Response.getReturnValue();
                
                var componentEvent = component.getEvent('quickContact');
                componentEvent.setParams({
                    ContactRecord : responseValue
                })
                componentEvent.fire();


            }else if(state === 'INCOMPLETE'){

            }else if(state === 'ERROR'){
                var errors = Response.getError();
                console.log('Error is ',errors);
            }

        },'ALL');
        $A.enqueueAction(action);

    }
})