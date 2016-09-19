//
//  KTabBarController.m
//  MQTTChat
//
//  Created by 高明 on 16/9/13.
//
//

#import "KTabBarController.h"
#import "MainViewController.h"
#import "GroupChatViewController.h"
#import "FriendsViewController.h"
#import "UsersViewController.h"

@interface KTabBarController ()

@end

@implementation KTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     
    NSArray *titleArr = [NSArray arrayWithObjects:@"首页",@"群聊",@"好友",@"我", nil];
    NSArray *iconArr = [NSArray arrayWithObjects:@"tabbar_icon_reader_",@"tabbar_icon_news_",@"tabbar_icon_media_",@"tabbar_icon_me_", nil];
    
    MainViewController *main = [[MainViewController alloc] init];
    UINavigationController *mainNc = [self controller:main title:titleArr[0] icon:iconArr[0]];
    
    GroupChatViewController *groupChat = [[GroupChatViewController alloc] init];
    UINavigationController *groupChatNc = [self controller:groupChat title:titleArr[1] icon:iconArr[1]];
    
    FriendsViewController *friends = [[FriendsViewController alloc] init];
    UINavigationController *friendsNc = [self controller:friends title:titleArr[2] icon:iconArr[2]];
    
    UsersViewController *users = [[UsersViewController alloc] init];
    UINavigationController *usersNc = [self controller:users title:titleArr[3] icon:iconArr[3]];
    
    self.viewControllers = @[mainNc,groupChatNc,friendsNc,usersNc];
    
}

- (UINavigationController *)controller:(UIViewController *)rootVc title:(NSString *)title icon:(NSString *)iconName
{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootVc];
    [nav.navigationBar setBarTintColor:[UIColor blackColor]];
//    [nav.navigationBar setTintColor:[UIColor blackColor]];
    nav.tabBarItem.title = title;
    [nav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]}  forState:UIControlStateSelected];
    [nav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}  forState:UIControlStateNormal];
    nav.tabBarItem.image = [[UIImage imageNamed:[NSString stringWithFormat:@"%@normal",iconName]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav.tabBarItem.selectedImage = [[UIImage imageNamed:[NSString stringWithFormat:@"%@highlight",iconName]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return nav;
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
