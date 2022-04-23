public class SoqlKeywords {
    public static void main(){
        
        
        //***IN
        List<String> nameList = new List<String>{'Aryan','Sudam','Raju','Ashok'};
        List<Contact> conList = [Select FirstName from Contact where Name IN :nameList];
        System.debug(nameList);
        System.debug('Result is'+conList);
        
        //***NOT IN
        List<String> nameList1 = new List<String>{'Aryan','Sudam','Raju','Ashok'};
        List<Contact> conList1 = [Select FirstName from Contact where Name NOT IN :nameList];
        System.debug(nameList1);
        System.debug('Result is'+conList1);
        
        //***Like
        List<Account> accList = [Select name from account where name like 'GenePoint'];
        
        List<Account> accList1 = [Select name from account where name like 'Burlington%'];
        List<Account> accList2 = [Select name from account where name like '%Oil%'];
        List<Account> accList3 = [Select name from account where name like '_Force'];
        System.debug(accList);
        System.debug(accList1);
        System.debug(accList2);
        System.debug(accList3);
        
        //***And /  Or
        List<Opportunity>oppList1=[Select name,Amount from opportunity where amount > 100000 And StageName ='Closed-won'];
        System.debug(oppList1);
        List<Opportunity>oppList2=[Select name,Amount from opportunity where amount > 100000 Or StageName ='Closed-won'];
        System.debug(oppList2);
        
        //***Order by
        List<Opportunity> oppList6=[Select name,amount from opportunity order by amount];
        System.debug(oppList6);
        
        List<Opportunity> oppList7=[Select name,amount from opportunity order by amount asc];
        System.debug(oppList7);
        
        List<Opportunity> oppList8=[Select name,amount from opportunity order by amount desc];
        System.debug(oppList8);
        
        List<Opportunity> oppList9=[Select name,amount from opportunity order by amount NULLS FIRST];
        System.debug(oppList9);
        
        List<Opportunity> oppList10=[Select name,amount from opportunity order by amount NULLS LAST];
        System.debug(oppList10);
        
        //***GroupBY
        List<AggregateResult>agrOPPO1=[Select stageName from opportunity GROUP By stagename];
        System.debug(agrOPPO1);
        
        List<AggregateResult>agrOPPO2=[Select Count(ID) from opportunity GROUP By stagename];
        System.debug(agrOPPO2);
        
        List<AggregateResult>agrOPPO3=[Select stageName,Count(ID) from opportunity GROUP By stagename];
        System.debug(agrOPPO3);
        
        List<AggregateResult>agrOPPO4=[Select stageName,Max(Amount) from opportunity GROUP By stagename];
        System.debug(agrOPPO4);
        
        //****LIMIT
        List<Account>accList11=[select name from account limit 10];
        
        List<Account>accList12=[select name from account limit 1];
        
        Account a =[select name from account limit 10];
        System.debug(a);
        
        List<Account> accList15 = [select name from account All Rows];
        
        List<Account> accList16 = [select name from account where isDeleted=true All Rows];
        
        List<Account> accList17 = [select name from account where isDeleted=true];
        
        
    }

}