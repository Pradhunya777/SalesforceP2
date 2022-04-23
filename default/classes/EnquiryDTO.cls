/*
* Name 			: EnquiryDTO
* Description	: Enquiry/Quote data structure used to send data from Salesforce to SAP
* TestMethod	:
* CreateDate	: 24-Dec-2021
 -------------------------------------------------------
#ModificationDate	: Details

*/
global class EnquiryDTO{    
    public string ExchangeRate;
    public string Port;
    public string PiNumber;
    public string EnqReceiptDate;
    public string ReasonRejection;
    public string DistributionChannel;
    public string SoldToParty;
    public string PriceingDate;
    public string SapEnquiry;
    public string CustReference;
    public string SalesOrg;
    public string CurrencyIsoCode;
    public string BillTo;
    public string OrderReason;
    public string Division;
    public string SfdcEnquiry;
    public string Inquirytype;
    public string PriceList;
    public string EnquiryDate;
    public string Payer;
    public string ProvisionalPrices;
    public string EnqResponseDate;
    public string PaymentTerm;
    public string ShipToParty;
    public string ExpectedOrderDate;
    public string IncotermLocation1;
    public string Incoterm;
    public string SalesType;
    public List<MessageRespSet> MessageRespSet;
    public List<EnquiryItemSet> EnquiryItmSet;
    
    public class MessageRespSet{
        public string SfdcEnquiry;
        public string MessageItem;
        public string MessageType;
        public string Message;
        public MessageRespSet(){
            this.SfdcEnquiry ='';
            this.MessageItem = '';
            this.MessageType = '';
            this.Message = '';
        }
    }
    public class EnquiryItemSet{
        public string SfdcEnquiry;
        public string EnquiryItem;
        public string SapItem;
        public string FgsapCode;
        public string MaterialSalesText;
        public string Quantity;
        public string Plant;
        public string Insurance;
        public string Freight;
        public string RoundOffValue;
        public string AdditionalField;
        public List<VariantCharSet> VariantCharSet;
    }
    public class VariantCharSet{
        public string SfdcEnquiry;
        public string EnquiryItem;
        public string VariantItem;
        public string InternalCharacterstics;
        public string CharactersticsDesc;
        public string CharatesticsValue;
    }
 
}