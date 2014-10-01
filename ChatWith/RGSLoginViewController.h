//
//  RGSLoginViewController.h
//  ChatWith
//
//  Created by PC on 4/14/14.
//  Copyright (c) 2014 Randel Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RGSLoginViewController;

@protocol LoginViewControllerDelegate <NSObject>
-(void)loginViewController:(RGSLoginViewController *)loginViewController registerUsername:(NSString *)username password:(NSString *)password;
-(void)loginViewController:(RGSLoginViewController *)loginViewController loginUsername:(NSString *)username password:(NSString *)password;

@end

@interface RGSLoginViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIView      *loginView;
@property (nonatomic, weak  ) IBOutlet UITextField *userNameTextField;
@property (nonatomic, weak  ) IBOutlet UITextField *userPasswordTextField;

@property (nonatomic, strong) IBOutlet UIView      *registrationView;
@property (nonatomic, weak  ) IBOutlet UITextField *regUserNameTextField;
@property (nonatomic, weak  ) IBOutlet UITextField *regUserPasswordTextField;

@property (nonatomic, weak)id <LoginViewControllerDelegate> delegate;
@property (nonatomic, strong)Class alertViewClass;

-(IBAction)loginUser:(id)sender;
-(IBAction)registerUser:(id)sender;





-(void)moveUp;
@end

