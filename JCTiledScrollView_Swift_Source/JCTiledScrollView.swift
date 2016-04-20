/*

 JCTiledScrollView_Swift

 Based on the code by:

 Jesse Collis (jessedc)
 Julius Oklamcak (vfr)
 Pete Hare (petehare)
 Anthony Damotte (adamotte)



 Copyright (c) 2015 Yichi Zhang
 https://github.com/yichizhang
 zhang-yi-chi@hotmail.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

import UIKit

let kJCTiledScrollViewAnimationTime = NSTimeInterval(0.1)

@objc protocol JCTiledScrollViewDelegate: NSObjectProtocol
{
    func tiledScrollView(scrollView: JCTiledScrollView!, viewForAnnotation annotation: JCAnnotation!) -> JCAnnotationView!

    optional func tiledScrollViewDidZoom(scrollView: JCTiledScrollView) -> ()

    optional func tiledScrollViewDidScroll(scrollView: JCTiledScrollView) -> ()

    optional func tiledScrollView(scrollView: JCTiledScrollView, annotationWillDisappear annotation: JCAnnotation) -> ()

    optional func tiledScrollView(scrollView: JCTiledScrollView, annotationDidDisappear annotation: JCAnnotation) -> ()

    optional func tiledScrollView(scrollView: JCTiledScrollView, annotationWillAppear annotation: JCAnnotation) -> ()

    optional func tiledScrollView(scrollView: JCTiledScrollView, annotationDidAppear annotation: JCAnnotation) -> ()

    optional func tiledScrollView(scrollView: JCTiledScrollView, didSelectAnnotationView view: JCAnnotationView) -> ()

    optional func tiledScrollView(scrollView: JCTiledScrollView, didDeselectAnnotationView view: JCAnnotationView) -> ()

    optional func tiledScrollView(scrollView: JCTiledScrollView, didReceiveSingleTap gestureRecognizer: UIGestureRecognizer) -> ()

    optional func tiledScrollView(scrollView: JCTiledScrollView, didReceiveDoubleTap gestureRecognizer: UIGestureRecognizer) -> ()

    optional func tiledScrollView(scrollView: JCTiledScrollView, didReceiveTwoFingerTap gestureRecognizer: UIGestureRecognizer) -> ()
}

@objc protocol JCTileSource: NSObjectProtocol
{
    func tiledScrollView(scrollView: JCTiledScrollView, imageForRow row: Int, column: Int, scale: Int) -> UIImage!
}

@objc class JCTiledScrollView: UIView
{
    //Delegates
    weak var tiledScrollViewDelegate: JCTiledScrollViewDelegate?
    weak var dataSource: JCTileSource?

    //internals
    var tiledView: JCTiledView!
    var scrollView: UIScrollView!
    var canvasView: UIView!

    //Default gesture behvaiour
    var centerSingleTap: Bool = true
    var zoomsInOnDoubleTap: Bool = true
    var zoomsToTouchLocation: Bool = false
    var zoomsOutOnTwoFingerTap: Bool = true

    var _levelsOfZoom: UInt!
    var _levelsOfDetail: UInt!
    var _muteAnnotationUpdates: Bool = false

    var levelsOfZoom: UInt
    {
        set
        {
            _levelsOfZoom = newValue

            self.scrollView.maximumZoomScale = pow(2.0, max(0.0, CGFloat(levelsOfZoom)))
        }
        get
        {
            return _levelsOfZoom
        }
    }
    var levelsOfDetail: UInt
    {
        set
        {
            _levelsOfDetail = newValue

            if levelsOfDetail == 1 {
                print("Note: Setting levelsOfDetail to 1 causes strange behaviour")
            }
            self.tiledView.numberOfZoomLevels = size_t(levelsOfDetail)
        }
        get
        {
            return _levelsOfDetail
        }
    }
    var zoomScale: CGFloat
    {
        set
        {
            self.setZoomScale(newValue, animated: false)
        }
        get
        {
            return scrollView.zoomScale
        }
    }
    /*private*/
    var muteAnnotationUpdates: Bool
    {
        set
        {

            // FIXME: Jesse C - I don't like overloading this here, but the logic is in one place
            _muteAnnotationUpdates = newValue

            self.userInteractionEnabled = !self.muteAnnotationUpdates
            if !self.muteAnnotationUpdates {
                self.correctScreenPositionOfAnnotations()
            }
        }
        get
        {
            return _muteAnnotationUpdates
        }
    }

    /*private*/
    var annotations: Set<JCAnnotation> = Set()
    /*private*/
    var recycledAnnotationViews: Set<JCAnnotationView> = Set()
    /*private*/
    var visibleAnnotations: Set<JCVisibleAnnotationTuple> = Set()
    /*private*/
    var previousSelectedAnnotationTuple: JCVisibleAnnotationTuple?
    /*private*/
    var currentSelectedAnnotationTuple: JCVisibleAnnotationTuple?

    /*private*/
    var singleTapGestureRecognizer: UITapGestureRecognizer!
    /*private*/
    var doubleTapGestureRecognizer: UITapGestureRecognizer!
    /*private*/
    var twoFingerTapGestureRecognizer: UITapGestureRecognizer!

    // MARK: -

    // MARK: Init method and main methods
    init(frame: CGRect, contentSize: CGSize)
    {
        super.init(frame: frame)

        autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]

        scrollView = UIScrollView(frame: self.bounds)
        scrollView.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.whiteColor()
        scrollView.contentSize = contentSize
        scrollView.bouncesZoom = true
        scrollView.bounces = true
        scrollView.minimumZoomScale = 1.0

        levelsOfZoom = 2

        let canvasFrame = CGRect(origin: CGPointZero, size: scrollView.contentSize)
        canvasView = UIView(frame: canvasFrame)
        canvasView.userInteractionEnabled = false

        let tiledLayerClass = self.dynamicType.tiledLayerClass() as! UIView.Type
        tiledView = tiledLayerClass.init(frame: canvasFrame) as! JCTiledView
        tiledView.delegate = self

        scrollView.addSubview(tiledView)

        addSubview(scrollView)
        addSubview(canvasView)

        singleTapGestureRecognizer = JCAnnotationTapGestureRecognizer(target: self, action: "singleTapReceived:")
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.delegate = self
        tiledView.addGestureRecognizer(singleTapGestureRecognizer)

        doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "doubleTapReceived:")
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        tiledView.addGestureRecognizer(doubleTapGestureRecognizer)

        singleTapGestureRecognizer.requireGestureRecognizerToFail(doubleTapGestureRecognizer)

        twoFingerTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "twoFingerTapReceived:")
        twoFingerTapGestureRecognizer.numberOfTouchesRequired = 2
        twoFingerTapGestureRecognizer.numberOfTapsRequired = 1
        tiledView.addGestureRecognizer(twoFingerTapGestureRecognizer)
    }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

    class func tiledLayerClass() -> AnyClass
    {
        return JCTiledView.self
    }

    // MARK: Position
    /*private*/
    func correctScreenPositionOfAnnotations()
    {

        CATransaction.begin()
        CATransaction.setAnimationDuration(0.0)

        if (scrollView.zoomBouncing || muteAnnotationUpdates) && !scrollView.zooming {
            for t in visibleAnnotations {
                t.view.position = screenPositionForAnnotation(t.annotation)
            }
        }
        else {
            for annotation in annotations {
                let screenPosition = screenPositionForAnnotation(annotation)
                var t = visibleAnnotations.visibleAnnotationTupleForAnnotation(annotation)

                if screenPosition.jc_isWithinBounds(bounds) {
                    if let t = t {
                        if t == currentSelectedAnnotationTuple {
                            canvasView.addSubview(t.view)
                        }
                        t.view.position = screenPosition
                    }
                    else {
                        // t is nil
                        let view = tiledScrollViewDelegate?.tiledScrollView(self, viewForAnnotation: annotation)

                        if let view = view {
                            view.position = screenPosition

                            t = JCVisibleAnnotationTuple(annotation: annotation, view: view)

                            if let t = t {
                                tiledScrollViewDelegate?.tiledScrollView?(self, annotationWillAppear: t.annotation)

                                visibleAnnotations.insert(t)
                                canvasView.addSubview(t.view)

                                CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
                                let animation = CABasicAnimation(keyPath: "opacity")
                                animation.duration = 0.3
                                animation.repeatCount = 1
                                animation.fromValue = 0.0
                                animation.toValue = 1.0
                                t.view.layer.addAnimation(animation, forKey: "animateOpacity")

                                tiledScrollViewDelegate?.tiledScrollView?(self, annotationDidAppear: t.annotation)
                            }

                        }
                        else {
                            // view is nil
                            continue
                        }
                    }
                }
                else {
                    if let t = t {
                        tiledScrollViewDelegate?.tiledScrollView?(self, annotationWillAppear: t.annotation)

                        if t != currentSelectedAnnotationTuple {
                            t.view.removeFromSuperview()
                            recycledAnnotationViews.insert(t.view)
                            visibleAnnotations.remove(t)
                        }
                        else {
                            // FIXME: Anthony D - I don't like let the view in visible annotations array, but the logic is in one place
                            t.view.removeFromSuperview()
                        }

                        tiledScrollViewDelegate?.tiledScrollView?(self, annotationDidDisappear: t.annotation)
                    }
                } // if screenPosition.jc_isWithinBounds(bounds)
            } // for obj in annotations
        }// if (scrollView.zoomBouncing || muteAnnotationUpdates) && !scrollView.zooming

        CATransaction.commit()
    }

    /*private*/
    func screenPositionForAnnotation(annotation: JCAnnotation) -> CGPoint
    {
        var position = CGPointZero
        position.x = (annotation.contentPosition.x * self.zoomScale) - scrollView.contentOffset.x
        position.y = (annotation.contentPosition.y * self.zoomScale) - scrollView.contentOffset.y
        return position
    }

    // MARK: Mute Annotation Updates
    func makeMuteAnnotationUpdatesTrueFor(time: NSTimeInterval)
    {

        self.muteAnnotationUpdates = true

        let popTime = dispatch_time(
        DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC)))
        dispatch_after(popTime, dispatch_get_main_queue(), {
            self.muteAnnotationUpdates = false
        })
    }

    // MARK: JCTiledScrollView
    func setZoomScale(zoomScale: CGFloat, animated: Bool)
    {
        scrollView.setZoomScale(zoomScale, animated: animated)
    }

    func setContentCenter(center: CGPoint, animated: Bool)
    {
        scrollView.jc_setContentCenter(center, animated: animated)
    }

    // MARK: Annotation Recycling

    func dequeueReusableAnnotationViewWithReuseIdentifier(reuseIdentifier: String) -> JCAnnotationView?
    {
        var viewToReturn: JCAnnotationView? = nil

        for v in self.recycledAnnotationViews {
            if v.reuseIdentifier == reuseIdentifier {
                viewToReturn = v
                break
            }
        }

        if viewToReturn != nil {
            self.recycledAnnotationViews.remove(viewToReturn!)

        }

        return viewToReturn
    }

    // MARK: Annotations

    func refreshAnnotations()
    {
        self.correctScreenPositionOfAnnotations()

        for annotation in self.annotations {
            let t = self.visibleAnnotations.visibleAnnotationTupleForAnnotation(annotation)

            t?.view.setNeedsLayout()
            t?.view.setNeedsDisplay()
        }
    }

    func addAnnotation(annotation: JCAnnotation)
    {
        self.annotations.insert(annotation)

        let screenPosition = self.screenPositionForAnnotation(annotation)

        if screenPosition.jc_isWithinBounds(bounds) {

            let view = self.tiledScrollViewDelegate!.tiledScrollView(self, viewForAnnotation: annotation)
            view.position = screenPosition

            let t = JCVisibleAnnotationTuple(annotation: annotation, view: view)
            self.visibleAnnotations.insert(t)

            self.canvasView.addSubview(view)
        }
    }

    func addAnnotations(annotations: NSArray)
    {
        for annotation in annotations {
            self.addAnnotation(annotation as! JCAnnotation)
        }
    }

    func removeAnnotation(annotation: JCAnnotation?)
    {
        if let annotation = annotation {
            if self.annotations.contains(annotation) {

                if let t = self.visibleAnnotations.visibleAnnotationTupleForAnnotation(annotation) {

                    t.view.removeFromSuperview()
                    self.visibleAnnotations.remove(t)
                }

                self.annotations.remove(annotation)
            }
        }
    }

    func removeAnnotations(annotations: NSArray)
    {
        for annotation in annotations {
            self.removeAnnotation(annotation as? JCAnnotation)
        }
    }

    func removeAllAnnotations()
    {
        for annotation in self.annotations {
            self.removeAnnotation(annotation)
        }
    }

}

