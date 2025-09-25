//
//  CRMasterViewController.m
//  Монеты России
//
//  Created by Andrey Androsov on 14.01.14.
//  Copyright (c) 2014 Andrey Sonido. All rights reserved.
//

#import "CRMasterViewController.h"
#import "CRCoinCell.h"
#import "CRData.h"
#import "CRDetailViewController.h"
#import "SWRevealViewController.h"
#import "CRLeftViewController.h"
#import "CRStatisticController.h"
#import "MxMovingPlaceholderTextField.h"
#import <MediaPlayer/MediaPlayer.h>
#import "XCDYouTubeKit.h"

@interface CRMasterViewController ()

@property(nonatomic, strong) UIAlertView *banner;
@property(nonatomic) NSUInteger logoutTimeRemaining;
@property (nonatomic, strong) UISearchController *searchController;
@end

static NSString* Sort = @"sorting";
static NSString* Nominal = @"nominal";
static NSString* Year = @"year";
static NSString* Dvor = @"dvor";
static NSString* Still = @"still";
static NSString* Serial = @"serial";
static NSString* Diccoins = @"diccoins";
static NSString* Diccoins2 = @"diccoins2";
static NSString* Diccoins3 = @"diccoins3";
static NSString* UpdateIpad = @"update";
static NSString* Arrow = @"arrow";

NSURLConnection *connection1;
NSURLConnection *connection2;
NSURLConnection *connection3;
NSXMLParser *rssParser;
NSXMLParser *rssParser2;
NSXMLParser *rssParser3;

@implementation CRMasterViewController

@synthesize button;
@synthesize rssData;
@synthesize rssData2;
@synthesize rssData3;
@synthesize news;
@synthesize news2;
@synthesize newsSale;
@synthesize newsNew;
@synthesize currentElement;
@synthesize article;
@synthesize cb_number;
@synthesize price;
@synthesize price_replace;
@synthesize searchController;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    _sideBarButtom.target = self.revealViewController;
    _sideBarButtom.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    _kat = [userDefaults integerForKey:Sort];
    _dvor = [userDefaults integerForKey:Dvor];
    _nom = [userDefaults integerForKey:Nominal];
    _year = [userDefaults integerForKey:Year];
    _still = [userDefaults integerForKey:Still];
    _rowSerial = [userDefaults integerForKey:Serial];
    _dataUser = [[[NSUserDefaults standardUserDefaults] arrayForKey:Diccoins] mutableCopy];
    _dataZakaz = [[[NSUserDefaults standardUserDefaults] arrayForKey:Diccoins3] mutableCopy];
    _arrow = [userDefaults integerForKey:Arrow];
    [userDefaults synchronize];
    
    NSDictionary *barButtonAppearanceDict = @{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:14.0]};
    [_rightbutton setTitleTextAttributes:barButtonAppearanceDict forState:UIControlStateNormal];
    
    NSUbiquitousKeyValueStore* cloudUser = [NSUbiquitousKeyValueStore defaultStore];
    _dataUser2 = [[cloudUser arrayForKey:@"AVAILABLE_NOTES"] mutableCopy];
    [cloudUser synchronize];
    
    if (_dataUser == _dataUser2) {
        nil;
    } else {
        id token = [[NSFileManager defaultManager] ubiquityIdentityToken];
        if (token == nil)
        {
            nil;
            // iCloud is not available for this app
        } else {
            NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:_dataUser2 forKey:Diccoins];
            [userDefaults synchronize];
            [self.tableView reloadData];
        }
    }
    
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    searchController.definesPresentationContext = true;
    
    [self.tableView setTableHeaderView:self.searchController.searchBar];
    self.definesPresentationContext = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadSettings) name:Sort object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadSettings) name:Dvor object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadSettings) name:Nominal object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadSettings) name:Year object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadSettings) name:Still object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadSettings) name:Serial object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadSettings) name:Diccoins object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadSettings) name:Diccoins3 object:nil];
    
    arrayData = [[NSArray alloc] initWithArray:[NSArray arrayWithObjects:@"Каталог",@"Моя коллекция",@"Статистика",@"Магазин",@"Перейти на сайт",@"Контакты",nil]];
    arrayInvest = [[NSArray alloc] initWithArray:[NSArray arrayWithObjects:@"5216-0060",@"5216-0060-1",@"5216-0060-2",@"5216-0060-4",@"5111-0178",
                                                  @"3213-0003",@"5111-0033",@"5217-0038",@"5216-0080",@"5217-0041",@"5216-0095",@"5217-0040",@"5216-0089",nil]];
    
    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ){
        NSLog(@"This iPhone up");
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        if( screenHeight < screenWidth ){
            screenHeight = screenWidth;
        }
        if( screenHeight > 480 && screenHeight < 667 ){
            dropDownView = [[DropDownView alloc] initWithArrayData:arrayData cellHeight:40 heightTableView:240 paddingTop:32 paddingLeft:60 paddingRight:132 refView:button animation:BOTH openAnimationDuration:0 closeAnimationDuration:0];
            dropDownView.delegate = self;
            NSLog(@"iPhone 5/5s");
        } else if ( screenHeight > 480 && screenHeight < 736 ){
            if (@available(iOS 11, *)) {
                dropDownView = [[DropDownView alloc] initWithArrayData:arrayData cellHeight:40 heightTableView:240 paddingTop:32 paddingLeft:20 paddingRight:227 refView:button animation:BOTH openAnimationDuration:0
                                                closeAnimationDuration:0];
            } else {
                dropDownView = [[DropDownView alloc] initWithArrayData:arrayData cellHeight:40 heightTableView:240 paddingTop:32 paddingLeft:90 paddingRight:187 refView:button animation:BOTH openAnimationDuration:0
                                                closeAnimationDuration:0];
            }
            dropDownView.delegate = self;
            NSLog(@"iPhone 8");
        } else if ( screenHeight > 480 ){
            dropDownView = [[DropDownView alloc] initWithArrayData:arrayData cellHeight:40 heightTableView:240 paddingTop:80 paddingLeft:0 paddingRight:320 refView:button animation:BOTH openAnimationDuration:0 closeAnimationDuration:0];
            dropDownView.delegate = self;
            NSLog(@"iPhone 8 Plus");
        } else {
            dropDownView = [[DropDownView alloc] initWithArrayData:arrayData cellHeight:40 heightTableView:240 paddingTop:32 paddingLeft:60 paddingRight:132 refView:button animation:BOTH openAnimationDuration:0 closeAnimationDuration:0];
            dropDownView.delegate = self;
            NSLog(@"iPhone 4/4s");
        }
    } else {
        dropDownView = [[DropDownView alloc] initWithArrayData:arrayData cellHeight:40 heightTableView:240 paddingTop:32 paddingLeft:20 paddingRight:190 refView:button animation:BOTH openAnimationDuration:0 closeAnimationDuration:0];
        dropDownView.delegate = self;
        NSLog(@"This iPhone down2");
    }
    
    [self.navigationController.view addSubview:dropDownView.view];
    [button setTitle:[arrayData objectAtIndex:0] forState:UIControlStateNormal];
    _dropdown = 0;
    [button setImage:[UIImage imageNamed:@"arrowDown.png"] forState:UIControlStateNormal];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    
    self.detailViewController = (CRDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    //[self dataChange];
    //[self firstLoad];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSURL *url = [NSURL URLWithString:@"https://www.ricgold.com/_xml"];
    
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:url
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    
    connection1=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://www.ricgold.com/_xml"]];
    [request setHTTPMethod:@"GET"];
    [request addValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"text/plain" forHTTPHeaderField:@"Accept"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        NSData * responseData = [requestReply dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        NSLog(@"requestReply: %@", responseData);
        self.rssData = [NSMutableData data];
        self.rssData = [NSMutableData dataWithData:responseData];
    }] resume];
    
    self.rssData2 = [NSMutableData data];
    self.rssData3 = [NSMutableData data];
    
    if (!_dataZakaz|(_dataZakaz.count == 0)) {
        [_basketImage setImage:[UIImage imageNamed:@"basketEmpty.png"] forState:UIControlStateNormal];
    } else {
        [_basketImage setImage:[UIImage imageNamed:@"basketFull.png"] forState:UIControlStateNormal];
    }
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone )
        {
            CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
            CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
            if( screenHeight < screenWidth )
            {
                screenHeight = screenWidth;
            }
            
            CGRect myImageRect = CGRectMake(0.0f, 0.0f, screenWidth, screenHeight);
            _myImage = [[UIImageView alloc] initWithFrame:myImageRect];
            _myImage.image = [UIImage imageNamed:@"fonInfo6plus.png"];
            [self.navigationController.view addSubview:_myImage];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
            _myImage.userInteractionEnabled = YES;
            [_myImage addGestureRecognizer:tap];
        }
    }
    _whatsup.hidden = NO;
    _telRic.text = @"  8-926-306-7474, 8-985-344-2627";
    _emailRic.text = @"www.ricgold.com@yandex.ru";
    
    [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(updateLabel:) userInfo:nil repeats:YES];
    //[NSTimer scheduledTimerWithTimeInterval:60*60.0f target:self selector:@selector(refresh:) userInfo:nil repeats:YES];
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(refresh:) userInfo:nil repeats:NO];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"LaunchedCoins"]) {
        [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(displayAlert:) userInfo:nil repeats:NO];
    }
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"LaunchedBannerNew"]) {
        [NSTimer scheduledTimerWithTimeInterval:2*60*60 target:self selector:@selector(bannernew:) userInfo:nil repeats:NO];
    }
    
    [self dataChange];
    [self firstLoad];
}

- (void)displayAlert:(NSTimer *) timer {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1200, 200)];
    UIImage *wonImage = [UIImage imageNamed:@"coinsban-1.png"];
    imageView.contentMode=UIViewContentModeScaleAspectFit;
    [imageView setImage:wonImage];
    UIAlertView *subAlert = [[UIAlertView alloc] initWithTitle:@"Я знаю о магазине www.ricgold.com"
                                                       message:@"Реальные цены покупки и продажи"
                                                      delegate:self
                                             cancelButtonTitle:@"Позже"
                                             otherButtonTitles:@"Перейти", nil];
    subAlert.alertViewStyle = UIAlertViewStyleDefault;
    [subAlert setValue:imageView forKey:@"accessoryView"];
    
    [subAlert show];
}

- (void)updatePrise:(NSTimer *) timer {
    //[self refresh:(id)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) updateEmail:(id)sender {
    _emailRic.text = @"инвестиционных монет";
}

