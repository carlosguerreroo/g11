//
//  MenuViewController.m
//  mensajes
//
//  Created by Carlos Guerrero on 4/3/15.
//  Copyright (c) 2015 grupoonce. All rights reserved.
//

#import "MenuViewController.h"
#import "ViewController.h"

@interface MenuViewController () {

    UIColor *grayColor;
    UIColor *yellowColor;
    NSArray *_socialUrl;
    Firebase *ref;
    


}
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *optionsButtons;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@end

NSString *const fireURL = @"https://glaring-heat-1751.firebaseio.com";

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    yellowColor = [UIColor colorWithRed:0.996 green:0.761 blue:0.133 alpha:1];

    
    for (UITextField *object in self.optionsButtons) {
        object.layer.cornerRadius = 4.0f;
        object.layer.masksToBounds= YES;
        object.layer.borderColor = [yellowColor CGColor];
        object.layer.borderWidth = 1.5f;
        object.backgroundColor = yellowColor;
    }
    _logoutButton.layer.cornerRadius = 4.0f;
    _logoutButton.layer.masksToBounds= YES;
    _logoutButton.layer.borderWidth = 1.5f;
    
    _socialUrl = @[@"https://www.facebook.com/grupoONCE11",
                   @"https://twitter.com/grupoONCE11",
                   @"https://www.youtube.com/user/grupo11ONCE"];
    ref = [[Firebase alloc] initWithUrl:fireURL];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
    barButton.title = @"Atrás";
    self.navigationController.navigationBar.topItem.backBarButtonItem = barButton;

}

-(void) viewWillAppear: (BOOL) animated {

    [[self navigationController] setNavigationBarHidden:YES animated:YES];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (IBAction)displaySocialNetwork:(id)sender {
    
    NSInteger index = ((UIButton *)sender).tag;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:  _socialUrl[index]]];
}
- (IBAction)logOut:(id)sender {
    
    [ref unauth];

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject: @"" forKey:@"companysName"];
    [prefs setObject: @"" forKey:@"city"];
    [prefs setObject: @"" forKey:@"userName"];
    [prefs synchronize];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *menuViewController = (ViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    [self presentViewController:menuViewController animated:YES completion:nil];

}
@end
