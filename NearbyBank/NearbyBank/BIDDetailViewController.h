//
//  BIDDetailViewController.h
//  NearbyBank
//
//  Created by kerofrog on 8/20/13.
//  Copyright (c) 2013 kerofrog. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BIDDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnPhone;
@property (weak, nonatomic) IBOutlet UIButton *btnViewMap;
@property (weak, nonatomic) IBOutlet UIButton *btnGetDirect;

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *refecenceString;
- (IBAction)calling:(id)sender;
- (IBAction)btnViewOnMapTouch:(id)sender;

@end
