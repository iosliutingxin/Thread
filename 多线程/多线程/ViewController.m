//
//  ViewController.m
//  多线程
//
//  Created by 李孔文 on 2018/4/27.
//  Copyright © 2018年 Sunning. All rights reserved.
//

#import "ViewController.h"
#import <pthread.h>
@interface ViewController ()

@property(nonatomic ,assign)int ticks;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _ticks = 20;
    [self beginThread];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
        //设备系统为IOS 10.0或者以上的
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }else{
        //设备系统为IOS 10.0以下的
        [[UIApplication sharedApplication] openURL:url];
    }
    //    [self saleTickets];
}

//耗时操作
-(void)test01{
    
    for (int i = 0; i < 50000; i ++) {
        NSLog(@"%d",i);
        NSLog(@"当前线程 %@",[NSThread currentThread]);
    }
    
   
}
/*
 在ios真正的多线程技术是Pthread 和 NSThread
 GCD ,NSoperation 并发技术
 
 注意：
 多线程的开发中不要相信一次线程的执行结果
 
 返回值：
 1、如果为0，则表示正确
 2、如果为非0，则表示错误
 
 __bridge
 早ARC开发中，涉及到和C语言中相同的数据类型转换，需要用到__bridge “桥接” 进行内存管理
 
 void *      (*)        (void *)
 返回值    （函数指针）    （参数）
 void *    和oc中的id   是等价的
 
 **/

#pragma pthread
-(void)pthreadTest01{
    
    pthread_t threadId;
    NSString *str = @"hello world";
    int result = pthread_create(&threadId, NULL, &demo, (__bridge void *)(str));
    if (result == 0) {
        NSLog(@"正确");
    }else{
        NSLog(@"错误");
    }
}

//c语言函数
void *demo(void *param){
    NSLog(@"当前线程%@",[NSThread currentThread]);
    return NULL;
}

#pragma NSThread
-(void)thread01{
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(threadFunction01:) object:@"hello world"];
    [thread start];
}

-(void)thread02{
    
    [NSThread detachNewThreadSelector:@selector(threadFunction01:) toTarget:self withObject:@"hello world"];
}

-(void)thread03{
    
    [self performSelectorInBackground:@selector(threadFunction01:) withObject:self];
}

-(void)threadFunction01:(id)object{
    
    NSLog(@"thread--->当前线程%@",[NSThread currentThread]);

    
}
-(void)thread04{
    
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(thread4Demo:) object:@"hello world"];
    //线程添加名称
    thread.name = @"thread04Name A";
    [thread start];
}

-(void)thread4Demo {
    for (int i = 0 ; i < 2 ; i++) {
        NSLog(@"thread4Demo===%@",[NSThread currentThread]);
    }
     //模拟崩溃
    NSMutableArray *arr = [NSMutableArray array];
//    [arr addObject:nil];
}

#pragma 互斥锁
//售票系统

-(void)saleTickets{

    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(saleTicketDemo) object:@"hello world"];
    //线程添加名称
    thread.name = @"thread04Name A";
    [thread start];
    
    NSThread *thread02 = [[NSThread alloc]initWithTarget:self selector:@selector(saleTicketDemo) object:@"hello world"];
    //线程添加名称
    thread.name = @"thread04Name B";
    [thread02 start];

}


-(void)saleTicketDemo{
    //循环
    while (YES) {
        //互斥锁---保证锁内的代码同一时间只有一条线程执行 --范围经历小
        //self参数可以为任意oc对象，一般用self
        @synchronized (self){
            [NSThread sleepForTimeInterval:1.0];

            if(_ticks > 0 ){
                
                _ticks --;
                NSLog(@"当前剩余===%d,当前线程 %@",_ticks,[NSThread currentThread]);
            }else{
                
                NSLog(@"卖完了,当前线程%@",[NSThread currentThread]);
                //跳出循环
                break;
                
            }
        }
       
    }
    
}

//线程间通信
-(void)beginThread{
    
    [self performSelectorInBackground:@selector(doweloadImage) withObject:nil];
}

-(void)doweloadImage{
    
    NSURL *url = [NSURL URLWithString:@"https://ss1.baidu.com/-4o3dSag_xI4khGko9WTAnF6hhy/image/h%3D300/sign=6dfd006c5e66d01661199828a72ad498/8601a18b87d6277fca09b19924381f30e924fc7c.jpg"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    [self performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage imageWithData:data] waitUntilDone:NO];

}

-(void)mainUI{
    
    //    [self performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage imageWithData:NSData] waitUntilDone:NO];
    
}
//更新UI
-(void)setImage:(UIImage *)image{
    
    
}

//runloop














@end