- (void) updateLabel:(id)sender {
    if ([_telRic.text  isEqual: @"  8-926-306-7474, 8-985-344-2627"]) {
        _whatsup.hidden = YES;
        _telRic.text = @"Большой ассортимент";
        _emailRic.text = @"памятных и ";
        [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(updateEmail:) userInfo:nil repeats:NO];
    } else if ([_telRic.text  isEqual: @"Большой ассортимент"]) {
        _whatsup.hidden = YES;
        _telRic.text = @"Выкупим Ваши монеты";
        _emailRic.text = @"за наличные";
    } else {
        if (_arrow == 0) {
            _whatsup.hidden = NO;
        } else {
            _whatsup.hidden = YES;
        }
        _telRic.text = @"  8-926-306-7474, 8-985-344-2627";
        _emailRic.text = @"www.ricgold.com@yandex.ru";
    }    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (connection == connection1) {
        //[rssData appendData:data];
    } else if (connection == connection2) {
        [rssData2 appendData:data];
    } else if (connection == connection3) {
        [rssData3 appendData:data];
    }
    _haveInet = 1;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (connection == connection1) {
        NSString *result = [[NSString alloc] initWithData:rssData encoding:NSUTF8StringEncoding];
        
        NSLog(@"data%@",rssData);
        NSLog(@"result%@",result);
        
        self.news = [NSMutableArray array];
        self.news2 = [NSMutableArray array];
        rssParser = [[NSXMLParser alloc] initWithData:rssData];
        rssParser.delegate = self;
        [rssParser parse];
    } else if (connection == connection2) {
        self.newsSale = [NSMutableArray array];
        rssParser2 = [[NSXMLParser alloc] initWithData:rssData2];
        rssParser2.delegate = self;
        [rssParser2 parse];
    }else if (connection == connection3) {
        self.newsNew = [NSMutableArray array];
        rssParser3 = [[NSXMLParser alloc] initWithData:rssData3];
        rssParser3.delegate = self;
        [rssParser3 parse];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    //NSLog(@"%@", error);
    _haveInet = 0;
    news = [[[NSUserDefaults standardUserDefaults] arrayForKey:Diccoins2] mutableCopy];
    for(int i = 0; i<[arrayInvest count]; i ++) {
        NSPredicate* noinvest = [NSPredicate predicateWithFormat:@"article CONTAINS[cd] %@", [arrayInvest objectAtIndex:i]];
        NSArray *ainvest = [news filteredArrayUsingPredicate:noinvest];
        if (ainvest > 0) {
            [news removeObjectsInArray:ainvest];
        }
    }
    [self.tableView reloadData];
}

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict  {
    if (parser == rssParser) {
        self.currentElement = elementName;
        if ([elementName isEqualToString:@"item"]) {
            self.article = [NSMutableString string];
            self.cb_number = [NSMutableString string];
            self.price = [NSMutableString string];
            self.price_replace = [NSMutableString string];
        }
    } else if (parser == rssParser2) {
        self.currentElement = elementName;
        if ([elementName isEqualToString:@"item"]) {
            self.article = [NSMutableString string];
        }
    } else if (parser == rssParser3) {
        self.currentElement = elementName;
        if ([elementName isEqualToString:@"item"]) {
            self.article = [NSMutableString string];
        }
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (parser == rssParser) {
        if ([currentElement isEqualToString:@"article"]) {
            [article appendString:string];
        } else if ([currentElement isEqualToString:@"cb_number"]) {
            [cb_number appendString:string];
        } else if ([currentElement isEqualToString:@"price"]) {
            [price appendString:string];
        } else if ([currentElement isEqualToString:@"price_replace"]) {
            [price_replace appendString:string];
        }
    } else if (parser == rssParser2) {
        if ([currentElement isEqualToString:@"article"]) {
            [article appendString:string];
        }
    } else if (parser == rssParser3) {
        if ([currentElement isEqualToString:@"article"]) {
            [article appendString:string];
        }
    }
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
    if (parser == rssParser) {
        if ([elementName isEqualToString:@"item"]) {
            NSDictionary *newsItem = [NSDictionary dictionaryWithObjectsAndKeys:
                                  article, @"article",
                                  cb_number, @"cb_number",
                                  price, @"price",
                                  price_replace, @"price_replace", nil];
            NSDictionary *newsItem2 = [NSDictionary dictionaryWithObjectsAndKeys:
                                  article, @"article", nil];
            [news addObject:newsItem];
            [news2 addObject:newsItem2];
        }
    } else if (parser == rssParser2) {
        if ([elementName isEqualToString:@"item"]) {
            NSDictionary *newsItem3 = [NSDictionary dictionaryWithObjectsAndKeys:
                                      article, @"article", nil];
            [newsSale addObject:newsItem3];
        }
    } else if (parser == rssParser3) {
        if ([elementName isEqualToString:@"item"]) {
            NSDictionary *newsItem4 = [NSDictionary dictionaryWithObjectsAndKeys:
                                       article, @"article", nil];
            [newsNew addObject:newsItem4];
        }
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:news forKey:Diccoins2];
    //NSLog(@"%@",news2);
    if (parser == rssParser) {
        for(int i = 0; i<[news2 count]; i ++) {
            NSDictionary *newsItem = [news2 objectAtIndex:i];
            NSMutableString *secondString = [NSMutableString stringWithFormat:@"%@", [newsItem objectForKey:@"article"]];
            [secondString replaceOccurrencesOfString:@"\n\t\t\t\t\t" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, secondString.length)];
            [news2 replaceObjectAtIndex:i withObject:secondString];
        }
        //NSLog(@"%@",news2);
    } else if (parser == rssParser2) {
        for(int i = 0; i<[newsSale count]; i ++) {
            NSDictionary *newsItem2 = [newsSale objectAtIndex:i];
            NSMutableString *secondString2 = [NSMutableString stringWithFormat:@"%@", [newsItem2 objectForKey:@"article"]];
            [secondString2 replaceOccurrencesOfString:@"\n\t\t\t\t\n\t\t\t\t\n\t\t\t\t" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, secondString2.length)];
            [secondString2 replaceOccurrencesOfString:@"\n\t\t\t\t\n\t\t\t\t" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, secondString2.length)];
            [newsSale replaceObjectAtIndex:i withObject:secondString2];
            //NSLog(@"%@",newsSale);
        }
    } else if (parser == rssParser3) {
        for(int i = 0; i<[newsNew count]; i ++) {
            NSDictionary *newsItem3 = [newsNew objectAtIndex:i];
            NSMutableString *secondString3 = [NSMutableString stringWithFormat:@"%@", [newsItem3 objectForKey:@"article"]];
            [secondString3 replaceOccurrencesOfString:@"\n\t\t\t\t\n\t\t\t\t\n\t\t\t\t" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, secondString3.length)];
            [secondString3 replaceOccurrencesOfString:@"\n\t\t\t\t\n\t\t\t\t" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, secondString3.length)];
            [newsNew replaceObjectAtIndex:i withObject:secondString3];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:Diccoins2 object:nil];
    [self.tableView reloadData];
}

- (void)firstLoad
{
    if (@available(iOS 11, *)) {
        [self.tableView setContentOffset:CGPointMake(0, 64 - self.tableView.contentInset.top)];
    } else {
        [self.tableView setContentOffset:CGPointMake(0, 44 - self.tableView.contentInset.top)];
    }
    
    _myDate = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"myDateKey"];
    if (_myDate == 0) {
        _myDate = [NSDate date];
        [[NSUserDefaults standardUserDefaults] setObject:_myDate forKey:@"myDateKey"];
    }
}

- (void)bannernew:(NSTimer *) timer {
    CGRect rect = [[UIScreen mainScreen] bounds];
    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ){
        UIImage *bgImage = [UIImage imageNamed:@"ban_1125x2436.png"];
        _backgroundImageView = [[UIImageView alloc] initWithImage:bgImage];
    } else {
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        
        if (orientation == UIInterfaceOrientationLandscapeLeft|orientation == UIInterfaceOrientationLandscapeRight) {
            UIImage *bgImage = [UIImage imageNamed:@"ban_2048x2752.png"];
            _backgroundImageView = [[UIImageView alloc] initWithImage:bgImage];
        }
    }
    
    [_backgroundImageView setFrame:rect];
    [self.navigationController.view addSubview:_backgroundImageView];
    
    _x = [UIButton buttonWithType:UIButtonTypeCustom];
    _x.frame = CGRectMake(0.0f, 20.0f, 90.0f, 24.0f);
    [_x setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    _x.backgroundColor = [UIColor redColor];
    [_x setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_x setTitle:@"Х закрыть" forState:UIControlStateNormal];
    [_x addTarget:self action:@selector(xSelectSection) forControlEvents:UIControlEventTouchUpInside];
    //[_x setImage:[UIImage imageNamed:@"labelric.png"] forState:UIControlStateNormal];
    [self.navigationController.view addSubview:_x];
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    _iknow = [UIButton buttonWithType:UIButtonTypeCustom];
    _iknow.frame = CGRectMake(0.0f, screenHeight-140, 620.0f, 140.0f);
    [_iknow setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [_iknow addTarget:self action:@selector(iKnowSelectSection) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:_iknow];
    
}

- (void)xSelectSection {
    [_backgroundImageView removeFromSuperview];
    [_x removeFromSuperview];
    [_iknow removeFromSuperview];
}

- (void)iKnowSelectSection {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"LaunchedBannerNew"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [_backgroundImageView removeFromSuperview];
    [_x removeFromSuperview];
    [_iknow removeFromSuperview];
    
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://ricgold.com"]];
    
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:@"http://ricgold.com"];
    [application openURL:URL options:@{} completionHandler:nil];
}

- (void) moviePlayerPlaybackDidFinish:(NSNotification *)notification
{

}

- (void )imageTapped:(UITapGestureRecognizer *) gestureRecognizer
{
    _myImage.hidden = YES;
}

- (void)bannerView
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    _arrow = [userDefaults integerForKey:Arrow];
    if (_arrow == 0) {
        [_arrrow setImage:[UIImage imageNamed:@"arrowDown.png"] forState:UIControlStateNormal];
        _imageRic.hidden = NO;
        _telefon.hidden = NO;
        _emailRic.hidden = NO;
        _telRic.hidden = NO;
        _info.hidden = YES;
        _basketImage.hidden = NO;
        _fonBanner.hidden = NO;
        _stick.hidden = NO;
        if ([_telRic.text  isEqual: @"  8-926-306-7474, 8-985-344-2627"]) {
            _whatsup.hidden = NO;
        } else {
            _whatsup.hidden = YES;
        }
    } else {
        [_arrrow setImage:[UIImage imageNamed:@"arrowUp.png"] forState:UIControlStateNormal];
        _imageRic.hidden = YES;
        _telefon.hidden = YES;
        _emailRic.hidden = YES;
        _telRic.hidden = YES;
        _info.hidden = YES;
        _basketImage.hidden = YES;
        _fonBanner.hidden = YES;
        _stick.hidden = YES;
        _whatsup.hidden = YES;
    }
}

- (void)loadSettings
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    _kat = [userDefaults integerForKey:Sort];
    _dvor = [userDefaults integerForKey:Dvor];
    _nom = [userDefaults integerForKey:Nominal];
    _year = [userDefaults integerForKey:Year];
    _still = [userDefaults integerForKey:Still];
    _rowSerial = [userDefaults integerForKey:Serial];
    _dataUser = [[[NSUserDefaults standardUserDefaults] arrayForKey:Diccoins] mutableCopy];
    _dataZakaz = [[[NSUserDefaults standardUserDefaults] arrayForKey:Diccoins3] mutableCopy];
    [userDefaults synchronize];
    
    [self dataChange];
    [self.tableView reloadData];
    
    if (!_dataZakaz|(_dataZakaz.count == 0)) {
        [_basketImage setImage:[UIImage imageNamed:@"basketEmpty.png"] forState:UIControlStateNormal];
    } else {
        [_basketImage setImage:[UIImage imageNamed:@"basketFull.png"] forState:UIControlStateNormal];
    }
}

