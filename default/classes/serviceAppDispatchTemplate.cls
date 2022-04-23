public without sharing class serviceAppDispatchTemplate {
    
    public Id saId {get;set;}
    public List<AssignedResource> getAssignedResourcesFunction()
    {
        System.debug('service appointment Id::'+saId);
        List<AssignedResource> assignResources;
        assignResources = [SELECT Id,ServiceResourceId,ServiceResource.Name FROM AssignedResource WHERE ServiceAppointmentId =: saId];
        System.debug('AssignedResource::'+assignResources);
        return assignResources;
    }


}