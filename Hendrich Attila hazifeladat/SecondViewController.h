//
//  SecondViewController.h
//  Hendrich Attila hazifeladat
//
//  Created by user on 4/18/14.
//  Copyright (c) 2014 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IssueViewController.h"
@interface SecondViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UITextField *repoField;
@property (weak, nonatomic) IBOutlet UISwitch *showAllSwitch;

@end
