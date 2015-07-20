//
//  MoIPBoleto.h
//  MoIPConnector
//
//  Created by Flavio Negrão Torres on 17/07/15.
//  Copyright (c) 2015 Apetis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MoIPSerializable.h"

@interface MoIPBoleto : NSObject <MoIPSerializable>

@property (nonatomic, strong) NSDate* expirationDate;
@property (nonatomic, strong) NSString* firstInstructionLine;
@property (nonatomic, strong) NSString* secondInstructionLine;
@property (nonatomic, strong) NSString* thirdInstructionLine;

// Response
@property (nonatomic, strong) NSString* linecode;


@end
