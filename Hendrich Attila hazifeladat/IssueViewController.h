//
//  IssueViewController.h
//  Hendrich Attila hazifeladat
//
//  Created by user on 4/20/14.
//  Copyright (c) 2014 user. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AFNetworking/AFNetworking.h>
#import "IssueCell.h"

@interface IssueViewController : UITableViewController
@property (strong, nonatomic) NSMutableArray *issues;
@property (strong, nonatomic) NSString *account;
@property (strong, nonatomic) NSString *repo;
@property (nonatomic) BOOL *showAll;
- (void)loadData;
@end
