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
