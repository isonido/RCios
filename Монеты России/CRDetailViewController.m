//
//  CRDetailViewController.m
//  Монеты России
//
//  Created by Andrey Androsov on 14.01.14.
//  Copyright (c) 2014 Andrey Sonido. All rights reserved.
//


#import "CRDetailViewController.h"
#import "CRViewController.h"
#import "MxMovingPlaceholderTextField.h"
#import "CRModalController.h"


@interface CRDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;

@end

static NSString* Diccoins = @"diccoins";
static NSString* Diccoins2 = @"diccoins2";
static NSString* Diccoins3 = @"diccoins3";
static NSString* UpdateIpad = @"update";
static NSString* Serial = @"serial";
static NSString* Nominal = @"nominal";
static NSString* Year = @"year";
static NSString* Sort = @"sorting";
static NSString* Still = @"still";

@implementation CRDetailViewController

@synthesize scrollView;
@synthesize triggerView;
@synthesize selectedSegmentImage;
@synthesize masterPopoverController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custum initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self refreshScreen];
        
        scrollView.contentSize = CGSizeMake(320.0f, 600.0f);
    } else {
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        
        if (orientation == UIInterfaceOrientationLandscapeLeft) {
            _screenIpad.frame = CGRectMake(0.0f, 65.0f, 704.0f, 704.0f);
        } else if (orientation == UIInterfaceOrientationLandscapeRight) {
            _screenIpad.frame = CGRectMake(0.0f, 65.0f, 704.0f, 704.0f);
        } else if (orientation == UIInterfaceOrientationPortrait) {
            _screenIpad.frame = CGRectMake(0.0f, 65.0f, 770.0f, 770.0f);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            _screenIpad.frame = CGRectMake(0.0f, 65.0f, 770.0f, 770.0f);
        }
    }
    _titleSection = [[NSArray alloc]initWithObjects:@" Подробно",nil];
    
    _isOp=[[NSMutableArray alloc] init];
    for (int i=0; i<1; i++) {
        [_isOp addObject:[NSNumber numberWithInt:0]];
    }
    if ([_detail.id characterAtIndex:1] == '0') {
        triggerView.tintColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.80]; }
    if ([_detail.id characterAtIndex:1] == '1') {
        triggerView.tintColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.80]; }
    if ([_detail.id characterAtIndex:1] == '7') {
        if ([_detail.id characterAtIndex:3] == '0'){
            triggerView.tintColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.80]; }
        if ([_detail.id characterAtIndex:3] == '2'){
            triggerView.tintColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.80]; }
        if ([_detail.id characterAtIndex:3] == '9'){
            triggerView.tintColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.80]; }
    }
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    _dataUser = [[userDefaults arrayForKey:Diccoins] mutableCopy];
    _news = [[userDefaults arrayForKey:Diccoins2] mutableCopy];
    _dataZakaz = [[userDefaults arrayForKey:Diccoins3] mutableCopy];
    [userDefaults synchronize];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCoins) name:Diccoins object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCoins) name:Diccoins2 object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:Diccoins3 object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCoins) name:UpdateIpad object:nil];
    [self updateCoins];

    _basketAddAlert.hidden = YES;
    
    if (!_dataZakaz|(_dataZakaz.count == 0)) {
        //[_basketImage setImage:[UIImage imageNamed:@"basketEmpty.png"] forState:UIControlStateNormal];
        _basketImage.image = [UIImage imageNamed:@"basketEmpty.png"];
    } else {
        //[_basketImage setImage:[UIImage imageNamed:@"basketFull.png"] forState:UIControlStateNormal];
        _basketImage.image = [UIImage imageNamed:@"basketFull.png"];
    }
    [self reloadData];
    if (!_dataZakaz|(_dataZakaz.count == 0)) {
        _dataZakaz = [[NSMutableArray alloc] init];
        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:_dataZakaz forKey:Diccoins3];
        [userDefaults synchronize];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDetail:(CRData *)detail
{
    _detail = detail;
    [self reloadData];
    
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}

