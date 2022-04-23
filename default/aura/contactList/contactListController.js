({
	doInit : function(component, event, helper) {
        var action = component.get('c.getContactList');
		/*action.setParams(
			 
		})*/
		action.setCallback(this,function(Response){
			var ResponseValue = Response.getReturnValue();
			console.log('responseValue',ResponseValue);
			component.set('v.contactList',ResponseValue);
 
		},'SUCCESS');
		$A.enqueueAction(action,false);
	},

	handleCompEvent : function(component, event, helper){
		var availableContact = component.get('v.contactList');
		var ContactRecord = event.getParam('ContactRecord');
		console.log(ContactRecord);
		availableContact.push(ContactRecord);
		component.set('v.contactList',availableContact)

	}
})