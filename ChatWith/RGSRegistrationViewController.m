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

#import "RGSNumberToolbar.h"



@interface RGSRegistrationViewController ()
@property (nonatomic, strong)NSMutableArray *textFields;
@property (nonatomic, strong)NSMutableArray *buttons;

@property BOOL hasUserImagePlaceholder;
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
        
        textField.returnKeyType = UIReturnKeyDone;
        [textField setBk_shouldReturnBlock:^BOOL(UITextField *textField) {
            [textField resignFirstResponder];
            return NO;
        }];
    }
    [self.phonenumberTextField setBk_didBeginEditingBlock:^(UITextField *textField) {
        
        UIBarButtonItem *canelButton = [[UIBarButtonItem alloc] bk_initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain handler:^(id sender) {
            [[UIDevice currentDevice] playInputClick];
            
            textField.text = nil;
            [textField resignFirstResponder];
        }];
        canelButton.tintColor = [UIColor whiteColor];
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] bk_initWithTitle:@"Done" style:UIBarButtonItemStyleDone handler:^(id sender) {
            [[UIDevice currentDevice] playInputClick];
            
            [textField resignFirstResponder];
        }];
        doneButton.tintColor = [UIColor whiteColor];
        
        RGSNumberToolbar *numberToolbar = [[RGSNumberToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        numberToolbar.barTintColor = [UIColor colorWithHexString:@"5C5C5C" alpha:.85];
        numberToolbar.items = [NSArray arrayWithObjects:
                               canelButton,
                               [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                               doneButton,
                               nil];
        [numberToolbar sizeToFit];
        textField.inputAccessoryView = numberToolbar;
    }];
    
    [self.buttons addObjectsFromArray:@[self.addUserImageButtom, self.submitButton]];
    for (UIButton *button in self.buttons) {
        button.backgroundColor = [UIColor colorWithHexString:@"353535" alpha:.65];
        [button.layer setCornerRadius:10];
        [button setTitleColor:[UIColor colorWithHexString:@"68DAFF"] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:20];
    }
    
    [self.userImage.layer setCornerRadius:10];
    self.userImage.clipsToBounds = YES;
    
    self.userImageContainer.backgroundColor = [UIColor colorWithHexString:@"363636" alpha:.20];
    
    
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
    
    self.hasUserImagePlaceholder = YES;
    
    [self registerForKeyboardNotifications];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self deRegisterForKeyboardNotifications];
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
    self.hasUserImagePlaceholder = NO;
    
    [self.userImage setFrameOrigin:CGPointMake(0, 0)];
    [self.userImage setFrameSize:self.userImageContainer.frame.size];
    
    self.userImage.image = imageAttachment;
}

