//
//  CRViewController.h
//  Монеты России
//
//  Created by Andrey Androsov on 11.02.14.
//  Copyright (c) 2014 Andrey Sonido. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRViewController : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *createdOn;
@property (weak, nonatomic) IBOutlet UILabel *id;
@property (weak, nonatomic) IBOutlet UITextView *aboutText;

@property (weak, nonatomic) IBOutlet UILabel *quality;
@property (weak, nonatomic) IBOutlet UILabel *still;
@property (weak, nonatomic) IBOutlet UILabel *weight;
@property (weak, nonatomic) IBOutlet UILabel *weightStill;
@property (weak, nonatomic) IBOutlet UILabel *diameter;
@property (weak, nonatomic) IBOutlet UILabel *thickness;
@property (weak, nonatomic) IBOutlet UILabel *pcs;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *dvor;
@property (weak, nonatomic) IBOutlet UILabel *gurt;

@property (weak, nonatomic) IBOutlet UILabel *diameter2;
@property (strong, nonatomic) IBOutlet UILabel *creator;
@property (strong, nonatomic) IBOutlet UILabel *sculpter;
@property (strong, nonatomic) IBOutlet UIButton *serial;

- (IBAction)serialTouch:(id)sender;

@end
