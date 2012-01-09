
/*

 File: AnimationFrame.h
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

#import <Foundation/Foundation.h>

@interface AnimationFrame : NSObject {
    
}

@property (nonatomic) int lastIndex;
@property (nonatomic, retain) CALayer *rootAnimationLayer;
@property (nonatomic, retain) NSMutableArray *animationImages;

- (void)addLayers:(CALayer *)layer, ...NS_REQUIRES_NIL_TERMINATION;

- (void)sendFrameToBack:(AnimationFrame *)aFrame;
- (void)sendFrameToFront:(AnimationFrame *)aFrame;

@end
