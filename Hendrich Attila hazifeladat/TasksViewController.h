//
//  TasksViewController.h
//  Hendrich Attila hazifeladat
//
//  Created by user on 4/21/14.
//  Copyright (c) 2014 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OBDragDrop.h"
#import "TaskCell.h"
#import "IssueViewController.h"

@interface TasksViewController : UIViewController  <OBOvumSource, OBDropZone, UIPopoverControllerDelegate>
@property (strong, nonatomic) NSMutableArray *backLogTasks;
@property (strong, nonatomic) NSMutableArray *inProgressTasks;
@property (strong, nonatomic) NSMutableArray *finishedTasks;
@property (strong, nonatomic) NSString *storageKey;
@property (strong, nonatomic) NSArray *storedArray;
@end
