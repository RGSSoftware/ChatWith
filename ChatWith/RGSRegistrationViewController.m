//
//  RGSRegistrationViewController.m
//  ChatWith
//
//  Created by PC on 12/10/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSRegistrationViewController.h"

#import "RGSApplicationSession.h"


#import "RGSMessageAttachmentViewController.h"

#import <Quickblox/QBRequest+QBAuth.h>

#import "RGSUserMangementService.h"
#import "RGSChatService.h"
#import "LocalStorageService.h"

#import "RGSBackBarButtonItem.h"



@interface RGSRegistrationViewController ()
@property (nonatomic, strong)NSMutableArray *textFields;
@property (nonatomic, strong)NSMutableArray *buttons;
@end

@implementation RGSRegistrationViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self baseInit];
        
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self baseInit];
    }
    return self;
}

-(void)baseInit{
    
    _textFields = [NSMutableArray array];
    _buttons = [NSMutableArray array];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Registration";
    self.navigationItem.rightBarButtonItem = nil;
    
    self.navigationItem.leftBarButtonItem = [[RGSBackBarButtonItem alloc] initWithTitle:@"Login" handler:^(id sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [self.textFields addObjectsFromArray:@[self.usernameTextField,
                                           self.passwordTextField,
                                           self.emailTextField,
                                           self.firstnameTextField,
                                           self.lastnameTextField,
                                           self.phonenumberTextField]];
    
    for (UITextField *textField in self.textFields) {
        textField.backgroundColor = [UIColor colorWithHexString:@"363636" alpha:.20];
        textField.layer.borderColor = [[UIColor clearColor] CGColor];
        textField.textColor = [UIColor whiteColor];
        textField.layer.borderWidth = 1;
        textField.layer.cornerRadius = 10;
        
        NSMutableAttributedString *attributedString = [[textField.placeholder attributedString] mutableCopy];
        [attributedString setColor:[UIColor colorWithWhite:0.830 alpha:1.000]];
        textField.attributedPlaceholder = attributedString;
    }
    
    [self.buttons addObjectsFromArray:@[self.addUserImageButtom, self.submitButton]];
    for (UIButton *button in self.buttons) {
        button.backgroundColor = [UIColor colorWithHexString:@"414141" alpha:.45];
        [button.layer setCornerRadius:10];
        [button setTitleColor:[UIColor colorWithHexString:@"68DAFF"] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:20];
    }
    
    [self.userImage.layer setCornerRadius:10];
    self.userImage.clipsToBounds = YES;
    
    self.userImageContainer.layer.borderColor = [[UIColor colorWithWhite:0.830 alpha:1.000] CGColor];
    
    
}
- (void)viewDidLayoutSubviews {
self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetMaxY(self.submitButton.frame) + 5);
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    for (UITextField *textField in self.textFields) {
        UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        [textField setLeftViewMode:UITextFieldViewModeAlways];
        [textField setLeftView:spacerView];
    }
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.superview.mas_top);
        make.bottom.equalTo(self.scrollView.superview.mas_bottom);
    }];    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.destinationViewController isKindOfClass:[RGSMessageAttachmentViewController class]]) {
        RGSMessageAttachmentViewController *destinationViewController = segue.destinationViewController;
        destinationViewController.delegate = self;
    }
}

#pragma mark - RGSMessageAttachmentViewControllerDelegate ()
-(void)RGSMessageAttachmentViewController:(RGSMessageAttachmentViewController *)messageAttachmentViewController imageAttachment:(UIImage *)imageAttachment{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    self.userImage.image = imageAttachment;
}

