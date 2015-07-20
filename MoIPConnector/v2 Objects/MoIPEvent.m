//
//  MoIPEvent.m
//  MoIPConnector
//
//  Created by Flavio Negrão Torres on 17/07/15.
//  Copyright (c) 2015 Apetis. All rights reserved.
//

#import "MoIPEvent.h"
#import "NSDate+MoIP.h"

@implementation MoIPEvent

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
    _createdAt = [NSDate dateFromString:dictionary[@"createdAt"] withFormat:MoIPDateFormat];
    _type = dictionary[@"type"];
    _eventDescription = dictionary[@"eventDescription"];
    
}


- (BOOL) validateValuesWithError:(NSError**) error {
    //TODO: Implement it
    return YES;
}


- (NSDictionary*) dictionaryRepresentation {
    NSMutableDictionary* representation = [NSMutableDictionary dictionary];
    
    if (self.createdAt) representation[@"createdAt"] = [self.createdAt stringUsingFormat:MoIPDateFormat];
    if (self.type) representation[@"type"] = self.type;
    if (self.eventDescription) representation[@"eventDescription"] = self.eventDescription
        ;
    return [representation copy];
}


- (NSString*) description {
    return [NSString stringWithFormat:@"%@ %@",[super description],[self dictionaryRepresentation]];
}


@end
