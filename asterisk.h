#ifndef ASTERISK_H
#define ASTERISK_H

#include <QObject>
/*#include <iostream>
#include <asteriskcpp/Manager.hpp>
#include <asteriskcpp/manager/Actions.hpp>
#include "asteriskcpp/utils/LogHandler.h"
#include "asteriskcpp/manager/ManagerConnection.h"
using namespace asteriskcpp;*/

class Asterisk : public QObject
{
    Q_OBJECT
public:
    explicit Asterisk(QObject *parent = nullptr);



    /*void eventCallback(const asteriskcpp::ManagerEvent& me) {
        std::cout << "TEST EVENT START: " << me.getEventName() << std::endl;
        if (me.getEventName() == "NewChannel") {
            std::cout << "E - " << me.toString() << std::endl;
        }
        std::cout << "TEST EVENT: " << me.toLog() << std::endl;
    }*/

signals:

public slots:
    void test();
    //void eventCallback(ManagerEvent *me) {
        //std::cout << std::endl << "TEST:EVENT" << me.toLog() << std::endl;
    //}

private:
    //ManagerConnection *mc;
    //asteriskcpp *ast;



};

#endif // ASTERISK_H
