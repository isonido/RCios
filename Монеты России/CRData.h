//
//  CRData.h
//  Монеты России
//
//  Created by Andrey Androsov on 14.01.14.
//  Copyright (c) 2014 Andrey Sonido. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRData : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *rating;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imageName1;
@property (nonatomic, copy) NSString *imageName2;
@property (nonatomic, copy) NSString *imageName3;

@property (nonatomic, copy) NSString *createdOn;
@property (nonatomic, copy) NSString *created;
@property (nonatomic, copy) NSString *text1;
@property (nonatomic, copy) NSString *text2;
@property (nonatomic, copy) NSString *row1text0;
@property (nonatomic, copy) NSString *row1text1;

@property (nonatomic) NSInteger kind;
@property (nonatomic) NSNumber* price;
@property (nonatomic) NSNumber* price2;

@property (nonatomic, copy) NSString *quality;
@property (nonatomic, copy) NSString *still;
@property (nonatomic, copy) NSString *weight;
@property (nonatomic, copy) NSString *weightStill;
@property (nonatomic, copy) NSString *diameter;
@property (nonatomic, copy) NSString *length;

@property (nonatomic, copy) NSString *thickness;
@property (nonatomic, copy) NSString *pcs;

@property (nonatomic, copy) NSString *creator;
@property (nonatomic, copy) NSString *sculptor;
@property (nonatomic, copy) NSString *dvor;
@property (nonatomic, copy) NSString *gurt;

@property (nonatomic, copy) NSString *serial;

+ (NSArray *)fetchData;

@end
