//
//  ChatViewController.m
//  mensajes
//
//  Created by Carlos Guerrero on 4/5/15.
//  Copyright (c) 2015 grupoonce. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController() {
    
    NSString *city;
    NSString *userName;
    NSString *companysName;
    NSString *userMessageNode;
    NSString *userType;
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
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    messages = [[NSMutableArray alloc] init];
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
    [[self navigationController] setNavigationBarHidden:NO animated:YES];


}

- (void) viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    [messageRef removeObserverWithHandle:handle];

}

-(void) viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [messages removeAllObjects];
    [self finishReceivingMessageAnimated:YES];
    [self setupFirebase];
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
    }
}

-(void) setUserMessageNode: (NSString*) messageNode {

    userMessageNode = messageNode;
}

-(void) updateReadMessage: (NSString *)node {
    
    Firebase *hopperRef = [messageRef childByAppendingPath: node];
    NSDictionary *nickname = @{
                               @"read": @YES,
                               };
    [hopperRef updateChildValues: nickname];
}

@end
