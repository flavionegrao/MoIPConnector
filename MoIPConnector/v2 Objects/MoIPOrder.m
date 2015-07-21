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
#import "MoIPEvent.h"
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

    _amount = [[MoIPAmount alloc]initWithDictionary:dictionary[@"amount"]];
    _customer = [[MoIPCustomer alloc]initWithDictionary:dictionary[@"customer"]];
    
    NSArray* itemsArray = dictionary[@"items"];
    NSMutableArray* items = [[NSMutableArray alloc]initWithCapacity:itemsArray.count];
    [itemsArray enumerateObjectsUsingBlock:^(NSDictionary* itemDictionary, NSUInteger idx, BOOL *stop) {
        MoIPItem* item = [[MoIPItem alloc]initWithDictionary:itemDictionary];
        [items addObject:item];
    }];
    _items = [items copy];
    
    NSArray* eventsArray = dictionary[@"events"];
    NSMutableArray* events = [[NSMutableArray alloc]initWithCapacity:eventsArray.count];
    [eventsArray enumerateObjectsUsingBlock:^(NSDictionary* eventDictionary, NSUInteger idx, BOOL *stop) {
        MoIPEvent* event = [[MoIPEvent alloc]initWithDictionary:eventDictionary];
        [events addObject:event];
    }];
    _events = [events copy];
    
    _createdAt = [NSDate dateFromString:dictionary[@"createdAt"] withFormat:MoIPDateFormat];
    _objectId = dictionary[@"id"];
    _ownId = dictionary[@"ownId"];
    _status = dictionary[@"status"];
    _links = dictionary[@"links"];
    
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
    NSMutableDictionary* representation = [NSMutableDictionary dictionary];
    
    NSMutableArray* items = [[NSMutableArray alloc]initWithCapacity:self.items.count];
    [self.items enumerateObjectsUsingBlock:^(MoIPItem* item, NSUInteger idx, BOOL *stop) {
        [items addObject:[item dictionaryRepresentation]];
    }];
    if (items.count > 0) representation[@"items"] = [items copy];
    
    NSMutableArray* events = [[NSMutableArray alloc]initWithCapacity:self.events.count];
    [self.events enumerateObjectsUsingBlock:^(MoIPItem* item, NSUInteger idx, BOOL *stop) {
        [events addObject:[item dictionaryRepresentation]];
    }];
    if (events.count > 0) representation[@"events"] = [events copy];
    
    if (self.customer) representation[@"customer"] = [self.customer dictionaryRepresentation];
    if (self.amount) representation[@"amount"] = [self.amount dictionaryRepresentation];
    
    if (self.ownId) representation[@"ownId"] = self.ownId;
    if (self.links) representation[@"_links"] = self.links;
    if (self.status) representation[@"status"] = self.status;
    if (self.objectId) representation[@"id"] = self.objectId;
    
    return [representation copy];
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
    return [NSString stringWithFormat:@"%@ %@",[super description],[self dictionaryRepresentation]];
}

@end

