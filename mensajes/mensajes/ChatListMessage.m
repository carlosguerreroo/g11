//
//  ChatListMessage.m
//  mensajes
//
//  Created by Carlos Guerrero on 5/15/15.
//  Copyright (c) 2015 grupoonce. All rights reserved.
//

#import "ChatListMessage.h"

@implementation ChatListMessage

-(id)initWithCompany:(NSString*)initCompany withTime:(NSString*)time withUsername: (NSString*)username andStatus:(BOOL) status
{
    self = [super init];
    if (self)
    {
        _company = initCompany;
        _time = time;
        _userName = username;
        _status = status;
    }
    return self;
}

@end
