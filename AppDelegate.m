#import "AppDelegate.h"
#import "BrowserViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    BrowserViewController *browser = [[BrowserViewController alloc] init];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:browser];
    navigation.navigationBarHidden = YES;
    self.window.rootViewController = navigation;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
