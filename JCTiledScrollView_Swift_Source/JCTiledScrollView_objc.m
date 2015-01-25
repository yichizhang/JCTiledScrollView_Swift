//
//  JCTiledScrollView_objc.m
//  JCTiledScrollView-Swift
//
//  Created by Yichi on 26/01/2015.
//  Copyright (c) 2015 Yichi Zhang. All rights reserved.
//

#import "JCTiledScrollView_objc.h"

@implementation JCTiledScrollView_objc

+ (id)tiledViewFromClass:(Class)class frame:(CGRect)frame{
	return [[class alloc] initWithFrame:frame];
}

@end
