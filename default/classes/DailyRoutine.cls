public class DailyRoutine {
    public DailyRoutine(){
        brush();
        bath();
        lunch();
        code();        
        dinner();
        sleep();
        repeat();
    }
    public static void brush(){
        System.debug('I am having a brush ');
    }
    public static void bath(){
        System.debug('I am having bath ');
    }
    @future
    public static void lunch(){ 
        System.debug('I am having a lunch ');
    }
    public static void code(){
        System.debug('Write a code ');
    }
    public static void dinner(){
        System.debug('I am having dinner '); 
    }
    public static void sleep(){
        System.debug('I am going to sleep ');
    }
    public static void repeat(){
        System.debug('Repeat all the steps ');
    }
}