//
//  ContactManager.h
//  Respoke
//
//  Copyright 2015, Digium, Inc.
//  All rights reserved.
//
//  This source code is licensed under The MIT License found in the
//  LICENSE file in the root directory of this source tree.
//
//  For all details and documentation:  https://www.respoke.io
//

#import <Foundation/Foundation.h>
#import "RespokeGroup.h"
#import "RespokeEndpoint.h"

#define ENDPOINT_MESSAGE_RECEIVED @"ENDPOINT_MESSAGE_RECEIVED"
#define GROUP_MEMBERSHIP_CHANGED @"GROUP_MEMBERSHIP_CHANGED"
#define ENDPOINT_DISCOVERED @"ENDPOINT_DISCOVERED"
#define ENDPOINT_DISAPPEARED @"ENDPOINT_DISAPPEARED"
#define ENDPOINT_JOINED_GROUP @"ENDPOINT_JOINED_GROUP"
#define ENDPOINT_LEFT_GROUP @"ENDPOINT_LEFT_GROUP"
#define GROUP_MESSAGE_RECEIVED @"GROUP_MESSAGE_RECEIVED"
#define ENDPOINT_PRESENCE_CHANGED @"ENDPOINT_PRESENCE_CHANGED"


@interface ContactManager : NSObject <RespokeGroupDelegate, RespokeEndpointDelegate>

@property NSString *username;
@property NSMutableArray *groups;
@property NSMutableDictionary *groupConnectionArrays;
@property NSMutableDictionary *groupEndpointArrays;
@property NSMutableDictionary *conversations;
@property NSMutableDictionary *groupConversations;
@property NSMutableArray *allKnownEndpoints;

- (void)joinGroups:(NSArray*)groupNames successHandler:(void (^)(void))successHandler errorHandler:(void (^)(NSString*))errorHandler;
- (void)leaveGroup:(RespokeGroup*)group successHandler:(void (^)(void))successHandler errorHandler:(void (^)(NSString*))errorHandler;
- (void)disconnected;
- (void)trackEndpoint:(RespokeEndpoint*)newEndpoint;

@end
