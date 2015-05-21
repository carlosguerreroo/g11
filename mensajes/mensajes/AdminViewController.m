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
#import "ChatListViewController.h"

@interface AdminViewController ()  <UITableViewDelegate, UITableViewDataSource> {

    NSArray *cities;
    NSMutableArray *citiesImages;
    UIImage *cityImage1 ;
    ChatListViewController * chatListViewController;


}

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIButton *logOutButtonAdmin;
@property (weak, nonatomic) IBOutlet UIButton *graphsButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

    
@end

@implementation AdminViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _logOutButtonAdmin.layer.cornerRadius = 4.0f;
    _logOutButtonAdmin.layer.masksToBounds = YES;
    _graphsButton.layer.cornerRadius = 4.0f;
    _graphsButton.layer.masksToBounds = YES;
    
    _usernameLabel.text = @"Admministrador";
    
    cityImage1 = [UIImage imageNamed: @"1"];
    citiesImages = [[NSMutableArray alloc] init];

    cities = @[@"Aguascalientes", @"Celaya", @"Culiacán", @"DF",
               @"Guadalajara",  @"León", @"Querétaro", @"San Luis Potosí",
               @"Tijuana", @"Torreón", @"Zacatecas"];
    
    for (int i = 1; i <= cities.count; i++)
    {
  
        [citiesImages addObject:[UIImage imageNamed: [NSString stringWithFormat: @"%d", i]]];
    }
    
  

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
    cell.city.text = cities[indexPath.row];
    [cell.image setImage:[citiesImages objectAtIndex:indexPath.row]];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    NSString *localCompany = ((ChatListMessage*)[messages objectAtIndex:indexPath.row]).company;
//    NSString *localUsername = ((ChatListMessage*)[messages objectAtIndex:indexPath.row]).userName;
    
    if (chatListViewController == nil) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        chatListViewController = (ChatListViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ChatListViewController"];
        
//        [chatViewController setUserMessageNode: [NSString stringWithFormat:@"%@/%@%%%@",city, localUsername, localCompany]];
        [self.navigationController pushViewController: chatListViewController animated: YES];
        
    } else {
        
//        [chatViewController setUserMessageNode: [NSString stringWithFormat:@"%@/%@%%%@",city, localUsername, localCompany]];
        [self.navigationController pushViewController: chatListViewController animated: YES];
    }
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
- (IBAction)ShowGraphs:(id)sender {
}
@end
