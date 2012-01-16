
#import <UIKit/UIKit.h>

@class AnimationViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) AnimationViewController *animationViewController;

- (void)presentAnimationController:(UIButton *)sender;

@end
