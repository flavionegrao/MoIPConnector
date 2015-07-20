//
//  MoIPHolder.m
//  MoIPConnector
//
//  Created by Flavio Negrão Torres on 17/07/15.
//  Copyright (c) 2015 Apetis. All rights reserved.
//

#import "MoIPHolder.h"
#import "MoIPTaxDocument.h"
#import "NSDate+MoIP.h"

@implementation MoIPHolder

- (instancetype) init {
      self = [super init];
    if (self) {
        _phone.countryCode = 0;
    }
    return self;
}

- (instancetype) initWithDictionary:(NSDictionary*) dictionary {
    self = [super init];
    
    if (self && dictionary) {
        [self populateWithDictionary:dictionary];
    } else {
        NSAssert(NO, @"Ops...");
    }
    
    return self;
}

- (void) populateWithDictionary:(NSDictionary*) dictionary {
    
}



- (BOOL) validateValuesWithError:(NSError**) error {
    //TODO: Implement it
    return YES;
}


- (NSDictionary*) dictionaryRepresentation {
    NSMutableDictionary* representation = [NSMutableDictionary dictionary];
    
    if (self.fullname) representation[@"fullname"] = self.fullname;
    if (self.birthdate) {
        representation[@"birthdate"] = [self.birthdate stringUsingFormat:@"YYYY-MM-dd"];
    }
    if (self.taxDocument) representation[@"taxDocument"] = [self.taxDocument dictionaryRepresentation];
    if (self.phone.countryCode != 0){
        representation[@"phone"] = @{@"countryCode": [NSString stringWithFormat:@"%ld", (long) self.phone.countryCode],
                                     @"areaCode":[NSString stringWithFormat:@"%ld", (long) self.phone.areaCode],
                                     @"number":[NSString stringWithFormat:@"%ld", (long) self.phone.number]};
    }
    
    return [representation copy];
}

- (NSString*) description {
    return [NSString stringWithFormat:@"%@",[self dictionaryRepresentation]];
}


@end
