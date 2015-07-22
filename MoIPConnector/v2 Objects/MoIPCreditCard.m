//
//  MoIPCreditCard.m
//  MoIPConnector
//
//  Created by Flavio Negrão Torres on 17/07/15.
//  Copyright (c) 2015 Apetis. All rights reserved.
//

#import "MoIPCreditCard.h"
#import "MoIPHolder.h"
//#import "MoipSDK.h"

@implementation MoIPCreditCard

- (instancetype) initWithDictionary:(NSDictionary*) dictionary {
    self = [super init];
    
    if (self && dictionary) {
        [self populateWithDictionary:dictionary];
    }
    
    return self;
}

- (void) populateWithDictionary:(NSDictionary*) dictionary {
    _objectId = dictionary[@"id"];
    _first6 = dictionary[@"first6"];
    _last4 = dictionary[@"last4"];
    _brand = dictionary[@"brand"];
    _holder = [[MoIPHolder alloc]initWithDictionary:dictionary[@"holder"]];
}


- (BOOL) validateValuesWithError:(NSError**) error {
    //TODO: Implement it
    return YES;
}


- (NSDictionary*) dictionaryRepresentation {
    NSMutableDictionary* representation = [NSMutableDictionary dictionary];
    
    if (self.objectId) {
        representation[@"id"] = self.objectId;
        if (self.cvc) representation[@"cvc"] = self.cvc;
        
    } else {
        representation[@"hash"] = [MoipSDK encryptCreditCard:self];
        if (self.holder) representation[@"holder"] = [self.holder dictionaryRepresentation];
    }
    
    return [representation copy];
}

- (NSString*) description {
    return [NSString stringWithFormat:@"%@",[self dictionaryRepresentation]];
}

@end
