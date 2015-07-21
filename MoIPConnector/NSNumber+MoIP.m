//
//  NSNumber+MoIP.m
//  MoIPConnector
//
//  Created by Flavio Negrão Torres on 21/07/15.
//  Copyright (c) 2015 Apetis. All rights reserved.
//

#import "NSNumber+MoIP.h"

@implementation NSNumber (MoIP)

- (NSNumber*) cents {
    return @(ceil([self floatValue] * 100));
}

+ (NSNumber*) numberWithCentsString:(NSString*) centsString {
    return @([centsString floatValue] / 100);
}

@end
