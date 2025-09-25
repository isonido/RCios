//
//  CRLeftViewController.m
//  Монеты России
//
//  Created by Andrey Androsov on 17.02.14.
//  Copyright (c) 2014 Andrey Sonido. All rights reserved.
//

#import "CRLeftViewController.h"
#import "SWRevealViewController.h"
#import "CRMasterViewController.h"
#import "CRData.h"

@interface CRLeftViewController ()

@end

static NSString* Sort = @"sorting";
static NSString* Nominal = @"nominal";
static NSString* Year = @"year";
static NSString* Dvor = @"dvor";
static NSString* Still = @"still";
static NSString* Serial = @"serial";

@implementation CRLeftViewController

@synthesize nominalPickerView;
@synthesize serialPickerView;
@synthesize dataNominal;
@synthesize dataYear;
@synthesize dataSerial;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [nominalPickerView selectRow:[userDefaults integerForKey:Nominal] inComponent:1 animated:NO];
    [nominalPickerView selectRow:[userDefaults integerForKey:Year] inComponent:0 animated:NO];
    [serialPickerView selectRow:[userDefaults integerForKey:Serial] inComponent:0 animated:NO];
    
    [self.revealViewController.frontViewController.view setUserInteractionEnabled:NO];
    [self.revealViewController.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.revealViewController.frontViewController.view setUserInteractionEnabled:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadSettings];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadSettings) name:Serial object:nil];
    
    self.dataSerial = [NSArray arrayWithObjects:@"Все",
                       @"1000-летие единения мордовского народа", // - 1
                       @"1000-летие основания Казани", // - 2
                       @"1000-летие России", // - 3
                       @"100-летие единения России и Тувы", // - 4
                       @"100-е музея искусства народов Востока", // - 5
                       @"100-е образования Республики Башкортостан", // - 6
                       @"100-е основания музея-усадьбы «Архангельское»", // - 7
                       @"100-летие Российского футбола", // - 8
                       @"100-е со дня образования Службы внешней разведки РФ", // - 9
                       @"100-летие эмиссионного закона Витте", // - 10
                       @"1150-летие зарождения рос. государственности", // - 11
                       @"1150-летие основания города Смоленска", // - 12
                       @"150-летие Банка России", // - 13
                       @"150-летие начала эпохи Великих реформ", // - 14
                       @"150-летие со дня рождения А.П. Чехова", // - 15
                       @"160-летие Банка России", // - 16
                       @"1-я и 2-я Камчатская экспедиция", // - 17
                       @"2000-летие основания г. Дербента", // - 18
                       @"200 лет основания Экспедиции заготовления государственных бумаг", // - 19
                       @"200-летие образования министерств", // - 20
                       @"200-летие победы ОВ 1812 года", // - 21
                       @"200-летие со дня рождения М.Ю. Лермонтова", // - 22
                       @"200-летие со дня рождения Н.В. Гоголя", // - 23
                       @"200-летие со дня рождения Пушкина", // - 24
                       @"200-е со дня рождения И.С. Тургенева", // - 25
                       @"20-летие принятия Конституции РФ", // - 26
                       @"250-летие Генерального штаба Вооруженных сил РФ", // - 27
                       @"250-летие основания Государственного Эрмитажа", // - 28
                       @"300-летие основания Санкт-Петербурга", // - 29
                       @"300-летие Полтавской битвы", // - 30
                       @"300-летие Российского флота", // - 31
                       @"300-летие Российского флота (набор)", // - 32
                       @"300 лет полиции России", // - 33
                       @"400-летие народного ополчения Козьмы Минина и Дмитрия Пожарского", // - 34
                       @"50 лет Великой Победы (набор)", // - 35
                       @"50-летие Победы в ВОВ", // - 36
                       @"55-я годовщина Победы в ВОВ", // - 37
                       @"60-я годовщина Победы в ВОВ", // - 38
                       @"625-летие Куликовской битвы", // - 39
                       @"65-я годовщина Победы в ВОВ", // - 40
                       @"700-летие со дня рождения Сергия Радонежского", // - 41
                       @"70-летие Победы в ВОВ", // - 42
                       @"70-летие разгрома немецко-фашистских войск в Сталинградской битве", // - 43
                       @"75-е Победы советского народа в ВОВ 1941–1945", // - 44
                       @"75-е полного освобождения Ленинграда", // - 45
                       @"850-летие основания Москвы", // - 46
                       @"90-летие «Динамо»", // - 47
                       @"XXIX Летние Олимпийские Игры (г. Пекин)", // - 48
                       @"Алмазный фонд России", // - 49
                       @"Андрей Рублев", // - 50
                       @"Архитектурные шедевры России", // - 51
                       @"Барк «Крузенштерн»", // - 52
                       @"Вклад России в сокров. мировой культуры", // - 53
                       @"Вооруженные Силы РФ", // - 54
                       @"Выдающиеся личности России", // - 55
                       @"Выдающиеся полководцы России", // - 56
                       @"Выдающиеся спортсмены России", // - 57
                       @"Герои ВОВ 1941–1945 гг.", //-58
                       @"Города", //-59
                       @"Города, освобожденные советскими войсками от немецко-фашистских захватчиков", // - 60
                       @"Города воинской славы", // - 61
                       @"Города трудовой доблести", // - 62
                       @"Дзюдо", // - 63
                       @"Дионисий", // - 64
                       @"Древние города России", // - 65
                       @"Животный мир стран ЕврАзЭС", // - 66
                       @"Зимние виды спорта", // - 67
                       @"Зимние Олимпийские игры 1998 года", // - 68
                       @"Знаки зодиака", // - 69
                       @"Золотое кольцо", // - 70
                       @"Инвестиционная монета", // - 71
                       @"Исследование Русской Арктики", // - 72
                       @"Исторические события", // - 73
                       @"История денежного обращения России", // - 74
                       @"История русского военно-морского флота", // - 75
                       @"История русской авиации", // - 76
                       @"К 300-летию добровольного вхождения Хакасии в РФ", // - 77
                       @"К 350-летию добровольного вхождения Бурятии в состав РФ", // - 78
                       @"К 400-летию добровольного вхождения калмыцкого народа в состав РФ", // - 79
                       @"К 450-летию добровольного вхождения Башкирии в РФ", // - 80
                       @"К 450-летию добровольного вхождения Удмуртии в РФ", // - 81
                       @"Красная книга", // - 82
                       @"Космос", // - 83
                       @"Кубок мира по спортивной ходьбе", // - 84
                       @"Легенды и сказки народов России", // - 85
                       @"Легенды и сказки стран ЕврАзЭС", // - 86
                       @"Лунный календарь", // - 87
                       @"Международная монетная программа стран ЕврАзЭС", // - 88
                       @"На страже Отечества", // - 89
                       @"Окно в Европу", // - 90
                       @"Олимпийский век России", // - 91
                       @"Оружие Великой Победы (конструкторы оружия)", // - 92
                       @"Освоение и исследование Сибири, XVI-XVII вв.", // - 93
                       @"Памятники архитектуры России", // - 94
                       @"Победa в ВОВ 1941-1945 гг.", // - 95
                       @"Первая русская антарктическая экспедиция", // - 96
                       @"Первое русское кругосветное путешествие", // - 97
                       @"Подвиг советских воинов, Крым, ВОВ 1941-1945 гг.", // - 98
                       @"Полководцы и герои ОВ 1812 года", // - 99
                       @"Российская Федерация", // - 100
                       @"Российская (советская) мультипликация", // - 101
                       @"Российский спорт", // - 102
                       @"Россия во всемирном наследии ЮНЕСКО", // - 103
                       @"Россия на рубеже тысячелетий", // - 104
                       @"Русские исследователи Центральной Азии", // - 105
                       @"Русский балет", // - 106
                       @"Самбо", // - 107
                       @"Сбербанк 170 лет", // - 108
                       @"Символы России", // - 109
                       @"Сокровищница мировой культуры", // - 110
                       @"Сохраним наш мир", // - 111
                       @"Сочи 2014", // - 112
                       @"Спорт", // - 113
                       @"Сражения и знам. события ОВ 1812 года", // - 114
                       @"Столицы стран - членов ЕврАзЭС", // - 115
                       @"Феофан Грек", // - 116
                       @"Универсиада 2013 года в г. Казани", // - 117
                       @"Человек труда", // - 118
                       @"Чемпионат мира по футболу FIFA 2018 в России",// - 119
                       @"Экспедиции Г.И. Невельского на Дальний Восток", // - 120
                       @"Эпоха просвещения. XVIII век", // - 121
                       @"Юбилей Победы советского народа в ВОВ 1941–1945 гг.", // - 122
                       @"Ювелирное искусство в России", // - 123
                       nil];
    [self updateStillSegment];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - save and load

