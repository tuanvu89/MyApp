//
//  BIDDetailViewController.m
//  NearbyBank
//
//  Created by kerofrog on 8/20/13.
//  Copyright (c) 2013 kerofrog. All rights reserved.
//

#import "BIDNearbyViewController.h"
#import "BIDDetailViewController.h"
#import <MapKit/MapKit.h>


#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define kGOOGLE_API_KEY @"AIzaSyDpqmJIb0JcL5unRlibKPC0lG_Kb39QLJo"

@interface BIDDetailViewController ()<CLLocationManagerDelegate>

@end

@implementation BIDDetailViewController
@synthesize nameLabel,addressLabel,btnGetDirect,btnPhone,btnViewMap, name, address, refecenceString;

static CLLocationCoordinate2D destinationReturnOnDetail;

-(void)viewWillAppear:(BOOL)animated
{
    [self setFrame:[self interfaceOrientation]];
}

-(void)setFrame:(UIInterfaceOrientation) interfaceOrientation{
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
        self.btnPhone.frame = CGRectMake(20, 190, 280, 60);
        self.btnViewMap.frame = CGRectMake(20, 260, 280, 60);
        self.btnGetDirect.frame = CGRectMake(20, 330, 280, 60);
    }else
    {
        self.btnPhone.frame = CGRectMake(20, 110, 220, 60);
        self.btnViewMap.frame = CGRectMake(250, 110, 220, 60);
        self.btnGetDirect.frame = CGRectMake(20, 180, 450, 60);
    }
}
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self setFrame:toInterfaceOrientation];
}


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
    
    //modify button image
    UIImage *btnImageNormal = [UIImage imageNamed:@"whiteButton.png"];
    UIImage *btnImagePress = [UIImage imageNamed:@"BlueButton.png"];
    
    UIImage *stretchabeImgNormal = [btnImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    UIImage *stretchableImgPress = [btnImagePress stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    
    [btnGetDirect setBackgroundImage:stretchabeImgNormal forState:UIControlStateNormal];
    [btnPhone setBackgroundImage:stretchabeImgNormal forState:UIControlStateNormal];
    [btnViewMap setBackgroundImage:stretchabeImgNormal forState:UIControlStateNormal];
    
    [btnGetDirect setBackgroundImage:stretchableImgPress forState:UIControlStateHighlighted];
    [btnPhone setBackgroundImage:stretchableImgPress forState:UIControlStateHighlighted];
    [btnViewMap setBackgroundImage:stretchableImgPress forState:UIControlStateHighlighted];
    
    [self queryPlaceInformation:refecenceString];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.name = nil;
    self.address = nil;
    self.refecenceString = nil;
    self.listDataReturn = nil;
}

- (IBAction)calling:(id)sender {
    NSString *phoneNumber = [NSString stringWithFormat:@"tel://%@" , btnPhone.titleLabel.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

-(void) returnDataToNearbyView : (NSString *) IDButtonReturn
{
    BIDNearbyViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"BIDNearbyViewController"];
    controller.IDViewerReturn = @"BIDDetailViewController";
    if ([IDButtonReturn isEqualToString:@"GetDirection"]) {
        controller.IDButtonReturn = @"GetDirection";
        controller.destinationReturn = destinationReturnOnDetail;
    }
    if ([IDButtonReturn isEqualToString:@"ViewOnMap"]) {
        controller.IDButtonReturn = @"ViewOnMap";
    }
    //tra ve vi tri va du lieu trong bang
    controller.indexOfTableReturn = self.indexReturn;
    controller.listData = self.listDataReturn;
    controller.wasDrawDirection = NO;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)btnViewOnMapTouch:(id)sender {
    [self returnDataToNearbyView:@"ViewOnMap"];
}

- (IBAction)getDirection:(id)sender {
    [self returnDataToNearbyView:@"GetDirection"];
}


-(void) queryPlaceInformation: (NSString *) referenceString{
    NSString *urlInformation = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?reference=%@&sensor=true&key=%@", referenceString, kGOOGLE_API_KEY];
    NSLog(@"%@", urlInformation);
    NSURL *googleRequestURL=[NSURL URLWithString:urlInformation];
    
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
        [self performSelectorOnMainThread:@selector(fetchedInformation:) withObject:data waitUntilDone:YES];
    });
    
}


-(void) fetchedInformation:(NSData *)responseData{
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    NSLog(@"%@", json);
    //get phone number from (dic) json variable obtain with the key "formatted_phone_number"
    NSDictionary* detail = [json objectForKey:@"result"];
    NSString* phoneNumber = [detail objectForKey:@"international_phone_number"];
    
    NSLog(@"so dien thoai %@", phoneNumber);
    if(phoneNumber != nil){
        [self.btnPhone setTitle:phoneNumber forState:UIControlStateNormal];
    }else{
        [self.btnPhone setTitle:@"Phone Number not found" forState:UIControlStateNormal];
    }
    
    nameLabel.text = [detail objectForKey:@"name"];
    addressLabel.text = [detail objectForKey:@"formatted_address"];
    
    CLLocationCoordinate2D curLocation;
    NSDictionary *vertex=[(NSDictionary*)[detail objectForKey:@"geometry"] objectForKey:@"location"];
    curLocation.latitude = [[vertex objectForKey:@"lat"] doubleValue];
    curLocation.longitude = [[vertex objectForKey:@"lng"] doubleValue];
    destinationReturnOnDetail = curLocation;
}
@end
