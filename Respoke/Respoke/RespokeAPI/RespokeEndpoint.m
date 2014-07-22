//
//  RespokeEndpoint.m
//  Respoke
//
//  Created by Jason Adams on 7/14/14.
//  Copyright (c) 2014 Ninjanetic Design Inc. All rights reserved.
//

#import "RespokeEndpoint.h"


@implementation RespokeEndpoint {
    RespokeSignalingChannel *signalingChannel;
}


- (instancetype)initWithSignalingChannel:(RespokeSignalingChannel*)channel
{
    if (self = [super init])
    {
        self.connections = [[NSMutableArray alloc] init];
        signalingChannel = channel;
    }

    return self;
}


- (void)sendMessage:(NSString*)message successHandler:(void (^)(void))successHandler errorHandler:(void (^)(NSString*))errorHandler
{
    if ([self.connections count])
    {
        NSDictionary *data = @{@"to": self.endpointID, @"message": message};

        [signalingChannel sendRESTMessage:@"post" url:@"/v1/messages" data:data responseHandler:^(id response, NSString *errorMessage) {
            if (errorMessage)
            {
                errorHandler(errorMessage);
            }
            else
            {
                successHandler();
            }
        }];
    }
    else
    {
        errorHandler(@"Specified endpoint does not have any connections");
    }
}


- (RespokeCall*)startVideoCallWithDelegate:(id <RespokeCallDelegate>)delegate remoteVideoView:(UIView*)newRemoteView localVideoView:(UIView*)newLocalView
{
    RespokeCall *call = [[RespokeCall alloc] initWithSignalingChannel:signalingChannel];
    call.delegate = delegate;
    call.remoteView = newRemoteView;
    call.localView = newLocalView;
    call.endpoint = self;

    [call startCall];

    return call;
}


- (RespokeCall*)startAudioCallWithDelegate:(id <RespokeCallDelegate>)delegate
{
    RespokeCall *call = [[RespokeCall alloc] initWithSignalingChannel:signalingChannel];
    call.delegate = delegate;
    call.audioOnly = YES;
    call.endpoint = self;

    [call startCall];

    return call;
}


@end