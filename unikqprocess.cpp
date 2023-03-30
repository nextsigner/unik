#include "unikqprocess.h"

UnikQProcess::UnikQProcess(QObject *parent) : QProcess(parent)
{
    //setOpenMode(QProcess::);
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

void UnikQProcess::run(const QByteArray cmd, const QStringList arguments, bool detached)
{
    if(!detached){
         start(cmd, arguments);
    }else{
        startDetached(cmd, arguments);
    }
}

void UnikQProcess::runWrite(const QByteArray cmd)
{
    QByteArray c="";
    c.append(cmd);
    c.append("\n");
    write(c);
}

void UnikQProcess::logOutProcess()
{
    setLogData(this->readAll());
}
void UnikQProcess::logOutProcessErr()
{
    setLogData(this->readAllStandardError());
}