- (void)updateCoins
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *key1 = [NSString stringWithFormat: @"0%@",_detail.id];
    NSString *key2 = [NSString stringWithFormat: @"1%@",_detail.id];
    _pcs = [userDefaults objectForKey:key1];
    _pcs2 = [userDefaults objectForKey:key2];
    NSNumber *sum = [NSNumber numberWithFloat:([_pcs floatValue] + [_pcs2 floatValue])];
    if ([sum intValue] == 0) {
        _kolPcs.text = @"нет";
        [_addEdit setTitle:@"Добавить" forState:UIControlStateNormal];
    } else {
        _kolPcs.text = [NSString stringWithFormat:@"%@ шт", [sum stringValue]];
        [_addEdit setTitle:@"Изменить" forState:UIControlStateNormal];
    }
    _kolName.textColor = [UIColor darkGrayColor];
    //_kolPcs.textColor = [UIColor blackColor];
    //_kolPcs.textColor = [UIColordef];
    
    if (_detail.text2 == nil) {
        _history.enabled = NO;
    } else {
        _history.enabled = YES;
    }
    
    NSString *find = [NSString stringWithFormat: @"%@-1",_detail.id];
    NSPredicate* with1 = [NSPredicate predicateWithFormat:@"article CONTAINS[cd] %@", find];
    NSPredicate* notwith1 = [NSCompoundPredicate notPredicateWithSubpredicate:with1];
    NSArray *notsresult1 = [_news filteredArrayUsingPredicate:notwith1];
    //NSArray *yesresult1 = [_news filteredArrayUsingPredicate:with1];
    
    NSPredicate* coin = [NSPredicate predicateWithFormat:@"article CONTAINS[cd] %@", _detail.id];
    NSArray *coinres = [notsresult1 filteredArrayUsingPredicate:coin];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    if([coinres count] > 0) {
        _zakaz.hidden = NO;
        NSDictionary *newsItem = [coinres objectAtIndex:0];
        //NSMutableString *resultfin = [NSMutableString stringWithFormat:@"%@ ₽", [newsItem objectForKey:@"price"]];
        //[resultfin replaceOccurrencesOfString:@"\n\t\t\t\t\t" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, resultfin.length)];
        //_priceric.text = resultfin;
        NSMutableString *resultfin = [NSMutableString stringWithFormat:@"%@", [newsItem objectForKey:@"price"]];
        [resultfin replaceOccurrencesOfString:@"\n" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, resultfin.length)];
        NSString *string2 = [NSString stringWithFormat:@"%@ ₽", [numberFormatter stringForObjectValue:[numberFormatter numberFromString:resultfin]]];
        _priceric.text = [string2 stringByReplacingOccurrencesOfString: @ "," withString: @ " "];
        if ([_priceric.text isEqualToString:@"0 ₽"]) {
            _zakaz.hidden = YES;
            _priceric.text = @"-";
        }
    } else {
        _zakaz.hidden = YES;
        _priceric.text = @"-";
    }
    
    [self.aboutCell reloadData];
    [userDefaults synchronize];
}

