//
//  JCTiledScrollView.m
//
//  Created by Jesse Collis on 1/2/2012.
//  Copyright (c) 2012, Jesse Collis JC Multimedia Design.
//  <jesse@jcmultimedia.com.au>
//  All rights reserved.
//
//  * Redistribution and use in source and binary forms, with or without
//   modification, are permitted provided that the following conditions are met:
//
//  * Redistributions of source code must retain the above copyright
//   notice, this list of conditions and the following disclaimer.
//
//  * Redistributions in binary form must reproduce the above copyright
//   notice, this list of conditions and the following disclaimer in the
//   documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
//  FOR ANY
//  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
//  THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE
//

#import "JCTiledScrollView.h"

#import "JCTiledScrollView-Swift.h"

#import "ADAnnotationTapGestureRecognizer.h"

#define kStandardUIScrollViewAnimationTime (int64_t)0.10

@implementation JCTiledScrollView_objc

+ (id)tiledViewFromClass:(Class)class frame:(CGRect)frame{
	return [[class alloc] initWithFrame:frame];
}

#pragma mark -

+ (void)o_correctScreenPositionOfAnnotations:(JCTiledScrollView*)theScrollView
{
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.0];

    if ((theScrollView.scrollView.isZoomBouncing || theScrollView.muteAnnotationUpdates) && !theScrollView.scrollView.isZooming) {
        for (JCVisibleAnnotationTuple* t in theScrollView.visibleAnnotations) {
            t.view.position = [theScrollView screenPositionForAnnotation:t.annotation];
        }
    }
    else {
        for (id<JCAnnotation> annotation in theScrollView.annotations) {

            CGPoint screenPosition = [theScrollView screenPositionForAnnotation:annotation];
            JCVisibleAnnotationTuple* t =
                [theScrollView.visibleAnnotations visibleAnnotationTupleForAnnotation:annotation];

            if ([theScrollView point:screenPosition isWithinBounds:theScrollView.bounds]) {
                if (nil == t) {
                    JCAnnotationView* view =
                        [theScrollView.tiledScrollViewDelegate tiledScrollView:theScrollView
                                                viewForAnnotation:annotation];

                    if (nil == view)
                        continue;
                    view.position = screenPosition;

                    t = [JCVisibleAnnotationTuple instanceWithAnnotation:annotation
                                                                    view:view];
                    if ([theScrollView.tiledScrollViewDelegate
                            respondsToSelector:@selector(tiledScrollView:
                                                    annotationWillAppear:)]) {
                        [theScrollView.tiledScrollViewDelegate tiledScrollView:theScrollView
                                                 annotationWillAppear:t.annotation];
                    }

                    if (t) {
                        [theScrollView.visibleAnnotations addObject:t];
                        [theScrollView.canvasView addSubview:t.view];
                    }

                    [CATransaction setValue:(id)kCFBooleanTrue
                                     forKey:kCATransactionDisableActions];
                    CABasicAnimation* theAnimation =
                        [CABasicAnimation animationWithKeyPath:@"opacity"];
                    theAnimation.duration = 0.3;
                    theAnimation.repeatCount = 1;
                    theAnimation.fromValue = [NSNumber numberWithFloat:0.0];
                    theAnimation.toValue = [NSNumber numberWithFloat:1.0];
                    [t.view.layer addAnimation:theAnimation forKey:@"animateOpacity"];

                    if ([theScrollView.tiledScrollViewDelegate
                            respondsToSelector:@selector(tiledScrollView:
                                                     annotationDidAppear:)]) {
                        [theScrollView.tiledScrollViewDelegate tiledScrollView:theScrollView
                                                  annotationDidAppear:t.annotation];
                    }
                }
                else {
                    if (t == theScrollView.currentSelectedAnnotationTuple) {
                        [theScrollView.canvasView addSubview:t.view];
                    }
                    t.view.position = screenPosition;
                }
            }
            else {
                if (nil != t) {
                    if ([theScrollView.tiledScrollViewDelegate
                            respondsToSelector:@selector(tiledScrollView:
                                                   annotationWillDisappear:)]) {
                        [theScrollView.tiledScrollViewDelegate tiledScrollView:theScrollView
                                                 annotationWillAppear:t.annotation];
                    }

                    if (t != theScrollView.currentSelectedAnnotationTuple) {
                        [t.view removeFromSuperview];
                        if (t.view) {
                            [theScrollView.recycledAnnotationViews addObject:t.view];
                        }
                        [theScrollView.visibleAnnotations removeObject:t];
                    }
                    else {
                        // FIXME: Anthony D - I don't like let the view in visible
                        // annotations array, but the logic is in one place
                        [t.view removeFromSuperview];
                    }

                    if ([theScrollView.tiledScrollViewDelegate
                            respondsToSelector:@selector(tiledScrollView:
                                                   annotationDidDisappear:)]) {
                        [theScrollView.tiledScrollViewDelegate tiledScrollView:theScrollView
                                               annotationDidDisappear:t.annotation];
                    }
                }
            }
        }
    }
    [CATransaction commit];
}

@end
