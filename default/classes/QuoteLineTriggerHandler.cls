/**
*
*/
public class QuoteLineTriggerHandler {
   // public static Decimal quantity;
    public static void beforeUpdate(Map<Id,SBQQ__QuoteLine__c> newQuoteLines,Map<Id,SBQQ__QuoteLine__c> oldQuoteLines){        
        List<Order_Loss__c> listOrderLoss = new List<Order_Loss__c>();
        Set<Id> quoteIds = new Set<Id>();
        Set<Id> orderIds = new Set<Id>();
        Decimal quantity;   
        
        for(SBQQ__QuoteLine__c line : newQuoteLines.values()){
            quoteIds.add(line.SBQQ__Quote__c);
        }
        SBQQ__Quote__c quote = [SELECT Id, SBQQ__Account__c,SBQQ__Account__r.name,SBQQ__Opportunity2__c
                                FROM SBQQ__Quote__c 
                                WHERE Id IN :quoteIds
                                LIMIT 1 ];
        
        if(!newQuoteLines.isEmpty() && !oldQuoteLines.isEmpty()){
            System.debug('In if');
            for(SBQQ__QuoteLine__c quoteLine : newQuoteLines.values()){
                System.debug('In for');
                if(quoteLine.IsFG__c == true && quoteLine.Loss_Type__c != oldQuoteLines.get(quoteLine.Id).Loss_Type__c || 
                    quoteLine.Loss_Quantity__c != oldQuoteLines.get(quoteLine.Id).Loss_Quantity__c){
                        System.debug('Entery condition!!');
                        if(quoteLine.Loss_Type__c != null && quoteLine.Loss_Quantity__c != null){
                            quantity = quoteLine.SBQQ__Quantity__c - quoteLine.Loss_Quantity__c;
                            System.debug('quantity:'+quantity);
                            Order_Loss__c orderLoss = new Order_Loss__c();                    
                            orderLoss.Customer__c = quote.SBQQ__Account__c;
                            orderLoss.Product__c = quoteLine.SBQQ__Product__c;
                            orderLoss.Quantity__c = quoteLine.Loss_Quantity__c;
                            orderLoss.Loss_Type__c = quoteLine.Loss_Type__c;
                            orderLoss.Opportunity__c = quote.SBQQ__Opportunity2__c;
                            if(quantity >= 0 &&
                                quoteLine.Loss_Quantity__c <= quoteLine.SBQQ__Quantity__c && 
                                quoteLine.Loss_Quantity__c > 0){
                                listOrderLoss.add(orderLoss);
                                quoteLine.SBQQ__Quantity__c = quantity == 0 ? 1 : quantity;
                            }  else if (quoteLine.Loss_Quantity__c < 0 || quoteLine.Loss_Quantity__c > quoteLine.SBQQ__Quantity__c) {
                                quoteLine.adderror('Can Not Update Product '+quoteLine.SBQQ__ProductName__c+'. Loss Quantity Of '
                                           +quoteLine.SBQQ__ProductName__c+'  Is '+quoteLine.Loss_Quantity__c);
                            }
                        }else if(quoteLine.Loss_Type__c == null && (quoteLine.Loss_Quantity__c < 0 || 
                                                                    quoteLine.Loss_Quantity__c > 0 ||
                                                                    quoteLine.Loss_Quantity__c > quoteLine.SBQQ__Quantity__c)) {
                                     System.debug('quoteLine.Loss_Quantity__c:'+quoteLine.Loss_Quantity__c);
                                     System.debug('quoteLine.Loss_Quantity__c:'+quoteLine.SBQQ__Quantity__c);

                            System.debug('Update Error!!!');
                            quoteLine.adderror('Please Enter Valid Loss Quantity For '+quoteLine.SBQQ__ProductName__c+' Product. Make Sure Loss Type Not Empty');
                        }
                    } 
            }
        }        
        if(!listOrderLoss.isEmpty()){
            INSERT listOrderLoss;
            for(Order_Loss__c lossOrder : listOrderLoss){
                orderIds.add(lossOrder.Id);
            }
            if(!orderIds.isEmpty()){
                sendEmailToQuote(orderIds);
            }
            
        }
    }  
    public static void beforeDelete(List<SBQQ__QuoteLine__c> quoteLines){
        System.debug('In before delete function!!');
        List<Order_Loss__c> listOrderLoss = new List<Order_Loss__c>();
        Set<Id> orderIds = new Set<Id>();        
        /*SBQQ__Quote__c quote = [SELECT Id, SBQQ__Account__c,SBQQ__Account__r.name,SBQQ__Opportunity2__c
                                FROM SBQQ__Quote__c 
                                WHERE Id = :quoteLines[0].SBQQ__Quote__c 
                                LIMIT 1 ];*/
        if(!quoteLines.isEmpty()){
            for(SBQQ__QuoteLine__c quoteLine : quoteLines){ 
                System.debug('In for Loop');
                if(quoteLine.IsFG__c == true){  
                    System.debug('In for Loop Is FG');
                    if(quoteLine.Loss_Type__c != null && quoteLine.Loss_Quantity__c != null){ 
                        System.debug('In for Loop Is FG Loss_Type__c');
                        System.debug('quoteLine.SBQQ__Quantity__c:'+quoteLine.SBQQ__Quantity__c);
                        System.debug('quoteLine.Loss_Quantity__c:'+quoteLine.Loss_Quantity__c);
                        if(quoteLine.SBQQ__Quantity__c > 1 && quoteLine.Loss_Quantity__c > 0 ){
                            /*System.debug('3 quantity:'+quantity);*/
                            quoteLine.adderror('You Can Not Delete '+quoteLine.SBQQ__ProductName__c+' Product. Quantity Of '
                                               +quoteLine.SBQQ__ProductName__c+'  Is '+quoteLine.SBQQ__Quantity__c);
                        } else if (quoteLine.Loss_Quantity__c < 0 ) {
                            //create order record
                            //listOrderLoss.add(orderLoss);  
                            /* System.debug('4 quantity:'+quantity);    */
                            quoteLine.adderror('Can Not Delete Product '+quoteLine.SBQQ__ProductName__c+'. Loss Quantity Of '
                                               +quoteLine.SBQQ__ProductName__c+'  Is '+quoteLine.Loss_Quantity__c);             
                        }
                    } else if(quoteLine.Loss_Quantity__c == null && quoteLine.Loss_Type__c == null){
                        quoteLine.adderror('Please Enter Loss Type and Loss Quantity For '+quoteLine.SBQQ__ProductName__c+' Product');
                    } else if(quoteLine.Loss_Type__c == null && 
                              (quoteLine.Loss_Quantity__c < 0 || 
                               quoteLine.Loss_Quantity__c > 0 ||
                               quoteLine.Loss_Quantity__c > quoteLine.SBQQ__Quantity__c)){
                                   quoteLine.adderror(quoteLine.SBQQ__ProductName__c+' Product Can Not Delete. Make Sure Loss Quantity Can Not Null ');
                               }
                }
            }
        }
        /*if(listOrderLoss.size()>0){
            INSERT listOrderLoss;
            System.debug('Afetr orderloss insert');
            for(Order_Loss__c lossOrder : listOrderLoss){
                orderIds.add(lossOrder.Id);
            }
            System.debug('order IDs:'+JSON.serialize(orderIds));
            if(!orderIds.isEmpty()){
                sendEmailToQuote(orderIds);
            }
            
        }*/
    }
    public static void beforeInsert(List<SBQQ__QuoteLine__c> quoteLines){
        System.debug('Insert');
        if(!quoteLines.isEmpty()){
            for(SBQQ__QuoteLine__c quoteLine : quoteLines){
                if(quoteLine.IsFG__c == true){
                    if(quoteLine.Loss_Quantity__c != null){// || quoteLine.Loss_Type__c != null
                        if(quoteLine.Loss_Quantity__c < 0 || quoteLine.Loss_Quantity__c > quoteLIne.SBQQ__Quantity__c){
                            quoteLine.adderror(quoteLine.SBQQ__ProductName__c+' Not Added In Quote Line. Loss Quantity Is '+quoteLine.Loss_Quantity__c);
                        }
                    }
                }
            }
        }
    }
    private static void sendEmailToQuote(Set<Id> orderLossIds){
        /*System.debug('In Send EmailTo Quote');
        SBQQ__Quote__c quote = [SELECT Id, LastModifiedById
                                FROM SBQQ__Quote__c 
                                WHERE Id = :quoteLines[0].SBQQ__Quote__c 
                                LIMIT 1 ];
        User userRecord = [SELECT Id,Email,Name
                           FROM User
                           WHERE Id = :quote.LastModifiedById
                           LIMIT 1];*/
        List<Order_Loss__c> orderLoss = [ SELECT Id,Customer__c,Product__c,Quantity__c,Opportunity__c 
                                         FROM Order_Loss__c 
                                         WHERE Id IN :orderLossIds];
        QuoteLineEmailHandler.sendEmailToUser(orderLoss);
    }
}