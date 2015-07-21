//
//  Created by Flavio Negrão Torres
//
//  GitHub
//  https://github.com/flavionegrao/MoIPConnector/
//
//
//  License
//  Copyright (c) 2015 Flavio Torres
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "MoipConnector.h"
#import "MoIPObjects.h"
#import "AppDelegate.h"


@interface MoIPConnectorTests : XCTestCase

@property (nonatomic,strong) NSString* moipToken;
@property (nonatomic,strong) NSString* moipAccessKey;
@property (nonatomic,strong) NSString* moipPublicKey;

@end

@implementation MoIPConnectorTests

- (void)setUp {
    [super setUp];
    
    AppDelegate* appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    self.moipToken = appDelegate.myMoipToken;
    self.moipAccessKey = appDelegate.myMoipAccessKey;
    self.moipPublicKey = appDelegate.myPublicKey;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void) testTokenAndAccessKey {
    XCTAssertTrue(self.moipToken.length > 0);
    XCTAssertTrue(self.moipAccessKey.length > 0);
    XCTAssertTrue(self.moipPublicKey.length > 0);
}

- (void) testMoIPItemObject {
    MoIPItem* item = [MoIPItem new];
    item.product = @"Box de Seriado - Exterminate!";
    item.quantity = @1;
    item.detail = @"Box de seriado com 8 dvds";
    item.price = @73.50;
    XCTAssertNotNil(item);
    
    NSDictionary* itemRepresentation = [item dictionaryRepresentation];
    XCTAssertNotNil(itemRepresentation);
    XCTAssertTrue([itemRepresentation[@"price"] integerValue] == 7350);
    
    MoIPItem* item2 = [MoIPItem new];
    item2.product = @"Box de Seriado - Exterminate!";
    item2.quantity = @1;
    item2.detail = @"Box de seriado com 8 dvds";
    item2.price = @73;
    XCTAssertNotNil(item2);
    
    NSDictionary* itemRepresentation2 = [item2 dictionaryRepresentation];
    XCTAssertNotNil(itemRepresentation2);
    XCTAssertTrue([itemRepresentation2[@"price"] integerValue] == 7300);
}

- (void) testMoIPHolderObject {
    MoIPHolder* holder = [MoIPHolder new];
    holder.fullname = @"João Portador da Silva";
    holder.birthdate = [NSDate date];
    holder.taxDocument = [MoIPTaxDocument new];
    holder.taxDocument.type = MoIPTaxDocumentTypeCPF;
    holder.taxDocument.number = @"12345679891";
    holder.phone = MoIPPhoneMake(55, 11, 66778899);

    
    NSDictionary* holderRepresentation = [holder dictionaryRepresentation];
    XCTAssertNotNil(holderRepresentation);
    
    NSString* birthDate = holderRepresentation[@"birthdate"];
    XCTAssertTrue(birthDate.length > 0);
    
    XCTAssertNotNil(holderRepresentation[@"taxDocument"]);
    XCTAssertNotNil(holderRepresentation[@"phone"]);
}

