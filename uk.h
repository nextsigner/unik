#ifndef UK_H
#define UK_H

#include <QObject>
//#include <QCoreApplication>
#include <QGuiApplication>
#include <QScreen>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickItem>


//Librerías Varias
#include <QTimer>
#include <QTextStream>
#include <QDir>
#include <QDirIterator>
#include <QFile>
#include <QDebug>
#include <QMimeDatabase>
#include <QPdfWriter>
#include <QPainter>
#include <QProcess>
#include <QSettings>
#include <QtWidgets/QDesktopWidget>

//Librerias Android
#ifdef Q_OS_ANDROID
#include <QtAndroidExtras/QtAndroid>
#include <QtAndroidExtras/QAndroidJniObject>
#endif

//Libreria QtQuick
#include <QQuickWindow>
#include <QQuickItemGrabResult>

//Librerías NetworkAccesManager
#include <QtNetwork/QNetworkInterface>
#include <QtNetwork/QNetworkAccessManager>
#include <QtNetwork/QNetworkRequest>
#include <QtNetwork/QNetworkReply>
#include <QtNetwork/QNetworkCacheMetaData>
#include <QtNetwork/QAbstractNetworkCache>
#include <QUrl>
#include <QUrlQuery>
#include <QEventLoop>

//Librerías Sqlite
#include <QtSql/QSqlDatabase>
#include <QtSql/QSqlError>
#include <QtSql/QSqlQuery>
#include <QtSql/QSqlRecord>

//Librerias Json
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonValue>
#include <QJsonArray>

#include <QDateTime>
#include <QStandardPaths>
#include <QThread>

#include "row.h"
#include "ukprocess.h"




//#include "uniksqlitecrypto.h"


//#include "frame.h"

//#include "definiciones.h"

/*class ROW : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QStringList fila READ getFila WRITE setFila)
public:
    explicit ROW(QObject *parent = nullptr);
    QStringList fila;
    void setFila(QStringList f){
        fila = f;
    }
    QStringList getFila(){
        return fila;
    }

};*/
//#define() = MY_DEFINE

class UK : public QObject
{
    Q_OBJECT
    //Q_PROPERTY(int porc READ getPorc WRITE setPorc NOTIFY porcChanged)
    Q_PROPERTY(int porc READ getPorc  NOTIFY porcChanged)
    Q_PROPERTY(QString uploadState READ getUploadState WRITE setUploadState NOTIFY uploadStateChanged)
    Q_PROPERTY(QString ukStd READ getUkStd() WRITE setUkStd NOTIFY ukStdChanged)
    Q_PROPERTY(QString stdErr READ getStdErr WRITE setStdErr NOTIFY stdErrChanged)
    Q_PROPERTY(bool runCL READ getRunCL WRITE setRunCL NOTIFY runCLChanged)
    Q_PROPERTY(bool debugLog READ getDebugLog WRITE setDebugLog NOTIFY debugLogChanged)
    Q_PROPERTY(QString initStdString READ getInitStdString WRITE setInitStdString)
public:
    explicit UK(QObject *parent = nullptr);
    ~UK();
    //static const QString dataVersion = QByteArrayLiteral(MY_DEFINE);
    QStringList uErrors;
    bool enabledInj;
    //Frame ukIPF;

    //Propiedades para QML
    int porc;
    QString uploadState;
    QString ukStd;
    QString stdErr;
    bool runCL;

    Q_INVOKABLE int getPorc(){
        return porc;
    }
    Q_INVOKABLE void setPorc(int p, int mode){
        porc = p;
        emit porcChanged();
        if(porc>0){
            QByteArray porcent;
            if(mode==0){
                porcent.append("downloaded ");
            }
            if(mode==1){
                porcent.append("uploaded ");
            }
            porcent.append("%");
            porcent.append(QString::number(porc));
            if(debugLog){
                log(porcent);
            }
        }
    }
    Q_INVOKABLE QString getUploadState(){
        return uploadState;
    }
    Q_INVOKABLE void setUploadState(QString us){
        uploadState = us;
        emit uploadStateChanged();
    }
    Q_INVOKABLE QString getUkStd(){
        return ukStd;
    }
    Q_INVOKABLE void setUkStd(const QString s){
        ukStd.clear();
        ukStd.append(s.toHtmlEscaped());
        ukStd.append("\n");
        /* QByteArray ls;
        ls.append(s);
        log(ls);*/
        emit ukStdChanged();
    }
    Q_INVOKABLE QString getStdErr(){
        return stdErr;
    }
    Q_INVOKABLE void setStdErr(QString s){
        stdErr = s;
        emit stdErrChanged();
    }
    Q_INVOKABLE QString getInitStdString(){
        return initStdString;
    }
    Q_INVOKABLE void setInitStdString(QString s){
        initStdString = s;
    }
    Q_INVOKABLE bool getRunCL(){
        return runCL;
    }
    Q_INVOKABLE void setRunCL(bool b){
        runCL = b;
        emit runCLChanged();
    }
    Q_INVOKABLE void setDebugLog(bool b){
        debugLog = b;
        emit debugLogChanged();
    }
    Q_INVOKABLE bool getDebugLog(){
        return debugLog;
    }
    Q_INVOKABLE void setHost(QString nh);
    Q_INVOKABLE QString host();