- (IBAction)submit:(id)sender {
    
    for (UITextField *testField in self.textFields) {
        [testField resignFirstResponder];
    }
    if ([self isUserCredentialsValid]) {
        if([RGSUserMangementService isEmailValid:self.emailTextField.text]){
            
        
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"Checking Username";
            
            UIImageView *doneCheckView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"doneCheck"]];
            doneCheckView.frame = CGRectMake(0, 0, CGRectGetWidth(doneCheckView.frame)/3, CGRectGetHeight(doneCheckView.frame)/3);
            hud.customView = doneCheckView;
            [[RGSUserMangementService shared]
             isUsernameTaken:self.usernameTextField.text
             successBlock:^(BOOL isTaken) {
                 if(!isTaken){
                     hud.mode = MBProgressHUDModeCustomView;
                     hud.labelText = @"Username available";
                     [NSTimer bk_scheduledTimerWithTimeInterval:0.8 block:^(NSTimer *timer) {
                          hud.mode = MBProgressHUDModeIndeterminate;
                          hud.labelText = @"Creating Account";
                         
                         QBUUser *user = [QBUUser user];
                         user.login = self.usernameTextField.text;
                         user.password = self.passwordTextField.text;
                         user.email = self.emailTextField.text;
                         if(![self.firstnameTextField.text isEqualToString:@""] && ![self.lastnameTextField.text isEqualToString:@""]){
                             user.fullName = [NSString stringWithFormat:@"%@ %@", self.firstnameTextField.text, self.lastnameTextField.text];
                         }
                         if(![self.phonenumberTextField.text isEqualToString:@""]){
                             user.phone = self.phonenumberTextField.text;
                         }
                         [QBRequest signUp:user successBlock:^(QBResponse *response, QBUUser *user) {
                             if(response.success && !response.error){
                                 hud.labelText = @"Signing In";
                                 
                                 [QBRequest logInWithUserLogin:self.usernameTextField.text password:self.passwordTextField.text successBlock:^(QBResponse *response, QBUUser *user) {
                                    
                                     //upload user image
                                     if(!self.hasUserImagePlaceholder){
                                         QBCOFile *file = [QBCOFile file];
                                         file.name = @"image.jpeg";
                                         file.contentType = @"image/jpeg";
                                         file.data = UIImageJPEGRepresentation(self.userImage.image, 0.0);
                                         
                                         QBCOCustomObject *object = [QBCOCustomObject customObject];
                                         object.className = @"UserImage";
                                         
                                         [QBRequest createObject:object successBlock:^(QBResponse *response, QBCOCustomObject *object) {
                                             
                                             [QBRequest uploadFile:file className:@"UserImage" objectID:object.ID fileFieldName:@"image" successBlock:^(QBResponse *response, QBCOFileUploadInfo *info) {
                                                 
                                                
                                                 NSLog(@"file image upload: Resonse status: %ld", response.status);
                                                 
                                             } statusBlock:^(QBRequest *request, QBRequestStatus *status) {
                                                 
                                                 
                                             } errorBlock:^(QBResponse *response) {
                                                 NSLog(@"creating file Image: Response error: %@", [response.error description]);
                                                 
                                             }];
                                         } errorBlock:^(QBResponse *response) {
                                             NSLog(@"creating MessageImage: Response error: %@", [response.error description]);
                                             
                                         }];
                                         
                                     }
                                     
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
                                                     [self performSegueWithIdentifier:@"unwindFromRegistrationScreenToSplashScreen" sender:self];
                                                     
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

                                 
                             }
                         } errorBlock:^(QBResponse *response) {
                             [hud hide:YES];
                             NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
                             [errorDetail setValue:@"error creating new account with QBSystem" forKey:NSLocalizedFailureReasonErrorKey];
                             [errorDetail setValue:@"Couldn't complete registration of new user because QBSystem failure to create new account." forKey:NSLocalizedDescriptionKey];
                             
                             [self handleFatalError: @{LogReportLevelMain : [NSError errorWithDomain:RGSRegistrationErrorDomain code:ERWC userInfo:errorDetail], LogReportLevelSub : response.error.error}];
                         }];
                         
                         
                         } repeats:NO];
                     
                     
                     
                     
//                     [NSTimer bk_scheduledTimerWithTimeInterval:0.8 block:^(NSTimer *timer) {
//                         hud.mode = MBProgressHUDModeIndeterminate;
//                         hud.labelText = @"Signing In";
//                         
//                         [QBRequest logInWithUserLogin:self.usernameTextField.text password:self.passwordTextField.text successBlock:^(QBResponse *response, QBUUser *user) {
//                             //display successful login message
//                             //segway to splah Screen
//                             
//                             RGSUser *rgsUser = [user rgsUser];
//                             rgsUser.currentUser = [NSNumber numberWithBool:YES];
//                             rgsUser.password = self.passwordTextField.text;
//                             rgsUser.entityID = [NSNumber numberWithInteger:user.ID];
//                             
//                             [rgsUser.managedObjectContext MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
//                                 [[RGSChatService shared] loginUser:[rgsUser qbUser]  successBlock:^(BOOL success) {
//                                     if(success){
//                                         float delay = 1.1;
//                                         hud.mode = MBProgressHUDModeCustomView;
//                                         hud.labelText = @"Sign Successful";
//                                         [hud hide:YES afterDelay:delay];
//                                         [NSTimer bk_scheduledTimerWithTimeInterval:delay + 0.2 block:^(NSTimer *timer) {
//                                             [self performSegueWithIdentifier:@"unwindFromRegistrationScreenToSplashScreen" sender:self];
//                                             
//                                         } repeats:NO];
//                                     } else {
//                                         [hud hide:YES];
//                                         NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
//                                         [errorDetail setValue:@"Failed to login to QBChat" forKey:NSLocalizedFailureReasonErrorKey];
//                                         [errorDetail setValue:@"Couldn't complete login of user because there was a QBChat failure login." forKey:NSLocalizedDescriptionKey];
//                                         [self handleFatalError: @{LogReportLevelMain : [NSError errorWithDomain:RGSLoginErrorDomain code:ELTQB userInfo:errorDetail]}];
//                                     }
//                                 }];
//                             }];
//                         } errorBlock:^(QBResponse *response) {
//                             [hud hide:YES];
//                             NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
//                             [errorDetail setValue:@"error login to QBSystem" forKey:NSLocalizedFailureReasonErrorKey];
//                             [errorDetail setValue:@"Couldn't complete login of user because there was a QBSystem failure login." forKey:NSLocalizedDescriptionKey];
//                             ;
//                             [self handleFatalError: @{LogReportLevelMain : [NSError errorWithDomain:RGSLoginErrorDomain code:ELTQB userInfo:errorDetail], LogReportLevelSub : response.error.error}];
//                             
//                         }];
//                      } repeats:NO];
                     
            } else {
                [hud hide:YES];
                [self showAlertViewWithMeassage:@"Oops! Somebody already has that name. Give it another shot."];
            }
         }];
        } else {
            [self showshowAlertViewWithMeassage:@"Oops! That email is invalid. Give it another shot." cancelBlock:^{
                [self.emailTextField becomeFirstResponder];
            }];
        }
    } else {
        [self showAlertViewWithMeassage:@"Oops! Username or Password is invalid. Give it another shot."];
    }
}

