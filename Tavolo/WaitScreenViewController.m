//
//  WaitScreenViewController.m
//  Tavolo
//
//  Created by MAC on 4/13/15.
//  Copyright (c) 2015 Tavolo Team. All rights reserved.
//

#import "WaitScreenViewController.h"

@interface WaitScreenViewController ()

@end

@implementation WaitScreenViewController {
    UIImage *downImage, *upImage;
    UIBarButtonItem *specialsButton;
    Boolean specialsShowing;
    NSInteger mins;
    NSTimer *timer;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (void)viewDidLoad {
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    [self drawCircle];
    
    // start location services
    locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.delegate = self;
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
    
    // get info about restaurant
    PFQuery *queueQuery = [PFQuery queryWithClassName:@"Queue"];
    [queueQuery whereKey:@"user" equalTo:[PFUser currentUser]];
    [queueQuery includeKey:@"venue"];
    [queueQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!objects || objects.count == 0) [NSException raise:@"something went wrong with the query" format:nil];
        PFObject *venue = [((PFObject *)[objects objectAtIndex:1]) objectForKey:@"venue"];
        venueLocation = [venue objectForKey:@"location"];
    }];
    
    //Set up toolbar
    downImage = [UIImage imageNamed:@"Down4-50.png"];
    upImage = [UIImage imageNamed:@"Up4-50.png"];
    specialsButton = [[UIBarButtonItem alloc] initWithImage:downImage style:UIBarButtonItemStylePlain target:self action:@selector(dropMenu)];
    /*UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];*/
    [_toolbar setItems:[NSArray arrayWithObjects:specialsButton, nil]];
    
    //Set up Drop Down View
    _arrayData = @[@"Pizza        $12.99", @"Steak        $17.99", @"Cheesecake        $9.99"];
    
    _dropDown = [[DropDownViewController alloc] initWithArrayData:_arrayData cellHeight:30 heightTableView:200 paddingTop:-8 paddingLeft:-5 paddingRight:-10 refView:_toolbar animation:BLENDIN openAnimationDuration:1 closeAnimationDuration:1];
    
    [self.view addSubview:_dropDown.view];
    
    specialsShowing = NO;
    
    //Wait Time
    PFQuery *query = [PFQuery queryWithClassName:@"newQueue"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *waitObj, NSError *er)
     {
         if(waitObj.count == 0) //Makes sure you are a registered guest in Queue
         {
             _waitTimeLabel.text = @"0";
         }
         else
         {
             PFObject *obj = [waitObj objectAtIndex:0];
             //Dates to get difference from
             NSDate *start = [obj createdAt];
             NSDate *end = [obj objectForKey:@"seatTime"];
             
             //formats dates appropriately
             NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
             [dateFormatter setDateFormat:@"hh:mm a"];
             NSString *stringFromDate = [dateFormatter stringFromDate:[obj objectForKey:@"createdAt"]];
             NSString *stringFromDate2 = [dateFormatter stringFromDate:[obj objectForKey:@"seatTime"]];
             
             NSLog(@"Date 1: %@ ... Date 2: %@", stringFromDate, stringFromDate2);
             
             //Calculates difference and sends it to UI
              NSTimeInterval distanceBetweenDates = [end timeIntervalSinceDate:start];
             double secondsInAMin = 60;
             mins = distanceBetweenDates / secondsInAMin;
             NSLog(@"Minutes %lu", mins);
             NSString *minutes = [NSString stringWithFormat:@"%lu", mins];
             _waitTimeLabel.text = minutes;
             
             //Start timer to update waiting time every minute ... cancels timer at 0
             timer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(updateWaitTime) userInfo:nil repeats:YES];
         }
     }];
}

//Fired by timer to update wait time label every minute
- (void)updateWaitTime {
    if(mins == 0)
    {
        [timer invalidate]; // cancels timer
    }
    else
    {
        mins--;
        NSString *waitTime = [NSString stringWithFormat:@"%lu",mins]; //gets remaining time
        _waitTimeLabel.text = waitTime; //sets timer value on UI
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    lastLocation = ((CLLocation *)[locations lastObject]); //obtains last location via coordinates
    PFGeoPoint *currentLocationGeoPoint = [PFGeoPoint geoPointWithLocation:lastLocation]; // current location
    if (venueLocation) [self getWalkingTimeFromLocation:currentLocationGeoPoint toLocation:venueLocation]; // gets walking distance based on venue
}

/***********************************
 leaves Queue when user no longer wishes to wait in this line
 **********************************/
- (IBAction)leaveQueue:(id)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"Queue"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query whereKeyExists:@"venue"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [((PFObject *)[objects objectAtIndex:0]) deleteInBackground];
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// Animation to display specials drop down menu
- (void)dropMenu {
    if(specialsShowing) //shows specials
    {
        [_dropDown closeAnimation];
        specialsShowing = NO;
        [specialsButton setImage:downImage];
        
    }
    else // close animation
    {
        [_dropDown openAnimation];
        specialsShowing = YES;
        [specialsButton setImage:upImage];
    }
}

- (IBAction)callPhone:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://6103372200"]]; //Calls CheeseCake factory for now
}

- (void)drawCircle { // draws wait timer circle
    // Set up the shape of the circle
    int radius = 90;
    CAShapeLayer *circle = [CAShapeLayer layer];
    // Make a circular shape
    circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius, 2.0*radius)
                                             cornerRadius:radius].CGPath;
    // Center the shape in self.view
    circle.position = CGPointMake(CGRectGetMidX(self.waitTimeLabel.frame)-radius - 128,
                                  CGRectGetMidY(self.waitTimeLabel.frame)-radius - 133);
    
    // Configure the apperence of the circle
    circle.fillColor = [UIColor lightGrayColor].CGColor;
    circle.opacity = 0.4f;
    //circle.strokeColor = [UIColor blackColor].CGColor;
    //circle.lineWidth = 5;
    
    // Add to parent layer
    [self.waitTimeLabel.layer addSublayer:circle];
}

- (NSString *)getWalkingTimeFromLocation:(PFGeoPoint *)currentLocation toLocation:(PFGeoPoint *)theVenueLocation {
    NSString *walkingTime = [[NSString alloc] init];
    
    if (!currentLocation || !theVenueLocation) {
        [NSException raise:@"calls to getWalkingTimeFromLocation:toLocation: must provide both location arguments" format:nil];
    }
    
    NSString *apiURL = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/distancematrix/json?origins=%f,%f&destinations=%f,%f&mode=walking", currentLocation.latitude, currentLocation.longitude, theVenueLocation.latitude, theVenueLocation.longitude];
    
    NSURL *url = [NSURL URLWithString:apiURL];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    
    NSURLResponse *response;
    NSError *error;
    NSData *data;
    data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSMutableDictionary *jsonDict= (NSMutableDictionary*)[NSJSONSerialization  JSONObjectWithData:data options:kNilOptions error:&error];
    NSMutableDictionary *newdict=[jsonDict valueForKey:@"rows"];
    NSArray *elementsArr=[newdict valueForKey:@"elements"];
    NSArray *arr=[elementsArr objectAtIndex:0];
    NSDictionary *dict=[arr objectAtIndex:0];
    NSMutableDictionary *distanceDict=[dict valueForKey:@"duration"];
    
    walkingTime = [distanceDict valueForKey:@"text"];
    
    self.returnTimeLabel.text = walkingTime;
    
    return walkingTime;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
