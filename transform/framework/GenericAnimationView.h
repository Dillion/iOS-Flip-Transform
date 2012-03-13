
/*
 
 File: GenericAnimationView.h
 Abstract: Generic Animation View is the base view to which all
 animation layers are added. It draws the animation layers based
 on supplied parameters and handles the layers as a stack of
 Animation Frames that can be rearranged in the overall application
 view hierarchy. Animation layers can be drawn with an image (from
 file or dynamically generated such as a screenshot) or using a
 background color.
 
 
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

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AnimationDelegate.h"
#import "AnimationFrame.h"

@interface GenericAnimationView : UIView {

    UIImage *templateImage;
    
    // size of the view determines size of all Animation Frames
    float templateWidth;
    float templateHeight;
    
    // number of logical parts in an Animation Frame
    int imageUnitQuantity; 
    
}

// Stack of Animation Frames
// Image data is grouped into Animation Frames, each frame contains the set of images displayed in between sequences
@property (nonatomic, retain) NSMutableArray *imageStackArray;

// set inset to restrict text frame size
@property (nonatomic) CGPoint textInset;
// set offset from position to align text
@property (nonatomic) CGPoint textOffset;
// font size (different from UILabel font size property)
@property (nonatomic) float fontSize;
// provide a font from plist or use inbuilt fonts
// if the rendering is very slow, change the font
@property (nonatomic, assign) NSString *font;
// font alignment
@property (nonatomic, assign) NSString *fontAlignment;
// truncation mode to set for CATextLayer
@property (nonatomic, assign) NSString *textTruncationMode;

// view has to know the type of animation to be able to prepare (draw, slice) the animation layers
@property (nonatomic) AnimationType animationType;

- (id)initWithAnimationType:(AnimationType)aType
                      frame:(CGRect)aFrame;

// method to override for subclasses
- (BOOL)printText:(NSString *)tickerString 
       usingImage:(UIImage *)aImage
  backgroundColor:(UIColor *)aBackgroundColor
        textColor:(UIColor *)aTextColor;

- (CALayer *)layerWithFrame:(CGRect)aFrame
             contentGravity:(NSString *)aContentGravity
               cornerRadius:(float)aRadius
                doubleSided:(BOOL)aValue;

- (void)rearrangeLayers:(DirectionType)aDirectionType :(int)step;

@end