- (void) loadSettings {
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    self.katSegmentControl.selectedSegmentIndex = [userDefaults integerForKey:Sort];
    self.dvorSegmentControl.selectedSegmentIndex = [userDefaults integerForKey:Dvor];
    self.stillSegmentControl.selectedSegmentIndex = [userDefaults integerForKey:Still];
    
    _rowSerial = [userDefaults integerForKey:Serial];
    if (_rowSerial == 0) {
        _stillSegmentControl.enabled = YES;
        self.dataNominal = [NSArray arrayWithObjects:
                            @"Все",@"1 рубль",@"2 рубля",@"3 рубля",@"5 рублей",@"10 рублей",@"20 рублей",
                            @"25 рублей",@"50 рублей",@"100 рублей",@"150 рублей",@"200 рублей",@"500 рублей",
                            @"1000 рублей",@"10 000 рублей",@"25 000 рублей",@"50 000 рублей", nil];
        
        self.dataYear = [NSArray arrayWithObjects:@"Все",@"2025",@"2024",@"2023",@"2022",@"2021",@"2020",@"2019",@"2018",@"2017",@"2016",@"2015",
                         @"2014",@"2013",@"2012",@"2011",@"2010",@"2009",@"2008",@"2007",
                         @"2006",@"2005",@"2004",@"2003",@"2002",@"2001",@"2000",@"1999",
                         @"1998",@"1997",@"1996",@"1995",@"1994",@"1993",@"1992",@"1976", nil];
    }
    if (_rowSerial == 1) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2012", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 2) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2005", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 3) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"Все",@"1996",@"1995", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 4) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2014", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 5) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2018", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 6) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2019", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 7) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2019", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 8) {
        self.dataNominal = [NSArray arrayWithObjects:@"1 рубль", nil];
        self.dataYear = [NSArray arrayWithObjects:@"1997", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 9) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2020", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 10) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"1997", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 11) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2012", nil];
        _stillSegmentControl.enabled = YES;
    }
    if (_rowSerial == 12) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 13) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2010", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 14) {
        self.dataNominal = [NSArray arrayWithObjects:@"1000 рублей", nil];
        self.dataYear = [NSArray arrayWithObjects:@"Все",@"2014",@"2011",nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 15) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2009", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 16) {
        self.dataNominal = [NSArray arrayWithObjects:@"3 рубля", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2020", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 17) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"Все",@"2004",@"2003", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 18) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2015", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 19) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2018", nil];
        _stillSegmentControl.enabled = YES;
    }
    if (_rowSerial == 20) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все",@"1 рубль",@"10 рублей",@"25 рублей", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2002", nil];
        _stillSegmentControl.enabled = YES;
    }
    if (_rowSerial == 21) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2012", nil];
        _stillSegmentControl.enabled = YES;
    }
    if (_rowSerial == 22) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2014", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 23) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2009", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 24) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"1999", nil];
        _stillSegmentControl.enabled = YES;
    }
    if (_rowSerial == 25) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2018", nil];
        _stillSegmentControl.enabled = YES;
    }
    if (_rowSerial == 26) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2013", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 27) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2013", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 28) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2014", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 29) {
        self.dataNominal = [NSArray arrayWithObjects:@"1 рубль", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2003", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 30) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2009", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 31) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"1996", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 32) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"1996", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 33) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2018", nil];
        _stillSegmentControl.enabled = YES;
    }
    if (_rowSerial == 34) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2012", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 35) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"1995", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 36) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все",@"2 рубля",@"3 рубля",@"100 рублей", nil];
        self.dataYear = [NSArray arrayWithObjects:@"Все",@"1995",@"1992", nil];
        _stillSegmentControl.enabled = YES;
    }
    if (_rowSerial == 37) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все",@"2 рубля",@"3 рубля",@"10 рублей",@"100 рублей", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2000", nil];
        _stillSegmentControl.enabled = YES;
    }
    if (_rowSerial == 38) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2005", nil];
        _stillSegmentControl.enabled = YES;
    }
    if (_rowSerial == 39) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2005", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 40) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все",@"3 рубля",@"10 рублей", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2010", nil];
        _stillSegmentControl.enabled = YES;
    }
    if (_rowSerial == 41) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2014", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 42) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"Все",@"2015",@"2014", nil];
        _stillSegmentControl.enabled = YES;
    }
    if (_rowSerial == 43) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2013", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 44) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"Все",@"2020",@"2019", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 45) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2019", nil];
        _stillSegmentControl.enabled = YES;
    }
    if (_rowSerial == 46) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"1997", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 47) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все",@"25 рублей",@"100 рублей",@"200 рублей",@"1000 рублей", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2013", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 48) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2008", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 49) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все",@"3 рубля",@"25 рублей", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2022",@"2018",@"2016", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 50) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2007", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 51) {
        self.dataNominal = [NSArray arrayWithObjects:@"25 рублей", nil];
        self.dataYear = [NSArray arrayWithObjects:@"Все",@"2015",@"2014",@"2013",@"2012", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 52) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"1997", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 53) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"Все",@"1994",@"1993", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 54) {
        self.dataNominal = [NSArray arrayWithObjects:@"1 рубль", nil];
        self.dataYear = [NSArray arrayWithObjects:@"Все",@"2024",@"2021",@"2019",@"2017",@"2015",@"2011",@"2010",@"2009",@"2007",@"2006",@"2005", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 55) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все",@"1 рубль",@"2 рубля", nil];
        self.dataYear = [NSArray arrayWithObjects:@"Все",@"2025",@"2024",@"2023",@"2022",@"2021",@"2020",@"2019",@"2018",@"2017",@"2016",@"2015",@"2014",@"2013",@"2012",@"2011",@"2010",@"2009",
                         @"2008",@"2007",@"2006",@"2005",@"2004",@"2003",@"2002",@"2001",@"2000",@"1999",@"1998",
                         @"1997",@"1996",@"1995",@"1994",@"1993", nil];
        _stillSegmentControl.enabled = YES;
    }
    if (_rowSerial == 56) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все",@"3 рубля",@"25 рублей",@"50 рублей", nil];
        self.dataYear = [NSArray arrayWithObjects:@"Все",@"2013",@"2000", nil];
        _stillSegmentControl.enabled = YES;
    }
    if (_rowSerial == 57) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все",@"2 рубля",@"3 рубля", nil];
        self.dataYear = [NSArray arrayWithObjects:@"Все",@"2014",@"2013",@"2012",@"2010",@"2009", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 58) {
        self.dataNominal = [NSArray arrayWithObjects:@"2 рубля", nil];
        self.dataYear = [NSArray arrayWithObjects:@"Все",@"2025",@"2022", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 59) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все",@"3 рубля",@"50 рублей",@"100 рублей", nil];
        self.dataYear = [NSArray arrayWithObjects:@"Все",@"2025",@"2024",@"2023",@"2022",@"2021", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 60) {
        self.dataNominal = [NSArray arrayWithObjects:@"5 рублей", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2016", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 61) {
        self.dataNominal = [NSArray arrayWithObjects:@"10 рублей", nil];
        self.dataYear = [NSArray arrayWithObjects:@"Все",@"2016",@"2015",@"2014",@"2013",@"2012",@"2011", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 62) {
        self.dataNominal = [NSArray arrayWithObjects:@"10 рублей", nil];
        self.dataYear = [NSArray arrayWithObjects:@"Все",@"2025",@"2024",@"2023",@"2022",@"2021", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 63) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2014", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 64) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2002", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 65) {
        self.dataNominal = [NSArray arrayWithObjects:@"10 рублей", nil];
        self.dataYear = [NSArray arrayWithObjects:@"Все",@"2024",@"2023",@"2022",@"2020",@"2019",@"2018",@"2017",@"2016",@"2014",@"2012",@"2011",@"2010",@"2009",@"2008",@"2007",
                         @"2006",@"2005",@"2004",@"2003",@"2002", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 66) {
        self.dataNominal = [NSArray arrayWithObjects:@"3 рубля", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2009", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 67) {
        self.dataNominal = [NSArray arrayWithObjects:@"200 рублей", nil];
        self.dataYear = [NSArray arrayWithObjects:@"Все",@"2010",@"2009", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 68) {
        self.dataNominal = [NSArray arrayWithObjects:@"1 рубль", nil];
        self.dataYear = [NSArray arrayWithObjects:@"1997", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 69) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все",@"2 рубля",@"3 рубля",@"25 рублей",@"50 рублей", nil];
        self.dataYear = [NSArray arrayWithObjects:@"Все",@"2005",@"2004",@"2003",@"2002", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 70) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все",@"5 рублей",@"100 рублей", nil];
        self.dataYear = [NSArray arrayWithObjects:@"Все",@"2008",@"2006",@"2004", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 71) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все",@"3 рубля",@"10 рублей",@"25 рублей",@"50 рублей",@"100 рублей",@"200 рублей", nil];
        self.dataYear = [NSArray arrayWithObjects:@"Все",@"2025",@"2024",@"2023",@"2022",@"2021",@"2020",@"2019",@"2018",@"2017",@"2016",@"2015",@"2014",@"2013",@"2010",@"2009",@"2008",@"2007",@"2006",@"1995",@"1976", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 72) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"1995", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 73) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"Все",@"2025",@"2024",@"2023",@"2022",@"2021", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 74) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2009", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 75) {
        self.dataNominal = [NSArray arrayWithObjects:@"1000 рублей", nil];
        self.dataYear = [NSArray arrayWithObjects:@"Все",@"2012",@"2010", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 76) {
        self.dataNominal = [NSArray arrayWithObjects:@"1 рубль", nil];
        self.dataYear = [NSArray arrayWithObjects:@"Все",@"2016",@"2014",@"2013",@"2012",@"2011",@"2010", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 77) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2007", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 78) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2011", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 79) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2009", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 80) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2007", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 81) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2008", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 82) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все",@"1 рубль",@"2 рубля",@"10 рублей",@"50 рублей", nil];
        self.dataYear = [NSArray arrayWithObjects:@"Все",@"2024",@"2019",@"2016",@"2014",@"2012",@"2010",@"2008",@"2007",@"2006",@"2005",@"2004",
                         @"2003",@"2002",@"2001",@"2000",@"1999",@"1998",@"1997",@"1996",@"1995",@"1994",@"1993",@"1992", nil];
        _stillSegmentControl.enabled = YES;
    }
    if (_rowSerial == 83) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2023",@"2022",@"2021", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 84) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2008", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 85) {
        self.dataNominal = [NSArray arrayWithObjects:@"3 рубля", nil];
        self.dataYear = [NSArray arrayWithObjects:@"Все",@"2022",@"2020",@"2019",@"2017", nil];
        _stillSegmentControl.enabled = YES;
    }
    if (_rowSerial == 86) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2009", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 87) {
        self.dataNominal = [NSArray arrayWithObjects:@"3 рубля", nil];
        self.dataYear = [NSArray arrayWithObjects:@"Все",@"2013",@"2012",@"2011",@"2010",@"2009",@"2008",@"2007",@"2006",@"2005",@"2004",@"2003", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 88) {
        self.dataNominal = [NSArray arrayWithObjects:@"3 рубля", nil];
        self.dataYear = [NSArray arrayWithObjects:@"Все",@"2012",@"2011",@"2010", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 89) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2018", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 90) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2003", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 91) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"1993", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 92) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"Все",@"2020",@"2019", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    
    if (_rowSerial == 93) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2001", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 94) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все",@"3 рубля",@"25 рублей", nil];
        self.dataYear = [NSArray arrayWithObjects:@"Все",@"2024",@"2023",@"2022",@"2021",@"2020",@"2019",@"2018",@"2017",@"2016",@"2015",@"2014",@"2013",@"2012",@"2011",@"2010",@"2009",@"2008",@"2007",@"2006",@"2005",@"2004",@"2003",@"2002",@"2000",@"1999",@"1998",@"1997",
                         @"1996",@"1995",@"1994",@"1993", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 95) {
        self.dataNominal = [NSArray arrayWithObjects:@"3 рубля", nil];
        self.dataYear = [NSArray arrayWithObjects:@"1994", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 96) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"1994", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 97) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"1993", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 98) {
        self.dataNominal = [NSArray arrayWithObjects:@"5 рублей", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2015", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 99) {
        self.dataNominal = [NSArray arrayWithObjects:@"2 рубля", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2012", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 100) {
        self.dataNominal = [NSArray arrayWithObjects:@"10 рублей", nil];
        self.dataYear = [NSArray arrayWithObjects:@"Все",@"2025",@"2024",@"2023",@"2022",@"2021",@"2019",@"2018",@"2016",@"2014",@"2013",@"2011",@"2010",@"2009",@"2008",@"2007",@"2006",@"2005", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 101) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все",@"3 рубля",@"25 рублей", nil];
        self.dataYear = [NSArray arrayWithObjects:@"Все",@"2024",@"2023",@"2022",@"2021",@"2020",@"2019",@"2018",@"2017", nil];
        _stillSegmentControl.enabled = YES;
    }
    if (_rowSerial == 102) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все",@"1 рубль",@"3 рубля",@"25 рублей", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2025",@"2024",@"2023", nil];
        _stillSegmentControl.enabled = YES;
    }
    if (_rowSerial == 103) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все",@"3 рубля",@"25 рублей",@"50 рублей",@"100 рублей",@"200 рублей",@"1000 рублей",@"10 000 рублей", nil];
        self.dataYear = [NSArray arrayWithObjects:@"Все",@"2016",@"2010",@"2009",@"2008",@"2006", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 104) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2000", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 105) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"1999", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 106) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все",@"3 рубля",@"5 рублей",@"10 рублей",@"25 рублей",@"50 рублей",@"100 рублей",@"150 рублей", nil];
        self.dataYear = [NSArray arrayWithObjects:@"Все",@"1999",@"1997",@"1996",@"1995",@"1994",@"1993", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 107) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2013", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 108) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"Все",@"2012",@"2011", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 109) {
        self.dataNominal = [NSArray arrayWithObjects:@"3 рубля", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2015", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 110) {
        self.dataNominal = [NSArray arrayWithObjects:@"25 рублей", nil];
        self.dataYear = [NSArray arrayWithObjects:@"Все",@"2018",@"2016",@"2015",@"2013", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 111) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все",@"3 рубля",@"25 рублей",@"50 рублей",@"100 рублей",@"200 рублей",@"10 000 рублей", nil];
        self.dataYear = [NSArray arrayWithObjects:@"Все",@"2023",@"2020",@"2015",@"2011",@"2008",@"2004",@"2000",@"1997",@"1996",@"1995",@"1994",@"1993", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 112) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все",@"3 рубля",@"25 рублей",@"50 рублей",@"100 рублей",@"200 рублей",@"1000 рублей",@"10 000 рублей",@"25 000 рублей", nil];
        self.dataYear = [NSArray arrayWithObjects:@"Все",@"2013",@"2012",@"2011", nil];
        _stillSegmentControl.enabled = YES;
    }
    if (_rowSerial == 113) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все",@"3 рубля",@"50 рублей", nil];
        self.dataYear = [NSArray arrayWithObjects:@"Все",@"2006",@"2005",@"2004", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 114) {
        self.dataNominal = [NSArray arrayWithObjects:@"5 рублей", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2012", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 115) {
        self.dataNominal = [NSArray arrayWithObjects:@"3 рубля", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2008", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 116) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2004", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 117) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2013", nil];
        _stillSegmentControl.enabled = YES;
    }
    if (_rowSerial == 118) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2024",@"2023",@"2022",@"2021",@"2020", nil];
        _stillSegmentControl.enabled = YES;
    }
    if (_rowSerial == 119) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все",@"3 рубля",@"25 рублей",@"50 рублей", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2017", nil];
        _stillSegmentControl.enabled = YES;
    }
    if (_rowSerial == 120) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2013", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 121) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"1992", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 122) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"2025", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
    if (_rowSerial == 123) {
        self.dataNominal = [NSArray arrayWithObjects:@"Все", nil];
        self.dataYear = [NSArray arrayWithObjects:@"Все",@"2024",@"2019",@"2016", nil];
        _stillSegmentControl.selectedSegmentIndex = 0;
        _stillSegmentControl.enabled = NO;
        [userDefaults setInteger:0 forKey:Still];
        [self updateStillSegment];
    }
        [nominalPickerView reloadAllComponents];
}

