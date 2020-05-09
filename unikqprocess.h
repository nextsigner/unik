#ifndef UNIKQPROCESS_H
#define UNIKQPROCESS_H

#include <QObject>
#include <QProcess>
#include <QDebug>

class UnikQProcess : public QProcess
{
    Q_OBJECT
    Q_PROPERTY(QString logData READ getLogData WRITE setLogData NOTIFY logDataChanged)
public:
    explicit UnikQProcess(QObject *parent = nullptr);
    QString logData;
    void setLogData(const QString ld){
        logData=ld;
        emit logDataChanged();
    }
    QString getLogData(){
        return logData;
    }
    Q_INVOKABLE bool upIsOpen(){
        return this->isOpen();
    }
    Q_INVOKABLE void upkill(){
        this->kill();
    }
signals:
    void logDataChanged();
    void logOut(QString data);
public slots:
    Q_INVOKABLE void run(const QByteArray cmd);
    Q_INVOKABLE void run(const QByteArray cmd, bool detached);

    void logOutProcess();
    void logOutProcessErr();
private:    
};

#endif // UNIKQPROCESS_H
