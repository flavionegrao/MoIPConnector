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



// Pegue o token e access key na sua conta MoIP -> Ferramentas -> API MoIP -> Chaves de Acesso
static NSString* const myMoipToken =  @"7HE7GESKFPYI7AWSKVOJOUQPYKZEL25C";
static NSString* const myMoipAccessKey =  @"F815D2Y8NWRBNUCUKHNIAJIDABV7KIL0QT91EMXU";

@interface MoIPConnectorTests : XCTestCase

@end

@implementation MoIPConnectorTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void) testTokenAndAccessKey {
    XCTAssertTrue(myMoipToken.length > 0);
    XCTAssertTrue(myMoipAccessKey.length > 0);
}


- (void) testMoIPOrderObject {
    MoIPOrder* order = [MoIPOrder new];
    order.ownId = @"pedido_xyz";
    
    MoIPItem* item = [MoIPItem new];
    item.product = @"Box de Seriado - Exterminate!";
    item.quantity = @1;
    item.detail = @"Box de seriado com 8 dvds";
    item.price = @7300;
    order.items = @[item];
    
    MoIPCustomer* customer = [MoIPCustomer new];
    customer.ownId = @"cliente_xyz";
    customer.fullName = @"João Silva";
    customer.email = @"joaosilva@email.com";
    order.customer = customer;
    
    NSError* error = nil;
    BOOL isValid = [order validateValuesWithError:&error];
    XCTAssertTrue(isValid);
    XCTAssertNil(error);
    
    XCTAssertNotNil([order dictionaryRepresentation]);
}

