//
//  BIDNearbyViewController.m
//  NearbyBank
//
//  Created by kerofrog on 8/19/13.
//  Copyright (c) 2013 kerofrog. All rights reserved.
//

#import "BIDNearbyViewController.h"
#import "BIDDetailViewController.h"

#define METERS_PER_MILE 1609.344
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define kSearchBankURL [NSURL URLWithString: @"http://local.yahooapis.com/LocalSearchService/V3/localSearch?appid=YahooDemo&query=bank&location=newyork&results=3&output=json"]

@interface NSDictionary(JSONCategories)
+(NSDictionary*)dictionaryWithContentsOfJSONURLString:(NSString*)urlAddress;
-(NSData*)toJSON;
@end

@implementation NSDictionary(JSONCategories)

+(NSDictionary*)dictionaryWithContentsOfJSONURLString:(NSString*)urlAddress
{
    NSData* data = [NSData dataWithContentsOfURL: [NSURL URLWithString: urlAddress] ];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}

-(NSData*)toJSON
{
    NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}
@end

@interface BIDNearbyViewController ()


@end

@implementation BIDNearbyViewController
@synthesize nearbyTable;
@synthesize mapView = _mapView;
@synthesize listData;


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
    
    self.mapView.delegate = self;
    
    //load json
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: kSearchBankURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.listData= nil;
}

#pragma JSON

- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:kNilOptions
                                                           error:&error];
    NSDictionary* resultSet = [json objectForKey:@"ResultSet"];
    NSArray* result = [resultSet objectForKey:@"Result"];
    NSLog(@"%@" ,result);
    
    listData = result;
    [nearbyTable reloadData];
    
}


#pragma segment toogle ----------------
- (IBAction)segmentValueChange:(id)sender {
    if([sender selectedSegmentIndex] == 0)
    {
        nearbyTable.hidden = NO;
        self.mapView.hidden = YES;
        
    }else
    {
        nearbyTable.hidden = YES;
        self.mapView.hidden = NO;
    }
}

#pragma table ------------------
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listData count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bankResultCell"];
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:1];
    UILabel *addressLabel = (UILabel *)[cell viewWithTag:2];
    if(listData != nil)
    {
        nameLabel.text = [(NSDictionary*)[listData objectAtIndex:indexPath.row] objectForKey:@"Title"];
        addressLabel.text = [(NSDictionary*)[listData objectAtIndex:indexPath.row] objectForKey:@"Address"];
    }
    
    return cell;
}

#pragma Map View


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark -MapView Delegate Methods


- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    for(MKAnnotationView *annotationView in views) {
        if(annotationView.annotation == mapView.userLocation) {
            MKCoordinateRegion region;
            MKCoordinateSpan span;
            
            span.latitudeDelta=0.1;
            span.longitudeDelta=0.1;
            
            CLLocationCoordinate2D location=mapView.userLocation.coordinate;
            
            region.span=span;
            region.center=location;
            
            [mapView setRegion:region animated:TRUE];
            [mapView regionThatFits:region];
        }
    }
}

#pragma segue

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    BIDDetailViewController *controller = segue.destinationViewController;
    NSIndexPath *indexPath = [nearbyTable indexPathForCell:sender];
    
    controller.name = [(NSDictionary*)[listData objectAtIndex:indexPath.row] objectForKey:@"Title"];
    controller.address = [(NSDictionary*)[listData objectAtIndex:indexPath.row] objectForKey:@"Address"];
    controller.phone = [(NSDictionary*)[listData objectAtIndex:indexPath.row] objectForKey:@"Phone"];
}

@end
