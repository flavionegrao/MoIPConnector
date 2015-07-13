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

@class MoIPPortadorDoCartao;

@interface MoIPCartaoDeCredito : NSObject

@property (nonatomic, assign) NSString* numero;
@property (nonatomic, assign) NSInteger expiracaoMes;
@property (nonatomic, assign) NSInteger expiracaoAno;
@property (nonatomic, assign) NSString* codigoDeSeguranca;
@property (nonatomic, strong) MoIPPortadorDoCartao* portadorDoCartao;


/**
 Validades all fields against MoIP definitions: https://labs.moip.com.br/parametro/javascript-de-pagamento/
 
 */
- (BOOL) validateValuesWithError:(NSError**) error;


/**
 Representation ready to be serialised and sent to MoIP
 
 */
- (NSDictionary*) dictionaryRepresentation;

@end
