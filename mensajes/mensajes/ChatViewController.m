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

    [messageRef observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
         
        NSString *text = snapshot.value[@"text"];
        NSString *sender = snapshot.value[@"sender"];
        NSDate *date = [[NSDate alloc] init];
        
        JSQMessage *message = [[JSQMessage alloc] initWithSenderId: sender
                                                  senderDisplayName: sender
                                                               date: date
                                                               text: text];
        [messages addObject:message];
        
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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    messages = [[NSMutableArray alloc] init];
    
    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
    self.automaticallyScrollsToMostRecentMessage = YES;
    self.inputToolbar.contentView.leftBarButtonItem = nil;
    [self.inputToolbar.contentView.rightBarButtonItem setTitle:@"Envio" forState: UIControlStateNormal];
    self.inputToolbar.contentView.textView.placeHolder = @"Mensaje";
    
    [self configureUser];
    
    NSString *cleanUserName = [userName stringByReplacingOccurrencesOfString:@"." withString: @""];
    userMessageNode = [NSString stringWithFormat:@"%@/%@%%%@",city, cleanUserName, companysName];

    self.senderId = userType;
    self.senderDisplayName = userName;
    
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
    
//    JSQMessage *message = [[JSQMessage alloc] initWithSenderId:senderId
//                                             senderDisplayName:senderDisplayName
//                                                          date:date
//                                                          text:text];
//    
//    [self.demoData.messages addObject:message];
    
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
    
    return [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
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
        
        if ([msg.senderId isEqualToString:self.senderId]) {
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
    }
}

@end
