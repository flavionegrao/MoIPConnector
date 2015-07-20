//
//  MoIPTaxDocument.h
//  MoIPConnector
//
//  Created by Flavio Negrão Torres on 17/07/15.
//  Copyright (c) 2015 Apetis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MoIPSerializable.h"

typedef NS_ENUM(NSInteger, MoIPTaxDocumentType) {
    MoIPTaxDocumentTypeUnKwown,
    MoIPTaxDocumentTypeCPF
};


@interface MoIPTaxDocument : NSObject <MoIPSerializable>

@property (nonatomic, assign) MoIPTaxDocumentType type;
@property (nonatomic, strong) NSString* number;

@end
