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

#import "MoipConnector.h"

static NSString* const MoIPSandboxServerURL = @"https://desenvolvedor.moip.com.br/sandbox/";
static NSString* const MoIPServerURL = @"https://www.moip.com.br";

static NSString* const MoipInstrucaoUnicaPath =  @"ws/alpha/EnviarInstrucao/Unica";
static NSString* const MoipPagamentoPath =       @"rest/pagamento";


// tags XML
static NSString* const XMLMoipID =         @"ID";
static NSString* const XMLMoipStatus =     @"Status";
static NSString* const XMLMoipToken =      @"Token";
static NSString* const XMLMoipErro =       @"Erro";
static NSString* const XMLMoipResposta =   @"Resposta";
static NSString* const XMLMoipCodigo =     @"Codigo";
static NSString* const XMLMoipErroCodigo = @"ErroCodigo";

// response Status from Moip
static NSString* const MoipStatusSucesso = @"Sucesso";
static NSString* const MoipStatusFalha =   @"Falha";

NSString* const MoipConnectorErrorDomain = @"br.com.moip.MoipConnectorErrorDomain";


@interface MoipConnector() <NSURLSessionTaskDelegate, NSXMLParserDelegate>

@property (nonatomic, strong) NSURLSession* session;
@property (readonly, nonatomic, assign) MoIPEnvironment environement;
@property (readonly, nonatomic, strong) NSURL* serverURL;
@property (readonly, nonatomic, strong) NSString* token;
@property (readonly, nonatomic, strong) NSString* accessKey;

// XML Parsing
@property (nonatomic, strong) NSXMLParser *xmlParser;
@property (nonatomic, strong) NSMutableArray *xmlResponseDataObjects;
@property (nonatomic, strong) NSMutableDictionary *xmlDictTempDataStorage;
@property (nonatomic, strong) NSMutableString *xmlFoundValue;
@property (nonatomic, strong) NSString *xmlCurrentElement;

@end


@implementation MoipConnector

#pragma mark - Initialization

- (instancetype) initWithEnviroment:(MoIPEnvironment) environment
                              token:(NSString*) token
                          accessKey:(NSString*) accessKey {
    
    self = [super init];
    
    if (self && token && accessKey) {
        _environement = environment;
        _serverURL = [self urlFromMoIPEnvironement:environment];
        _token = token;
        _accessKey = accessKey;
        
    } else {
        NSAssert(NO, @"missing parameters");
    }
    return self;
}


- (NSURL*) urlFromMoIPEnvironement:(MoIPEnvironment) environement {
    switch (environement) {
        case MoIPEnvironmentProduction: return [NSURL URLWithString:MoIPServerURL];
        case MoIPEnvironmentSandBox: return [NSURL URLWithString:MoIPSandboxServerURL];
    }
}

- (NSURL*) urlDePagamentoWithToken:(NSString *)tokenDePagamento {
    NSString* urlString =  [NSString stringWithFormat:@"%@Instrucao.do?token=%@",
                            [self urlFromMoIPEnvironement:self.environement],
                            tokenDePagamento];
    return [NSURL URLWithString:urlString];
}

#pragma mark - Getter and Setters

