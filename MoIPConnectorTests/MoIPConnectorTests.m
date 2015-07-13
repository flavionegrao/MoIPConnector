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

#import "MoIPInfoDePagamento.h"
#import "MoIPMetodoDePagamento.h"
#import "MoIPCartaoDeCredito.h"
#import "MoIPPortadorDoCartao.h"
#import "MoipConnector.h"
#import "MoIPStatusDoPagamento.h"

// Pegue o token e access key na sua conta MoIP -> Ferramentas -> API MoIP -> Chaves de Acesso
static NSString* const myMoipToken =  @"";
static NSString* const myMoipAccessKey =  @"";

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


- (void) testValidInformacaoDePagamento {
    MoIPInfoDePagamento* infoDePagamento = [MoIPInfoDePagamento new];
    infoDePagamento.razao = @"Compra na loja XPTO";
    infoDePagamento.valor = @12.40;
    infoDePagamento.idProprio = @"ABC123";
    infoDePagamento.idPagador = @"XYZ123";
    infoDePagamento.nome = @"João da Silva";
    infoDePagamento.email = @"joao@dasila.com";
    infoDePagamento.logradouro = @"Rua Marechal Deodoro";
    infoDePagamento.numero = @"123";
    infoDePagamento.complemento = @"ap 254";
    infoDePagamento.bairro = @"Agua Verde";
    infoDePagamento.cidade = @"Curitiba";
    infoDePagamento.estado = @"PR";
    infoDePagamento.pais = @"BRA";
    infoDePagamento.cep = @"80710000";
    infoDePagamento.telefoneFixo = @"4133333333";
    
    NSError* error = nil;
    BOOL isValid = [infoDePagamento validateValuesWithError:&error];
    XCTAssertTrue(isValid);
    XCTAssertNil(error);
    
    NSString* infoDePagamentoRepresentation = [infoDePagamento XMLRepresentation];
    XCTAssertNotNil(infoDePagamentoRepresentation);
    XCTAssert([infoDePagamentoRepresentation rangeOfString:@"(null)"].location == NSNotFound,@"Can't have nil values");
}

- (void) testInValidInformacaoDePagamentoNilField {
    MoIPInfoDePagamento* infoDePagamento = [MoIPInfoDePagamento new];
    infoDePagamento.razao = @"Compra na loja XPTO";
    infoDePagamento.valor = @12.40;
    infoDePagamento.idProprio = @"ABC123";
    infoDePagamento.idPagador = @"XYZ123";
    infoDePagamento.nome = @"João da Silva";
    infoDePagamento.email = @"joao@dasila.com";
    infoDePagamento.logradouro = @"Rua Marechal Deodoro";
    infoDePagamento.numero = @"123";
    infoDePagamento.complemento = nil;
    infoDePagamento.bairro = @"Agua Verde";
    infoDePagamento.cidade = @"Curitiba";
    infoDePagamento.estado = nil;
    infoDePagamento.pais = @"Brazil";
    infoDePagamento.cep = @"80710000";
    infoDePagamento.telefoneFixo = @"4133333333";
    
    
    NSError* error = nil;
    BOOL isValid = [infoDePagamento validateValuesWithError:&error];
    XCTAssertFalse(isValid);
    XCTAssertNotNil(error);
}


- (void) testPortadorDoCartao {
    MoIPPortadorDoCartao* portador = [MoIPPortadorDoCartao new];
    portador.nome = @"João da Silva";
    portador.dataDeNascimento = [NSDate date];
    portador.telefone = @"4199992233";
    portador.identidade = @"61200729";
    
    NSError* error = nil;
    BOOL isValid = [portador validateValuesWithError:&error];
    XCTAssertTrue(isValid);
    XCTAssertNil(error);
    
    NSDictionary* metodoDePagamentoRepresentation = [portador dictionaryRepresentation];
    XCTAssertNotNil(metodoDePagamentoRepresentation);
}

- (void) testMetodoDePagamentoBoleto {
    MoIPMetodoDePagamento* metodoDePagamento = [[MoIPMetodoDePagamento alloc]initWithFormaDePagamento:MoIPFormaDePagamentoBoletoBancario];
    
    NSError* error = nil;
    BOOL isValid = [metodoDePagamento validateValuesWithError:&error];
    XCTAssertTrue(isValid);
    XCTAssertNil(error);
    
    NSDictionary* metodoDePagamentoRepresentation = [metodoDePagamento dictionaryRepresentation];
    XCTAssertNotNil(metodoDePagamentoRepresentation);
}


