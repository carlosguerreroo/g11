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
@property (weak, nonatomic) IBOutlet UISegmentedControl *viewSelector;


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
    self.header.backgroundColor = [UIColor blackColor];
    
    
    for (UITextField *object in self.loginItems) {
        object.layer.cornerRadius = 4.0f;
        object.layer.masksToBounds= YES;
        object.layer.borderColor = [yellowColor CGColor];
        object.layer.borderWidth = 1.5f;
        [object setDelegate:self];
    }
    
    
    self.loginButton.backgroundColor = yellowColor;
    self.loginButton.layer.cornerRadius = 4.0f;
    
    error1 = @"";
    error2 = @"";
    
    ((UITextField*)_loginItems[1]).secureTextEntry = YES;

    ref = [[Firebase alloc] initWithUrl:firebaseURL];
    [self.view endEditing:YES];
    ((UITextField*)_loginItems[2]).hidden = YES;
    ((UITextField*)_loginItems[2]).secureTextEntry = YES;

    
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

        if (_viewSelector.selectedSegmentIndex == 0) {

    
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
                
                        UIAlertController *alertController = [UIAlertController
                                                      alertControllerWithTitle:@"Ocurrió un error."
                                                      message:@"Verifica tu usario y contraseña"
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
        } else {
            
            NSString *titleText = @"Datos registrados.";
            NSString *messageText = @"La cuenta ha sido creada exitosamente.";

            if ([self validatesSignUp]) {
            
                [ref createUser: username password: password
       withValueCompletionBlock:^(NSError *error, NSDictionary *result) {
           if (error) {
               
               [self displayAlertWith: @"Error" And: @"Error al crear su cuenta."];
               
           } else {
               NSString *uid = [result objectForKey:@"uid"];
               NSLog(@"Successfully created user account with uid: %@", uid);
               
               [self.viewSelector  setSelectedSegmentIndex:0];
               [self displayAlertWith: titleText And: messageText];
               
               NSDictionary *newUser = @{
                                         @"userName": username,
                                         @"companysName": @"generic",
                                         @"city": @"generic",
                                         @"password": password
                                         };
               [[[ref childByAppendingPath:@"users"]
                 childByAppendingPath:uid] setValue:newUser];
               [self resetView];
           }
       }];
            
            
            } else {
                
                titleText = @"Verifique sus datos.";
                messageText = [NSString stringWithFormat:@"%@ \n %@", error1, error2];
                [self displayAlertWith: titleText And: messageText];
            }
        }
}

- (IBAction)selectOption:(id)sender {
    
    UISegmentedControl* button  = (UISegmentedControl*)sender;
    
    switch (button.selectedSegmentIndex)
    {
        case 0:
            ((UITextField*)_loginItems[2]).hidden = YES;
            [_loginButton setTitle:@"Entrar" forState:UIControlStateNormal];
            break;
        case 1:
            ((UITextField*)_loginItems[2]).hidden = NO;
            [_loginButton setTitle:@"Registro" forState:UIControlStateNormal];

            break;
        default: 
            break; 
    }


}


- (BOOL) validatesSignUp {
    
    NSString *password1;
    BOOL flag = YES;
    error1 = @"";
    error2 = @"";
    
    for (UITextField *object in self.loginItems) {
        
        
        if  ([self stringIsEmpty: object.text]) {
            
            flag = NO;
            error1 = @"Ningún campo puede estar vació.";
        }
        
        if (object.tag == 1) {
            
            password1 = object.text;
        }
        
        if (object.tag == 2 &&  ![object.text isEqualToString:password1]) {
            
            flag = NO;
            error2 = @"Las contraseñas deben de ser iguales.";
            object.text = @"";
            UITextField *passfield = self.loginItems[1];
            passfield.text = @"";
            
        }
    }
    
    return flag;
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

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (void) resetView {
    
    for (UITextField *object in self.loginItems) {
        [object setText:@""];
    }
    ((UITextField*)_loginItems[2]).hidden = YES;

}

@end
