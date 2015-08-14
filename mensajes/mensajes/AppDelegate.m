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
#import <Parse/Parse.h>

@interface AppDelegate ()

@end


@implementation AppDelegate

NSString *const firebaseURLRoot = @"https://glaring-heat-1751.firebaseio.com/";

Firebase *userInfo;
NSString *url = @"https://glaring-heat-1751.firebaseio.com/";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    
        [Parse setApplicationId:@"RwxxnpNW9zRrZ0Bwpx0NxLXIaJy6BHdlMLjLdeyQ"
                  clientKey:@"MJ1FXYFTDKb6JqhfLP41kp5KeHjzFaE0WzKzCMTu"];
    
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    
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

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
        if (userInfo.authData) {
//            PFInstallation *currentInstallation = [PFInstallation currentInstallation];
//            [currentInstallation setDeviceTokenFromData:deviceToken];
//            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//            NSString *companysName = [prefs stringForKey:@"companysName"];
//            NSString *city = [prefs stringForKey:@"city"];
//            NSString *userName = [prefs stringForKey:@"userName"];
//    
//            currentInstallation[@"pushType"] = @"iOs";
//            currentInstallation[@"city"] = city;
//            currentInstallation[@"companysName"] = companysName;
//            currentInstallation[@"userName"] = userName;
//            currentInstallation[@"session"] = @"open";
//            currentInstallation.channels = @[@""];
//            [currentInstallation saveInBackground];
        }
    NSLog(@"sa1ae");
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
    NSLog(@"%@",userInfo);
}

@end
