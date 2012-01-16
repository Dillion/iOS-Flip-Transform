
/*
 
 File: RootViewController.h
 Abstract: An example of 2 flip views that respond to user input.
 
 
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

@class FlipView;
@class AnimationDelegate;

@interface AnimationViewController : UIViewController <UIGestureRecognizerDelegate> {
    
    // use this to choreograph a sequence of animations that you want the user to step through
    int step;
    
    //the controller needs a reference to the delegate for control of the animation sequence
    AnimationDelegate *animationDelegate;
    AnimationDelegate *animationDelegate2;
    
    BOOL runWhenRestart;
    
}

@property (nonatomic, retain) FlipView *flipView;
@property (nonatomic, retain) FlipView *flipView2;

@property (nonatomic, retain) UIButton *repeatButton;
@property (nonatomic, retain) UIButton *reverseButton;
@property (nonatomic, retain) UIButton *shadowButton;

@property (nonatomic, retain) UIView *panRegion;
@property (nonatomic, retain) UIPanGestureRecognizer *panRecognizer;

- (void)onBackButtonPressed:(UIBarButtonItem *)sender;

- (void)panned:(UIPanGestureRecognizer *)recognizer;

// animation delegate will notify the controller when the animation frame has reached a position of rest
- (void)animationDidFinish:(int)direction;

- (void)toggleRepeat:(UIButton *)sender;
- (void)toggleReverse:(UIButton *)sender;
- (void)toggleShadow:(UIButton *)sender;

@end
