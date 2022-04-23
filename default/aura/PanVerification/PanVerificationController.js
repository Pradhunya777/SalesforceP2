({
    doInit: function (component, event, helper) {
        if (typeof AuraUtils != "undefined") {  
            helper.doInit(component);
            helper.verifyPanNumber();
        }
    },

    setAsVerified: function (component, event, helper) {
        helper.setPANStatus(true);
    },

    setAsInvalid: function (component, event, helper) {
        helper.setPANStatus(false);
    }
})