- (void)dataChange
{
    _titleSeries.hidden = NO;
    _pcsSeries.hidden = NO;
    _betabet = [[NSArray alloc]initWithObjects:@"1 рубль",@"2 рубля",@"3 рубля",@"5 рублей",@"10 рублей",@"20 рублей",
                @"25 рублей",@"50 рублей",@"100 рублей",@"150 рублей",@"200 рублей",@"500 рублей",@"1000 рублей",@"10000 рублей",
                @"25000 рублей",@"50000 рублей", nil];
    _gammabet1 = [[NSArray alloc]initWithObjects: @"15",@"25",@"35",@"50",@"75",nil];
    _gammabet2 = [[NSArray alloc]initWithObjects: @"100",@"120",@"150",@"155",@"170",@"200",@"250",@"300",nil];
    _gammabet3 = [[NSArray alloc]initWithObjects: @"500",@"600",@"650",@"700",@"750",@"850",@"900",nil];
    _gammabet4 = [[NSArray alloc]initWithObjects: @"1 000",@"1 200",@"1 250",@"1 400",@"1 480",@"1 500",@"1 750",@"2 000",@"2 500",@"2 700",@"3 000",@"3 500",
                  @"4 000",@"4 500",@"4 700",nil];
    _gammabet5 = [[NSArray alloc]initWithObjects: @"5 000",@"5 500",@"5 700",@"6 000",@"7 000",@"7 500",@"8 000",nil];
    _gammabet6 = [[NSArray alloc]initWithObjects: @"10 000",@"10 500",@"11 500",@"12 000",@"12 500",@"14 000",@"15 000",@"17 500",@"18 205",@"5 000/20 000",
                  @"20 000",@"22 000",@"24 000",@"25 000",@"27 000",@"30 000",@"35 000",@"40 000",@"45 000",@"50 000",@"57 500",@"100 000",@"125 000",
                  @"150 000",@"200 000",@"250 000",@"280 000",@"300 000",@"400 000",@"150 000/350 000",@"500 000",@"600 000/400 000",@"1 000 000",
                  @"1 950 000",@"2 000 000",@"2 300 000",@"5 000 000",@"6 565 000",@"9 300 000",@"9 750 000",@"10 000 000",@"19 750 000",@"20 000 000",
                  @"50 000 000",@"65 000 000",@"100 000 000",nil];
    
    if (_rowSerial == 0) {
        _data = [CRData fetchData];
        _alphabet = [[NSArray alloc]initWithObjects:@"2025",@"2024",@"2023",@"2022",@"2021",@"2020",@"2019",@"2018",@"2017",@"2016",@"2015",@"2014",@"2013",@"2012",@"2011",@"2010",@"2009",@"2008",@"2007",
                     @"2006",@"2005",@"2004",@"2003",@"2002",@"2001",@"2000",@"1999",
                     @"1998",@"1997",@"1996",@"1995",@"1994",@"1993",@"1992",@"1976",nil];
        
        _titleSeries.text = @"Все серии";
        _data2 = _data;
    }
    if (_rowSerial == 1) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == '1000-летие единения мордовского народа'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2012",nil];
        //_betabet = [[NSArray alloc]initWithObjects:@"3 рубля",@"50 рублей",@"100 рублей",nil];
        _titleSeries.text = @"1000-летие единения мордовского народа";
        _data2 = _data;
    }
    if (_rowSerial == 2) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == '1000-летие основания Казани'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2005",nil];
        _titleSeries.text = @"1000-летие основания Казани";
        _data2 = _data;
    }
    if (_rowSerial == 3) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == '1000-летие России'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"1996",@"1995",nil];
        _titleSeries.text = @"1000-летие России";
        _data2 = _data;
    }
    if (_rowSerial == 4) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == '100-летие единения России и Тувы'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2014",nil];
        _titleSeries.text = @"100-летие единения России и Тувы";
        _data2 = _data;
    }
    if (_rowSerial == 5) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == '100-е музея искусства народов Востока'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2018",nil];
        _titleSeries.text = @"100-е музея искусства народов Востока";
        _data2 = _data;
    }
    if (_rowSerial == 6) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == '100-е образования Республики Башкортостан'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2019",nil];
        _titleSeries.text = @"100-е образования Республики Башкортостан";
        _data2 = _data;
    }
    if (_rowSerial == 7) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == '100-е основания музея-усадьбы «Архангельское»'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2019",nil];
        _titleSeries.text = @"100-е основания музея-усадьбы «Архангельское»";
        _data2 = _data;
    }
    if (_rowSerial == 8) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == '100-летие Российского футбола'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"1997", nil];
        _betabet = [[NSArray alloc]initWithObjects:@"1 рубль", nil];
        _titleSeries.text = @"100-летие Российского футбола";
        _data2 = _data;
    }
    if (_rowSerial == 9) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == '100-е со дня образования Службы внешней разведки РФ'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2020",nil];
        _titleSeries.text = @"100-е со дня образования Службы внешней разведки РФ";
        _data2 = _data;
    }
    if (_rowSerial == 10) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == '100-летие эмиссионного закона Витте'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"1997", nil];
        _titleSeries.text = @"100-летие эмиссионного закона Витте";
        _data2 = _data;
    }
    if (_rowSerial == 11) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == '1150-летие зарождения российской государственности'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2012",nil];
        _titleSeries.text = @"1150-летие зарождения рос. государственности";
        _data2 = _data;
    }
    if (_rowSerial == 12) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == '1150-летие основания города Смоленска'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2013", nil];
        _titleSeries.text = @"1150-летие основания города Смоленска";
        _data2 = _data;
    }
    if (_rowSerial == 13) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == '150-летие Банка России'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2010", nil];
        _titleSeries.text = @"150-летие Банка России";
        _data2 = _data;
    }
    if (_rowSerial == 14) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == '150-летие начала эпохи Великих реформ'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2014",@"2011", nil];
        _betabet = [[NSArray alloc]initWithObjects:@"1000 рублей", nil];
        _titleSeries.text = @"150-летие начала эпохи Великих реформ";
        _data2 = _data;
    }
    if (_rowSerial == 15) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == '150-летие со дня рождения А.П. Чехова'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2009", nil];
        _titleSeries.text = @"150-летие со дня рождения А.П. Чехова";
        _data2 = _data;
    }
    if (_rowSerial == 16) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == '160-летие Банка России'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2020", nil];
        _betabet = [[NSArray alloc]initWithObjects:@"3 рубля", nil];
        _titleSeries.text = @"160-летие Банка России";
        _data2 = _data;
    }
    if (_rowSerial == 17) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == '1-я и 2-я Камчатская экспедиция'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2004",@"2003",nil];
        _titleSeries.text = @"1-я и 2-я Камчатская экспедиция";
        _data2 = _data;
    }
    if (_rowSerial == 18) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == '2000-летие основания г. Дербента'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2015", nil];
        _titleSeries.text = @"2000-летие основания г. Дербента";
        _data2 = _data;
    }
    if (_rowSerial == 19) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == '200 лет основания Экспедиции заготовления государственных бумаг'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2018",nil];
        _titleSeries.text = @"200 лет основания Экспедиции заготовления государственных бумаг";
        _data2 = _data;
    }
    if (_rowSerial == 20) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == '200-летие образования министерств'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2002",nil];
        _betabet = [[NSArray alloc]initWithObjects:@"1 рубль",@"10 рублей",@"25 рублей", nil];
        _titleSeries.text = @"200-летие образования министерств";
        _data2 = _data;
    }
    if (_rowSerial == 21) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == '200-летие победы ОВ 1812 года'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2012",nil];
        _titleSeries.text = @"200-летие победы ОВ 1812 года";
        _data2 = _data;
    }
    if (_rowSerial == 22) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == '200-летие со дня рождения М.Ю. Лермонтова'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2014", nil];
        _titleSeries.text = @"200-летие со дня рождения М.Ю. Лермонтова";
        _data2 = _data;
    }
    if (_rowSerial == 23) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == '200-летие со дня рождения Н.В. Гоголя'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2009", nil];
        _titleSeries.text = @"200-летие со дня рождения Н.В. Гоголя";
        _data2 = _data;
    }
    if (_rowSerial == 24) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == '200-летие со дня рождения Пушкина'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"1999",nil];
        _titleSeries.text = @"200-летие со дня рождения Пушкина";
        _data2 = _data;
    }
    if (_rowSerial == 25) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == '200-е со дня рождения И.С. Тургенева'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2018",nil];
        _titleSeries.text = @"200-е со дня рождения И.С. Тургенева";
        _data2 = _data;
    }
    if (_rowSerial == 26) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == '20-летие принятия Конституции РФ'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2013", nil];
        _titleSeries.text = @"20-летие принятия Конституции РФ";
        _data2 = _data;
    }
    if (_rowSerial == 27) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == '250-летие Генерального штаба Вооруженных сил РФ'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2013", nil];
        _titleSeries.text = @"250-летие Генерального штаба Вооруженных сил РФ";
        _data2 = _data;
    }
    if (_rowSerial == 28) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == '250-летие основания Государственного Эрмитажа'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2014", nil];
        _titleSeries.text = @"250-летие основания Государственного Эрмитажа";
        _data2 = _data;
    }
    if (_rowSerial == 29) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == '300-летие основания Санкт-Петербурга'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2003", nil];
        _betabet = [[NSArray alloc]initWithObjects:@"1 рубль", nil];
        _titleSeries.text = @"300-летие основания Санкт-Петербурга";
        _data2 = _data;
    }
    if (_rowSerial == 30) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == '300-летие Полтавской битвы'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2009", nil];
        _titleSeries.text = @"300-летие Полтавской битвы";
        _data2 = _data;
    }
    if (_rowSerial == 31) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == '300-летие Российского флота'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"1996",nil];
        _titleSeries.text = @"300-летие Российского флота";
        _data2 = _data;
    }
    if (_rowSerial == 32) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == '300-летие Российского флота (набор)'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"1996",nil];
        _titleSeries.text = @"300-летие Российского флота (набор)";
        _data2 = _data;
    }
    if (_rowSerial == 33) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == '300 лет полиции России'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2018",nil];
        _titleSeries.text = @"300 лет полиции России";
        _data2 = _data;
    }
    if (_rowSerial == 34) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == '400-летие народного ополчения Козьмы Минина и Дмитрия Пожарского'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2012",nil];
        _titleSeries.text = @"400-летие народного ополчения Козьмы Минина и Дмитрия Пожарского";
        _data2 = _data;
    }
    
    if (_rowSerial == 35) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == '50 лет Великой Победы (набор)'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"1995",nil];
        _titleSeries.text = @"50 лет Великой Победы (набор)";
        _data2 = _data;
    }
    if (_rowSerial == 36) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == '50-летие Победы в ВОВ'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"1995",@"1992",nil];
        _betabet = [[NSArray alloc]initWithObjects:@"2 рубля",@"3 рубля",@"100 рублей", nil];
        _titleSeries.text = @"50-летие Победы в ВОВ";
        _data2 = _data;
    }
    if (_rowSerial == 37) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == '55-я годовщина Победы в ВОВ'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2000",nil];
        _betabet = [[NSArray alloc]initWithObjects:@"2 рубля",@"3 рубля",@"10 рублей",@"100 рублей", nil];
        _titleSeries.text = @"55-я годовщина Победы в ВОВ";
        _data2 = _data;
    }
    if (_rowSerial == 38) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == '60-я годовщина Победы в ВОВ'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2005",nil];
        _titleSeries.text = @"60-я годовщина Победы в ВОВ";
        _data2 = _data;
    }
    if (_rowSerial == 39) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == '625-летие Куликовской битвы'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2005",nil];
        _titleSeries.text = @"625-летие Куликовской битвы";
        _data2 = _data;
    }
    if (_rowSerial == 40) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == '65-я годовщина Победы в ВОВ'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2010",nil];
        _betabet = [[NSArray alloc]initWithObjects:@"3 рубля",@"10 рублей", nil];
        _titleSeries.text = @"65-я годовщина Победы в ВОВ";
        _data2 = _data;
    }
    if (_rowSerial == 41) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == '700-летие со дня рождения Сергия Радонежского'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2014",nil];
        _titleSeries.text = @"700-летие со дня рождения Сергия Радонежского";
        _data2 = _data;
    }
    if (_rowSerial == 42) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == '70-летие Победы в ВОВ'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2015",@"2014",nil];
        _titleSeries.text = @"70-летие Победы в ВОВ";
        _data2 = _data;
    }
    if (_rowSerial == 43) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == '70-летие разгрома немецко-фашистских войск в Сталинградской битве'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2013",nil];
        _titleSeries.text = @"70-летие разгрома немецко-фашистских войск в Сталинградской битве";
        _data2 = _data;
    }
    if (_rowSerial == 44) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == '75-е Победы советского народа в ВОВ 1941–1945'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2020",@"2019",nil];
        _titleSeries.text = @"75-е Победы советского народа в ВОВ 1941–1945";
        _data2 = _data;
    }
    if (_rowSerial == 45) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == '75-е полного освобождения Ленинграда'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2019",nil];
        _titleSeries.text = @"75-е полного освобождения Ленинграда";
        _data2 = _data;
    }
    if (_rowSerial == 46) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == '850-летие основания Москвы'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"1997",nil];
        _titleSeries.text = @"850-летие основания Москвы";
        _data2 = _data;
    }
    if (_rowSerial == 47) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == '90-летие «Динамо»'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2013",nil];
        _betabet = [[NSArray alloc]initWithObjects:@"25 рублей",@"100 рублей",@"200 рублей",@"1000 рублей", nil];
        _titleSeries.text = @"90-летие «Динамо»";
        _data2 = _data;
    }
    if (_rowSerial == 48) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'XXIX Летние Олимпийские Игры (г. Пекин)'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2008",nil];
        _titleSeries.text = @"XXIX Летние Олимпийские Игры (г. Пекин)";
        _data2 = _data;
    }
    if (_rowSerial == 49) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Алмазный фонд России'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2022",@"2018",@"2016",nil];
        _betabet = [[NSArray alloc]initWithObjects:@"3 рубля",@"25 рублей", nil];
        _titleSeries.text = @"Алмазный фонд России";
        _data2 = _data;
    }
    if (_rowSerial == 50) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Андрей Рублев'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2007",nil];
        _titleSeries.text = @"Андрей Рублев";
        _data2 = _data;
    }
    if (_rowSerial == 51) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Архитектурные шедевры России'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2015",@"2014",@"2013",@"2012",nil];
        _titleSeries.text = @"Архитектурные шедевры России";
        _data2 = _data;
    }
    if (_rowSerial == 52) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Барк «Крузенштерн»'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"1997",nil];
        _titleSeries.text = @"Барк «Крузенштерн»";
        _data2 = _data;
    }
    if (_rowSerial == 53) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Вклад России в сокровище мировой культуры'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"1994",@"1993",nil];
        _titleSeries.text = @"Вклад России в сокров. мировой культуры";
        _data2 = _data;
    }
    if (_rowSerial == 54) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Вооруженные Силы РФ'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2024",@"2021",@"2019",@"2017",@"2015",@"2011",@"2010",@"2009",@"2007",@"2006",@"2005",nil];
        _titleSeries.text = @"Вооруженные Силы РФ";
        _data2 = _data;
    }
    if (_rowSerial == 55) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Выдающиеся личности России'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2025",@"2024",@"2023",@"2022",@"2021",@"2020",@"2019",@"2018",@"2017",@"2016",@"2015",@"2014",@"2013",@"2012",@"2011",@"2010",@"2009",
                     @"2008",@"2007",@"2006",@"2005",@"2004",@"2003",@"2002",@"2001",@"2000",@"1999",@"1998",
                     @"1997",@"1996",@"1995",@"1994",@"1993",nil];
        _betabet = [[NSArray alloc]initWithObjects:@"1 рубль",@"2 рубля", nil];
        _titleSeries.text = @"Выдающиеся личности России";
        _data2 = _data;
    }
    if (_rowSerial == 56) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Выдающиеся полководцы России'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2013",@"2000",nil];
        _betabet = [[NSArray alloc]initWithObjects:@"3 рубля",@"25 рублей",@"50 рублей", nil];
        _titleSeries.text = @"Выдающиеся полководцы России";
        _data2 = _data;
    }
    if (_rowSerial == 57) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Выдающиеся спортсмены России'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2014",@"2013",@"2012",@"2010",@"2009",nil];
        _betabet = [[NSArray alloc]initWithObjects:@"2 рубля",@"3 рубля", nil];
        _titleSeries.text = @"Выдающиеся спортсмены России";
        _data2 = _data;
    }
    if (_rowSerial == 58) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Герои ВОВ 1941–1945 гг.'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2025",@"2022",nil];
        _titleSeries.text = @"Герои ВОВ 1941–1945 гг.";
        _data2 = _data;
    }
    if (_rowSerial == 59) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Города'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2025",@"2024",@"2023",@"2022",@"2021",nil];
        _betabet = [[NSArray alloc]initWithObjects:@"3 рубля",@"50 рублей",@"100 рублей", nil];
        _titleSeries.text = @"Города";
        _data2 = _data;
    }
    if (_rowSerial == 60) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Города, освобожденные советскими войсками от немецко-фашистских захватчиков'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2016",nil];
        _titleSeries.text = @"Города, освобожденные советскими войсками от немецко-фашистских захватчиков";
        _data2 = _data;
    }
    if (_rowSerial == 61) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Города воинской славы'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2016",@"2015",@"2014",@"2013",@"2012",@"2011",nil];
        _titleSeries.text = @"Города воинской славы";
        _data2 = _data;
    }
    if (_rowSerial == 62) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Города трудовой доблести'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2025",@"2024",@"2023",@"2022",@"2021",nil];
        _titleSeries.text = @"Города трудовой доблести";
        _data2 = _data;
    }
    if (_rowSerial == 63) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Дзюдо'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2014",nil];
        _titleSeries.text = @"Дзюдо";
        _data2 = _data;
    }
    if (_rowSerial == 64) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Дионисий'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2002",nil];
        _titleSeries.text = @"Дионисий";
        _data2 = _data;
    }
    if (_rowSerial == 65) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Древние города России'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2024",@"2023",@"2022",@"2020",@"2019",@"2018",@"2017",@"2016",@"2014",@"2012",@"2011",@"2010",@"2009",@"2008",@"2007",
                     @"2006",@"2005",@"2004",@"2003",@"2002",nil];
        _titleSeries.text = @"Древние города России";
        _data2 = _data;
    }
    if (_rowSerial == 66) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Животный мир стран ЕврАзЭС'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2009",nil];
        _betabet = [[NSArray alloc]initWithObjects:@"3 рубля", nil];
        _titleSeries.text = @"Животный мир стран ЕврАзЭС";
        _data2 = _data;
    }
    if (_rowSerial == 67) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Зимние виды спорта'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2010",@"2009",nil];
        _titleSeries.text = @"Зимние виды спорта";
        _data2 = _data;
    }
    if (_rowSerial == 68) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Зимние Олимпийские игры 1998 года'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"1997",nil];
        _betabet = [[NSArray alloc]initWithObjects:@"1 рубль", nil];
        _titleSeries.text = @"Зимние Олимпийские игры 1998 года";
        _data2 = _data;
    }
    if (_rowSerial == 69) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Знаки зодиака'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2005",@"2004",@"2003",@"2002",nil];
        _betabet = [[NSArray alloc]initWithObjects:@"2 рубля",@"3 рубля",@"25 рублей",@"50 рублей", nil];
        _titleSeries.text = @"Знаки зодиака";
        _data2 = _data;
    }
    if (_rowSerial == 70) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Золотое кольцо'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2008",@"2006",@"2004",nil];
        _betabet = [[NSArray alloc]initWithObjects:@"5 рублей",@"100 рублей", nil];
        _titleSeries.text = @"Золотое кольцо";
        _data2 = _data;
    }
    if (_rowSerial == 71) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Инвестиционная монета'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2025",@"2024",@"2023",@"2022",@"2021",@"2020",@"2019",@"2018",@"2017",@"2016",@"2015",@"2014",@"2013",@"2010",@"2009",@"2008",@"2007",@"2006",@"1995",@"1976",nil];
        _betabet = [[NSArray alloc]initWithObjects:@"3 рубля",@"10 рублей",@"25 рублей",@"50 рублей",@"100 рублей",@"200 рублей", nil];
        _titleSeries.text = @"Инвестиционная монета";
        _data2 = _data;
    }
    if (_rowSerial == 72) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Исследование Русской Арктики'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"1995",nil];
        _titleSeries.text = @"Исследование Русской Арктики";
        _data2 = _data;
    }
    if (_rowSerial == 73) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Исторические события'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2025",@"2024",@"2023",@"2022",@"2021",nil];
        _titleSeries.text = @"Исторические события";
        _data2 = _data;
    }
    if (_rowSerial == 74) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'История денежного обращения России'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2009",nil];
        _titleSeries.text = @"История денежного обращения России";
        _data2 = _data;
    }
    if (_rowSerial == 75) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'История русского военно-морского флота'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2012",@"2010",nil];
        //_betabet = [[NSArray alloc]initWithObjects:@"1000 рублей", nil];
        _titleSeries.text = @"История русского военно-морского флота";
        _data2 = _data;
    }
    if (_rowSerial == 76) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'История русской авиации'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2016",@"2014",@"2013",@"2012",@"2011",@"2010",nil];
        _titleSeries.text = @"История русской авиации";
        _data2 = _data;
    }
    if (_rowSerial == 77) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'К 300-летию добровольного вхождения Хакасии в РФ'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2007",nil];
        _titleSeries.text = @"К 300-летию добровольного вхождения Хакасии в РФ";
        _data2 = _data;
    }
    if (_rowSerial == 78) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'К 350-летию добровольного вхождения Бурятии в состав РФ'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2011",nil];
        _titleSeries.text = @"К 350-летию добровольного вхождения Бурятии в состав РФ";
        _data2 = _data;
    }
    if (_rowSerial == 79) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'К 400-летию добровольного вхождения калмыцкого народа в состав РФ'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2009",nil];
        _titleSeries.text = @"К 400-летию добровольного вхождения калмыцкого народа в состав РФ";
        _data2 = _data;
    }
    if (_rowSerial == 80) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'К 450-летию добровольного вхождения Башкирии в РФ'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2007",nil];
        _titleSeries.text = @"К 450-летию добровольного вхождения Башкирии в РФ";
        _data2 = _data;
    }
    if (_rowSerial == 81) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'К 450-летию добровольного вхождения Удмуртии в РФ'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2008",nil];
        _titleSeries.text = @"К 450-летию добровольного вхождения Удмуртии в РФ";
        _data2 = _data;
    }
    if (_rowSerial == 82) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Красная книга'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2024",@"2019",@"2016",@"2014",@"2012",@"2010",@"2008",@"2007",@"2006",@"2005",@"2004",
                     @"2003",@"2002",@"2001",@"2000",@"1999",@"1998",@"1997",@"1996",@"1995",@"1994",@"1993",@"1992",nil];
        _betabet = [[NSArray alloc]initWithObjects:@"1 рубль",@"2 рубля",@"10 рублей",@"50 рублей", nil];
        _titleSeries.text = @"Красная книга";
        _data2 = _data;
    }
    if (_rowSerial == 83) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Космос'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2023",@"2022",@"2021",nil];
        _titleSeries.text = @"Космос";
        _data2 = _data;
    }
    if (_rowSerial == 84) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Кубок мира по спортивной ходьбе'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2008",nil];
        _titleSeries.text = @"Кубок мира по спортивной ходьбе";
        _data2 = _data;
    }
    if (_rowSerial == 85) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Легенды и сказки народов России'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2022",@"2020",@"2019",@"2017",nil];
        _titleSeries.text = @"Легенды и сказки народов России";
        _data2 = _data;
    }
    if (_rowSerial == 86) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Легенды и сказки стран ЕврАзЭС'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2009",nil];
        _titleSeries.text = @"Легенды и сказки стран ЕврАзЭС";
        _data2 = _data;
    }
    if (_rowSerial == 87) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Лунный календарь'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2013",@"2012",@"2011",@"2010",@"2009",@"2008",@"2007",@"2006",@"2005",@"2004",@"2003",nil];
        _titleSeries.text = @"Лунный календарь";
        _data2 = _data;
    }
    if (_rowSerial == 88) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Международная монетная программа стран ЕврАзЭС'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2012",@"2011",@"2010",nil];
        _titleSeries.text = @"Международная монетная программа стран ЕврАзЭС";
        _data2 = _data;
    }
    if (_rowSerial == 89) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'На страже Отечества'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2018",nil];
        _titleSeries.text = @"На страже Отечества";
        _data2 = _data;
    }
    if (_rowSerial == 90) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Окно в Европу'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2003",nil];
        _titleSeries.text = @"Окно в Европу";
        _data2 = _data;
    }
    if (_rowSerial == 91) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Олимпийский век России'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"1993",nil];
        _titleSeries.text = @"Олимпийский век России";
        _data2 = _data;
    }
    if (_rowSerial == 92) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Оружие Великой Победы (конструкторы оружия)'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2020",@"2019",nil];
        _titleSeries.text = @"Оружие Великой Победы (конструкторы оружия)";
        _data2 = _data;
    }
    if (_rowSerial == 93) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Освоение и исследование Сибири, XVI-XVII вв.'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2001",nil];
        _titleSeries.text = @"Освоение и исследование Сибири, XVI-XVII вв.";
        _data2 = _data;
    }
    if (_rowSerial == 94) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Памятники архитектуры России'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2024",@"2023",@"2022",@"2021",@"2020",@"2019",@"2018",@"2017",@"2016",@"2015",@"2014",@"2013",@"2012",@"2011",@"2010",@"2009",@"2008",@"2007",@"2006",@"2005",@"2004",@"2003",@"2002",@"2000",@"1999",@"1998",@"1997",
                     @"1996",@"1995",@"1994",@"1993",nil];
        _betabet = [[NSArray alloc]initWithObjects:@"3 рубля",@"25 рублей", nil];
        _titleSeries.text = @"Памятники архитектуры России";
        _data2 = _data;
    }
    if (_rowSerial == 95) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Победa в ВОВ 1941-1945'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"1994",nil];
        _titleSeries.text = @"Победa в ВОВ 1941-1945 гг.";
        _data2 = _data;
    }
    if (_rowSerial == 96) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Первая русская антарктическая экспедиция'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"1994",nil];
        _titleSeries.text = @"Первая русская антарктическая экспедиция";
        _data2 = _data;
    }
    if (_rowSerial == 97) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Первое русское кругосветное путешествие'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"1993",nil];
        _titleSeries.text = @"Первое русское кругосветное путешествие";
        _data2 = _data;
    }
    if (_rowSerial == 98) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Подвиг советских воинов, Крым, ВОВ 1941-1945 гг.'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2015",nil];
        _titleSeries.text = @"Подвиг советских воинов, Крым, ВОВ 1941-1945 гг.";
        _data2 = _data;
    }
    if (_rowSerial == 99) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Полководцы и герои ОВ 1812 года'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2012",nil];
        _titleSeries.text = @"Полководцы и герои ОВ 1812 года";
        _data2 = _data;
    }
    if (_rowSerial == 100) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Российская Федерация'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2025",@"2024",@"2023",@"2022",@"2021",@"2019",@"2018",@"2016",@"2014",@"2013",@"2011",@"2010",@"2009",@"2008",@"2007",@"2006",@"2005",nil];
        _titleSeries.text = @"Российская Федерация";
        _data2 = _data;
    }
    if (_rowSerial == 101) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Российская (советская) мультипликация'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2024",@"2023",@"2022",@"2021",@"2020",@"2019",@"2018",@"2017",nil];
        _betabet = [[NSArray alloc]initWithObjects:@"3 рубля",@"25 рублей", nil];
        _titleSeries.text = @"Российская (советская) мультипликация";
        _data2 = _data;
    }
    if (_rowSerial == 102) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Российский спорт'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2025",@"2024",@"2023",nil];
        _betabet = [[NSArray alloc]initWithObjects:@"1 рубль",@"3 рубля",@"25 рублей", nil];
        _titleSeries.text = @"Российский спорт";
        _data2 = _data;
    }
    if (_rowSerial == 103) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Россия во всемирном наследии ЮНЕСКО'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2016",@"2010",@"2009",@"2008",@"2006",nil];
        _betabet = [[NSArray alloc]initWithObjects:@"3 рубля",@"25 рублей",@"50 рублей",@"100 рублей",@"200 рублей",@"1000 рублей",@"10000 рублей", nil];
        _titleSeries.text = @"Россия во всемирном наследии ЮНЕСКО";
        _data2 = _data;
    }
    if (_rowSerial == 104) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Россия на рубеже тысячелетий'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2000",nil];
        _titleSeries.text = @"Россия на рубеже тысячелетий";
        _data2 = _data;
    }
    if (_rowSerial == 105) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Русские исследователи Центральной Азии'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"1999",nil];
        _titleSeries.text = @"Русские исследователи Центральной Азии";
        _data2 = _data;
    }
    if (_rowSerial == 106) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Русский балет'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"1999",@"1997",@"1996",@"1995",@"1994",@"1993",nil];
        _betabet = [[NSArray alloc]initWithObjects:@"3 рубля",@"5 рублей",@"10 рублей",@"25 рублей",@"50 рублей",@"100 рублей",@"150 рублей", nil];
        _titleSeries.text = @"Русский балет";
        _data2 = _data;
    }
    if (_rowSerial == 107) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Самбо'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2013",nil];
        _titleSeries.text = @"Самбо";
        _data2 = _data;
    }
    if (_rowSerial == 108) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Сбербанк 170 лет'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2012",@"2011",nil];
        _titleSeries.text = @"Сбербанк 170 лет";
        _data2 = _data;
    }
    if (_rowSerial == 109) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Символы России'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2015",nil];
        _titleSeries.text = @"Символы России";
        _data2 = _data;
    }
    if (_rowSerial == 110) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Сокровищница мировой культуры'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2018",@"2016",@"2015",@"2013",nil];
        _titleSeries.text = @"Сокровищница мировой культуры";
        _data2 = _data;
    }
    if (_rowSerial == 111) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Сохраним наш мир'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2023",@"2020",@"2015",@"2011",@"2008",@"2004",@"2000",@"1997",@"1996",@"1995",@"1994",@"1993",nil];
        _betabet = [[NSArray alloc]initWithObjects:@"3 рубля",@"25 рублей",@"50 рублей",@"100 рублей",@"200 рублей",@"10000 рублей", nil];
        _titleSeries.text = @"Сохраним наш мир";
        _data2 = _data;
    }
    if (_rowSerial == 112) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Сочи 2014'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2013",@"2012",@"2011",nil];
        _betabet = [[NSArray alloc]initWithObjects:@"3 рубля",@"25 рублей",@"50 рублей",@"100 рублей",@"200 рублей",@"1000 рублей",@"10000 рублей",@"25000 рублей", nil];
        _titleSeries.text = @"Сочи 2014";
        _data2 = _data;
    }
    if (_rowSerial == 113) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Спорт'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2006",@"2005",@"2004",nil];
        _betabet = [[NSArray alloc]initWithObjects:@"3 рубля",@"50 рублей", nil];
        _titleSeries.text = @"Спорт";
        _data2 = _data;
    }
    if (_rowSerial == 114) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Сражения и знаменательные события 1812 года'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2012",nil];
        _titleSeries.text = @"Сражения и знам. события ОВ 1812 года";
        _data2 = _data;
    }
    if (_rowSerial == 115) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Столицы стран - членов ЕврАзЭС'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2008",nil];
        _titleSeries.text = @"Столицы стран - членов ЕврАзЭС";
        _data2 = _data;
    }
    if (_rowSerial == 116) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Феофан Грек'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2004",nil];
        _titleSeries.text = @"Феофан Грек";
        _data2 = _data;
    }
    if (_rowSerial == 117) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Универсиада 2013 года в Казани'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2013",nil];
        _titleSeries.text = @"Универсиада 2013 года в г. Казани";
        _data2 = _data;
    }
    if (_rowSerial == 118) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Человек труда'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2024",@"2023",@"2022",@"2021",@"2020",nil];
        _titleSeries.text = @"Человек труда";
        _data2 = _data;
    }
    if (_rowSerial == 119) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Чемпионат мира по футболу FIFA 2018 в России'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2017",nil];
        _betabet = [[NSArray alloc]initWithObjects:@"3 рубля",@"25 рублей",@"50 рублей", nil];
        _titleSeries.text = @"Чемпионат мира по футболу FIFA 2018 в России";
        _data2 = _data;
    }
    if (_rowSerial == 120) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Экспедиции Г.И. Невельского на Дальний Восток'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2013",nil];
        _titleSeries.text = @"Экспедиции Г.И. Невельского на Дальний Восток";
        _data2 = _data;
    }
    if (_rowSerial == 121) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Эпоха просвещения. XVIII век'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"1992",nil];
        _titleSeries.text = @"Эпоха просвещения. XVIII век";
        _data2 = _data;
    }
    if (_rowSerial == 122) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Юбилей Победы советского народа в ВОВ 1941–1945 гг.'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2025",nil];
        _titleSeries.text = @"Юбилей Победы советского народа в ВОВ 1941–1945 гг.";
        _data2 = _data;
    }
    if (_rowSerial == 123) {
        NSPredicate* serial = [NSPredicate predicateWithFormat:@"serial == 'Ювелирное искусство в России'"];
        NSArray *serialResult = [[CRData fetchData] filteredArrayUsingPredicate:serial];
        _data = serialResult;
        _alphabet = [[NSArray alloc]initWithObjects:@"2024",@"2019",@"2016",nil];
        _titleSeries.text = @"Ювелирное искусство в России";
        _data2 = _data;
    }
    
    if (_still == 1) {
        NSPredicate* s11 = [NSPredicate predicateWithFormat:@"SELF.id beginswith[cd]%@", @"50"];
        NSPredicate* notPred11 = [NSCompoundPredicate notPredicateWithSubpredicate:s11];
        NSArray *notsresult11 = [_data filteredArrayUsingPredicate:notPred11];
        _data = notsresult11;
        NSPredicate* s12 = [NSPredicate predicateWithFormat:@"SELF.id beginswith[cd]%@", @"55"];
        NSPredicate* notPred12 = [NSCompoundPredicate notPredicateWithSubpredicate:s12];
        NSArray *notsresult12 = [_data filteredArrayUsingPredicate:notPred12];
        _data = notsresult12;
        NSPredicate* s13 = [NSPredicate predicateWithFormat:@"SELF.id beginswith[cd]%@", @"57"];
        NSPredicate* notPred13 = [NSCompoundPredicate notPredicateWithSubpredicate:s13];
        NSArray *notsresult13 = [_data filteredArrayUsingPredicate:notPred13];
        _data = notsresult13;
    }

    if (_still == 2) {
        NSPredicate* s11 = [NSPredicate predicateWithFormat:@"SELF.id beginswith[cd]%@", @"52"];
        NSArray *result11 = [_data filteredArrayUsingPredicate:s11];
        _data = result11;
    }
    
    if (_still == 3) {
        NSPredicate* s2 = [NSPredicate predicateWithFormat:@"SELF.id beginswith[cd]%@", @"51"];
        NSArray *result2 = [_data filteredArrayUsingPredicate:s2];
        _data = result2;
    }
    
    if (_still == 4) {
        NSPredicate* s21 = [NSPredicate predicateWithFormat:@"SELF.id beginswith[cd]%@", @"51"];
        NSPredicate* notPred21 = [NSCompoundPredicate notPredicateWithSubpredicate:s21];
        NSArray *notsresult21 = [_data filteredArrayUsingPredicate:notPred21];
        _data = notsresult21;
        NSPredicate* s22 = [NSPredicate predicateWithFormat:@"SELF.id beginswith[cd]%@", @"52"];
        NSPredicate* notPred22 = [NSCompoundPredicate notPredicateWithSubpredicate:s22];
        NSArray *notsresult22 = [_data filteredArrayUsingPredicate:notPred22];
        _data = notsresult22;
        NSPredicate* s23 = [NSPredicate predicateWithFormat:@"SELF.id beginswith[cd]%@", @"53"];
        NSPredicate* notPred23 = [NSCompoundPredicate notPredicateWithSubpredicate:s23];
        NSArray *notsresult23 = [_data filteredArrayUsingPredicate:notPred23];
        _data = notsresult23;
        NSPredicate* s24 = [NSPredicate predicateWithFormat:@"SELF.id beginswith[cd]%@", @"54"];
        NSPredicate* notPred24 = [NSCompoundPredicate notPredicateWithSubpredicate:s24];
        NSArray *notsresult24 = [_data filteredArrayUsingPredicate:notPred24];
        _data = notsresult24;
        NSPredicate* s25 = [NSPredicate predicateWithFormat:@"SELF.id beginswith[cd]%@", @"56"];
        NSPredicate* notPred25 = [NSCompoundPredicate notPredicateWithSubpredicate:s25];
        NSArray *notsresult25 = [_data filteredArrayUsingPredicate:notPred25];
        _data = notsresult25;
        NSPredicate* s26 = [NSPredicate predicateWithFormat:@"SELF.id beginswith[cd]%@", @"32"];
        NSPredicate* notPred26 = [NSCompoundPredicate notPredicateWithSubpredicate:s26];
        NSArray *notsresult26 = [_data filteredArrayUsingPredicate:notPred26];
        _data = notsresult26;
    }

    [self pcsCoinCollection];
    
    if (_dvor == 1) {
        NSPredicate* d = [NSPredicate predicateWithFormat:@"dvor CONTAINS[cd] %@", @"ММД"];
        NSArray *dresult = [_data filteredArrayUsingPredicate:d];
        _data = dresult;
    }
    if (_dvor == 2) {
        NSPredicate* d = [NSPredicate predicateWithFormat:@"dvor CONTAINS[cd] %@", @"СПМД"];
        NSArray *dresult = [_data filteredArrayUsingPredicate:d];
        _data = dresult;
    }
    _alphabet2 = [[NSMutableArray alloc] initWithCapacity:25];
    
    for(int i = 0; i<[_alphabet count]; i ++) {
        if (_year == (i+1)) {
            NSPredicate* z = [NSPredicate predicateWithFormat:@"created == %@", [_alphabet objectAtIndex:i]];
            NSArray *fresult = [_data filteredArrayUsingPredicate:z];
            _data = fresult;
        }
    }
    for(int j = 0; j<[_betabet count]; j ++) {
        if (_nom == (j+1)) {
            NSPredicate* zb = [NSPredicate predicateWithFormat:@"rating == %@", [_betabet objectAtIndex:j]];
            NSArray *fbresult = [_data filteredArrayUsingPredicate:zb];
            _data = fbresult;
        }
    }

    if (_dropdown == 0) {
        if (_kat == 0) {
            _dataSource = [[NSMutableArray alloc]initWithCapacity:[_alphabet count]];
            for(int i = 0; i<[_alphabet count]; i ++) {
                NSPredicate* p = [NSPredicate predicateWithFormat:@"created == %@", [_alphabet objectAtIndex:i]];
                NSArray *fresult = [_data filteredArrayUsingPredicate:p];
                if([fresult count]>0) {
                    [_dataSource addObject:(fresult)];
                    [_alphabet2 addObject:[_alphabet objectAtIndex:i]];
                }
            }
        }
        if (_kat == 1) {
            _dataSource = [[NSMutableArray alloc]initWithCapacity:[_betabet count]];
            for(int i = 0; i<[_betabet count]; i ++) {
                NSPredicate* p = [NSPredicate predicateWithFormat:@"rating == %@", [_betabet objectAtIndex:i]];
                NSArray *fresult = [_data filteredArrayUsingPredicate:p];
                if([fresult count]>0) {
                    [_dataSource addObject:(fresult)];
                    [_alphabet2 addObject:[_betabet objectAtIndex:i]];
                }
            }
        }
        if (_kat == 2) {
            _alphabet2 = [[NSMutableArray alloc] init];
            _dataSource = [[NSMutableArray alloc] init];
            _dataSource1 = [[NSMutableArray alloc] init];
            _dataSource2 = [[NSMutableArray alloc] init];
            _dataSource3 = [[NSMutableArray alloc] init];
            _dataSource4 = [[NSMutableArray alloc] init];
            _dataSource5 = [[NSMutableArray alloc] init];
            _dataSource6 = [[NSMutableArray alloc] init];
            for(int i = 0; i<[_gammabet1 count]; i ++) {
                NSPredicate* p = [NSPredicate predicateWithFormat:@"pcs == %@", [_gammabet1 objectAtIndex:i]];
                NSArray *fresult = [_data filteredArrayUsingPredicate:p];
                if([fresult count]>0) {
                    [_dataSource1 addObjectsFromArray:(fresult)];
                }
            }
            if([_dataSource1 count]>0) {
                [_dataSource addObject:_dataSource1];
                [_alphabet2 addObject:@"<99"];
            }
            for(int i = 0; i<[_gammabet2 count]; i ++) {
                NSPredicate* p = [NSPredicate predicateWithFormat:@"pcs == %@", [_gammabet2 objectAtIndex:i]];
                NSArray *fresult = [_data filteredArrayUsingPredicate:p];
                if([fresult count]>0) {
                    [_dataSource2 addObjectsFromArray:(fresult)];
                }
            }
            if([_dataSource2 count]>0) {
                [_dataSource addObject:_dataSource2];
                [_alphabet2 addObject:@"100-499"];
            }
            for(int i = 0; i<[_gammabet3 count]; i ++) {
                NSPredicate* p = [NSPredicate predicateWithFormat:@"pcs == %@", [_gammabet3 objectAtIndex:i]];
                NSArray *fresult = [_data filteredArrayUsingPredicate:p];
                if([fresult count]>0) {
                    [_dataSource3 addObjectsFromArray:(fresult)];
                }
            }
            if([_dataSource3 count]>0) {
                [_dataSource addObject:_dataSource3];
                [_alphabet2 addObject:@"500-999"];
            }
            for(int i = 0; i<[_gammabet4 count]; i ++) {
                NSPredicate* p = [NSPredicate predicateWithFormat:@"pcs == %@", [_gammabet4 objectAtIndex:i]];
                NSArray *fresult = [_data filteredArrayUsingPredicate:p];
                if([fresult count]>0) {
                    [_dataSource4 addObjectsFromArray:(fresult)];
                }
            }
            if([_dataSource4 count]>0) {
                [_dataSource addObject:_dataSource4];
                [_alphabet2 addObject:@"1 000-4 999"];
            }
            for(int i = 0; i<[_gammabet5 count]; i ++) {
                NSPredicate* p = [NSPredicate predicateWithFormat:@"pcs == %@", [_gammabet5 objectAtIndex:i]];
                NSArray *fresult = [_data filteredArrayUsingPredicate:p];
                if([fresult count]>0) {
                    [_dataSource5 addObjectsFromArray:(fresult)];
                }
            }
            if([_dataSource5 count]>0) {
                [_dataSource addObject:_dataSource5];
                [_alphabet2 addObject:@"5 000-9 999"];
            }
            for(int i = 0; i<[_gammabet6 count]; i ++) {
                NSPredicate* p = [NSPredicate predicateWithFormat:@"pcs == %@", [_gammabet6 objectAtIndex:i]];
                NSArray *fresult = [_data filteredArrayUsingPredicate:p];
                if([fresult count]>0) {
                    [_dataSource6 addObjectsFromArray:(fresult)];
                }
            }
            if([_dataSource6 count]>0) {
                [_dataSource addObject:_dataSource6];
                [_alphabet2 addObject:@"10 000<"];
            }
        }
    } else if (_dropdown == 1) {
        NSPredicate* u = [NSPredicate predicateWithFormat:@"id IN %@", _dataUser];
        NSArray *uresult = [_data filteredArrayUsingPredicate:u];
        _data = uresult;

        if (_kat == 0) {
            _dataSource = [[NSMutableArray alloc]initWithCapacity:[_alphabet count]];
            for(int i = 0; i<[_alphabet count]; i ++) {
                NSPredicate* p1 = [NSPredicate predicateWithFormat:@"created == %@", [_alphabet objectAtIndex:i]];
                NSArray *fresult = [_data filteredArrayUsingPredicate:p1];
                if([fresult count]>0) {
                    [_dataSource addObject:(fresult)];
                    [_alphabet2 addObject:[_alphabet objectAtIndex:i]];
                }
            }
        }
        if (_kat == 1) {
            _dataSource = [[NSMutableArray alloc]initWithCapacity:[_betabet count]];
            for(int i = 0; i<[_betabet count]; i ++) {
                NSPredicate* p = [NSPredicate predicateWithFormat:@"rating == %@", [_betabet objectAtIndex:i]];
                NSArray *fresult = [_data filteredArrayUsingPredicate:p];
                if([fresult count]>0) {
                    [_dataSource addObject:(fresult)];
                    [_alphabet2 addObject:[_betabet objectAtIndex:i]];
                }
            }
        }
        if (_kat == 2) {
            _alphabet2 = [[NSMutableArray alloc] init];
            _dataSource = [[NSMutableArray alloc] init];
            _dataSource1 = [[NSMutableArray alloc] init];
            _dataSource2 = [[NSMutableArray alloc] init];
            _dataSource3 = [[NSMutableArray alloc] init];
            _dataSource4 = [[NSMutableArray alloc] init];
            _dataSource5 = [[NSMutableArray alloc] init];
            _dataSource6 = [[NSMutableArray alloc] init];
            for(int i = 0; i<[_gammabet1 count]; i ++) {
                NSPredicate* p = [NSPredicate predicateWithFormat:@"pcs == %@", [_gammabet1 objectAtIndex:i]];
                NSArray *fresult = [_data filteredArrayUsingPredicate:p];
                if([fresult count]>0) {
                    [_dataSource1 addObjectsFromArray:(fresult)];
                }
            }
            if([_dataSource1 count]>0) {
                [_dataSource addObject:_dataSource1];
                [_alphabet2 addObject:@"<99"];
            }
            for(int i = 0; i<[_gammabet2 count]; i ++) {
                NSPredicate* p = [NSPredicate predicateWithFormat:@"pcs == %@", [_gammabet2 objectAtIndex:i]];
                NSArray *fresult = [_data filteredArrayUsingPredicate:p];
                if([fresult count]>0) {
                    [_dataSource2 addObjectsFromArray:(fresult)];
                }
            }
            if([_dataSource2 count]>0) {
                [_dataSource addObject:_dataSource2];
                [_alphabet2 addObject:@"100-499"];
            }
            for(int i = 0; i<[_gammabet3 count]; i ++) {
                NSPredicate* p = [NSPredicate predicateWithFormat:@"pcs == %@", [_gammabet3 objectAtIndex:i]];
                NSArray *fresult = [_data filteredArrayUsingPredicate:p];
                if([fresult count]>0) {
                    [_dataSource3 addObjectsFromArray:(fresult)];
                }
            }
            if([_dataSource3 count]>0) {
                [_dataSource addObject:_dataSource3];
                [_alphabet2 addObject:@"500-999"];
            }
            for(int i = 0; i<[_gammabet4 count]; i ++) {
                NSPredicate* p = [NSPredicate predicateWithFormat:@"pcs == %@", [_gammabet4 objectAtIndex:i]];
                NSArray *fresult = [_data filteredArrayUsingPredicate:p];
                if([fresult count]>0) {
                    [_dataSource4 addObjectsFromArray:(fresult)];
                }
            }
            if([_dataSource4 count]>0) {
                [_dataSource addObject:_dataSource4];
                [_alphabet2 addObject:@"1 000-4 999"];
            }
            for(int i = 0; i<[_gammabet5 count]; i ++) {
                NSPredicate* p = [NSPredicate predicateWithFormat:@"pcs == %@", [_gammabet5 objectAtIndex:i]];
                NSArray *fresult = [_data filteredArrayUsingPredicate:p];
                if([fresult count]>0) {
                    [_dataSource5 addObjectsFromArray:(fresult)];
                }
            }
            if([_dataSource5 count]>0) {
                [_dataSource addObject:_dataSource5];
                [_alphabet2 addObject:@"5 000-9 999"];
            }
            for(int i = 0; i<[_gammabet6 count]; i ++) {
                NSPredicate* p = [NSPredicate predicateWithFormat:@"pcs == %@", [_gammabet6 objectAtIndex:i]];
                NSArray *fresult = [_data filteredArrayUsingPredicate:p];
                if([fresult count]>0) {
                    [_dataSource6 addObjectsFromArray:(fresult)];
                }
            }
            if([_dataSource6 count]>0) {
                [_dataSource addObject:_dataSource6];
                [_alphabet2 addObject:@"10 000<"];
            }
        }
        if (_dataUser.count == 0) {
            if (_dropdown == 1) {
                UIAlertView *subAlert = [[UIAlertView alloc] initWithTitle:@"Нет монет в коллекции"
                                                                   message:@"Вы можете добавить монеты через каталог"
                                                                  delegate:self
                                                         cancelButtonTitle:@"ОК"
                                                         otherButtonTitles:nil];
                subAlert.alertViewStyle = UIAlertViewStyleDefault;
                [subAlert show];

                [button setTitle:[arrayData objectAtIndex:0] forState:UIControlStateNormal];
                _dropdown = 0;
                [self loadSettings];
            }
        }
    } else if (_dropdown == 3) {
        NSPredicate* coin = [NSPredicate predicateWithFormat:@"id IN %@", news2];
        NSArray *coinres = [_data filteredArrayUsingPredicate:coin];
        _data = coinres;
        
        if (_kat == 0) {
            _dataSource = [[NSMutableArray alloc]initWithCapacity:[_alphabet count]];
            for(int i = 0; i<[_alphabet count]; i ++) {
                NSPredicate* p = [NSPredicate predicateWithFormat:@"created == %@", [_alphabet objectAtIndex:i]];
                NSArray *fresult = [_data filteredArrayUsingPredicate:p];
                if([fresult count]>0) {
                    [_dataSource addObject:(fresult)];
                    [_alphabet2 addObject:[_alphabet objectAtIndex:i]];
                }
            }
        }
        if (_kat == 1) {
            _dataSource = [[NSMutableArray alloc]initWithCapacity:[_betabet count]];
            for(int i = 0; i<[_betabet count]; i ++) {
                NSPredicate* p = [NSPredicate predicateWithFormat:@"rating == %@", [_betabet objectAtIndex:i]];
                NSArray *fresult = [_data filteredArrayUsingPredicate:p];
                if([fresult count]>0) {
                    [_dataSource addObject:(fresult)];
                    [_alphabet2 addObject:[_betabet objectAtIndex:i]];
                }
            }
        }
        if (_kat == 2) {
            _alphabet2 = [[NSMutableArray alloc] init];
            _dataSource = [[NSMutableArray alloc] init];
            _dataSource1 = [[NSMutableArray alloc] init];
            _dataSource2 = [[NSMutableArray alloc] init];
            _dataSource3 = [[NSMutableArray alloc] init];
            _dataSource4 = [[NSMutableArray alloc] init];
            _dataSource5 = [[NSMutableArray alloc] init];
            _dataSource6 = [[NSMutableArray alloc] init];
            for(int i = 0; i<[_gammabet1 count]; i ++) {
                NSPredicate* p = [NSPredicate predicateWithFormat:@"pcs == %@", [_gammabet1 objectAtIndex:i]];
                NSArray *fresult = [_data filteredArrayUsingPredicate:p];
                if([fresult count]>0) {
                    [_dataSource1 addObjectsFromArray:(fresult)];
                }
            }
            if([_dataSource1 count]>0) {
                [_dataSource addObject:_dataSource1];
                [_alphabet2 addObject:@"<99"];
            }
            for(int i = 0; i<[_gammabet2 count]; i ++) {
                NSPredicate* p = [NSPredicate predicateWithFormat:@"pcs == %@", [_gammabet2 objectAtIndex:i]];
                NSArray *fresult = [_data filteredArrayUsingPredicate:p];
                if([fresult count]>0) {
                    [_dataSource2 addObjectsFromArray:(fresult)];
                }
            }
            if([_dataSource2 count]>0) {
                [_dataSource addObject:_dataSource2];
                [_alphabet2 addObject:@"100-499"];
            }
            for(int i = 0; i<[_gammabet3 count]; i ++) {
                NSPredicate* p = [NSPredicate predicateWithFormat:@"pcs == %@", [_gammabet3 objectAtIndex:i]];
                NSArray *fresult = [_data filteredArrayUsingPredicate:p];
                if([fresult count]>0) {
                    [_dataSource3 addObjectsFromArray:(fresult)];
                }
            }
            if([_dataSource3 count]>0) {
                [_dataSource addObject:_dataSource3];
                [_alphabet2 addObject:@"500-999"];
            }
            for(int i = 0; i<[_gammabet4 count]; i ++) {
                NSPredicate* p = [NSPredicate predicateWithFormat:@"pcs == %@", [_gammabet4 objectAtIndex:i]];
                NSArray *fresult = [_data filteredArrayUsingPredicate:p];
                if([fresult count]>0) {
                    [_dataSource4 addObjectsFromArray:(fresult)];
                }
            }
            if([_dataSource4 count]>0) {
                [_dataSource addObject:_dataSource4];
                [_alphabet2 addObject:@"1 000-4 999"];
            }
            for(int i = 0; i<[_gammabet5 count]; i ++) {
                NSPredicate* p = [NSPredicate predicateWithFormat:@"pcs == %@", [_gammabet5 objectAtIndex:i]];
                NSArray *fresult = [_data filteredArrayUsingPredicate:p];
                if([fresult count]>0) {
                    [_dataSource5 addObjectsFromArray:(fresult)];
                }
            }
            if([_dataSource5 count]>0) {
                [_dataSource addObject:_dataSource5];
                [_alphabet2 addObject:@"5 000-9 999"];
            }
            for(int i = 0; i<[_gammabet6 count]; i ++) {
                NSPredicate* p = [NSPredicate predicateWithFormat:@"pcs == %@", [_gammabet6 objectAtIndex:i]];
                NSArray *fresult = [_data filteredArrayUsingPredicate:p];
                if([fresult count]>0) {
                    [_dataSource6 addObjectsFromArray:(fresult)];
                }
            }
            if([_dataSource6 count]>0) {
                [_dataSource addObject:_dataSource6];
                [_alphabet2 addObject:@"10 000<"];
            }
        }
        if (_haveInet == 0) {
            UIAlertView *subAlert = [[UIAlertView alloc] initWithTitle:@"Отсутствует соединение интернет"
                                                               message:@"Для доступа в магазин требуется подключение к сети интернет"
                                                              delegate:self
                                                     cancelButtonTitle:@"ОК"
                                                     otherButtonTitles:nil];
            subAlert.alertViewStyle = UIAlertViewStyleDefault;
            [subAlert show];
            
            [button setTitle:[arrayData objectAtIndex:0] forState:UIControlStateNormal];
            _dropdown = 0;
            [self loadSettings];
        }
    } else if (_dropdown == 4) {
        
    } else if (_dropdown == 5) {
        NSPredicate* coin = [NSPredicate predicateWithFormat:@"id IN %@", newsNew];
        NSArray *coinres = [_data filteredArrayUsingPredicate:coin];
        _data = coinres;
        
        if (_kat == 0) {
            _dataSource = [[NSMutableArray alloc]initWithCapacity:[_alphabet count]];
            for(int i = 0; i<[_alphabet count]; i ++) {
                NSPredicate* p = [NSPredicate predicateWithFormat:@"created == %@", [_alphabet objectAtIndex:i]];
                NSArray *fresult = [_data filteredArrayUsingPredicate:p];
                if([fresult count]>0) {
                    [_dataSource addObject:(fresult)];
                    [_alphabet2 addObject:[_alphabet objectAtIndex:i]];
                }
            }
        }
        if (_kat == 1) {
            _dataSource = [[NSMutableArray alloc]initWithCapacity:[_betabet count]];
            for(int i = 0; i<[_betabet count]; i ++) {
                NSPredicate* p = [NSPredicate predicateWithFormat:@"rating == %@", [_betabet objectAtIndex:i]];
                NSArray *fresult = [_data filteredArrayUsingPredicate:p];
                if([fresult count]>0) {
                    [_dataSource addObject:(fresult)];
                    [_alphabet2 addObject:[_betabet objectAtIndex:i]];
                }
            }
        }
        if (_kat == 2) {
            _alphabet2 = [[NSMutableArray alloc] init];
            _dataSource = [[NSMutableArray alloc] init];
            _dataSource1 = [[NSMutableArray alloc] init];
            _dataSource2 = [[NSMutableArray alloc] init];
            _dataSource3 = [[NSMutableArray alloc] init];
            _dataSource4 = [[NSMutableArray alloc] init];
            _dataSource5 = [[NSMutableArray alloc] init];
            _dataSource6 = [[NSMutableArray alloc] init];
            for(int i = 0; i<[_gammabet1 count]; i ++) {
                NSPredicate* p = [NSPredicate predicateWithFormat:@"pcs == %@", [_gammabet1 objectAtIndex:i]];
                NSArray *fresult = [_data filteredArrayUsingPredicate:p];
                if([fresult count]>0) {
                    [_dataSource1 addObjectsFromArray:(fresult)];
                }
            }
            if([_dataSource1 count]>0) {
                [_dataSource addObject:_dataSource1];
                [_alphabet2 addObject:@"<99"];
            }
            for(int i = 0; i<[_gammabet2 count]; i ++) {
                NSPredicate* p = [NSPredicate predicateWithFormat:@"pcs == %@", [_gammabet2 objectAtIndex:i]];
                NSArray *fresult = [_data filteredArrayUsingPredicate:p];
                if([fresult count]>0) {
                    [_dataSource2 addObjectsFromArray:(fresult)];
                }
            }
            if([_dataSource2 count]>0) {
                [_dataSource addObject:_dataSource2];
                [_alphabet2 addObject:@"100-499"];
            }
            for(int i = 0; i<[_gammabet3 count]; i ++) {
                NSPredicate* p = [NSPredicate predicateWithFormat:@"pcs == %@", [_gammabet3 objectAtIndex:i]];
                NSArray *fresult = [_data filteredArrayUsingPredicate:p];
                if([fresult count]>0) {
                    [_dataSource3 addObjectsFromArray:(fresult)];
                }
            }
            if([_dataSource3 count]>0) {
                [_dataSource addObject:_dataSource3];
                [_alphabet2 addObject:@"500-999"];
            }
            for(int i = 0; i<[_gammabet4 count]; i ++) {
                NSPredicate* p = [NSPredicate predicateWithFormat:@"pcs == %@", [_gammabet4 objectAtIndex:i]];
                NSArray *fresult = [_data filteredArrayUsingPredicate:p];
                if([fresult count]>0) {
                    [_dataSource4 addObjectsFromArray:(fresult)];
                }
            }
            if([_dataSource4 count]>0) {
                [_dataSource addObject:_dataSource4];
                [_alphabet2 addObject:@"1 000-4 999"];
            }
            for(int i = 0; i<[_gammabet5 count]; i ++) {
                NSPredicate* p = [NSPredicate predicateWithFormat:@"pcs == %@", [_gammabet5 objectAtIndex:i]];
                NSArray *fresult = [_data filteredArrayUsingPredicate:p];
                if([fresult count]>0) {
                    [_dataSource5 addObjectsFromArray:(fresult)];
                }
            }
            if([_dataSource5 count]>0) {
                [_dataSource addObject:_dataSource5];
                [_alphabet2 addObject:@"5 000-9 999"];
            }
            for(int i = 0; i<[_gammabet6 count]; i ++) {
                NSPredicate* p = [NSPredicate predicateWithFormat:@"pcs == %@", [_gammabet6 objectAtIndex:i]];
                NSArray *fresult = [_data filteredArrayUsingPredicate:p];
                if([fresult count]>0) {
                    [_dataSource6 addObjectsFromArray:(fresult)];
                }
            }
            if([_dataSource6 count]>0) {
                [_dataSource addObject:_dataSource6];
                [_alphabet2 addObject:@"10 000<"];
            }
        }
        if (_haveInet == 0) {
            UIAlertView *subAlert = [[UIAlertView alloc] initWithTitle:@"Отсутствует соединение интернет"
                                                               message:@"Для доступа в магазин требуется подключение к сети интернет"
                                                              delegate:self
                                                     cancelButtonTitle:@"ОК"
                                                     otherButtonTitles:nil];
            subAlert.alertViewStyle = UIAlertViewStyleDefault;
            [subAlert show];
            
            [button setTitle:[arrayData objectAtIndex:0] forState:UIControlStateNormal];
            _dropdown = 0;
            [self loadSettings];
        }
    }
}

