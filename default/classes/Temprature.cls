public class Temprature {
    public static decimal FtoC(Decimal fh){
        Decimal result = (fh-32)*5/9;
        return result.setScale(2);
    } 
}