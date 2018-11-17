#include "unikargsproc.h"

UnikArgsProc::UnikArgsProc(QObject *parent) : QObject(parent)
{
    qInfo()<<"\n\n\nUAP: init... ";
    dp = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
    qInfo()<<"UAP: Prepare WorkSpace...";
    if(settings.value("ws").toString().isEmpty()){
        settings.setValue("ws", dp.toUtf8()+"/unik");
        ws=dp.toUtf8()+"/unik";
        qInfo()<<"UAP WorkSpace by default: "<<ws;
    }else{
        qInfo()<<"Current WorkSpace: "<<settings.value("ws").toString().toUtf8();
        QFileInfo fi(settings.value("ws").toString().toUtf8());
        if(!fi.isWritable()){
            QString ndulw;
            ndulw.append(QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation));
            ndulw.append("/unik");
            ws = ndulw;
            qInfo()<<"WorkSpace not writable!";
            qInfo("New WorkSpace seted: "+ndulw.toUtf8());
        }else{
            ws = settings.value("ws").toString().toUtf8();
        }
    }
    qInfo()<<"UAP: WorkSpace defined as "<<ws;
    // init();
}

void UnikArgsProc::init()
{
    if(args.length()>2){
        procArgs();
    }else{
        procCfgArgs();
    }
    qInfo()<<"UAP finished. "<<ws<<"\n\n\n";
}

void UnikArgsProc::procArgs()
{
    qInfo()<<"UAP: Procesing applications argumets... "<<args;
}

void UnikArgsProc::procCfgArgs()
{
    qInfo()<<"UAP: Procesing cfg argumets... ";
    bool loadConfig=false;
    QString tcfgp=ws.toUtf8()+"/temp_cfg.json";
    QString cfgp;
    qInfo()<<"UAP: Checking temp config file "<<tcfgp;
    QFile tcfgf(tcfgp);
    if(tcfgf.exists()){
       qInfo()<<"UAP: Temp config file detected.";
        loadConfig=true;
        cfgp.append(tcfgp);
    }else{
        cfgp.append(tcfgp.replace("temp_cfg", "cfg"));
        qInfo()<<"UAP: Temp config file not detected.";
        qInfo()<<"UAP: Checking config file "<<cfgp;
        QFile cfgf(cfgp);
        if(cfgf.exists()){
             loadConfig=true;
        }else{
            QByteArray dc;
            dc.append("{\n");

            dc.append("{\"arg0\":\"");
            dc.append("-folder=");
            dc.append(ws);
#ifndef Q_OS_ANDROID
            dc.append("/unik-tools");
#else
            dc.append("/qmlandia");
#endif
            dc.append("\"");

            dc.append("}\n");
            if(cfgf.open(QIODevice::WriteOnly)){
                cfgf.write(dc);
                cfgf.close();
                qInfo()<<"UAP: Making cfg.json  "<<cfgp<<" code: "<<dc;
            }else{
                qInfo()<<"UAP: Error! cfg.json not exist "<<cfgp;
            }
        }
    }
    if(loadConfig){
        qInfo()<<"UAP: Loading config file "<<cfgp;
        QByteArray  jsonConfigData;
        QFile jsonConfig(cfgp);
        if(jsonConfig.open(QIODevice::ReadOnly)){
            jsonConfigData.append(jsonConfig.readAll());
            QJsonDocument docConf = QJsonDocument::fromJson(jsonConfigData.constData());
            QJsonObject raizConf = docConf.object();
            int cantArgs=raizConf.count();
            if(cantArgs>0){
                args.clear();
                for (int i = 0; i < cantArgs; ++i) {
                    QByteArray nom="arg";
                    nom.append(QString::number(i));
                    args.append(raizConf.value(nom.constData()).toString());
                }
            }
            jsonConfig.close();
            if(cfgp.contains("temp_")){
                jsonConfig.remove();
            }
            qInfo()<<"UAP Arguments from cfg config: "<<cantArgs;
            qInfo()<<"UAP Cfg Arguments config: "<<args;
            /*if(raizConf.value("appName").toString()!=""){
                appName.append(raizConf.value("appName").toString());
            }*/
        }
    }
}
