public class ExceptionHandling {
    public static void main(integer i){
        
      try
      {
        if(i==0){
            Integer a;
            Integer b= a*5;     //Throws a null pointer exception
        }
        else{
            Account acc = new account();
            insert acc;		//Throws DML E
        }
    }
        catch(NullPointerException npe){
            System.debug('I execute when there is a NullPointer Exception in the try block');
        }
        catch(DMLException d){
            System.debug('I execute when there is a DMLException Exception in the try block');
        }
        catch(Exception e){
            System.debug('I execute when there is a Other Exception in the try block');
        }
        finally{
            System.debug('No matter wheather an exception in the try block occured or not I always execute');
        }
        
    }

}