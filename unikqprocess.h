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
    Q_INVOKABLE void setLogData(const QString ld){
        logData=ld;
        emit logDataChanged();
    }
    Q_INVOKABLE QString getLogData(){
        return logData;
    }
//    Q_INVOKABLE void write(const QByteArray cmd){
//        this->write(cmd);
//    }
    Q_INVOKABLE bool upIsOpen(){
        return this->isOpen();
    }
    Q_INVOKABLE void upkill(){
        this->kill();
    }
//    Q_INVOKABLE void write(const QByteArray cmd){
//        this->write(cmd);
//    }
signals:
    void logDataChanged();
    void logOut(QString data);
public slots:
    Q_INVOKABLE void run(const QByteArray cmd);
    Q_INVOKABLE void run(const QByteArray cmd, bool detached);
    Q_INVOKABLE void run(const QByteArray cmd, const QStringList arguments, bool detached);
    Q_INVOKABLE void runWrite(const QByteArray cmd);

    void logOutProcess();
    void logOutProcessErr();
private:
};

#endif // UNIKQPROCESS_H
