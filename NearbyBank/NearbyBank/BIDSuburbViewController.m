//
//  BIDSuburbViewController.m
//  NearbyBank
//
//  Created by kerofrog on 8/19/13.
//  Copyright (c) 2013 kerofrog. All rights reserved.
//

#import "BIDSuburbViewController.h"
#import "BIDNearbyViewController.h"

@interface BIDSuburbViewController ()

@end

@implementation BIDSuburbViewController

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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"search button clicked");
    //1
//    [self performSegueWithIdentifier:@"BIDNearbyViewController" sender:nil];
    
    //2
    BIDNearbyViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"BIDNearbyViewController"];
    controller.searchInfo = searchBar.text;
    controller.IDViewer = @"BIDSuburbViewController";
    
    [self.navigationController pushViewController:controller animated:YES];
}

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"BIDNearbyViewController"]) {
//        BIDNearbyViewController *controller = segue.destinationViewController;
//        controller.searchInfo = @"asdasd";
//    }
//}

@end
