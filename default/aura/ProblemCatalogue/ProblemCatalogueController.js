({
    doInit : function( component, event, helper ) {
        var recordId = component.get("v.recordId"); 
        helper.getValues(component, recordId);  
    },
	handleChange: function (component, event) {
        var selectedOptionValue = event.getParam("value");
        console.log('selectedOptionValue',selectedOptionValue);
    }
})