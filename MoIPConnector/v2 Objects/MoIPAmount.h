//
//  MoIPAmount.h
//  MoIPConnector
//
//  Created by Flavio Negrão Torres on 17/07/15.
//  Copyright (c) 2015 Apetis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MoIPSerializable.h"

struct MoIPSubTotals {
    float shipping;
    float adition;
    float discount;
    float items;
};
typedef struct MoIPSubTotals MoIPSubTotals;

static inline MoIPSubTotals MoIPSubTotalsMake (float shipping, float adition, float discount,  float items) {
    MoIPSubTotals subTotals;
    subTotals.shipping = shipping;
    subTotals.adition = adition;
    subTotals.discount = discount;
    subTotals.items = items;
    return subTotals;
}


@interface MoIPAmount : NSObject <MoIPSerializable>

@property (nonatomic, strong) NSNumber* total;
@property (nonatomic, strong) NSNumber* fees;
@property (nonatomic, strong) NSNumber* refunds;
@property (nonatomic, strong) NSNumber* liquid;
@property (nonatomic, strong) NSNumber* otherReceivers;
@property (nonatomic, strong) NSString* currency;
@property (nonatomic, assign) MoIPSubTotals subTotals;

@end
