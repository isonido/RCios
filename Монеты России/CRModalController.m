//
//  CRModalController.m
//  Монеты России
//
//  Created by Andrey Androsov on 23.07.14.
//  Copyright (c) 2014 Andrey Sonido. All rights reserved.
//

#import "CRModalController.h"

@interface CRModalController ()

@end


static NSString* MMDpcs = @"coinpcsmmd";
static NSString* SPMDpcs = @"coinpcsspmd";
static NSString* Diccoins = @"diccoins";
static NSString* pcs1 = @"1pcs";
static NSString* pcs2 = @"2pcs";

@implementation CRModalController

@synthesize pcsPickerView;


- (void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *key1 = [NSString stringWithFormat: @"0%@",_detail.id];
    NSString *key2 = [NSString stringWithFormat: @"1%@",_detail.id];

    [pcsPickerView selectRow:[userDefaults integerForKey:key1] inComponent:0 animated:NO];
    if (pcsPickerView.numberOfComponents == 2) {
    [pcsPickerView selectRow:[userDefaults integerForKey:key2] inComponent:1 animated:NO];
    } else {
        nil;
    }
    [self updateCoins];

    [userDefaults synchronize];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reloadData];

    _pcsCoins = [[NSMutableArray alloc] init];
    int i;
    for ( i = 0; i < 1000; ++i) [_pcsCoins addObject:[NSString stringWithFormat: @"%d",i]];
    
    _dvorLabel.text = _detail.dvor;
    _stepper2.enabled = NO;

    if ([_dvor  isEqual: @"ММД и СПМД"]|[_dvor  isEqual: @"ММД и СПМД (ЛМД)"]) {
        _dvorLabel.text = @"ММД                   СПМД";
        _stepper2.enabled = YES;

        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ){
            _stepper1.translatesAutoresizingMaskIntoConstraints = YES;
            _stepper2.translatesAutoresizingMaskIntoConstraints = YES;
            
            _stepper1.frame = CGRectMake(42, 350, 0, 0);
            _stepper2.frame = CGRectMake(184, 350, 0, 0);
            
            CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
            CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
            if( screenHeight < screenWidth ){
                screenHeight = screenWidth;
            }
            if( screenHeight > 480 && screenHeight < 667 ){
                nil;
                //NSLog(@"iPhone 5/5s");
            } else if ( screenHeight > 480 && screenHeight < 736 ){
                _stepper1.frame = CGRectMake(42 + 20, 350, 0, 0);
                _stepper2.frame = CGRectMake(184 + 36, 350, 0, 0);
                //NSLog(@"iPhone 6");
            } else if ( screenHeight > 480 ){
                _stepper1.frame = CGRectMake(42 + 35, 350, 0, 0);
                _stepper2.frame = CGRectMake(184 + 59, 350, 0, 0);
                //NSLog(@"iPhone 6 Plus");
            } else {
                nil;
                //NSLog(@"iPhone 4/4s");
            }
        } else {
            //iPad
            _stepper1.frame = CGRectMake(250, 230, 0, 0);
            _stepper2.frame = CGRectMake(820, 230, 0, 0);
        }
    }
    
    if ([_quality isEqual: @"БА/пруф-лайк"]){
        _dvorLabel.text = @"    БА              пруф-лайк";
        _stepper2.enabled = YES;
        
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ){
            _stepper1.translatesAutoresizingMaskIntoConstraints = YES;
            _stepper2.translatesAutoresizingMaskIntoConstraints = YES;
            
            CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
            CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
            if( screenHeight < screenWidth ){
                screenHeight = screenWidth;
            }
            if( screenHeight > 480 && screenHeight < 667 ){
                _stepper1.frame = CGRectMake(42, 344, 0, 0);
                _stepper2.frame = CGRectMake(184, 344, 0, 0);
                //NSLog(@"iPhone 5/5s");
            } else if ( screenHeight > 480 && screenHeight < 736 ){
                _stepper1.frame = CGRectMake(42 + 20, 370, 0, 0);
                _stepper2.frame = CGRectMake(184 + 36, 370, 0, 0);
                //NSLog(@"iPhone 6");
            } else if ( screenHeight > 480 ){
                _stepper1.frame = CGRectMake(42 + 35, 350, 0, 0);
                _stepper2.frame = CGRectMake(184 + 59, 350, 0, 0);
                //NSLog(@"iPhone 6 Plus");
            } else {
                _stepper1.frame = CGRectMake(42, 344, 0, 0);
                _stepper2.frame = CGRectMake(184, 344, 0, 0);
                //NSLog(@"iPhone 4/4s");
            }
        } else {
            _stepper1.frame = CGRectMake(36, 230, 0, 0);
            _stepper2.frame = CGRectMake(172, 230, 0, 0);
        }
    }
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    _dataUser = [[[NSUserDefaults standardUserDefaults] arrayForKey:Diccoins] mutableCopy];
    [userDefaults synchronize];
    
    if ([_dataUser count] == 0) {
    _dataUser = [[NSMutableArray alloc] init];
    } else {
        nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDetail:(CRData *)detail
{
    _detail = detail;
    [self reloadData];
}

- (void)reloadData
{
    if (!_detail) {
        return;
    }
    _dvor = _detail.dvor;
    _quality = _detail.quality;
    _smallCoins.image = [UIImage imageNamed:_detail.imageName2];
    _titleAdd.text = _detail.title;

    self.navigationItem.title = @"Добавить/Изменить";
}

- (void)updateCoins
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *key1 = [NSString stringWithFormat: @"0%@",_detail.id];
    NSString *key2 = [NSString stringWithFormat: @"1%@",_detail.id];
    _pcs = [userDefaults objectForKey:key1];
    _pcs2 = [userDefaults objectForKey:key2];

    if ([_pcs intValue] == 0) {
        if ([_pcs2 intValue] == 0) {
    [_dataUser removeObject:_detail.id];
    [userDefaults setObject:_dataUser forKey:Diccoins];
        }
    }
    _stepper1.value = [_pcs doubleValue];
    _stepper2.value = [_pcs2 doubleValue];
    NSUbiquitousKeyValueStore* cloudUser = [NSUbiquitousKeyValueStore defaultStore];
    [cloudUser setArray:_dataUser forKey:@"AVAILABLE_NOTES"];
    [cloudUser setObject:_pcs forKey:key1];
    [cloudUser setObject:_pcs2 forKey:key2];
    [cloudUser synchronize];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pcsPickerView
{
    if ([_quality isEqual: @"БА/пруф-лайк"]|[_dvor isEqual: @"ММД и СПМД"]|[_dvor isEqual: @"ММД и СПМД (ЛМД)"]) {
        return 2;
    } else {
        return 1;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pcsPickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pcsCoins.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *pickerLabel = (UILabel *)view;
    if (pickerLabel == nil) {
        pickerLabel = [[UILabel alloc] init];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setFont:[UIFont systemFontOfSize:18]];
    }
        [pickerLabel setText:[_pcsCoins objectAtIndex:row]];

    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pcsPickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *key1 = [NSString stringWithFormat: @"0%@",_detail.id];
    NSString *key2 = [NSString stringWithFormat: @"1%@",_detail.id];
    if(component == 0) {
        _pcs = [NSNumber numberWithInteger:row];
       
        if (row == 0) {
            NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:_pcs forKey:key1];
            [userDefaults synchronize];
            [self updateCoins];
            [[NSNotificationCenter defaultCenter] postNotificationName:Diccoins object:nil];
        } else {
            NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:_pcs forKey:key1];
            [userDefaults synchronize];
            [self updateCoins];
            [[NSNotificationCenter defaultCenter] postNotificationName:Diccoins object:nil];
            if ([_dataUser containsObject:_detail.id]) {
                nil;
            } else {
                [_dataUser addObject:_detail.id];
                NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:_dataUser forKey:Diccoins];
                [userDefaults synchronize];
                [self updateCoins];
                [[NSNotificationCenter defaultCenter] postNotificationName:Diccoins object:nil];
            }
        }
    } else {
        _pcs2 = [NSNumber numberWithInteger:row];

        if (row == 0) {
            NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:_pcs2 forKey:key2];
            [userDefaults synchronize];
            [self updateCoins];
            [[NSNotificationCenter defaultCenter] postNotificationName:Diccoins object:nil];
        } else {
            NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:_pcs2 forKey:key2];
            [userDefaults synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:Diccoins object:nil];
            [self updateCoins];
            if ([_dataUser containsObject:_detail.id]) {
                nil;
            } else {
                [_dataUser addObject:_detail.id];
                NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:_dataUser forKey:Diccoins];
                [userDefaults synchronize];
                [self updateCoins];
                [[NSNotificationCenter defaultCenter] postNotificationName:Diccoins object:nil];
            }
        }
    }
}