- (NSURLSession*) session {
    if (!_session) {
        NSURLSessionConfiguration* conf = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        conf.URLCache = nil;
        conf.timeoutIntervalForRequest = 5 * 60;
        _session = [NSURLSession sessionWithConfiguration:conf delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}


#pragma mark - Public methods

- (void) executePaymentWithPaymenInfo:(MoIPInfoDePagamento*) paymentInfo
                        paymentMethod:(MoIPMetodoDePagamento*) paymentoMethod
                           completion:(void (^)(MoIPStatusDoPagamento* paymentStatus, NSError* error))completionBlock {

    [self paymentRegisterWithInfo:paymentInfo completion:^(NSString *token, NSError *error) {
        if (!error) {
            [self paymentExecute:paymentoMethod token:token completion:completionBlock];
        } else {
            if (completionBlock) completionBlock(nil,error);
        }
    }];
}


#pragma mark - Private Methods

- (void) paymentRegisterWithInfo:(MoIPInfoDePagamento*) paymentInfo
              completion: (void (^) (NSString* token, NSError* error)) completionBlock {
    
    NSURL* requestURL = [NSURL URLWithString:MoipInstrucaoUnicaPath relativeToURL:self.serverURL];
    NSMutableURLRequest* request = [self requestForURL:requestURL paymentInfo:paymentInfo];
    
    NSURLSessionDataTask* task = [self xmlTaskWithRequest:request completionHandler:^(NSData *xml, NSError *error) {
        
        if (!error) {
            self.xmlParser = [[NSXMLParser alloc] initWithData:xml];
            self.xmlParser.delegate = self;
            
            if ([self.xmlParser parse]) {
                NSDictionary* moIPResponse = self.xmlResponseDataObjects.firstObject;
                NSString* responseStatus = [moIPResponse objectForKey:XMLMoipStatus];
                    
                    if ([responseStatus isEqualToString:MoipStatusSucesso]) {
                        NSString *token = [moIPResponse objectForKey:XMLMoipToken];
                        completionBlock(token, nil);
                        
                    } else if ([responseStatus isEqualToString:MoipStatusFalha]) {
                        NSString *errorString = [[NSString alloc] initWithFormat:@"An Error response from MoIP => Status=%@, Codigo=%@ - %@",
                                                 [moIPResponse objectForKey:XMLMoipStatus],
                                                 [moIPResponse objectForKey:XMLMoipErroCodigo],
                                                 [moIPResponse objectForKey:XMLMoipErro]];
        
                        NSError* localError =  [NSError errorWithDomain:MoipConnectorErrorDomain
                                                                   code:MoipConnectorErrorCodeGeneric
                                                               userInfo:@{NSLocalizedFailureReasonErrorKey:errorString}];
                        completionBlock(nil,localError);
                        
                    } else {
                        NSError* localError =  [NSError errorWithDomain:MoipConnectorErrorDomain
                                                                   code:MoipConnectorErrorCodeUnkown
                                                               userInfo:@{NSLocalizedFailureReasonErrorKey:moIPResponse}];
                        completionBlock(nil,localError);
                    }
                
            } else {
                // error in parse XML
                NSLog(@"An Error occurred parsing response for paymentRegister.");
                NSError* localError =  [NSError errorWithDomain:MoipConnectorErrorDomain
                                                           code:MoipConnectorErrorCodeXMLParsing
                                                       userInfo:nil];
                completionBlock(nil,localError);
            }
            
        } else {
            completionBlock(nil,error);
        }
    }];
    
    [task resume];
}


- (void) paymentExecute:(MoIPMetodoDePagamento *)paymentMethod
                  token:(NSString *)token
             completion: (void (^) (MoIPStatusDoPagamento* paymentStatus, NSError* error)) completionBlock {
    
    NSMutableString *queryString = [[NSMutableString alloc] initWithString:@"callback=callback&pagamentoWidget="];
    
    NSDictionary *paymentWidget = @{@"pagamentoWidget":@{@"referer":@"callback",
                                                         @"token":token,
                                                         @"dadosPagamento":[paymentMethod dictionaryRepresentation]}};
    
    NSError* jsonError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paymentWidget options:NSJSONWritingPrettyPrinted error:&jsonError];
    if (jsonError) {
        NSLog(@"Error with JSON format: %@", paymentWidget);
        NSError* localError =  [NSError errorWithDomain:MoipConnectorErrorDomain
                                                   code:MoipConnectorErrorCodeJSONParsing
                                               userInfo:@{NSUnderlyingErrorKey:jsonError}];
        completionBlock(nil,localError);
        return;
    }
    
    NSString *unescapedString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString* escapedUrlString = [unescapedString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [queryString appendString:escapedUrlString];
    
    // timestamp in miliseconds since 1970
    [queryString appendFormat:@"&_=%0.f", [[NSDate date] timeIntervalSince1970] * 1000];
    
    NSString *urlString = [NSString stringWithFormat:@"%@?%@", MoipPagamentoPath, queryString];
    NSURL* requestURL = [NSURL URLWithString:urlString relativeToURL:self.serverURL];
    NSURLRequest* request = [[NSURLRequest alloc] initWithURL:requestURL];
    
    NSURLSessionDataTask* task = [self moIPJSONTaskWithRequest:request completionHandler:^(NSDictionary* json, NSError *error) {
        if (!error) {
            MoIPStatusDoPagamento* paymentStatus = [[MoIPStatusDoPagamento alloc]initWithDictionary:json tokenDePagamento:token];
            if (completionBlock) completionBlock(paymentStatus,nil);
        } else {
            if (completionBlock) completionBlock(nil,error);
        }
    }];
    
    [task resume];
}


- (NSString *) authBasicMoip {
    NSString *tokenkey = [[NSString alloc] initWithFormat:@"%@:%@", self.token, self.accessKey];
    NSData *nsdata = [tokenkey dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authBasicTokenKey = [[NSString alloc] initWithFormat:@"Basic %@", [nsdata base64EncodedStringWithOptions:0]];
    
    return authBasicTokenKey;
}


- (NSMutableURLRequest*) requestForURL:(NSURL*) requestURL
                           paymentInfo:(MoIPInfoDePagamento*) paymentInfo {
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:requestURL];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/xml" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/xml; charset=ISO-8859-1" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[self authBasicMoip] forHTTPHeaderField:@"Authorization"];
    
    NSString *xmlBody = [paymentInfo XMLRepresentation];
    
    NSData *xmlDataBody = [xmlBody dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:xmlDataBody];
    [request setValue:[NSString stringWithFormat:@"%ld", (long) [xmlDataBody length]] forHTTPHeaderField:@"Content-Length"];
    
    return request;
}

- (NSURLSessionDataTask *)xmlTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData* xml, NSError *error))completionHandler {
    
    NSURLSessionDataTask* task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *urlSessionError) {
        
        if (urlSessionError) {
            completionHandler(nil,[self errorFromURLSessionError:urlSessionError]);
            return;
        }
        
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*) response;
        if (httpResponse.statusCode != 200) {
            completionHandler(nil,[self errorFromHTTPResponse:httpResponse data:data]);
            return;
        }
        
        NSString *responseXMLString = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
        NSData* responseXMLData = [responseXMLString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        completionHandler(responseXMLData,nil);
    }];
    
    return task;
}


