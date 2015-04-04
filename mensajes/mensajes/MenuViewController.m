//
//  MenuViewController.m
//  mensajes
//
//  Created by Carlos Guerrero on 4/3/15.
//  Copyright (c) 2015 grupoonce. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController () {

    UIColor *grayColor;
    UIColor *yellowColor;


}
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *optionsButtons;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@end

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