- (void) testMoIPAmountObject {
    MoIPAmount* amount = [MoIPAmount new];
    amount.total = @100.54;
    amount.fees = @45;
    amount.refunds = @56;
    amount.liquid = @65;
    amount.otherReceivers = @100.56;
    amount.currency = @"BRL";
    amount.subtotals = MoIPSubtotalsMake(100, 200, 300, 400);
    
    NSDictionary* amountRepresentation = [amount dictionaryRepresentation];
    XCTAssertNotNil(amountRepresentation);
    
    XCTAssertNotNil(amountRepresentation[@"total"]);
    XCTAssertNotNil(amountRepresentation[@"fees"]);
    XCTAssertNotNil(amountRepresentation[@"refunds"]);
    XCTAssertNotNil(amountRepresentation[@"liquid"]);
    XCTAssertNotNil(amountRepresentation[@"otherReceivers"]);
    XCTAssertNotNil(amountRepresentation[@"currency"]);
    XCTAssertNotNil(amountRepresentation[@"subtotals"]);
    
    MoIPAmount* amount2 = [[MoIPAmount alloc]initWithDictionary:amountRepresentation];
    XCTAssertNotNil(amount2.total);
    XCTAssertNotNil(amount2.fees);
    XCTAssertNotNil(amount2.refunds);
    XCTAssertNotNil(amount2.liquid);
    XCTAssertNotNil(amount2.otherReceivers);
    XCTAssertNotNil(amount2.currency);
    XCTAssertTrue(amount2.subtotals.shipping == 100);
    XCTAssertTrue(amount2.subtotals.adition == 200);
    XCTAssertTrue(amount2.subtotals.discount == 300);
    XCTAssertTrue(amount2.subtotals.items == 400);

}

- (void) testMoIPAddressObject {
    MoIPAddress* address = [MoIPAddress new];
    address.street = @"Rua XPTO";
    address.number = @"123";
    address.complement = @"ap 254";
    address.district = @"Agua Verde";
    address.city = @"Curitiba";
    address.state = @"PR";
    address.country = @"BRA";
    address.zipcode = @"80710000";
    
    NSDictionary* addressRepresentation = [address dictionaryRepresentation];
    XCTAssertNotNil(addressRepresentation);
    
    XCTAssertNotNil(addressRepresentation[@"street"]);
    XCTAssertNotNil(addressRepresentation[@"number"]);
    XCTAssertNotNil(addressRepresentation[@"complement"]);
    XCTAssertNotNil(addressRepresentation[@"district"]);
    XCTAssertNotNil(addressRepresentation[@"city"]);
    XCTAssertNotNil(addressRepresentation[@"state"]);
    XCTAssertNotNil(addressRepresentation[@"country"]);
    XCTAssertNotNil(addressRepresentation[@"zipcode"]);
    
    MoIPAddress* address2 = [[MoIPAddress alloc]initWithDictionary:addressRepresentation];
    XCTAssertNotNil(address2.street);
    XCTAssertNotNil(address2.number);
    XCTAssertNotNil(address2.complement);
    XCTAssertNotNil(address2.district);
    XCTAssertNotNil(address2.city);
    XCTAssertNotNil(address2.state);
    XCTAssertNotNil(address2.country);
    XCTAssertNotNil(address2.zipcode);
}


- (void) testMoIPFundingInstrumentObject {
    
    MoIPHolder* holder = [MoIPHolder new];
    holder.fullname = @"João Portador da Silva";
    holder.birthdate = [NSDate date];
    holder.taxDocument = [MoIPTaxDocument new];
    holder.taxDocument.type = MoIPTaxDocumentTypeCPF;
    holder.taxDocument.number = @"12345679891";
    holder.phone = MoIPPhoneMake(55, 11, 66778899);
    
    MoIPCreditCard* creditCard = [MoIPCreditCard new];
    creditCard.expirationMonth = @"05";
    creditCard.expirationYear = @"2018";
    creditCard.number = @"5555666677778884";
    creditCard.cvc = @"123";
    creditCard.holder = holder;
    
    MoIPFundingInstrument* fundingInstrument = [MoIPFundingInstrument new];
    fundingInstrument.method = MoIPFundingInstrumentMethodCreditCard;
    fundingInstrument.creditCard = creditCard;
    
    NSDictionary* fundingInstrumentRepresentation = [fundingInstrument dictionaryRepresentation];
    XCTAssertNotNil(fundingInstrumentRepresentation);
    
    XCTAssertTrue([fundingInstrumentRepresentation[@"method"]isEqualToString:@"CREDIT_CARD"]);
    XCTAssertNotNil(fundingInstrumentRepresentation[@"creditCard"]);
    
    MoIPFundingInstrument* fundingInstrument2 = [[MoIPFundingInstrument alloc]initWithDictionary:fundingInstrumentRepresentation];
    XCTAssertNotNil(fundingInstrument2.creditCard);
    XCTAssertTrue(fundingInstrument2.method == MoIPFundingInstrumentMethodCreditCard);

}


