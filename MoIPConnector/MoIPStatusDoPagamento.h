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

typedef NS_ENUM(NSInteger, MoIPStatusPagamento) {
    MoIPStatusPagamentoSucesso,
    MoIPStatusPagamentoFalha,
    
    MoIPStatusPagamentoNaoInformado = 999 //Caso não seja informado na resposta do MoIP
    
};

typedef NS_ENUM(NSInteger, MoIPStatus) {
    MoIPStatusEmAnalise,
    MoIPStatusAutorizado,
    MoIPStatusIniciado,
    MoIPStatusCancelado,
    
    MoIPStatusNaoInformado = 999 //Caso não seja informado na resposta do MoIP
};

@interface MoIPStatusDoPagamento : NSObject

/// Status de processamento da requisição de pagamento
@property (nonatomic, assign, readonly) MoIPStatusPagamento statusDoPagamento;

/// Status do pagamento no Moip.
@property (nonatomic, assign, readonly) MoIPStatus status;

/// Código identificador da transação Moip
@property (nonatomic, strong, readonly) NSString* codigoMoIP;

/// Código de identificação da classificação Moip
@property (nonatomic, assign, readonly) NSNumber* codigo;

/// Mensagem descritiva sobre o processamento da transação
@property (nonatomic, strong, readonly) NSString* menssagem;

/// Taxa Moip cobrada pela prestação de serviço
@property (nonatomic, strong, readonly) NSNumber* taxaMoIP;

/// Valor total pago pelo cliente
@property (nonatomic, strong, readonly) NSNumber* totalPago;

/// Motivo de cancelamento de um pagamento
@property (nonatomic, strong, readonly) NSDictionary* classificacao;


- (instancetype) initWithDictionary:(NSDictionary*) dictionary;

@end
