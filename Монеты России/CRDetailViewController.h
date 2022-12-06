//
//  CRDetailViewController.h
//  Монеты России
//
//  Created by Andrey Androsov on 14.01.14.
//  Copyright (c) 2014 Andrey Sonido. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "CRData.h"
#import "CRMasterViewController.h"


@interface CRDetailViewController : UIViewController <UISplitViewControllerDelegate, UITextViewDelegate>

@property NSArray *titleSection;
@property NSNumber *coinNumber;
@property NSMutableArray *isOp;
@property NSMutableArray *isOp2;
@property NSMutableArray *dataUser;
@property NSMutableArray *dataZakaz;
@property (nonatomic, retain) NSMutableArray *news;
@property (nonatomic) NSNumber* pcs;
@property (nonatomic) NSNumber* pcs2;
@property (nonatomic) NSNumber* pcs3;
@property (nonatomic) NSNumber* pcs3_1;
@property (nonatomic, strong) CRData *detail;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *coinView;
@property (weak, nonatomic) IBOutlet UIImageView *selectedSegmentImage;
@property (weak, nonatomic) IBOutlet UIImageView *detailImage1;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, copy) NSString *serial;

@property (weak, nonatomic) IBOutlet UISegmentedControl *triggerView;
@property (strong, nonatomic) IBOutlet UILabel *kolName;
@property (strong, nonatomic) IBOutlet UILabel *kolPcs;
@property (strong, nonatomic) IBOutlet UIButton *addEdit;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addPlus;
@property (strong, nonatomic) IBOutlet UITableView *aboutCell;
@property (strong, nonatomic) IBOutlet UITableView *aboutCell2;
@property (strong, nonatomic) IBOutlet UIImageView *screenIpad;
@property (strong, nonatomic) IBOutlet UIButton *history;
@property (weak, nonatomic) IBOutlet UILabel *priceric;
@property (weak, nonatomic) IBOutlet UIButton *zakaz;
@property (weak, nonatomic) IBOutlet UIView *basketAddAlert;
@property (weak, nonatomic) IBOutlet UITextField *numberCoinAdd;
@property (weak, nonatomic) IBOutlet UITextField *numberCoinAdd2;
@property (weak, nonatomic) IBOutlet UIStepper *addPcs;
@property (weak, nonatomic) IBOutlet UIStepper *addPcs2;
@property (nonatomic) IBOutlet UIBarButtonItem *basketImage;
@property (weak, nonatomic) IBOutlet UILabel *labelMmd;
@property (weak, nonatomic) IBOutlet UILabel *labelSpmd;

@property (strong, nonatomic) CRDetailViewController *detailViewController;

- (IBAction)triggerView:(UISegmentedControl *)sender;
- (IBAction)history:(id)sender;
- (IBAction)addBasket:(id)sender;
- (IBAction)addPcs:(id)sender;
- (IBAction)cancelAdd:(id)sender;
- (IBAction)addAdd:(id)sender;
- (IBAction)addPcs2:(id)sender;

@end