- (void) testMoIPOrderObject {
    MoIPOrder* order = [MoIPOrder new];
    order.ownId = @"pedido_xyz";
    
    MoIPItem* item = [MoIPItem new];
    item.product = @"Box de Seriado - Exterminate!";
    item.quantity = @1;
    item.detail = @"Box de seriado com 8 dvds";
    item.price = @73.50;
    order.items = @[item];
    
    MoIPCustomer* customer = [MoIPCustomer new];
    customer.ownId = @"cliente_xyz";
    customer.fullname = @"João Silva";
    customer.email = @"joaosilva@email.com";
    order.customer = customer;
    
    NSError* error = nil;
    BOOL isValid = [order validateValuesWithError:&error];
    XCTAssertTrue(isValid);
    XCTAssertNil(error);
    
    NSDictionary* dictionaryRepresentation = [order dictionaryRepresentation];
    XCTAssertNotNil(dictionaryRepresentation);
    
    NSDictionary* itemRepresentation = [dictionaryRepresentation[@"items"] firstObject];
    XCTAssertNotNil(itemRepresentation);
    XCTAssertTrue([itemRepresentation[@"price"] integerValue] == 7350);
    
    XCTAssertNotNil([order jsonData]);
}


- (void) testMoIPPaymentObject {
    MoIPHolder* holder = [MoIPHolder new];
    holder.fullname = @"João Portador da Silva";
    holder.birthdate = [NSDate date];
    holder.taxDocument = [MoIPTaxDocument new];
    holder.taxDocument.type = MoIPTaxDocumentTypeCPF;
    holder.taxDocument.number = @"12345679891";
    holder.phone = MoIPPhoneMake(55, 11, 66778899);
    
    [MoipSDK importPublicKey:self.moipPublicKey];
    
    MoIPCreditCard* creditCard = [MoIPCreditCard new];
    creditCard.expirationMonth = @"05";
    creditCard.expirationYear = @"2018";
    creditCard.number = @"5555666677778884";
    creditCard.cvc = @"123";
    creditCard.holder = holder;
    
    MoIPFundingInstrument* fundingInstrument = [MoIPFundingInstrument new];
    fundingInstrument.method = MoIPFundingInstrumentMethodCreditCard;
    fundingInstrument.creditCard = creditCard;
    
    MoIPPayment* payment = [MoIPPayment new];
    payment.installmentCount = @2;
    payment.fundingInstrument = fundingInstrument;
    
    NSError* error = nil;
    BOOL isValid = [payment validateValuesWithError:&error];
    XCTAssertTrue(isValid);
    XCTAssertNil(error);
    
    XCTAssertNotNil([payment dictionaryRepresentation]);
}


