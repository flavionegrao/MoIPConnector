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
    _myMoipToken = @"7HE7GESKFPYI7AWSKVOJOUQPYKZEL25C";
    _myMoipAccessKey = @"F815D2Y8NWRBNUCUKHNIAJIDABV7KIL0QT91EMXU";
    _myPublicKey = [self importPublicKey];
    
    NSAssert(_myMoipToken.length > 0 &&
             _myMoipAccessKey.length > 0 &&
             _myPublicKey,
             @"Config MoIP keys error");
    
    return YES;
}


- (NSString*) importPublicKey {
    NSString* path = [[NSBundle mainBundle] pathForResource:@"myPublicKey"
                                                     ofType:@"txt"];
    
    NSError* error;
    NSString *myPublicKey = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    
    if (!error) {
        return myPublicKey;
    } else {
        NSLog(@"Error: %@", error);
        return nil;
    }
}


@end