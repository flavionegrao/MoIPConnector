//
//  MoIPBoleto.m
//  MoIPConnector
//
//  Created by Flavio Negrão Torres on 17/07/15.
//  Copyright (c) 2015 Apetis. All rights reserved.
//

#import "MoIPBoleto.h"
#import "NSDate+MoIP.h"

@implementation MoIPBoleto

- (instancetype) initWithDictionary:(NSDictionary*) dictionary {
    self = [super init];
    
    if (self && dictionary) {
        [self populateWithDictionary:dictionary];
    }
    return self;
}

- (void) populateWithDictionary:(NSDictionary*) dictionary {
    //TODO
}



- (BOOL) validateValuesWithError:(NSError**) error {
    //TODO: Implement it
    return YES;
}


- (NSDictionary*) dictionaryRepresentation {
    NSMutableDictionary* representation = [NSMutableDictionary dictionary];
    
    if (self.expirationDate) {
        representation[@"expirationDate"] = [self.expirationDate stringUsingFormat:@"YYYY-MM-dd"];
    }
    
    NSMutableDictionary* instructionLines = [NSMutableDictionary new];
    if (self.firstInstructionLine) instructionLines[@"first"] = self.firstInstructionLine;
    
    if (self.secondInstructionLine) instructionLines[@"second"] = self.secondInstructionLine;
    
    if (self.thirdInstructionLine) instructionLines[@"third"] = self.thirdInstructionLine;
    
    representation[@"instructionLines"] = [instructionLines copy];
    
    
    return [representation copy];
}

- (NSString*) description {
    return [NSString stringWithFormat:@"%@",[self dictionaryRepresentation]];
}


@end
