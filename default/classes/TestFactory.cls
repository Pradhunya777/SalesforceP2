/**  
 * @Description        : Factory class to create test data record
 * @Author             : NA
 * @Date               : 19-01-2022 (DD-MM-YYYY)  
 * 
 * Modification Log:
 * Ticket           Author          Date                 Description
 * NA               NA              19-01-2022           Initial Development
*/

@isTest
public class TestFactory {
    public static Account buildAccount(String name) {
        return new Account(
            Name = name
        );
    }

    public static void buildCustomSettings() {
        // Build Zoom One Custom Setting
        ZOOP_ONE_API_Setting__c zoopSetting = new ZOOP_ONE_API_Setting__c();
		zoopSetting.API_Key__c = 'TestKey';
		zoopSetting.App_Id__c = 'TestAppId';
		zoopSetting.Endpoint__c = 'https://test.zoop.one/api/v1/in/identity/pan/lite';
		INSERT zoopSetting;
    }
}