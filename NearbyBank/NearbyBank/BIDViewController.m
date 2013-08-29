//
//  BIDViewController.m
//  NearbyBank
//
//  Created by kerofrog on 8/19/13.
//  Copyright (c) 2013 kerofrog. All rights reserved.
//

#import "BIDViewController.h"

#define degreesToRadians(x) (M_PI * (x) / 180.0)
@interface BIDViewController ()

@end

@implementation BIDViewController
@synthesize btnAdSearch;
@synthesize btnBySuburb;
@synthesize btnNearby;
@synthesize myView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self setFrame:[self interfaceOrientation]];
}

-(void)setFrame:(UIInterfaceOrientation) interfaceOrientation{
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
        self.lblTitle.frame = CGRectMake(20, 20, 280, 100);
        self.btnNearby.frame = CGRectMake(20, 180, 280, 60);
        self.btnBySuburb.frame = CGRectMake(20, 253, 280, 60);
        self.btnAdSearch.frame = CGRectMake(20, 326, 280, 60);
    }else
    {
        self.lblTitle.frame = CGRectMake(20, 20, 440, 60);
        self.btnNearby.frame = CGRectMake(20, 110, 220, 60);
        self.btnBySuburb.frame = CGRectMake(250, 110, 220, 60);
        self.btnAdSearch.frame = CGRectMake(20, 180, 440, 60);
    }
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self setFrame:toInterfaceOrientation];
}
@end
