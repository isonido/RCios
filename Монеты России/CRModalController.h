//
//  CRModalController.h
//  Монеты России
//
//  Created by Andrey Androsov on 23.07.14.
//  Copyright (c) 2014 Andrey Sonido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRData.h"
#import "CRMasterViewController.h"

@interface CRModalController : UIViewController

@property (strong, nonatomic) NSMutableArray *pcsCoins;
@property NSMutableArray *dataUser;
@property (nonatomic, strong) CRData *detail;
@property (strong, nonatomic) IBOutlet UIPickerView *pcsPickerView;

@property (nonatomic) NSNumber* pcs;
@property (nonatomic) NSNumber* pcs2;

@property (strong, nonatomic) IBOutlet UILabel *dvorLabel;
@property (strong, nonatomic) IBOutlet UIImageView *smallCoins;
@property (strong, nonatomic) IBOutlet UILabel *titleAdd;

@property (strong, nonatomic) IBOutlet UIStepper *stepper1;
@property (nonatomic, copy) NSString *dvor;
@property (nonatomic, copy) NSString *quality;
@property (strong, nonatomic) IBOutlet UIStepper *stepper2;

- (IBAction)stepper1:(id)sender;
- (IBAction)stepper2:(id)sender;
- (IBAction)touchHome:(id)sender;

@end