- (void) testMoIPCreditCardOperation {
    
    // Order
    
    MoIPItem* item = [MoIPItem new];
    item.product = @"Box de Seriado - Exterminate!";
    item.quantity = @1;
    item.detail = @"Box de seriado com 8 dvds";
    item.price = @7350;
    
    MoIPCustomer* customer = [MoIPCustomer new];
    customer.ownId = @"cliente_xyz";
    customer.fullname = @"João Silva";
    customer.email = @"joaosilva@email.com";
    
    MoIPOrder* order = [MoIPOrder new];
    order.ownId = @"pedido_xyz";
    order.customer = customer;
    order.items = @[item];
    
    
    // Payment
    
    MoIPHolder* holder = [MoIPHolder new];
    holder.fullname = @"João Portador da Silva";
    holder.birthdate = [NSDate date];
    holder.taxDocument = [MoIPTaxDocument new];
    holder.taxDocument.type = MoIPTaxDocumentTypeCPF;
    holder.taxDocument.number = @"12345679891";
    holder.phone = MoIPPhoneMake(55, 11, 66778899);
    
    [MoipSDK importPublicKey:self.moipPublicKey];
    
    MoIPCreditCard* creditCard = [MoIPCreditCard new];
    creditCard.expirationMonth = @"05";
    creditCard.expirationYear = @"2018";
    creditCard.number = @"5555666677778884";
    creditCard.cvc = @"123";
    creditCard.holder = holder;
    
    MoIPFundingInstrument* fundingInstrument = [MoIPFundingInstrument new];
    fundingInstrument.method = MoIPFundingInstrumentMethodCreditCard;
    fundingInstrument.creditCard = creditCard;
    
    MoIPPayment* payment = [MoIPPayment new];
    payment.installmentCount = @2;
    payment.fundingInstrument = fundingInstrument;
    
    MoipConnector* connector = [[MoipConnector alloc]
                                initWithEnviroment:MoIPEnvironmentSandBox
                                token:self.moipToken
                                accessKey:self.moipAccessKey
                                publicCertificate:self.moipPublicKey];
    
    XCTestExpectation* expectation = [self expectationWithDescription:@"Payment Expectation"];
        [connector executeOrder:order withPayment:payment completionhandler:^(MoIPOrder *orderAnswer, MoIPPayment *paymentAnwer, NSError *error) {
            XCTAssertNil(error);
            XCTAssertNotNil(orderAnswer);
            XCTAssertNotNil(paymentAnwer);
            [expectation fulfill];
        }];
    
        [self waitForExpectationsWithTimeout:30 handler:nil];
}


