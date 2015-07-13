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

@interface MoIPPortadorDoCartao : NSObject

/// Nome do portador do cartão de crédito, idêntico ao nome exibido no cartão.
@property (nonatomic, strong) NSString* nome;

/// Data de nascimento do portador do cartão de crédito.
@property (nonatomic, strong) NSDate* dataDeNascimento;

/// Telefone de contato do portador do cartão. Essa informação é muito importante para análise de risco.
@property (nonatomic, strong) NSString* telefone;

/// Identidade CPF do titular do cartão de crédito, essa informação é muito importante para análise de risco.
@property (nonatomic, strong) NSString* identidade;

/**
 Validades all fields against MoIP definitions: https://labs.moip.com.br/parametro/javascript-de-pagamento/
 
 */
- (BOOL) validateValuesWithError:(NSError**) error;


/**
 Representation ready to be serialised and sent to MoIP
 
 */
- (NSDictionary*) dictionaryRepresentation;

@end