- (void) testMetodoDePagamentoDebitoBancario {
    MoIPMetodoDePagamento* metodoDePagamento = [[MoIPMetodoDePagamento alloc]initWithFormaDePagamento:MoIPFormaDePagamentoDebitoBancario];
    metodoDePagamento.instituicaoDePagamento = MoIPInstituicaoDePagamentoBancoDoBrasil;
        
    NSError* error = nil;
    BOOL isValid = [metodoDePagamento validateValuesWithError:&error];
    XCTAssertTrue(isValid);
    XCTAssertNil(error);
    
    NSDictionary* metodoDePagamentoRepresentation = [metodoDePagamento dictionaryRepresentation];
    XCTAssertNotNil(metodoDePagamentoRepresentation);
}


- (void) testMetodoDePagamentoCartaoDeCredito {
    MoIPMetodoDePagamento* metodoDePagamento = [[MoIPMetodoDePagamento alloc]initWithFormaDePagamento:MoIPFormaDePagamentoCartaoDeCredito];
    metodoDePagamento.instituicaoDePagamento = MoIPInstituicaoDePagamentoVisa;
    metodoDePagamento.parcelas = 1;
    
    MoIPCartaoDeCredito* cartaoDeCredito = [MoIPCartaoDeCredito new];
    cartaoDeCredito.numero = @"4444555566667777";
    cartaoDeCredito.expiracaoMes = 10;
    cartaoDeCredito.expiracaoAno = 2017;
    cartaoDeCredito.codigoDeSeguranca = @"123";
    
    MoIPPortadorDoCartao* portador = [MoIPPortadorDoCartao new];
    portador.nome = @"João da Silva";
    portador.dataDeNascimento = [NSDate date];
    portador.telefone = @"4199992233";
    portador.identidade = @"61200729";
    
    cartaoDeCredito.portadorDoCartao = portador;
    metodoDePagamento.cartaoDeCredito = cartaoDeCredito;
    
    NSError* error = nil;
    BOOL isValid = [metodoDePagamento validateValuesWithError:&error];
    XCTAssertTrue(isValid);
    XCTAssertNil(error);
    
    NSDictionary* metodoDePagamentoRepresentation = [metodoDePagamento dictionaryRepresentation];
    XCTAssertNotNil(metodoDePagamentoRepresentation);
}


