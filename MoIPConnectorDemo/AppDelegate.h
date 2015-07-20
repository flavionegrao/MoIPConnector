//
//  Created by Flavio Negrão Torres
//
//  GitHub
//  https://github.com/flavionegrao/MoIPConnector/
//
//
//  License
//  Copyright (c) 2015 Flavio Torres
//  Released under an MIT license: http://opensource.org/licenses/MIT
//
#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong,readonly,nonatomic) NSString* myMoipToken;
@property (strong,readonly,nonatomic) NSString* myMoipAccessKey;
@property (strong,readonly,nonatomic) NSString* myPublicKey;


@end

