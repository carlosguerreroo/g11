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
    NSString *userId;

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
    NSLog(@"%@",userNameText);
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
    barButton.title = @"Atrás";
    self.navigationController.navigationBar.topItem.backBarButtonItem = barButton;

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    _usernameLabel.text = userNameText;
    [self setFirebase];
    _passwordTextField.text = @"";
    [self.navigationController setNavigationBarHidden:NO animated:animated];

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
                 
                    userId = key;
                    _emailLabel.text = snapshot.value[key][@"userName"];
                    _passwordLabel.text = snapshot.value[key][@"password"];
                 return ;
             }

         }

        
    }];
}
- (IBAction)changePassword:(id)sender {


    Firebase *refPa = [[Firebase alloc] initWithUrl:@"https://glaring-heat-1751.firebaseio.com"];
    
    [refPa changePasswordForUser:_emailLabel.text fromOld:_passwordLabel.text
                         toNew:_passwordTextField.text withCompletionBlock:^(NSError *error) {
                             if (error) {
                                 // There was an error processing the request
                                 
                                 UIAlertController *alertController = [UIAlertController
                                                                       alertControllerWithTitle:@"Ocurrió un error."
                                                                       message:@"Intente mas tarde"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
                                 UIAlertAction* accept = [UIAlertAction
                                                          actionWithTitle:@"Aceptar"
                                                          style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                                          {
                                                              [alertController dismissViewControllerAnimated:YES completion:nil];
                                                              
                                                          }];
                                 
                                 [alertController addAction:accept];
                                 
                                 [self presentViewController:alertController animated:YES completion:nil];
                                 
                             } else {
                                 // Password changed successfully
                                 
                                 Firebase *hopperRef = [ref childByAppendingPath: userId];
                                 
                                 NSDictionary *userPassword = @{
                                                            @"password": _passwordTextField.text,
                                                            };
                                 
                                 [hopperRef updateChildValues: userPassword withCompletionBlock:^(NSError *error, Firebase *ref) {
                                     
                                     if (error == nil) {
                                         
                                         UIAlertController *alertController = [UIAlertController
                                                                               alertControllerWithTitle:@"El password se ha cambiado con exitó."
                                                                               message:@""
                                                                               preferredStyle:UIAlertControllerStyleAlert];
                                         UIAlertAction* accept = [UIAlertAction
                                                                  actionWithTitle:@"Aceptar"
                                                                  style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action)
                                                                  {
                                                                      [alertController dismissViewControllerAnimated:YES completion:nil];
                                                                      
                                                                  }];
                                         
                                         [alertController addAction:accept];
                                         
                                         [self presentViewController:alertController animated:YES completion:nil];
                                         _passwordLabel.text = _passwordTextField.text;
                                         _passwordTextField.text = @"";
                                     }
                                 }];
                             }
                         }];
}


@end
