//
// OMAMovingAnnotation.m
//
// Copyright (c) 2013 Oleg Poyaganov (oleg@poyaganov.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "OMAMovingAnnotation.h"

#import "OMAMovePath.h"

static double interpolate(double from, double to, NSTimeInterval time) {
    return (to - from) * time + from;
}

static CLLocationDegrees interpolateDegrees(CLLocationDegrees from, CLLocationDegrees to, NSTimeInterval time) {
    return interpolate(from, to, time);
}

static CLLocationCoordinate2D interpolateCoordinate(CLLocationCoordinate2D from, CLLocationCoordinate2D to, NSTimeInterval time) {
    return CLLocationCoordinate2DMake(interpolateDegrees(from.latitude, to.latitude, time),
                                interpolateDegrees(from.longitude, to.longitude, time));
}

@interface OMAMovingAnnotation()

@property (nonatomic, assign, readwrite) OMAMovePathSegment currentSegment;
@property (nonatomic, assign, readwrite) float angle;

@end

@implementation OMAMovingAnnotation {
    CFTimeInterval _lastStep;
    NSTimeInterval _timeOffset;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _currentSegment = OMAMovePathSegmentNull;
    }
    return self;
}

- (void)moveStep {
    if (![self isMoving]) {
        _lastStep = CACurrentMediaTime();
        
        if (OMAMovePathSegmentIsNull(_currentSegment)) {
            _currentSegment = [self.movePath popSegment];
        }
        
        if (!OMAMovePathSegmentIsNull(_currentSegment)) {
            self.moving = YES;
            [self updateAngle];
        }
    }
    
    if (OMAMovePathSegmentIsNull(_currentSegment)) {
        if (self.moving) {
            self.moving = NO;
        }
        _timeOffset = 0;
        return;
    }
    
    CFTimeInterval thisStep = CACurrentMediaTime();
    CFTimeInterval stepDuration = thisStep - _lastStep;
    _lastStep = thisStep;
    _timeOffset = MIN(_timeOffset + stepDuration, _currentSegment.duration);
    NSTimeInterval time = _timeOffset / _currentSegment.duration;
    
    self.coordinate = interpolateCoordinate(_currentSegment.from, _currentSegment.to, time);
    
    if (_timeOffset >= _currentSegment.duration) {
        _currentSegment = [self.movePath popSegment];
        _timeOffset = 0;
        
        BOOL isCurrentSegmentNull = OMAMovePathSegmentIsNull(_currentSegment);
        if (isCurrentSegmentNull && self.moving) {
            self.moving = NO;
        }
        
        if (!isCurrentSegmentNull) {
            [self updateAngle];
        }
    }
}

- (void)updateAngle {
    self.angle = OMAMovePathSegmentGetAngle(_currentSegment);
}

@end
