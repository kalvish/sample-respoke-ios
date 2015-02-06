//
//  LoginTests.m
//  Respoke
//
//  Created by Rob Crabtree on 1/27/15.
//  Copyright (c) 2015 Digium, Inc. All rights reserved.
//

#import <KIF/KIF.h>
#import "KIFUITestActor+Respoke.h"
#import "AppDelegate.h"


#define TEST_ENDPOINT       @"test endpoint"
#define TEST_GROUP          @"test group"
#define TEST_APP_ID         @"57ac5f3a-0513-40b5-ba42-b80939e69436"
#define TEST_BAD_APP_ID     @"bad app id"


@interface LoginTests : KIFTestCase
@end


@implementation LoginTests


#pragma mark - Pre and Post Test Methods


- (void)beforeEach
{
    [super beforeEach];
    [tester initializeLoginScreen];
}


- (void)afterEach
{
    [super afterEach];
    [tester resetLoginScreen];
}


#pragma mark - UI Tests


- (void)testSuccessfulLogin
{
    [tester loginEndpoint:TEST_ENDPOINT groupName:TEST_GROUP appID:nil];
    [tester logout];
}


 - (void)testSuccessfulLoginWithValidAppID
{
    [tester loginEndpoint:TEST_ENDPOINT groupName:TEST_GROUP appID:TEST_APP_ID];
    [tester logout];
}


- (void)testFailedLoginWithBadAppID
{
    // supply endpoint, group, and appID
    [tester enterText:TEST_ENDPOINT intoViewWithAccessibilityLabel:LOGIN_ENDPOINT_ID_TEXTFIELD];
    [tester enterText:TEST_GROUP intoViewWithAccessibilityLabel:LOGIN_GROUP_TEXTFIELD];
    [tester enterText:TEST_BAD_APP_ID intoViewWithAccessibilityLabel:LOGIN_APP_ID_TEXTFIELD];

    // hit connect button
    [tester tapViewWithAccessibilityLabel:LOGIN_CONNECT_BUTTON];

    // verify we get the expected error
    UILabel *errorLabel = (UILabel *) [tester waitForViewWithAccessibilityLabel:LOGIN_ERROR_LABEL];
    XCTAssertTrue([errorLabel.text isEqualToString:@"API authentication error"], @"Should not authenticate");
}


- (void)testFailedLoginWithBlankEndpoint
{
    [tester tapViewWithAccessibilityLabel:LOGIN_CONNECT_BUTTON];
    UILabel *errorLabel = (UILabel *) [tester waitForViewWithAccessibilityLabel:LOGIN_ERROR_LABEL];
    XCTAssertTrue([errorLabel.text isEqualToString:@"Username may not be blank"], @"Should not connect");
}


- (void)testBrokeredAuth
{
    [tester setOn:YES forSwitchWithAccessibilityLabel:LOGIN_BROKERED_SWITCH];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:LOGIN_CHANGE_APP_ID_BUTTON];

    // TODO: Test brokered authentication

    // reset the brokered auth switch
    [tester setOn:NO forSwitchWithAccessibilityLabel:LOGIN_BROKERED_SWITCH];
    [tester waitForViewWithAccessibilityLabel:LOGIN_CHANGE_APP_ID_BUTTON];

    // if we don't show the appID text field then reset will fail
    [tester tapViewWithAccessibilityLabel:LOGIN_CHANGE_APP_ID_BUTTON];
}


- (void)testStatusChanges
{
    [tester loginEndpoint:TEST_ENDPOINT groupName:TEST_GROUP appID:nil];

    // verify status changes
    UIButton *statusButton = (UIButton *) [tester waitForViewWithAccessibilityLabel:GROUP_LIST_STATUS_BUTTON];
    [self setStatus:@"chat" statusButton:statusButton];
    [self setStatus:@"available" statusButton:statusButton];
    [self setStatus:@"away" statusButton:statusButton];
    [self setStatus:@"dnd" statusButton:statusButton];
    [self setStatus:@"unavailable" statusButton:statusButton];

    // verify that status doesn't change if we cancel
    [tester tapViewWithAccessibilityLabel:GROUP_LIST_STATUS_BUTTON];
    [tester tapViewWithAccessibilityLabel:@"Cancel"];
    XCTAssertTrue([statusButton.titleLabel.text hasSuffix:@"unavailable"],
                  @"Status should contain 'unavailable'");

    [tester logout];
}


#pragma mark - Helper Methods


- (void)setStatus:(NSString *)status statusButton:(UIButton *)statusButton
{
    [tester tapViewWithAccessibilityLabel:GROUP_LIST_STATUS_BUTTON];
    [tester tapViewWithAccessibilityLabel:status];
    XCTAssertTrue([statusButton.titleLabel.text hasSuffix:status],
                  @"Status should contain '%@'", status);
}


@end