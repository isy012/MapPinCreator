//
//  ViewController.h
//  MapPinCreator
//
//  Created by Isabelle Park on 12/24/13.
//  Copyright (c) 2013 izzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) BOOL isOnMap;

- (void)addGestureRecogniserToMapView;

- (IBAction)addCitiesToMap:(id)sender;

@end