- (void)reloadData
{
    if (!_detail) {
        self.navigationItem.title = @" ";
        self.screenIpad.hidden = NO;
        _addPlus.enabled = NO;
        _addEdit.hidden = YES;
        return;
    } else {
        _addPlus.enabled = YES;
        _addEdit.hidden = NO;
    }
    self.navigationItem.title = _detail.rating;
    self.titleLabel.text = _detail.title;
    _serial = _detail.serial;
    self.screenIpad.hidden = YES;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        selectedSegmentImage.image = [UIImage imageNamed:_detail.imageName1];
        self.detailImage1.image = [UIImage imageNamed:_detail.imageName2];
    }
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    _dataZakaz = [[userDefaults arrayForKey:Diccoins3] mutableCopy];
    [userDefaults synchronize];
    
    if (!_dataZakaz|(_dataZakaz.count == 0)) {
        //[_basketImage setImage:[UIImage imageNamed:@"basketEmpty.png"] forState:UIControlStateNormal];
        _basketImage.image = [UIImage imageNamed:@"basketEmpty.png"];
    } else {
        //[_basketImage setImage:[UIImage imageNamed:@"basketFull.png"] forState:UIControlStateNormal];
        _basketImage.image = [UIImage imageNamed:@"basketFull.png"];
    }
    
    if ([_dataZakaz containsObject:_detail.id]) {
        [_zakaz setTitle:@"Добавлено" forState:UIControlStateNormal];
        _zakaz.enabled = NO;
    } else {
        [_zakaz setTitle:@"В корзину" forState:UIControlStateNormal];
        _zakaz.enabled = YES;
        _numberCoinAdd.text=[NSString stringWithFormat:@"%g",_addPcs.value];
        _numberCoinAdd2.text=[NSString stringWithFormat:@"%g",_addPcs2.value];
        _pcs3 = [NSNumber numberWithDouble:_addPcs.value];
        _pcs3_1 = [NSNumber numberWithDouble:_addPcs2.value];
    }
    _addPcs2.enabled = NO;
    _numberCoinAdd2.enabled = NO;
    _addPcs2.hidden = YES;
    _numberCoinAdd2.hidden = YES;
    _labelMmd.hidden = YES;
    _labelSpmd.hidden = YES;
    //if ([_detail.dvor isEqual: @"ММД и СПМД"]|[_detail.dvor isEqual: @"ММД и СПМД (ЛМД)"]) {
    if ([_detail.id isEqual: @"5111-0178"]|[_detail.id isEqual: @"5111-0033"]) {
        _addPcs2.enabled = YES;
        _numberCoinAdd2.enabled = YES;
        _addPcs2.hidden = NO;
        _numberCoinAdd2.hidden = NO;
        _addPcs.translatesAutoresizingMaskIntoConstraints = YES;
        _numberCoinAdd.translatesAutoresizingMaskIntoConstraints = YES;
        _addPcs.frame = CGRectMake(136, 10, 94, 29);
        _numberCoinAdd.frame = CGRectMake(75, 9, 35, 30);
        _labelMmd.hidden = NO;
        _labelSpmd.hidden = NO;
    }
}

- (void) refreshScreen
{
    if (self.triggerView.selectedSegmentIndex == 0) {
        selectedSegmentImage.image = [UIImage imageNamed:_detail.imageName2];
    }else{
        selectedSegmentImage.image = [UIImage imageNamed:_detail.imageName1];
    }
}

- (IBAction)triggerView:(UISegmentedControl *)sender {
    [self refreshScreen];
}

- (IBAction)history:(id)sender {
}

- (IBAction)addBasket:(id)sender {
    _basketAddAlert.hidden = NO;

}

- (IBAction)addPcs:(id)sender {
    _numberCoinAdd.text=[NSString stringWithFormat:@"%g",_addPcs.value];
    _pcs3 = [NSNumber numberWithDouble:[(UIStepper *)sender value]];
}

- (IBAction)addPcs2:(id)sender {
    _numberCoinAdd2.text=[NSString stringWithFormat:@"%g",_addPcs2.value];
    _pcs3_1 = [NSNumber numberWithDouble:[(UIStepper *)sender value]];
}

- (IBAction)cancelAdd:(id)sender {
    _basketAddAlert.hidden = YES;
}

