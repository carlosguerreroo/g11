//
//  ChatViewController.m
//  mensajes
//
//  Created by Carlos Guerrero on 4/5/15.
//  Copyright (c) 2015 grupoonce. All rights reserved.
//

#import "ChatViewController.h"
#import <Parse/Parse.h>

@interface ChatViewController() {
    
    NSString *city;
    NSString *userName;
    NSString *companysName;
    NSString *userMessageNode;
    NSString *userType;
    NSString *cityPath;
    NSString *userNamePath;
}

@end

NSString *const firebaseChatURL = @"https://glaring-heat-1751.firebaseio.com/messages/";

@implementation ChatViewController


-(void)setupFirebase {
    
    NSString *firebaseNode = [NSString stringWithFormat:@"%@%@", firebaseChatURL, userMessageNode];
    
    messageRef = [[Firebase alloc] initWithUrl: firebaseNode];

    handle = [messageRef observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
         
        NSString *text = snapshot.value[@"text"];
        NSString *sender = snapshot.value[@"sender"];
        NSDate *date = [[NSDate alloc] init];
        
        JSQMessage *message = [[JSQMessage alloc] initWithSenderId: sender
                                                  senderDisplayName: sender
                                                               date: date
                                                               text: text];
        [messages addObject:message];
        [messagesDate addObject: snapshot.value[@"date"]];
        
        if (![sender isEqualToString:userType]) {
            
            [self updateReadMessage: snapshot.key];
        }
        
        [self finishReceivingMessageAnimated:YES];
     }];
}

-(void)sendMessageWithText: (NSString*)text sender: (NSString*)sender {
    
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"LLLL dd"];
    NSString *date = [DateFormatter stringFromDate:[NSDate date]];
    [DateFormatter setDateFormat:@"HH:mm"];
    NSString *time = [DateFormatter stringFromDate:[NSDate date]];

    NSDictionary *message = @{
                              @"text": text,
                              @"sender": userType,
                              @"date": date,
                              @"read": @NO,
                              @"time": time
                              };
    Firebase *sendMessage = [messageRef childByAutoId];
    [sendMessage setValue: message];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    if ([companysName isEqualToString:@"grupoonce"]) {
        // Create our Installation query
        PFQuery *pushQuery = [PFInstallation query];
        [pushQuery whereKey:@"city" equalTo:cityPath];
        [pushQuery whereKey:@"userName" equalTo:userNamePath];
        
        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"Tienes un nuevo mensaje de tu asesor", @"alert",
                              @"cheering.caf", @"sound",
                              nil];
        [pushQuery whereKey:@"session" equalTo:@"open"];
        
        PFPush *push = [[PFPush alloc] init];
        [push setQuery:pushQuery]; // Set our Installation query
        [push setData:data];
        [push sendPushInBackground];
    } else {
    
        PFQuery *pushQuery = [PFInstallation query];
        [pushQuery whereKey:@"companysName" equalTo:@"grupoonce"];
        PFPush *push = [[PFPush alloc] init];
        [push setQuery:pushQuery]; // Set our Installation query
        
        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSString stringWithFormat:@"%@ %@", @"Tienes un nuevo mensaje de ", city], @"alert",
                              @"cheering.caf", @"sound", nil];
        [push setData:data];
        [push sendPushInBackground];
    }
   
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    messages = [[NSMutableArray alloc] init];
    messagesDate = [[NSMutableArray alloc] init];

    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    
    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
    self.automaticallyScrollsToMostRecentMessage = YES;
    self.inputToolbar.contentView.leftBarButtonItem = nil;
    [self.inputToolbar.contentView.rightBarButtonItem setTitle:@"Envio" forState: UIControlStateNormal];
    self.inputToolbar.contentView.textView.placeHolder = @"Mensaje";
    
    [self configureUser];
    
    self.senderId = userType;
    self.senderDisplayName = userName;
}

- (void) viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    [messageRef removeObserverWithHandle:handle];

}

-(void) viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [messages removeAllObjects];
    [messagesDate removeAllObjects];
    [self finishReceivingMessageAnimated:YES];
    [self setupFirebase];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - JSQMessagesViewController method overrides

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date
{
    
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    
    [self sendMessageWithText:text sender:senderId];
    [self finishSendingMessageAnimated:YES];
}

#pragma mark - JSQMessages CollectionView DataSource

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [messages objectAtIndex:indexPath.item];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    UIColor *bubbleColor;
    
    if ([((JSQMessage*)[messages objectAtIndex:indexPath.item]).senderId isEqualToString:@"client"]) {
        bubbleColor = [UIColor jsq_messageBubbleGreenColor];
        
    } else {
        bubbleColor = [UIColor jsq_messageBubbleLightGrayColor];
    }
    
    return [bubbleFactory outgoingMessagesBubbleImageWithColor: bubbleColor];
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
     *  The other label text delegate methods should follow a similar pattern.
     *
     *  Show a timestamp for every 3rd message
     */
    if (indexPath.item % 3 == 0) {
        JSQMessage *msg = [messages objectAtIndex:indexPath.item];

        return [[NSAttributedString alloc] initWithString:[messagesDate objectAtIndex:indexPath.item]];
    }
    
    return nil;
}
#pragma mark - Adjusting cell label heights

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
     */
    
    /**
     *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
     *  The other label height delegate methods should follow similarly
     *
     *  Show a timestamp for every 3rd message
     */
    if (indexPath.item % 3 == 0) {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    return  0.0f;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.0f;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.0f;
}
#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [messages count];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    
    JSQMessage *msg = [messages objectAtIndex:indexPath.item];
    
    if (!msg.isMediaMessage) {
        if ([msg.senderId isEqualToString: @"adviser"]) {
            cell.textView.textColor = [UIColor blackColor];
        }
        else {
            cell.textView.textColor = [UIColor whiteColor];
        }
        
        
        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                              NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }
    
    return cell;
}

-(void) configureUser {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    city = [prefs stringForKey:@"city"];
    userName = [prefs stringForKey:@"userName"];
    companysName = [prefs stringForKey:@"companysName"];
    
    if ([companysName isEqualToString:@"grupoonce"]) {
        userType = @"adviser";
    } else {
        userType = @"client";
        NSString *cleanUserName = [userName stringByReplacingOccurrencesOfString:@"." withString: @""];
        userMessageNode = [NSString stringWithFormat:@"%@/%@%%%@",city, cleanUserName, companysName];
        NSLog(@"sasasasa");
    }
}

-(void) setUserMessageNode: (NSString*) messageNode {

    userMessageNode = messageNode;
}

-(void) setUserName: (NSString*) userNamePathM AndCityPath: (NSString*)cityPathM{
    
    userNamePath = userNamePathM;
    cityPath = cityPathM;
}

-(void) updateReadMessage: (NSString *)node {
    
    Firebase *hopperRef = [messageRef childByAppendingPath: node];
    NSDictionary *nickname = @{
                               @"read": @YES,
                               };
    [hopperRef updateChildValues: nickname];
}

@end
