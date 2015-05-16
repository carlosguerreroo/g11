//
//  ChatListTableViewCell.h
//  mensajes
//
//  Created by Carlos Guerrero on 5/15/15.
//  Copyright (c) 2015 grupoonce. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *companysName;
@property (weak, nonatomic) IBOutlet UILabel *status;

@end
