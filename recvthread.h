#ifndef RECVTHREAD_H
#define RECVTHREAD_H

#include <QThread>
#include <QtNetwork>
#include <QTimer>

class RecvThread : public QThread
{
    Q_OBJECT
public:
    RecvThread();
    void Delay_MSec(int msec);
protected:
    void run();
};

#endif // RECVTHREAD_H
