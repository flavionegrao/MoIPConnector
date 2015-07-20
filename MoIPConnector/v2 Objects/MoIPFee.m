//
//  MoIPFee.m
//  MoIPConnector
//
//  Created by Flavio Negrão Torres on 17/07/15.
//  Copyright (c) 2015 Apetis. All rights reserved.
//

#import "MoIPFee.h"

@implementation MoIPFee

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
    _type = dictionary[@"type"];
    _amount = dictionary[@"amount"];
}


- (BOOL) validateValuesWithError:(NSError**) error {
    //TODO: Implement it
    return YES;
}


- (NSDictionary*) dictionaryRepresentation {
    NSMutableDictionary* representation = [NSMutableDictionary dictionary];
    if (self.type) representation[@"type"] = self.type;
    if (self.amount) representation[@"amount"] = self.amount;
    return [representation copy];
}

@end
