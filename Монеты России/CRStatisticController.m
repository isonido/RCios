//
//  CRStatisticController.m
//  Russian Coins
//
//  Created by Andrey Androsov on 11.03.15.
//  Copyright (c) 2015 Andrey Sonido. All rights reserved.
//

#import "CRStatisticController.h"
#import "CRData.h"

@interface CRStatisticController ()

@end

static NSString* Diccoins = @"diccoins";

@implementation CRStatisticController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Статистика";
    _data = [CRData fetchData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData) name:Diccoins object:nil];
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    _dataUser = [[[NSUserDefaults standardUserDefaults] arrayForKey:Diccoins] mutableCopy];
    [userDefaults synchronize];
    
    if ([_dataUserSerial count] == 0) {
        _dataUserSerial = [[NSMutableArray alloc] init];
    } else {
        nil;
    }
    _sumpcs = [[NSMutableArray alloc] init];
    _sumpcs2 = [[NSMutableArray alloc] init];
    _priceKonros = [[NSMutableArray alloc] init];
    self.dataSerial = [NSArray arrayWithObjects:
                       @"1000-летие единения мордовского народа", // - 1
                       @"1000-летие основания Казани", // - 2
                       @"1000-летие России", // - 3
                       @"100-летие единения России и Тувы", // - 4
                       @"100-летие Российского футбола", // - 5
                       @"100-летие эмиссионного закона Витте", // - 6
                       @"1150-летие зарождения российской государственности", // - 7
                       @"1150-летие основания города Смоленска", // - 8
                       @"150-летие Банка России", // - 9
                       @"150-летие начала эпохи Великих реформ", // - 10
                       @"150-летие со дня рождения А.П. Чехова", // - 11
                       @"1-я и 2-я Камчатская экспедиция", // - 12
                       @"2000-летие основания г. Дербента", // - 13
                       @"200-летие образования министерств", // - 14
                       @"200-летие победы ОВ 1812 года", // - 15
                       @"200-летие со дня рождения М.Ю. Лермонтова", // - 16
                       @"200-летие со дня рождения Н.В. Гоголя", // - 17
                       @"200-летие со дня рождения Пушкина", // - 18
                       @"20-летие принятия Конституции РФ", // - 19
                       @"250-летие Генерального штаба Вооруженных сил РФ", // - 20
                       @"250-летие основания Государственного Эрмитажа", // - 21
                       @"300-летие основания Санкт-Петербурга", // - 22
                       @"300-летие Полтавской битвы", // - 23
                       @"300-летие Российского флота", // - 24
                       @"300-летие Российского флота (набор)", // - 25
                       @"400-летие народного ополчения Козьмы Минина и Дмитрия Пожарского", // - 26
                       @"50 лет Великой Победы (набор)", // - 27
                       @"50-летие Победы в ВОВ", // - 28
                       @"55-я годовщина Победы в ВОВ", // - 29
                       @"60-я годовщина Победы в ВОВ", // - 30
                       @"625-летие Куликовской битвы", // - 31
                       @"65-я годовщина Победы в ВОВ", // - 32
                       @"700-летие со дня рождения Сергия Радонежского", // - 33
                       @"70-летие Победы в ВОВ", // - 34
                       @"70-летие разгрома немецко-фашистских войск в Сталинградской битве", // - 35
                       @"850-летие основания Москвы", // - 36
                       @"90-летие «Динамо»", // - 37
                       @"XXIX Летние Олимпийские Игры (г. Пекин)", // - 38
                       @"Алмазный фонд России", // - 39
                       @"Андрей Рублев", // - 40
                       @"Архитектурные шедевры России", // - 41
                       @"Барк «Крузенштерн»", // - 42
                       @"Вклад России в сокровище мировой культуры", // - 43
                       @"Вооруженные Силы РФ", // - 44
                       @"Выдающиеся личности России", // - 45
                       @"Выдающиеся полководцы России", // - 46
                       @"Выдающиеся спортсмены России", // - 47
                       @"Города, освобожденные советскими войсками от немецко-фашистских захватчиков", // - 48
                       @"Города воинской славы", // - 49
                       @"Дзюдо", // - 50
                       @"Дионисий", // - 51
                       @"Древние города России", // - 52
                       @"Животный мир стран ЕврАзЭС", // - 53
                       @"Зимние виды спорта", // - 54
                       @"Зимние Олимпийские игры 1998 года", // - 55
                       @"Знаки зодиака", // - 56
                       @"Золотое кольцо", // - 57
                       @"Инвестиционная монета", // - 58
                       @"Исследование Русской Арктики", // - 59
                       @"История денежного обращения России", // - 60
                       @"История русского военно-морского флота", // - 61
                       @"История русской авиации", // - 62
                       @"К 300-летию добровольного вхождения Хакасии в РФ", // - 63
                       @"К 350-летию добровольного вхождения Бурятии в состав РФ", // - 64
                       @"К 400-летию добровольного вхождения калмыцкого народа в состав РФ", // - 65
                       @"К 450-летию добровольного вхождения Башкирии в РФ", // - 66
                       @"К 450-летию добровольного вхождения Удмуртии в РФ", // - 67
                       @"Красная книга", // - 68
                       @"Кубок мира по спортивной ходьбе", // - 69
                       @"Легенды и сказки стран ЕврАзЭС", // - 70
                       @"Лунный календарь", // - 71
                       @"Международная монетная программа стран ЕврАзЭС", // - 72
                       @"Окно в Европу", // - 73
                       @"Олимпийский век России", // - 74
                       @"Освоение и исследование Сибири, XVI-XVII вв.", // - 75
                       @"Памятники архитектуры России", // - 76
                       @"Победa в ВОВ 1941-1945", // - 77
                       @"Первая русская антарктическая экспедиция", // - 78
                       @"Первое русское кругосветное путешествие", // - 79
                       @"Подвиг советских воинов, Крым, ВОВ 1941-1945 гг.", // - 80
                       @"Полководцы и герои ОВ 1812 года", // - 81
                       @"Российская Федерация", // - 82
                       @"Россия во всемирном наследии ЮНЕСКО", // - 83
                       @"Россия на рубеже тысячелетий", // - 84
                       @"Русские исследователи Центральной Азии", // - 85
                       @"Русский балет", // - 86
                       @"Самбо", // - 87
                       @"Сбербанк 170 лет", // - 88
                       @"Символы России", // - 89
                       @"Сокровищница мировой культуры", // - 90
                       @"Сохраним наш мир", // - 91
                       @"Сочи 2014", // - 92
                       @"Спорт", // - 93
                       @"Сражения и знаменательные события 1812 года", // - 94
                       @"Столицы стран - членов ЕврАзЭС", // - 95
                       @"Феофан Грек", // - 96
                       @"Универсиада 2013 года в Казани", // - 97
                       @"Чемпионат мира по футболу FIFA 2018 в России",// - 98
                       @"Экспедиции Г.И. Невельского на Дальний Восток", // - 99
                       @"Эпоха просвещения. XVIII век", // - 100
                       @"Ювелирное искусство в России", // - 101
                       nil];
    _alphabet = [[NSArray alloc]initWithObjects:@"1 рубль",@"2 рубля",@"3 рубля",@"5 рублей",@"10 рублей",@"20 рублей",
                 @"25 рублей",@"50 рублей",@"100 рублей",@"150 рублей",@"200 рублей",@"500 рублей",@"1000 рублей",@"10000 рублей",
                 @"25000 рублей",@"50000 рублей", nil];
    
    _data3 = [[NSMutableArray alloc] init];
    [self updateData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)updateData
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    _dataUser = [[[NSUserDefaults standardUserDefaults] arrayForKey:Diccoins] mutableCopy];
    [userDefaults synchronize];
    
    _pcsAll.text = [NSString stringWithFormat:@"%lu", (unsigned long)_data.count];
    if (!_dataUser.count) {
        _pcsUserAll.text = @"0";
        _pcsUser2 = @"0";
    } else {
        _pcsUserAll.text = [NSString stringWithFormat:@"%lu", (unsigned long)_dataUser.count];
        _pcsUser2 = [NSString stringWithFormat:@"%lu", (unsigned long)_dataUser.count];
    }
    
    for(int i = 0; i<[_dataSerial count]; i ++) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == %@", [_dataSerial objectAtIndex:i]];
        NSPredicate* df = [NSPredicate predicateWithFormat:@"id IN %@", _dataUser];
        NSArray *dresult = [_data filteredArrayUsingPredicate:serial];
        NSArray *uresult = [dresult filteredArrayUsingPredicate:df];
        
        if([uresult isEqual:dresult]) {
            [_dataUserSerial addObject:[_dataSerial objectAtIndex:i]];
        }
    }
    _serialUserAll.text = [NSString stringWithFormat:@"%lu", (unsigned long)_dataUserSerial.count];
    
    NSPredicate* find = [NSPredicate predicateWithFormat:@"id IN %@", _dataUser];
    NSArray *dfresult = [_data filteredArrayUsingPredicate:find];
    _data = dfresult;
    
    for(int j = 0; j<[_dataUser count]; j ++) {
        CRData *item = [_data objectAtIndex:j];
        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *key1 = [NSString stringWithFormat: @"0%@",[_dataUser objectAtIndex:j]];
        NSString *key2 = [NSString stringWithFormat: @"1%@",[_dataUser objectAtIndex:j]];
        _pcs = [userDefaults objectForKey:key1];
        _pcs2 = [userDefaults objectForKey:key2];
        if ([_pcs intValue]>1) {
            NSNumber *number1 = [NSNumber numberWithInt:[_pcs intValue] - 1];
            [_sumpcs addObject:number1];
        }
        if ([_pcs2 intValue]>1) {
            NSNumber *number2 = [NSNumber numberWithInt:[_pcs2 intValue] - 1];
            [_sumpcs2 addObject:number2];
        }
        NSNumber *price = [NSNumber numberWithFloat:([item.price floatValue]*([_pcs intValue]+[_pcs2 intValue]))];
        [_priceKonros addObject:price];
    }

    NSNumber* sum1 = [_sumpcs valueForKeyPath: @"@sum.self"];
    NSNumber* sum2 = [_sumpcs2 valueForKeyPath: @"@sum.self"];
    _sum = [NSNumber numberWithFloat:([sum1 floatValue] + [sum2 floatValue])];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSNumber* sumKonros = [_priceKonros valueForKeyPath: @"@sum.self"];
    NSString *string = [NSString stringWithFormat:@"%@ ₽", [numberFormatter stringForObjectValue:sumKonros]];
    _costUser.text = [string stringByReplacingOccurrencesOfString: @ "," withString: @ " "];
    if ([_costUser.text isEqualToString:@"0 ₽"]) {
        _costUser.text = @"-";
    }

    _pcsPovtrUser.text = [NSString stringWithFormat:@"%@", _sum];
    
    _serialAll.text = @"101";
    
    NSUbiquitousKeyValueStore* cloudUser = [NSUbiquitousKeyValueStore defaultStore];
    _dataUser2 = [[cloudUser arrayForKey:@"AVAILABLE_NOTES"] mutableCopy];
    [cloudUser synchronize];
    id token = [[NSFileManager defaultManager] ubiquityIdentityToken];
    if (token == nil)
    {
        _icloudenable.text = @"Cинхронизация iCloud недоступна. Проверьте настройки вашего устройства";
        //_icloudenable.text = @"Синхронизация выполнена";
        // iCloud is not available for this app
    }else{
        if ((_dataUser = _dataUser2)) {
            _icloudenable.text = @"Синхронизация выполнена";
        } else {
            _icloudenable.text = @"Синхронизация не выполнена";
        }
    }
}

