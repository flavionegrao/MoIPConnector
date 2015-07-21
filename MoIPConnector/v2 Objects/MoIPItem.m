//
//  MoIPItem.m
//  MoIPConnector
//
//  Created by Flavio Negrão Torres on 17/07/15.
//  Copyright (c) 2015 Apetis. All rights reserved.
//

#import "MoIPItem.h"
#import "NSNumber+MoIP.h"

@implementation MoIPItem

- (instancetype) initWithDictionary:(NSDictionary*) dictionary {
    self = [super init];
    
    if (self && dictionary) {
        [self populateWithDictionary:dictionary];
    }
    
    return self;
}

- (BOOL) validateValuesWithError:(NSError**) error {
    //TODO: Implement it
    return YES;
}


- (void) populateWithDictionary:(NSDictionary*) dictionary {
    _detail = dictionary[@"detail"];
    _price = [NSNumber numberWithCentsString:dictionary[@"price"]];
    _product = dictionary[@"product"];
    _quantity = @([dictionary[@"quantity"]floatValue]);
}


- (NSDictionary*) dictionaryRepresentation {
    return @{@"detail":self.detail,
             @"quantity":self.quantity,
             @"price":[self.price cents],
             @"product":self.product
             };
}

- (NSString*) description {
    return [NSString stringWithFormat:@"%@ %@",
            [super description],
            [self dictionaryRepresentation]];
}

@end
