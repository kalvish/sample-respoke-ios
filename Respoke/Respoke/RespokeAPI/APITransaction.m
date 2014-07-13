//
//  ApiTransaction.m
//  Respoke
//
//  Created by Jason Adams on 7/12/14.
//  Copyright (c) 2014 Ninjanetic Design Inc. All rights reserved.
//

#import "APITransaction.h"

#define HTTP_TIMEOUT 10.0f


@implementation APITransaction


- (instancetype)init
{
    if (self = [super init])
    {
        self.baseURL = @"https://api.respoke.io";
        urlEndpoint = @"";
        params = @"";
        httpMethod = @"POST";
    }

    return self;
}


- (void)goWithSuccessHandler:(void (^)())successHandler errorHandler:(void (^)(NSString*))errorHandler
{
    self.successHandler = successHandler;
    self.errorHandler = errorHandler;

    NSURL *theURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.baseURL, urlEndpoint]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:theURL cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:HTTP_TIMEOUT];
    [request setHTTPMethod:httpMethod];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/xml" forHTTPHeaderField:@"Accept"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[params length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];

    connection = [NSURLConnection connectionWithRequest:request delegate:self];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSInteger httpStatus = ((NSHTTPURLResponse*)response).statusCode;

    if (401 == httpStatus)
    {
        self.errorMessage = @"API authentication error";
    }
    else if (httpStatus == 503)
    {
        self.errorMessage = @"Server is down for maintenance";
    }
    else if (httpStatus >= 400)
    {
        self.errorMessage = [NSString stringWithFormat:@"Failed with server error %ld!", (long)httpStatus];
    }
    else
    {
        self.success = YES;
    }
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (!self.receivedData)
    {
        self.receivedData = [NSMutableData dataWithData:data];
    }
    else
    {
        [self.receivedData appendData:data];
    }
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self transactionComplete];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if ((error.code == NSURLErrorUserCancelledAuthentication) || (error.code == NSURLErrorUserAuthenticationRequired))
    {
        self.errorMessage = @"API authentication error";
    }
    else if (error.code == NSURLErrorBadServerResponse)
    {
        self.errorMessage = @"Failed with status code 500";
    }
    else
    {
        self.errorMessage = @"Unable to reach server";
    }

    self.success = NO;

    [self transactionComplete];
}


- (void)transactionComplete
{
    // overridden by child classes

    if (self.success)
    {
        NSError *error;
        self.jsonResult = [NSJSONSerialization JSONObjectWithData:self.receivedData options:0 error:&error];

        if (error)
        {
            NSLog(@"------%@: error deserializing response: %@", [self class], [error localizedDescription]);
            self.errorMessage = @"Unexpected response from server";
            self.success = NO;
        }
    }
}


- (void)cancel
{
    abort = YES;
    [connection cancel];
}


@end
