//
//  MQTTManager.m
//  MQTTChat
//
//  Created by 高明 on 16/9/14.
//
//

#import "MQTTManager.h"
#import <MQTTClient.h>
#import <MQTTSessionManager.h>

static MQTTManager *manager = nil;

@interface MQTTManager()<MQTTSessionManagerDelegate>
@property (nonatomic, strong) MQTTSessionManager *sessionManager;
@end

@implementation MQTTManager

+ (instancetype)shareMQTTManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MQTTManager alloc] init];
    });
    return manager;
}

- (void)connectToHost
{
    if (!self.sessionManager) {
        self.sessionManager = [[MQTTSessionManager alloc] init];
        self.sessionManager.delegate = self;
        [self.sessionManager connectTo:@"192.168.10.19"
                             port:1883
                             tls:NO
                             keepalive:30
                             clean:NO
                             auth:false
                             user:nil
                             pass:nil
                             willTopic:nil
                             will:nil
                             willQos:0 //这个只能设置0 别的会连接不上 可能跟will设置NO有关
                             willRetainFlag:false
                             withClientId:nil];
    }else{
        [self.sessionManager connectToLast];
    }
    [self.sessionManager addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    switch (self.sessionManager.state) {
        case MQTTSessionManagerStateClosed:
            NSLog(@"关闭");
            break;
        case MQTTSessionManagerStateClosing:
            NSLog(@"关闭中");
            break;
        case MQTTSessionManagerStateConnected:
            NSLog(@"连接成功");
            [self.sessionManager connectToLast];
            break;
        case MQTTSessionManagerStateConnecting:
            NSLog(@"连接中");
            break;
        case MQTTSessionManagerStateError:
            NSLog(@"连接失败");
            [self.sessionManager connectToLast];
            break;
        case MQTTSessionManagerStateStarting:
        default:
            break;
    }
}

- (void)disconnectToHost
{
    [self.sessionManager disconnect];
}

- (void)handleMessage:(NSData *)data onTopic:(NSString *)topic retained:(BOOL)retained
{
    if ([_delegate respondsToSelector:@selector(receiveMessage:onTopic:retained:)]) {
        [_delegate receiveMessage:data onTopic:topic retained:retained];
    }
}

- (UInt16)subscribeToTopic:(NSString *)topic atLevel:(SubscribeTopicLevel)level
{
    return [self.sessionManager.session subscribeToTopic:topic atLevel:(UInt8)level subscribeHandler:^(NSError *error, NSArray<NSNumber *> *gQoss) {
        if (error) {
            NSLog(@"关注主题失败");
        }else{
            NSLog(@"关注主题成功");
        }
    }];
}

@end
