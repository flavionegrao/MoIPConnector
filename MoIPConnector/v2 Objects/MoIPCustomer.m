//
//  MoIPCustomer.m
//  MoIPConnector
//
//  Created by Flavio Negrão Torres on 17/07/15.
//  Copyright (c) 2015 Apetis. All rights reserved.
//

#import "MoIPCustomer.h"
#import "MoIPTaxDocument.h"

@implementation MoIPCustomer

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
    _links = dictionary[@"_links"];
    _createdAt = dictionary[@"createdAt"];
    _email = dictionary[@"email"];
    _fullName = dictionary[@"fullName"];
    _objectId = dictionary[@"id"];
    
    NSDictionary* taxDocumentDictionary = dictionary[@"taxDocument"];
    if (taxDocumentDictionary) {
        MoIPTaxDocument* taxDocument = [MoIPTaxDocument new];
        if ([taxDocumentDictionary[@"type"] isEqualToString:@"UNKNOWN"]) {
            taxDocument.type = MoIPTaxDocumentTypeUnKwown;
            
        } else if ([taxDocumentDictionary[@"type"] isEqualToString:@"CPF"]) {
            taxDocument.type = MoIPTaxDocumentTypeCPF;
        }
        taxDocument.number = taxDocumentDictionary[@"number"];
        _taxDocument = taxDocument;
    }
    
}


- (NSString*) restEntryPoint {
    return @"customers";
}


- (BOOL) validateValuesWithError:(NSError**) error {
    return YES;
}


- (NSDictionary*) dictionaryRepresentation {
    return @{@"ownId":self.ownId,
             @"fullname":self.fullName,
             @"email":self.email
             };
}

@end
