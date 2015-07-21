//
//  MoIPAddress.m
//  MoIPConnector
//
//  Created by Flavio Negrão Torres on 21/07/15.
//  Copyright (c) 2015 Apetis. All rights reserved.
//

#import "MoIPAddress.h"

@implementation MoIPAddress

- (instancetype) initWithDictionary:(NSDictionary*) dictionary {
    self = [super init];
    
    if (self && dictionary) {
        [self populateWithDictionary:dictionary];
    }
    
    return self;
}

- (void) populateWithDictionary:(NSDictionary*) dictionary {
    _street = dictionary[@"street"];
    _number = dictionary[@"number"];
    _complement = dictionary[@"complement"];
    _city = dictionary[@"city"];
    _state = dictionary[@"state"];
    _country = dictionary[@"country"];
    _zipcode = dictionary[@"zipcode"];
    _district = dictionary[@"district"];
}

- (BOOL) validateValuesWithError:(NSError**) error {
    //TODO: Implement it
    return YES;
}


- (NSDictionary*) dictionaryRepresentation {
    NSMutableDictionary* representation = [NSMutableDictionary dictionary];
    
    if (self.street) representation[@"street"] = self.street;
    if (self.number) representation[@"number"] = self.number;
    if (self.complement) representation[@"complement"] = self.complement;
    if (self.district) representation[@"district"] = self.district;
    if (self.city) representation[@"city"] = self.city;
    if (self.state) representation[@"state"] = self.state;
    if (self.country) representation[@"country"] = self.country;
    if (self.zipcode) representation[@"zipcode"] = self.zipcode;
    
    return [representation copy];
}

- (NSString*) description {
    return [NSString stringWithFormat:@"%@",[self dictionaryRepresentation]];
}

@end
