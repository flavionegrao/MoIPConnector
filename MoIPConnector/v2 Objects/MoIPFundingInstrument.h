//
//  MoIPFundingInstrument.h
//  MoIPConnector
//
//  Created by Flavio Negrão Torres on 17/07/15.
//  Copyright (c) 2015 Apetis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MoIPSerializable.h"

@class MoIPCreditCard;
@class MoIPBoleto;
@class MoIPOnlineDebit;

typedef NS_ENUM(NSInteger, MoIPFundingInstrumentMethod) {
    MoIPFundingInstrumentMethodCreditCard,
    MoIPFundingInstrumentMethodBoleto,
    MoIPFundingInstrumentOnlineDebit
};


@interface MoIPFundingInstrument : NSObject <MoIPSerializable>

@property (nonatomic, assign) MoIPFundingInstrumentMethod method;
@property (nonatomic, strong) MoIPCreditCard* creditCard;
@property (nonatomic, strong) MoIPBoleto* boleto;
@property (nonatomic, strong) MoIPOnlineDebit* onlineDebit;

- (NSString*) methodName;

@end