- (IBAction)submit:(id)sender {
    
    if([RGSUserMangementService isEmailValid:self.emailTextField.text]){
        [self showAlertViewWithMeassage:@"Yes"];
    } else {
        [self showAlertViewWithMeassage:@"NO"];
    }
    
//    if ([self isUserCredentialsValid]) {
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        hud.labelText = @"Checking Username";
//        
//        UIImageView *doneCheckView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"doneCheck"]];
//        doneCheckView.frame = CGRectMake(0, 0, CGRectGetWidth(doneCheckView.frame)/3, CGRectGetHeight(doneCheckView.frame)/3);
//        hud.customView = doneCheckView;
//        [[RGSUserMangementService shared]
//         isUsernameTaken:self.usernameTextField.text
//         successBlock:^(BOOL isTaken) {
//             if(!isTaken){
//                 hud.mode = MBProgressHUDModeCustomView;
//                 hud.labelText = @"Username available";
//                 
//                 [NSTimer bk_scheduledTimerWithTimeInterval:0.8 block:^(NSTimer *timer) {
//                     hud.mode = MBProgressHUDModeIndeterminate;
//                     hud.labelText = @"Signing In";
//                     
//                     [QBRequest logInWithUserLogin:self.usernameTextField.text password:self.passwordTextField.text successBlock:^(QBResponse *response, QBUUser *user) {
//                         //display successful login message
//                         //segway to splah Screen
//                         
//                         RGSUser *rgsUser = [user rgsUser];
//                         rgsUser.currentUser = [NSNumber numberWithBool:YES];
//                         rgsUser.password = self.passwordTextField.text;
//                         rgsUser.entityID = [NSNumber numberWithInteger:user.ID];
//                         
//                         [rgsUser.managedObjectContext MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
//                             [[RGSChatService shared] loginUser:[rgsUser qbUser]  successBlock:^(BOOL success) {
//                                 if(success){
//                                     float delay = 1.1;
//                                     hud.mode = MBProgressHUDModeCustomView;
//                                     hud.labelText = @"Sign Successful";
//                                     [hud hide:YES afterDelay:delay];
//                                     [NSTimer bk_scheduledTimerWithTimeInterval:delay + 0.2 block:^(NSTimer *timer) {
//                                         [self performSegueWithIdentifier:@"unwindFromRegistrationScreenToSplashScreen" sender:self];
//                                         
//                                     } repeats:NO];
//                                 } else {
//                                     [hud hide:YES];
//                                     NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
//                                     [errorDetail setValue:@"Failed to login to QBChat" forKey:NSLocalizedFailureReasonErrorKey];
//                                     [errorDetail setValue:@"Couldn't complete login of user because there was a QBChat failure login." forKey:NSLocalizedDescriptionKey];
//                                     [self handleFatalError: @{LogReportLevelMain : [NSError errorWithDomain:RGSLoginErrorDomain code:ELTQB userInfo:errorDetail]}];
//                                 }
//                             }];
//                         }];
//                     } errorBlock:^(QBResponse *response) {
//                         [hud hide:YES];
//                         NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
//                         [errorDetail setValue:@"error login to QBSystem" forKey:NSLocalizedFailureReasonErrorKey];
//                         [errorDetail setValue:@"Couldn't complete login of user because there was a QBSystem failure login." forKey:NSLocalizedDescriptionKey];
//                         ;
//                         [self handleFatalError: @{LogReportLevelMain : [NSError errorWithDomain:RGSLoginErrorDomain code:ELTQB userInfo:errorDetail], LogReportLevelSub : response.error.error}];
//                         
//                     }];
//                  } repeats:NO];
//                 
//        } else {
//            [hud hide:YES];
//            [self showAlertViewWithMeassage:@"Oops! Somebody already has that name. Give it another shot."];
//        }
//         }];
//    } else {[self showAlertViewWithMeassage:@"Oops! Username or Password is invalid. Give it another shot."];}
}


-(BOOL)isUserCredentialsValid{
    return ([RGSUserMangementService isUserNameValid:self.usernameTextField.text] &&
            [RGSUserMangementService isPasswordValid:self.passwordTextField.text]);
}

- (void)showAlertViewWithMeassage:(NSString *)message{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"OKAY"
                                              otherButtonTitles:nil];
    
    [alertView show];
    
}

