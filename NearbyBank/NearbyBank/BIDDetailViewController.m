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
    
    [self queryPlaceInformation:refecenceString];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    controller.indexOfTableReturn = self.index;
    controller.listData = self.listDataReturn;
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
