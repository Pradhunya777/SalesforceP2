({
    doInit: function(component, event, helper) {
        if (typeof(AuraUtils) != 'undefined') {
            helper.doInit(component);
        }
    },

    uploadBtnHandler: function(component, event, helper) {
        helper.uploadWorkOrder(component, event);
    },

    closeQuickAction: function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    }
})