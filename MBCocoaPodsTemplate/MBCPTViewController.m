//
//  MBCPTViewController.m
//  MBCocoaPodsTemplate
//
//  Created by Justin R. Miller on 11/1/13.
//  Copyright (c) 2013 MapBox. All rights reserved.
//

#import "MBCPTViewController.h"

#import <MapBox/MapBox.h>

@interface MBCPTViewController () <RMMapViewDelegate>

@property (nonatomic) RMMapView *mapView;

@end

@implementation MBCPTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.mapView = [[RMMapView alloc] initWithFrame:self.view.bounds];

    [self.view addSubview:self.mapView];

    self.mapView.delegate = self;

    NSDictionary *flight = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"flight" ofType:@"json"]]
                                                           options:0
                                                             error:nil];

    NSMutableArray *points = [NSMutableArray array];

    for (NSArray *coordinatePair in flight[@"features"][0][@"geometry"][@"coordinates"][0])
    {
        CLLocationDegrees lat = [coordinatePair[1] doubleValue];
        CLLocationDegrees lon = [coordinatePair[0] doubleValue];

        [points addObject:[[CLLocation alloc] initWithLatitude:lat longitude:lon]];

        if ([points count] == 30)
        {
            RMAnnotation *annotation = [[RMAnnotation alloc] initWithMapView:self.mapView coordinate:[points[0] coordinate] andTitle:nil];
            [annotation setBoundingBoxFromLocations:points];
            annotation.userInfo = points;
            [self.mapView addAnnotation:annotation];
            points = [NSMutableArray arrayWithObject:[points lastObject]];
        }
    }

    NSArray *bboxCoordinates = flight[@"features"][0][@"geometry"][@"bbox"];

    CLLocationCoordinate2D ne = CLLocationCoordinate2DMake([bboxCoordinates[1] doubleValue], [bboxCoordinates[0] doubleValue]);
    CLLocationCoordinate2D sw = CLLocationCoordinate2DMake([bboxCoordinates[3] doubleValue], [bboxCoordinates[2] doubleValue]);

    [self.mapView zoomWithLatitudeLongitudeBoundsSouthWest:sw northEast:ne animated:NO];
    self.mapView.zoom -= 0.5;
}

#pragma mark -

- (RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation
{
    if (annotation.isUserLocationAnnotation)
        return nil;

    NSArray *points = annotation.userInfo;

    RMShape *shape = [[RMShape alloc] initWithView:mapView];

    NSArray *colors = @[ @"red", @"yellow", @"green", @"blue", @"cyan", @"magenta", @"white", @"lightGray", @"brown" ];

    shape.lineColor = [[UIColor class] performSelector:NSSelectorFromString([NSString stringWithFormat:@"%@Color", [colors objectAtIndex:(rand() % [colors count])]])];
    shape.lineJoin = kCALineJoinRound;
    shape.lineWidth = 3.0;

    for (CLLocation *point in points)
        [shape addLineToCoordinate:point.coordinate];

    return shape;
}

@end