// MARK: - UIScrollViewDelegate

extension JCTiledScrollView: UIScrollViewDelegate
{

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView?
    {
        return self.tiledView
    }

    func scrollViewDidZoom(scrollView: UIScrollView)
    {
        self.tiledScrollViewDelegate?.tiledScrollViewDidZoom?(self)
    }

    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        self.correctScreenPositionOfAnnotations()

        self.tiledScrollViewDelegate?.tiledScrollViewDidScroll?(self)
    }
}

// MARK: - JCTiledBitmapViewDelegate

extension JCTiledScrollView: JCTiledBitmapViewDelegate
{

    func tiledView(tiledView: JCTiledView, imageForRow row: Int, column: Int, scale: Int) -> UIImage
    {
        return self.dataSource!.tiledScrollView(self, imageForRow: row, column: column, scale: scale)
    }

}

// MARK: - UIGestureRecognizerDelegate

extension JCTiledScrollView: UIGestureRecognizerDelegate
{

    func singleTapReceived(gestureRecognizer: UITapGestureRecognizer)
    {
        if gestureRecognizer.isKindOfClass(JCAnnotationTapGestureRecognizer.self) {

            let annotationGestureRecognizer = gestureRecognizer as! JCAnnotationTapGestureRecognizer

            previousSelectedAnnotationTuple = currentSelectedAnnotationTuple
            currentSelectedAnnotationTuple = annotationGestureRecognizer.tapAnnotation

            if nil == annotationGestureRecognizer.tapAnnotation {

                if let previousSelectedAnnotationTuple = self.previousSelectedAnnotationTuple {
                    self.tiledScrollViewDelegate?.tiledScrollView?(self, didDeselectAnnotationView: previousSelectedAnnotationTuple.view)
                }
                else if self.centerSingleTap {
                    self.setContentCenter(gestureRecognizer.locationInView(self.tiledView), animated: true)
                }

                self.tiledScrollViewDelegate?.tiledScrollView?(self, didReceiveSingleTap: gestureRecognizer)
            }
            else {
                if let previousSelectedAnnotationTuple = self.previousSelectedAnnotationTuple {
                    var oldSelectedAnnotationView = previousSelectedAnnotationTuple.view

                    if oldSelectedAnnotationView == nil {
                        oldSelectedAnnotationView = self.tiledScrollViewDelegate?.tiledScrollView(self, viewForAnnotation: previousSelectedAnnotationTuple.annotation)
                    }
                    self.tiledScrollViewDelegate?.tiledScrollView?(self, didDeselectAnnotationView: oldSelectedAnnotationView)
                }
                if currentSelectedAnnotationTuple != nil {
                    if let tapAnnotation = annotationGestureRecognizer.tapAnnotation {
                        let currentSelectedAnnotationView = tapAnnotation.view
                        self.tiledScrollViewDelegate?.tiledScrollView?(self, didSelectAnnotationView: currentSelectedAnnotationView)
                    }
                }
            }
        }
    }

