//----------------------------------------------------
//
// Generated by www.easywsdl.com
// Version: 4.1.9.0
//
// Created by Quasar Development at 02-11-2015
//
//---------------------------------------------------



#import "USAePayAccountDetails.h"
#import "USAePayAddress.h"
#import "USAePayBank.h"
#import "USAePayBatchSearchResult.h"
#import "USAePayBatchStatus.h"
#import "USAePayBatchUploadStatus.h"
#import "USAePayCheckData.h"
#import "USAePayCheckTrace.h"
#import "USAePayCreditCardData.h"
#import "USAePayCurrencyConversion.h"
#import "USAePayCurrencyObject.h"
#import "USAePayCustomerObject.h"
#import "USAePayCustomerSearchResult.h"
#import "USAePayCustomerTransactionRequest.h"
#import "USAePayFieldValue.h"
#import "USAePayLineItem.h"
#import "USAePayPaymentMethod.h"
#import "USAePayPriceTier.h"
#import "USAePayProduct.h"
#import "USAePayProductCategory.h"
#import "USAePayProductInventory.h"
#import "USAePayProductSearchResult.h"
#import "USAePayReceipt.h"
#import "USAePayRecurringBilling.h"
#import "USAePaySearchParam.h"
#import "USAePaySyncLog.h"
#import "USAePaySystemInfo.h"
#import "USAePayTransactionDetail.h"
#import "USAePayTransactionObject.h"
#import "USAePayTransactionRequestObject.h"
#import "USAePayTransactionResponse.h"
#import "USAePayTransactionSearchResult.h"
#import "USAePayueHash.h"
#import "USAePayueSecurityToken.h"
#import "USAePayBankArray.h"
#import "USAePayBatchStatusArray.h"
#import "USAePayCurrencyConversionArray.h"
#import "USAePayCurrencyObjectArray.h"
#import "USAePayCustomerObjectArray.h"
#import "USAePaydoubleArray.h"
#import "USAePayFieldValueArray.h"
#import "USAePayLineItemArray.h"
#import "USAePayPaymentMethodArray.h"
#import "USAePayPriceTierArray.h"
#import "USAePayProductArray.h"
#import "USAePayProductCategoryArray.h"
#import "USAePayProductInventoryArray.h"
#import "USAePayReceiptArray.h"
#import "USAePaySearchParamArray.h"
#import "USAePaystringArray.h"
#import "USAePaySyncLogArray.h"
#import "USAePayTransactionObjectArray.h"
#import "USAePayHelper.h"
#import "USAePayRequestResultHandler.h"
#import "USAePaySoapError.h"


@implementation USAePayRequestResultHandler

@synthesize Header,Body;
@synthesize OutputHeader,OutputBody,OutputFault;
@synthesize Callback;
@synthesize EnableLogging;
@synthesize EnableMTOM;
static NSDictionary* classNames;

- (id) init {
    if(self = [self init:SOAPVERSION_11])
    {
    }
    return self;
}

