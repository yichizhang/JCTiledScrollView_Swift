//
//  Copyright (c) 2015-present Yichi Zhang
//  https://github.com/yichizhang
//  zhang-yi-chi@hotmail.com
//
//  This source code is licensed under MIT license found in the LICENSE file
//  in the root directory of this source tree.
//  Attribution can be found in the ATTRIBUTION file in the root directory 
//  of this source tree.
//

import UIKit

class DemoAnnotationView: JCAnnotationView
{
    var markerColor: UIColor!
    {
        didSet
        {
            sizeToFit()
            setNeedsDisplay()
        }
    }

    override init(frame: CGRect, annotation: JCAnnotation, reuseIdentifier: String)
    {
        super.init(frame: frame, annotation: annotation, reuseIdentifier: reuseIdentifier)

        backgroundColor = UIColor.clear
        markerColor = UIColor.black
    }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize
    {
        return CGSize(width: 64, height: 64)
    }

    override func draw(_ rect: CGRect)
    {
        // Marker
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 32, y: 8))
        bezierPath.addCurve(to: CGPoint(x: 14, y: 25.89), controlPoint1: CGPoint(x: 22.07, y: 8), controlPoint2: CGPoint(x: 14, y: 16.03))
        bezierPath.addCurve(to: CGPoint(x: 31.37, y: 57.55), controlPoint1: CGPoint(x: 14, y: 35.15), controlPoint2: CGPoint(x: 25.05, y: 46))
        bezierPath.addCurve(to: CGPoint(x: 31.99, y: 58), controlPoint1: CGPoint(x: 31.45, y: 57.82), controlPoint2: CGPoint(x: 31.7, y: 58))
        bezierPath.addCurve(to: CGPoint(x: 32.6, y: 57.54), controlPoint1: CGPoint(x: 32.27, y: 58), controlPoint2: CGPoint(x: 32.52, y: 57.81))
        bezierPath.addCurve(to: CGPoint(x: 50, y: 25.89), controlPoint1: CGPoint(x: 39.05, y: 46), controlPoint2: CGPoint(x: 50, y: 35.16))
        bezierPath.addCurve(to: CGPoint(x: 32, y: 8), controlPoint1: CGPoint(x: 50, y: 16.03), controlPoint2: CGPoint(x: 41.92, y: 8))
        bezierPath.close()
        bezierPath.miterLimit = 4;

        markerColor.setFill()
        bezierPath.fill()


        // The dot on the marker
        let dotColor = UIColor.white
        let bezier2Path = UIBezierPath()
        bezier2Path.move(to: CGPoint(x: 32, y: 36))
        bezier2Path.addCurve(to: CGPoint(x: 21, y: 25), controlPoint1: CGPoint(x: 25.94, y: 36), controlPoint2: CGPoint(x: 21, y: 31.06))
        bezier2Path.addCurve(to: CGPoint(x: 32, y: 14), controlPoint1: CGPoint(x: 21, y: 18.93), controlPoint2: CGPoint(x: 25.94, y: 14))
        bezier2Path.addCurve(to: CGPoint(x: 43, y: 25), controlPoint1: CGPoint(x: 38.06, y: 14), controlPoint2: CGPoint(x: 43, y: 18.93))
        bezier2Path.addCurve(to: CGPoint(x: 32, y: 36), controlPoint1: CGPoint(x: 43, y: 31.06), controlPoint2: CGPoint(x: 38.06, y: 36))
        bezier2Path.close()

        dotColor.setFill()
        bezier2Path.fill()
    }

    func update(forAnnotation annotation: DemoAnnotation?)
    {
        self.annotation = annotation

        let isSelectable = annotation?.isSelectable ?? true
        let isSelected = annotation?.isSelected ?? false

        if isSelectable {
            markerColor = isSelected ? UIColor.yellow : UIColor.red
        }
        else {
            markerColor = UIColor.darkGray
        }
    }
}
