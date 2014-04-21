//
//  SecondViewController.m
//  Hendrich Attila hazifeladat
//
//  Created by user on 4/18/14.
//  Copyright (c) 2014 user. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goButtonPushed:(id)sender {
    UINavigationController *nvc = (UINavigationController*)self.tabBarController.viewControllers[0];
    IssueViewController *ivc = (IssueViewController*)nvc.viewControllers[0];
    ivc.account = self.accountField.text;
    ivc.repo = self.repoField.text;
    ivc.showAll = self.showAllSwitch.on;
    [ivc loadData];
    self.tabBarController.selectedIndex = 0;
    [nvc popToRootViewControllerAnimated:YES];
}


- (IBAction)inBrowserButtonPushed:(id)sender {
    NSString *urlString = [NSString stringWithFormat:@"https://github.com/%@/%@/issues", self.accountField.text, self.repoField.text];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}


@end
