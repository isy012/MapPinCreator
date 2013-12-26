//
//  MapAnnotation.h
//  MapPinCreator
//
//  Created by Isabelle Park on 12/24/13.
//  Copyright (c) 2013 izzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapAnnotation : NSObject <MKAnnotation> {
    NSString *title;
    NSString *subtitle;
    NSString *note;
    
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end
