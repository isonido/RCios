//
//  CRZakazController.h
//  Russian Coins
//
//  Created by Andrey Androsov on 23.08.15.
//  Copyright (c) 2015 Andrey Sonido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRData.h"
#import <MessageUI/MessageUI.h>

@interface CRZakazController : UIViewController <MFMailComposeViewControllerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) CRData *detail;
@property NSMutableArray *dataUser;
@property NSMutableArray *dataZakaz;
@property NSArray *dataSource;
@property NSMutableArray *sumDataZakaz;
@property NSMutableArray *textMailZakaz;

@property (nonatomic, retain) NSMutableArray *news;
@property (nonatomic) NSNumber* pcssum;
@property (nonatomic) NSNumber* pcsstep;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollZakaz;
@property (weak, nonatomic) IBOutlet UILabel *text1;
@property (weak, nonatomic) IBOutlet UILabel *text2;
@property (weak, nonatomic) IBOutlet UILabel *sumZakaz;
@property (weak, nonatomic) IBOutlet UITextField *telefonField;

@property (weak, nonatomic) IBOutlet UITableView *tableZakaz;
@property (weak, nonatomic) IBOutlet UIButton *email;
@property (weak, nonatomic) IBOutlet UIButton *deleteAll;
- (IBAction)site:(id)sender;

- (IBAction)tel:(id)sender;
- (IBAction)deleteAll:(id)sender;
- (IBAction)email:(id)sender;

@end
