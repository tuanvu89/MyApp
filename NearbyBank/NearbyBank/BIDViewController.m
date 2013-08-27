//
//  BIDViewController.m
//  NearbyBank
//
//  Created by kerofrog on 8/19/13.
//  Copyright (c) 2013 kerofrog. All rights reserved.
//

#import "BIDViewController.h"

@interface BIDViewController ()

@end

@implementation BIDViewController
@synthesize btnAdSearch;
@synthesize btnBySuburb;
@synthesize btnNearby;

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
    UIImage *btnImageNormal = [UIImage imageNamed:@"whiteButton.png"];
    UIImage *btnImagePress = [UIImage imageNamed:@"BlueButton.png"];
    
    UIImage *stretchabeImgNormal = [btnImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    UIImage *stretchableImgPress = [btnImagePress stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    
    [btnNearby setBackgroundImage:stretchabeImgNormal forState:UIControlStateNormal];
    [btnAdSearch setBackgroundImage:stretchabeImgNormal forState:UIControlStateNormal];
    [btnBySuburb setBackgroundImage:stretchabeImgNormal forState:UIControlStateNormal];
    
    [btnBySuburb setBackgroundImage:stretchableImgPress forState:UIControlStateHighlighted];
    [btnAdSearch setBackgroundImage:stretchableImgPress forState:UIControlStateHighlighted];
    [btnNearby setBackgroundImage:stretchableImgPress forState:UIControlStateHighlighted];
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
