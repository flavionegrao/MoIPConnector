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
    }
    return self;
}


- (void) populateWithDictionary:(NSDictionary*) dictionary {
    if ([dictionary[@"method"]isEqualToString:@"CREDIT_CARD"]) {
        self.method = MoIPFundingInstrumentMethodCreditCard;
        
    } else if ([dictionary[@"method"]isEqualToString:@"BOLETO"]) {
        self.method = MoIPFundingInstrumentMethodBoleto;
        
    } else if ([dictionary[@"method"]isEqualToString:@"ONLINE_BANK_DEBIT"]) {
        self.method = MoIPFundingInstrumentOnlineDebit;
        
    } else {
        NSLog(@"%s - Unexpected method: %@",__PRETTY_FUNCTION__, dictionary[@"method"]);
    }
    
    _creditCard = [[MoIPCreditCard alloc]initWithDictionary:dictionary[@"creditCard"]];
    _boleto = [[MoIPBoleto alloc]initWithDictionary:dictionary[@"boleto"]];
    _onlineDebit = [[MoIPOnlineDebit alloc]initWithDictionary:dictionary[@"onlineDebit"]];
}



- (BOOL) validateValuesWithError:(NSError**) error {
    //TODO: Implement it
    return YES;
}


- (NSDictionary*) dictionaryRepresentation {
    NSMutableDictionary* representation = [NSMutableDictionary dictionary];
    
    switch (self.method) {
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
