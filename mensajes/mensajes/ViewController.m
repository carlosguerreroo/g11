//
//  ViewController.m
//  mensajes
//
//  Created by Carlos Guerrero on 3/31/15.
//  Copyright (c) 2015 grupoonce. All rights reserved.
//

#import "ViewController.h"
#import "MenuViewController.h"

@interface ViewController () {
    
    NSArray *_pickerData;
    NSArray *_socialUrl;
    UIColor *grayColor;
    UIColor *yellowColor;
    NSString *error1;
    NSString *error2;
}

@property (weak, nonatomic) IBOutlet UIView *signup;
@property (weak, nonatomic) IBOutlet UIView *login;
@property (weak, nonatomic) IBOutlet UIView *header;
@property (weak, nonatomic) IBOutlet UIView *selector;
@property (weak, nonatomic) IBOutlet UIPickerView *cities;
@property (weak, nonatomic) IBOutlet UISegmentedControl *viewSelector;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;


// Signup items
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *signupItems;
// Login items
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *loginItems;

@end

NSString *const firebaseURL = @"https://glaring-heat-1751.firebaseio.com";

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self signup].hidden = NO;
    [self login].hidden = YES;
    
    _pickerData = @[@"Monterrey", @"Guadalajara", @"Queretaro"];
    _socialUrl = @[@"https://www.facebook.com/grupoONCE11",
                   @"https://twitter.com/grupoONCE11",
                   @"https://www.youtube.com/user/grupo11ONCE"];
    grayColor = [UIColor colorWithRed:0.651 green:0.651 blue:0.651 alpha:1];
    yellowColor = [UIColor colorWithRed:0.996 green:0.761 blue:0.133 alpha:1];

    self.cities.dataSource = self;
    self.cities.delegate = self;
    
    //Setting background color
    self.signup.backgroundColor = grayColor;
    self.login.backgroundColor = grayColor;
    self.header.backgroundColor = [UIColor blackColor];
    self.selector.backgroundColor = grayColor;
    
    self.viewSelector.tintColor = yellowColor;
    
    for (UITextField *object in self.signupItems) {
        object.layer.cornerRadius = 4.0f;
        object.layer.masksToBounds= YES;
        object.layer.borderColor = [yellowColor CGColor];
        object.layer.borderWidth = 1.5f;
	}
    
    for (UITextField *object in self.loginItems) {
        object.layer.cornerRadius = 4.0f;
        object.layer.masksToBounds= YES;
        object.layer.borderColor = [yellowColor CGColor];
        object.layer.borderWidth = 1.5f;
    }
    
    
    self.signupButton.backgroundColor = yellowColor;
    self.signupButton.layer.cornerRadius = 4.0f;
    
    self.loginButton.backgroundColor = yellowColor;
    self.loginButton.layer.cornerRadius = 4.0f;
    
    error1 = @"";
    error2 = @"";
    
    ((UITextField*)_loginItems[1]).secureTextEntry = YES;
    ((UITextField*)_signupItems[2]).secureTextEntry = YES;
    ((UITextField*)_signupItems[3]).secureTextEntry = YES;

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)changeView:(UISegmentedControl *)sender {

    switch (sender.selectedSegmentIndex)
    {
        case 0:
            self.signup.hidden = YES;
            self.login.hidden = NO;
            break;
        case 1:

            self.signup.hidden = NO;
            self.login.hidden = YES;
            break;
        default:
            break; 
    }
}
- (IBAction)displaySocialNetwork:(id)sender {
    
    NSInteger index = ((UIButton *)sender).tag;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:  _socialUrl[index]]];
}


// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pickerData[row];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (IBAction)loginOrSignup:(id)sender {
    
    // Login
    if (_viewSelector.selectedSegmentIndex == 0) {
       
        Firebase *ref = [[Firebase alloc] initWithUrl:firebaseURL];
        
        
        NSString *username = ((UITextField *) _loginItems[0]).text;
        NSString *password = ((UITextField *) _loginItems[1]).text;
        
        [ref authUser:username password:password
                withCompletionBlock:^(NSError *error, FAuthData *authData) {
      
      if (error) {
          // an error occurred while attempting login
          NSLog(@"Not logged with credentials %@ %@",username,password);

      } else {
          // user is logged in, check authData for data
          NSLog(@"User logged");
          
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MenuViewController *menuViewController = (MenuViewController *)[storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
          [self presentViewController:menuViewController animated:YES completion:nil];
      }
  }];
    } else {
     
        NSString *messageText;
        NSString *titleText;
        
        if ([self validatesSignUp]) {
            
            [self.viewSelector  setSelectedSegmentIndex:0];
            self.signup.hidden = YES;
            self.login.hidden = NO;
            titleText = @"Datos registrados.";
            messageText = @"La cuenta ha sido creada exitosamente.";
        } else {
            
            titleText = @"Verifique sus datos.";
            messageText = [NSString stringWithFormat:@"%@ \n %@", error1, error2];
            
        }
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:titleText
                                                          message:messageText
                                                         delegate:nil
                                                cancelButtonTitle:@"Aceptar"
                                                otherButtonTitles:nil];
        
        [message show];
    }
}

- (BOOL) validatesSignUp {
    
    NSString *password1;
    BOOL flag = YES;
    
    for (UITextField *object in self.signupItems) {
        
        
        if  ([[object.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length] == 0) {
                
            flag = NO;
            error1 = @"Ningún campo puede estar vació.";
        }
        
        if (object.tag == 2) {
            
            password1 = object.text;
        }
        
        if (object.tag == 3 && password1 != object.text) {
            
            flag = NO;
            error2 = @"Las contraseñas deben de ser iguales.";
            object.text = @"";
            UITextField *passfield = self.signupItems[2];
            passfield.text = @"";

        }
        
    }
    
    return flag;
}

@end
