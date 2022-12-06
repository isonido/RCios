//
//  CRInfo.h
//  Russian Coins
//
//  Created by Andrey Androsov on 14.04.15.
//  Copyright (c) 2015 Andrey Sonido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRData.h"

@interface CRInfo : UIViewController

@property (nonatomic, strong) CRData *detail;
@property (strong, nonatomic) IBOutlet UITextView *textInfo;

@end