- (void)pcsCoinCollection
{
    NSPredicate* df = [NSPredicate predicateWithFormat:@"id IN %@", _dataUser];
    NSArray *dfresult = [_data2 filteredArrayUsingPredicate:df];
    _data3 = dfresult;
    if (_dropdown == 0) {
        _pcsSeries.text = [NSString stringWithFormat:@"%luшт", (unsigned long)_data2.count];
    } else if (_dropdown == 1) {
        _pcsSeries.text = [NSString stringWithFormat:@"%lu/%luшт", (unsigned long)_data3.count, (unsigned long)_data2.count];
    } else if (_dropdown == 3) {
        _pcsSeries.text = [NSString stringWithFormat:@"%luшт", (unsigned long)news2.count];
    } else if (_dropdown == 4) {
        //_pcsSeries.text = [NSString stringWithFormat:@"%luшт", (unsigned long)newsSale.count];
    } else if (_dropdown == 5) {
        _pcsSeries.text = [NSString stringWithFormat:@"%luшт", (unsigned long)newsNew.count];
    }
}

#pragma mark -
#pragma mark DropDownViewDelegate

-(void)dropDownCellSelected:(NSInteger)returnIndex{
    
    [button setTitle:[arrayData objectAtIndex:returnIndex] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"arrowDown.png"] forState:UIControlStateNormal];
    
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    
    self.tableView.userInteractionEnabled = YES;
    self.sideBarButtom.enabled = YES;
    if (returnIndex == 0) {
        _dropdown = 0;
        //dropDownView.;
        [self loadSettings];
    }
    if (returnIndex == 1) {
        _dropdown = 1;
        [self loadSettings];
    }
    if (returnIndex == 2) {
        [self performSegueWithIdentifier:@"statisticseg" sender:nil];
        [button setTitle:[arrayData objectAtIndex:0] forState:UIControlStateNormal];
        _dropdown = 0;
        [self loadSettings];
    }
    if (returnIndex == 3) {
        _dropdown = 3;
        [self loadSettings];
    }
    if (returnIndex == 4) {
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://ricgold.com"]];
        
        UIApplication *application = [UIApplication sharedApplication];
        NSURL *URL = [NSURL URLWithString:@"http://ricgold.com"];
        [application openURL:URL options:@{} completionHandler:nil];
    }
    if (returnIndex == 5) {
        [self performSegueWithIdentifier:@"shopseg" sender:nil];
        [button setTitle:[arrayData objectAtIndex:0] forState:UIControlStateNormal];
        _dropdown = 0;
        [self loadSettings];
    }
    if (returnIndex == 6) {
        [self performSegueWithIdentifier:@"statisticdelivery" sender:nil];
        [button setTitle:[arrayData objectAtIndex:0] forState:UIControlStateNormal];
        _dropdown = 0;
        [self loadSettings];
    }
}

