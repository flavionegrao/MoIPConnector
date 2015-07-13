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

#import "MoIPMetodoDePagamento.h"
#import "MoIPCartaoDeCredito.h"

/* 
 Chaves do JSON a ser enviado para o MoIP 
 @see https://labs.moip.com.br/parametro/javascript-de-pagamento/
 */
static NSString* const FormaDePagamentoKey = @"Forma";
static NSString* const InstituicaoKey = @"Instituicao";
static NSString* const ParcelasKey = @"Parcelas";
static NSString* const CartaoDeCreditoKey = @"CartaoCredito";


@implementation MoIPMetodoDePagamento

- (instancetype) initWithFormaDePagamento:(MoIPFormaDePagamento) formaDePagamento {
    self = [super init];
    if (self) {
        _formaDePagamento = formaDePagamento;
    }
    return self;
}


- (BOOL) validateValuesWithError:(NSError**) error {
    BOOL isValid = YES;
    
    if (self.formaDePagamento == MoIPFormaDePagamentoDebitoBancario) {
        if (self.instituicaoDePagamento < MoIPInstituicaoDePagamentoBancoDoBrasil) {
            isValid = NO;
        }
    } else if (self.formaDePagamento == MoIPFormaDePagamentoCartaoDeCredito) {
        if (self.instituicaoDePagamento < MoIPInstituicaoDePagamentoVisa ||
            !self.cartaoDeCredito) {
            isValid = NO;
        }
    }
    
    if (!isValid) {
        //TODO - Handle it better
        if (error) *error = [NSError errorWithDomain:@"MoIPMetodoDePagamentoErrorDomain" code:0 userInfo:@{NSLocalizedDescriptionKey:@"Nem todos os campos foram preencidos corretamente"}];
    }
    return isValid;
}


- (NSString*) stringFromFormaDePagamento {
    switch (self.formaDePagamento) {
        case MoIPFormaDePagamentoBoletoBancario: return @"BoletoBancario";
        case MoIPFormaDePagamentoCartaoDeCredito: return @"CartaoCredito";
        case MoIPFormaDePagamentoDebitoBancario: return @"DebitoBancario";
    }
}


- (NSString*) stringFromInstituicao {
    switch (self.instituicaoDePagamento) {
        case MoIPInstituicaoDePagamentoVisa: return @"Visa";
        case MoIPInstituicaoDePagamentoDiners: return @"Diners";
        case MoIPInstituicaoDePagamentoMasterCard: return @"Mastercard";
        case MoIPInstituicaoDePagamentoHiperCard: return @"Hipercard";
        case MoIPInstituicaoDePagamentoHiper: return @"Hiper";
        case MoIPInstituicaoDePagamentoElo: return @"Elo";
        case MoIPInstituicaoDePagamentoAmericanExpress: return @"AmericanExpress";

        case MoIPInstituicaoDePagamentoBancoDoBrasil: return @"BancoDoBrasil";
        case MoIPInstituicaoDePagamentoBradesco: return @"Bradesco";
        case MoIPInstituicaoDePagamentoBanrisul: return @"Banrisul";
        case MoIPInstituicaoDePagamentoItau: return @"Itau";
    }
}


- (NSDictionary*) dictionaryRepresentation {
    NSMutableDictionary* representation = [NSMutableDictionary dictionary];
    [representation setObject:[self stringFromFormaDePagamento] forKey:FormaDePagamentoKey];
    
    if (self.formaDePagamento == MoIPFormaDePagamentoDebitoBancario ||
        self.formaDePagamento == MoIPFormaDePagamentoCartaoDeCredito) {
        
        [representation setObject:[self stringFromInstituicao] forKey:InstituicaoKey];
        
        if (self.formaDePagamento == MoIPFormaDePagamentoCartaoDeCredito) {
            NSString* parcelas = [NSString stringWithFormat:@"%ld", (long) self.parcelas];
            [representation setObject:parcelas forKey:ParcelasKey];
            [representation setObject:[self.cartaoDeCredito dictionaryRepresentation] forKey:CartaoDeCreditoKey];
        }
    }
    
    return [representation copy];
}

@end
