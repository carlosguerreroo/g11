//
//  AppDelegate.m
//  mensajes
//
//  Created by Carlos Guerrero on 3/31/15.
//  Copyright (c) 2015 grupoonce. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSString *const firebaseURL = @"https://glaring-heat-1751.firebaseio.com";

    Firebase *ref = [[Firebase alloc] initWithUrl:firebaseURL];
    
    if (ref.authData) {
        NSLog(@"%@", ref.authData);
    } else {
        // No user is logged in
        NSLog(@"Not user logged");

    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
   
}

@end
