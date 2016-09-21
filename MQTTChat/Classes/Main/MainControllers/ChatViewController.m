//
//  ChatViewController.m
//  MQTTChat
//
//  Created by 高明 on 16/9/18.
//
//

#import "ChatViewController.h"
#import "MQTTManager.h"
#import "ChatViewCell.h"

@interface ChatViewController ()<UITableViewDelegate,UITableViewDataSource,MQTTManagerDelegate,UITextViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSMutableArray *sourceArr;
@property (nonatomic, strong) UIView *toolBar;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *sendBtn;
@end

@implementation ChatViewController

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIView *)toolBar
{
    if (!_toolBar) {
        _toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
        _toolBar.backgroundColor = [UIColor whiteColor];
    }
    return _toolBar;
}

- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, self.view.frame.size.width - 55, 40)];
        _textView.delegate = self;
        _textView.backgroundColor = [UIColor greenColor];
        _textView.layer.masksToBounds = YES;
        _textView.layer.cornerRadius = 5;
    }
    return _textView;
}

- (UIButton *)sendBtn
{
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendBtn setTitle:@"send" forState:UIControlStateNormal];
        _sendBtn.frame = CGRectMake(self.view.frame.size.width - 5 - 45, 5, 40, 40);
        [_sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _sendBtn;
}

- (NSMutableArray *)sourceArr
{
    if (!_sourceArr) {
        _sourceArr = [NSMutableArray array];
        [_sourceArr addObjectsFromArray:[NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5", nil]];
    }
    return _sourceArr;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"cell";
    ChatViewCell *chatCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!chatCell) {
        chatCell = [[ChatViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return chatCell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [(ChatViewCell *)cell setContentStr:self.sourceArr[indexPath.row]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.toolBar];
    [self.toolBar addSubview:self.textView];
    [self.toolBar addSubview:self.sendBtn];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"%@",[NSThread currentThread]);
        UInt16 result = [[MQTTManager shareMQTTManager] subscribeToTopic:[NSString stringWithFormat:@"%@/#",self.topicStr] atLevel:2];
        [MQTTManager shareMQTTManager].delegate = self;
        NSLog(@"%hu",result);
        NSLog(@"----");
    });
    NSLog(@"gogogogo");
}

- (void)receiveMessage:(NSData *)data onTopic:(NSString *)topic retained:(BOOL)retained
{
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"%@",dict);
    [self.sourceArr addObject:[dict objectForKey:@"message"]];
    [self.tableView reloadData];
}

- (void)keyboardWillAppear:(NSNotification *)noti
{
    NSDictionary *info = [noti userInfo];
    
    NSLog(@"%@",info);
    
    //取出动画时长
    
    CGFloat animationDuration = [[info valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    //取出键盘位置大小信息
    
    CGRect keyboardBounds = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
//    //rect转换
//    
//    CGRect keyboardRect = [self.view convertRect:keyboardBounds toView:nil];
    
    //记录Y轴变化
    
    CGFloat keyboardHeight = keyboardBounds.size.height;
    
    //上移动画options
    
    NSInteger options = [[info valueForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16;
    
    [UIView animateKeyframesWithDuration:animationDuration delay:0 options:options animations:^{
        CGRect frame = self.tableView.frame;
        frame.size.height -= keyboardHeight;
        self.tableView.frame = frame;
        
        CGRect toolBarFrame = self.toolBar.frame;
        toolBarFrame.origin.y -= keyboardHeight;
        self.toolBar.frame = toolBarFrame;
        
        if (self.tableView.contentSize.height > self.tableView.frame.size.height)
        {
            CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
            [self.tableView setContentOffset:offset animated:YES];
        }
        
    } completion:nil];
    
}

- (void)keyboardWillDisappear:(NSNotification *)noti
{
    NSDictionary *info = [noti userInfo];
    
    NSLog(@"%@",info);
    //取出动画时长
    
    CGFloat animationDuration = [[info valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    //下移动画options
    
    NSInteger options = [[info valueForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16;
    
    //回复动画
    
    [UIView animateKeyframesWithDuration:animationDuration delay:0 options:options animations:^{
        self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50);
        self.toolBar.frame = CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50);
    } completion:nil];
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    NSLog(@"开始输入");
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textView endEditing:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.toolBar.frame.origin.y < self.view.frame.size.height - 50) {
        [self.textView endEditing:YES];
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

@end
