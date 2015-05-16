//
//  QuestionsViewController.m
//  mensajes
//
//  Created by Carlos Guerrero on 4/3/15.
//  Copyright (c) 2015 grupoonce. All rights reserved.
//

#import "QuestionsViewController.h"

@interface QuestionsViewController () {
    
    NSArray *_socialUrl;
}

@end

@implementation QuestionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _socialUrl = @[@"https://www.facebook.com/grupoONCE11",
                   @"https://twitter.com/grupoONCE11",
                   @"https://www.youtube.com/user/grupo11ONCE"];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (IBAction)displaySocialNetwork:(id)sender {
    
    NSInteger index = ((UIButton *)sender).tag;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:  _socialUrl[index]]];
}

@end
