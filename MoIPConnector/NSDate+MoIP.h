//
//  NSDate+MoIP.h
//  MoIPConnector
//
//  Created by Flavio Negrão Torres on 17/07/15.
//  Copyright (c) 2015 Apetis. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const MoIPDateFormat;

@interface NSDate (MoIP)

- (NSString*) stringUsingFormat:(NSString*) format;
+ (NSDate*) dateFromString:(NSString *)dateString withFormat:(NSString*) format;

@end
