//
//  CRLeftViewController.h
//  Монеты России
//
//  Created by Andrey Androsov on 17.02.14.
//  Copyright (c) 2014 Andrey Sonido. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CRMasterViewController;

@interface CRLeftViewController : UITableViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) CRMasterViewController *masterViewController;
@property (retain, nonatomic) IBOutlet UISegmentedControl *katSegmentControl;
@property (weak, nonatomic) IBOutlet UIPickerView *nominalPickerView;
@property (strong, nonatomic) IBOutlet UIPickerView *serialPickerView;
@property (strong, nonatomic) NSArray *dataNominal;
@property (strong, nonatomic) NSArray *dataYear;
@property (strong, nonatomic) NSArray *dataSerial;
@property (nonatomic) NSInteger rowSerial;
@property (retain, nonatomic) IBOutlet UISegmentedControl *dvorSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *stillSegmentControl;

@property (strong, nonatomic) IBOutlet UIButton *cancel;
@property (weak, nonatomic) IBOutlet UIView *viewCancel;
@property (weak, nonatomic) IBOutlet UITextField *boarderView;

- (IBAction)katSegmentControl:(UISegmentedControl *)sender;
- (IBAction)dvorSegmentControl:(UISegmentedControl *)sender;
- (IBAction)stillSegmentControl:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)online:(id)sender;

@end
