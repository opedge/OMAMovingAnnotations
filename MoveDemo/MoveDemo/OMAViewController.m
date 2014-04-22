//
//  OMAViewController.m
//  MoveDemo
//
//  Created by Oleg Poyaganov on 17/04/14.
//
//

#import "OMAViewController.h"

#import <MapKit/MapKit.h>

#import "OMAMovingAnnotations.h"

#define ARC4RANDOM_MAX 0x100000000

static CLLocationCoordinate2D const OMAMapViewDefaultCenter = (CLLocationCoordinate2D){ 55.756651, 37.624881 };
static CLLocationDistance const OMAMapViewDefaultSpanInMeters = 30000;
static NSUInteger const OMAViewControllerAnnotationsCount = 20;

@interface OMAViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (assign, nonatomic) MKCoordinateRegion region;

@property (strong, nonatomic) OMAMovingAnnotationsAnimator *animator;

@end

@implementation OMAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMapView];
    [self setupAnnotations];
    [self.animator startAnimating];
}

- (void)setupMapView {
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(OMAMapViewDefaultCenter, OMAMapViewDefaultSpanInMeters, OMAMapViewDefaultSpanInMeters);
    [self.mapView setRegion:region];
    self.region = region;
}

- (void)setupAnnotations {
    self.animator = [[OMAMovingAnnotationsAnimator alloc] init];
    
    for (NSInteger i = 0; i < OMAViewControllerAnnotationsCount; i++) {
        OMAMovePath *path = [[OMAMovePath alloc] init];
        
        CLLocationCoordinate2D start = [self randomCoordinateInRegion:self.region];
        CLLocationCoordinate2D end = [self randomCoordinateInRegion:self.region];
        
        [path addSegment:OMAMovePathSegmentMake(start, end, [self randomDoubleBetweenMin:5 max:10])];
        
        OMAMovingAnnotation *annotation = [[OMAMovingAnnotation alloc] init];
        annotation.coordinate = start;
        annotation.movePath = path;
        [annotation addObserver:self forKeyPath:@"moving" options:NSKeyValueObservingOptionNew context:NULL];
        [self.mapView addAnnotation:annotation];
        [self.animator addAnnotation:annotation];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"moving"]) {
        BOOL moving = [change[NSKeyValueChangeNewKey] boolValue];
        if (!moving) {
            OMAMovingAnnotation *annotation = object;
            if ([annotation.movePath isEmpty] && OMAMovePathSegmentIsNull(annotation.currentSegment)) {
                OMAMovePathSegment segment = OMAMovePathSegmentMake(annotation.coordinate, [self randomCoordinateInRegion:self.region], [self randomDoubleBetweenMin:5 max:10]);
                [annotation.movePath addSegment:segment];
            }
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc {
    for (OMAMovingAnnotation *annotation in self.mapView.annotations) {
        [annotation removeObserver:self forKeyPath:@"moving"];
    }
}

- (double)randomDoubleBetweenMin:(double)min max:(double)max {
    return ((double)arc4random() / ARC4RANDOM_MAX) * (max - min) + min;
}

- (CLLocationCoordinate2D)randomCoordinateInRegion:(MKCoordinateRegion)region {
    CLLocationDegrees minLat = region.center.latitude - region.span.latitudeDelta / 2.;
    CLLocationDegrees maxLat = region.center.latitude + region.span.latitudeDelta / 2.;
    CLLocationDegrees minLon = region.center.longitude - region.span.longitudeDelta / 2.;
    CLLocationDegrees maxLon = region.center.longitude + region.span.longitudeDelta / 2.;
    return CLLocationCoordinate2DMake([self randomDoubleBetweenMin:minLat max:maxLat],
                                [self randomDoubleBetweenMin:minLon max:maxLon]);
}

@end
