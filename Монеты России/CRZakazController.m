//
//  CRZakazController.m
//  Russian Coins
//
//  Created by Andrey Androsov on 23.08.15.
//  Copyright (c) 2015 Andrey Sonido. All rights reserved.
//

#import "CRZakazController.h"
#import "CRZakazCell.h"
#import "SKPSMTPMessage.h"

@interface CRZakazController ()

@end

static NSString* Diccoins = @"diccoins";
static NSString* Diccoins2 = @"diccoins2";
static NSString* Diccoins3 = @"diccoins3";
static NSString* Name = @"name";
static NSString* Telefon = @"telefon";
static NSString* City = @"city";

@implementation CRZakazController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Корзина";
    
    _text1.hidden = YES;
    _text2.hidden = YES;
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    _dataUser = [[[NSUserDefaults standardUserDefaults] arrayForKey:Diccoins] mutableCopy];
    _news = [[userDefaults arrayForKey:Diccoins2] mutableCopy];
    _dataZakaz = [[[NSUserDefaults standardUserDefaults] arrayForKey:Diccoins3] mutableCopy];
    [userDefaults synchronize];
    
    //_nameField.text = [[NSUserDefaults standardUserDefaults] stringForKey:Name];
    //_cityField.text = [[NSUserDefaults standardUserDefaults] stringForKey:City];
    _telefonField.text = [[NSUserDefaults standardUserDefaults] stringForKey:Telefon];
    
    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ){
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        
        if( screenHeight < 500){
            _scrollZakaz.scrollEnabled = YES;
            _scrollZakaz.contentSize = CGSizeMake(320.0f, 400.0f);
        } else {
            _scrollZakaz.scrollEnabled = NO;
        }
    }
    
    //[self reloadData];
    
    UIToolbar *keyboardDoneButtonView = [[UIToolbar alloc] init];
    [keyboardDoneButtonView sizeToFit];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStylePlain target:self
                                                                  action:@selector(doneClicked:)];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
    _telefonField.inputAccessoryView = keyboardDoneButtonView;
    
    [self updatezakaz];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    //[userDefaults setObject:_nameField.text forKey:Name];
    //[_nameField resignFirstResponder];
    //[userDefaults setObject:_cityField.text forKey:City];
    //[_cityField resignFirstResponder];
    [userDefaults setObject:_telefonField.text forKey:Telefon];
    [_telefonField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // every time the length reaches four, it gets reset to 0 and a '-' is added.

    static int currentLength = 0;

    if ((currentLength += [string length]) == 5) {
        currentLength = 3;
        [_telefonField setText:[NSString stringWithFormat:@"%c%@%@%@", '(', [_telefonField text], string, @") "]];
         return NO;
    }
    if ((currentLength += [string length]) == 9) {
        currentLength = 9;
        [_telefonField setText:[NSString stringWithFormat:@"%@%@%@", [_telefonField text], string, @"-"]];
        return NO;
    }
         //return YES;
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= 14;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGPoint scrollPoint = CGPointMake(0, 40);
    [_scrollZakaz setContentOffset:scrollPoint animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    CGPoint scrollPoint = CGPointMake(0, -64);
    [_scrollZakaz setContentOffset:scrollPoint animated:YES];
    [self updatezakaz];
}

- (void)updatezakaz
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    _dataZakaz = [[[NSUserDefaults standardUserDefaults] arrayForKey:Diccoins3] mutableCopy];
    [userDefaults synchronize];
    if (!_dataZakaz|(_dataZakaz.count == 0)) {
        _tableZakaz.hidden = YES;
        _email.enabled = NO;
        _deleteAll.hidden = YES;
    } else {
        _tableZakaz.hidden = NO;
        if ([_telefonField hasText]) {
            _email.enabled = YES;
        } else {
            _email.enabled = NO;
        }
        _deleteAll.hidden = NO;
    }
    NSPredicate* coin = [NSPredicate predicateWithFormat:@"id IN %@", _dataZakaz];
    NSArray *coinres = [[CRData fetchData] filteredArrayUsingPredicate:coin];
    _dataSource = coinres;
    
    _sumDataZakaz = [[NSMutableArray alloc]initWithCapacity:[_dataZakaz count]];
    _textMailZakaz = [[NSMutableArray alloc]initWithCapacity:[_dataZakaz count]];
    for(int i = 0; i<[_dataZakaz count]; i ++) {
        NSString *find = [NSString stringWithFormat: @"%@-1",[_dataZakaz objectAtIndex:i]];
        NSPredicate* with1 = [NSPredicate predicateWithFormat:@"article CONTAINS[cd] %@", find];
        NSPredicate* notwith1 = [NSCompoundPredicate notPredicateWithSubpredicate:with1];
        NSArray *notsresult1 = [_news filteredArrayUsingPredicate:notwith1];
        
        NSPredicate* coin = [NSPredicate predicateWithFormat:@"article CONTAINS[cd] %@", [_dataZakaz objectAtIndex:i]];
        NSArray *coinres = [notsresult1 filteredArrayUsingPredicate:coin];
        
        if([coinres count] > 0) {
            NSDictionary *newsItem = [coinres objectAtIndex:0];
            NSMutableString *resultfin = [NSMutableString stringWithFormat:@"%@", [newsItem objectForKey:@"price"]];
            [resultfin replaceOccurrencesOfString:@"\n" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, resultfin.length)];
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            f.numberStyle = NSNumberFormatterDecimalStyle;
            _pcssum = [f numberFromString:resultfin];
        }
        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *key = [NSString stringWithFormat: @"%@",[_dataZakaz objectAtIndex:i]];
        NSString *keyNew = [NSString stringWithFormat: @"%@-1",[_dataZakaz objectAtIndex:i]];
        //_pcsstep = [userDefaults objectForKey:key];
        _pcsstep = [NSNumber numberWithFloat:(([[userDefaults objectForKey:key] integerValue] + [[userDefaults objectForKey:keyNew] integerValue]))];
        
        NSNumber *sum = [NSNumber numberWithFloat:([_pcssum floatValue] * [_pcsstep floatValue])];
        [_sumDataZakaz addObject:(sum)];
        
        if ([[userDefaults objectForKey:keyNew] integerValue] > 0) {
            NSString *text = [NSString stringWithFormat:@"Article:%@ pcs:%@ mmd:%@ spmd:%@", [_dataZakaz objectAtIndex:i], [_pcsstep stringValue], [[userDefaults objectForKey:key] stringValue], [[userDefaults objectForKey:keyNew] stringValue]];
            [_textMailZakaz addObject:(text)];
        } else {
            NSString *text = [NSString stringWithFormat:@"Article:%@ pcs:%@", [_dataZakaz objectAtIndex:i], [_pcsstep stringValue]];
            [_textMailZakaz addObject:(text)];
        }
        
    }
    NSArray* numbers = _sumDataZakaz;
    NSNumber* sum = [numbers valueForKeyPath: @"@sum.self"];
    _sumZakaz.text = [NSString stringWithFormat:@"Сумма заказа: %@ ₽", [sum stringValue]];
    
    [_tableZakaz reloadData];
}

