({
    componentRef: null,

    AuraUtils: null,

    doInit: function(component) {
        this.componentRef = component;
        this.AuraUtils = new AuraUtils(component);
    },
    
    verifyPanNumber: function() {
        var self = this;
        var isValidPAN = false;
        var params = {
            accountId: this.componentRef.get('v.recordId')
        };
        this.AuraUtils.callApexMethod2("verifyPanNumber", params, function(response) {
            if (response.isSuccess) {
                isValidPAN = true;
                var account = response.data.account;
                var panResult = response.data.panResult;
                var isNameDiffer = account.Name != panResult.user_full_name;
                self.componentRef.set("v.isValidPAN", isValidPAN);
                self.componentRef.set("v.account", account);
                self.componentRef.set("v.panResult", panResult);
                self.componentRef.set("v.isNameDiffer", isNameDiffer);
                self.AuraUtils.showSuccess(response.message);
            } else {
                self.AuraUtils.showError(response.message);
            }
            self.AuraUtils.refreshView();
            if (!isValidPAN) {
                self.AuraUtils.closeQuickAction();
            }
        }, function(errors) {
            $A.reportError("Something went wrong. Please try again after some time.", errors);
        });
    },
    
    setPANStatus: function(isPANVerified) {
        var self = this;
        var accountId = this.componentRef.get("v.recordId");
        var textarea = this.componentRef.find("panComment");
        var chkCopyPANName = this.componentRef.find("copyPANName");
        var nameOnPANCard = this.componentRef.get("v.panResult").user_full_name;
        var params = {
            accountId: accountId,
            isPANVerified: isPANVerified, 
            comments: textarea.get("v.value"),
            isCopyPANName: chkCopyPANName.get("v.checked"),
            nameOnPANCard: nameOnPANCard
        };
        
        this.AuraUtils.callApexMethod2("setPANStatus", params, function(response) {
            if (response.isSuccess) {
                self.AuraUtils.showSuccess(response.message);
                self.AuraUtils.closeQuickAction();
                self.AuraUtils.refreshView();
            } else {
                self.AuraUtils.showError(response.message);
            }
        }, function(errors) {
            $A.reportError("Something went wrong. Please try again after some time.", errors);
        });
	}
})