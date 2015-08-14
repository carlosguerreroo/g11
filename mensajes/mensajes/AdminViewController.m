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
#import "SelectGraphViewController.h"

@interface AdminViewController ()  <UITableViewDelegate, UITableViewDataSource> {

    NSArray *cities;
    NSMutableArray *citiesImages;
    ChatListViewController * chatListViewController;
    SelectGraphViewController *selectGraphViewController;

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
    
    citiesImages = [[NSMutableArray alloc] init];

    cities = @[@"Aguascalientes", @"Celaya", @"Culiacán", @"DF",
               @"Guadalajara",  @"León", @"Querétaro", @"San Luis Potosí",
               @"Tijuana", @"Torreón", @"Zacatecas"];
    
    for (int i = 1; i <= cities.count; i++)
    {
  
        [citiesImages addObject:[UIImage imageNamed: [NSString stringWithFormat: @"%d", i]]];
    }
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
    barButton.title = @"Atrás";
    self.navigationController.navigationBar.topItem.backBarButtonItem = barButton;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
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
    if (chatListViewController == nil) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        chatListViewController = (ChatListViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ChatListViewController"];
        
        [chatListViewController setAdmin: YES];
        [chatListViewController setCity: cities[indexPath.row]];
        [self.navigationController pushViewController: chatListViewController animated: YES];
        
    } else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        chatListViewController = (ChatListViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ChatListViewController"];
        
        [chatListViewController setAdmin: YES];
        [chatListViewController setCity: cities[indexPath.row]];

        [self.navigationController pushViewController: chatListViewController animated: YES];
    }
}


- (IBAction)logOut:(id)sender {
    
    Firebase *ref = [[Firebase alloc] initWithUrl:@"https://glaring-heat-1751.firebaseio.com/"];
    [ref unauth];
    
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

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if (selectGraphViewController == nil) {
        selectGraphViewController = (SelectGraphViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SelectGraphViewController"];

    }

    [self.navigationController pushViewController: selectGraphViewController animated: YES];
}

@end
