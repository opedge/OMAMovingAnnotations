//
// OMAStructs.m
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

#import "OMAStructs.h"

OMAMovePathSegment const OMAMovePathSegmentNull = { {0, 0}, {0, 0}, 0 };

BOOL OMAMovePathSegmentIsNull(OMAMovePathSegment segment) {
    return (segment.from.latitude == 0)
    && (segment.from.longitude == 0)
    && (segment.to.latitude == 0)
    && (segment.to.longitude == 0)
    && (segment.duration == 0);
}

OMAMovePathSegment OMAMovePathSegmentMake(CLLocationCoordinate2D from, CLLocationCoordinate2D to, NSTimeInterval duration) {
    OMAMovePathSegment segment;
    segment.from = from;
    segment.to = to;
    segment.duration = duration;
    return segment;
}

float OMAMovePathSegmentGetAngle(OMAMovePathSegment segment) {
    return -atan2(segment.to.latitude - segment.from.latitude, segment.to.longitude - segment.from.longitude);
}