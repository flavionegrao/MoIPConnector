//
//  MoIPAmount.m
//  MoIPConnector
//
//  Created by Flavio Negrão Torres on 17/07/15.
//  Copyright (c) 2015 Apetis. All rights reserved.
//

#import "MoIPAmount.h"

@implementation MoIPAmount

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
    
    _currency = dictionary[@"currency"];
    _fees = @([dictionary[@"fees"]floatValue]);
    _refunds = @([dictionary[@"refunds"]floatValue]);
    _liquid = @([dictionary[@"liquid"]floatValue]);
    _otherReceivers = @([dictionary[@"otherReceivers"]floatValue]);
    _total = @([dictionary[@"total"]floatValue]);
    
    NSDictionary* subtotal = dictionary[@"subtotals"];
    if (subtotal) {
        MoIPSubTotals subtotals;
        subtotals.shipping = [subtotal[@"shipping"]floatValue];
        subtotals.adition = [subtotal[@"adition"]floatValue];
        subtotals.discount = [subtotal[@"discount"]floatValue];
        subtotals.items = [subtotal[@"items"]floatValue];
        _subTotals = subtotals;
    }
}


- (BOOL) validateValuesWithError:(NSError**) error {
    //TODO: Implement it
    return YES;
}


- (NSDictionary*) dictionaryRepresentation {
    NSMutableDictionary* representation = [NSMutableDictionary dictionary];
    
    if (self.total) representation[@"total"] = self.total;
    if (self.fees) representation[@"fees"] = self.fees;
    if (self.refunds) representation[@"refunds"] = self.refunds;
    if (self.liquid) representation[@"liquid"] = self.liquid;
    if (self.otherReceivers) representation[@"otherReceivers"] = self.otherReceivers;
    if (self.currency) representation[@"currency"] = self.currency;
    if (self.subTotals.items > 0) {
        representation[@"subTotals"] = @{@"shipping":@(self.subTotals.shipping),
                                         @"adition":@(self.subTotals.adition),
                                         @"discount":@(self.subTotals.discount),
                                         @"items":@(self.subTotals.items)};
    }
    return [representation copy];
}

@end
