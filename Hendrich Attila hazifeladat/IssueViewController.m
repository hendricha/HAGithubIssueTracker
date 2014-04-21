//
//  IssueViewController.m
//  Hendrich Attila hazifeladat
//
//  Created by user on 4/20/14.
//  Copyright (c) 2014 user. All rights reserved.
//

#import "IssueViewController.h"

@interface IssueViewController ()

@end

@implementation IssueViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.account = self.account ? self.account : @"hendricha";
    self.repo = self.repo ? self.repo : @"sandbox";

    [self loadData];
}

- (void)loadData
{
    self.title = [NSString stringWithFormat:@"Issues for %@/%@", self.account, self.repo];
    self.issues = [[NSMutableArray alloc]init];
    [self.tableView reloadData];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *target = [NSString stringWithFormat:@"https://api.github.com/repos/%@/%@/issues", self.account, self.repo];
    
    [manager GET:target parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        responseObject = [responseObject sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSNumber *issueNumber1 = a[@"number"];
            NSNumber *issueNumber2 = b[@"number"];
            return [issueNumber1 compare:issueNumber2];
        }];
        
        if (self.showAll) {
            self.issues = responseObject;
        } else {
            for(id issue in responseObject) {
                for(id label in issue[@"labels"]) {
                    if ([label[@"name"] isEqual: @"bug"] || [label[@"name"] isEqual: @"enhancement"]) {
                        [self.issues addObject:issue];
                        break;
                    }
                }
            }
        }
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection error"
                                                        message:@"Could not retrieve issues. (Check logs for why.)"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    NSLog(@"WTF: %@", self.issues);
    if (self.issues) {
        return [self.issues count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    IssueCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSLog(@"EJJ %@", self.issues[indexPath.row]);
    cell.title.text = self.issues[indexPath.row][@"title"];
    
    NSNumber *issueNumber = self.issues[indexPath.row][@"number"];
    cell.number.text = [issueNumber stringValue];
    
    for(id label in self.issues[indexPath.row][@"labels"]) {
        if ([label[@"name"] isEqual: @"bug"]) {
            cell.number.backgroundColor = [UIColor redColor];
            break;
        }
    }
    
    return cell;
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
