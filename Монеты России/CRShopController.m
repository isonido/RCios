//
//  CRShopController.m
//  Russian Coins
//
//  Created by Andrey Androsov on 02.08.15.
//  Copyright (c) 2015 Andrey Sonido. All rights reserved.
//

#import "CRShopController.h"

@interface CRShopController ()

@end

@implementation CRShopController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"Контакты";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)touchYa:(id)sender {
    //[[UIApplication sharedApplication] openURL:
     //[NSURL URLWithString:@"yandexmaps://build_route_on_map/?lat_to=55.736807&lon_to=37.653011"]];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"yandexmaps://"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"yandexmaps://build_route_on_map/?lat_to=55.736807&lon_to=37.653011"]];
    } else {
        // Открываем страницу приложения Яндекс.Карты в App Store.
        [[UIApplication sharedApplication] openURL:
         [NSURL URLWithString:@"https://itunes.apple.com/ru/app/yandex.maps/id313877526?mt=8"]];
    }
}

- (IBAction)email:(id)sender {
    // Email Subject
    NSString *emailTitle = @"Написать в магазин";
    // Email Content
    NSString *messageBody = @"Ваше сообщение:";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObjects:@"bkv@ricgold.com",@"mev81@mail.ru",@"mister.loka@yandex.ru",@"harchenko1987@yandex.ru",nil];
    //NSArray *toRecipents = [NSArray arrayWithObjects:@"andrey.sonido@gmail.com",nil];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
}

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)telefon:(id)sender {
    UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:@"Позвонить в магазин?"
                                                    message:@"+7 (495) 775-82-99"
                                                   delegate:self
                                          cancelButtonTitle:@"Отмена"
                                          otherButtonTitles:@"Да",nil];
    Alert.alertViewStyle = UIAlertViewStyleDefault;
    [Alert show];
}

- (IBAction)tel1:(id)sender {
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://79263067474"]];
    
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:@"tel://79263067474"];
    [application openURL:URL options:@{} completionHandler:nil];
}

- (IBAction)tel2:(id)sender {
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://79853442627"]];
    
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:@"telprompt://79853442627"];
    [application openURL:URL options:@{} completionHandler:nil];
}

- (IBAction)vykup:(id)sender {
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.ricgold.com"]];
    
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:@"http://ricgold.com"];
    [application openURL:URL options:@{} completionHandler:nil];
}

- (IBAction)pribor:(id)sender {
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.ricgold.com"]];
    
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:@"http://ricgold.com"];
    [application openURL:URL options:@{} completionHandler:nil];
}

- (IBAction)site:(id)sender {
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://ricgold.com"]];
    
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:@"http://ricgold.com"];
    [application openURL:URL options:@{} completionHandler:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://74957758299"]];
        
        UIApplication *application = [UIApplication sharedApplication];
        NSURL *URL = [NSURL URLWithString:@"telprompt://74957758299"];
        [application openURL:URL options:@{} completionHandler:nil];
    }
}


@end
