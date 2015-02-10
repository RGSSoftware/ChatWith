//
//  RGSLoginViewController.m
//  ChatWith
//
//  Created by PC on 4/14/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSLoginViewController.h"

#import "RGSApplicationSession.h"

#import "RGSUserMangementService.h"
#import "RGSChatService.h"
#import "LocalStorageService.h"

@interface RGSLoginViewController ()
@property (nonatomic, strong)NSMutableArray *textFields;
@end

@implementation RGSLoginViewController

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
    
    _textFields = [NSMutableArray arrayWithCapacity:2];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.textFields addObjectsFromArray:@[self.usernameTextField, self.passwordTextField]];
    
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
    
    
    self.loginButton.backgroundColor = [UIColor colorWithHexString:@"414141" alpha:.45];
    [self.loginButton.layer setCornerRadius:10];
    [self.loginButton setTitleColor:[UIColor colorWithHexString:@"68DAFF"] forState:UIControlStateNormal];
    self.loginButton.titleLabel.font = [UIFont systemFontOfSize:20];
    
    self.registerButton.backgroundColor = [UIColor colorWithHexString:@"353535" alpha:.65];
    [self.registerButton.layer setCornerRadius:10];
    [self.registerButton setTitleColor:[UIColor colorWithHexString:@"68DAFF"] forState:UIControlStateNormal];
    self.registerButton.titleLabel.font = [self.registerButton.titleLabel.font fontWithSize:13];
    
    self.forgotButton.backgroundColor = [UIColor colorWithHexString:@"353535" alpha:.65];
    [self.forgotButton.layer setCornerRadius:10];
    
    NSMutableAttributedString *attributedString = [self.forgotButton.currentAttributedTitle mutableCopy];
    [attributedString setAlignment:NSTextAlignmentCenter];
    [attributedString setColor:[UIColor colorWithHexString:@"68DAFF"]];
    [attributedString setFont:[self.registerButton.titleLabel.font fontWithSize:13]];
    [self.forgotButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    
    self.rememberMeSwitch.onTintColor = [UIColor colorWithHexString:@"57d6ff"];
    self.rememberMeSwitch.tintColor = [UIColor colorWithWhite:0.810 alpha:1.000];
    
    
    self.rememberMeLabel.userInteractionEnabled = YES;
    [self.rememberMeLabel addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rememberMeLabelTapped:)]];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationItem.title = @"Login";
    
    self.navigationItem.rightBarButtonItem = nil;
    
    
    for (UITextField *textField in self.textFields) {
        UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        [textField setLeftViewMode:UITextFieldViewModeAlways];
        [textField setLeftView:spacerView];
    }
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        RGSUser *savedUser = [RGSUser findCurrentUser];
        if (savedUser) {
            if ([[NSUserDefaults standardUserDefaults] boolForKey:UDKRememberMe]) {
                self.usernameTextField.text = savedUser.login;
                self.passwordTextField.text = savedUser.password;
            }
        }
    });
    
    [self.container mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(CGRectGetMaxY(self.navigationController.navigationBar.frame) + 17));
    }];
}

- (void)unwindToInitViewScreen {
    //segway to next screen
    [self performSegueWithIdentifier:@"unwindFromLoginScreenToInitViewScreen" sender:self];
}

-(IBAction)loginUser:(id)sender{

    if ([self isUserCredentialsValid]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Signing In";
        
        UIImageView *doneCheckView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"doneCheck"]];
        doneCheckView.frame = CGRectMake(0, 0, CGRectGetWidth(doneCheckView.frame)/3, CGRectGetHeight(doneCheckView.frame)/3);
        hud.customView = doneCheckView;
        
        [QBRequest logInWithUserLogin:self.usernameTextField.text password:self.passwordTextField.text successBlock:^(QBResponse *response, QBUUser *user) {
            //display successful login message
            //segway to splah Screen
            
            RGSUser *rgsUser = [user rgsUser];
            rgsUser.currentUser = [NSNumber numberWithBool:YES];
            rgsUser.password = self.passwordTextField.text;
            rgsUser.entityID = [NSNumber numberWithInteger:user.ID];
        
            [rgsUser.managedObjectContext MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
                [[RGSChatService shared] loginUser:[rgsUser qbUser]  successBlock:^(BOOL success) {
                    if(success){
                        float delay = 1.1;
                        hud.mode = MBProgressHUDModeCustomView;
                        hud.labelText = @"Sign Successful";
                        [hud hide:YES afterDelay:delay];
                        [NSTimer bk_scheduledTimerWithTimeInterval:delay + 0.2 block:^(NSTimer *timer) {
                            [self performSegueWithIdentifier:@"unwindFromLoginScreenToSplashScreen" sender:self];

                        } repeats:NO];
                    } else {
                        [hud hide:YES];
                        NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
                        [errorDetail setValue:@"Failed to login to QBChat" forKey:NSLocalizedFailureReasonErrorKey];
                        [errorDetail setValue:@"Couldn't complete login of user because there was a QBChat failure login." forKey:NSLocalizedDescriptionKey];
                        [self handleFatalError: @{LogReportLevelMain : [NSError errorWithDomain:RGSLoginErrorDomain code:ELTQB userInfo:errorDetail]}];
                    }
                }];
            }];
        } errorBlock:^(QBResponse *response) {
            [hud hide:YES];
            NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
            [errorDetail setValue:@"error login to QBSystem" forKey:NSLocalizedFailureReasonErrorKey];
            [errorDetail setValue:@"Couldn't complete login of user because there was a QBSystem failure login." forKey:NSLocalizedDescriptionKey];
            ;
            [self handleFatalError: @{LogReportLevelMain : [NSError errorWithDomain:RGSLoginErrorDomain code:ELTQB userInfo:errorDetail], LogReportLevelSub : response.error.error}];

        }];

    } else {[self showAlertViewWithMeassage:@"Oops! Username or Password is invalid. Give it another shot."];}
    
    
    
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
    
    if(CGRectGetMaxY(finalFrame) >= CGRectGetMinY(self.container.frame)){
        [self.container mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@((CGRectGetMaxY(self.navigationController.navigationBar.frame)) + CGRectGetHeight(errorView.frame)));
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


- (void)showAlertViewWithMeassage:(NSString *)message{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OKAY"
                                              otherButtonTitles:nil];
    [alertView show];

}
-(BOOL)isUserCredentialsValid{
    return ([RGSUserMangementService isUserNameValid:self.usernameTextField.text] &&
            [RGSUserMangementService isPasswordValid:self.passwordTextField.text]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)rememberMeLabelTapped:(id)sender{
    if(self.rememberMeSwitch.isOn){
        [self.rememberMeSwitch setOn:NO animated:YES];
        [self rememberMe:self.rememberMeSwitch];
    } else {
        [self.rememberMeSwitch setOn:YES animated:YES];
        [self rememberMe:self.rememberMeSwitch];
    }
}

- (IBAction)rememberMe:(id)sender {
    if([sender isOn]){
        self.rememberMeLabel.textColor = [UIColor whiteColor];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:UDKRememberMe];
    }else{
        self.rememberMeLabel.textColor = [sender tintColor];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:UDKRememberMe];
    }
    
}
@end