-(id)init:(int)version {
    if ((self=[super init])) {
        soapVersion=version;
        envNS=(soapVersion==SOAPVERSION_12?@"http://www.w3.org/2003/05/soap-envelope":@"http://schemas.xmlsoap.org/soap/envelope/");
        receivedBuffer=[NSMutableData data];
        referencesTable=[NSMutableDictionary dictionary];
        reverseReferencesTable=[NSMutableDictionary dictionary];
        attachments=[NSMutableDictionary dictionary];
        namespaces=[NSMutableDictionary dictionary];
        [self createEnvelopeXml];

        if(!classNames)
        {
            classNames = [NSDictionary dictionaryWithObjectsAndKeys:    
            [USAePayAccountDetails class],@"urn:usaepay^^AccountDetails",
            [USAePayAddress class],@"urn:usaepay^^Address",
            [USAePayBank class],@"urn:usaepay^^Bank",
            [USAePayBatchSearchResult class],@"urn:usaepay^^BatchSearchResult",
            [USAePayBatchStatus class],@"urn:usaepay^^BatchStatus",
            [USAePayBatchUploadStatus class],@"urn:usaepay^^BatchUploadStatus",
            [USAePayCheckData class],@"urn:usaepay^^CheckData",
            [USAePayCheckTrace class],@"urn:usaepay^^CheckTrace",
            [USAePayCreditCardData class],@"urn:usaepay^^CreditCardData",
            [USAePayCurrencyConversion class],@"urn:usaepay^^CurrencyConversion",
            [USAePayCurrencyObject class],@"urn:usaepay^^CurrencyObject",
            [USAePayCustomerObject class],@"urn:usaepay^^CustomerObject",
            [USAePayCustomerSearchResult class],@"urn:usaepay^^CustomerSearchResult",
            [USAePayCustomerTransactionRequest class],@"urn:usaepay^^CustomerTransactionRequest",
            [USAePayFieldValue class],@"urn:usaepay^^FieldValue",
            [USAePayLineItem class],@"urn:usaepay^^LineItem",
            [USAePayPaymentMethod class],@"urn:usaepay^^PaymentMethod",
            [USAePayPriceTier class],@"urn:usaepay^^PriceTier",
            [USAePayProduct class],@"urn:usaepay^^Product",
            [USAePayProductCategory class],@"urn:usaepay^^ProductCategory",
            [USAePayProductInventory class],@"urn:usaepay^^ProductInventory",
            [USAePayProductSearchResult class],@"urn:usaepay^^ProductSearchResult",
            [USAePayReceipt class],@"urn:usaepay^^Receipt",
            [USAePayRecurringBilling class],@"urn:usaepay^^RecurringBilling",
            [USAePaySearchParam class],@"urn:usaepay^^SearchParam",
            [USAePaySyncLog class],@"urn:usaepay^^SyncLog",
            [USAePaySystemInfo class],@"urn:usaepay^^SystemInfo",
            [USAePayTransactionDetail class],@"urn:usaepay^^TransactionDetail",
            [USAePayTransactionObject class],@"urn:usaepay^^TransactionObject",
            [USAePayTransactionRequestObject class],@"urn:usaepay^^TransactionRequestObject",
            [USAePayTransactionResponse class],@"urn:usaepay^^TransactionResponse",
            [USAePayTransactionSearchResult class],@"urn:usaepay^^TransactionSearchResult",
            [USAePayueHash class],@"urn:usaepay^^ueHash",
            [USAePayueSecurityToken class],@"urn:usaepay^^ueSecurityToken",
            [USAePayBankArray class],@"urn:usaepay^^BankArray",
            [USAePayBatchStatusArray class],@"urn:usaepay^^BatchStatusArray",
            [USAePayCurrencyConversionArray class],@"urn:usaepay^^CurrencyConversionArray",
            [USAePayCurrencyObjectArray class],@"urn:usaepay^^CurrencyObjectArray",
            [USAePayCustomerObjectArray class],@"urn:usaepay^^CustomerObjectArray",
            [USAePaydoubleArray class],@"urn:usaepay^^doubleArray",
            [USAePayFieldValueArray class],@"urn:usaepay^^FieldValueArray",
            [USAePayLineItemArray class],@"urn:usaepay^^LineItemArray",
            [USAePayPaymentMethodArray class],@"urn:usaepay^^PaymentMethodArray",
            [USAePayPriceTierArray class],@"urn:usaepay^^PriceTierArray",
            [USAePayProductArray class],@"urn:usaepay^^ProductArray",
            [USAePayProductCategoryArray class],@"urn:usaepay^^ProductCategoryArray",
            [USAePayProductInventoryArray class],@"urn:usaepay^^ProductInventoryArray",
            [USAePayReceiptArray class],@"urn:usaepay^^ReceiptArray",
            [USAePaySearchParamArray class],@"urn:usaepay^^SearchParamArray",
            [USAePaystringArray class],@"urn:usaepay^^stringArray",
            [USAePaySyncLogArray class],@"urn:usaepay^^SyncLogArray",
            [USAePayTransactionObjectArray class],@"urn:usaepay^^TransactionObjectArray",
            nil]; 

        }
    }
    return self;
}

    
-(NSString*) getEnvelopeString
{
    return [[xml rootElement] XMLString];
}

