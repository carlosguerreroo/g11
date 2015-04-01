//
//  ViewController.m
//  mensajes
//
//  Created by Carlos Guerrero on 3/31/15.
//  Copyright (c) 2015 grupoonce. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *signup;
@property (weak, nonatomic) IBOutlet UIView *login;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self signup].hidden = NO;
    [self login].hidden = YES;}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)changeView:(UISegmentedControl *)sender {

    switch (sender.selectedSegmentIndex)
    {
        case 0:
            [self signup].hidden = NO;
            [self login].hidden = YES;
            break;
        case 1:
            [self signup].hidden = YES;
            [self login].hidden = NO;
            break;
        default: 
            break; 
    }
}

@end
