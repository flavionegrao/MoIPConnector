//
//  MoIPPayment.m
//  MoIPConnector
//
//  Created by Flavio Negrão Torres on 17/07/15.
//  Copyright (c) 2015 Apetis. All rights reserved.
//

#import "MoIPPayment.h"
#import "MoIPFundingInstrument.h"
#import "MoIPAmount.h"
#import "NSDate+MoIP.h"
#import "MoIPFee.h"
#import "MoIPEvent.h"


@implementation MoIPPayment


#pragma mark - MoIPObject

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
    
    NSArray* feesArray = dictionary[@"fees"];
    if (feesArray) {
        NSMutableArray* fees = [[NSMutableArray alloc]initWithCapacity:feesArray.count];
        [feesArray enumerateObjectsUsingBlock:^(NSDictionary* feeDictionary, NSUInteger idx, BOOL *stop) {
            MoIPFee* fee = [[MoIPFee alloc]initWithDictionary:feeDictionary];
            [fees addObject:fee];
        }];
        _fees = [fees copy];
    }
    
    NSArray* eventsArray = dictionary[@"events"];
    if (eventsArray) {
        NSMutableArray* events = [[NSMutableArray alloc]initWithCapacity:eventsArray.count];
        [eventsArray enumerateObjectsUsingBlock:^(NSDictionary* eventDictionary, NSUInteger idx, BOOL *stop) {
            MoIPEvent* event = [[MoIPEvent alloc]initWithDictionary:eventDictionary];
            [events addObject:event];
        }];
        _events = [events copy];
    }
    
    _createdAt = [NSDate dateFromString:dictionary[@"createdAt"] withFormat:MoIPDateFormat];
    _updatedAt = [NSDate dateFromString:dictionary[@"updatedAt"] withFormat:MoIPDateFormat];
    _objectId = dictionary[@"id"];
    _status = dictionary[@"status"];
    _installmentCount = dictionary[@"installmentCount"];
    _links = dictionary[@"_links"];
}


- (NSString*) restEntryPoint {
    return @"payments";
}

- (BOOL) validateValuesWithError:(NSError**) error {
    //TODO: Implement it
    return YES;
}


- (NSDictionary*) dictionaryRepresentation {
    NSMutableDictionary* representation = [NSMutableDictionary dictionary];
    
    if (self.installmentCount) representation[@"installmentCount"] = self.installmentCount;
    if (self.fundingInstrument) representation[@"fundingInstrument"] = [self.fundingInstrument dictionaryRepresentation];
    
    if (self.createdAt) representation[@"createdAt"] = self.createdAt;
    if (self.updatedAt) representation[@"updatedAt"] = self.createdAt;
    if (self.objectId) representation[@"objectId"] = self.objectId;
    if (self.status) representation[@"status"] = self.status;
    if (self.links) representation[@"links"] = self.links;
    
    NSMutableArray* events = [[NSMutableArray alloc]initWithCapacity:self.events.count];
    [self.events enumerateObjectsUsingBlock:^(MoIPEvent* event, NSUInteger idx, BOOL *stop) {
        [events addObject:[event dictionaryRepresentation]];
    }];
    if (events) representation[@"events"] = [events copy];
    
    NSMutableArray* fees = [[NSMutableArray alloc]initWithCapacity:self.fees.count];
    [self.fees enumerateObjectsUsingBlock:^(MoIPFee* fee, NSUInteger idx, BOOL *stop) {
        [fees addObject:[fee dictionaryRepresentation]];
    }];
    if (fees) representation[@"events"] = [fees copy];
    
    if (self.amount) representation[@"amount"] = [self.amount dictionaryRepresentation];
    
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
