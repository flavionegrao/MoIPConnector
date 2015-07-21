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

#import "MoIPCartaoDeCredito.h"
#import "MoIPPortadorDoCartao.h"

/*
 Chaves do JSON a ser enviado para o MoIP
 @see https://labs.moip.com.br/parametro/javascript-de-pagamento/
 */
static NSString* const NumeroKey = @"Numero";
static NSString* const ExpiracaoKey = @"Expiracao";
static NSString* const CodigoDeSegurancaKey = @"CodigoSeguranca";
static NSString* const PortadorKey = @"Portador";

@implementation MoIPCartaoDeCredito


- (BOOL) validateValuesWithError:(NSError**) error {
    BOOL isValid = YES;
    
    if (self.numero <= 0
        || self.codigoDeSeguranca <= 0
        || !self.portadorDoCartao
        || ![self isExpirationDateValid]) {
        return NO;
    }
    
    if (!isValid) {
        //TODO - Handle it better
        if (error) *error = [NSError errorWithDomain:@"MoIPMetodoDePagamentoErrorDomain" code:0 userInfo:@{NSLocalizedDescriptionKey:@"Nem todos os campos foram preencidos corretamente"}];
    }
    return isValid;
}


- (NSDictionary*) dictionaryRepresentation {
    NSMutableDictionary* representation = [NSMutableDictionary dictionary];
    [representation setObject:self.numero forKey:NumeroKey];
    [representation setObject:[self expirationDateStringFormat] forKey:ExpiracaoKey];
    [representation setObject:self.codigoDeSeguranca forKey:CodigoDeSegurancaKey];
    [representation setObject:[self.portadorDoCartao dictionaryRepresentation] forKey:PortadorKey];
    return [representation copy];
}


#pragma mark - Helpers

- (NSString*) expirationDateStringFormat {
    return [NSString stringWithFormat:@"%ld/%ld",(long)self.expiracaoMes, (long) self.expiracaoAno];
}

- (BOOL) isExpirationDateValid {
    NSDate* today = [NSDate date];
    NSDate* expirationData = [self dateWithMonth:self.expiracaoMes year:self.expiracaoAno];
    
    if ([[expirationData earlierDate:today] isEqualToDate:expirationData]) {
        return YES;
    } else {
        return NO;
    }
}


- (NSDate*) dateWithMonth:(NSInteger) month year:(NSInteger) year {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [NSDateComponents new];
    components.month = month;
    components.year = year;
    return [cal dateFromComponents:components];
}


@end
