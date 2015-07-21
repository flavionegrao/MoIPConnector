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
    }
    
    return self;
}


- (void) populateWithDictionary:(NSDictionary*) dictionary {
    _links = dictionary[@"_links"];
    _createdAt = dictionary[@"createdAt"];
    _email = dictionary[@"email"];
    _fullname = dictionary[@"fullname"];
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
    NSMutableDictionary* representation = [NSMutableDictionary dictionary];
    
    if (self.ownId) representation[@"ownId"] = self.ownId;
    if (self.links) representation[@"_links"] = self.links;
    if (self.objectId) representation[@"id"] = self.objectId;
    if (self.fullname) representation[@"fullname"] = self.fullname;
    if (self.email) representation[@"email"] = self.email;
    if (self.createdAt) representation[@"createdAt"] = self.createdAt;
    if (self.taxDocument) representation[@"taxDocument"] = [self.taxDocument dictionaryRepresentation];
    
    
    return [representation copy];
}


- (NSString*) description {
    return [NSString stringWithFormat:@"%@ %@",
            [super description],
            [self dictionaryRepresentation]];
}

@end
