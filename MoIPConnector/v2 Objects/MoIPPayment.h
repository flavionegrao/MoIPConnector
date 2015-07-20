//
//  MoIPPayment.h
//  MoIPConnector
//
//  Created by Flavio Negrão Torres on 17/07/15.
//  Copyright (c) 2015 Apetis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MoIPObject.h"
#import "MoIPSerializable.h"

@class MoIPAmount;
@class MoIPFundingInstrument;

@interface MoIPPayment : NSObject <MoIPObject,MoIPSerializable>

@property (nonatomic, strong) NSString* objectId;
@property (nonatomic, strong) NSDate* createdAt;
@property (nonatomic, strong) NSDate* updatedAt;
@property (nonatomic, strong) NSString* status;
@property (nonatomic, strong) MoIPAmount* amount;
@property (nonatomic, strong) NSNumber* installmentCount;
@property (nonatomic, strong) MoIPFundingInstrument* fundingInstrument;
@property (nonatomic, strong) NSArray* fees;
@property (nonatomic, strong) NSArray* events;
@property (nonatomic, strong) NSDictionary* links;

- (NSData*) jsonData;

@end