#pragma mark - Actions

- (IBAction)katSegmentControl:(UISegmentedControl *)sender {
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:self.katSegmentControl.selectedSegmentIndex forKey:Sort];
    [userDefaults synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:Sort object:nil];
}

- (IBAction)dvorSegmentControl:(UISegmentedControl *)sender {
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:self.dvorSegmentControl.selectedSegmentIndex forKey:Dvor];
    [userDefaults synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:Dvor object:nil];
}

- (IBAction)stillSegmentControl:(id)sender {
    [self updateStillSegment];
    if (self.stillSegmentControl.numberOfSegments == 5) {
        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setInteger:self.stillSegmentControl.selectedSegmentIndex forKey:Still];
        [userDefaults synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:Still object:nil];
    } else {
        if (self.stillSegmentControl.selectedSegmentIndex == 2) {
            NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setInteger:4 forKey:Still];
            [userDefaults synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:Still object:nil];
        } else {
            NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setInteger:self.stillSegmentControl.selectedSegmentIndex forKey:Still];
            [userDefaults synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:Still object:nil];
        }
    }
}

- (void) updateStillSegment {
    if (self.stillSegmentControl.selectedSegmentIndex == 0) {
        [_stillSegmentControl setWidth:95.0f forSegmentAtIndex:1];
        _boarderView.hidden = YES;
        if (self.stillSegmentControl.numberOfSegments == 5) {
            [_stillSegmentControl removeSegmentAtIndex:2 animated:YES];
            [_stillSegmentControl removeSegmentAtIndex:2 animated:YES];
        }
    }
    if (self.stillSegmentControl.selectedSegmentIndex == 1) {
        [_stillSegmentControl setWidth:50.0f forSegmentAtIndex:1];
        _boarderView.hidden = NO;
        if (self.stillSegmentControl.numberOfSegments == 3) {
            [_stillSegmentControl insertSegmentWithTitle:@"Au" atIndex:2 animated:YES];
            [_stillSegmentControl insertSegmentWithTitle:@"Ag" atIndex:3 animated:YES];
        }
    }
    if (self.stillSegmentControl.selectedSegmentIndex == 2) {
        if (self.stillSegmentControl.numberOfSegments == 3) {
            [_stillSegmentControl setWidth:95.0f forSegmentAtIndex:1];
            _boarderView.hidden = YES;
        } else {
            [_stillSegmentControl setWidth:50.0f forSegmentAtIndex:1];
            _boarderView.hidden = NO;
        }
    }
    if (self.stillSegmentControl.selectedSegmentIndex == 3) {
        [_stillSegmentControl setWidth:50.0f forSegmentAtIndex:1];
        _boarderView.hidden = NO;
    }
    if (self.stillSegmentControl.selectedSegmentIndex == 4) {
        [_stillSegmentControl setWidth:50.0f forSegmentAtIndex:1];
        _boarderView.hidden = NO;
    }
}

