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

@interface ChatViewController : JSQMessagesViewController <UIActionSheetDelegate>
@property (strong, nonatomic) DemoModelData *demoData;

@end