- (IBAction)stepper1:(id)sender {
    NSString *key1 = [NSString stringWithFormat: @"0%@",_detail.id];
    _pcs = [NSNumber numberWithDouble:[(UIStepper *)sender value]];
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:_pcs forKey:key1];
    if ([_dataUser containsObject:_detail.id]) {
        nil;
    } else {
    [_dataUser addObject:_detail.id];
    }
    [userDefaults setObject:_dataUser forKey:Diccoins];
    [userDefaults synchronize];
    [self updateCoins];
    [[NSNotificationCenter defaultCenter] postNotificationName:Diccoins object:nil];
    [pcsPickerView selectRow:[userDefaults integerForKey:key1] inComponent:0 animated:YES];
    
}

- (IBAction)stepper2:(id)sender {
    NSString *key2 = [NSString stringWithFormat: @"1%@",_detail.id];
    _pcs2 = [NSNumber numberWithDouble:[(UIStepper *)sender value]];
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:_pcs2 forKey:key2];
    if ([_dataUser containsObject:_detail.id]) {
        nil;
    } else {
    [_dataUser addObject:_detail.id];
    }
    [userDefaults setObject:_dataUser forKey:Diccoins];
    [userDefaults synchronize];
    [self updateCoins];
    [[NSNotificationCenter defaultCenter] postNotificationName:Diccoins object:nil];
    [pcsPickerView selectRow:[userDefaults integerForKey:key2] inComponent:1 animated:YES];
    
}

- (IBAction)touchHome:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
