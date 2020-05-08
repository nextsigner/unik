#include "unikqprocess.h"

UnikQProcess::UnikQProcess(QObject *parent) : QProcess(parent)
{
    connect(this, SIGNAL(readyReadStandardOutput()), this, SLOT(logOutProcess()));
    connect(this, SIGNAL(readyReadStandardError()), this, SLOT(logOutProcessErr()));
}

void UnikQProcess::run(const QByteArray cmd)
{
    run(cmd, false);
}

void UnikQProcess::run(const QByteArray cmd, bool detached)
{
    if(!detached){
         start(cmd);
    }else{
        startDetached(cmd);
    }
}

void UnikQProcess::logOutProcess()
{
    setLogData(this->readAll());
}
void UnikQProcess::logOutProcessErr()
{
    setLogData(this->readAllStandardError());
}