- (IBAction)cancel:(id)sender {
    [_stillSegmentControl setWidth:95.0f forSegmentAtIndex:1];
    _boarderView.hidden = YES;
    if (self.stillSegmentControl.numberOfSegments == 5) {
        [_stillSegmentControl removeSegmentAtIndex:2 animated:YES];
        [_stillSegmentControl removeSegmentAtIndex:2 animated:YES];
    }
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:0 forKey:Still];
    [userDefaults setInteger:0 forKey:Dvor];
    [userDefaults setInteger:0 forKey:Sort];
    [userDefaults setInteger:0 forKey:Nominal];
    [userDefaults setInteger:0 forKey:Year];
    [userDefaults setInteger:0 forKey:Serial];
    [userDefaults synchronize];
    
    [self loadSettings];
    [nominalPickerView selectRow:[userDefaults integerForKey:Nominal] inComponent:1 animated:NO];
    [nominalPickerView selectRow:[userDefaults integerForKey:Year] inComponent:0 animated:NO];
    [serialPickerView selectRow:[userDefaults integerForKey:Serial] inComponent:0 animated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:Serial object:nil];
}

- (IBAction)online:(id)sender {
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://ricgold.com"]];
    
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:@"http://ricgold.com"];
    [application openURL:URL options:@{} completionHandler:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect frame = self.viewCancel.frame;
    frame.origin.y = scrollView.contentOffset.y + scrollView.frame.size.height-_viewCancel.frame.size.height;
    if (scrollView.contentSize.height > scrollView.frame.size.height){
        self.viewCancel.frame = frame;
        [scrollView bringSubviewToFront:self.viewCancel];
    } else {
        nil;
    }
}

