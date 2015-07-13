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

@interface MoIPInfoDePagamento : NSObject

@property (nonatomic, copy) NSString* razao;
@property (nonatomic, copy) NSNumber* valor;

/// Dever ser único, não pode repetir para transações diferentes
@property (nonatomic, copy) NSString* idProprio;

@property (nonatomic, copy) NSString* nome;
@property (nonatomic, copy) NSString* email;
@property (nonatomic, copy) NSString* idPagador;
@property (nonatomic, copy) NSString* logradouro;
@property (nonatomic, copy) NSString* numero;
@property (nonatomic, copy) NSString* complemento;
@property (nonatomic, copy) NSString* bairro;
@property (nonatomic, copy) NSString* cidade;
@property (nonatomic, copy) NSString* estado;
@property (nonatomic, copy) NSString* pais;
@property (nonatomic, copy) NSString* cep;
@property (nonatomic, copy) NSString* telefoneFixo;

/**
 Validades all fields against MoIP definitions: https://labs.moip.com.br/parametro/javascript-de-pagamento/
 */
- (BOOL) validateValuesWithError:(NSError**) error;


/**
 Representation ready to be serialised and sent to MoIP
 
 */
- (NSString*) XMLRepresentation;

@end
