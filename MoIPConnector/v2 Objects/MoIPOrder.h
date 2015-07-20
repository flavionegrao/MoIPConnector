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

@interface MoIPOrder : NSObject <MoIPObject,MoIPSerializable>

@property (nonatomic, strong) NSString* objectId;
@property (nonatomic, strong) NSString* ownId;
@property (nonatomic, strong) NSString* status;
@property (nonatomic, strong) NSDate* createdAt;
@property (nonatomic, strong) MoIPAmount* amount;
@property (nonatomic, strong) NSArray* items;
@property (nonatomic, strong) NSArray* payments;
@property (nonatomic, strong) NSArray* refunds;
@property (nonatomic, strong) NSArray* entries;
@property (nonatomic, strong) NSArray* events;
@property (nonatomic, strong) MoIPCustomer* customer;
@property (nonatomic, strong) NSArray* receivers;
@property (nonatomic, strong) NSDictionary* links;

- (NSData*) jsonData;

@end
