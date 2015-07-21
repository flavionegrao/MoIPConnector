//
//  MoIPAmount.m
//  MoIPConnector
//
//  Created by Flavio Negrão Torres on 17/07/15.
//  Copyright (c) 2015 Apetis. All rights reserved.
//

#import "MoIPAmount.h"
#import "NSNumber+MoIP.h"

@implementation MoIPAmount

- (instancetype) initWithDictionary:(NSDictionary*) dictionary {
    self = [super init];
    
    if (self && dictionary) {
        [self populateWithDictionary:dictionary];
    }
    
    return self;
}


- (void) populateWithDictionary:(NSDictionary*) dictionary {
    
    _currency = dictionary[@"currency"];
    _fees = [NSNumber numberWithCentsString:dictionary[@"fees"]];
    _refunds =[NSNumber numberWithCentsString:dictionary[@"refunds"]];
    _liquid = [NSNumber numberWithCentsString:dictionary[@"liquid"]];
    _otherReceivers = [NSNumber numberWithCentsString:dictionary[@"otherReceivers"]];
    _total = [NSNumber numberWithCentsString:dictionary[@"total"]];
    
    NSDictionary* subtotal = dictionary[@"subtotals"];
    if (subtotal) {
        MoIPSubTotals subtotals;
        subtotals.shipping = [NSNumber numberWithCentsString:subtotal[@"shipping"]].floatValue;
        subtotals.adition = [NSNumber numberWithCentsString:subtotal[@"adition"]].floatValue;
        subtotals.discount = [NSNumber numberWithCentsString:subtotal[@"discount"]].floatValue;
        subtotals.items = [NSNumber numberWithCentsString:subtotal[@"items"]].floatValue;
        _subTotals = subtotals;
    }
}


- (BOOL) validateValuesWithError:(NSError**) error {
    //TODO: Implement it
    return YES;
}


- (NSDictionary*) dictionaryRepresentation {
    NSMutableDictionary* representation = [NSMutableDictionary dictionary];
    
    if (self.total) representation[@"total"] = [self.total cents];
    if (self.fees) representation[@"fees"] = [self.fees cents];
    if (self.refunds) representation[@"refunds"] = [self.refunds cents];
    if (self.liquid) representation[@"liquid"] = [self.liquid cents];
    if (self.otherReceivers) representation[@"otherReceivers"] = [self.otherReceivers cents];
    if (self.currency) representation[@"currency"] = self.currency;
    if (self.subTotals.items > 0) {
        representation[@"subTotals"] = @{@"shipping":[@(self.subTotals.shipping)cents],
                                         @"adition":[@(self.subTotals.adition)cents],
                                         @"discount":[@(self.subTotals.discount)cents],
                                         @"items":[@(self.subTotals.items)cents]};
    }
    return [representation copy];
}

- (NSString*) description {
    return [NSString stringWithFormat:@"%@ %@",[super description],[self dictionaryRepresentation]];
}

@end
