//
//  CRStatisticController.h
//  Russian Coins
//
//  Created by Andrey Androsov on 11.03.15.
//  Copyright (c) 2015 Andrey Sonido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface CRStatisticController : UITableViewController <MFMailComposeViewControllerDelegate, UIActionSheetDelegate>
{
    NSArray *_data;
}

@property (strong, nonatomic) IBOutlet UILabel *pcsAll;
@property (strong, nonatomic) IBOutlet UILabel *pcsUserAll;
@property (strong, nonatomic) IBOutlet UILabel *pcsPovtrUser;
@property (strong, nonatomic) IBOutlet UILabel *serialAll;
@property (strong, nonatomic) IBOutlet UILabel *serialUserAll;
@property (weak, nonatomic) IBOutlet UILabel *costUser;
@property (strong, nonatomic) NSArray *dataSerial;
@property (strong, nonatomic) IBOutlet UILabel *icloudenable;
@property NSMutableArray *dataUserSerial;
@property NSMutableArray *dataUser;
@property NSMutableArray *dataUser2;
@property NSArray *alphabet;
@property NSArray *data3;
@property NSMutableArray *sumpcs;
@property NSMutableArray *sumpcs2;
@property NSMutableArray *priceKonros;
@property (nonatomic) NSNumber* pcs;
@property (nonatomic) NSNumber* pcs2;
@property (nonatomic) NSNumber* sum;
@property (nonatomic) NSString* pcsUser2;
@property (nonatomic) NSString* pcsMmd;
@property (nonatomic) NSString* pcsSpmd;

- (IBAction)appStore:(id)sender;
- (IBAction)developer:(id)sender;
- (IBAction)vk:(id)sender;
- (IBAction)sendStat:(id)sender;

@end
