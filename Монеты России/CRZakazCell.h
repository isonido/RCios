//
//  CRZakazCell.h
//  Russian Coins
//
//  Created by Andrey Androsov on 27.09.15.
//  Copyright © 2015 Andrey Sonido. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRZakazCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cellImage;
@property (weak, nonatomic) IBOutlet UILabel *cellRating;
@property (weak, nonatomic) IBOutlet UILabel *cellTitle;
@property (weak, nonatomic) IBOutlet UITextField *cellPcs;
@property (weak, nonatomic) IBOutlet UIStepper *stepperPcs;
@property (weak, nonatomic) IBOutlet UILabel *priceRic;
@property (weak, nonatomic) IBOutlet UILabel *cellDvor;

- (IBAction)stepperPcs:(id)sender;


@end
