//
//  ChatListViewController.m
//  mensajes
//
//  Created by Carlos Guerrero on 5/15/15.
//  Copyright (c) 2015 grupoonce. All rights reserved.
//

#import "ChatListViewController.h"
#import "ViewController.h"
#import "ChatListTableViewCell.h"
#import "ChatListMessage.h"
#import "ChatViewController.h"

@interface ChatListViewController () <UITableViewDelegate, UITableViewDataSource> {
    NSString *city;
    NSString *userName;
    NSString *companysName;
    Firebase *ref;
    NSMutableArray *messages;
    ChatViewController *chatViewController;
    int messageUnread;
}

@property (weak, nonatomic) IBOutlet UIButton *logOutButton;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageCounterLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

NSString *const fireURLRoot = @"https://glaring-heat-1751.firebaseio.com/messages/";

@implementation ChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _logOutButton.layer.cornerRadius = 4.0f;
    _logOutButton.layer.masksToBounds= YES;
    
    _messageCounterLabel.text = @"0";
    messageUnread = 0;

    [self configureUser];

    _usernameLabel.text = city;
    ref = [[Firebase alloc] initWithUrl:fireURLRoot];
    
    messages = [[NSMutableArray alloc] init];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (IBAction)logOut:(id)sender {
    
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

-(void)configureUser {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    city = [prefs stringForKey:@"city"];
    userName = [prefs stringForKey:@"userName"];
    companysName = [prefs stringForKey:@"companysName"];
}

-(void) setupFirebase {
    
    [[ref childByAppendingPath: city] observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        
        NSArray *userData = [snapshot.key componentsSeparatedByString:@"%"];

        ChatListMessage* message =
            [[ChatListMessage alloc] initWithCompany: userData[1]
                                         withTime:@"foo"
                                    withUsername: userData[0]
                                        andStatus:NO];
        
        [messages addObject: message];
        [_tableView reloadData];
        [self AddObservertoNode: snapshot.key];
    }];


}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [messages count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ListCell";
    
    ChatListTableViewCell *cell = (ChatListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.companysName.text = ((ChatListMessage*)[messages objectAtIndex:indexPath.row]).company;
    cell.userName.text = ((ChatListMessage*)[messages objectAtIndex:indexPath.row]).userName;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *localCompany = ((ChatListMessage*)[messages objectAtIndex:indexPath.row]).company;
    NSString *localUsername = ((ChatListMessage*)[messages objectAtIndex:indexPath.row]).userName;
    
    if (chatViewController == nil) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        chatViewController = (ChatViewController *)[storyboard instantiateViewControllerWithIdentifier:@"chatViewController"];
       
        [chatViewController setUserMessageNode: [NSString stringWithFormat:@"%@/%@%%%@",city, localUsername, localCompany]];
        [self.navigationController pushViewController:chatViewController animated: YES];

    } else {
        
        [chatViewController setUserMessageNode: [NSString stringWithFormat:@"%@/%@%%%@",city, localUsername, localCompany]];
        [self.navigationController pushViewController:chatViewController animated: YES];
    }
}

- (void) AddObservertoNode: (NSString*) node {
    
    [[[ref childByAppendingPath: city] childByAppendingPath:node] observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        
        if ([snapshot.value[@"read"] boolValue] == 0) {
            messageUnread++;
            _messageCounterLabel.text = [NSString stringWithFormat:@"%d", messageUnread];

        }
    }];
}

- (void) viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear: animated];
    
    messageUnread = 0;
    _messageCounterLabel.text = @"0";
    [ref removeAllObservers];
}

-(void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear: animated];
    [messages removeAllObjects];
    [self setupFirebase];

}

@end
