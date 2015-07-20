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

static NSString* const MoIPSandboxServerURL = @"https://test.moip.com.br/v2/";
static NSString* const MoIPServerURL = @"https://moip.com.br/v2/";

NSString* const MoipConnectorErrorDomain = @"br.com.moip.MoipConnectorErrorDomain";


@interface MoipConnector() <NSURLSessionTaskDelegate, NSXMLParserDelegate>

@property (nonatomic, strong) NSURLSession* session;
@property (readonly, nonatomic, assign) MoIPEnvironment environement;
@property (readonly, nonatomic, strong) NSURL* serverURL;
@property (readonly, nonatomic, strong) NSString* token;
@property (readonly, nonatomic, strong) NSString* accessKey;
@property (readonly, nonatomic, strong) NSString* publicCertificate;

@end


@implementation MoipConnector

#pragma mark - Initialization

- (instancetype) initWithEnviroment:(MoIPEnvironment) enviroment
                              token:(NSString*) token
                          accessKey:(NSString*) accessKey
                  publicCertificate:(NSString*) publicCertificate {
    
    self = [super init];
    
    if (self && token.length > 0  && accessKey.length > 0 && publicCertificate.length > 0) {
        _environement = enviroment;
        _serverURL = [self urlFromMoIPEnvironement:enviroment];
        _token = token;
        _accessKey = accessKey;
        _publicCertificate = publicCertificate;
        
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

- (void) executeOrder:(MoIPOrder*) order
          withPayment:(MoIPPayment*) payment
    completionhandler:(void (^)(MoIPOrder* orderAnswer, MoIPPayment* paymentAnwer, NSError* error))completionBlock {

    [self postOrder:order completionhandler:^(MoIPOrder *orderAnswer, NSError *error) {
        if (!error) {
            [self postPayment:payment forOrder:orderAnswer completionhandler:^(MoIPPayment *paymentAnswer, NSError *error) {
                if (!error) {
                    if (completionBlock) completionBlock(orderAnswer,paymentAnswer,nil);
                } else {
                     if (completionBlock) completionBlock(nil,nil,error);
                }
            }];
        } else {
             if (completionBlock) completionBlock(nil,nil,error);
        }
    }];
}


#pragma mark - Private Methods

- (void) postOrder:(MoIPOrder*) order completionhandler:(void (^)(MoIPOrder* orderAnswer, NSError* error))completionBlock {
    NSURL* requestURL = [NSURL URLWithString:[order restEntryPoint] relativeToURL:self.serverURL];
    
    NSMutableURLRequest* request = [self requestForURL:requestURL withPayloadData:[order jsonData]];
    
    NSURLSessionDataTask* task = [self jsonTaskWithRequest:request completionHandler:^(NSDictionary *answer, NSError *error) {
        if (!error) {
            MoIPOrder* orderAnswer = [[MoIPOrder alloc]initWithDictionary:answer];
            if (completionBlock) completionBlock (orderAnswer,nil);
        } else {
            if (completionBlock) completionBlock(nil,error);
        }
        
    }];
    
    [task resume];
}

- (void) postPayment:(MoIPPayment*) payment forOrder:(MoIPOrder*)order completionhandler:(void (^)(MoIPPayment* paymentAnswer, NSError* error))completionBlock {
    
    NSString* path = [NSString stringWithFormat:@"%@/%@/%@",[order restEntryPoint],order.objectId,[payment restEntryPoint]];
    NSURL* requestURL = [NSURL URLWithString:path relativeToURL:self.serverURL];
    NSMutableURLRequest* request = [self requestForURL:requestURL withPayloadData:[payment jsonData]];
    
    NSURLSessionDataTask* task = [self jsonTaskWithRequest:request completionHandler:^(NSDictionary *answer, NSError *error) {
        if (!error) {
            MoIPPayment* paymentAnswer = [[MoIPPayment alloc]initWithDictionary:answer];
            if (completionBlock) completionBlock (paymentAnswer,nil);
        } else {
            if (completionBlock) completionBlock(nil,error);
        }
        
    }];
    
    [task resume];
}

- (NSString *) basicMoipAuthenticationString {
    NSString *tokenkey = [[NSString alloc] initWithFormat:@"%@:%@", self.token, self.accessKey];
    NSData *nsdata = [tokenkey dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authBasicTokenKey = [[NSString alloc] initWithFormat:@"Basic %@", [nsdata base64EncodedStringWithOptions:0]];
    
    return authBasicTokenKey;
}


- (NSMutableURLRequest*) requestForURL:(NSURL*) requestURL withPayloadData:(NSData*) payload {
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:requestURL];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[self basicMoipAuthenticationString] forHTTPHeaderField:@"Authorization"];
    [request setHTTPBody:payload];
    [request setValue:[NSString stringWithFormat:@"%ld", (long) [payload length]] forHTTPHeaderField:@"Content-Length"];
    
    return request;
}


- (NSURLSessionDataTask *)jsonTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSDictionary* answer, NSError *error))completionHandler {
    
    NSURLSessionDataTask* task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *urlSessionError) {
        
        if (urlSessionError) {
            completionHandler(nil,[self errorFromURLSessionError:urlSessionError]);
            return;
        }
        
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*) response;
        
        /*
         https://www.ietf.org/rfc/rfc2616.txt
         200 OK
         201 Created
         202 Accepted
         */
        if (httpResponse.statusCode > 202) {
            completionHandler(nil,[self errorFromHTTPResponse:httpResponse data:data]);
            return;
        }
        
        if (data != nil) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
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
    NSDictionary* userInfo;
    if ([response.allHeaderFields[@"Content-Type"] isEqualToString:@"application/json"]) {
        id jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        userInfo = @{NSLocalizedDescriptionKey:jsonData};
        
    } else if ([response.allHeaderFields[@"Content-Type"] isEqualToString:@"text/plain; charset=UTF-8"]) {
        NSString* stringError = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        userInfo = @{NSLocalizedDescriptionKey:stringError};

    }
    return [NSError errorWithDomain:MoipConnectorErrorDomain code:response.statusCode userInfo:userInfo];
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

@end
