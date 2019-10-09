#include "unikqprocess.h"

UnikQProcess::UnikQProcess(QObject *parent) : QProcess(parent)
{
    connect(this, SIGNAL(readyReadStandardOutput()), this, SLOT(logOutProcess()));
    connect(this, SIGNAL(readyReadStandardError()), this, SLOT(logOutProcess()));
}

void UnikQProcess::run(const QByteArray cmd)
{
    start(cmd);
}

void UnikQProcess::logOutProcess()
{
    setLogData(this->readAll());
}

void UnikQProcess::setItem(QQuickItem *item)
{
    emit logOut("asdsaff---------------------------------");
}

/*void UnikQProcess::logData()
{
    emit logOut("asdsaff---------------------------------");
    qDebug()<<this->readAll();
}*/