- (NSURLSessionDataTask *)moIPJSONTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSDictionary* answer, NSError *error))completionHandler {
    
    NSURLSessionDataTask* task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *urlSessionError) {
        
        if (urlSessionError) {
            completionHandler(nil,[self errorFromURLSessionError:urlSessionError]);
            return;
        }
        
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*) response;
        if (httpResponse.statusCode != 200) {
            completionHandler(nil,[self errorFromHTTPResponse:httpResponse data:data]);
            return;
        }
        
        if (data != nil) {
            NSString* rawMoIPAnswer = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSRange clipStart = [rawMoIPAnswer rangeOfString:@"{"];
            NSRange clipRange = NSMakeRange(clipStart.location, rawMoIPAnswer.length - clipStart.location - 1);
            NSString* moIPAnswer = [rawMoIPAnswer substringWithRange:clipRange];
            
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[moIPAnswer dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
            completionHandler(json,nil);
            
        } else {
            NSError* localError =  [NSError errorWithDomain:MoipConnectorErrorDomain code:MoipConnectorErrorCodeXMLParsing userInfo:nil];
            completionHandler(nil,localError);
        }
        
    }];
    
    return task;
}



- (NSError*) errorFromURLSessionError:(NSError*) error {
    return [NSError errorWithDomain:MoipConnectorErrorDomain code:0 userInfo:@{NSUnderlyingErrorKey:error}];
}


- (NSError*) errorFromHTTPResponse:(NSHTTPURLResponse*) response data:(NSData*) data {
    return [NSError errorWithDomain:MoipConnectorErrorDomain code:response.statusCode userInfo:nil];
}

