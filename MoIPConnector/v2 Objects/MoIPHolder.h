//
//  MoIPHolder.h
//  MoIPConnector
//
//  Created by Flavio Negrão Torres on 17/07/15.
//  Copyright (c) 2015 Apetis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MoIPSerializable.h"

struct MoIPPhone {
    NSInteger countryCode;
    NSInteger areaCode;
    NSInteger number;
};
typedef struct MoIPPhone MoIPPhone;

static inline MoIPPhone MoIPPhoneMake(NSInteger countryCode, NSInteger areaCode, NSInteger number) {
    MoIPPhone phone;
    phone.countryCode = countryCode;
    phone.areaCode = areaCode;
    phone.number = number;
    return phone;
}


@class MoIPTaxDocument;
@class MoIPAddress;

@interface MoIPHolder : NSObject <MoIPSerializable>

#pragma mark - New Object Creation

/// Mandatory
@property (nonatomic, strong) NSString* fullname;

/// Mandatory for Venda Protegida
@property (nonatomic, strong) NSDate* birthdate;
@property (nonatomic, assign) MoIPPhone phone;
@property (nonatomic, strong) MoIPTaxDocument* taxDocument;
@property (nonatomic, strong) MoIPAddress* billingAddress;

@end