-(DDXMLDocument*) createEnvelopeXml
{
    NSString *envelope=nil;
    if(soapVersion==SOAPVERSION_12)
    {
        envelope = [NSString stringWithFormat:@"<soap:Envelope xmlns:c=\"http://www.w3.org/2003/05/soap-encoding\" xmlns:soap=\"%@\"></soap:Envelope>",envNS];
    }
    else
    {
        envelope = [NSString stringWithFormat:@"<soap:Envelope xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:soap=\"%@\"></soap:Envelope>",envNS];
    }
    
    xml = [[DDXMLDocument alloc] initWithXMLString:envelope options:0 error:nil];
    
    DDXMLElement *root=[xml rootElement];
    Header=[[DDXMLElement alloc] initWithName:@"soap:Header"];
    Body=[[DDXMLElement alloc] initWithName:@"soap:Body"];
    [root addChild:Header];
    [root addChild:Body];
    return xml;
}

-(id)createObject: (DDXMLElement*) node type:(Class) type
{
    DDXMLNode* refAttr=[USAePayHelper getAttribute:node name:@"Ref" url:MS_SERIALIZATION_NS];
    if(refAttr!=nil)
    {
        return [referencesTable objectForKey:[refAttr stringValue]];
    }
    
    DDXMLNode* nilAttr=[USAePayHelper getAttribute:node name:@"nil" url:XSI];
    if(nilAttr!=nil && [[nilAttr stringValue]boolValue])
    {
        return nil;
    }

    DDXMLNode* typeAttr=[USAePayHelper getAttribute:node name:@"type" url:XSI];
    if(typeAttr !=nil)
    {
        NSString* attrValue=[typeAttr stringValue];
        NSArray* splitString=[attrValue componentsSeparatedByString:@":"];
        DDXMLNode* namespace=[node resolveNamespaceForName:attrValue];
        NSString* typeName=[splitString count]==2?[splitString objectAtIndex:1]:attrValue;
        if(namespace!=nil)
        {
            NSString* classType=[NSString stringWithFormat:@"%@^^%@",[namespace stringValue],typeName];
            Class temp=[classNames objectForKey: classType];
            if(temp!=nil)
            {
                type=temp;
            }
        }
    }

    DDXMLNode* hrefAttr=[USAePayHelper getAttribute:node name:@"href" url:@""];
    if(hrefAttr==nil)
    {
        hrefAttr=[USAePayHelper getAttribute:node name:@"ref" url:@""];
    }
    if(hrefAttr!=nil)
    {
        NSString* hrefId=[[hrefAttr stringValue] substringFromIndex:1];
        NSString* xpathQuery=[NSString stringWithFormat:@"//*[@id='%@']",hrefId];
        NSArray *nodes=[node.rootDocument nodesForXPath:xpathQuery error:nil];

        if([nodes count]>0)
        {
            node=[nodes objectAtIndex:0];
        }
    }

    id obj=[self createInstance:type node:node request:self];

    DDXMLNode* idAttr=[USAePayHelper getAttribute:node name:@"Id" url:MS_SERIALIZATION_NS];
    if(idAttr!=nil)
    {
        [referencesTable setObject:obj forKey:[idAttr stringValue]];
    }
    
    return obj;
}
    
-(id) createInstance:(Class) type node: (DDXMLNode*)node request :(USAePayRequestResultHandler *)request
{
    SEL initSelector=@selector(initWithXml:__request:);
    id allocObj=[type alloc];
    IMP imp = [allocObj methodForSelector:initSelector];
    id (*func)(id, SEL, DDXMLNode*, USAePayRequestResultHandler *) = (void *)imp;
    id obj = func(allocObj, initSelector, node, self);
    return obj;
}

