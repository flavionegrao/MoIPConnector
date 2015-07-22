//
//  MoIPCreditCard.h
//  MoIPConnector
//
//  Created by Flavio Negrão Torres on 17/07/15.
//  Copyright (c) 2015 Apetis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MoIPSerializable.h"
#import <MoipSDK/MoipSDK.h>

@class MoIPHolder;

@interface MoIPCreditCard : MPKCreditCard <MoIPSerializable>

@property (nonatomic, strong) NSString* first6;
@property (nonatomic, strong) NSString* last4;
@property (nonatomic, strong) MoIPHolder* holder;
@property (nonatomic, strong) NSString* objectId;
@property (nonatomic, strong) NSString* brand;
@end
