//
// OMAStructs.h
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

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/*
 * OMAMovePathSegment - segment of annotation's path represented by
 * line (2 points - "from" and "to") and duration in seconds.
 * Annotation will move along this line with constant speed according to
 * duration value.
 */
typedef struct {
    CLLocationCoordinate2D from;
    CLLocationCoordinate2D to;
    NSTimeInterval duration;
} OMAMovePathSegment;

extern OMAMovePathSegment const OMAMovePathSegmentNull;

extern BOOL OMAMovePathSegmentIsNull(OMAMovePathSegment segment);

extern OMAMovePathSegment OMAMovePathSegmentMake(CLLocationCoordinate2D from, CLLocationCoordinate2D to, NSTimeInterval duration);

/*
 * Angle between segment line and 0 degrees (0 degrees - right direction)
 */
float OMAMovePathSegmentGetAngle(OMAMovePathSegment segment);