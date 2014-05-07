//
//  TasksViewController.m
//  Hendrich Attila hazifeladat
//
//  Created by user on 4/21/14.
//  Copyright (c) 2014 user. All rights reserved.
//

#import "TasksViewController.h"

@interface TasksViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *backLogCollection;
@property (weak, nonatomic) IBOutlet UICollectionView *inProgressCollection;
@property (weak, nonatomic) IBOutlet UICollectionView *finishedCollection;
@property (weak, nonatomic) OBDragDropManager *manager;
@end

@implementation TasksViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.manager = [OBDragDropManager sharedManager];
    
    self.backLogCollection.dropZoneHandler = self;
    self.inProgressCollection.dropZoneHandler = self;
    self.finishedCollection.dropZoneHandler = self;
    self.view.dropZoneHandler = self;
    self.tabBarController.view.dropZoneHandler = self;
    self.navigationController.view.dropZoneHandler = self;

    IssueViewController *ivc = self.navigationController.viewControllers[0];
    
    NSInteger indexValue = [ivc.tableView indexPathForSelectedRow].row;
    NSNumber *issueNumber = ivc.issues[indexValue][@"number"];
    self.storageKey = [NSString stringWithFormat:@"%@/%@#%@", ivc.account, ivc.repo, issueNumber];
    self.title = self.storageKey;

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.storedArray = [userDefaults objectForKey:self.storageKey];
   
    if (!self.storedArray) {
        self.storedArray = @[[[NSMutableArray alloc] init], [[NSMutableArray alloc] init], [[NSMutableArray alloc] init]];
    }
    
    self.backLogTasks = self.storedArray[0];
    self.inProgressTasks = self.storedArray[1];
    self.finishedTasks = self.storedArray[2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)maximumNumberOfColumnsForCollectionView:(UICollectionView
                                                       *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
{
    return 2;
}

- (CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath*)indexPath
{
    return 40;
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{

    if (collectionView == self.backLogCollection)
    {
        NSLog(@"KÁNT%lu", (unsigned long)[self.backLogTasks count]);
        return [self.backLogTasks count];
    }
    else if (collectionView == self.inProgressCollection)
    {
        NSLog(@"KÁNT%lu", (unsigned long)[self.inProgressTasks count]);
        return [self.inProgressTasks count];
    } else {
        NSLog(@"KÁNT%lu", (unsigned long)[self.finishedTasks count]);
        return [self.finishedTasks count];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView
{
    return 1;
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView
                 cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString *CellIdentifier = @"TaskCell";
    TaskCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (collectionView == self.backLogCollection)
    {
        cell.title.text = self.backLogTasks[indexPath.row];
        cell.type = 0;
    }
    else if (collectionView == self.inProgressCollection)
    {
        cell.title.text = self.inProgressTasks[indexPath.row];
        cell.type = 1;
    } else {
        cell.title.text = self.finishedTasks[indexPath.row];
        cell.type = 2;
    }
    
    cell.index = indexPath.row;
    cell.tvc = self;
    
    UILongPressGestureRecognizer *dragDropRecognizer = [self.manager createLongPressDragDropGestureRecognizerWithSource:self];
    [cell addGestureRecognizer:dragDropRecognizer];
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(OBOvum *) createOvumFromView:(UIView*)sourceView
{
    OBOvum *ovum = [[OBOvum alloc] init];
    ovum.dataObject = ((TaskCell*)sourceView).title.text;
    
    NSMutableArray* targetTaskArray;
    switch (((TaskCell*)sourceView).type) {
        case 0:
            targetTaskArray = self.backLogTasks;
            break;
        case 1:
            targetTaskArray = self.inProgressTasks;
            break;
            
        default:
            targetTaskArray = self.finishedTasks;
            break;
    }
    
    for(int i = 0; i < [targetTaskArray count]; i++) {
        if ([targetTaskArray[i] isEqualToString:ovum.dataObject]) {
            [targetTaskArray removeObjectAtIndex:i];
            break;
        }
    }
    
    [self reloadCollections];
    
    return ovum;
}

- (void) reloadCollections {
    [self.backLogCollection reloadData];
    [self.inProgressCollection reloadData];
    [self.finishedCollection reloadData];
}

-(UIView *) createDragRepresentationOfSourceView:(UIView *)sourceView inWindow:(UIWindow*)window
{
    // Create a view that represents this source. It will be place on
    // the overlay window and hence the coordinates conversion to make
    // sure user doesn't see a jump in object location
    CGRect frameInWindow = [sourceView convertRect:sourceView.frame toView:sourceView.window];
    frameInWindow = [window convertRect:frameInWindow fromWindow:sourceView.window];
    
    UIView *dragView = [[UIView alloc] initWithFrame:frameInWindow];
    dragView.backgroundColor = sourceView.backgroundColor;
    dragView.layer.cornerRadius = 5.0;
    dragView.layer.borderColor = [UIColor colorWithWhite:0.0 alpha:1.0].CGColor;
    dragView.layer.borderWidth = 1.0;
    dragView.layer.masksToBounds = YES;
    return dragView;
}


-(OBDropAction) ovumEntered:(OBOvum*)ovum inView:(UIView*)view atLocation:(CGPoint)location
{
    if (view == self.backLogCollection || view == self.inProgressCollection || view == self.finishedCollection) {
        view.backgroundColor = [UIColor grayColor];
    }
    
    return OBDropActionCopy;
}

-(void) ovumExited:(OBOvum*)ovum inView:(UIView*)view atLocation:(CGPoint)location
{
    if (view == self.backLogCollection || view == self.inProgressCollection || view == self.finishedCollection)
        view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}


-(void) ovumDropped:(OBOvum*)ovum inView:(UIView*)view atLocation:(CGPoint)location
{
    NSMutableArray* targetTaskArray;
    if (view == self.backLogCollection) {
        targetTaskArray = self.backLogTasks;
    } else if (view == self.inProgressCollection) {
        targetTaskArray = self.inProgressTasks;
    } else {
        targetTaskArray = self.finishedTasks;
    }

    [targetTaskArray addObject:ovum.dataObject];

    [self storeArrays];
    
    [self reloadCollections];
    
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)storeArrays
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.storedArray forKey:self.storageKey];
    [userDefaults synchronize];
}

- (IBAction)addButtonClicked:(id)sender {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Please add task description" message:@"" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;

    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.backLogTasks addObject:[alertView textFieldAtIndex:0].text];
    [self.backLogCollection reloadData];
    
    [self storeArrays];
}

@end
