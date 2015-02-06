//
//  KIFUITestActor+Helper.m
//  Respoke
//
//  Created by Rob Crabtree on 1/27/15.
//  Copyright (c) 2015 Digium, Inc. All rights reserved.
//

#import "KIFUITestActor+Respoke.h"


@implementation KIFUITestActor (Respoke)


#define LAST_APP_ID_KEY @"LAST_APP_ID_KEY"


- (void)initializeLoginScreen
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // This is a workaround to clear out any appIDs that may have been saved in user defaults
        NSString *lastAppID = [[NSUserDefaults standardUserDefaults] objectForKey:LAST_APP_ID_KEY];
        if (lastAppID)
        {
            // show the app id text field
            [tester tapViewWithAccessibilityLabel:LOGIN_CHANGE_APP_ID_BUTTON];
        }
        [self resetLoginScreen];
    });

    // hit change app id button
    [tester tapViewWithAccessibilityLabel:LOGIN_CHANGE_APP_ID_BUTTON];

    // wait for app id text field to appear
    [tester waitForViewWithAccessibilityLabel:LOGIN_APP_ID_TEXTFIELD];
}


- (void)resetLoginScreen
{
    // clear endpointID, groupName, and appID
    [tester clearTextFromViewWithAccessibilityLabel:LOGIN_ENDPOINT_ID_TEXTFIELD];
    [tester clearTextFromViewWithAccessibilityLabel:LOGIN_GROUP_TEXTFIELD];
    [tester clearTextFromViewWithAccessibilityLabel:LOGIN_APP_ID_TEXTFIELD];

    // hide the "app id" textfield and show the "change app id" button
    [tester setOn:YES forSwitchWithAccessibilityLabel:LOGIN_BROKERED_SWITCH];
    [tester setOn:NO forSwitchWithAccessibilityLabel:LOGIN_BROKERED_SWITCH];

    // ensure the change app id button is present
    [tester waitForViewWithAccessibilityLabel:LOGIN_CHANGE_APP_ID_BUTTON];
}


- (void)loginEndpoint:(NSString *)endpoint groupName:(NSString *)groupName appID:(NSString *)appID
{
    // enter endpointID and group textfields
    if (endpoint)
    {
        [tester enterText:endpoint intoViewWithAccessibilityLabel:LOGIN_ENDPOINT_ID_TEXTFIELD];
    }
    if (groupName)
    {
        [tester enterText:groupName intoViewWithAccessibilityLabel:LOGIN_GROUP_TEXTFIELD];
    }

    if (appID)
    {
        // enter app id
        [tester enterText:appID intoViewWithAccessibilityLabel:LOGIN_APP_ID_TEXTFIELD];
    }

    // hit the login button
    [tester tapViewWithAccessibilityLabel:LOGIN_CONNECT_BUTTON];

    // ensure the group list table view appears
    [tester waitForViewWithAccessibilityLabel:GROUP_LIST_TABLE_VIEW];
}


- (void)logout
{
    // make sure we are at the expected view
    [tester waitForViewWithAccessibilityLabel:GROUP_LIST_TABLE_VIEW];

    // hit the logout button
    [tester tapViewWithAccessibilityLabel:GROUP_LIST_LOGOUT_BUTTON];

    // wait for login screen to appear
    [tester waitForViewWithAccessibilityLabel:LOGIN_ENDPOINT_ID_TEXTFIELD];
}

@end
