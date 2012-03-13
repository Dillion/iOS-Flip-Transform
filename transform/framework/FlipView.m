
/*
 
 File: FlipView.m
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


#import "FlipView.h"

@implementation FlipView

@synthesize sublayerCornerRadius;

- (id)initWithAnimationType:(AnimationType)aType
                      frame:(CGRect)aFrame 
{
    
    if ((self = [super initWithAnimationType:aType
                                       frame:aFrame])) {
        
        sublayerCornerRadius = 0.0f;
        
        switch (aType) {
            case kAnimationFlipVertical:
            case kAnimationFlipHorizontal:
                imageUnitQuantity = 2;
                break;
                
            default:
                break;
        }
        
    }
    return self;
    
}

- (void)addOverlay 
{
    // for custom implementation
}

- (BOOL)printText:(NSString *)tickerString 
       usingImage:(UIImage *)aImage
  backgroundColor:(UIColor *)aBackgroundColor
        textColor:(UIColor *)aTextColor 
{
    CGFloat scale = [[UIScreen mainScreen] scale];
    
    if ([super printText:tickerString usingImage:aImage backgroundColor:aBackgroundColor textColor:aTextColor]) {
        switch (self.animationType) {
                
                /* For a half-fold (both kAnimationFlipVertical and kAnimationFlipHorizontal),
                 there are 10 layers per animation frame (2 transform, 4 content, 4 shadow).
                 The transform layers encapsulate the content and shadow so that we don't have
                 to apply separate transforms for the front facing and back facing layers */
            case kAnimationFlipVertical: {
                
                CALayer *flipLayer = [CATransformLayer layer];
                flipLayer.frame = CGRectMake(0, 
                                             templateHeight/4, 
                                             templateWidth, 
                                             templateHeight/2);
                flipLayer.anchorPoint = CGPointMake(0.5, 1.0);
                
                CGRect layerRect = CGRectMake(0, 
                                              0, 
                                              templateWidth, 
                                              templateHeight/2);
                
                CALayer *backLayer = [self layerWithFrame:layerRect contentGravity:kCAGravityTop cornerRadius:sublayerCornerRadius doubleSided:NO];
                [flipLayer addSublayer:backLayer];
                
                CALayer *shadowLayer = [self layerWithFrame:layerRect contentGravity:nil cornerRadius:sublayerCornerRadius doubleSided:YES];
                shadowLayer.backgroundColor = [UIColor blackColor].CGColor;
                shadowLayer.opacity = 0.0f;
                [flipLayer addSublayer:shadowLayer];
                
                CALayer *frontLayer = [self layerWithFrame:layerRect contentGravity:kCAGravityBottom cornerRadius:sublayerCornerRadius doubleSided:NO];
                frontLayer.transform = CATransform3DMakeRotation(M_PI, 1.0, 0, 0);
                [flipLayer addSublayer:frontLayer];
                
                CALayer *shadowLayer2 = [self layerWithFrame:layerRect contentGravity:nil cornerRadius:sublayerCornerRadius doubleSided:YES];
                shadowLayer2.backgroundColor = [UIColor blackColor].CGColor;
                shadowLayer2.opacity = 0.0f;
                shadowLayer2.transform = CATransform3DMakeRotation(M_PI, 1.0, 0, 0);
                [flipLayer addSublayer:shadowLayer2];
                
                CALayer *flipLayer2 = [CATransformLayer layer];
                flipLayer2.frame = CGRectMake(0, 
                                              templateHeight/4, 
                                              templateWidth, 
                                              templateHeight/2);
                flipLayer2.anchorPoint = CGPointMake(0.5, 0.0);
                
                CALayer *backLayer2 = [self layerWithFrame:layerRect contentGravity:kCAGravityTop cornerRadius:sublayerCornerRadius doubleSided:NO];
                [flipLayer2 addSublayer:backLayer2];
                
                CALayer *shadowLayer3 = [self layerWithFrame:layerRect contentGravity:nil cornerRadius:sublayerCornerRadius doubleSided:YES];
                shadowLayer3.backgroundColor = [UIColor blackColor].CGColor;
                shadowLayer3.opacity = 0.0f;
                [flipLayer2 addSublayer:shadowLayer3];
                
                CALayer *frontLayer2 = [self layerWithFrame:layerRect contentGravity:kCAGravityBottom cornerRadius:sublayerCornerRadius doubleSided:NO];
                frontLayer2.transform = CATransform3DMakeRotation(M_PI, 1.0, 0, 0);
                [flipLayer2 addSublayer:frontLayer2];
                
                CALayer *shadowLayer4 = [self layerWithFrame:layerRect contentGravity:nil cornerRadius:sublayerCornerRadius doubleSided:YES];
                shadowLayer4.backgroundColor = [UIColor blackColor].CGColor;
                shadowLayer4.opacity = 0.0f;
                shadowLayer4.transform = CATransform3DMakeRotation(M_PI, 1.0, 0, 0);
                [flipLayer2 addSublayer:shadowLayer4];
                
                CGImageRef imageRef = CGImageCreateWithImageInRect([templateImage CGImage], CGRectMake(0, 0, templateWidth*scale, templateHeight*scale/2));
                
                CGImageRef imageRef2 = CGImageCreateWithImageInRect([templateImage CGImage], CGRectMake(0, templateHeight*scale/2, templateWidth*scale, templateHeight*scale/2));
                
                [backLayer setContents:(id)imageRef];
                [backLayer2 setContents:(id)imageRef2];
                
                AnimationFrame *newFrame = [[AnimationFrame alloc] init];
                [self.layer addSublayer:newFrame.rootAnimationLayer];
                [newFrame.rootAnimationLayer addSublayer:flipLayer];
                [newFrame.rootAnimationLayer addSublayer:flipLayer2];
                [newFrame addLayers:flipLayer2, flipLayer, nil];
                
                [self.imageStackArray addObject:newFrame];
                
                return YES;
            }
                break;
            case kAnimationFlipHorizontal: {
                
                CALayer *flipLayer = [CATransformLayer layer];
                flipLayer.frame = CGRectMake(templateWidth/4, 
                                             0, 
                                             templateWidth/2, 
                                             templateHeight);
                flipLayer.anchorPoint = CGPointMake(1.0, 0.5);
                
                CGRect layerRect = CGRectMake(0, 
                                              0, 
                                              templateWidth/2, 
                                              templateHeight);
                
                CALayer *backLayer = [self layerWithFrame:layerRect contentGravity:kCAGravityLeft cornerRadius:sublayerCornerRadius doubleSided:NO];
                [flipLayer addSublayer:backLayer];
                
                CALayer *shadowLayer = [self layerWithFrame:layerRect contentGravity:nil cornerRadius:sublayerCornerRadius doubleSided:YES];
                shadowLayer.backgroundColor = [UIColor blackColor].CGColor;
                shadowLayer.opacity = 0.0f;
                [flipLayer addSublayer:shadowLayer];
                
                CALayer *frontLayer = [self layerWithFrame:layerRect contentGravity:kCAGravityRight cornerRadius:sublayerCornerRadius doubleSided:NO];
                frontLayer.transform = CATransform3DMakeRotation(M_PI, 0, 1.0, 0);
                [flipLayer addSublayer:frontLayer];
                
                CALayer *shadowLayer2 = [self layerWithFrame:layerRect contentGravity:nil cornerRadius:sublayerCornerRadius doubleSided:YES];
                shadowLayer2.backgroundColor = [UIColor blackColor].CGColor;
                shadowLayer2.opacity = 0.0f;
                shadowLayer2.transform = CATransform3DMakeRotation(M_PI, 0, 1.0, 0);
                [flipLayer addSublayer:shadowLayer2];
                
                CALayer *flipLayer2 = [CATransformLayer layer];
                flipLayer2.frame = CGRectMake(templateWidth/4, 
                                              0, 
                                              templateWidth/2, 
                                              templateHeight);
                flipLayer2.anchorPoint = CGPointMake(0.0, 0.5);
                
                CALayer *backLayer2 = [self layerWithFrame:layerRect contentGravity:kCAGravityLeft cornerRadius:sublayerCornerRadius doubleSided:NO];
                [flipLayer2 addSublayer:backLayer2];
                
                CALayer *shadowLayer3 = [self layerWithFrame:layerRect contentGravity:nil cornerRadius:sublayerCornerRadius doubleSided:YES];
                shadowLayer3.backgroundColor = [UIColor blackColor].CGColor;
                shadowLayer3.opacity = 0.0f;
                [flipLayer2 addSublayer:shadowLayer3];
                
                CALayer *frontLayer2 = [self layerWithFrame:layerRect contentGravity:kCAGravityRight cornerRadius:sublayerCornerRadius doubleSided:NO];
                frontLayer2.transform = CATransform3DMakeRotation(M_PI, 0, 1.0, 0);
                [flipLayer2 addSublayer:frontLayer2];
                
                CALayer *shadowLayer4 = [self layerWithFrame:layerRect contentGravity:nil cornerRadius:sublayerCornerRadius doubleSided:YES];
                shadowLayer4.backgroundColor = [UIColor blackColor].CGColor;
                shadowLayer4.opacity = 0.0f;
                shadowLayer4.transform = CATransform3DMakeRotation(M_PI, 0, 1.0, 0);
                [flipLayer2 addSublayer:shadowLayer4];
                
                CGImageRef imageRef = CGImageCreateWithImageInRect([templateImage CGImage], CGRectMake(templateWidth*scale/2, 0, templateWidth*scale/2, templateHeight*scale));
                
                CGImageRef imageRef2 = CGImageCreateWithImageInRect([templateImage CGImage], CGRectMake(0, 0, templateWidth*scale/2, templateHeight*scale));
                
                [backLayer setContents:(id)imageRef2];
                [backLayer2 setContents:(id)imageRef];
                
                AnimationFrame *newFrame = [[AnimationFrame alloc] init];
                [self.layer addSublayer:newFrame.rootAnimationLayer];
                [newFrame.rootAnimationLayer addSublayer:flipLayer];
                [newFrame.rootAnimationLayer addSublayer:flipLayer2];
                [newFrame addLayers:flipLayer2, flipLayer, nil];
                
                [self.imageStackArray addObject:newFrame];
                
                return YES;
            }
                break;
            default:
                break;
        }
    }
    
    return NO;
}

