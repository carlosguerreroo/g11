//
//  AppDelegate.m
//  mensajes
//
//  Created by Carlos Guerrero on 3/31/15.
//  Copyright (c) 2015 grupoonce. All rights reserved.
//

#import "AppDelegate.h"
#import "MenuViewController.h"
#import "ChatListViewController.h"
#import "ChatListNavViewController.h"
#import "MenuChatNavViewController.h"
#import "AdminNavViewController.h"

@interface AppDelegate ()

@end


@implementation AppDelegate

NSString *const firebaseURLRoot = @"https://glaring-heat-1751.firebaseio.com/";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

        
        Firebase *userInfo;
        NSString *url = @"https://glaring-heat-1751.firebaseio.com/";
        userInfo = [[Firebase alloc] initWithUrl: url];
        
        if (userInfo.authData) {
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            NSString *companysName = [prefs stringForKey:@"companysName"];
            NSString *city = [prefs stringForKey:@"city"];

            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            [self.window setBackgroundColor:[UIColor whiteColor]];
            [self.window makeKeyAndVisible];
                           
            if ([companysName isEqualToString:@"grupoonce"]) {
                
                if ([city isEqualToString:@"admin"]) {
                    
                    AdminNavViewController *adminNavViewController = (AdminNavViewController *)[storyboard instantiateViewControllerWithIdentifier:@"AdminNavViewController"];
                    [self.window setRootViewController :adminNavViewController];

                } else {
                    ChatListNavViewController *chatListViewController = (ChatListNavViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ChatListNavViewController"];
                    [self.window setRootViewController:chatListViewController];
                    
                }
                
            } else {
                
                MenuChatNavViewController *menuViewController = (MenuChatNavViewController *)[storyboard instantiateViewControllerWithIdentifier:@"MenuChatNavViewController"];
                [self.window setRootViewController:menuViewController];

            }
            
        } else {
            
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
