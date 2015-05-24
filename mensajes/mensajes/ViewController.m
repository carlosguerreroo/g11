//
//  ViewController.m
//  mensajes
//
//  Created by Carlos Guerrero on 3/31/15.
//  Copyright (c) 2015 grupoonce. All rights reserved.
//

#import "ViewController.h"
#import "MenuViewController.h"
#import "ChatListViewController.h"
#import "ChatListNavViewController.h"
#import "MenuChatNavViewController.h"
#import "AdminNavViewController.h"

@interface ViewController () {
    
    NSArray *_pickerData;
    NSArray *_socialUrl;
    UIColor *grayColor;
    UIColor *yellowColor;
    NSString *error1;
    NSString *error2;
    Firebase *ref;

}

@property (weak, nonatomic) IBOutlet UIView *login;
@property (weak, nonatomic) IBOutlet UIView *header;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;


// Login items
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *loginItems;

@end

NSString *const firebaseURL = @"https://glaring-heat-1751.firebaseio.com";

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self login].hidden = NO;
    
    _pickerData = @[@"Monterrey", @"Guadalajara", @"Queretaro"];
    _socialUrl = @[@"https://www.facebook.com/grupoONCE11",
                   @"https://twitter.com/grupoONCE11",
                   @"https://www.youtube.com/user/grupo11ONCE"];
    grayColor = [UIColor colorWithRed:0.651 green:0.651 blue:0.651 alpha:1];
    yellowColor = [UIColor colorWithRed:0.996 green:0.761 blue:0.133 alpha:1];

    
    //Setting background color
    self.login.backgroundColor = grayColor;
    self.header.backgroundColor = [UIColor blackColor];
    
    
    for (UITextField *object in self.loginItems) {
        object.layer.cornerRadius = 4.0f;
        object.layer.masksToBounds= YES;
        object.layer.borderColor = [yellowColor CGColor];
        object.layer.borderWidth = 1.5f;
    }
    
    
    self.loginButton.backgroundColor = yellowColor;
    self.loginButton.layer.cornerRadius = 4.0f;
    
    error1 = @"";
    error2 = @"";
    
    ((UITextField*)_loginItems[1]).secureTextEntry = YES;
    ref = [[Firebase alloc] initWithUrl:firebaseURL];
    [self.view endEditing:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)changeView:(UISegmentedControl *)sender {

    switch (sender.selectedSegmentIndex)
    {
        case 0:
            self.login.hidden = NO;
            break;
        case 1:

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

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pickerData[row];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (IBAction)loginOrSignup:(id)sender {
    
        NSString *username = ((UITextField *) _loginItems[0]).text;
        NSString *password = ((UITextField *) _loginItems[1]).text;
        
        if ([self stringIsEmpty: username] || [self stringIsEmpty: password] ) {
            

            [self displayAlertWith: @"Verifique sus datos."
                               And: @"Ningún campo tiene que estar vació."];

            return;
        }
        
        [ref authUser:username password:password
                withCompletionBlock:^(NSError *error, FAuthData *authData) {
      
            if (error) {
                // an error occurred while attempting login
                NSLog(@"Not logged with credentials %@ %@",username,password);

            } else {
                // user is logged in, check authData for data
                NSLog(@"User logged");
                
                NSString *userPath = [NSString stringWithFormat:@"/users/%@", authData.uid];
                [[ref childByAppendingPath:userPath]observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
                    
                    NSString *companysName = snapshot.value[@"companysName"];
                    NSString *city = snapshot.value[@"city"];
                    NSString *userName = snapshot.value[@"userName"];
                    
                    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                    
                    [prefs setObject: companysName forKey:@"companysName"];
                    [prefs setObject: city forKey:@"city"];
                    [prefs setObject: userName forKey:@"userName"];
                    
                    [prefs synchronize];

                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

                    if ([companysName isEqualToString:@"grupoonce"]) {
                       
                        if ([city isEqualToString:@"admin"]) {
                            
                            AdminNavViewController *adminNavViewController = (AdminNavViewController *)[storyboard instantiateViewControllerWithIdentifier:@"AdminNavViewController"];
                            [self presentViewController:adminNavViewController animated:YES completion:nil];
                            
                        } else {
                            ChatListNavViewController *chatListViewController = (ChatListNavViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ChatListNavViewController"];
                            [self presentViewController:chatListViewController animated:YES completion:nil];
                            
                        }

                    } else {
                        MenuChatNavViewController *menuViewController = (MenuChatNavViewController *)[storyboard instantiateViewControllerWithIdentifier:@"MenuChatNavViewController"];
                        [self presentViewController:menuViewController animated:YES completion:nil];
                    }

                }];
                

            }
        }];
}


-(BOOL) stringIsEmpty: (NSString*) object {

    return ([[object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length] == 0);
}

-(void) displayAlertWith: (NSString*) title And: (NSString*) message {
    
    UIAlertView *alertMessage = [[UIAlertView alloc] initWithTitle:title
                                                      message:message
                                                     delegate:nil
                                            cancelButtonTitle:@"Aceptar"
                                            otherButtonTitles:nil];
    [alertMessage show];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self view] endEditing:YES];
}
@end
