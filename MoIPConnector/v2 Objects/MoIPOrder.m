//
//  MoIPOrder.m
//  MoIPConnector
//
//  Created by Flavio Negrão Torres on 17/07/15.
//  Copyright (c) 2015 Apetis. All rights reserved.
//

#import "MoIPOrder.h"
#import "MoIPCustomer.h"
#import "MoIPItem.h"
#import "MoIPAmount.h"
#import "NSDate+MoIP.h"

@implementation MoIPOrder

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
    NSDictionary* amountDictionaty = dictionary[@"amount"];
    if (amountDictionaty) {
        _amount = [[MoIPAmount alloc]initWithDictionary:dictionary[@"amount"]];
    }
    
    NSDictionary* customerDictionaty = dictionary[@"customer"];
    if (customerDictionaty) {
        _customer = [[MoIPCustomer alloc]initWithDictionary:dictionary[@"customer"]];
    }
    
    NSArray* itemsArray = dictionary[@"items"];
    if (itemsArray) {
        NSMutableArray* items = [[NSMutableArray alloc]initWithCapacity:itemsArray.count];
        [itemsArray enumerateObjectsUsingBlock:^(NSDictionary* itemDictionary, NSUInteger idx, BOOL *stop) {
            MoIPItem* item = [[MoIPItem alloc]initWithDictionary:itemDictionary];
            [items addObject:item];
        }];
        _items = [items copy];
    }
    
    _createdAt = [NSDate dateFromString:dictionary[@"createdAt"] withFormat:MoIPDateFormat];
    _objectId = dictionary[@"id"];
    _ownId = dictionary[@"ownId"];
    _status = dictionary[@"status"];
    
    //TODO
    _receivers = nil;
    _payments = nil;
    _refunds = nil;
}


- (NSString*) restEntryPoint {
    return @"orders";
}


- (BOOL) validateValuesWithError:(NSError**) error {
    return YES;
}


- (NSDictionary*) dictionaryRepresentation {
    
    NSMutableArray* items;
    if (self.items) {
        items = [[NSMutableArray alloc]initWithCapacity:self.items.count];
        [self.items enumerateObjectsUsingBlock:^(MoIPItem* item, NSUInteger idx, BOOL *stop) {
            [items addObject:[item dictionaryRepresentation]];
        }];
    }
    
    return @{@"ownId":self.ownId,
             @"items":[items copy] ?:[NSNull null],
             @"customer":[self.customer dictionaryRepresentation]
             };
}


- (NSData*) jsonData {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self dictionaryRepresentation]
                                                       options:0
                                                         error:&error];
    if (!error) {
        return jsonData;
    } else {
        NSLog(@"Error: %@",error);
        return nil;
    }
}

- (NSString*) description {
    return [NSString stringWithFormat:@"%@ %@",
            [super description],
            [self dictionaryRepresentation]];
}

@end

