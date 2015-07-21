//
//  MoIPOrder.h
//  MoIPConnector
//
//  Created by Flavio Negrão Torres on 17/07/15.
//  Copyright (c) 2015 Apetis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MoIPObject.h"
#import "MoIPSerializable.h"

@class MoIPCustomer;
@class MoIPAmount;

@interface MoIPOrder : NSObject <MoIPObject, MoIPSerializable>

#pragma mark - New Object Creation

/// Mandatory
@property (nonatomic, strong) NSString* ownId;

/// Mandatory
@property (nonatomic, strong) MoIPCustomer* customer;

/// Mandatory at least 1
@property (nonatomic, strong) NSArray* items;

/// Mandatory
@property (nonatomic, strong) MoIPAmount* amount;


#pragma mark - Response
@property (nonatomic, strong) NSString* objectId;
@property (nonatomic, strong) NSString* status;
@property (nonatomic, strong) NSDate* createdAt;
@property (nonatomic, strong) NSArray* payments;
@property (nonatomic, strong) NSArray* refunds;
@property (nonatomic, strong) NSArray* entries;
@property (nonatomic, strong) NSArray* events;
@property (nonatomic, strong) NSArray* receivers;
@property (nonatomic, strong) NSDictionary* links;


#pragma mark - Helpers

/// Converts the object dictionary representaion in a JSON object
- (NSData*) jsonData;

@end
