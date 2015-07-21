//
//  MoIPAddress.h
//  MoIPConnector
//
//  Created by Flavio Negrão Torres on 21/07/15.
//  Copyright (c) 2015 Apetis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MoIPSerializable.h"

@interface MoIPAddress : NSObject <MoIPSerializable>

@property (nonatomic, strong) NSString* street;
@property (nonatomic, strong) NSString* number;
@property (nonatomic, strong) NSString* complement;
@property (nonatomic, strong) NSString* district;
@property (nonatomic, strong) NSString* city;
@property (nonatomic, strong) NSString* state;
@property (nonatomic, strong) NSString* country;
@property (nonatomic, strong) NSString* zipcode;

@end
