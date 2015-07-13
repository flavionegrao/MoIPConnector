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

#import "MoIPPortadorDoCartao.h"

/*
 Chaves do JSON a ser enviado para o MoIP
 @see https://labs.moip.com.br/parametro/javascript-de-pagamento/
 */
static NSString* const NomeKey = @"Nome";
static NSString* const DataNascimentoKey = @"DataNascimento";
static NSString* const TelefoneKey = @"Telefone";
static NSString* const IdentidadeKey = @"Identidade";

@implementation MoIPPortadorDoCartao


- (BOOL) validateValuesWithError:(NSError**) error {
    BOOL isValid = YES;
    
    if (!self.nome
        || !self.dataDeNascimento
        || !self.telefone
        || !self.identidade) {
        
        isValid = NO;
    }
        
        
    if (!isValid) {
        //TODO - Handle it better
        if (error) *error = [NSError errorWithDomain:@"MoIPPortadorDoCartaoErrorDomain" code:0 userInfo:@{NSLocalizedDescriptionKey:@"Nem todos os campos foram preencidos corretamente"}];
    }
    return isValid;
}


- (NSDictionary*) dictionaryRepresentation {
    NSMutableDictionary* representation = [NSMutableDictionary dictionary];
    [representation setObject:self.nome forKey:NomeKey];
    [representation setObject:[self dataDeNascimentoMoIPFormat] forKey:DataNascimentoKey];
    [representation setObject:self.telefone forKey:TelefoneKey];
    [representation setObject:self.identidade forKey:IdentidadeKey];
    return [representation copy];
}



#pragma mark - Helpers

- (NSString*) dataDeNascimentoMoIPFormat {
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"dd/MMM/yyyy"];
    return [formatter stringFromDate:self.dataDeNascimento];

}

@end
