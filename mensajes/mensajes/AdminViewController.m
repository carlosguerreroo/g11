//
//  AdminViewController.m
//  mensajes
//
//  Created by Carlos Guerrero on 5/16/15.
//  Copyright (c) 2015 grupoonce. All rights reserved.
//

#import "AdminViewController.h"
#import "ViewController.h"
#import "AdminTableViewCell.h"


@interface AdminViewController ()  <UITableViewDelegate, UITableViewDataSource> {

    NSArray *cities;

}

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIButton *logOutButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

    
@end

@implementation AdminViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _logOutButton.layer.cornerRadius = 4.0f;
    _logOutButton.layer.masksToBounds= YES;
    _usernameLabel.text = @"Admministrador";
    cities = @[@"Aguascalientes", @"Celaya", @"León", @"Culiacán", @"DF Lomas altas",
               @"Guadalajara", @"Querétaro", @"SLP", @"Tijuana", @"Torreón", @"Zacatecas"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)prefersStatusBarHidden {
    return YES;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [cities count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AdminCell";
    
    AdminTableViewCell *cell = (AdminTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.city.text = @"a";
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    
//    NSString *localCompany = ((ChatListMessage*)[messages objectAtIndex:indexPath.row]).company;
//    NSString *localUsername = ((ChatListMessage*)[messages objectAtIndex:indexPath.row]).userName;
//    
//    if (chatViewController == nil) {
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        chatViewController = (ChatViewController *)[storyboard instantiateViewControllerWithIdentifier:@"chatViewController"];
//        
//        [chatViewController setUserMessageNode: [NSString stringWithFormat:@"%@/%@%%%@",city, localUsername, localCompany]];
//        [self.navigationController pushViewController:chatViewController animated: YES];
//        
//    } else {
//        
//        [chatViewController setUserMessageNode: [NSString stringWithFormat:@"%@/%@%%%@",city, localUsername, localCompany]];
//        [self.navigationController pushViewController:chatViewController animated: YES];
//    }
}


- (IBAction)logOut:(id)sender {

    
//    [ref unauth];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject: @"" forKey:@"companysName"];
    [prefs setObject: @"" forKey:@"city"];
    [prefs setObject: @"" forKey:@"userName"];
    [prefs synchronize];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *viewController = (ViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    [self presentViewController:viewController animated:YES completion:nil];
}
@end