#pragma mark -
#pragma mark Class methods

-(IBAction)actionButtonClick{
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    if (_sideBarButtom.enabled == NO) {
        [dropDownView closeAnimation];
        [button setImage:[UIImage imageNamed:@"arrowDown.png"] forState:UIControlStateNormal];
        self.tableView.userInteractionEnabled = YES;
        self.sideBarButtom.enabled = YES;
    } else {
        [dropDownView openAnimation];
        [button setImage:[UIImage imageNamed:@"arrowUp.png"] forState:UIControlStateNormal];
        self.tableView.userInteractionEnabled = NO;
        self.sideBarButtom.enabled = NO;
    }
}

- (IBAction)telButton:(id)sender {
    UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:@"Позвонить в магазин"
                                                       message:@""
                                                      delegate:self
                                             cancelButtonTitle:@"Отмена"
                                             otherButtonTitles:@"+7-926-306-74-74",@"+7-985-344-26-27",nil];
    Alert.alertViewStyle = UIAlertViewStyleDefault;
    Alert.tag = 1;
    [Alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://79263067474"]];
        }
        if (buttonIndex == 2) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://79853442627"]];
        }
    } else {
        if (buttonIndex == 1) {
           // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://ricgold.com"]];
            
            UIApplication *application = [UIApplication sharedApplication];
            NSURL *URL = [NSURL URLWithString:@"http://ricgold.com"];
            [application openURL:URL options:@{} completionHandler:nil];
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"LaunchedCoins"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

- (IBAction)refresh:(id)sender {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSURL *url = [NSURL URLWithString:@"https://www.ricgold.com/_xml/"];

    NSURLRequest *theRequest=[NSURLRequest requestWithURL:url
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    //NSURLRequest *theRequest2=[NSURLRequest requestWithURL:url2
    //                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
    //                                       timeoutInterval:60.0];
    //NSURLRequest *theRequest3=[NSURLRequest requestWithURL:url3
    //                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
    //                                       timeoutInterval:60.0];
    connection1=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];

    if (connection1) {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:@"https://www.ricgold.com/_xml"]];
        [request setHTTPMethod:@"GET"];
        [request addValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
        [request addValue:@"text/plain" forHTTPHeaderField:@"Accept"];

            NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            NSData * responseData = [requestReply dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
            NSLog(@"requestReply: %@", responseData);
                self.rssData = [NSMutableData data];
                self.rssData = [NSMutableData dataWithData:responseData];
        }] resume];

        [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(refreshend:) userInfo:nil repeats:NO];
    } else {
        NSLog(@"Connection failed");
    }
    [self.tableView reloadData];
}

