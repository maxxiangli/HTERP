//
//  CRegisterViewController.m
//  HTERP
//
//  Created by li xiang on 2016/11/15.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "CRegisterViewController.h"
#import "CLoginSmsCodeParam.h"
#import "CLoginStateJSONRequestCommand.h"
#import "CATradeLoadingView.h"
#import "CAlertWaitingViewStyleOne.h"
#import "CLoginRegisterParam.h"
#import "IDCountDownButton.h"

@interface CRegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *verifyTextField;
@property (weak, nonatomic) IBOutlet UITextField *pswTextField;
@property (weak, nonatomic) IBOutlet UITextField *pswTwiceTextField;
@property (weak, nonatomic) IBOutlet IDCountDownButton *smsCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@end

@implementation CRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setDisplayCustomTitleText:[self typeStr]];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ( self.isRegister )
    {
        [self.registerBtn setTitle:@"注册" forState:UIControlStateNormal];
        [self.registerBtn setTitle:@"注册" forState:UIControlStateHighlighted];
    }
    else
    {
        [self.registerBtn setTitle:@"重置密码" forState:UIControlStateNormal];
        [self.registerBtn setTitle:@"重置密码" forState:UIControlStateHighlighted];
    }
    
    [self.phoneNumTextField addTarget:self action:@selector(phoneNumTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.verifyTextField addTarget:self action:@selector(verifyTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.pswTextField addTarget:self action:@selector(pswTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.pswTwiceTextField addTarget:self action:@selector(pswTwiceTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (NSString *)typeStr
{
    if ( self.isRegister )
    {
        return @"注册";
    }
    else
    {
        return @"重置密码";
    }
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

// 手机号码验证
- (BOOL)validateMobile:(NSString*)mobile
{
    // 手机号以1开头，10个 \d 数字字符
    NSString      *phoneRegex = @"^(1)\\d{10}$";
    NSPredicate   *phoneTest  = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    return [phoneTest evaluateWithObject:mobile];
}

#pragma mark -事件响应
- (void)phoneNumTextFieldDidChange:(id)sender
{
    if ( self.phoneNumTextField.text.length > 11 )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"手机号不能超过11位" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] ;
        [alert show];
        
        self.phoneNumTextField.text = [self.phoneNumTextField.text substringToIndex:11];
        return;
    }
}

- (void)verifyTextFieldDidChange:(id)sender
{
    if ( self.verifyTextField.text.length > 6 )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"验证码不能超过6位" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] ;
        [alert show];
        
        self.verifyTextField.text = [self.verifyTextField.text substringToIndex:6];
        return;
    }
}

- (void)pswTextFieldDidChange:(id)sender
{
    
}

- (void)pswTwiceTextFieldDidChange:(id)sender
{
}


- (IBAction)onClickSendCodeBtn:(id)sender
{
    CLoginSmsCodeParam *param = [[CLoginSmsCodeParam alloc] init];
    param.mobile = self.phoneNumTextField.text;
    
    __weak typeof(self) weakSelf = self;
    [CLoginStateJSONRequestCommand getWithParams:param modelClass:[CRequestJSONModelBase class] sucess:^(NSInteger code, NSString *msg, CJSONRequestCommand *requestCommand) {
        //关闭loading
        [CATradeLoadingView hideLoadingViewForView:weakSelf.view];
        
        if ( 0 == code )
        {
            [[[UIAlertView alloc] initWithTitle:@"验证码发送成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        }

    } failure:^(NSInteger code, NSString *msg, CJSONRequestCommand *requestCommand, NSError *dataParseError) {
        
    }];
}


- (IBAction)onClickRegisterBtn:(id)sender
{
    [self.view endEditing:YES];
    
    if ( ![self validateMobile:self.phoneNumTextField.text] )
    {
        [[[UIAlertView alloc] initWithTitle:@"手机号不可用" message:@"请输入有效的手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        return;
    }
    
    if ( self.verifyTextField.text.length < 6 )
    {
        [[[UIAlertView alloc] initWithTitle:nil message:@"验证码不能少于6位" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        return;
    }
    
    if ( self.pswTextField.text.length <= 0 )
    {
        [[[UIAlertView alloc] initWithTitle:nil message:@"请输入密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        return;
    }
    
    if ( ![self.pswTextField.text isEqualToString:self.pswTwiceTextField.text] )
    {
        [[[UIAlertView alloc] initWithTitle:nil message:@"两次密码输入不一样" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        return;
    }
    
    NSString *tipsStr = [self typeStr];
    
    CLoginRegisterParam *param = [[CLoginRegisterParam alloc] init];
    param.mobile = self.phoneNumTextField.text;
    param.passwd = self.pswTextField.text;
    
    [CATradeLoadingView showLoadingViewAddedTo:self.view];
    __weak typeof(self) weakSelf = self;
    [CLoginStateJSONRequestCommand getWithParams:param modelClass:[CLoginInforModel class] sucess:^(NSInteger code, NSString *msg, CJSONRequestCommand *requestCommand) {
        //关闭loading
        [CATradeLoadingView hideLoadingViewForView:weakSelf.view];
        
        //检测数据有效性
        CLoginInforModel *model = (CLoginInforModel *)requestCommand.responseModel;
        if ( ![model isKindOfClass:[CLoginInforModel class]] )
        {
            [[[CAlertWaitingViewStyleOne alloc] initFailMessage:[NSString stringWithFormat:@"%@失败", tipsStr] closeAfterDelay:0.3] show];
            return;
        }
        [[[CAlertWaitingViewStyleOne alloc] initSuccessMessage:[NSString stringWithFormat:@"%@成功", tipsStr] closeAfterDelay:0.3] show];
        
        //保存数据
        model.uin = param.mobile;
        [GLOBEL_LOGIN_OBJECT saveLoginData:model];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } failure:^(NSInteger code, NSString *msg, CJSONRequestCommand *requestCommand, NSError *dataParseError) {
        //关闭loading
        [CATradeLoadingView hideLoadingViewForView:weakSelf.view];
        
        CAlertWaitingViewStyleOne *alertView = [[CAlertWaitingViewStyleOne alloc] initFailMessage:[NSString stringWithFormat:@"%@失败", tipsStr] closeAfterDelay:0.3] ;
        [alertView show];
        
    }];
}
@end
