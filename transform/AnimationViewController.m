
/*
 
 File: RootViewController.m
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

#import "AnimationViewController.h"
#import "FlipView.h"
#import "AnimationDelegate.h"

@implementation AnimationViewController

@synthesize flipView, flipView2;
@synthesize repeatButton, reverseButton, shadowButton;
@synthesize panRecognizer;
@synthesize panRegion;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        step = 0;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

- (void)dealloc
{
    
    [flipView release];
    [flipView2 release];
    [repeatButton release];
    [reverseButton release];
    [shadowButton release];
    [panRecognizer release];
    [panRegion release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onBackButtonPressed:)];
        
    // first flip view is a vertical flip on auto, like a news ticker
    animationDelegate = [[AnimationDelegate alloc] initWithSequenceType:kSequenceAuto
                                                          directionType:kDirectionForward];
    animationDelegate.controller = self;
    animationDelegate.perspectiveDepth = 200;
    
    self.flipView = [[FlipView alloc] initWithAnimationType:kAnimationFlipVertical
                                                      frame:CGRectMake(60, 95, 200, 50)];
    animationDelegate.transformView = flipView;
    
    [self.view addSubview:flipView];
    
    flipView.fontSize = 36;
//    for (UIFont *font in [UIFont familyNames]) {
//        NSLog(@"font %@", font);
//    }
    flipView.font = @"Helvetica Neue Bold";
    flipView.fontAlignment = @"center";
    flipView.textOffset = CGPointMake(0.0, 2.0);
    flipView.textTruncationMode = kCATruncationEnd;
    
    flipView.sublayerCornerRadius = 6.0f;
    
    [flipView printText:@"LOOP" usingImage:nil backgroundColor:[UIColor colorWithRed:0.9 green:0 blue:0 alpha:1] textColor:[UIColor whiteColor]];
    [flipView printText:@"A" usingImage:nil backgroundColor:[UIColor colorWithRed:0.75 green:0 blue:0 alpha:1] textColor:[UIColor whiteColor]];
    [flipView printText:@"IN" usingImage:nil backgroundColor:[UIColor colorWithRed:0.6 green:0 blue:0 alpha:1] textColor:[UIColor whiteColor]];
    [flipView printText:@"DATA" usingImage:nil backgroundColor:[UIColor colorWithRed:0.45 green:0 blue:0 alpha:1] textColor:[UIColor whiteColor]];
    [flipView printText:@"YOUR" usingImage:nil backgroundColor:[UIColor colorWithRed:0.3 green:0 blue:0 alpha:1] textColor:[UIColor whiteColor]];
    [flipView printText:@"THROUGH" usingImage:nil backgroundColor:[UIColor colorWithRed:0.15 green:0 blue:0 alpha:1] textColor:[UIColor whiteColor]];
    [flipView printText:@"FLIP" usingImage:nil backgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1] textColor:[UIColor whiteColor]];
    
    self.repeatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    repeatButton.frame = CGRectMake(60, 160, 90, 40);
    repeatButton.selected = YES;
    [repeatButton setBackgroundImage:[UIImage imageNamed:@"repeat_normal"] forState:UIControlStateNormal];
    [repeatButton setBackgroundImage:[UIImage imageNamed:@"repeat_selected"] forState:UIControlStateHighlighted];
    [repeatButton setBackgroundImage:[UIImage imageNamed:@"repeat_selected"] forState:UIControlStateSelected];
    [repeatButton addTarget:self action:@selector(toggleRepeat:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:repeatButton];
    
    self.reverseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    reverseButton.frame = CGRectMake(170, 160, 90, 40);
    [reverseButton setBackgroundImage:[UIImage imageNamed:@"reverse_normal"] forState:UIControlStateNormal];
    [reverseButton setBackgroundImage:[UIImage imageNamed:@"reverse_selected"] forState:UIControlStateHighlighted];
    [reverseButton setBackgroundImage:[UIImage imageNamed:@"reverse_selected"] forState:UIControlStateSelected];
    [reverseButton addTarget:self action:@selector(toggleReverse:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reverseButton];
    
    self.shadowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shadowButton.frame = CGRectMake(170, 40, 90, 40);
    shadowButton.selected = YES;
    [shadowButton setBackgroundImage:[UIImage imageNamed:@"shadow_normal"] forState:UIControlStateNormal];
    [shadowButton setBackgroundImage:[UIImage imageNamed:@"shadow_selected"] forState:UIControlStateHighlighted];
    [shadowButton setBackgroundImage:[UIImage imageNamed:@"shadow_selected"] forState:UIControlStateSelected];
    [shadowButton addTarget:self action:@selector(toggleShadow:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shadowButton];
    
    // screenshot the first flip view
    // second flip view is a horizontal flip on controlled, like a book
    UIGraphicsBeginImageContext(CGSizeMake(260, 150));
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    CGImageRef imageRef = CGImageCreateWithImageInRect([screenshot CGImage], CGRectMake(60, 40, 200, 110));
    
    UIGraphicsEndImageContext();
    
    UIImage *screenshotAfterCrop = [UIImage imageWithCGImage:imageRef];
    CFRelease(imageRef);
    
    animationDelegate2 = [[AnimationDelegate alloc] initWithSequenceType:kSequenceControlled
                                                           directionType:kDirectionForward];
    animationDelegate2.controller = self;
    animationDelegate2.perspectiveDepth = 2000;
    
    self.flipView2 = [[FlipView alloc] initWithAnimationType:kAnimationFlipHorizontal
                                                       frame:CGRectMake(60, 240, 200, 110)];
    animationDelegate2.transformView = flipView2;
    
    [self.view addSubview:flipView2];
    
    flipView2.textInset = CGPointMake(6.0, 0.0);
    
    flipView2.font = @"AppleGothic";
    flipView2.textTruncationMode = kCATruncationEnd;
    
    flipView2.fontSize = 18;
    flipView2.fontAlignment = @"left";
    flipView2.textOffset = CGPointMake(6.0, 16.0);
    [flipView2 printText:@"HORIZONTAL\nOR\nVERTICAL FLIPS" usingImage:nil backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor]];
    
    [flipView2 printText:@"BIDIRECTIONAL\nCUSTOMIZABLE\nAUTO, TRIGGERED,\nCONTROLLED" usingImage:nil backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor]];
    
    [flipView2 printText:@"ADJUSTABLE\nSENSITIVITY\nGRAVITY\nSHADOW" usingImage:nil backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor]];
    
    flipView2.fontAlignment = @"center";
    flipView2.textOffset = CGPointMake(6.0, 28.0);
    [flipView2 printText:@"SCREENSHOT" usingImage:screenshotAfterCrop backgroundColor:nil textColor:[UIColor redColor]];
    
    flipView2.fontSize = 24;
    flipView2.fontAlignment = @"left";
    flipView2.textOffset = CGPointMake(6.0, 16.0);
    [flipView2 printText:@"2.5D\nANIMATIONS" usingImage:nil backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor]];
    
    self.panRegion = [[UIView alloc] initWithFrame:CGRectMake(60, 240, 200, 110)];
    [self.view addSubview:panRegion];
    
    self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
    panRecognizer.delegate = self;
    panRecognizer.maximumNumberOfTouches = 1;
    panRecognizer.minimumNumberOfTouches = 1;
    [self.view addGestureRecognizer:panRecognizer];
}

- (void)onBackButtonPressed:(UIBarButtonItem *)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (animationDelegate.repeat) {
        [animationDelegate startAnimation:kDirectionNone];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [animationDelegate resetTransformValues];
    [NSObject cancelPreviousPerformRequestsWithTarget:animationDelegate];
}

- (void)toggleRepeat:(UIButton *)sender
{
    if (!animationDelegate.repeat) {
        if ([animationDelegate startAnimation:kDirectionNone]) {
            animationDelegate.repeat = YES;
            sender.selected = YES;
        }
    } else {
        sender.selected = NO;
        animationDelegate.repeat = NO;
    }
}

- (void)toggleReverse:(UIButton *)sender
{
    if (!sender.selected) {
        if ([animationDelegate startAnimation:kDirectionBackward]) {
            sender.selected = YES;
        }
    } else {
        if ([animationDelegate startAnimation:kDirectionForward]) {
            sender.selected = NO;
        }
    }
}

- (void)toggleShadow:(UIButton *)sender
{
    if (!animationDelegate.shadow) {
        animationDelegate.shadow = YES;
        sender.selected = YES;
    } else {
        animationDelegate.shadow = NO;
        sender.selected = NO;
    }
}

- (void)panned:(UIPanGestureRecognizer *)recognizer
{
    switch (recognizer.state) {
        case UIGestureRecognizerStatePossible:
            break;
//        case UIGestureRecognizerStateRecognized: // for discrete recognizers
//            break;
        case UIGestureRecognizerStateFailed: // cannot recognize for multi touch sequence
            break;
        case UIGestureRecognizerStateBegan: {
            // allow controlled flip only when touch begins within the pan region
            if (CGRectContainsPoint(panRegion.frame, [recognizer locationInView:self.view])) {
                if (animationDelegate2.animationState == 0) {
                    [NSObject cancelPreviousPerformRequestsWithTarget:self];
                    animationDelegate2.sequenceType = kSequenceControlled;
                    animationDelegate2.animationLock = YES;
                }
            }
        }
            break;
        case UIGestureRecognizerStateChanged: {
            if (animationDelegate2.animationLock) {
                switch (flipView2.animationType) {
                    case kAnimationFlipVertical: {
                        float value = [recognizer translationInView:self.view].y;
                        [animationDelegate2 setTransformValue:value delegating:NO];
                    }
                        break;
                    case kAnimationFlipHorizontal: {
                        float value = [recognizer translationInView:self.view].x;
                        [animationDelegate2 setTransformValue:value delegating:NO];
                    }
                        break;
                    default:break;
                }
            }
        }
            break;
        case UIGestureRecognizerStateCancelled: // cancellation touch
            break;
        case UIGestureRecognizerStateEnded: {
            if (animationDelegate2.animationLock) {
                // provide inertia to panning gesture
                float value = sqrtf(fabsf([recognizer velocityInView:self.view].x))/10.0f;
                [animationDelegate2 endStateWithSpeed:value];
            }
        }
            break;
        default:
            break;
    }
}

// use this to trigger events after specific interactions
- (void)animationDidFinish:(int)direction 
{
    switch (step) {
        case 0:
            break;
        case 1:
            break;
        default:break;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
