//
//  BIDDetailViewController.m
//  NearbyBank
//
//  Created by kerofrog on 8/20/13.
//  Copyright (c) 2013 kerofrog. All rights reserved.
//

#import "BIDDetailViewController.h"

@interface BIDDetailViewController ()

@end

@implementation BIDDetailViewController
@synthesize nameLabel,addressLabel,btnGetDirect,btnPhone,btnViewMap, name, address, phone;


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
    nameLabel.text = name;
    addressLabel.text = address;
    [btnPhone setTitle:phone forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
