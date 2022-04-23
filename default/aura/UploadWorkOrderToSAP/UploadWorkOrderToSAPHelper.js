({
    componentRef: null,

    AuraUtils: null,

    doInit: function(component) {
        this.componentRef = component;
        this.AuraUtils = new AuraUtils(component);
    },

    uploadWorkOrder: function(component, event) {
        var self = this;
        var params = {
            workOrderId: this.componentRef.get('v.recordId')
        };        
        this.AuraUtils.callApexMethod("uploadWorkOrderToSAP", params).then(function(response) {
            if (response.isSuccess) {
                self.AuraUtils.showSuccess(response.message);
            } else {
                self.AuraUtils.showError(response.message);
            }
            self.AuraUtils.refreshView();
        }).catch(function(errors) {
            $A.reportError("Something went wrong. Please try again after some time.", errors);
        });
    }
})