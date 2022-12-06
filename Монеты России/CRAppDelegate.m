//
//  CRAppDelegate.m
//  Монеты России
//
//  Created by Andrey Androsov on 14.01.14.
//  Copyright (c) 2014 Andrey Sonido. All rights reserved.
//

#import "CRAppDelegate.h"
#import "CRLeftViewController.h"
#import "ATAppUpdater.h"
//#import "ACTReporter.h"
//#import "Adjust.h"
//#import "YandexMobileMetrica.h"

static NSString* Diccoins = @"diccoins";

@implementation CRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        splitViewController.delegate = (id)navigationController.topViewController;
    }
    
    //YMMYandexMetricaConfiguration *configuration = [[YMMYandexMetricaConfiguration alloc] initWithApiKey:@"API_key"];
    //[YMMYandexMetrica activateWithConfiguration:configuration];
    
    /*
    ATAppUpdater *updater = [ATAppUpdater sharedUpdater];
    [updater setAlertTitle:NSLocalizedString(@"Новая версия!", @"Alert Title")];
    [updater setAlertMessage:NSLocalizedString(@"Версия %@ уже доступна в AppStore.", @"Alert Message")];
    [updater setAlertUpdateButtonTitle:@"Обновить"];
    [updater setAlertCancelButtonTitle:@"Отмена"];
    //[updater setDelegate:self]; // Optional
    [updater showUpdateWithConfirmation];
    return YES;
    */
    //[ACTAutomatedUsageTracker enableAutomatedUsageReportingWithConversionID:@"949049157"];
    /*
    [ACTConversionReporter reportWithConversionID:@"949049157" label:@"LraXCPnQs2AQxa7FxAM" value:@"0.00" isRepeatable:NO];
    
    NSString *yourAppToken = @"7gjqwt8vzwfm";
    NSString *environment = ADJEnvironmentProduction;
    //NSString *environment = ADJEnvironmentSandbox;
    ADJConfig *adjustConfig = [ADJConfig configWithAppToken:yourAppToken
                                                environment:environment];
    [Adjust appDidLaunch:adjustConfig];
    
    ADJEvent *event = [ADJEvent eventWithEventToken:@"olqu3e"];
    [Adjust trackEvent:event];
*/
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
/*
+ (void)initialize
{
    if ([self class] == [CRAppDelegate class]) {
        //Инициализация AppMetrica SDK
        [YMMYandexMetrica activateWithApiKey:@"fb067ef6-2db2-4cff-82c2-78eb2e3c17c7"];
    }
}
*/

@end
