//
//  ChatListMessage.h
//  mensajes
//
//  Created by Carlos Guerrero on 5/15/15.
//  Copyright (c) 2015 grupoonce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatListMessage : NSObject

@property(nonatomic, readwrite) NSString *company;
@property(nonatomic, readwrite) NSString *time;
@property(nonatomic, readwrite) NSString *userName;
@property(nonatomic, readwrite) BOOL status;

-(id)initWithCompany:(NSString*)initCompany withTime:(NSString*)time withUsername: (NSString*)username andStatus:(BOOL) status;
@end
