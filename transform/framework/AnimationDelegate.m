
/*
 
 File: AnimationDelegate.m
 Abstract: Animation Delegate is the helper to handle callbacks
 from transform operations. The animation 
 delegate should have knowledge of how and what kind of transform
 should be applied to current animation frame, based on the type
 of animation and various user settings.
 
 
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

#import "AnimationDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "GenericAnimationView.h"
#import "AnimationFrame.h"

@implementation AnimationDelegate

@synthesize transformView;
@synthesize controller;
@synthesize nextDuration;
@synthesize sequenceType;
@synthesize animationState;
@synthesize animationLock;
@synthesize shadow;
@synthesize repeatDelay;
@synthesize repeat;
@synthesize sensitivity;
@synthesize gravity;
@synthesize perspectiveDepth;

- (id)initWithSequenceType:(SequenceType)aType
             directionType:(DirectionType)aDirection 
{

    if ((self = [super init])) {
        
        transformView = nil;
        controller = nil;
        
        sequenceType = aType;
        currentDirection = aDirection;
        repeat = NO;
        
        // default values
        nextDuration = 0.6;
        repeatDelay = 0.2;
        sensitivity = 40;
        gravity = 2;
        perspectiveDepth = 500;
        shadow = YES;
        
        if (sequenceType == kSequenceAuto) {
            repeat = YES;
        } else {
            repeat = NO;
        }
        
    }
    return self;
}

- (BOOL)startAnimation:(DirectionType)aDirection 
{
    if (animationState == 0) {
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        
        if (aDirection != kDirectionNone) {
            currentDirection = aDirection;
        }
        
        switch (currentDirection) {
            case kDirectionForward:
                [self setTransformValue:10.0f delegating:YES];
                return YES;
                break;
            case kDirectionBackward:
                [self setTransformValue:-10.0f delegating:YES];
                return YES;
                break;
            default:break;
        }
    }
    
    return NO;
}

- (void)animationDidStop:(CABasicAnimation *)theAnimation finished:(BOOL)flag
{
    if (flag) {
        
        switch (animationState) {
            case 0:
                break;
            case 1: {
                switch (transformView.animationType) {
                    case kAnimationFlipVertical:
                    case kAnimationFlipHorizontal: {
                        [self animationCallback];
                    }
                        break;
                    default:
                        break;
                }
            }
                break;
            default:
                break;
        }
    }
}

- (void)animationCallback 
{
    [self resetTransformValues];
    
    if (repeat && sequenceType == kSequenceAuto) {
        // the recommended way to queue CAAnimations by Apple is to offset the beginTime, 
        // but doing so requires changing the fillmode to kCAFillModeBackwards
        // using perform selector allows maintaining the fillmode value of the original animation
        [self performSelector:@selector(startAnimation:) withObject:nil afterDelay:repeatDelay];
    }
        
}

- (void)endStateWithSpeed:(float)aVelocity
{
    if (value == 0.0f) {
        
        [self resetTransformValues];
        
    } else if (value == 10.0f) {
        
        [self resetTransformValues];
        
    } else {
        
        AnimationFrame* currentFrame = [transformView.imageStackArray lastObject];
        CALayer *targetLayer;
        
        int aX, aY, aZ;
        int rotationModifier;
        
        switch (transformView.animationType) {
            case kAnimationFlipVertical:
                aX = 1;
                aY = 0;
                aZ = 0;
                rotationModifier = -1;
                break;
            case kAnimationFlipHorizontal:
                aX = 0;
                aY = 1;
                aZ = 0;
                rotationModifier = 1;
                break;
            default:break;
        }
        
        float rotationAfterDirection;
        
        if (currentDirection == kDirectionForward) {
            rotationAfterDirection = M_PI * rotationModifier;
            targetLayer = [currentFrame.animationImages lastObject];
        } else if (currentDirection == kDirectionBackward) {
            rotationAfterDirection = -M_PI * rotationModifier;
            targetLayer = [currentFrame.animationImages objectAtIndex:0];
        }
        CALayer *targetShadowLayer;
        
        CATransform3D aTransform = CATransform3DIdentity;
        aTransform.m34 = 1.0 / -perspectiveDepth;
        [targetLayer setValue:[NSValue valueWithCATransform3D:CATransform3DRotate(aTransform,rotationAfterDirection/10.0 * value, aX, aY, aZ)] forKeyPath:@"transform"];
        for (CALayer *layer in targetLayer.sublayers) {
            [layer removeAllAnimations];
        }
        [targetLayer removeAllAnimations];
        
        if (gravity > 0) {
            
            animationState = 1;
            
            if (value+aVelocity <= 5.0f) {
                targetShadowLayer = [targetLayer.sublayers objectAtIndex:1];
                
                [self setTransformProgress:rotationAfterDirection / 10.0 * value
                                          :0.0f
                                          :1.0f/(gravity+aVelocity)
                                          :aX :aY :aZ
                                          :YES
                                          :NO
                                          :kCAFillModeForwards 
                                          :targetLayer];
                if (shadow) {
                    [self setOpacityProgress:oldOpacityValue 
                                            :0.0f
                                            :0.0f
                                            :currentDuration 
                                            :kCAFillModeForwards 
                                            :targetShadowLayer];
                }
                value = 0.0f;
            } else {
                targetShadowLayer = [targetLayer.sublayers objectAtIndex:3];
                
                [self setTransformProgress:rotationAfterDirection / 10.0 * value
                                          :rotationAfterDirection
                                          :1.0f/(gravity+aVelocity)
                                          :aX :aY :aZ
                                          :YES
                                          :NO
                                          :kCAFillModeForwards 
                                          :targetLayer];
                if (shadow) {
                    [self setOpacityProgress:oldOpacityValue 
                                            :0.0f
                                            :0.0f
                                            :currentDuration 
                                            :kCAFillModeForwards 
                                            :targetShadowLayer];
                }
                value = 10.0f;
            }
        }
    }
}

- (void)resetTransformValues
{
    AnimationFrame* currentFrame = [transformView.imageStackArray lastObject];
    
    CALayer *targetLayer;
    CALayer *targetShadowLayer, *targetShadowLayer2;
    
    if (currentDirection == kDirectionForward) {
        targetLayer = [currentFrame.animationImages lastObject];
    } else if (currentDirection == kDirectionBackward) {
        targetLayer = [currentFrame.animationImages objectAtIndex:0];
    }
    
    targetShadowLayer = [targetLayer.sublayers objectAtIndex:1];
    targetShadowLayer2 = [targetLayer.sublayers objectAtIndex:3];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    [targetLayer setValue:[NSValue valueWithCATransform3D:CATransform3DIdentity] forKeyPath:@"transform"];
    targetShadowLayer.opacity = 0.0f;
    targetShadowLayer2.opacity = 0.0f;
    
    for (CALayer *layer in targetLayer.sublayers) {
        [layer removeAllAnimations];
    }
    [targetLayer removeAllAnimations];
    
    targetLayer.zPosition = 0;
    
    CATransform3D aTransform = CATransform3DIdentity;
    targetLayer.sublayerTransform = aTransform;
    
    if (value == 10.0f) {
        [transformView rearrangeLayers:currentDirection :3];
    } else {
        [transformView rearrangeLayers:currentDirection :2];
    }
    
    [CATransaction commit];
    
    if (controller && [controller respondsToSelector:@selector(animationDidFinish:)]) {
        if (currentDirection == kDirectionForward && value == 10.0f) {
            [controller animationDidFinish:1];
        } else if (currentDirection == kDirectionBackward && value == 10.0f) {
            [controller animationDidFinish:-1];
        }
    }
    
    animationState = 0;
    animationLock = NO;
    transitionImageBackup = nil;
    value = 0.0f;
    oldOpacityValue = 0.0f;
}

// set the progress of the animation
- (void)setTransformValue:(float)aValue delegating:(BOOL)bValue
{
    currentDuration = nextDuration;
    
    int frameCount = [transformView.imageStackArray count];
    AnimationFrame* currentFrame = [transformView.imageStackArray lastObject];
    CALayer *targetLayer;
    AnimationFrame* nextFrame = [transformView.imageStackArray objectAtIndex:frameCount-2];
    AnimationFrame* previousFrame = [transformView.imageStackArray objectAtIndex:0];

    int aX, aY, aZ;
    int rotationModifier;
    
    switch (transformView.animationType) {
        case kAnimationFlipVertical:
            aX = 1;
            aY = 0;
            aZ = 0;
            rotationModifier = -1;
            break;
        case kAnimationFlipHorizontal:
            aX = 0;
            aY = 1;
            aZ = 0;
            rotationModifier = 1;
            break;
        default:break;
    }
    
    float rotationAfterDirection;
    
    if (transitionImageBackup == nil) {
        if (aValue - value >= 0.0f) {
            currentDirection = kDirectionForward;
            switch (transformView.animationType) {
                case kAnimationFlipVertical:
                case kAnimationFlipHorizontal: {
                    targetLayer = [currentFrame.animationImages lastObject];
                    targetLayer.zPosition = 100;
                }
                    break;
                default:
                    break;
            }
            animationState++;
        } else if (aValue - value < 0.0f) {
            currentDirection = kDirectionBackward;
            [transformView rearrangeLayers:currentDirection :1];
            switch (transformView.animationType) {
                case kAnimationFlipVertical:
                case kAnimationFlipHorizontal: {
                    targetLayer = [currentFrame.animationImages objectAtIndex:0];
                    targetLayer.zPosition = 100;
                }
                    break;
                default:
                    break;
            }
            animationState++;
        }
    }
    
    if (currentDirection == kDirectionForward) {
        rotationAfterDirection = M_PI * rotationModifier;
        targetLayer = [currentFrame.animationImages lastObject];
    } else if (currentDirection == kDirectionBackward) {
        rotationAfterDirection = -M_PI * rotationModifier;
        targetLayer = [currentFrame.animationImages objectAtIndex:0];
    }
    
    float adjustedValue;
    float opacityValue;
    if (sequenceType == kSequenceControlled) {
        adjustedValue = fabs(aValue * (sensitivity/1000.0));
    } else {
        adjustedValue = fabs(aValue);
    }
    adjustedValue = MAX(0.0, adjustedValue);
    adjustedValue = MIN(10.0, adjustedValue);
    
    if (adjustedValue <= 5.0f) {
        opacityValue = adjustedValue/10.0f;
    } else if (adjustedValue > 5.0f) {
        opacityValue = (10.0f - adjustedValue)/10.0f;
    }
    
    CALayer *targetFrontLayer, *targetBackLayer = nil;
    CALayer *targetShadowLayer, *targetShadowLayer2 = nil;
    
    switch (transformView.animationType) {
        case kAnimationFlipVertical: {
            
            switch (currentDirection) {
                case kDirectionForward: {
                    
                    targetFrontLayer = [targetLayer.sublayers objectAtIndex:2];
                    CALayer *nextLayer = [nextFrame.animationImages objectAtIndex:0];
                    targetBackLayer = [nextLayer.sublayers objectAtIndex:0];
                    
                }
                    break;
                case kDirectionBackward: {
                    
                    targetFrontLayer = [targetLayer.sublayers objectAtIndex:2];
                    CALayer *previousLayer = [previousFrame.animationImages objectAtIndex:1];
                    targetBackLayer = [previousLayer.sublayers objectAtIndex:0];
                    
                }
                    break;
                default:
                    break;
            }
            
        }
            break;
        case kAnimationFlipHorizontal: {
            
            switch (currentDirection) {
                case kDirectionForward: {
                    
                    targetFrontLayer = [targetLayer.sublayers objectAtIndex:2];
                    CALayer *nextLayer = [nextFrame.animationImages objectAtIndex:0];
                    targetBackLayer = [nextLayer.sublayers objectAtIndex:0];
                }
                    break;
                case kDirectionBackward: {
                    
                    targetFrontLayer = [targetLayer.sublayers objectAtIndex:2];
                    CALayer *previousLayer = [previousFrame.animationImages objectAtIndex:1];
                    targetBackLayer = [previousLayer.sublayers objectAtIndex:0];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:break;
    }
    if (adjustedValue == 10.0f && value == 0.0f) {
        targetShadowLayer = [targetLayer.sublayers objectAtIndex:1];
        targetShadowLayer2 = [targetLayer.sublayers objectAtIndex:3];
    }
    else if (adjustedValue <= 5.0f) {
        targetShadowLayer = [targetLayer.sublayers objectAtIndex:1];
    } 
    else {
        targetShadowLayer = [targetLayer.sublayers objectAtIndex:3];
    }
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    CATransform3D aTransform = CATransform3DIdentity;
    aTransform.m34 = 1.0 / -perspectiveDepth;
    [targetLayer setValue:[NSValue valueWithCATransform3D:CATransform3DRotate(aTransform, rotationAfterDirection/10.0 * value, aX, aY, aZ)] forKeyPath:@"transform"];
    targetShadowLayer.opacity = oldOpacityValue;
    if (targetShadowLayer2) targetShadowLayer2.opacity = oldOpacityValue;
    for (CALayer *layer in targetLayer.sublayers) {
        [layer removeAllAnimations];
    }
    [targetLayer removeAllAnimations];
    
    [CATransaction commit];
    
    if (adjustedValue != value) {
        
        CATransform3D aTransform = CATransform3DIdentity;
        aTransform.m34 = 1.0 / -perspectiveDepth;
        targetLayer.sublayerTransform = aTransform;
        
        if (transitionImageBackup == nil) { //transition has begun, copy the layer content for the reverse layer
            
            CGImageRef tempImageRef = (CGImageRef)targetBackLayer.contents;
            
            //NSLog(@"%s:%d imageref=%@", __func__, __LINE__, tempImageRef);
            
            transitionImageBackup = (CGImageRef)targetFrontLayer.contents;
            targetFrontLayer.contents = (id)tempImageRef;
        } 
        
        [self setTransformProgress:(rotationAfterDirection/10.0 * value)
                                  :(rotationAfterDirection/10.0 * adjustedValue)
                                  :currentDuration
                                  :aX :aY :aZ
                                  :bValue
                                  :NO
                                  :kCAFillModeForwards 
                                  :targetLayer];
        
        if (shadow) {
            if (oldOpacityValue == 0.0f && oldOpacityValue == opacityValue) {
                
                [self setOpacityProgress:0.0f 
                                        :0.5f
                                        :0.0f
                                        :currentDuration/2 
                                        :kCAFillModeForwards 
                                        :targetShadowLayer];
                [self setOpacityProgress:0.5f 
                                        :0.0f
                                        :currentDuration/2
                                        :currentDuration/2 
                                        :kCAFillModeBackwards 
                                        :targetShadowLayer2];
            } else {
                [self setOpacityProgress:oldOpacityValue 
                                        :opacityValue
                                        :0.0f
                                        :currentDuration 
                                        :kCAFillModeForwards 
                                        :targetShadowLayer];
            }
        }
        
        value = adjustedValue;
        
        oldOpacityValue = opacityValue;
    }

}

- (void)setTransformProgress:(float)startTransformValue
                            :(float)endTransformValue
                            :(float)duration
                            :(int)aX 
                            :(int)aY 
                            :(int)aZ
                            :(BOOL)setDelegate
                            :(BOOL)removedOnCompletion
                            :(NSString *)fillMode
                            :(CALayer *)targetLayer
{
    //NSLog(@"transform value %f, %f", startTransformValue, endTransformValue);
    
    CATransform3D aTransform = CATransform3DIdentity;
    aTransform.m34 = 1.0 / -perspectiveDepth;
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform"];
    anim.duration = duration;
    anim.fromValue= [NSValue valueWithCATransform3D:CATransform3DRotate(aTransform, startTransformValue, aX, aY, aZ)];
    anim.toValue=[NSValue valueWithCATransform3D:CATransform3DRotate(aTransform, endTransformValue, aX, aY, aZ)];
    if (setDelegate) {
        anim.delegate = self;
    }
    anim.removedOnCompletion = removedOnCompletion;
    [anim setFillMode:fillMode];
    
    [targetLayer addAnimation:anim forKey:@"transformAnimation"];
}

- (void)setOpacityProgress:(float)startOpacityValue
                          :(float)endOpacityValue
                          :(float)beginTime
                          :(float)duration
                          :(NSString *)fillMode
                          :(CALayer *)targetLayer
{
    //NSLog(@"opacity value %f, %f, %@", startOpacityValue, endOpacityValue, targetLayer);
    
    CFTimeInterval localMediaTime = [targetLayer convertTime:CACurrentMediaTime() fromLayer:nil];
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anim.duration = duration;
    anim.fromValue= [NSNumber numberWithFloat:startOpacityValue];
    anim.toValue= [NSNumber numberWithFloat:endOpacityValue];
    anim.beginTime = localMediaTime+beginTime;
    anim.removedOnCompletion = NO;
    [anim setFillMode:fillMode];
    
    [targetLayer addAnimation:anim forKey:@"opacityAnimation"];
}

@end
