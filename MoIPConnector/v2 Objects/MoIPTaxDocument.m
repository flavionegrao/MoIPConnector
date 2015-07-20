//
//  MoIPTaxDocument.m
//  MoIPConnector
//
//  Created by Flavio Negrão Torres on 17/07/15.
//  Copyright (c) 2015 Apetis. All rights reserved.
//

#import "MoIPTaxDocument.h"


@implementation MoIPTaxDocument

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
    
    if (self.number) representation[@"number"] = self.number;
    
    if (self.type == MoIPTaxDocumentTypeUnKwown) {
        representation[@"type"] = @"UNKNOWN";
        
    } else if (self.type == MoIPTaxDocumentTypeCPF) {
         representation[@"type"] = @"CPF";
        
    } else {
        NSAssert(NO, @"Unexpected value");
    }
    
    return [representation copy];
}

@end
