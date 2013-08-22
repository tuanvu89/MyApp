//
//  BIDDetailViewController.m
//  NearbyBank
//
//  Created by kerofrog on 8/20/13.
//  Copyright (c) 2013 kerofrog. All rights reserved.
//

#import "BIDNearbyViewController.h"
#import "BIDDetailViewController.h"


#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define kGOOGLE_API_KEY @"AIzaSyDpqmJIb0JcL5unRlibKPC0lG_Kb39QLJo"

@interface BIDDetailViewController ()

@end

@implementation BIDDetailViewController
@synthesize nameLabel,addressLabel,btnGetDirect,btnPhone,btnViewMap, name, address, refecenceString;


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
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    BIDNearbyViewController *controller = segue.destinationViewController;
    controller.IDViewer = @"BIDDetailViewController";
}
@end