- (IBAction)appStore:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1198257212&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"]];
}

- (IBAction)developer:(id)sender {
    // Email Subject
    NSString *emailTitle = @"Монеты России";
    // Email Content
    NSString *messageBody = @"Ваше сообщение:";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObjects:@"andrey.sonido@gmail.com",@"bkv@ricgold.com",nil];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
}

- (IBAction)vk:(id)sender {
    NSString *path = @"http://ricgold.com";
    NSURL *url = [NSURL URLWithString:path];
    [[UIApplication sharedApplication] openURL:url];
    /*
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://vk.com/club89320889"]];
    } */
}

- (IBAction)sendStat:(id)sender {
    [super viewDidLoad];
    UIActionSheet *actSheet = [[UIActionSheet alloc] initWithTitle:@"Поделиться статистикой"
                                                          delegate:self
                                                 cancelButtonTitle:@"Отмена"
                                                destructiveButtonTitle:nil
                                                 otherButtonTitles:@"E-mail",nil];
    actSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actSheet showInView:self.view];
}

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)actionSheet:(UIActionSheet *)actSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        // Email Subject
        NSString *emailTitle2 = @"Моя коллекция";
        
        // Email Content
        //NSString *messageBody = [NSString stringWithFormat:@"%@\n\r%@\n\n\rИмя: %@\n\rГород: %@\n\rТелефон: %@", _textMailZakaz, _sumZakaz.text, _nameField.text, _cityField.text, _telefonField.text];
        
        NSPredicate* find = [NSPredicate predicateWithFormat:@"id IN %@", _dataUser];
        NSArray *dfresult = [_data filteredArrayUsingPredicate:find];
        _data = dfresult;
        
        //NSString *messageBody2 = @"";
        NSString *messageBody2 = [NSString stringWithFormat:@"Монет в коллекции: %@ шт., повторных: %@ шт.", _pcsUser2, _sum];
        
        int j;
        for (j=0; j < [_alphabet count]; j++) {
            
            NSPredicate* p = [NSPredicate predicateWithFormat:@"rating == %@", [_alphabet objectAtIndex:j]];
            NSArray *fresult = [_data filteredArrayUsingPredicate:p];
            
                if([fresult count]>0) {
                    _data3 = fresult;
                    //NSLog(@"%@", _data3);
                    messageBody2 = [messageBody2 stringByAppendingFormat:@"</table>"];
                    messageBody2 = [messageBody2 stringByAppendingFormat:@"<h4>%@</h4>", [_alphabet objectAtIndex:j]];
                    messageBody2 = [messageBody2 stringByAppendingFormat:@"<table width='700' border='1'><tr><th align='center'>№</th><th align='center'>Год</th><th align='center'>Наименование</th><th align='center'>Кат.номер</th><th align='center'>ММД</th><th align='center'>СПМД</th></tr>"];
                    int i;
                    
                    for (i=0; i < [_data3 count]; i++) {
                        CRData *item = [_data3 objectAtIndex:i];
                        
                        messageBody2 = [messageBody2 stringByAppendingFormat:@"<tr><td width='30' align='center'>"];
                        messageBody2 = [messageBody2 stringByAppendingFormat:@"%d", i+1];
                        messageBody2 = [messageBody2 stringByAppendingFormat:@"</td><td width='50' align='center'>"];
                        messageBody2 = [messageBody2 stringByAppendingFormat:@"%@",item.created];
                        messageBody2 = [messageBody2 stringByAppendingFormat:@"</td><td>"];
                        messageBody2 = [messageBody2 stringByAppendingFormat:@"%@",item.title];
                        messageBody2 = [messageBody2 stringByAppendingFormat:@"</td><td width='100' align='center'>"];
                        messageBody2 = [messageBody2 stringByAppendingFormat:@"%@",item.id];
                        messageBody2 = [messageBody2 stringByAppendingFormat:@"</td><td width='50' align='center'>"];
                        
                        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
                        NSString *key1 = [NSString stringWithFormat: @"0%@",item.id];
                        NSString *key2 = [NSString stringWithFormat: @"1%@",item.id];
                        _pcs = [userDefaults objectForKey:key1];
                        _pcs2 = [userDefaults objectForKey:key2];
                        
                        if ([item.dvor isEqualToString:@"ММД"]) {
                            _pcsMmd = [NSString stringWithFormat:@"%@", [_pcs stringValue]];
                            if ([_pcs stringValue] == 0) {
                                _pcsMmd = [NSString stringWithFormat:@"0"];
                            }
                            _pcsSpmd = [NSString stringWithFormat:@"-"];
                        }
                        if ([item.dvor isEqualToString:@"СПМД"]) {
                            _pcsMmd = [NSString stringWithFormat:@"-"];
                            _pcsSpmd = [NSString stringWithFormat:@"%@", [_pcs stringValue]];
                            if ([_pcs stringValue] == 0) {
                                _pcsSpmd = [NSString stringWithFormat:@"0"];
                            }
                        }
                        if ([item.dvor isEqualToString:@"ММД и СПМД"]|[item.dvor isEqualToString:@"ММД и СПМД (ЛМД)"]) {
                            _pcsMmd = [NSString stringWithFormat:@"%@", [_pcs stringValue]];
                            if ([_pcs stringValue] == 0) {
                                _pcsMmd = [NSString stringWithFormat:@"0"];
                            }
                            _pcsSpmd = [NSString stringWithFormat:@"%@", [_pcs2 stringValue]];
                            if ([_pcs2 stringValue] == 0) {
                                _pcsSpmd = [NSString stringWithFormat:@"0"];
                            }
                        }
                        messageBody2 = [messageBody2 stringByAppendingFormat:@"%@", _pcsMmd];
                        messageBody2 = [messageBody2 stringByAppendingFormat:@"</td><td width='50' align='center'>"];
                        messageBody2 = [messageBody2 stringByAppendingFormat:@"%@", _pcsSpmd];
                        messageBody2 = [messageBody2 stringByAppendingFormat:@"</td></tr>"];
                    }
                }
        }
        
        // To address
        //NSArray *toRecipents = [NSArray arrayWithObjects:@"sonido@mail.ru",nil];
        
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle2];
        [mc setMessageBody:messageBody2 isHTML:YES];
        //[mc setToRecipients:toRecipents];
        [mc setToRecipients:nil];
        
        //[mc addAttachmentData:fileData mimeType:mimeType fileName:filename];
        
        // Present mail view controller on screen
        [self presentViewController:mc animated:YES completion:nil];
    }
    if (buttonIndex == 1) {
        NSLog(@"1");
    }
    if (buttonIndex == 2) {
        NSLog(@"2");
    }
}


@end
