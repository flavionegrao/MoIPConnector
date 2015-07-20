//
//  NSDate+MoIP.m
//  MoIPConnector
//
//  Created by Flavio Negrão Torres on 17/07/15.
//  Copyright (c) 2015 Apetis. All rights reserved.
//

#import "NSDate+MoIP.h"

@implementation NSDate (MoIP)

NSString* const MoIPDateFormat = @"yyyy'-'MM'-'dd'T'HH':'mm':'ssZ";

+ (NSDateFormatter*) currentLocalFormatter {
    static NSDateFormatter* formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc]init];
        //NSLocale *brLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"pt_BR"];
        [formatter setLocale:[NSLocale currentLocale]];
    });
    return formatter;
}

- (NSString*) stringUsingFormat:(NSString*) format {
    NSDateFormatter* formatter = [NSDate currentLocalFormatter];
    formatter.dateFormat = format;
    return [formatter stringFromDate:self];
}

+ (NSDate*) dateFromString:(NSString *)dateString withFormat:(NSString*) format {
    NSDateFormatter* formatter = [NSDate currentLocalFormatter];
    formatter.dateFormat = format;
    return [formatter dateFromString:dateString];
}

@end
