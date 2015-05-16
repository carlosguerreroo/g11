//
//  ChatViewController.h
//  mensajes
//
//  Created by Carlos Guerrero on 4/5/15.
//  Copyright (c) 2015 grupoonce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSQMessages.h"
#import "DemoModelData.h"
#import <Firebase/Firebase.h>

@interface ChatViewController : JSQMessagesViewController <UIActionSheetDelegate>

-(void) setUserMessageNode: (NSString*) userMesageNode;

@end

Firebase *messageRef;
FirebaseHandle handle;
NSMutableArray *messages;