- (void) testMoIPPaymentObject {
    MoIPHolder* holder = [MoIPHolder new];
    holder.fullname = @"João Portador da Silva";
    holder.birthdate = [NSDate date];
    holder.taxDocument = [MoIPTaxDocument new];
    holder.taxDocument.type = MoIPTaxDocumentTypeCPF;
    holder.taxDocument.number = @"12345679891";
    holder.phone = MoIPPhoneMake(55, 11, 66778899);
    
    [MoipSDK importPublicKey:[self importPublicKey]];
    
    MoIPCreditCard* creditCard = [MoIPCreditCard new];
    creditCard.expirationMonth = @"05";
    creditCard.expirationYear = @"2018";
    creditCard.number = @"5555666677778884";
    creditCard.cvc = @"123";
    creditCard.holder = holder;
    
    MoIPFundingInstrument* fundingInstrument = [MoIPFundingInstrument new];
    fundingInstrument.method = @"CREDIT_CARD";
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
    item.price = @7300;
    
    MoIPCustomer* customer = [MoIPCustomer new];
    customer.ownId = @"cliente_xyz";
    customer.fullName = @"João Silva";
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
    
    [MoipSDK importPublicKey:[self importPublicKey]];
    
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
    
    MoipConnector* connector = [[MoipConnector alloc]initWithEnviroment:MoIPEnvironmentSandBox token:myMoipToken accessKey:myMoipAccessKey publicCertificate:[self importPublicKey]];
    
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
    customer.fullName = @"João Silva";
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
    
    MoipConnector* connector = [[MoipConnector alloc]initWithEnviroment:MoIPEnvironmentSandBox token:myMoipToken accessKey:myMoipAccessKey publicCertificate:[self importPublicKey]];
    
    XCTestExpectation* expectation = [self expectationWithDescription:@"Payment Expectation"];
    [connector executeOrder:order withPayment:payment completionhandler:^(MoIPOrder *orderAnswer, MoIPPayment *paymentAnwer, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(orderAnswer);
        XCTAssertNotNil(paymentAnwer);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:nil];
}


#pragma mark - Helpers

- (NSString*) importPublicKey {
    NSString* path = [[NSBundle bundleForClass:[self class]] pathForResource:@"myPublicKey"
                                                     ofType:@"txt"];
    
    NSError* error;
    NSString *myPublicKey = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    
    if (!error) {
        return myPublicKey;
    } else {
        NSLog(@"Error: %@", error);
        return nil;
    }
}


#pragma mark - Old Tests - need to change them to v2.

//- (void) testInValidInformacaoDePagamentoNilField {
//    MoIPInfoDePagamento* infoDePagamento = [MoIPInfoDePagamento new];
//    infoDePagamento.razao = @"Compra na loja XPTO";
//    infoDePagamento.valor = @12.40;
//    infoDePagamento.idProprio = @"ABC123";
//    infoDePagamento.idPagador = @"XYZ123";
//    infoDePagamento.nome = @"João da Silva";
//    infoDePagamento.email = @"joao@dasila.com";
//    infoDePagamento.logradouro = @"Rua Marechal Deodoro";
//    infoDePagamento.numero = @"123";
//    infoDePagamento.complemento = nil;
//    infoDePagamento.bairro = @"Agua Verde";
//    infoDePagamento.cidade = @"Curitiba";
//    infoDePagamento.estado = nil;
//    infoDePagamento.pais = @"Brazil";
//    infoDePagamento.cep = @"80710000";
//    infoDePagamento.telefoneFixo = @"4133333333";
//    
//    
//    NSError* error = nil;
//    BOOL isValid = [infoDePagamento validateValuesWithError:&error];
//    XCTAssertFalse(isValid);
//    XCTAssertNotNil(error);
//}
//
//
//- (void) testPortadorDoCartao {
//    MoIPPortadorDoCartao* portador = [MoIPPortadorDoCartao new];
//    portador.nome = @"João da Silva";
//    portador.dataDeNascimento = [NSDate date];
//    portador.telefone = @"4199992233";
//    portador.identidade = @"61200729";
//    
//    NSError* error = nil;
//    BOOL isValid = [portador validateValuesWithError:&error];
//    XCTAssertTrue(isValid);
//    XCTAssertNil(error);
//    
//    NSDictionary* metodoDePagamentoRepresentation = [portador dictionaryRepresentation];
//    XCTAssertNotNil(metodoDePagamentoRepresentation);
//}
//
//- (void) testMetodoDePagamentoBoleto {
//    MoIPMetodoDePagamento* metodoDePagamento = [[MoIPMetodoDePagamento alloc]initWithFormaDePagamento:MoIPFormaDePagamentoBoletoBancario];
//    
//    NSError* error = nil;
//    BOOL isValid = [metodoDePagamento validateValuesWithError:&error];
//    XCTAssertTrue(isValid);
//    XCTAssertNil(error);
//    
//    NSDictionary* metodoDePagamentoRepresentation = [metodoDePagamento dictionaryRepresentation];
//    XCTAssertNotNil(metodoDePagamentoRepresentation);
//}
//
//
//- (void) testMetodoDePagamentoDebitoBancario {
//    MoIPMetodoDePagamento* metodoDePagamento = [[MoIPMetodoDePagamento alloc]initWithFormaDePagamento:MoIPFormaDePagamentoDebitoBancario];
//    metodoDePagamento.instituicaoDePagamento = MoIPInstituicaoDePagamentoBancoDoBrasil;
//        
//    NSError* error = nil;
//    BOOL isValid = [metodoDePagamento validateValuesWithError:&error];
//    XCTAssertTrue(isValid);
//    XCTAssertNil(error);
//    
//    NSDictionary* metodoDePagamentoRepresentation = [metodoDePagamento dictionaryRepresentation];
//    XCTAssertNotNil(metodoDePagamentoRepresentation);
//}
//
//
//- (void) testMetodoDePagamentoCartaoDeCredito {
//    MoIPMetodoDePagamento* metodoDePagamento = [[MoIPMetodoDePagamento alloc]initWithFormaDePagamento:MoIPFormaDePagamentoCartaoDeCredito];
//    metodoDePagamento.instituicaoDePagamento = MoIPInstituicaoDePagamentoVisa;
//    metodoDePagamento.parcelas = 1;
//    
//    MoIPCartaoDeCredito* cartaoDeCredito = [MoIPCartaoDeCredito new];
//    cartaoDeCredito.numero = @"4444555566667777";
//    cartaoDeCredito.expiracaoMes = 10;
//    cartaoDeCredito.expiracaoAno = 2017;
//    cartaoDeCredito.codigoDeSeguranca = @"123";
//    
//    MoIPPortadorDoCartao* portador = [MoIPPortadorDoCartao new];
//    portador.nome = @"João da Silva";
//    portador.dataDeNascimento = [NSDate date];
//    portador.telefone = @"4199992233";
//    portador.identidade = @"61200729";
//    
//    cartaoDeCredito.portadorDoCartao = portador;
//    metodoDePagamento.cartaoDeCredito = cartaoDeCredito;
//    
//    NSError* error = nil;
//    BOOL isValid = [metodoDePagamento validateValuesWithError:&error];
//    XCTAssertTrue(isValid);
//    XCTAssertNil(error);
//    
//    NSDictionary* metodoDePagamentoRepresentation = [metodoDePagamento dictionaryRepresentation];
//    XCTAssertNotNil(metodoDePagamentoRepresentation);
//}
//
//
//- (void) testConnectorWithBoleto {
//    MoipConnector* connector = [[MoipConnector alloc]initWithEnviroment:MoIPEnvironmentSandBox token:myMoipToken accessKey:myMoipAccessKey];
//    
//    MoIPInfoDePagamento* infoDePagamento = [MoIPInfoDePagamento new];
//    infoDePagamento.razao = @"Compra na loja XPTO";
//    infoDePagamento.valor = @12.40;
//    infoDePagamento.idProprio = [[NSUUID UUID]UUIDString];
//    infoDePagamento.idPagador = @"XYZ123";
//    infoDePagamento.nome = @"João da Silva";
//    infoDePagamento.email = @"joao@dasila.com";
//    infoDePagamento.logradouro = @"Rua Marechal Deodoro";
//    infoDePagamento.numero = @"123";
//    infoDePagamento.complemento = nil;
//    infoDePagamento.bairro = @"Agua Verde";
//    infoDePagamento.cidade = @"Curitiba";
//    infoDePagamento.estado = @"PR";
//    infoDePagamento.pais = @"BRA";
//    infoDePagamento.cep = @"80710000";
//    infoDePagamento.telefoneFixo = @"4133333333";
//    
//    MoIPMetodoDePagamento* metodoDePagamentoBoleto = [[MoIPMetodoDePagamento alloc]initWithFormaDePagamento:MoIPFormaDePagamentoBoletoBancario];
//    
//    XCTestExpectation* expectation = [self expectationWithDescription:@"Payment Expectation"];
//    [connector executePaymentWithPaymenInfo:infoDePagamento paymentMethod:metodoDePagamentoBoleto completion:^(MoIPStatusDoPagamento *statusDoPagamento, NSError *error) {
//        XCTAssert(statusDoPagamento.statusDoPagamento == MoIPStatusPagamentoSucesso);
//        XCTAssertNil(error);
//        [expectation fulfill];
//    }];
//    
//    [self waitForExpectationsWithTimeout:30 handler:nil];
//}
//
//
//- (void) testConnectorWithDebitoEmConta {
//    MoipConnector* connector = [[MoipConnector alloc]initWithEnviroment:MoIPEnvironmentSandBox token:myMoipToken accessKey:myMoipAccessKey];
//    
//    MoIPInfoDePagamento* infoDePagamento = [MoIPInfoDePagamento new];
//    infoDePagamento.razao = @"Compra na loja XPTO";
//    infoDePagamento.valor = @12.40;
//    infoDePagamento.idProprio = [[NSUUID UUID]UUIDString];
//    infoDePagamento.idPagador = @"XYZ123";
//    infoDePagamento.nome = @"João da Silva";
//    infoDePagamento.email = @"joao@dasila.com";
//    infoDePagamento.logradouro = @"Rua Marechal Deodoro";
//    infoDePagamento.numero = @"123";
//    infoDePagamento.complemento = nil;
//    infoDePagamento.bairro = @"Agua Verde";
//    infoDePagamento.cidade = @"Curitiba";
//    infoDePagamento.estado = @"PR";
//    infoDePagamento.pais = @"BRA";
//    infoDePagamento.cep = @"80710000";
//    infoDePagamento.telefoneFixo = @"4133333333";
//    
//    MoIPMetodoDePagamento* metodoDePagamento = [[MoIPMetodoDePagamento alloc]initWithFormaDePagamento:MoIPFormaDePagamentoDebitoBancario];
//    metodoDePagamento.instituicaoDePagamento = MoIPInstituicaoDePagamentoBancoDoBrasil;
//
//    
//    XCTestExpectation* expectation = [self expectationWithDescription:@"Payment Expectation"];
//    [connector executePaymentWithPaymenInfo:infoDePagamento paymentMethod:metodoDePagamento completion:^(MoIPStatusDoPagamento *statusDoPagamento, NSError *error) {
//        XCTAssert(statusDoPagamento.statusDoPagamento == MoIPStatusPagamentoSucesso);
//        XCTAssertNil(error);
//        [expectation fulfill];
//    }];
//    
//    [self waitForExpectationsWithTimeout:30 handler:nil];
//}
//
//
//- (void) testConnectorWithCartaoDeCredito {
//    MoipConnector* connector = [[MoipConnector alloc]initWithEnviroment:MoIPEnvironmentSandBox token:myMoipToken accessKey:myMoipAccessKey];
//    
//    MoIPInfoDePagamento* infoDePagamento = [MoIPInfoDePagamento new];
//    infoDePagamento.razao = @"Compra na loja XPTO via OmniChat";
//    infoDePagamento.valor = @12.40;
//    infoDePagamento.idProprio = [[NSUUID UUID]UUIDString];
//    infoDePagamento.idPagador = @"XYZ123";
//    infoDePagamento.nome = @"João da Silva";
//    infoDePagamento.email = @"joao@dasila.com";
//    infoDePagamento.logradouro = @"Rua Marechal Deodoro";
//    infoDePagamento.numero = @"123";
//    infoDePagamento.complemento = nil;
//    infoDePagamento.bairro = @"Agua Verde";
//    infoDePagamento.cidade = @"Curitiba";
//    infoDePagamento.estado = @"PR";
//    infoDePagamento.pais = @"BRA";
//    infoDePagamento.cep = @"80710000";
//    infoDePagamento.telefoneFixo = @"4133333333";
//    
//    MoIPMetodoDePagamento* metodoDePagamento = [[MoIPMetodoDePagamento alloc]initWithFormaDePagamento:MoIPFormaDePagamentoCartaoDeCredito];
//    metodoDePagamento.instituicaoDePagamento = MoIPInstituicaoDePagamentoVisa;
//    metodoDePagamento.parcelas = 1;
//    
//    MoIPCartaoDeCredito* cartaoDeCredito = [MoIPCartaoDeCredito new];
//    cartaoDeCredito.numero = @"4444555566667777";
//    cartaoDeCredito.expiracaoMes = 10;
//    cartaoDeCredito.expiracaoAno = 2017;
//    cartaoDeCredito.codigoDeSeguranca = @"123";
//    
//    MoIPPortadorDoCartao* portador = [MoIPPortadorDoCartao new];
//    portador.nome = @"João da Silva";
//    portador.dataDeNascimento = [NSDate date];
//    portador.telefone = @"4199992233";
//    portador.identidade = @"61200729";
//    
//    cartaoDeCredito.portadorDoCartao = portador;
//    metodoDePagamento.cartaoDeCredito = cartaoDeCredito;
//    
//    
//    XCTestExpectation* expectation = [self expectationWithDescription:@"Payment Expectation"];
//    [connector executePaymentWithPaymenInfo:infoDePagamento paymentMethod:metodoDePagamento completion:^(MoIPStatusDoPagamento *statusDoPagamento, NSError *error) {
//        XCTAssert(statusDoPagamento.statusDoPagamento == MoIPStatusPagamentoSucesso);
//        XCTAssertNil(error);
//        [expectation fulfill];
//    }];
//    
//    [self waitForExpectationsWithTimeout:30 handler:nil];
//}


@end
