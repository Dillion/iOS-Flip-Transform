
/*
 
 File: AnimationFrame.m
 Abstract: Animation Frame is a collection of CALayers (with or
 without image contents) required to display 1 animation cycle.
 Each CALayer is added to a root layer before adding to the 
 application view hierarchy, to allow easy manipulation of the
 animation frame view order while maintaining internal view order.
 
 
 Copyright (c) 2011 Dillion Tan
 
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 
 */

#import "AnimationFrame.h"
#import <QuartzCore/QuartzCore.h>

@implementation AnimationFrame

@synthesize lastIndex;
@synthesize rootAnimationLayer;
@synthesize animationImages;

- (id)init 
{    
    if ((self = [super init])) {
        self.animationImages = [NSMutableArray array];
        self.rootAnimationLayer = [CALayer layer];
    }
    
    return self;
}

- (void)dealloc
{
    [animationImages removeAllObjects];
    [animationImages release];
    
    [rootAnimationLayer release];
    
    [super dealloc];
}

- (void)sendFrameToBack:(AnimationFrame *)aFrame 
{
    CALayer *rootLayer = aFrame.rootAnimationLayer.superlayer;
    
    [rootAnimationLayer removeFromSuperlayer];
    
    [rootLayer insertSublayer:rootAnimationLayer below:aFrame.rootAnimationLayer];
}

- (void)sendFrameToFront:(AnimationFrame *)aFrame 
{
    CALayer *rootLayer = rootAnimationLayer.superlayer;
    
    [rootAnimationLayer removeFromSuperlayer];
    
    [rootLayer insertSublayer:rootAnimationLayer above:aFrame.rootAnimationLayer];
}

- (void)addLayers:(CALayer *)layer, ... 
{
    int index = [layer.superlayer.sublayers count];
    
    va_list args;
    va_start(args, layer);
    
    for (CALayer *arg = layer; arg != nil; arg = va_arg(args, CALayer *)) {
        [animationImages addObject:arg];
    }
    
    va_end(args);
    
    lastIndex = index;
}

@end