-(NSString*) getNamespacePrefix:(NSString*) url propertyElement:(DDXMLElement*) propertyElement
{
    if([url length]==0)
    {
        return nil;
    }
    DDXMLElement* rootElement= [[propertyElement rootDocument] rootElement];
    NSString* prefix= [namespaces valueForKey:url];
    if(prefix==nil)
    {
        prefix=[NSString stringWithFormat:@"n%u",[namespaces count]+1];
        DDXMLNode* ns=[DDXMLNode namespaceWithName:prefix stringValue:url];
        [rootElement addNamespace:ns];
        [namespaces setValue:prefix forKey:url];
    }
    return prefix;
}
        
-(NSString*) getXmlFullName:(NSString*) name URI:(NSString*) URI propertyElement:(DDXMLElement*) propertyElement
{
    NSString *prefix=[self getNamespacePrefix:URI propertyElement:propertyElement];
    NSString *fullname=name;
    if(prefix!=nil)
    {
        fullname=[NSString stringWithFormat:@"%@:%@",prefix,name];
    }
    return fullname;
}
    
-(DDXMLNode*) addAttribute:(NSString*) name URI:(NSString*) URI stringValue:(NSString*) stringValue element:(DDXMLElement*) element
{
    NSString *fullname=[self getXmlFullName:name URI:URI propertyElement:element];
    DDXMLNode *refAttr=[DDXMLNode attributeWithName:fullname stringValue:stringValue];
    [element addAttribute:refAttr];
    return refAttr;
}

-(DDXMLElement*) writeElement:(NSString*)name URI: (NSString*) URI parent:(DDXMLElement*) parent
{
    NSString *fullname=[self getXmlFullName:name URI:URI propertyElement:parent];
    DDXMLElement* propertyElement=[[DDXMLElement alloc] initWithName:fullname];
    [parent addChild:propertyElement];
    return propertyElement;
}


