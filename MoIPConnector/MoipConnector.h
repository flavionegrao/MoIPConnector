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

#import "MoIPOrder.h"
#import "MoIPPayment.h"

typedef NS_ENUM(NSInteger, MoIPEnvironment) {
    MoIPEnvironmentSandBox,
    MoIPEnvironmentProduction,
};


/**************
 Error Handling
 **************/
extern NSString* const MoipConnectorErrorDomain;

typedef NS_ENUM(NSInteger, MoipConnectorErrorCode) {
    MoipConnectorErrorCodeGeneric = 0, //Check NSLocalizedFailureReasonErrorKey
    
    MoipConnectorErrorCodeProcessingPayment = 1,
    MoipConnectorErrorCodePaymentRegister = 2,
    MoipConnectorErrorCodeCallingPaymentProcess = 3,
    
    MoipConnectorErrorCodeURLSessionError = 100,
    MoipConnectorErrorCodeHTTPServerError = 101,
    
    MoipConnectorErrorCodeXMLParsing = 200,
    
    MoipConnectorErrorCodeJSONParsing = 300,
    
    MoipConnectorErrorCodeUnkown = 999
};


@interface MoipConnector : NSObject

@property (readonly, nonatomic, strong) NSString* token;
@property (readonly, nonatomic, strong) NSString* accessKey;
@property (readonly, nonatomic, strong) NSString* publicCertificate;

/**
 Initialises an instance ready to process payments with MoIP
 @param enviroment Select between sandbox or production
 @param token your payment token that enables MoIP to indentify you and send the payments to your account. You may find the token under MoIP -> Ferramentas -> API MoIP -> Chaves de Acesso
 @param accessKey your payment access key, it works like a password for your account at MoIP. You may find the access key under MoIP -> Ferramentas -> API MoIP -> Chaves de Acesso
 
 */
- (instancetype) initWithEnviroment:(MoIPEnvironment) enviroment
                              token:(NSString*) token
                          accessKey:(NSString*) accessKey
                  publicCertificate:(NSString*) publicCertificate NS_DESIGNATED_INITIALIZER;


/**
 Identify and executes a payment transaction asynchronously.
 @param MoIPOrder Indentifies the payment
 @param MoIPPayment Idenitifies the payment method
 @param completion The completion handler that will be called upon the transaction completion.
 
 */
- (void) executeOrder:(MoIPOrder*) order
          withPayment:(MoIPPayment*) payment
    completionhandler:(void (^)(MoIPOrder* orderAnswer, MoIPPayment* paymentAnwer, NSError* error))completionBlock;


@end
