#include "recvthread.h"

RecvThread::RecvThread()
{

}

void RecvThread::run()
{
    QTcpSocket *client=new QTcpSocket;
    client->connectToHost(QHostAddress("47.102.221.64"), 5678);
}

void RecvThread::Delay_MSec(int msec)
{
       QEventLoop loop;//定义一个新的事件循环
       QTimer::singleShot(msec, &loop, SLOT(quit()));//创建单次定时器，槽函数为事件循环的退出函数
       loop.exec();//事件循环开始执行，程序会卡在这里，直到定时时间到，本循环被退出
}
