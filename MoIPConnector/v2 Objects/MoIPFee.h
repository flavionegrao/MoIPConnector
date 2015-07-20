//
//  MoIPFee.h
//  MoIPConnector
//
//  Created by Flavio Negrão Torres on 17/07/15.
//  Copyright (c) 2015 Apetis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MoIPSerializable.h"

@interface MoIPFee : NSObject <MoIPSerializable>

@property (nonatomic, strong) NSString* type;
@property (nonatomic, strong) NSNumber* amount;

@end
