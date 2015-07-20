//
//  MoIPFundingInstrument.m
//  MoIPConnector
//
//  Created by Flavio Negrão Torres on 17/07/15.
//  Copyright (c) 2015 Apetis. All rights reserved.
//

#import "MoIPFundingInstrument.h"
#import "MoIPCreditCard.h"
#import "MoIPBoleto.h"
#import "MoIPOnlineDebit.h"

@implementation MoIPFundingInstrument

- (instancetype) initWithDictionary:(NSDictionary*) dictionary {
    self = [super init];
    
    if (self && dictionary) {
        [self populateWithDictionary:dictionary];
    } else {
        NSAssert(NO, @"Ops...");
    }
    
    return self;
}

- (void) populateWithDictionary:(NSDictionary*) dictionary {
    
}



- (BOOL) validateValuesWithError:(NSError**) error {
    //TODO: Implement it
    return YES;
}


- (NSDictionary*) dictionaryRepresentation {
    NSMutableDictionary* representation = [NSMutableDictionary dictionary];
    
    switch (self.method) {
        case MoIPFundingInstrumentMethodCofre:
        case MoIPFundingInstrumentMethodCreditCard:
            representation[@"method"] = @"CREDIT_CARD";
            if (self.creditCard) representation[@"creditCard"] = [self.creditCard dictionaryRepresentation];
            break;
            
        case MoIPFundingInstrumentMethodBoleto:
            representation[@"method"] = @"BOLETO";
             if (self.boleto) representation[@"boleto"] = [self.boleto dictionaryRepresentation];
            break;
            
        case MoIPFundingInstrumentOnlineDebit:
            representation[@"method"] = @"ONLINE_BANK_DEBIT";
            if (self.onlineDebit) representation[@"onlineDebit"] = [self.onlineDebit dictionaryRepresentation];
            break;
    
        default:
            break;
    }
    
    return [representation copy];
}

- (NSString*) description {
    return [NSString stringWithFormat:@"%@",[self dictionaryRepresentation]];
}

@end
