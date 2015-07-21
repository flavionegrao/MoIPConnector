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

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _myMoipToken = @"";
    _myMoipAccessKey = @"";
    _myPublicKey = @"";
    
    NSAssert(_myMoipToken.length > 0 &&
             _myMoipAccessKey.length > 0 &&
             _myPublicKey,
             @"Config MoIP keys error");
    
    return YES;
}


@end