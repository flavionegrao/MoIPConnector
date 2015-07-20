//
//  MoIPItem.h
//  MoIPConnector
//
//  Created by Flavio Negrão Torres on 17/07/15.
//  Copyright (c) 2015 Apetis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MoIPSerializable.h"

@interface MoIPItem : NSObject <MoIPSerializable>

@property (nonatomic, strong) NSString* detail;
@property (nonatomic, strong) NSNumber* quantity;
@property (nonatomic, strong) NSNumber* price;
@property (nonatomic, strong) NSString* product;

@end
