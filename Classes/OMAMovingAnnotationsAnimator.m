//
// OMAAnnotationsAnimator.m
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

#import "OMAMovingAnnotationsAnimator.h"

#import "OMAMovingAnnotation.h"

NSInteger const OMAMovingAnnotationsAnimatorFrameIntervalDefault = 2;

@interface OMAMovingAnnotationsAnimator()

@property (nonatomic, strong) CADisplayLink *timer;

@end

@implementation OMAMovingAnnotationsAnimator {
    NSMutableSet *_annotations;
    NSInteger _frameInterval;
    
    NSMutableSet *_annotationsToRemove;
    NSMutableSet *_annotationsToAdd;
}


- (instancetype)initWithFrameInterval:(NSInteger)frameInterval {
    self = [super init];
    if (self) {
        _annotations = [NSMutableSet set];
        _frameInterval = frameInterval;
        _annotationsToRemove = [NSMutableSet set];
        _annotationsToAdd = [NSMutableSet set];
    }
    return self;
}

- (instancetype)init {
    return [self initWithFrameInterval:OMAMovingAnnotationsAnimatorFrameIntervalDefault];
}

- (void)addAnnotation:(OMAMovingAnnotation *)annotation {
    NSParameterAssert(annotation);
    [_annotationsToAdd addObject:annotation];
}

- (void)addAnnotations:(NSSet *)annotations {
    NSParameterAssert(annotations);
    [_annotationsToAdd unionSet:annotations];
}

- (void)removeAnnotation:(OMAMovingAnnotation *)annotation {
    NSParameterAssert(annotation);
    [_annotationsToRemove addObject:annotation];
}

- (void)removeAnnotations:(NSSet *)annotations {
    NSParameterAssert(annotations);
    [_annotationsToRemove unionSet:annotations];
}

- (void)removeAllAnnotations {
    [_annotationsToRemove unionSet:_annotations];
}

- (void)startAnimating {
    [self.timer invalidate];
    self.timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(doStep)];
    self.timer.frameInterval = _frameInterval;
    
    NSRunLoop *mainRunLoop = [NSRunLoop mainRunLoop];
    [self.timer addToRunLoop:mainRunLoop forMode:NSDefaultRunLoopMode];
    [self.timer addToRunLoop:mainRunLoop forMode:UITrackingRunLoopMode];
}

- (void)stopAnimating {
    [self.timer invalidate];
    self.timer = nil;
    [self setAllAnnotationsStopped];
}

- (void)setAllAnnotationsStopped {
    for (OMAMovingAnnotation *annotation in _annotations) {
        [annotation setMoving:NO];
    }
}

- (void)doStep {
    [_annotations minusSet:_annotationsToRemove];
    [_annotations unionSet:_annotationsToAdd];
    [_annotationsToAdd removeAllObjects];
    [_annotationsToRemove removeAllObjects];
    [self step];
}

- (void)step {
    for (OMAMovingAnnotation *annotation in _annotations) {
        [annotation moveStep];
    }
}

@end
