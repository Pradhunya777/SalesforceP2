/*
    * Name : QuotePDFCompanyInformationFromQuote
    * Description: To show Company Information in Quote PDF
    * TestMethod:
    * CreateDate: 03-Dec-2021
    */
public class QuotePDFCompanyInformationController {
    public SBQQ__Quote__c quoteInfo{get;set;}
    public String quoteId;
    Public String tableBody{get;set;}
    
    
    //Public Map<String,QuoteWrapper> StrMapWrap{get;set;}
    public QuotePDFCompanyInformationController(){
        quoteId = ApexPages.currentPage().getParameters().get('qid');
        quoteInfo = new SBQQ__Quote__c();
        tableBody = '';
       
    }
    public void init(){
        try{
                    
             quoteInfo = [SELECT Id,Company_Name__c,SBQQ__BillingCity__c, SBQQ__BillingCountry__c,SBQQ__BillingPostalCode__c, SBQQ__BillingState__c,
                                 SBQQ__BillingStreet__c,TelePhone__c,Mobile__c,Email__c,Fax__c,Website__c,PAN_Number__c,Exim_Code__c,VAT_Number__c,
                                 Machine_Offer_Type__c,Offer_Number__c,Quote_PDF_Current_Date__c
                          FROM SBQQ__Quote__c
                                    WHERE Id = :quoteId];
            
            tableBody = '<table border-collapse="collapse" margin-top="10pt" width="100%">'+
                '<table-column column-width="25%"/><table-column column-width="30%"/>'+
                '<table-body>';
           
            if(quoteInfo.Company_Name__c != null){
               tableBody += '<table-row><table-cell display-align="center" padding="5">'+
                   '<block font-weight="bold" font-size="small"><inline>Company/Customer Name</inline>'+
                   '</block></table-cell>';
               tableBody += '<table-cell display-align="center" padding="5">'+
                   '<block font-size="small"><inline>'+': '+quoteInfo.Company_Name__c+'</inline>'+
                   '</block></table-cell></table-row>';
            }
            
            if(quoteInfo.SBQQ__BillingStreet__c != null || quoteInfo.SBQQ__BillingPostalCode__c != null 
               || quoteInfo.SBQQ__BillingCity__c != null || quoteInfo.SBQQ__BillingState__c!= null 
               || quoteInfo.SBQQ__BillingCountry__c != null){
               tableBody += '<table-row><table-cell display-align="center" padding="5">'+
                   '<block font-weight="bold" font-size="small"><inline>Address</inline>'+
                   '</block></table-cell>';
               tableBody += '<table-cell display-align="center" padding="5">'+
                   '<block font-size="small"><inline>'+': ';
                if(quoteInfo.SBQQ__BillingStreet__c != null){
                    tableBody += quoteInfo.SBQQ__BillingStreet__c;
                }
                if(quoteInfo.SBQQ__BillingCity__c != null){
                    tableBody += ', '+quoteInfo.SBQQ__BillingCity__c;
                }
                if(quoteInfo.SBQQ__BillingPostalCode__c != null){
                       tableBody += ' - '+quoteInfo.SBQQ__BillingPostalCode__c;
                }
                if(quoteInfo.SBQQ__BillingState__c != null){
                       tableBody += ', '+quoteInfo.SBQQ__BillingState__c;
                }
                if(quoteInfo.SBQQ__BillingCountry__c != null){
                    tableBody += ', '+quoteInfo.SBQQ__BillingCountry__c;
                }
                tableBody += '</inline></block></table-cell></table-row>';
            }
            
            if(quoteInfo.TelePhone__c != null){
               tableBody += '<table-row><table-cell display-align="center" padding="5">'+
                   '<block font-weight="bold" font-size="small"><inline>Tel</inline>'+
                   '</block></table-cell>';
               tableBody += '<table-cell display-align="center" padding="5">'+
                   '<block font-size="small"><inline>'+': '+quoteInfo.TelePhone__c+'</inline>'+
                   '</block></table-cell></table-row>';
            }
            if(quoteInfo.Mobile__c != null){
               tableBody += '<table-row><table-cell display-align="center" padding="5">'+
                   '<block font-weight="bold" font-size="small"><inline>Mobile</inline>'+
                   '</block></table-cell>';
               tableBody += '<table-cell display-align="center" padding="5">'+
                   '<block font-size="small"><inline>'+': '+quoteInfo.Mobile__c+'</inline>'+
                   '</block></table-cell></table-row>';
            }
            if(quoteInfo.Email__c != null){
               tableBody += '<table-row><table-cell display-align="center" padding="5">'+
                   '<block font-weight="bold" font-size="small"><inline>Email</inline>'+
                   '</block></table-cell>';
               tableBody += '<table-cell display-align="center" padding="5">'+
                   '<block font-size="small"><inline>'+': '+quoteInfo.Email__c+'</inline>'+
                   '</block></table-cell></table-row>';
            }
            if(quoteInfo.Fax__c != null){
               tableBody += '<table-row><table-cell display-align="center" padding="5">'+
                   '<block font-weight="bold" font-size="small"><inline>Fax</inline>'+
                   '</block></table-cell>';
               tableBody += '<table-cell display-align="center" padding="5">'+
                   '<block font-size="small"><inline>'+': '+quoteInfo.Fax__c+'</inline>'+
                   '</block></table-cell></table-row>';
            }
            if(quoteInfo.Website__c != null){
               tableBody += '<table-row><table-cell display-align="center" padding="5">'+
                   '<block font-weight="bold" font-size="small"><inline>Website</inline>'+
                   '</block></table-cell>';
               tableBody += '<table-cell display-align="center" padding="5">'+
                   '<block font-size="small"><inline>'+': '+quoteInfo.Website__c+'</inline>'+
                   '</block></table-cell></table-row>';
            }
            if(quoteInfo.PAN_Number__c != null){
               tableBody += '<table-row><table-cell display-align="center" padding="5">'+
                   '<block font-weight="bold" font-size="small"><inline>PAN</inline>'+
                   '</block></table-cell>';
               tableBody += '<table-cell display-align="center" padding="5">'+
                   '<block font-size="small"><inline>'+': '+quoteInfo.PAN_Number__c+'</inline>'+
                   '</block></table-cell></table-row>';
            }
            if(quoteInfo.Exim_Code__c != null){
               tableBody += '<table-row><table-cell display-align="center" padding="5">'+
                   '<block font-weight="bold" font-size="small"><inline>Exim Code</inline>'+
                   '</block></table-cell>';
               tableBody += '<table-cell display-align="center" padding="5">'+
                   '<block font-size="small"><inline>'+': '+quoteInfo.Exim_Code__c+'</inline>'+
                   '</block></table-cell></table-row>';
            }
            if(quoteInfo.VAT_Number__c != null){
               tableBody += '<table-row><table-cell display-align="center" padding="5">'+
                   '<block font-weight="bold" font-size="small"><inline>VAT No.</inline>'+
                   '</block></table-cell>';
               tableBody += '<table-cell display-align="center" padding="5">'+
                   '<block font-size="small"><inline>'+': '+quoteInfo.VAT_Number__c+'</inline>'+
                   '</block></table-cell></table-row>';
            }
            tableBody += '</table-body></table>';
            System.debug('###'+tableBody);
              
        }catch(Exception e){
            System.debug('Exception:'+e);
        }
    }
}