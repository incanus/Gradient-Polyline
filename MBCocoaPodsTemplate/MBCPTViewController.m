//
//  MBCPTViewController.m
//  MBCocoaPodsTemplate
//
//  Created by Justin R. Miller on 11/1/13.
//  Copyright (c) 2013 MapBox. All rights reserved.
//

#import "MBCPTViewController.h"

#import <MapBox/MapBox.h>

@interface MBCPTViewController ()

@property (nonatomic) RMMapView *mapView;

@end

@implementation MBCPTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.mapView = [[RMMapView alloc] initWithFrame:self.view.bounds];

    [self.view addSubview:self.mapView];

    NSDictionary *flight = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"flight" ofType:@"json"]]
                                                           options:0
                                                             error:nil];

    NSMutableArray *points = [NSMutableArray array];

    for (NSArray *coordinatePair in flight[@"features"][0][@"geometry"][@"coordinates"][0])
    {
        CLLocationDegrees lat = [coordinatePair[1] doubleValue];
        CLLocationDegrees lon = [coordinatePair[0] doubleValue];

        [points addObject:[[CLLocation alloc] initWithLatitude:lat longitude:lon]];
    }

    [self.mapView addAnnotation:[[RMPolylineAnnotation alloc] initWithMapView:self.mapView points:points]];

    NSArray *bboxCoordinates = flight[@"features"][0][@"geometry"][@"bbox"];

    CLLocationCoordinate2D ne = CLLocationCoordinate2DMake([bboxCoordinates[1] doubleValue], [bboxCoordinates[0] doubleValue]);
    CLLocationCoordinate2D sw = CLLocationCoordinate2DMake([bboxCoordinates[3] doubleValue], [bboxCoordinates[2] doubleValue]);

    [self.mapView zoomWithLatitudeLongitudeBoundsSouthWest:sw northEast:ne animated:NO];
    self.mapView.zoom -= 1;
}

@end