    func doubleTapReceived(gestureRecognizer: UITapGestureRecognizer)
    {
        if self.zoomsInOnDoubleTap {
            let newZoom = self.scrollView.jc_zoomScaleByZoomingIn(1.0)
            self.makeMuteAnnotationUpdatesTrueFor(kJCTiledScrollViewAnimationTime)

            if self.zoomsToTouchLocation {
                let bounds = scrollView.bounds
                let pointInView = CGPointApplyAffineTransform(
                gestureRecognizer.locationInView(scrollView),
                CGAffineTransformMakeScale(1 / scrollView.zoomScale, 1 / scrollView.zoomScale)
                )
                let newSize = CGSizeApplyAffineTransform(
                bounds.size,
                CGAffineTransformMakeScale(1 / newZoom, 1 / newZoom)
                )

                scrollView.zoomToRect(CGRectMake(pointInView.x - (newSize.width / 2),
                                                 pointInView.y - (newSize.height / 2), newSize.width, newSize.height), animated: true)
            }
            else {
                scrollView.setZoomScale(newZoom, animated: true)
            }
        }
        self.tiledScrollViewDelegate?.tiledScrollView?(self, didReceiveDoubleTap: gestureRecognizer)
    }

    func twoFingerTapReceived(gestureRecognizer: UITapGestureRecognizer)
    {
        if self.zoomsOutOnTwoFingerTap {

            let newZoom = self.scrollView.jc_zoomScaleByZoomingOut(1.0)

            self.makeMuteAnnotationUpdatesTrueFor(kJCTiledScrollViewAnimationTime)

            scrollView.setZoomScale(newZoom, animated: true)
        }

        self.tiledScrollViewDelegate?.tiledScrollView?(self, didReceiveTwoFingerTap: gestureRecognizer)
    }

    /** Catch our own tap gesture if it is on an annotation view to set annotation.
     *Return NO to only recognize single tap on annotation
     */

    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool
    {
        let location = gestureRecognizer.locationInView(self.canvasView)

        (gestureRecognizer as? JCAnnotationTapGestureRecognizer)?.tapAnnotation = nil

        for t in self.visibleAnnotations {
            if CGRectContainsPoint(t.view.frame, location) {
                (gestureRecognizer as? JCAnnotationTapGestureRecognizer)?.tapAnnotation = t
                return true
            }
        }

        // Deal with all tap gesture
        return true
    }
}
