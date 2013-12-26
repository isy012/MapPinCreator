//
//  ViewController.m
//  MapPinCreator
//
//  Created by Isabelle Park on 12/24/13.
//  Copyright (c) 2013 izzy. All rights reserved.
//

#import "ViewController.h"
#import "MapAnnotation.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.mapView setDelegate:self];
    [self addGestureRecogniserToMapView];
    _isOnMap = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addGestureRecogniserToMapView{
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(addPinToMap:)];
    lpgr.minimumPressDuration = 0.5; //
    [self.mapView addGestureRecognizer:lpgr];
    
}

- (void)addPinToMap:(UIGestureRecognizer *)gestureRecognizer
{
    
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    MapAnnotation *toAdd = [[MapAnnotation alloc]init];
    
    toAdd.coordinate = touchMapCoordinate;
    toAdd.subtitle = @"Subtitle";
    toAdd.title = @"Title";
    
    [self.mapView addAnnotation:toAdd];
    
}

/*
 On the background thread, retrieve the Array of Annotations from the JSON from the next function.
 On the main thread, add the annotations to the map.
 */
- (IBAction)addCitiesToMap:(id)sender{
    __block NSArray *annotations;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        annotations = [self parseJSONCities];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            if (!_isOnMap){
            [self.mapView addAnnotations:annotations];
                NSLog(@"adding to map");
                _isOnMap = YES;}
            else if (_isOnMap) {
                [self.mapView removeAnnotations:annotations];
                _isOnMap = NO;
                NSLog(@"aint on the map now");
            }
        });
    });
    
    
}

/*
 Convert raw JSON to Objective-C Foundation Objects
 Iterate over each returned object and create a JFMapAnnotationObject from it
 Add each new Annotation to an Array and then return it.
 */
- (NSMutableArray *)parseJSONCities{
    
    NSMutableArray *retval = [[NSMutableArray alloc]init];
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"capitals"
                                                         ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    NSError *error = nil;
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data
                                                    options:kNilOptions
                                                      error:&error];
    
    for (MapAnnotation *record in json) {
        
        MapAnnotation *temp = [[MapAnnotation alloc]init];
        [temp setTitle:[record valueForKey:@"Capital"]];
        [temp setSubtitle:[record valueForKey:@"Country"]];
        [temp setCoordinate:CLLocationCoordinate2DMake([[record valueForKey:@"Latitude"]floatValue], [[record valueForKey:@"Longitude"]floatValue])];
        [retval addObject:temp];
        
    }
    
    return retval;
}

@end