- (IBAction)addAdd:(id)sender {
    
    if ([_dataZakaz containsObject:_detail.id]) {
        nil;
    } else {
        [_dataZakaz addObject:_detail.id];
    }
    
    NSString *key = [NSString stringWithFormat: @"%@",_detail.id];
    NSString *keyNew = [NSString stringWithFormat: @"%@-1",_detail.id];

    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    if ([_pcs3 intValue] > 0 | [_pcs3_1 intValue] > 0) {
        [userDefaults setObject:_dataZakaz forKey:Diccoins3];
        if ([_pcs3 intValue] > 0) {
            [userDefaults setObject:_pcs3 forKey:key];
        }
        if ([_pcs3_1 intValue] > 0) {
            [userDefaults setObject:_pcs3_1 forKey:keyNew];
        }
        [userDefaults synchronize];

        [[NSNotificationCenter defaultCenter] postNotificationName:Diccoins3 object:nil];
    }
    
    [_zakaz setTitle:@"Добавлено" forState:UIControlStateNormal];
    _zakaz.enabled = NO;
    _basketAddAlert.hidden = YES;
    [self reloadData];
    //NSLog(@"%@",_dataZakaz);
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}

-(void)pushButtonClicked:(id)sender
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    if ([_detail.serial  isEqual: @"1000-летие единения мордовского народа"]) {
        [userDefaults setInteger:1 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"1000-летие основания Казани"]) {
        [userDefaults setInteger:2 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"1000-летие России"]) {
        [userDefaults setInteger:3 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"100-летие единения России и Тувы"]) {
        [userDefaults setInteger:4 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"100-е музея искусства народов Востока"]) {
        [userDefaults setInteger:5 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"100-е образования Республики Башкортостан"]) {
        [userDefaults setInteger:6 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"100-е основания музея-усадьбы «Архангельское»"]) {
        [userDefaults setInteger:7 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"100-летие Российского футбола"]) {
        [userDefaults setInteger:8 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"100-е со дня образования Службы внешней разведки РФ"]) {
        [userDefaults setInteger:9 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"100-летие эмиссионного закона Витте"]) {
        [userDefaults setInteger:10 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"1150-летие зарождения российской государственности"]) {
        [userDefaults setInteger:11 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"1150-летие основания города Смоленска"]) {
        [userDefaults setInteger:12 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"150-летие Банка России"]) {
        [userDefaults setInteger:13 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"150-летие начала эпохи Великих реформ"]) {
        [userDefaults setInteger:14 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"150-летие со дня рождения А.П. Чехова"]) {
        [userDefaults setInteger:15 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"160-летие Банка России"]) {
        [userDefaults setInteger:16 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"1-я и 2-я Камчатская экспедиция"]) {
        [userDefaults setInteger:17 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"2000-летие основания г. Дербента"]) {
        [userDefaults setInteger:18 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"200 лет основания Экспедиции заготовления государственных бумаг"]) {
        [userDefaults setInteger:19 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"200-летие образования министерств"]) {
        [userDefaults setInteger:20 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"200-летие победы ОВ 1812 года"]) {
        [userDefaults setInteger:21 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"200-летие со дня рождения М.Ю. Лермонтова"]) {
        [userDefaults setInteger:22 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"200-летие со дня рождения Н.В. Гоголя"]) {
        [userDefaults setInteger:23 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"200-летие со дня рождения Пушкина"]) {
        [userDefaults setInteger:24 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"200-е со дня рождения И.С. Тургенева"]) {
        [userDefaults setInteger:25 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"20-летие принятия Конституции РФ"]) {
        [userDefaults setInteger:26 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"250-летие Генерального штаба Вооруженных сил РФ"]) {
        [userDefaults setInteger:27 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"250-летие основания Государственного Эрмитажа"]) {
        [userDefaults setInteger:28 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"300-летие основания Санкт-Петербурга"]) {
        [userDefaults setInteger:29 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"300-летие Полтавской битвы"]) {
        [userDefaults setInteger:30 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"300-летие Российского флота"]) {
        [userDefaults setInteger:31 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"300-летие Российского флота (набор)"]) {
        [userDefaults setInteger:32 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"300 лет полиции России"]) {
        [userDefaults setInteger:33 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"400-летие народного ополчения Козьмы Минина и Дмитрия Пожарского"]) {
        [userDefaults setInteger:34 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"50 лет Великой Победы (набор)"]) {
        [userDefaults setInteger:35 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"50-летие Победы в ВОВ"]) {
        [userDefaults setInteger:36 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"55-я годовщина Победы в ВОВ"]) {
        [userDefaults setInteger:37 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"60-я годовщина Победы в ВОВ"]) {
        [userDefaults setInteger:38 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"625-летие Куликовской битвы"]) {
        [userDefaults setInteger:39 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"65-я годовщина Победы в ВОВ"]) {
        [userDefaults setInteger:40 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"700-летие со дня рождения Сергия Радонежского"]) {
        [userDefaults setInteger:41 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"70-летие Победы в ВОВ"]) {
        [userDefaults setInteger:42 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"70-летие разгрома немецко-фашистских войск в Сталинградской битве"]) {
        [userDefaults setInteger:43 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"75-е Победы советского народа в ВОВ 1941–1945"]) {
        [userDefaults setInteger:44 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"75-е полного освобождения Ленинграда"]) {
        [userDefaults setInteger:45 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"850-летие основания Москвы"]) {
        [userDefaults setInteger:46 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"90-летие «Динамо»"]) {
        [userDefaults setInteger:47 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"XXIX Летние Олимпийские Игры (г. Пекин)"]) {
        [userDefaults setInteger:48 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Алмазный фонд России"]) {
        [userDefaults setInteger:49 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Андрей Рублев"]) {
        [userDefaults setInteger:50 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Архитектурные шедевры России"]) {
        [userDefaults setInteger:51 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Барк «Крузенштерн»"]) {
        [userDefaults setInteger:52 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Вклад России в сокровище мировой культуры"]) {
        [userDefaults setInteger:53 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Вооруженные Силы РФ"]) {
        [userDefaults setInteger:54 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Выдающиеся личности России"]) {
        [userDefaults setInteger:55 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Выдающиеся полководцы России"]) {
        [userDefaults setInteger:56 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Выдающиеся спортсмены России"]) {
        [userDefaults setInteger:57 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Герои ВОВ 1941–1945 гг."]) {
        [userDefaults setInteger:58 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Города, освобожденные советскими войсками от немецко-фашистских захватчиков"]) {
        [userDefaults setInteger:59 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Города воинской славы"]) {
        [userDefaults setInteger:60 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Города трудовой доблести"]) {
        [userDefaults setInteger:61 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Дзюдо"]) {
        [userDefaults setInteger:62 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Дионисий"]) {
        [userDefaults setInteger:63 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Древние города России"]) {
        [userDefaults setInteger:64 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Животный мир стран ЕврАзЭС"]) {
        [userDefaults setInteger:65 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Зимние виды спорта"]) {
        [userDefaults setInteger:66 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Зимние Олимпийские игры 1998 года"]) {
        [userDefaults setInteger:67 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Знаки зодиака"]) {
        [userDefaults setInteger:68 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Золотое кольцо"]) {
        [userDefaults setInteger:69 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Инвестиционная монета"]) {
        [userDefaults setInteger:70 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Исследование Русской Арктики"]) {
        [userDefaults setInteger:71 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Исторические события"]) {
        [userDefaults setInteger:72 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"История денежного обращения России"]) {
        [userDefaults setInteger:73 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"История русского военно-морского флота"]) {
        [userDefaults setInteger:74 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"История русской авиации"]) {
        [userDefaults setInteger:75 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"К 300-летию добровольного вхождения Хакасии в РФ"]) {
        [userDefaults setInteger:76 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"К 350-летию добровольного вхождения Бурятии в состав РФ"]) {
        [userDefaults setInteger:77 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"К 400-летию добровольного вхождения калмыцкого народа в состав РФ"]) {
        [userDefaults setInteger:78 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"К 450-летию добровольного вхождения Башкирии в РФ"]) {
        [userDefaults setInteger:79 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"К 450-летию добровольного вхождения Удмуртии в РФ"]) {
        [userDefaults setInteger:80 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Красная книга"]) {
        [userDefaults setInteger:81 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Космос"]) {
        [userDefaults setInteger:82 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Кубок мира по спортивной ходьбе"]) {
        [userDefaults setInteger:83 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Легенды и сказки народов России"]) {
        [userDefaults setInteger:84 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Легенды и сказки стран ЕврАзЭС"]) {
        [userDefaults setInteger:85 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Лунный календарь"]) {
        [userDefaults setInteger:86 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Международная монетная программа стран ЕврАзЭС"]) {
        [userDefaults setInteger:87 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"На страже Отечества"]) {
        [userDefaults setInteger:88 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Окно в Европу"]) {
        [userDefaults setInteger:89 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Олимпийский век России"]) {
        [userDefaults setInteger:90 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Оружие Великой Победы (конструкторы оружия)"]) {
        [userDefaults setInteger:91 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Освоение и исследование Сибири, XVI-XVII вв."]) {
        [userDefaults setInteger:92 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Памятники архитектуры России"]) {
        [userDefaults setInteger:93 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Победa в ВОВ 1941-1945"]) {
        [userDefaults setInteger:94 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Первая русская антарктическая экспедиция"]) {
        [userDefaults setInteger:95 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Первое русское кругосветное путешествие"]) {
        [userDefaults setInteger:96 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Подвиг советских воинов, Крым, ВОВ 1941-1945 гг."]) {
        [userDefaults setInteger:97 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Полководцы и герои ОВ 1812 года"]) {
        [userDefaults setInteger:98 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Российская Федерация"]) {
        [userDefaults setInteger:99 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Российская (советская) мультипликация"]) {
        [userDefaults setInteger:100 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Россия во всемирном наследии ЮНЕСКО"]) {
        [userDefaults setInteger:101 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Россия на рубеже тысячелетий"]) {
        [userDefaults setInteger:102 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Русские исследователи Центральной Азии"]) {
        [userDefaults setInteger:103 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Русский балет"]) {
        [userDefaults setInteger:104 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Самбо"]) {
        [userDefaults setInteger:105 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Сбербанк 170 лет"]) {
        [userDefaults setInteger:106 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Символы России"]) {
        [userDefaults setInteger:107 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Сокровищница мировой культуры"]) {
        [userDefaults setInteger:108 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Сохраним наш мир"]) {
        [userDefaults setInteger:109 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Сочи 2014"]) {
        [userDefaults setInteger:110 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Спорт"]) {
        [userDefaults setInteger:111 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Сражения и знаменательные события 1812 года"]) {
        [userDefaults setInteger:112 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Столицы стран - членов ЕврАзЭС"]) {
        [userDefaults setInteger:113 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Феофан Грек"]) {
        [userDefaults setInteger:114 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Универсиада 2013 года в Казани"]) {
        [userDefaults setInteger:115 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Человек труда"]) {
        [userDefaults setInteger:116 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Чемпионат мира по футболу FIFA 2018 в России"]) {
        [userDefaults setInteger:117 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Экспедиции Г.И. Невельского на Дальний Восток"]) {
        [userDefaults setInteger:118 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Эпоха просвещения. XVIII век"]) {
        [userDefaults setInteger:119 forKey:Serial];
    }
    if ([_detail.serial  isEqual: @"Ювелирное искусство в России"]) {
        [userDefaults setInteger:120 forKey:Serial];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:Serial object:nil];
}

#pragma mark - AboutCell

- (void)didSelectSection:(UIButton*)sender {
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (int i=0; i<1; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:sender.tag]];
    }
    BOOL isOpen = [[_isOp objectAtIndex:sender.tag] boolValue];
    
    _isOp[sender.tag]=[NSNumber numberWithBool:!isOpen];
    if (isOpen) {
        [self.aboutCell2 deleteRowsAtIndexPaths:indexPaths withRowAnimation:NO];
        scrollView.contentSize = CGSizeMake(320.0f, 600.0f);
    } else {
        [self.aboutCell2 insertRowsAtIndexPaths:indexPaths withRowAnimation:NO];
        scrollView.contentSize = CGSizeMake(320.0f, 300.0f + _aboutCell.frame.size.height);
    }
    NSString *arrowName = isOpen? @"arrowDown.png":@"arrowUp.png";
    [sender setImage:[UIImage imageNamed:arrowName] forState:UIControlStateNormal];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aboutCell
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == _aboutCell)
        return @"Описание";
    else
        return [_titleSection objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)aboutCell numberOfRowsInSection:(NSInteger)section
{
    if (aboutCell == _aboutCell) {
    return 1;
        
    } else {
      if ([[_isOp objectAtIndex:section] boolValue]) {
          if (section == 0) {
              return 1;
          }
      }
    return 0;
    }
}

- (UIView *)tableView:(UITableView *)aboutCell viewForHeaderInSection:(NSInteger)section
{
    if (aboutCell == _aboutCell) {
        return nil;
        } else {
            NSString *sectionTitle = [_titleSection objectAtIndex:section];
            BOOL isOpen = [[_isOp objectAtIndex:section] boolValue];
            NSString *arrowName = isOpen? @"arrowUp":@"arrowDown";
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0.0f, 0.0f, 300.0f, 25.0f);
            button.tag = section;
            button.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.035];
            [button setTitleColor:[UIColor labelColor] forState:UIControlStateNormal];
            [button setTitle:sectionTitle forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont boldSystemFontOfSize:16.f]];
            [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            [button addTarget:self action:@selector(didSelectSection:) forControlEvents:UIControlEventTouchUpInside];
            [button setImage:[UIImage imageNamed:arrowName] forState:UIControlStateNormal];
            [button setImageEdgeInsets:UIEdgeInsetsMake(0.0f, 110.0f, 0, 0)];
            return button;
    }
}

- (void)tableView:(UITableView *)aboutCell willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if (aboutCell == _aboutCell) {
    // Background color
    view.tintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.035];

    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor labelColor]];

    // Another way to set the background color
    // Note: does not preserve gradient effect of original header
    // header.contentView.backgroundColor = [UIColor blackColor];
    }
}

- (UITableViewCell *)tableView:(UITableView *)aboutCell cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    static NSString *const CellId = @"cell1";
    static NSString *const CellId2 = @"cell2";
        if (aboutCell == _aboutCell) {
    CRViewController *cell = [aboutCell dequeueReusableCellWithIdentifier:CellId];
    if (!cell) {
        cell = [[CRViewController alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId];
    }
    cell.dvor.text = _detail.dvor;
    cell.pcs.text = _detail.pcs;
    cell.quality.text = _detail.quality;

    if (_detail.price2 == nil) {
        if (_detail.price == nil) {
            cell.price.text = @" ";
        } else {
            NSString *string = [NSString stringWithFormat:@"%@ ₽ (Конрос, 01.2018)", [numberFormatter stringForObjectValue:_detail.price]];
            cell.price.text = [string stringByReplacingOccurrencesOfString: @ "," withString: @ " "];
        }
    } else {
        cell.price.text = [NSString stringWithFormat:@"%@ ₽(М), %@ ₽(СПб)", [_detail.price stringValue],[_detail.price2 stringValue]];
    }
            if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ){
                cell.still.text = _detail.still;
            }
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
                cell.still.text = _detail.still;
                cell.createdOn.text = _detail.createdOn;
                cell.id.text = _detail.id;
                cell.weightStill.text = _detail.weightStill;
                cell.gurt.text = _detail.gurt;
                _detail.text1 = [_detail.text1 stringByReplacingOccurrencesOfString:@"  " withString:@"\r\r"];
                cell.aboutText.text = _detail.text1;
                cell.creator.text = _detail.creator;
                cell.sculpter.text = _detail.sculptor;
                cell.diameter.text = _detail.diameter;
                cell.weight.text = _detail.weight;
                cell.diameter.text = _detail.diameter;
                if (_detail.diameter == nil) {
                    cell.diameter.text = _detail.length;
                    cell.diameter2.text = @"Длина / Ширина, мм";
                } else {
                    cell.diameter2.text = @"Диаметр, мм";
                }
            }
            cell.weight.text = _detail.weight;
            cell.diameter.text = _detail.diameter;
            if (_detail.diameter == nil) {
                cell.diameter.text = _detail.length;
                cell.diameter2.text = @"Длина / Ширина, мм";
            }
            cell.thickness.text = _detail.thickness;
            
            cell.serial.enabled = YES;
            if (_detail.serial == nil) {
                [cell.serial setTitle:@" " forState:normal];
                cell.serial.enabled = NO;
            }
            [cell.serial setTitle:_detail.serial forState:normal];

            [cell.serial addTarget:self action:@selector(pushButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    } else {
        CRViewController *cell = [aboutCell dequeueReusableCellWithIdentifier:CellId2];
        if (!cell) {
            cell = [[CRViewController alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId2];
        }
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ){
            CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
            CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
            if( screenHeight < screenWidth ){
                screenHeight = screenWidth;
            }
            if( screenHeight > 480 && screenHeight < 667 ){
                cell.sculpter.frame = CGRectMake(150.0f, 63.0f, 150.0f, 15.0f);
                cell.creator.frame = CGRectMake(150.0f, 48.0f, 150.0f, 15.0f);
                cell.gurt.frame = CGRectMake(150.0f, 78.0f, 150.0f, 15.0f);
                //NSLog(@"iPhone 5/5s");
            } else if ( screenHeight > 480 && screenHeight < 736 ){
                cell.sculpter.frame = CGRectMake(150.0f + 28, 63.0f, 170.0f, 15.0f);
                cell.creator.frame = CGRectMake(150.0f + 28, 48.0f, 170.0f, 15.0f);
                cell.gurt.frame = CGRectMake(150.0f + 28, 78.0f, 170.0f, 15.0f);
                //NSLog(@"iPhone 6");
            } else if ( screenHeight > 480 ){
                cell.sculpter.frame = CGRectMake(150.0f + 42, 63.0f, 185.0f, 15.0f);
                cell.creator.frame = CGRectMake(150.0f + 42, 48.0f, 185.0f, 15.0f);
                cell.gurt.frame = CGRectMake(150.0f + 42, 78.0f, 185.0f, 15.0f);
                //NSLog(@"iPhone 6 Plus");
            } else {
                cell.sculpter.frame = CGRectMake(150.0f, 63.0f, 150.0f, 15.0f);
                cell.creator.frame = CGRectMake(150.0f, 48.0f, 150.0f, 15.0f);
                cell.gurt.frame = CGRectMake(150.0f, 78.0f, 150.0f, 15.0f);
                //NSLog(@"iPhone 4/4s");
            }
        
        cell.sculpter.text = _detail.sculptor;
        cell.creator.text = _detail.creator;
        cell.gurt.text = _detail.gurt;

        }
        cell.createdOn.text = _detail.createdOn;
        cell.id.text = _detail.id;
        cell.weightStill.text = _detail.weightStill;
        cell.gurt.text = _detail.gurt;
        _detail.text1 = [_detail.text1 stringByReplacingOccurrencesOfString:@"  " withString:@"\r\r"];
        cell.aboutText.text = _detail.text1;
        _aboutCell.contentSize = cell.aboutText.contentSize;

    return cell;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"master"]){
        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setValue:0 forKey:Nominal];
        [userDefaults setValue:0 forKey:Year];;
    } else {
        CRData *item = _detail;
        [segue.destinationViewController setDetail:item];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setValue:0 forKey:Nominal];
        [userDefaults setValue:0 forKey:Year];;
    }
}

@end