-(DDXMLElement*) writeElement:(id)obj type:(Class)type name: (NSString*)name URI: (NSString*) URI parent:(DDXMLElement*) parent skipNullProperty:(BOOL)skipNullProperty
{
    if(obj==nil && skipNullProperty)
    {
        return nil;
    }
    DDXMLElement* propertyElement=[self writeElement:name URI:URI parent:parent];
    
    if(obj==nil)
    {
        [self addAttribute:@"nil" URI:XSI stringValue:@"true" element:propertyElement];
        return nil;
    }
    NSValue* key=[NSValue valueWithNonretainedObject:obj ] ;
    id idStr=[reverseReferencesTable objectForKey:key];
    if(idStr!=nil)
    {
        [self addAttribute:@"Ref" URI:MS_SERIALIZATION_NS stringValue:idStr element:propertyElement];
        return nil;
    }
    if([obj conformsToProtocol:@protocol(USAePayIReferenceObject)])
    {
        idStr=[NSString stringWithFormat:@"i%u",[reverseReferencesTable count]+1];       
        [self addAttribute:@"Id" URI:MS_SERIALIZATION_NS stringValue:idStr element:propertyElement];
        [reverseReferencesTable setObject:idStr forKey:key];
    }

    Class currentType=[obj class];
    if(currentType!=type)
    {
        NSString* xmlType=(NSString*)[[classNames allKeysForObject:currentType] lastObject];//add namespace?
        if(xmlType!=nil)
        {
            
            NSArray* splitType=[xmlType componentsSeparatedByString:@"^^"];
            NSString *fullname=[self getXmlFullName:[splitType objectAtIndex:1] URI:[splitType objectAtIndex:0] propertyElement:propertyElement];
            [self addAttribute:@"type" URI:XSI stringValue:fullname element:propertyElement];
        }
        
    }
    return propertyElement;
}


        
-(void)setResponse:(NSData *)responseData response:(NSURLResponse*) response
{
    if(self.EnableLogging) {
        NSString* strResponse = [[NSString alloc] initWithData: responseData encoding: NSUTF8StringEncoding];
        NSLog(@"%@\n", strResponse);
    }
    if(response!=nil)
    {
        NSDictionary* headers = [(NSHTTPURLResponse *)response allHeaderFields];
        PKContentType* pkContentType=[[PKContentType alloc]initWithString:[headers objectForKey:@"Content-Type"]];
        if(pkContentType.isMultipart)
        {
            [self parseMultipartData:responseData contentType:pkContentType];
            return;
        }
    }
    DDXMLDocument *__doc=[[DDXMLDocument alloc] initWithData:responseData options:0 error:nil];
    DDXMLElement *__root=[__doc rootElement];
    if(__root==nil)
    {
        NSString* errorMessage=[[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding ];
        OutputFault=[NSError  errorWithDomain:errorMessage code:0 userInfo:nil];
        return;
    }
    OutputBody=[USAePayHelper getNode:__root  name:@"Body" URI:envNS];
    OutputHeader=[USAePayHelper getNode:__root  name:@"Header" URI:envNS];
    DDXMLElement* fault=[USAePayHelper getNode:OutputBody  name:@"Fault" URI:envNS];
    if(fault!=nil)
    {
        DDXMLElement* faultString=[USAePayHelper getNode:fault name:@"faultstring"];
        if(faultString == nil)
        {
            faultString=[USAePayHelper getNode:fault name:@"Reason"];
            if(faultString!=nil)
            {
                faultString = [USAePayHelper getNode:faultString name:@"Text"];
            }
        }
        id faultObj=nil;
        DDXMLElement* faultDetail=[USAePayHelper getNode:fault name:@"detail"];
        if(faultDetail!=nil)
        {
            DDXMLElement* faultClass=(DDXMLElement*)[faultDetail childAtIndex:0];
            if(faultClass!=nil)
            {
                NSString * typeName=[faultClass localName];
                DDXMLNode* namespaceNode=[faultClass resolveNamespaceForName:typeName];
                NSString* namespace=nil;
                if(namespaceNode==nil)
                {
                    namespace=[faultClass URI];
                }
                else
                {
                    namespace=[namespaceNode stringValue];
                }
                NSString* classType=[NSString stringWithFormat:@"%@^^%@",namespace,typeName];
                Class temp=[classNames objectForKey: classType];
                if(temp!=nil)
                {
                    faultObj= [self createInstance:temp node:faultClass request:self];
                }
            }
        }
        
        OutputFault=[[USAePaySoapError alloc] initWithDetails:[faultString stringValue] details:faultObj];
    }
}

-(void) sendImplementation:(NSMutableURLRequest*) request
{

    if(self.EnableLogging) {
        NSString* strRequest = [[NSString alloc] initWithData: request.HTTPBody encoding: NSUTF8StringEncoding];
        NSLog(@"%@\n", strRequest);
    }

    NSURLResponse* response;
    NSError* innerError;
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&innerError];
    if(data==nil)
    {
        OutputFault = innerError;
    }
    else
    {
        [self setResponse:data response:response];
    }
}

