//
//  MoIPCustomer.h
//  MoIPConnector
//
//  Created by Flavio Negrão Torres on 17/07/15.
//  Copyright (c) 2015 Apetis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MoIPObject.h"
#import "MoIPSerializable.h"

@class MoIPTaxDocument;

@interface MoIPCustomer : NSObject <MoIPObject, MoIPSerializable>

@property (nonatomic, strong) NSString* objectId;
@property (nonatomic, strong) NSDate* createdAt;
@property (nonatomic, strong) NSString* ownId;
@property (nonatomic, strong) NSString* fullname;
@property (nonatomic, strong) NSString* email;
@property (nonatomic, strong) NSDictionary* links;
@property (nonatomic, strong) MoIPTaxDocument* taxDocument;

@end