- (void) testConnectorWithBoleto {
    MoipConnector* connector = [[MoipConnector alloc]initWithEnviroment:MoIPEnvironmentSandBox token:myMoipToken accessKey:myMoipAccessKey];
    
    MoIPInfoDePagamento* infoDePagamento = [MoIPInfoDePagamento new];
    infoDePagamento.razao = @"Compra na loja XPTO";
    infoDePagamento.valor = @12.40;
    infoDePagamento.idProprio = [[NSUUID UUID]UUIDString];
    infoDePagamento.idPagador = @"XYZ123";
    infoDePagamento.nome = @"João da Silva";
    infoDePagamento.email = @"joao@dasila.com";
    infoDePagamento.logradouro = @"Rua Marechal Deodoro";
    infoDePagamento.numero = @"123";
    infoDePagamento.complemento = nil;
    infoDePagamento.bairro = @"Agua Verde";
    infoDePagamento.cidade = @"Curitiba";
    infoDePagamento.estado = @"PR";
    infoDePagamento.pais = @"BRA";
    infoDePagamento.cep = @"80710000";
    infoDePagamento.telefoneFixo = @"4133333333";
    
    MoIPMetodoDePagamento* metodoDePagamentoBoleto = [[MoIPMetodoDePagamento alloc]initWithFormaDePagamento:MoIPFormaDePagamentoBoletoBancario];
    
    XCTestExpectation* expectation = [self expectationWithDescription:@"Payment Expectation"];
    [connector executePaymentWithPaymenInfo:infoDePagamento paymentMethod:metodoDePagamentoBoleto completion:^(MoIPStatusDoPagamento *statusDoPagamento, NSError *error) {
        XCTAssert(statusDoPagamento.statusDoPagamento == MoIPStatusPagamentoSucesso);
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:nil];
}


- (void) testConnectorWithDebitoEmConta {
    MoipConnector* connector = [[MoipConnector alloc]initWithEnviroment:MoIPEnvironmentSandBox token:myMoipToken accessKey:myMoipAccessKey];
    
    MoIPInfoDePagamento* infoDePagamento = [MoIPInfoDePagamento new];
    infoDePagamento.razao = @"Compra na loja XPTO";
    infoDePagamento.valor = @12.40;
    infoDePagamento.idProprio = [[NSUUID UUID]UUIDString];
    infoDePagamento.idPagador = @"XYZ123";
    infoDePagamento.nome = @"João da Silva";
    infoDePagamento.email = @"joao@dasila.com";
    infoDePagamento.logradouro = @"Rua Marechal Deodoro";
    infoDePagamento.numero = @"123";
    infoDePagamento.complemento = nil;
    infoDePagamento.bairro = @"Agua Verde";
    infoDePagamento.cidade = @"Curitiba";
    infoDePagamento.estado = @"PR";
    infoDePagamento.pais = @"BRA";
    infoDePagamento.cep = @"80710000";
    infoDePagamento.telefoneFixo = @"4133333333";
    
    MoIPMetodoDePagamento* metodoDePagamento = [[MoIPMetodoDePagamento alloc]initWithFormaDePagamento:MoIPFormaDePagamentoDebitoBancario];
    metodoDePagamento.instituicaoDePagamento = MoIPInstituicaoDePagamentoBancoDoBrasil;

    
    XCTestExpectation* expectation = [self expectationWithDescription:@"Payment Expectation"];
    [connector executePaymentWithPaymenInfo:infoDePagamento paymentMethod:metodoDePagamento completion:^(MoIPStatusDoPagamento *statusDoPagamento, NSError *error) {
        XCTAssert(statusDoPagamento.statusDoPagamento == MoIPStatusPagamentoSucesso);
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:nil];
}


- (void) testConnectorWithCartaoDeCredito {
    MoipConnector* connector = [[MoipConnector alloc]initWithEnviroment:MoIPEnvironmentSandBox token:myMoipToken accessKey:myMoipAccessKey];
    
    MoIPInfoDePagamento* infoDePagamento = [MoIPInfoDePagamento new];
    infoDePagamento.razao = @"Compra na loja XPTO via OmniChat";
    infoDePagamento.valor = @12.40;
    infoDePagamento.idProprio = [[NSUUID UUID]UUIDString];
    infoDePagamento.idPagador = @"XYZ123";
    infoDePagamento.nome = @"João da Silva";
    infoDePagamento.email = @"joao@dasila.com";
    infoDePagamento.logradouro = @"Rua Marechal Deodoro";
    infoDePagamento.numero = @"123";
    infoDePagamento.complemento = nil;
    infoDePagamento.bairro = @"Agua Verde";
    infoDePagamento.cidade = @"Curitiba";
    infoDePagamento.estado = @"PR";
    infoDePagamento.pais = @"BRA";
    infoDePagamento.cep = @"80710000";
    infoDePagamento.telefoneFixo = @"4133333333";
    
    MoIPMetodoDePagamento* metodoDePagamento = [[MoIPMetodoDePagamento alloc]initWithFormaDePagamento:MoIPFormaDePagamentoCartaoDeCredito];
    metodoDePagamento.instituicaoDePagamento = MoIPInstituicaoDePagamentoVisa;
    metodoDePagamento.parcelas = 1;
    
    MoIPCartaoDeCredito* cartaoDeCredito = [MoIPCartaoDeCredito new];
    cartaoDeCredito.numero = @"4444555566667777";
    cartaoDeCredito.expiracaoMes = 10;
    cartaoDeCredito.expiracaoAno = 2017;
    cartaoDeCredito.codigoDeSeguranca = @"123";
    
    MoIPPortadorDoCartao* portador = [MoIPPortadorDoCartao new];
    portador.nome = @"João da Silva";
    portador.dataDeNascimento = [NSDate date];
    portador.telefone = @"4199992233";
    portador.identidade = @"61200729";
    
    cartaoDeCredito.portadorDoCartao = portador;
    metodoDePagamento.cartaoDeCredito = cartaoDeCredito;
    
    
    XCTestExpectation* expectation = [self expectationWithDescription:@"Payment Expectation"];
    [connector executePaymentWithPaymenInfo:infoDePagamento paymentMethod:metodoDePagamento completion:^(MoIPStatusDoPagamento *statusDoPagamento, NSError *error) {
        XCTAssert(statusDoPagamento.statusDoPagamento == MoIPStatusPagamentoSucesso);
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:nil];
}


@end
