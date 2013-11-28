//
//  MBCPTAppDelegate.m
//  MBCocoaPodsTemplate
//
//  Created by Justin R. Miller on 11/1/13.
//  Copyright (c) 2013 MapBox. All rights reserved.
//

#import "MBCPTAppDelegate.h"

#import "MBCPTViewController.h"

@implementation MBCPTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [MBCPTViewController new];
    [self.window makeKeyAndVisible];

    return YES;
}
							
@end
