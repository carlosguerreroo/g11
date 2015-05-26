//
//  SendMessageViewController.m
//  mensajes
//
//  Created by Carlos Guerrero on 4/3/15.
//  Copyright (c) 2015 grupoonce. All rights reserved.
//

#import "SendMessageViewController.h"

@interface SendMessageViewController ()

@end

@implementation SendMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