- (id) jsonObjectFromData:(NSData*) data error:(NSError**) error {
    NSError* jsonParseError = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParseError];
    if (!jsonParseError){
        return json;
    } else {
        if (error) *error = jsonParseError;
        return nil;
    }
}


#pragma mark - NSXMLParserDelegate

/*
 /// RESPONSE: OK
 <ns1:EnviarInstrucaoUnicaResponse xmlns:ns1="http://www.moip.com.br/ws/alpha/">
 <Resposta>
 <ID>201505230024095230000007736049</ID>
 <Status>Sucesso</Status>
 <Token>B2O0O1I54075T2S3D0O05264X0F9Y5Y2W3V0I000Z0N0V0Q7L7P366L0R4T9</Token>
 </Resposta>
 </ns1:EnviarInstrucaoUnicaResponse>
 
 /// RESPONSE: ERROR
 <ns1:EnviarInstrucaoUnicaResponse xmlns:ns1="http://www.moip.com.br/ws/alpha/">
 <Resposta>
 <ID>201505230914168090000007743332</ID>
 <Status>Falha</Status>
 <Erro Codigo="102">Id Próprio já foi utilizado em outra Instrução</Erro>
 </Resposta>
 </ns1:EnviarInstrucaoUnicaResponse
 
 */

- (void)parserDidStartDocument:(NSXMLParser *)parser{
    self.xmlResponseDataObjects = [NSMutableArray array];
    self.xmlFoundValue = [NSMutableString string];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser{
    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
    if ([elementName isEqualToString:XMLMoipResposta]) {
        // Response from MoIP - initialize the temporary dictionary
        self.xmlDictTempDataStorage = [[NSMutableDictionary alloc] init];
    } else if ([elementName isEqualToString:XMLMoipErro]) {
        // If "Erro" we also store the "Codigo"
        [self.xmlDictTempDataStorage setObject:[NSString stringWithString:[attributeDict objectForKey:XMLMoipCodigo]] forKey:XMLMoipErroCodigo];
    }
    
    // Keep the current element.
    self.xmlCurrentElement = elementName;
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    //    NSLog(@"End element %@", elementName);
    if ([elementName isEqualToString:XMLMoipResposta]) {
        // End of "Resposta" from MoIP all should be added to xmlResponseDataObjects
        [self.xmlResponseDataObjects addObject:[[NSDictionary alloc] initWithDictionary:self.xmlDictTempDataStorage]];
        
    }
    else if ([elementName isEqualToString:XMLMoipID])     [self.xmlDictTempDataStorage setObject:[NSString stringWithString:self.xmlFoundValue] forKey:XMLMoipID];
    else if ([elementName isEqualToString:XMLMoipStatus]) [self.xmlDictTempDataStorage setObject:[NSString stringWithString:self.xmlFoundValue] forKey:XMLMoipStatus];
    else if ([elementName isEqualToString:XMLMoipToken])  [self.xmlDictTempDataStorage setObject:[NSString stringWithString:self.xmlFoundValue] forKey:XMLMoipToken];
    else if ([elementName isEqualToString:XMLMoipErro])   [self.xmlDictTempDataStorage setObject:[NSString stringWithString:self.xmlFoundValue] forKey:XMLMoipErro];
    
    // Clear the mutable string.
    [self.xmlFoundValue setString:@""];
}

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    NSLog(@"%@", [parseError localizedDescription]);
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    // Store the found characters if only we're interested in the current element.
    if ([self.xmlCurrentElement isEqualToString:XMLMoipID] ||
        [self.xmlCurrentElement isEqualToString:XMLMoipStatus] ||
        [self.xmlCurrentElement isEqualToString:XMLMoipToken] ||
        [self.xmlCurrentElement isEqualToString:XMLMoipErro]) {
        
        //        NSLog(@"Found: %@", string);
        if (![string isEqualToString:@"\n"]) {
            [self.xmlFoundValue appendString:string];
        }
    }
}

@end
