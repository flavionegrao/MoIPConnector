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
    
    // MoIP Token e Access Key
    _myMoipToken = @"";
    _myMoipAccessKey = @"";
    
    NSAssert(_myMoipToken.length > 0 && _myMoipAccessKey.length > 0, @"Inclua seu token e access key do MoIP");
    
    return YES;
}


@end