-(void) sendImplementation:(NSMutableURLRequest*) request callbackDelegate:(USAePayCLB) callbackDelegate
{
    if(self.EnableLogging) {
        NSString* strRequest = [[NSString alloc] initWithData: request.HTTPBody encoding: NSUTF8StringEncoding];
        NSLog(@"%@\n", strRequest);
    }
    self.Callback=callbackDelegate;
    connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

- (void)connection:(NSURLConnection *)connectionParam didReceiveResponse:(NSURLResponse *)response {
    [receivedBuffer setLength:0];
    responseObj=response;
}

- (void)connection:(NSURLConnection *)connectionParam didReceiveData:(NSData *)value {
    [receivedBuffer appendData:value];
}

- (void)connection:(NSURLConnection *)connectionParam didFailWithError:(NSError *)error {
    OutputFault=error;
    self.Callback(self);
    connection = nil;
    self.Callback=nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connectionParam {
	connection = nil;
    [self setResponse:receivedBuffer response:responseObj];
    self.Callback(self);
    self.Callback=nil;
}

-(void)connection:(NSURLConnection *)connectionParam didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
}

-(void)Cancel
{
    if(connection!=nil)
    {
        [connection cancel];
        connection=nil;
        self.Callback=nil;
    }
}


-(void) prepareRequest:(NSMutableURLRequest*)__requestObj
{
    NSData *__soapMessageData=nil;
    if(EnableMTOM)
    {
        PKMIMEMessage* __mimeMessage=[self getEnvelopeData];
        __soapMessageData=[__mimeMessage data];
        [__requestObj addValue: @"multipart/related; application/xop+xml; text/xml; charset=utf-8" forHTTPHeaderField:@"Accept"];
        [__requestObj addValue: @"1.0" forHTTPHeaderField:@"MIME-Version"];
        NSString* contentType=[NSString stringWithFormat:@"multipart/related; type=\"application/xop+xml\"; start-info=\"text/xml\";  boundary=\"%@\"; start=\"<%@>\"",__mimeMessage.boundary,__mimeMessage.rootContentID];
        [__requestObj addValue: contentType forHTTPHeaderField:@"Content-Type"];
    }
    else
    {
        __soapMessageData=[[self getEnvelopeString] dataUsingEncoding:NSUTF8StringEncoding];
        [__requestObj addValue: soapVersion==SOAPVERSION_12?@"application/soap+xml; charset=utf-8":@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    }

    NSString *msgLength = [NSString stringWithFormat:@"%u", [__soapMessageData length]];
    [__requestObj addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [__requestObj setHTTPBody: __soapMessageData];
}
-(void) setBinary:(DDXMLNode*)propertyElement data:(NSData*)data isSwaRef:(BOOL)isSwaRef isAttribute:(BOOL) isAttribute
{
    if(EnableMTOM && !isAttribute)
    {
        NSString* contentId = [USAePayHelper createGuid];
        [attachments setObject:data forKey:contentId];
        contentId=[NSString stringWithFormat:@"cid:%@",contentId];
        if(isSwaRef)
        {
            [propertyElement setStringValue:contentId];
        }
        else
        {
            DDXMLElement* includeElement=[self writeElement:@"Include" URI:@"http://www.w3.org/2004/08/xop/include" parent:(DDXMLElement*)propertyElement];
            [self addAttribute:@"href" URI:nil stringValue:contentId element:includeElement];
        }
        return;
    }
    [propertyElement setStringValue:[USAePayHelper base64forData:data]];
}

-(NSData*) getBinary: (DDXMLNode*)element isSwaRef:(BOOL)isSwaRef isAttribute:(BOOL) isAttribute
{
    if(!isAttribute)
    {
        DDXMLElement* includeElem=[USAePayHelper getNode:(DDXMLElement*)element name:@"Include" URI:@"http://www.w3.org/2004/08/xop/include"];
        if(includeElem!=nil)
        {
            DDXMLNode *href=[USAePayHelper getAttribute:includeElem name:@"href"];
            NSString* cid=[href stringValue];
            cid = [cid substringFromIndex:4];
            PKMIMEData* attachment=[self attachmentById:cid];
            return [attachment data];
        }
        else if(isSwaRef)
        {
            NSString* cid=[element stringValue];
            cid = [cid substringFromIndex:4];
            PKMIMEData* attachment=[self attachmentById:cid];
            return [attachment data];
        }
    }
    return [USAePayHelper base64DataFromString:[element stringValue]];
}
 

-(void)parseMultipartData:(NSData*) responseData contentType:(PKContentType*)contentType
{
    PKMIMEData* mimeData=[PKMIMEData dataFromData:responseData withContentType:contentType];
    mimeMessage=[PKMIMEMessage messageWithData:mimeData];
    PKMIMEData *root=[mimeMessage rootData];

    [self setResponse:[root  data] response:nil];
}

-(PKMIMEData*) attachmentById:(NSString*) contentId
{
    return [mimeMessage partDataWithID:contentId];
}

-(PKMIMEMessage*) getEnvelopeData
    {
    NSString* uuidStr = [USAePayHelper createGuid];

    NSString* rootId = [USAePayHelper createGuid];

    PKContentType* contentType=[[PKContentType alloc]initWithString:@"multipart/related"];
    PKMIMEMessage* pkMessage=[[PKMIMEMessage alloc]initWithContentType:contentType];

    [pkMessage setBoundary:[NSString stringWithFormat:@"uuid:%@",uuidStr]];
    NSString* xmlEnvelope=[self getEnvelopeString];
    PKMIMEData* pkData = [[PKMIMEData alloc]initWithString:xmlEnvelope];
    [pkData setContentID:rootId];
    [pkData setContentType:[[PKContentType alloc]initWithString:@"application/xop+xml;charset=utf-8;type=\"text/xml\""]];
    [pkMessage addPart:pkData];

    [pkMessage setRootContentID:rootId];
    for(NSString *key in attachments)
    {
        NSData* attachment=[attachments objectForKey:key];
        pkData = [[PKMIMEData alloc]initWithData:attachment contentID:key];
        NSString* contentType=@"application/octet-stream";
        [pkData setContentType:[[PKContentType alloc]initWithString:contentType]];
        [pkMessage addPart:pkData];
    }
    return pkMessage;
}
    


-(void) addWS_addressingHeaders:(NSString*) action replyTo:(NSString*) replyTo to:(NSString*) to referenceParameters:(NSMutableArray *)referenceParameters
{
    DDXMLElement* __wsaddressingElement=[self writeElement:@"Action" URI:@"http://www.w3.org/2005/08/addressing" parent:self.Header];
    [__wsaddressingElement setStringValue:action];
    [self addAttribute:@"mustUnderstand" URI:envNS stringValue:@"1" element:__wsaddressingElement];
    __wsaddressingElement=[self writeElement:@"MessageID"  URI:@"http://www.w3.org/2005/08/addressing" parent:self.Header];
    [__wsaddressingElement setStringValue:[@"urn:uuid:" stringByAppendingString:[USAePayHelper createGuid]]];
    __wsaddressingElement=[self writeElement:@"ReplyTo" URI:@"http://www.w3.org/2005/08/addressing" parent:self.Header];
    __wsaddressingElement=[self writeElement:@"Address" URI:@"http://www.w3.org/2005/08/addressing" parent:__wsaddressingElement];
    [__wsaddressingElement setStringValue:replyTo];
    __wsaddressingElement=[self writeElement:@"To" URI:@"http://www.w3.org/2005/08/addressing" parent:self.Header];
    [__wsaddressingElement setStringValue:to ];
    [self addAttribute:@"mustUnderstand" URI:envNS stringValue:@"1" element:__wsaddressingElement];

    for (NSString* param in referenceParameters) {
        DDXMLDocument *__doc=[[DDXMLDocument alloc]  initWithXMLString:param options:0 error:nil];
        DDXMLElement *root=[__doc rootElement];
        [root detach];
        [self addAttribute:@"IsReferenceParameter" URI:@"http://www.w3.org/2005/08/addressing" stringValue:@"true" element:root];
        [self.Header addChild:root];
    }
}

-(id) getAnyTypeValue:(DDXMLElement*) node
{
    DDXMLNode* typeAttr=[USAePayHelper getAttribute:node name:@"type" url:XSI];
    if(typeAttr !=nil)
    {
        NSString* attrValue=[typeAttr stringValue];
        NSArray* splitString=[attrValue componentsSeparatedByString:@":"];
        if([splitString count]==2)
        {
            DDXMLNode* namespace=[node resolveNamespaceForName:attrValue];
            if([[namespace stringValue] isEqualToString:@"http://www.w3.org/2001/XMLSchema"])
            {
                NSString *value=(NSString *)[splitString objectAtIndex:1];
                if([value isEqualToString:@"int"] || [value isEqualToString:@"double"] || [value isEqualToString:@"float"] || [value isEqualToString:@"long"] || [value isEqualToString:@"integer"] || [value isEqualToString:@"decimal"] || [value isEqualToString:@"byte"] || [value isEqualToString:@"negativeInteger"]
                    || [value isEqualToString:@"nonNegativeInteger"] || [value isEqualToString:@"nonPositiveInteger"] || [value isEqualToString:@"positiveInteger"]
                    || [value isEqualToString:@"short"] || [value isEqualToString:@"unsignedLong"] || [value isEqualToString:@"unsignedInt" ]|| [value isEqualToString:@"unsignedShort"] || [value isEqualToString:@"unsignedByte"])
                {
                    return [USAePayHelper getNumber:[node stringValue] ];
                }
                else if([value isEqualToString:@"boolean"])
                {
                    return [NSNumber numberWithBool:[[node stringValue] isEqualToString:@"true"]];
                }
                else{
                    return [node stringValue];
                }
            }
            else
            {
                NSString* typeName=[splitString count]==2?[splitString objectAtIndex:1]:attrValue;
                if(namespace!=nil)
                {
                    NSString* classType=[NSString stringWithFormat:@"%@^^%@",[namespace stringValue],typeName];
                    Class temp=[classNames objectForKey: classType];
                    if(temp!=nil)
                    {
                        return [self createInstance:temp node:node request:self];
                    }
                }
            }
        }
    }
    return node;
}

-(void) setAnyTypeValue: (NSObject*)item propertyElement:(DDXMLElement*) propertyElement
{
    if([item conformsToProtocol:@protocol(USAePayISerializableObject)])
    {
        id< USAePayISerializableObject> obj1=(id< USAePayISerializableObject>)item;
        [obj1 serialize:propertyElement __request:self];
    }
    else if([item isKindOfClass:[NSString class]])
    {
        NSString* str=(NSString*)item;
        NSString* prefix=[self getNamespacePrefix:@"http://www.w3.org/2001/XMLSchema" propertyElement:propertyElement];
        [self addAttribute:@"type" URI:@"http://www.w3.org/2001/XMLSchema-instance" stringValue:[NSString stringWithFormat:@"%@:string", prefix] element:propertyElement];
        [propertyElement setStringValue:str];
    }
    else if([item isKindOfClass:[NSNumber class]])
    {
        NSNumber *number=(NSNumber*)item;
        NSString* prefix=[self getNamespacePrefix:@"http://www.w3.org/2001/XMLSchema" propertyElement:propertyElement ];
        if (strcmp([number objCType], @encode(BOOL)) == 0)
        {
            [self addAttribute:@"type" URI:@"http://www.w3.org/2001/XMLSchema-instance" stringValue:[NSString stringWithFormat:@"%@:boolean", prefix] element:propertyElement];
            [propertyElement setStringValue:item == (void*)kCFBooleanFalse?@"false":@"true"];
        } 
        else if (strcmp([number objCType], @encode(int)) == 0) 
        {
            [self addAttribute:@"type" URI:@"http://www.w3.org/2001/XMLSchema-instance" stringValue:[NSString stringWithFormat:@"%@:int", prefix] element:propertyElement];
            [propertyElement setStringValue:[number stringValue]];
        }
        else if (strcmp([number objCType], @encode(long)) == 0) 
        {
            [self addAttribute:@"type" URI:@"http://www.w3.org/2001/XMLSchema-instance" stringValue:[NSString stringWithFormat:@"%@:long", prefix] element:propertyElement];
            [propertyElement setStringValue:[number stringValue]];
        }
        else if (strcmp([number objCType], @encode(float)) == 0) 
        {
            [self addAttribute:@"type" URI:@"http://www.w3.org/2001/XMLSchema-instance" stringValue:[NSString stringWithFormat:@"%@:float", prefix] element:propertyElement];
            [propertyElement setStringValue:[number stringValue]];
        }
        else if (strcmp([number objCType], @encode(double)) == 0) 
        {
            [self addAttribute:@"type" URI:@"http://www.w3.org/2001/XMLSchema-instance" stringValue:[NSString stringWithFormat:@"%@:double", prefix] element:propertyElement];
            [propertyElement setStringValue:[number stringValue]];
        }
        else
        {
            [self addAttribute:@"type" URI:@"http://www.w3.org/2001/XMLSchema-instance" stringValue:[NSString stringWithFormat:@"%@:long", prefix] element:propertyElement];
            [propertyElement setStringValue:[number stringValue]];
        }
    }
    else
    {
        [propertyElement setStringValue:[item description]];
    }
}
@end
