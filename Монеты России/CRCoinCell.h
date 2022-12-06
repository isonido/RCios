//
//  CRCoinCell.h
//  Монеты России
//
//  Created by Andrey Androsov on 14.01.14.
//  Copyright (c) 2014 Andrey Sonido. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface CRCoinCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cellCoinView;
@property (weak, nonatomic) IBOutlet UILabel *cellTextRating;
@property (weak, nonatomic) IBOutlet UILabel *cellTextTitle;
@property (weak, nonatomic) IBOutlet UILabel *cellId;
@property (strong, nonatomic) IBOutlet UILabel *pcs1;
@property (strong, nonatomic) IBOutlet UILabel *pcs2;
@property (weak, nonatomic) IBOutlet UILabel *price1;
@property (weak, nonatomic) IBOutlet UILabel *price3;


@end
