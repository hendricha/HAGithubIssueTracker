//
//  TaskCell.m
//  Hendrich Attila hazifeladat
//
//  Created by user on 4/21/14.
//  Copyright (c) 2014 user. All rights reserved.
//

#import "TaskCell.h"
#import "TasksViewController.h"

@implementation TaskCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)ShowContentsFromFinished:(id)sender {
    [self ShowContents];
}
- (IBAction)ShowContentsFromProgress:(id)sender {
    [self ShowContents];
}
- (IBAction)ShowContentsFromBacklog:(id)sender {
    [self ShowContents];
}

- (void)ShowContents {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Task" message:@"" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:@"Delete", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert textFieldAtIndex:0].text = self.title.text;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSMutableArray* targetTaskArray;
    switch (self.type) {
        case 0:
            targetTaskArray = self.tvc.backLogTasks;
            break;
        case 1:
            targetTaskArray = self.tvc.inProgressTasks;
            break;
            
        default:
            targetTaskArray = self.tvc.finishedTasks;
            break;
    }
    
    [targetTaskArray removeObjectAtIndex: self.index];
    
    if (buttonIndex == 0) {
        [targetTaskArray addObject:[alertView textFieldAtIndex:0].text];
    }
     
    [self.tvc reloadCollections];
    [self.tvc storeArrays];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