    QQmlApplicationEngine *_engine;
    void setEngine(QQmlApplicationEngine *e){
        _engine = e;
        //connect(_engine, SIGNAL(quit()), this, SLOT(engineQuited()));
    }
    QString inj;
    QString initStdString;
    bool debugLog=false;
    bool canCloseApp=false;
    bool splashClosed=false;

signals:
    //Señales para QML
    void porcChanged();
    void uploadStateChanged();
    void ukStdChanged();
    void stdErrChanged();
    void runCLChanged();
    void debugLogChanged();

public slots:
    void ukInit();
    void ukClose(QQuickCloseEvent *close);
    void engineExited(int n);
    void engineQuited(QObject*);

    //Funciones del OS
    int getScreenWidth();

    //Funciones del Sistema Unik
    void setWorkSpace(QString ws);
    void definirCarpetaTrabajo(QString et);
    void errorQML(QList<QQmlError> e);
    void loadQml(QByteArray url);
    void revInj();
    void initRecInj(int ms);
    //void setSRC(QString c);
    bool folderToUpk(QString folder, QString upkName, QString user, QString key, QString folderDestination);
    bool carpetaAUpk(QString carpeta, QString nombreUpk, QString usuario, QString clave, QString carpetaDestino);
    bool downloadRemoteFolder(QString urlFolder, QString list, QString dirDestination);
    bool instalarApp(QString appName, QString user, QString key, QString dirDestino);
    //bool extraerUpk(QString appName, QString origen, QString dirDestino, QString user, QString key);
    bool mkUpk(QByteArray folder, QByteArray upkName, QByteArray user, QByteArray key, QByteArray folderDestination);
    bool upkToFolder(QByteArray upk, QByteArray user, QByteArray key, QByteArray folderDestination);
    bool isFree(QString upk);
    bool loadUpk(QString upkLocation, bool closeAppLauncher, QString user, QString key);
    bool downloadGit(QByteArray url, QByteArray localFolder);
    bool inject(QString mainQml, QString inj);
    void restartApp();
    void restartApp(QString args);
    bool run(QString commandLine);
    void salidaRun();
    void salidaRunError();
    void finalizaRun(int e);
    void log(QByteArray d);
    void sleep(int ms);
    QString getPath(int path);
    QString encData(QByteArray d, QString user, QString key);
    QString decData(QByteArray d0, QString user, QString key);
    QQuickWindow *mainWindow(int n);
    void setProperty(const QString name, const QVariant &value);
    QVariant getProperty(const QString name);
    //void showLogView(QQuickItem * item);
    //void hideLogView(QQuickItem *item);

    //Funciones Imagen
    void itemToFrame(QQuickItem *item);
    void loadImageToFrame(const QByteArray url);

    //Funciones Network
    QByteArray getHttpFile(QByteArray url);
    void httpReadyRead();
    void startRequest(QUrl url);
    void fileGetError(QNetworkReply::NetworkError error);
    void httpFinished();
    bool downloadFile(QByteArray url, QByteArray ubicacion);
    bool downloadZipFile(QByteArray url, QByteArray ubicacion);
    void sendFile(QString file, QString phpReceiver);
    void uploadProgress(qint64 bytesSend, qint64 bytesTotal);
    void downloadProgress(qint64 bytesSend, qint64 bytesTotal);
    void sendFinished();

    //Funciones Sqlite
    bool sqliteInit(QString pathName);
    bool sqliteCryptoInit(QString pathName, QString user, QString key);
    bool sqlQuery(QString query);
    QString getJsonSql(QString table, QString query, QString type);
    QList<QObject *> getSqlData(QString table, QString query, QString type);
    bool mysqlInit(QString hostName, QString dataBaseName, QString userName, QString password, int firtOrSecondDB);
    void setMySqlDatabase(QString databaseName, int firtOrSecondDB);

    //Funciones de Sistema de Archivos
    void deleteFile(QByteArray f);
    bool setFile(QByteArray n, QByteArray d);
    QString getFile(QByteArray n);
    bool mkdir(const QString path);
    QString getUpkTempPath();
    QString getUpksLocalPath();
    bool fileExist(QByteArray fileName);
    void unZip(QString zip_filename , QString filename);
    bool createLink(QString location, QString name);

    //Funciones Varias
    QString toHtmlEscaped(QString htmlCode);
    void crearPDF(QString captura, QString url, int orientacion);

#ifdef Q_OS_WIN
    int frameHeight(QObject *window);
    int frameWidth(QObject *window);
#endif

private slots:
    QString encPrivateData(QByteArray d, QString user, QString key);
    QString decPrivateData(QByteArray d0, QString user, QString key);

    QString compData(QString d);
    QString desCompData(QString d);

    bool unpackUpk(QString upk, QString user, QString key, QString folderDestination, QString appName);
    void descZip();
    void downloadZipProgress(qint64 bytesSend, qint64 bytesTotal);

private:

    QSqlDatabase db;
    QSqlDatabase firstDB;
    QSqlDatabase secondDB;
    QStringList lsim;//=QStringList()<<"g"<<"h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z";
    QStringList lnum;//=QStringList("11,33,66,77,88,99,20,30,40,60,70,80,90,12,21,57,82,92,84,72");
    QByteArray lba;
    QTimer *cinj;
    QString h;

    //UnikSqliteCrypto dbc;

   bool doResume;
   bool httpRequestAborted;
   bool retried;
   int bytesWritten;
   QNetworkReply *reply2;
   QNetworkAccessManager *qnam;
   QFile *file;
   QByteArray dzip;

    //QQuickItem itemLogView;

    QProcess *proc;

    QNetworkReply *respuentaSendDatos;
    QImage *frame;
};
#endif
