//
//  GroupTableViewController.h
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

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "RespokeGroup.h"


@interface GroupTableViewController : UITableViewController

@property RespokeGroup *group;

- (IBAction)leaveAction;

@end
