//
//  ChatListViewController.m
//  mensajes
//
//  Created by Carlos Guerrero on 5/15/15.
//  Copyright (c) 2015 grupoonce. All rights reserved.
//

#import "ChatListViewController.h"

@interface ChatListViewController () {
    NSString *city;

}

@property (weak, nonatomic) IBOutlet UIButton *logOutButton;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageCounterLabel;

@end

@implementation ChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _logOutButton.layer.cornerRadius = 4.0f;
    _logOutButton.layer.masksToBounds= YES;
    
    _messageCounterLabel.text = @"0";

    [self configureUser];

    _usernameLabel.text = city;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (IBAction)logOut:(id)sender {
}

-(void)configureUser {

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
     city = [prefs stringForKey:@"city"];
}
@end
