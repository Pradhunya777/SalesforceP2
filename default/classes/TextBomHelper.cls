/**  
 * @Description        : Helper class for TextBom
 * @Author             : NA
 * @Date               : 19-01-2022 (DD-MM-YYYY)
 * @TestClass          : TextBomHelperTest.cls
 * 
 * Modification Log:
 * Ticket           Author          Date                 Description
 * NA               NA              19-01-2022           Initial Development
*/

public class TextBomHelper {

    public static List<TextBom__c> searchTextBom(Boolean isStrictMatch, String materialCode, Map<String, String> charMap) {
        List<TextBom__c> textBomList = new List<TextBom__c>();

        if (isStrictMatch) {
            List<String> charNoList = new List<String>();
            for (String charNo : charMap.keySet()) {
                charNoList.add(charNo);
            }
            String mergedCharNo = String.join(charNoList, ' and ');
            String mergedCharVals = String.join(charMap.values(), ' and ');
            textBomList = [SELECT Id, Bom_Content__c, Characteristic_Description__c
                           FROM TextBom__c
                           WHERE Material__c = :materialCode                           
                           AND Characteristic_No__c = :mergedCharNo
                           AND Characteristic_Value__c = :mergedCharVals];
        } else {
            // TODO: 2nd version of Search Logic 
            // 1. Generate all permutations of CharNo & CharVal
            // 2. Apply CharNo & CharVal as Array in SOQL
            // 3. Sort the result based on Highest no of combination on top
        }

        return textBomList;
    }
}