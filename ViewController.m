/
#import "ViewController.h"
#import "YQPOSTRequest.h"
#define kboundary @"boundary"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSString *urlStr = @"http://127.0.0.1/login/login.php";
//    NSDictionary *pram = @{@"username":@"zhangsan",@"password":@"zh"};
//    [[YQPOSTRequest sharedPOSTRequest] POSTRequestWithURLString:urlStr andDict:pram andSuccessBlock:^(NSData *data, NSURLResponse *response) {
//        
//      NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
//        
//    } andFalseBlock:^(NSError *error) {
//        
//        NSLog(@"%@",error);
//        
//    }];
//    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"%s",__func__);
    
      NSString *str = @"http://127.0.0.1/upload/upload-m.php";
    // NSString *filePath = @"/Users/cuiyongqin/Desktop/QQ.plist";
    
//    [[YQPOSTRequest sharedPOSTRequest] sendFileWithURLString:str KeyName:@"userfile" andFileName:@"123.plist" andFilePath:filePath];
    
    
        NSString *filePath1 = @"/Users/cuiyongqin/Sites/resources/videos/minion_03.png";
        NSString *filePath2 = @"/Users/cuiyongqin/Sites/resources/images/minion_01.png";
        NSString *filePath3 = @"/Users/cuiyongqin/Sites/resources/videos/minion_02.png";
    
    NSDictionary *fileDict = @{@"1":filePath1,@"2":filePath2,@"3":filePath3};
    NSDictionary *normalDict = @{@"username":@"san",@"pwd":@"yq",@"company":@"cast"};
    
    [[YQPOSTRequest sharedPOSTRequest] sendFilesWithURLString:str FileKey:@"userfile[ ]" andFileDict:fileDict andNormalParmaret:normalDict];
  
}


@end





