-(void)showshowAlertViewWithMeassage:(NSString *)message cancelBlock:(void (^)(void))block{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"OKAY"
                                              otherButtonTitles:nil];
    [alertView bk_setCancelBlock:block];
    [alertView show];
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

-(void)keyboardWillChangeFrame:(NSNotification *)aNotification{
    
    NSDictionary* info = [aNotification userInfo];
    CGRect endFrame;
    [[info valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&endFrame];
    endFrame = [self.view convertRect:endFrame fromView:self.view];
    
    UIEdgeInsets bottomPadding = self.scrollView.contentInset;
    if(CGRectGetMinY(endFrame) < CGRectGetHeight(self.view.frame)){
        bottomPadding.bottom = CGRectGetHeight(self.view.frame) - CGRectGetMinY(endFrame) + 5;
    } else {
        bottomPadding.bottom = CGRectGetHeight(self.view.frame) - CGRectGetMinY(endFrame);
    }
   
    [UIView animateWithDuration:[[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                          delay:0
                        options:(([[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16) | UIViewAnimationOptionBeginFromCurrentState)
                     animations:^{
                         
                            self.scrollView.contentInset = bottomPadding;
                            self.scrollView.scrollIndicatorInsets = bottomPadding;
                     }
     
                     completion:nil];
}

- (void)keyboardDidHidden:(NSNotification*)aNotification
{
}


- (void)registerForKeyboardNotifications
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChangeFrame:)
                                                 name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHidden:)
                                                 name:UIKeyboardDidHideNotification object:nil];
    
}

- (void)deRegisterForKeyboardNotifications
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [center removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

- (void)dealloc {
    [self deRegisterForKeyboardNotifications];
}


@end
