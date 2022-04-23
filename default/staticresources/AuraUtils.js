/**  
 * @Description        : Library for Lightning/Aura common functions
 * @Author             : NA
 * @Date               : 13-01-2022 (DD-MM-YYYY)
 * 
 * Modification Log:
 * Ticket           Author          Date                 Description
 * NA               NA              13-01-2022           Initial Development
*/

window.AuraUtils = function(component) {
    return {      
        callApexMethod: function(apexMethod, params) {
            // NOTE: e.force.closeQuickAction does not work with this version, use callApexMethod2 instead
            var self = this;
            return new Promise($A.getCallback(function(resolve, reject) {
                var action = component.get("c." + apexMethod + "");
                action.setParams(params);
                action.setCallback(this, function(response) {
                    self.hideSpinner();
                    if (response.getState() == 'SUCCESS') {
                        resolve(response.getReturnValue());
                    } else if (response.getState() == 'ERROR') {
                        reject(response.getError());
                    }                    
                });
                self.showSpinner();
                $A.enqueueAction(action);
            }));
        },

        callApexMethod2: function(apexMethod, params, successBk, errorBk) {
            var self = this;
            var action = component.get("c." + apexMethod + "");
            action.setParams(params);
            action.setCallback(this, function(response) {
                self.hideSpinner();
                if (response.getState() == "SUCCESS") {
                    successBk(response.getReturnValue());
                } else if (response.getState() == 'ERROR') {
                    errorBk(response.getError());
                }
            });
            self.showSpinner();
            $A.enqueueAction(action);
        },

        showToast: function(title, type, msg) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": title,
                "type": type,
                "message": msg
            });
            toastEvent.fire();
        },
    
        showSuccess: function(msg) {
            this.showToast('Success', 'success', msg);
        },
    
        showWarning: function(msg) {
            this.showToast('Warning', 'warning', msg);
        },
    
        showError: function(msg) {
            this.showToast('Error', 'error', msg);
        },
    
        showSpinner: function() {
            component.set("v.isSpinner", true);
        },
    
        hideSpinner: function() {
            component.set("v.isSpinner", false);
        },
    
        refreshView: function() {
            $A.get('e.force:refreshView').fire();
        },

        closeQuickAction: function() {
            $A.get("e.force:closeQuickAction").fire();
        }
    };
}