- (IBAction)doneClicked:(id)sender
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:_telefonField.text forKey:Telefon];
    
    NSLog(@"Done Clicked.");
    [self.view endEditing:YES];
}

- (IBAction)email:(id)sender {
    
    // Email Subject
    NSString *emailTitle = @"Ваш заказ (iOS)";
    // Email Content
    
    NSString *messageBody = [NSString stringWithFormat:@"%@\n\r%@\n\n\rТелефон: +7%@", _textMailZakaz, _sumZakaz.text, _telefonField.text];
    // To address
    //NSArray *toRecipents = [NSArray arrayWithObjects:@"bkv@ricgold.com",@"mev81@mail.ru",@"mister.loka@yandex.ru",@"harchenko1987@yandex.ru",nil];
    NSArray *toRecipents = [NSArray arrayWithObjects:@"www.ricgold.com@yandex.ru",nil];
    //NSArray *toBccRecipents = [NSArray arrayWithObjects:@"andrey.sonido@gmail.com",nil];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    //[mc setEditing:NO];
    [mc setToRecipients:toRecipents];
    //[mc setBccRecipients:toBccRecipents];
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:nil];
    
    
    //NSMutableArray *toRecipents = [NSMutableArray arrayWithObjects:@"bkv@ricgold.com",@"mev81@mail.ru",@"mister.loka@yandex.ru",@"harchenko1987@yandex.ru",nil];
    
    
    /*
    NSString *txtMessage = [NSString stringWithFormat:@"%@\n\r%@\n\n\rТелефон: +7%@", _textMailZakaz, _sumZakaz.text, _telefonField.text];
    SKPSMTPMessage *testMsg = [[SKPSMTPMessage alloc] init];
    
    testMsg.fromEmail = @"rial.gold2016@gmail.com"; // адрес, от кого отправляем письмо
    testMsg.toEmail = @"www.ricgold.com@yandex.ru"; //адрес, куда отправляем письмо
    testMsg.relayHost = @"smtp.gmail.com"; //smtp сервер, который вы используете
    testMsg.requiresAuth = YES; //требуется ли аутентификация
    testMsg.login = @"rial.gold2016@gmail.com"; //login на smtp сервев
    testMsg.pass = @"hbfkrhtlbn"; //пароль для smtp сервера
    testMsg.subject = @"Заказ с iOS"; //тема письма
    //testMsg.ccEmail = @"harchenko1987@yandex.ru";
    testMsg.bccEmail = @"andrey.sonido@gmail.com";
    testMsg.wantsSecure = YES; // smtp.gmail.com doesn't work without TLS!
    
    NSDictionary *plainPart = [NSDictionary dictionaryWithObjectsAndKeys:@"text/plain",
                               kSKPSMTPPartContentTypeKey,
                               txtMessage,
                               kSKPSMTPPartMessageKey,
                               @"8bit",
                               kSKPSMTPPartContentTransferEncodingKey,
                               nil];
    
    testMsg.parts = [NSArray arrayWithObjects:plainPart,nil];
    
    [testMsg send];
    */
    _text1.hidden = NO;
    _text2.hidden = NO;
    _email.enabled = NO;
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [_dataZakaz removeAllObjects];
    [userDefaults setObject:_dataZakaz forKey:Diccoins3];
    [userDefaults synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:Diccoins3 object:nil];
}

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    switch (result) {
        case MFMailComposeResultSent:
            //NSLog(@"You sent the email.");
            //_rezerv.text = @"Зарезервировано";
            _text1.hidden = NO;
            _text2.hidden = NO;
            //_stepperPcs.enabled = NO;
            break;
        case MFMailComposeResultSaved:
            //NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            //NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            //NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            //NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)site:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.ricgold.com"]];
}

