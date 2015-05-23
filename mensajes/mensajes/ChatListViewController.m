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
#import "ResetPasswordViewController.h"

@interface ChatListViewController () <UITableViewDelegate, UITableViewDataSource> {
    NSString *city;
    NSString *userName;
    NSString *companysName;
    Firebase *ref;
    NSMutableArray *messages;
    NSMutableArray *handles;
    
    ChatViewController *chatViewController;
    ResetPasswordViewController *resetPasswordViewController;
    int messageUnread;
    NSAttributedString *statusEmpty;
    NSAttributedString *statusFill;
    BOOL isAdmin;
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
    
    _logOutButton.layer.cornerRadius = 4.0f;
    _logOutButton.layer.masksToBounds= YES;
    
    _messageCounterLabel.text = @"0";
    messageUnread = 0;

    [self configureUser];
    _usernameLabel.text = city;

    ref = [[Firebase alloc] initWithUrl:fireURLRoot];
    
    messages = [[NSMutableArray alloc] init];
    handles = [[NSMutableArray alloc] init];
    statusEmpty = [[NSAttributedString alloc]
                   initWithData: [@"&#9898;" dataUsingEncoding:NSUTF8StringEncoding]
                   options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                   documentAttributes: nil
                   error: nil];
    
    statusFill = [[NSAttributedString alloc]
                  initWithData: [@"&#9679;" dataUsingEncoding:NSUTF8StringEncoding]
                  options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                  documentAttributes: nil
                  error: nil];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    
    if (isAdmin) {
        
        [_logOutButton setTitle: @"Configuración" forState: UIControlStateNormal];
    } else {
        [_logOutButton setTitle: @"Cerrar Sesión" forState: UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (IBAction)logOut:(id)sender {
    
    
    if (isAdmin) {
    
        
        if (resetPasswordViewController == nil) {
        
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            resetPasswordViewController = (ResetPasswordViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ResetPasswordViewController"];
            [resetPasswordViewController setUsernameText: city];
            [self.navigationController pushViewController: resetPasswordViewController animated: YES];

        } else {
            [resetPasswordViewController setUsernameText: city];
            [self.navigationController pushViewController: resetPasswordViewController animated: YES];

        }
    
    } else {
        
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

}

-(void)configureUser {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    userName = [prefs stringForKey:@"userName"];
    companysName = [prefs stringForKey:@"companysName"];
    
    if (!isAdmin) {
        city = [prefs stringForKey:@"city"];
    } else {
    
        
    }
}

-(void) setupFirebase {
    
    NSLog(@"%@", city);
    [[ref childByAppendingPath: city] observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        
        NSArray *userData = [snapshot.key componentsSeparatedByString:@"%"];

        ChatListMessage* message =
            [[ChatListMessage alloc] initWithCompany: userData[1]
                                         withTime:@"foo"
                                    withUsername: userData[0]
                                        andStatus:NO];
        
        [messages addObject: message];
        [_tableView reloadData];
        [self AddObservertoNode: snapshot.key  index: ([messages count]-1)];
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
    cell.time.text = ((ChatListMessage*)[messages objectAtIndex:indexPath.row]).time;
    
    if(((ChatListMessage*)[messages objectAtIndex:indexPath.row]).status) {
        cell.status.attributedText = statusFill;
        NSLog(@"as");
    } else {
        NSLog(@"as");

        cell.status.attributedText = statusEmpty;
    }
    
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

- (void) AddObservertoNode: (NSString*) node index: (unsigned long)position {
    
    Firebase* tmpRef = [[ref childByAppendingPath: city] childByAppendingPath:node];
    
    [tmpRef observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        
        if ([snapshot.value[@"read"] boolValue] == 0 && ![snapshot.value[@"sender"] isEqualToString:@"adviser"]) {
            messageUnread++;
            _messageCounterLabel.text = [NSString stringWithFormat:@"%d", messageUnread];
            [((ChatListMessage *)messages[position]) setStatus:YES];

        }
        
        [((ChatListMessage *)messages[position]) setTime: snapshot.value[@"time"]];
        [_tableView reloadData];
    }];
    
    [handles addObject:tmpRef];
}

- (void) viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear: animated];
    
    messageUnread = 0;
    _messageCounterLabel.text = @"0";
    [ref removeAllObservers];
    
    for(Firebase *st in handles) {
        [st removeAllObservers];
    }
    
    NSLog(@"viewDidDisappear");
}

-(void) viewWillAppear:(BOOL)animated {
    
    NSLog(@"viewWillAppear");
    [super viewWillAppear: animated];
    [messages removeAllObjects];
    [self setupFirebase];
}

- (void) setCity:(NSString*)cityName {
    
    city = cityName;
    _usernameLabel.text = city;
}

- (void) setAdmin:(BOOL)adminMode {
    isAdmin = adminMode;
}
@end
