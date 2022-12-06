//
//  CRAppDelegate.h
//  Монеты России
//
//  Created by Andrey Androsov on 14.01.14.
//  Copyright (c) 2014 Andrey Sonido. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface CRAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property NSMutableArray *dataUser;
@property NSArray *dataTransferTotal;
@property NSArray *dataUserTransfer;
@property NSArray *pcs1Transfer;
@property NSArray *pcs2Transfer;
@property (nonatomic) NSNumber* pcs;
@property (nonatomic) NSNumber* pcs2;

@end
