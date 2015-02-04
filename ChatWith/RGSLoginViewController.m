//
//  RGSLoginViewController.m
//  ChatWith
//
//  Created by PC on 4/14/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import "RGSLoginViewController.h"

#import "RGSApplicationSession.h"

#import "RGSLogReport.h"
#import "RGSLogService.h"
#import "RGSUserMangementService.h"
#import "RGSChatService.h"
#import "LocalStorageService.h"

@interface RGSLoginViewController () <UIAlertViewDelegate>
@property (nonatomic, strong)NSMutableArray *textFields;

@property (nonatomic, strong)UIAlertView *sendToDevloperAlert;

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
     _userManger = [RGSUserMangementService new];
    
    _textFields = [NSMutableArray arrayWithCapacity:2];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UILabel *redSquare = [UILabel new];
    redSquare.frame = CGRectMake(20, 20, 100, 100);
    redSquare.backgroundColor = [UIColor redColor];
    
    
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
    [self.rememberMeLabel addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rememberMeTapped:)]];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    for (UITextField *textField in self.textFields) {
        UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        [textField setLeftViewMode:UITextFieldViewModeAlways];
        [textField setLeftView:spacerView];
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
-(void)rememberMeTapped:(id)sender{
    if(self.rememberMeSwitch.isOn){
        [self.rememberMeSwitch setOn:NO animated:YES];
        [self rememberMe:self.rememberMeSwitch];
    } else {
        [self.rememberMeSwitch setOn:YES animated:YES];
        [self rememberMe:self.rememberMeSwitch];
        
 
    }
}

- (void)unwindToInitViewScreen {
    //segway to next screen
    [self performSegueWithIdentifier:@"unwindFromLoginScreenToInitViewScreen" sender:self];
}

-(IBAction)loginUser:(id)sender{

    if ([self isUserCredentialsValid]) {
        [QBRequest logInWithUserLogin:self.usernameTextField.text password:self.passwordTextField.text successBlock:^(QBResponse *response, QBUUser *user) {
            //display successful login message
            //segway to splah Screen
            
            RGSUser *rgsUser = [user rgsUser];
            rgsUser.currentUser = [NSNumber numberWithBool:YES];
            rgsUser.entityID = [NSNumber numberWithInteger:user.ID];
            
            [rgsUser.managedObjectContext MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
                [[RGSChatService shared] loginUser:user successBlock:^(BOOL success) {
                    if(success){
                        [self unwindToInitViewScreen];
                    } else {
                        
                        NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
                        [errorDetail setValue:@"Failed to login to QBChat" forKey:NSLocalizedFailureReasonErrorKey];
                        [errorDetail setValue:@"Couldn't complete login of user because there was a QBChat failure login." forKey:NSLocalizedDescriptionKey];
                        [self handleFatalError: @{LogReportLevelMain : [NSError errorWithDomain:RGSLoginErrorDomain code:ELTQB userInfo:errorDetail]}];
                    }
                }];
            }];
        } errorBlock:^(QBResponse *response) {
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
    [errorView setFrameOriginY:CGRectGetHeight(errorView.frame) * -1];
    [errorContainerView addSubview:errorView];
    
    [UIView animateWithDuration:1.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [errorView setFrameOriginY:navHeight];
    } completion:nil];
    
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
                                                       delegate:self
                                              cancelButtonTitle:@"OKAY"
                                              otherButtonTitles:nil];
    [alertView show];

}
-(BOOL)isUserCredentialsValid{
    return ([self isUserNameValid:self.usernameTextField.text] &&
            [self isPasswordValid:self.passwordTextField.text]);
}

- (BOOL)isPasswordValid:(NSString *)password
{
    if (password && !(password.length <= 4) && (password.length <=15)) {
        return YES;
    }
    
    return NO;
}
- (BOOL)isUserNameValid:(NSString *)username
{
    if(username && !(username.length == 0) && (username.length <= 20)){
        
        return [username isAlphaNumeric];
    }
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tryLoginWithMaxAttempts:(int)tries
                    successBlock:(void (^)(QBResponse *response, QBUUser *user))successBlock
                      errorBlock:(void (^)(QBResponse *response))errorBlock{
    QBUUser *user = [QBUUser user];
    user.login = self.usernameTextField.text;
    user.password = self.passwordTextField.text;
    
    [QBRequest logInWithUserLogin:user.login password:user.password successBlock:^(QBResponse *response, QBUUser *user) {
        successBlock(response, user);
        
    } errorBlock:^(QBResponse *response) {
        __block int currentTry = tries;
        if(currentTry != 0){
            currentTry--;
            [self tryLoginWithMaxAttempts:currentTry successBlock:successBlock errorBlock:errorBlock];
        } else {
            errorBlock(response);
        }
    }];
}


- (IBAction)rememberMe:(id)sender {
    if([sender isOn]){
        self.rememberMeLabel.textColor = [UIColor whiteColor];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"rememberMe"];
    }else{
        self.rememberMeLabel.textColor = [sender tintColor];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"rememberMe"];
    }
    
}
@end
