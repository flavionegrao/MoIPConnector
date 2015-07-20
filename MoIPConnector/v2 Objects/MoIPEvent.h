//
//  MoIPEvent.h
//  MoIPConnector
//
//  Created by Flavio Negrão Torres on 17/07/15.
//  Copyright (c) 2015 Apetis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MoIPSerializable.h"

@interface MoIPEvent : NSObject <MoIPSerializable>

@property (nonatomic, strong) NSDate* createdAt;
@property (nonatomic, strong) NSString* eventDescription;
@property (nonatomic, strong) NSString* type;

@end
