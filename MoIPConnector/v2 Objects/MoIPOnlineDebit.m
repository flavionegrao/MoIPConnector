//
//  MoIPOnlineDebit.m
//  MoIPConnector
//
//  Created by Flavio Negrão Torres on 17/07/15.
//  Copyright (c) 2015 Apetis. All rights reserved.
//

#import "MoIPOnlineDebit.h"

@implementation MoIPOnlineDebit

- (instancetype) initWithDictionary:(NSDictionary*) dictionary {
    self = [super init];
    
    if (self && dictionary) {
        [self populateWithDictionary:dictionary];
    }
    return self;
}


- (void) populateWithDictionary:(NSDictionary*) dictionary {
#warning TO BE IMPLEMENTED
}



- (BOOL) validateValuesWithError:(NSError**) error {
    #warning TO BE IMPLEMENTED
    return YES;
}


- (NSDictionary*) dictionaryRepresentation {
    NSMutableDictionary* representation = [NSMutableDictionary dictionary];
    #warning TO BE IMPLEMENTED
    
    return [representation copy];
}

- (NSString*) description {
    return [NSString stringWithFormat:@"%@",[self dictionaryRepresentation]];
}


@end