#pragma mark - PickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if([pickerView isEqual: nominalPickerView]){
        return 2;
    } else {
        return 1;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if([pickerView isEqual: nominalPickerView]){
        if(component == 1) {
            return dataNominal.count;
        }else{
            return dataYear.count;
        }
    } else {
        return dataSerial.count;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    if([pickerView isEqual: nominalPickerView]){
        UILabel *pickerLabel = (UILabel *)view;
        if (pickerLabel == nil) {
            pickerLabel = [[UILabel alloc] init];
            [pickerLabel setTextAlignment:NSTextAlignmentCenter];
            [pickerLabel setFont:[UIFont systemFontOfSize:18]];
        }
            if(component == 1) {
                [pickerLabel setText:[dataNominal objectAtIndex:row]];
            }else{
                [pickerLabel setText:[dataYear objectAtIndex:row]];
            }
        return pickerLabel;
    } else {
        UILabel *pickerLabel2 = (UILabel *)view;
        if (pickerLabel2 == nil) {
            pickerLabel2 = [[UILabel alloc] init];
            [pickerLabel2 setTextAlignment:NSTextAlignmentCenter];
            [pickerLabel2 setFont:[UIFont systemFontOfSize:14]];
        }
            [pickerLabel2 setText:[dataSerial objectAtIndex:row]];
        return pickerLabel2;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if([pickerView isEqual: nominalPickerView]){
        if(component == 1) {
            NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setInteger:row forKey:Nominal];
            [userDefaults synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:Nominal object:nil];
        } else {
            NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setInteger:row forKey:Year];
            [userDefaults synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:Year object:nil];
        }
    } else {
        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setInteger:row forKey:Serial];
        
        [userDefaults setValue:0 forKey:Nominal];
        [userDefaults setValue:0 forKey:Year];
        [nominalPickerView selectRow:[userDefaults integerForKey:Nominal] inComponent:1 animated:NO];
        [nominalPickerView selectRow:[userDefaults integerForKey:Year] inComponent:0 animated:NO];
        [userDefaults synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:Serial object:nil];
    }
}

@end
