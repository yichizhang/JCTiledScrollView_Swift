//
//  DemoAnnotation.swift
//  Demo-Swift
//
//  Created by Yichi on 13/12/2014.
//  Copyright (c) 2014 Yichi Zhang. All rights reserved.
//

import UIKit

class DemoAnnotation: JCAnnotation
{
    var isSelectable = false
    var isSelected = false

    init(isSelectable: Bool)
    {
        super.init()

        self.isSelectable = isSelectable
    }
}
