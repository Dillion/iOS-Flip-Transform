
/*
 
 File: FlipView.h
 Abstract: FlipView is the subclassed implementation of 
 GenericAnimationView that performs slicing of layers and 
 rearrangement specific to half-fold flip animation.
 
 
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

#import "GenericAnimationView.h"

@interface FlipView : GenericAnimationView {
    
}

@property (nonatomic) float sublayerCornerRadius;

// use this method to add a static overlay layer on top of the animation layers
// set the zPosition to a value higher than all the animation layers
- (void)addOverlay;

- (BOOL)printText:(NSString *)tickerString 
       usingImage:(UIImage *)aImage
  backgroundColor:(UIColor *)aBackgroundColor
        textColor:(UIColor *)aTextColor;

// rearrangment is necessary because layers of the current frame that face away from the viewer
// need to mirror content from the next or previous frames, depending on direction
- (void)rearrangeLayers:(DirectionType)aDirectionType :(int)step;

@end
