public class UpSertProduct {
    public static void main(){
        
        //***UpSert
        
        List<Product2>prodList = [select name from product2];
        // Because API name of product is product2.
        
        for(Product2 p : prodList){
            p.Name = p.Name+' 2021';
        }
        product2 p1 = new product2(name='Charger');
        product2 p2 = new product2(name='Drive');
        
        prodList.add(p1);
        prodList.add(p2);
        
        UpSert prodList;
        
    }

}