-(void)refreshend:(id)sender {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (IBAction)arrow:(id)sender {
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    if (_arrow == 0) {
        [userDefaults setInteger:1 forKey:Arrow];
    } else {
        [userDefaults setInteger:0 forKey:Arrow];
    }
    [self bannerView];
}

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.searchController.isActive) {
        return 1;
    } else {
        return [_dataSource count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.searchController.isActive) {
        return @"Найдено:";
    } else {
        return [_alphabet2 objectAtIndex:section];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect frame = self.veiwSerial.frame;
    
    frame.origin.y = scrollView.contentOffset.y + scrollView.frame.size.height-_veiwSerial.frame.size.height;
    if (scrollView.contentSize.height > scrollView.frame.size.height){
        self.veiwSerial.frame = frame;
        [scrollView bringSubviewToFront:self.veiwSerial];
    } else {
        nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchController.isActive) {
        return [_filteredContent count];
    } else {
    if ([_dataSource count] == 0) {
        return 0;
    }
    return [[_dataSource objectAtIndex:section] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const CoinCellId = @"CoinCell";
    CRCoinCell *cell = [tableView dequeueReusableCellWithIdentifier:CoinCellId];
    if (!cell)
    {
        cell = [[CRCoinCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CoinCellId];
    }
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    if (self.searchController.isActive) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:CoinCellId];
        CRData *item = [_filteredContent objectAtIndex:indexPath.row];
        cell.cellCoinView.image = [UIImage imageNamed:item.imageName2];
        cell.cellTextRating.text = item.rating;
        if (item.rating.length == 12) {
            NSMutableString *st = [NSMutableString stringWithString:item.rating];
            [st insertString:@" " atIndex:2];
            cell.cellTextRating.text = st;
        }
        cell.cellTextTitle.text = item.title;
        
        NSString *string = item.pcs;
        cell.price1.text = [NSString stringWithFormat:@"Тираж: %@ шт", string];
        /*
        if (item.price == nil) {
            cell.price1.text = @" ";
        } else {
            NSString *string = [NSString stringWithFormat:@"Средняя цена: %@ ₽", [numberFormatter stringForObjectValue:item.price]];
            cell.price1.text = [string stringByReplacingOccurrencesOfString: @ "," withString: @ " "];
        }
         */
        NSString *find = [NSString stringWithFormat: @"%@-1",item.id];
        NSPredicate* with1 = [NSPredicate predicateWithFormat:@"article CONTAINS[cd] %@", find];
        NSPredicate* notwith1 = [NSCompoundPredicate notPredicateWithSubpredicate:with1];
        NSArray *notsresult1 = [news filteredArrayUsingPredicate:notwith1];
        
        NSPredicate* coin = [NSPredicate predicateWithFormat:@"article CONTAINS[cd] %@", item.id];
        NSArray *coinres = [notsresult1 filteredArrayUsingPredicate:coin];
        
        if([coinres count] > 0) {
            NSDictionary *newsItem = [coinres objectAtIndex:0];
            NSMutableString *resultfin = [NSMutableString stringWithFormat:@"%@", [newsItem objectForKey:@"price"]];
            [resultfin replaceOccurrencesOfString:@"\n" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, resultfin.length)];
            
            NSMutableString *resultfinOld = [NSMutableString stringWithFormat:@"%@", [newsItem objectForKey:@"price_replace"]];
            [resultfinOld replaceOccurrencesOfString:@"\n" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, resultfinOld.length)];
            
            NSMutableString *stringOld = [NSMutableString stringWithFormat:@" %@", [numberFormatter stringForObjectValue:[numberFormatter numberFromString:resultfinOld]]];
            NSString *stringf = [stringOld stringByReplacingOccurrencesOfString: @ "," withString: @ " "];
            if ([stringf  isEqual: @" 0"]) {
                stringf = @"";
            }
            
            NSMutableAttributedString *mutableAttString = [[NSMutableAttributedString alloc] init];
            NSDictionary* attributes = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]};
            NSAttributedString* attributedString = [[NSAttributedString alloc] initWithString:stringf attributes:attributes];
            
            NSString *stringNew = [NSString stringWithFormat:@" %@ ₽", [numberFormatter stringForObjectValue:[numberFormatter numberFromString:resultfin]]];
            NSString *string3 = [stringNew stringByReplacingOccurrencesOfString: @ "," withString: @ " "];
            NSAttributedString* string1 = [[NSAttributedString alloc] initWithString:@"Купить сейчас:"];
            NSAttributedString* string2 = [[NSAttributedString alloc] initWithString:string3];
            
            [mutableAttString appendAttributedString:string1];
            [mutableAttString appendAttributedString:attributedString];
            [mutableAttString appendAttributedString:string2];
            
            cell.price3.attributedText = mutableAttString;
            
            if ([cell.price3.text isEqualToString:@"Купить сейчас: 0 ₽"]) {
                cell.price3.text = @"Купить сейчас: нет в наличии";
            }
        } else {
            cell.price3.text = @"Купить сейчас: нет в наличии";
        }
        cell.cellId.text = item.createdOn;
        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *key1 = [NSString stringWithFormat: @"0%@",item.id];
        NSString *key2 = [NSString stringWithFormat: @"1%@",item.id];
        _pcs = [userDefaults objectForKey:key1];
        _pcs2 = [userDefaults objectForKey:key2];
        NSUbiquitousKeyValueStore* cloudUser = [NSUbiquitousKeyValueStore defaultStore];
        _pcsC = [cloudUser objectForKey:key1];
        _pcsC2 = [cloudUser objectForKey:key2];
        
        if (_pcs == _pcsC) {
            nil;
        } else {
            id token = [[NSFileManager defaultManager] ubiquityIdentityToken];
            if (token == nil)
            {
                nil;
            } else {
            NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:_pcsC forKey:key1];
            [userDefaults synchronize];}
        }
        if (_pcs2 == _pcsC2) {
            nil;
        } else {
            id token = [[NSFileManager defaultManager] ubiquityIdentityToken];
            if (token == nil)
            {
                nil;
            } else {
            NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:_pcsC2 forKey:key2];
            [userDefaults synchronize];}
        }
        if ([item.dvor isEqualToString:@"ММД"]) {
            cell.pcs2.text = @" ";
            if ([_pcs intValue] == 0) {
                cell.pcs1.text = [NSString stringWithFormat:@"ММД:0"];
                cell.pcs1.enabled = NO;
            } else {
                cell.pcs1.text = [NSString stringWithFormat:@"ММД:%@", [_pcs stringValue]];
                cell.pcs1.enabled = YES;
            }
        }
        if ([item.dvor isEqualToString:@"СПМД"]) {
            cell.pcs2.text = @" ";
            if ([_pcs intValue] == 0) {
                cell.pcs1.text = [NSString stringWithFormat:@"СПМД:0"];
                cell.pcs1.enabled = NO;
            } else {
                cell.pcs1.text = [NSString stringWithFormat:@"СПМД:%@", [_pcs stringValue]];
                cell.pcs1.enabled = YES;
            }
        }
        if ([item.dvor isEqualToString:@"СПМД (ЛМД)"]) {
            cell.pcs2.text = @" ";
            if ([_pcs intValue] == 0) {
                cell.pcs1.text = [NSString stringWithFormat:@"ЛМД:0"];
                cell.pcs1.enabled = NO;
            } else {
                cell.pcs1.text = [NSString stringWithFormat:@"ЛМД:%@", [_pcs stringValue]];
                cell.pcs1.enabled = YES;
            }
        }
        if ([item.dvor isEqualToString:@"ММД и СПМД"]|[item.dvor isEqualToString:@"ММД и СПМД (ЛМД)"]) {
            if ([_pcs2 intValue] == 0) {
                cell.pcs2.text = [NSString stringWithFormat:@"СПМД:0"];
                cell.pcs2.enabled = NO;
            }else{
                cell.pcs2.text = [NSString stringWithFormat:@"СПМД:%@", [_pcs2 stringValue]];
                cell.pcs2.enabled = YES;
            }
            if ([_pcs intValue] == 0) {
                cell.pcs1.text = [NSString stringWithFormat:@"ММД:0"];
                cell.pcs1.enabled = NO;
            }else{
                cell.pcs1.text = [NSString stringWithFormat:@"ММД:%@", [_pcs stringValue]];
                cell.pcs1.enabled = YES;
            }
            if ([item.dvor isEqualToString:@"ММД и СПМД (ЛМД)"]) {
                if ([_pcs2 intValue] == 0) {
                    cell.pcs2.text = [NSString stringWithFormat:@"ЛМД:0"];
                    cell.pcs2.enabled = NO;
                }else{
                    cell.pcs2.text = [NSString stringWithFormat:@"ЛМД:%@", [_pcs2 stringValue]];
                    cell.pcs2.enabled = YES;
                }
                if ([_pcs intValue] == 0) {
                    cell.pcs1.text = [NSString stringWithFormat:@"ММД:0"];
                    cell.pcs1.enabled = NO;
                }else{
                    cell.pcs1.text = [NSString stringWithFormat:@"ММД:%@", [_pcs stringValue]];
                    cell.pcs1.enabled = YES;
                }
            }
        }
    } else {
    CRData *item = [[_dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
    cell.cellCoinView.image = [UIImage imageNamed:item.imageName2];
    cell.cellTextRating.text = item.rating;
        if (item.rating.length == 12) {
            NSMutableString *st = [NSMutableString stringWithString:item.rating];
            [st insertString:@" " atIndex:2];
            cell.cellTextRating.text = st;
        }
    cell.cellTextTitle.text = item.title;
        
        NSString *string = item.pcs;
        cell.price1.text = [NSString stringWithFormat:@"Тираж: %@ шт", string];

        NSString *find = [NSString stringWithFormat: @"%@-1",item.id];
        NSPredicate* with1 = [NSPredicate predicateWithFormat:@"article CONTAINS[cd] %@", find];
        NSPredicate* notwith1 = [NSCompoundPredicate notPredicateWithSubpredicate:with1];
        NSArray *notsresult1 = [news filteredArrayUsingPredicate:notwith1];
        
        NSPredicate* coin = [NSPredicate predicateWithFormat:@"article CONTAINS[cd] %@", item.id];
        NSArray *coinres = [notsresult1 filteredArrayUsingPredicate:coin];

        if([coinres count] > 0) {
            NSDictionary *newsItem = [coinres objectAtIndex:0];
            NSMutableString *resultfin = [NSMutableString stringWithFormat:@"%@", [newsItem objectForKey:@"price"]];
            [resultfin replaceOccurrencesOfString:@"\n" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, resultfin.length)];
            
            NSMutableString *resultfinOld = [NSMutableString stringWithFormat:@"%@", [newsItem objectForKey:@"price_replace"]];
            [resultfinOld replaceOccurrencesOfString:@"\n" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, resultfinOld.length)];
            
            NSMutableString *stringOld = [NSMutableString stringWithFormat:@" %@", [numberFormatter stringForObjectValue:[numberFormatter numberFromString:resultfinOld]]];
            NSString *stringf = [stringOld stringByReplacingOccurrencesOfString: @ "," withString: @ " "];
            if ([stringf  isEqual: @" 0"]) {
                stringf = @"";
            }
            
            NSMutableAttributedString *mutableAttString = [[NSMutableAttributedString alloc] init];
            NSDictionary* attributes = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]};
            //NSDictionary* attributes = @{[NSBaselineOffsetAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0,stringf.length)]};
            NSAttributedString* attributedString = [[NSAttributedString alloc] initWithString:stringf attributes:attributes];
            
            NSString *stringNew = [NSString stringWithFormat:@" %@ ₽", [numberFormatter stringForObjectValue:[numberFormatter numberFromString:resultfin]]];
            NSString *string3 = [stringNew stringByReplacingOccurrencesOfString: @ "," withString: @ " "];
            NSAttributedString* string1 = [[NSAttributedString alloc] initWithString:@"Купить сейчас:"];
            NSAttributedString* string2 = [[NSAttributedString alloc] initWithString:string3];
            
            [mutableAttString appendAttributedString:string1];
            [mutableAttString appendAttributedString:attributedString];
            [mutableAttString appendAttributedString:string2];
            
            cell.price3.attributedText = mutableAttString;
            
            if ([cell.price3.text isEqualToString:@"Купить сейчас: 0 ₽"]) {
                cell.price3.text = @"Купить сейчас: нет в наличии";
            }
        } else {
            cell.price3.text = @"Купить сейчас: нет в наличии";
        }
        
    cell.cellId.text = item.createdOn;
        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *key1 = [NSString stringWithFormat: @"0%@",item.id];
        NSString *key2 = [NSString stringWithFormat: @"1%@",item.id];
        _pcs = [userDefaults objectForKey:key1];
        _pcs2 = [userDefaults objectForKey:key2];
        NSUbiquitousKeyValueStore* cloudUser = [NSUbiquitousKeyValueStore defaultStore];
        _pcsC = [cloudUser objectForKey:key1];
        _pcsC2 = [cloudUser objectForKey:key2];
        
        if (_pcs == _pcsC) {
            nil;
        } else {
            id token = [[NSFileManager defaultManager] ubiquityIdentityToken];
            if (token == nil)
            {
                nil;
            } else {
            NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:_pcsC forKey:key1];
            [userDefaults synchronize];}
        }
        if (_pcs2 == _pcsC2) {
            nil;
        } else {
            id token = [[NSFileManager defaultManager] ubiquityIdentityToken];
            if (token == nil)
            {
                nil;
            } else {
            NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:_pcsC2 forKey:key2];
            [userDefaults synchronize];}
        }

        if ([item.dvor isEqualToString:@"ММД"]) {
            cell.pcs2.text = @" ";
            if ([_pcs intValue] == 0) {
                cell.pcs1.text = [NSString stringWithFormat:@"ММД:0"];
                cell.pcs1.enabled = NO;
            } else {
                cell.pcs1.text = [NSString stringWithFormat:@"ММД:%@", [_pcs stringValue]];
                cell.pcs1.enabled = YES;
            }
        }
        if ([item.dvor isEqualToString:@"СПМД"]) {
            cell.pcs2.text = @" ";
            if ([_pcs intValue] == 0) {
                cell.pcs1.text = [NSString stringWithFormat:@"СПМД:0"];
                cell.pcs1.enabled = NO;
            } else {
                cell.pcs1.text = [NSString stringWithFormat:@"СПМД:%@", [_pcs stringValue]];
                cell.pcs1.enabled = YES;
            }
        }
        if ([item.dvor isEqualToString:@"СПМД (ЛМД)"]) {
            cell.pcs2.text = @" ";
            if ([_pcs intValue] == 0) {
                cell.pcs1.text = [NSString stringWithFormat:@"ЛМД:0"];
                cell.pcs1.enabled = NO;
            } else {
                cell.pcs1.text = [NSString stringWithFormat:@"ЛМД:%@", [_pcs stringValue]];
                cell.pcs1.enabled = YES;
            }
        }
        if ([item.dvor isEqualToString:@"ММД и СПМД"]) {
            if ([_pcs2 intValue] == 0) {
                cell.pcs2.text = [NSString stringWithFormat:@"СПМД:0"];
                cell.pcs2.enabled = NO;
            }else{
                cell.pcs2.text = [NSString stringWithFormat:@"СПМД:%@", [_pcs2 stringValue]];
                cell.pcs2.enabled = YES;
            }
            if ([_pcs intValue] == 0) {
                cell.pcs1.text = [NSString stringWithFormat:@"ММД:0"];
                cell.pcs1.enabled = NO;
            }else{
                cell.pcs1.text = [NSString stringWithFormat:@"ММД:%@", [_pcs stringValue]];
                cell.pcs1.enabled = YES;
            }
        }
        if ([item.dvor isEqualToString:@"ММД и СПМД (ЛМД)"]) {
            if ([_pcs2 intValue] == 0) {
                cell.pcs2.text = [NSString stringWithFormat:@"ЛМД:0"];
                cell.pcs2.enabled = NO;
            }else{
                cell.pcs2.text = [NSString stringWithFormat:@"ЛМД:%@", [_pcs2 stringValue]];
                cell.pcs2.enabled = YES;
            }
            if ([_pcs intValue] == 0) {
                cell.pcs1.text = [NSString stringWithFormat:@"ММД:0"];
                cell.pcs1.enabled = NO;
            }else{
                cell.pcs1.text = [NSString stringWithFormat:@"ММД:%@", [_pcs stringValue]];
                cell.pcs1.enabled = YES;
            }
        }
    }
    return cell;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)_searchController
{
    NSString *searchString = _searchController.searchBar.text;
    [self searchForText:searchString];
    [self.tableView reloadData];
}

