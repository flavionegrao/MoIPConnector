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

#import "MoIPStatusDoPagamento.h"

/*********
 Constants key for Moip JSON return
 for more information: https://labs.moip.com.br/parametro/javascript-de-pagamento/
 *********/
static NSString* const StatusPagamentoKey =  @"StatusPagamento";
static NSString* const StatusKey = @"Status";
static NSString* const ErrorKey = @"Error";
static NSString* const CodigoMoIPKey = @"CodigoMoIP";
static NSString* const MensagemKey =  @"Mensagem";
static NSString* const TaxaMoIPKey = @"TaxaMoIP";
static NSString* const TotalPagoKey = @"TotalPago";
static NSString* const ClassificacaoKey =  @"Classificacao";
static NSString* const CodigoKey = @"Codigo";
static NSString* const DescricaoKey = @"Descricao";


@implementation MoIPStatusDoPagamento

- (instancetype) initWithDictionary:(NSDictionary*) dictionary
                   tokenDePagamento:(NSString*) token {
    self = [super init];
    
    if (self && dictionary && token) {
        _tokenDePagamento = token;
        [self configWithDictionary:dictionary];
        
    } else {
        NSAssert(NO, @"Missing mandatory init paramethers");
    }
    return self;
}

- (void) configWithDictionary:(NSDictionary*) dictionary {
    _statusDoPagamento = [self statusDoPagamentoFromString:dictionary[StatusPagamentoKey]];
    
    if (_statusDoPagamento == MoIPStatusPagamentoSucesso) {
        _status = [self statusFromString:dictionary[StatusKey]];
        _codigoMoIP = dictionary[CodigoMoIPKey];
        _totalPago = @([dictionary[TotalPagoKey]floatValue]);
        _taxaMoIP = @([dictionary[TaxaMoIPKey]floatValue]);
        _classificacao = dictionary[ClassificacaoKey];
        _codigo = @([dictionary[CodigoKey]integerValue]);
    }
    _mensagem = dictionary[MensagemKey];
}

- (MoIPStatusPagamento) statusDoPagamentoFromString:(NSString*) string {
    if ([string isEqualToString:@"Sucesso"]){
        return MoIPStatusPagamentoSucesso;
    } else if ([string isEqualToString:@"Falha"]) {
        return MoIPStatusPagamentoFalha;
    } else {
        return MoIPStatusPagamentoNaoInformado;
    }
}

- (MoIPStatus) statusFromString:(NSString*) string {
    if ([string isEqualToString:@"EmAnalise"]){
        return MoIPStatusEmAnalise;
        
    } else if ([string isEqualToString:@"Autorizado"]) {
        return MoIPStatusAutorizado;
        
    } else if ([string isEqualToString:@"Iniciado"]) {
        return MoIPStatusIniciado;
        
    } else if ([string isEqualToString:@"Cancelado"]) {
        return MoIPStatusCancelado;
        
    } else {
        return MoIPStatusNaoInformado;
        return -1;
    }
}

#pragma mark - Debug

- (NSString*) description {
    NSMutableString* description = [NSMutableString string];
    
    [description appendString:@"Status do Pagamento: "];
    switch (self.statusDoPagamento) {
        case MoIPStatusPagamentoFalha:[description appendString:@"Falha"];break;
        case MoIPStatusPagamentoSucesso: [description appendString:@"Sucesso"];break;
        case MoIPStatusPagamentoNaoInformado: [description appendString:@"Não Informado"];break;
    }
    
    [description appendString:@"\nStatus do Pagamento: "];
    switch (self.status) {
        case MoIPStatusAutorizado:[description appendString:@"Autorizado"];break;
        case MoIPStatusCancelado: [description appendString:@"Cancelado"];break;
        case MoIPStatusEmAnalise: [description appendString:@"Em Analise"];break;
        case MoIPStatusIniciado: [description appendString:@"Iniciado"];break;
        case MoIPStatusNaoInformado: [description appendString:@"Nao Informado"];break;
    }
    
    [description appendFormat:@"\nCódigo MoIP: %@",self.codigoMoIP ?: @"N/A"];
    [description appendFormat:@"\nCódigo: %@",self.codigo ?: @"N/A"];
    [description appendFormat:@"\nMensagem: %@",self.mensagem ?: @"N/A"];
    [description appendFormat:@"\nTaxa MoIP: %@",self.taxaMoIP ?: @"N/A"];
    [description appendFormat:@"\nTotal Pago: %@",self.totalPago ?: @"N/A"];
    [description appendFormat:@"\nClassificação: %@",self.classificacao ?:@"N/A"];
    
    return [description copy];
}


@end