- (IBAction)tel:(id)sender {
    UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:@"Позвонить в магазин"
                                                    message:@""
                                                   delegate:self
                                          cancelButtonTitle:@"Отмена"
                                          otherButtonTitles:@"+7-926-306-74-74",@"+7-985-344-26-27",nil];
    Alert.alertViewStyle = UIAlertViewStyleDefault;
    [Alert show];
}

- (IBAction)deleteAll:(id)sender {
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [_dataZakaz removeAllObjects];
    [userDefaults setObject:_dataZakaz forKey:Diccoins3];
    [userDefaults synchronize];
    
    //[self reloadData];
    [self updatezakaz];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:Diccoins3 object:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://79263067474"]];
        //_rezerv.text = @"Зарезервировано";
        _text1.hidden = NO;
        _text2.hidden = NO;
    }
    if (buttonIndex == 2) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://79853442627"]];
        //_rezerv.text = @"Зарезервировано";
        _text1.hidden = NO;
        _text2.hidden = NO;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_dataZakaz count] == 0) {
        return 0;
    }
    return [_dataZakaz count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const CoinCellId = @"ZakazCell";
    CRZakazCell *cell = [tableView dequeueReusableCellWithIdentifier:CoinCellId];
    if (!cell)
    {
        cell = [[CRZakazCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CoinCellId];
    }
    cell = [_tableZakaz dequeueReusableCellWithIdentifier:CoinCellId];
    CRData *item = [_dataSource objectAtIndex:indexPath.row];
    cell.cellImage.image = [UIImage imageNamed:item.imageName3];
    cell.cellRating.text = item.rating;
    cell.cellTitle.text = item.title;
    
    NSString *find = [NSString stringWithFormat: @"%@-1",item.id];
    NSPredicate* with1 = [NSPredicate predicateWithFormat:@"article CONTAINS[cd] %@", find];
    NSPredicate* notwith1 = [NSCompoundPredicate notPredicateWithSubpredicate:with1];
    NSArray *notsresult1 = [_news filteredArrayUsingPredicate:notwith1];
    
    NSPredicate* coin = [NSPredicate predicateWithFormat:@"article CONTAINS[cd] %@", item.id];
    NSArray *coinres = [notsresult1 filteredArrayUsingPredicate:coin];
    
    if([coinres count] > 0) {
        NSDictionary *newsItem = [coinres objectAtIndex:0];
        if ([newsItem objectForKey:@"price"] == 0) {
            NSMutableString *resultfin = [NSMutableString stringWithFormat:@"Цена: по запросу"];
            cell.priceRic.text = resultfin;
        } else {
            NSMutableString *resultfin = [NSMutableString stringWithFormat:@"Цена: %@ ₽", [newsItem objectForKey:@"price"]];
            [resultfin replaceOccurrencesOfString:@"\n\t\t\t\t\t" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, resultfin.length)];
            cell.priceRic.text = resultfin;
        }
    }
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat: @"%@",item.id];
    NSString *keyNew = [NSString stringWithFormat: @"%@-1",item.id];
    NSNumber *sum1 = [NSNumber numberWithFloat:([[userDefaults objectForKey:key] integerValue] + [[userDefaults objectForKey:keyNew] integerValue])];
    
    if ([[userDefaults objectForKey:keyNew] integerValue] > 0) {
        cell.cellDvor.text = [NSString stringWithFormat:@"М:%ld С:%ld", [[userDefaults objectForKey:key] integerValue], [[userDefaults objectForKey:keyNew] integerValue]];
    } else {
        cell.cellDvor.text = [NSString stringWithFormat:@" "];
    }
    
    cell.stepperPcs.tag = indexPath.row;
    cell.cellPcs.text = [NSString stringWithFormat:@"%@", sum1];
    cell.stepperPcs.value = [[userDefaults objectForKey:key] doubleValue];
    [userDefaults synchronize];
    [cell.stepperPcs addTarget:self action:@selector(incrementStepper:) forControlEvents:UIControlEventValueChanged];
    
    return cell;
}

- (void)incrementStepper:(UIStepper *)sender {
    NSInteger row = sender.tag;
    CRData *item = [_dataSource objectAtIndex:row];
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat: @"%@",item.id];
    //NSString *keyNew = [NSString stringWithFormat: @"%@-1",item.id];
    [userDefaults setObject:[NSNumber numberWithDouble:[(UIStepper *)sender value]] forKey:key];
    if (sender.value == 0) {
        [_dataZakaz removeObject:item.id];
        [userDefaults setObject:_dataZakaz forKey:Diccoins3];
        [[NSNotificationCenter defaultCenter] postNotificationName:Diccoins3 object:nil];
    }
    [userDefaults synchronize];

    [self updatezakaz];
}

@end