- (void)rearrangeLayers:(DirectionType)aDirectionType :(int)step 
{
    
    switch (imageUnitQuantity) {
        case 0:
            break;
        case 1:
            break;
        case 2: {
            if ([self.imageStackArray count] > 1) {
                AnimationFrame *currentFrame = [self.imageStackArray lastObject];
                
                AnimationFrame *previousFrame = [self.imageStackArray objectAtIndex:0];
                
                AnimationFrame *previousPreviousFrame = [self.imageStackArray objectAtIndex:1];
                
                AnimationFrame *nextFrame = [self.imageStackArray objectAtIndex:[self.imageStackArray count]-2];
                
                if (aDirectionType == kDirectionForward) {
                    
                    if (step == 3) {
                        [currentFrame.rootAnimationLayer removeFromSuperlayer];
                        
                        [self.layer insertSublayer:currentFrame.rootAnimationLayer below:previousFrame.rootAnimationLayer];
                        
                        [self.imageStackArray removeLastObject];
                        
                        [self.imageStackArray insertObject:currentFrame atIndex:0];
                    }
                    
                } else if (aDirectionType == kDirectionBackward) {
                    
                    if (step == 1) {
                        
                        if ([self.imageStackArray count] > 2) {
                            [previousFrame.rootAnimationLayer removeFromSuperlayer];
                            
                            [self.layer insertSublayer:previousFrame.rootAnimationLayer above:nextFrame.rootAnimationLayer];
                        }
                        
                    } else if (step == 2) {
                        
                        if ([self.imageStackArray count] > 2) {
                            [previousFrame.rootAnimationLayer removeFromSuperlayer];
                            
                            [self.layer insertSublayer:previousFrame.rootAnimationLayer below:previousPreviousFrame.rootAnimationLayer];
                        }
                        
                    } else if (step == 3) {
                        [previousFrame.rootAnimationLayer removeFromSuperlayer];
                        
                        [self.layer insertSublayer:previousFrame.rootAnimationLayer above:currentFrame.rootAnimationLayer];
                        
                        [self.imageStackArray removeObjectAtIndex:0];
                        
                        [self.imageStackArray addObject:previousFrame];
                    }
                }
            }
        }
            break;
        case 3:
            break;
        case 4:
            break;
        case 5:
            break;
        default:break;
    }
}

@end
