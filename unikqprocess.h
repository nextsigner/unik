#ifndef UNIKQPROCESS_H
#define UNIKQPROCESS_H

#include <QObject>
#include <QProcess>
#include <QtQuick/QQuickItem>
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

signals:
    void logDataChanged();
    void logOut(QString data);
public slots:
    Q_INVOKABLE void run(const QByteArray cmd);
    void logOutProcess();
    void setItem(QQuickItem *item);
private:
    QQuickItem *item;
};

#endif // UNIKQPROCESS_H
