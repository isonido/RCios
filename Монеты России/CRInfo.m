//
//  CRInfo.m
//  Russian Coins
//
//  Created by Andrey Androsov on 14.04.15.
//  Copyright (c) 2015 Andrey Sonido. All rights reserved.
//

#import "CRInfo.h"

@interface CRInfo ()

@end

@implementation CRInfo

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _textInfo.text = _detail.text2;
    [_textInfo setTextAlignment:NSTextAlignmentCenter];
    [_textInfo setFont:[UIFont systemFontOfSize:14]];
    self.navigationItem.title = @"Историко-тематическая справка";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDetail:(CRData *)detail
{
    _detail = detail;
}

@end
