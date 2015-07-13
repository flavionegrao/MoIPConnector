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

#import "MoIPInfoDePagamento.h"

static NSString* const RazaoKey = @"Razao";
static NSString* const ValorKey = @"Valor";
static NSString* const IdProprioKey = @"IdProprio";
static NSString* const IdPagadorKey = @"IdPagador";
static NSString* const NomeKey = @"Nome";
static NSString* const EmailKey = @"Email";
static NSString* const NumeroKey = @"Numero";
static NSString* const LogradouroKey = @"Logradouro";
static NSString* const ComplementoKey = @"Complemento";
static NSString* const BairroKey = @"Bairro";
static NSString* const CidadeKey = @"Cidade";
static NSString* const EstadoKey = @"Estado";
static NSString* const PaisKey = @"Pais";
static NSString* const CEPKey = @"CEP";
static NSString* const TelefoneFixoKey = @"TelefoneFixo";
static NSString* const LoginMoIPKey = @"LoginMoIP";
static NSString* const PagadorKey = @"Pagador";
static NSString* const EnderecoDeCobranca = @"EnderecoCobranca";
static NSString* const InstrucaoUnicaKey = @"InstrucaoUnica";
static NSString* const EnviarInstrucaoKey = @"EnviarInstrucao";
static NSString* const TipoValidacaoKey = @"TipoValidacao";

@implementation MoIPInfoDePagamento

/**
 Elementos mínimos
 <EnviarInstrucao>
    <InstrucaoUnica TipoValidacao="Transparente">
        <Razao>Razão / Motivo do pagamento</Razao>
        <Valores>
            <Valor moeda='BRL'>100.00</Valor>
        </Valores>
        <IdProprio>ABC1234</IdProprio>
        <Pagador>
            <Nome>Nome Sobrenome</Nome>
            <Email>email@cliente.com.br</Email>
            <IdPagador>id_usuario</IdPagador>
            <EnderecoCobranca>
                <Logradouro>Rua do Zézinho Coração</Logradouro>
                <Numero>45</Numero>
                <Complemento>z</Complemento>
                <Bairro>Palhaço Jão</Bairro>
                <Cidade>São Paulo</Cidade>
                <Estado>SP</Estado>
                <Pais>BRA</Pais>
                <CEP>01230-000</CEP>
                <TelefoneFixo>(11)8888-8888</TelefoneFixo>
            </EnderecoCobranca>
        </Pagador>
    </InstrucaoUnica>
 </EnviarInstrucao>
 */

- (BOOL) validateValuesWithError:(NSError**) error {
    BOOL isValid = YES;
    
    if (!self.razao
        || !self.idProprio
        || [self.valor floatValue] <= 0
        || !self.nome
        || !self.email
        || !self.idPagador
        || !self.logradouro
        || !self.numero
        || !self.bairro
        || !self.cidade
        || self.estado.length != 2
        || self.pais.length != 3
        || !self.cep
        || !self.telefoneFixo) {
        
        isValid = NO;
    }
    
    if (!isValid) {
        //TODO - Handle it better
        if (error) *error = [NSError errorWithDomain:@"MoIPInfoDePagamentoErrorDomain" code:0 userInfo:@{NSLocalizedDescriptionKey:@"Nem todos os campos foram preencidos corretamente"}];
    }
    return isValid;
}

- (NSString*) XMLRepresentation {
    NSMutableString *instrucao = [NSMutableString string];
    
    [instrucao appendString:[self xmlNodeWithKey:RazaoKey value:self.razao]];
    [instrucao appendString:[self xmlNodeWithKey:IdProprioKey value:self.idProprio]];
    
    NSString* valor = [self xmlNodeWithKey:@"Valor" attributes:@{@"moeda":@"BRL"} value:[self.valor stringValue]];
    [instrucao appendString:[self xmlNodeWithKey:@"Valores" value:valor]];
    
    NSMutableString* pagador = [NSMutableString new];
    [pagador appendString:[self xmlNodeWithKey:NomeKey value:self.nome]];
    [pagador appendString:[self xmlNodeWithKey:EmailKey value:self.email]];
    [pagador appendString:[self xmlNodeWithKey:IdPagadorKey value:self.idPagador]];
    
    NSMutableString* enderecoDeCobranca = [NSMutableString new];
    [enderecoDeCobranca appendString:[self xmlNodeWithKey:LogradouroKey value:self.logradouro]];
    [enderecoDeCobranca appendString:[self xmlNodeWithKey:NumeroKey value:self.numero]];
    [enderecoDeCobranca appendString:[self xmlNodeWithKey:ComplementoKey value:self.complemento]];
    [enderecoDeCobranca appendString:[self xmlNodeWithKey:BairroKey value:self.bairro]];
    [enderecoDeCobranca appendString:[self xmlNodeWithKey:CidadeKey value:self.cidade]];
    [enderecoDeCobranca appendString:[self xmlNodeWithKey:EstadoKey value:self.estado]];
    [enderecoDeCobranca appendString:[self xmlNodeWithKey:PaisKey value:self.pais]];
    [enderecoDeCobranca appendString:[self xmlNodeWithKey:CEPKey value:self.cep]];
    [enderecoDeCobranca appendString:[self xmlNodeWithKey:TelefoneFixoKey value:self.telefoneFixo]];
    [pagador appendString:[self xmlNodeWithKey:EnderecoDeCobranca value:enderecoDeCobranca]];
    
    [instrucao appendString:[self xmlNodeWithKey:PagadorKey value:pagador]];
    
    NSString* instrucaoUnica = [self xmlNodeWithKey:InstrucaoUnicaKey attributes:@{TipoValidacaoKey:@"Transparente"} value:instrucao];
    
    return [self xmlNodeWithKey:EnviarInstrucaoKey value:instrucaoUnica];
}


#pragma mark - Helpers

- (NSString*) xmlNodeWithKey:(NSString*) key value:(NSString*) value {
    return [NSString stringWithFormat:@"<%@>%@</%@>",key,value?:@"",key];
}

- (NSString*) xmlNodeWithKey:(NSString*) key attributes:(NSDictionary*) attributes value:(NSString*) value {
    
    NSMutableString* attributesString;
    if (attributes) {
        attributesString  = [NSMutableString string];
        [attributes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [attributesString appendFormat:@" %@='%@'",key,obj];
        }];
    }
    
    return [NSString stringWithFormat:@"<%@%@>%@</%@>",key, attributesString ?: @"",value ?: @"",key];
}

@end