- (void)searchForText:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
    scope:[[self.searchController.searchBar scopeButtonTitles]
    objectAtIndex:[self.searchController.searchBar
    selectedScopeButtonIndex]]];
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@ OR rating BEGINSWITH[cd] %@ OR serial BEGINSWITH[cd] %@ OR id BEGINSWITH[cd] %@", searchText, searchText,searchText,searchText];
    //NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@", searchText];
    NSArray *sresult2 = [[CRData fetchData] filteredArrayUsingPredicate:predicate2];
    if([sresult2 count]>0) {
        _filteredContent = [[CRData fetchData] filteredArrayUsingPredicate:predicate2];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        if ([self.searchController isActive]) {
            //CRData *item = [[_filteredContent objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            CRData *item = [_filteredContent objectAtIndex:indexPath.row];
            self.detailViewController.detail = item;
        } else {
            CRData *item = [[_dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            self.detailViewController.detail = item;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:UpdateIpad object:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        if ([self.searchController isActive]) {
            //NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            CRData *item = [_filteredContent objectAtIndex:indexPath.row];
            [segue.destinationViewController setDetail:item];
        } else {
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            if (indexPath) {
                CRData *item = [[_dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
                [segue.destinationViewController setDetail:item];
            }
        }
    }
}

@end
