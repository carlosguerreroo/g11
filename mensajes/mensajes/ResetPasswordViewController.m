//
//  ResetPasswordViewController.m
//  Grupo Once
//
//  Created by Carlos Guerrero on 5/20/15.
//  Copyright (c) 2015 grupoonce. All rights reserved.
//

#import "ResetPasswordViewController.h"

@interface ResetPasswordViewController () {
    NSString * userNameText;
    Firebase *ref;

}
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *updatePasswordButton;
@end

NSString *const fireUserURL = @"https://glaring-heat-1751.firebaseio.com/users/";

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;

    _updatePasswordButton.layer.cornerRadius = 4.0f;
    _updatePasswordButton.layer.masksToBounds= YES;

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    _usernameLabel.text = userNameText;
    [self setFirebase];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUsernameText: (NSString*) city {
    
    userNameText = city;
}

- (void)setFirebase {
    ref = [[Firebase alloc] initWithUrl:fireUserURL];

    [[[ref queryOrderedByChild:@"city"] queryEqualToValue:userNameText]
     observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
         
         
         for (NSString* key in snapshot.value) {
             
             if ([snapshot.value[key][@"companysName"] isEqualToString: @"grupoonce"]) {
             
                    _emailLabel.text = snapshot.value[key][@"userName"];
                    _passwordLabel.text = snapshot.value[key][@"password"];
                 return ;
             }

         }

        
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
