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

#import <Foundation/Foundation.h>

@class MoIPCartaoDeCredito;

typedef NS_ENUM(NSInteger, MoIPFormaDePagamento) {
    MoIPFormaDePagamentoCartaoDeCredito = 1,
    MoIPFormaDePagamentoDebitoBancario,
    MoIPFormaDePagamentoBoletoBancario
};

typedef NS_ENUM(NSInteger, MoIPInstituicaoDePagamento) {
    //Validos com Cartão de Crédito (MoIPFormaDePagamentoCartaoDeCredito)
    MoIPInstituicaoDePagamentoVisa = 1,
    MoIPInstituicaoDePagamentoDiners,
    MoIPInstituicaoDePagamentoMasterCard,
    MoIPInstituicaoDePagamentoHiperCard,
    MoIPInstituicaoDePagamentoHiper,
    MoIPInstituicaoDePagamentoElo,
    MoIPInstituicaoDePagamentoAmericanExpress,
    
    // //Validos com Debito Bancario (MoIPFormaDePagamentoDebitoBancario)
    MoIPInstituicaoDePagamentoBancoDoBrasil = 100,
    MoIPInstituicaoDePagamentoBradesco,
    MoIPInstituicaoDePagamentoBanrisul,
    MoIPInstituicaoDePagamentoItau,
};


@interface MoIPMetodoDePagamento : NSObject

- (instancetype) initWithFormaDePagamento:(MoIPFormaDePagamento) formaDePagamento;

/// Definição da forma de pagamento a ser utilizada na instrução.
@property (nonatomic, readonly) MoIPFormaDePagamento formaDePagamento;

/// Definição da instituição de pagamento a ser utilizado
@property (nonatomic, assign) MoIPInstituicaoDePagamento instituicaoDePagamento;

/// Quantidade de parcelas em que o pagamento será efetuado. Default é 1
@property (nonatomic, assign) NSInteger parcelas;

/// Objeto de definição de dados do cartão de crédito a ser transacionado.
@property (nonatomic, strong) MoIPCartaoDeCredito* cartaoDeCredito;


/**
 Validades all fields against MoIP definitions: https://labs.moip.com.br/parametro/javascript-de-pagamento/
 
*/
- (BOOL) validateValuesWithError:(NSError**) error;


/**
 Representation ready to be serialised and sent to MoIP
 
 */
- (NSDictionary*) dictionaryRepresentation;

@end