- (void) testMoIPCofreOperation {
    
    /*****
     1st Payment to enable us to ger the credit card ID from MoIP
     *****/
    
    
    // Order
    
    MoIPItem* item = [MoIPItem new];
    item.product = @"Box de Seriado - Exterminate!";
    item.quantity = @1;
    item.detail = @"Box de seriado com 8 dvds";
    item.price = @7350;
    
    MoIPCustomer* customer = [MoIPCustomer new];
    customer.ownId = @"OMNICHAT01CUST";
    customer.fullname = @"João Silva";
    customer.email = @"joaosilva@email.com";
    
    MoIPOrder* order = [MoIPOrder new];
    order.ownId = @"OMNICHAT01ORD";
    order.customer = customer;
    order.items = @[item];
    
    
    // Payment
    
    MoIPHolder* holder = [MoIPHolder new];
    holder.fullname = @"João Portador da Silva";
    holder.birthdate = [NSDate date];
    holder.taxDocument = [MoIPTaxDocument new];
    holder.taxDocument.type = MoIPTaxDocumentTypeCPF;
    holder.taxDocument.number = @"12345679891";
    holder.phone = MoIPPhoneMake(55, 11, 66778899);
    
    [MoipSDK importPublicKey:self.moipPublicKey];
    
    MoIPCreditCard* creditCard = [MoIPCreditCard new];
    creditCard.expirationMonth = @"05";
    creditCard.expirationYear = @"2018";
    creditCard.number = @"5555666677778884";
    creditCard.cvc = @"123";
    creditCard.holder = holder;
    
    MoIPFundingInstrument* fundingInstrument = [MoIPFundingInstrument new];
    fundingInstrument.method = MoIPFundingInstrumentMethodCreditCard;
    fundingInstrument.creditCard = creditCard;
    
    MoIPPayment* payment = [MoIPPayment new];
    payment.installmentCount = @2;
    payment.fundingInstrument = fundingInstrument;
    
    MoipConnector* connector = [[MoipConnector alloc]
                                initWithEnviroment:MoIPEnvironmentSandBox
                                token:self.moipToken
                                accessKey:self.moipAccessKey
                                publicCertificate:self.moipPublicKey];
    
    XCTestExpectation* expectation = [self expectationWithDescription:@"Payment Expectation"];
    __block NSString* creditCardObjectId;
    [connector executeOrder:order withPayment:payment completionhandler:^(MoIPOrder *orderAnswer, MoIPPayment *paymentAnwer, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(orderAnswer);
        XCTAssertNotNil(paymentAnwer);
        
        //Cofre
        creditCardObjectId = paymentAnwer.fundingInstrument.creditCard.objectId;
        XCTAssertNotNil(creditCardObjectId);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:nil];
    
    
    /*****
     2nd Payment using the last payment credit cart id - Cofre
     *****/
    
    // Order
    
    MoIPOrder* orderUsingCofre = [MoIPOrder new];
    orderUsingCofre.ownId = @"OMNICHAT01ORD_COFRE";
    orderUsingCofre.customer = customer;
    orderUsingCofre.items = @[item];
    
    // Payment
    
    MoIPCreditCard* creditCardFromCofre = [MoIPCreditCard new];
    creditCardFromCofre.objectId = creditCardObjectId;
    creditCardFromCofre.cvc = @"123";
    
    MoIPFundingInstrument* fundingInstrumentCofre = [MoIPFundingInstrument new];
    fundingInstrumentCofre.method = MoIPFundingInstrumentMethodCreditCard;
    fundingInstrumentCofre.creditCard = creditCardFromCofre;
    
    MoIPPayment* paymentFromCofre = [MoIPPayment new];
    paymentFromCofre.installmentCount = @1;
    paymentFromCofre.fundingInstrument = fundingInstrumentCofre;
    
    XCTestExpectation* expectation2 = [self expectationWithDescription:@"Payment Expectation"];
    [connector executeOrder:orderUsingCofre withPayment:paymentFromCofre completionhandler:^(MoIPOrder *orderAnswer, MoIPPayment *paymentAnwer, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(orderAnswer);
        XCTAssertNotNil(paymentAnwer);
        [expectation2 fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:nil];
}


- (void) testMoIPBoletoOperation {
    
    // Order
    
    MoIPItem* item = [MoIPItem new];
    item.product = @"Box de Seriado - Exterminate!";
    item.quantity = @1;
    item.detail = @"Box de seriado com 8 dvds";
    item.price = @7300;
    
    MoIPCustomer* customer = [MoIPCustomer new];
    customer.ownId = @"cliente_xyz";
    customer.fullname = @"João Silva";
    customer.email = @"joaosilva@email.com";
    
    MoIPOrder* order = [MoIPOrder new];
    order.ownId = @"pedido_xyz";
    order.customer = customer;
    order.items = @[item];
    
    
    // Payment
    
    MoIPBoleto* boleto = [MoIPBoleto new];
    boleto.firstInstructionLine = @"1st line";
    boleto.secondInstructionLine = @"2nd line";
    boleto.thirdInstructionLine = @"3rd line";
    boleto.expirationDate = [NSDate date];
    
    MoIPFundingInstrument* fundingInstrument = [MoIPFundingInstrument new];
    fundingInstrument.method = MoIPFundingInstrumentMethodBoleto;
    fundingInstrument.boleto = boleto;
    
    MoIPPayment* payment = [MoIPPayment new];
    payment.fundingInstrument = fundingInstrument;
    
    MoipConnector* connector = [[MoipConnector alloc]
                                initWithEnviroment:MoIPEnvironmentSandBox
                                token:self.moipToken
                                accessKey:self.moipAccessKey
                                publicCertificate:self.moipPublicKey];
    
    XCTestExpectation* expectation = [self expectationWithDescription:@"Payment Expectation"];
    [connector executeOrder:order withPayment:payment completionhandler:^(MoIPOrder *orderAnswer, MoIPPayment *paymentAnwer, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(orderAnswer);
        XCTAssertNotNil(paymentAnwer);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:nil];
}


@end