-(UIView *)fatalErrorView{
    int topPadding = 7;
    int bottonPadding = 7;
    int rightPadding = 10;
    int leftPadding = 10;
    
    UILabel *errorMessageLabel = [UILabel labelWithText:@"An error has occured. Please report for a quicker fix."];
    errorMessageLabel.textAlignment = NSTextAlignmentCenter;
    errorMessageLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    errorMessageLabel.textColor = [UIColor whiteColor];
    errorMessageLabel.numberOfLines = 0;
    
    
    CGSize expectedSize = [errorMessageLabel.text boundingRectWithSize:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) - (leftPadding + rightPadding), CGFLOAT_MAX) font:errorMessageLabel.font].size;
    errorMessageLabel.frame = CGRectMake(leftPadding, topPadding, CGRectGetWidth([UIScreen mainScreen].bounds) - (leftPadding + rightPadding), expectedSize.height);
    
    
    float errorViewHeight = topPadding + expectedSize.height + bottonPadding;
    UIView *errorView = [UIView new];
    errorView.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), errorViewHeight);
    errorView.backgroundColor = [UIColor colorWithHexString:@"e30c28"];
    
    [errorView addSubview:errorMessageLabel];
    
    return errorView;
}

-(void)handleFatalError:(NSDictionary *)errorDic{
    UIView *errorContainerView = [[UIView alloc] initWithFrame:self.view.frame];
    errorContainerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:errorContainerView];
    
    CALayer *maskLayer = [CALayer new];
    maskLayer.frame = self.view.bounds;
    errorContainerView.layer.mask = maskLayer;
    
    int navHeight = [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height;
    
    CALayer *clearlayer = [CALayer new];
    clearlayer.frame = CGRectMake(0,
                                  0,
                                  CGRectGetWidth(self.view.bounds),
                                  navHeight);
    clearlayer.backgroundColor = [UIColor clearColor].CGColor;
    [maskLayer addSublayer:clearlayer];
    
    CALayer *whiteLayer = [CALayer new];
    whiteLayer.frame = CGRectMake(0,
                                  navHeight,
                                  CGRectGetWidth(self.view.bounds),
                                  CGRectGetHeight(self.view.bounds) - navHeight);
    whiteLayer.backgroundColor = [UIColor whiteColor].CGColor;
    [maskLayer addSublayer:whiteLayer];
    
    
    //display fatal error
    UIView *errorView = [self fatalErrorView];
    [errorView setFrameOriginY:[UIApplication sharedApplication].statusBarFrame.size.height];
    [errorContainerView addSubview:errorView];
    
    CGRect finalFrame = errorView.frame;
    finalFrame.origin.y = navHeight;
    
    if(CGRectGetMaxY(finalFrame) >= CGRectGetMinY(self.scrollView.frame)){
//        [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(@((CGRectGetMaxY(self.navigationController.navigationBar.frame)) + CGRectGetHeight(errorView.frame)));
//        }];
        [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(@((CGRectGetMaxY(self.navigationController.navigationBar.frame)) + CGRectGetHeight(errorView.frame)));
             make.top.equalTo(self.scrollView.superview.mas_top).with.offset(CGRectGetHeight(errorView.frame));
            make.bottom.equalTo(self.scrollView.superview.mas_bottom).with.offset(CGRectGetHeight(errorView.frame));
        }];
        [UIView animateWithDuration:1.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            [errorView setFrameOriginY:navHeight];
            [self.view layoutIfNeeded];

        } completion:nil];
    } else {
        [UIView animateWithDuration:1.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [errorView setFrameOriginY:navHeight];
        } completion:nil];
    }
    
    RGSLogReport *logReport = [RGSLogReport logReportFromErrorDic:errorDic];
    if(logReport){
        [logReport.managedObjectContext MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
            if(success)[RGSLogService sendLog:logReport successBlock:nil];
        }];
    }
}



@end
