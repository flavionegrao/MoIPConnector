//
//  NSNumber+MoIP.h
//  MoIPConnector
//
//  Created by Flavio Negrão Torres on 21/07/15.
//  Copyright (c) 2015 Apetis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (MoIP)

- (NSNumber*) cents;
+ (NSNumber*) numberWithCentsString:(NSString*) centsString;

@end
