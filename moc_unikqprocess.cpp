/****************************************************************************
** Meta object code from reading C++ file 'unikqprocess.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.14.2)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include <memory>
#include "unikqprocess.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'unikqprocess.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.14.2. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_UnikQProcess_t {
    QByteArrayData data[18];
    char stringdata0[157];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_UnikQProcess_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_UnikQProcess_t qt_meta_stringdata_UnikQProcess = {
    {
QT_MOC_LITERAL(0, 0, 12), // "UnikQProcess"
QT_MOC_LITERAL(1, 13, 14), // "logDataChanged"
QT_MOC_LITERAL(2, 28, 0), // ""
QT_MOC_LITERAL(3, 29, 6), // "logOut"
QT_MOC_LITERAL(4, 36, 4), // "data"
QT_MOC_LITERAL(5, 41, 3), // "run"
QT_MOC_LITERAL(6, 45, 3), // "cmd"
QT_MOC_LITERAL(7, 49, 8), // "detached"
QT_MOC_LITERAL(8, 58, 9), // "arguments"
QT_MOC_LITERAL(9, 68, 8), // "runWrite"
QT_MOC_LITERAL(10, 77, 13), // "logOutProcess"
QT_MOC_LITERAL(11, 91, 16), // "logOutProcessErr"
QT_MOC_LITERAL(12, 108, 10), // "setLogData"
QT_MOC_LITERAL(13, 119, 2), // "ld"
QT_MOC_LITERAL(14, 122, 10), // "getLogData"
QT_MOC_LITERAL(15, 133, 8), // "upIsOpen"
QT_MOC_LITERAL(16, 142, 6), // "upkill"
QT_MOC_LITERAL(17, 149, 7) // "logData"

    },
    "UnikQProcess\0logDataChanged\0\0logOut\0"
    "data\0run\0cmd\0detached\0arguments\0"
    "runWrite\0logOutProcess\0logOutProcessErr\0"
    "setLogData\0ld\0getLogData\0upIsOpen\0"
    "upkill\0logData"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_UnikQProcess[] = {

 // content:
       8,       // revision
       0,       // classname
       0,    0, // classinfo
      12,   14, // methods
       1,  104, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       2,       // signalCount

 // signals: name, argc, parameters, tag, flags
       1,    0,   74,    2, 0x06 /* Public */,
       3,    1,   75,    2, 0x06 /* Public */,

 // slots: name, argc, parameters, tag, flags
       5,    1,   78,    2, 0x0a /* Public */,
       5,    2,   81,    2, 0x0a /* Public */,
       5,    3,   86,    2, 0x0a /* Public */,
       9,    1,   93,    2, 0x0a /* Public */,
      10,    0,   96,    2, 0x0a /* Public */,
      11,    0,   97,    2, 0x0a /* Public */,

 // methods: name, argc, parameters, tag, flags
      12,    1,   98,    2, 0x02 /* Public */,
      14,    0,  101,    2, 0x02 /* Public */,
      15,    0,  102,    2, 0x02 /* Public */,
      16,    0,  103,    2, 0x02 /* Public */,

 // signals: parameters
    QMetaType::Void,
    QMetaType::Void, QMetaType::QString,    4,

 // slots: parameters
    QMetaType::Void, QMetaType::QByteArray,    6,
    QMetaType::Void, QMetaType::QByteArray, QMetaType::Bool,    6,    7,
    QMetaType::Void, QMetaType::QByteArray, QMetaType::QStringList, QMetaType::Bool,    6,    8,    7,
    QMetaType::Void, QMetaType::QByteArray,    6,
    QMetaType::Void,
    QMetaType::Void,

 // methods: parameters
    QMetaType::Void, QMetaType::QString,   13,
    QMetaType::QString,
    QMetaType::Bool,
    QMetaType::Void,

 // properties: name, type, flags
      17, QMetaType::QString, 0x00495103,

 // properties: notify_signal_id
       0,

       0        // eod
};

void UnikQProcess::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        auto *_t = static_cast<UnikQProcess *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: _t->logDataChanged(); break;
        case 1: _t->logOut((*reinterpret_cast< QString(*)>(_a[1]))); break;
        case 2: _t->run((*reinterpret_cast< const QByteArray(*)>(_a[1]))); break;
        case 3: _t->run((*reinterpret_cast< const QByteArray(*)>(_a[1])),(*reinterpret_cast< bool(*)>(_a[2]))); break;
        case 4: _t->run((*reinterpret_cast< const QByteArray(*)>(_a[1])),(*reinterpret_cast< const QStringList(*)>(_a[2])),(*reinterpret_cast< bool(*)>(_a[3]))); break;
        case 5: _t->runWrite((*reinterpret_cast< const QByteArray(*)>(_a[1]))); break;
        case 6: _t->logOutProcess(); break;
        case 7: _t->logOutProcessErr(); break;
        case 8: _t->setLogData((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 9: { QString _r = _t->getLogData();
            if (_a[0]) *reinterpret_cast< QString*>(_a[0]) = std::move(_r); }  break;
        case 10: { bool _r = _t->upIsOpen();
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = std::move(_r); }  break;
        case 11: _t->upkill(); break;
        default: ;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        {
            using _t = void (UnikQProcess::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&UnikQProcess::logDataChanged)) {
                *result = 0;
                return;
            }
        }
        {
            using _t = void (UnikQProcess::*)(QString );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&UnikQProcess::logOut)) {
                *result = 1;
                return;
            }
        }
    }
#ifndef QT_NO_PROPERTIES
    else if (_c == QMetaObject::ReadProperty) {
        auto *_t = static_cast<UnikQProcess *>(_o);
        Q_UNUSED(_t)
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast< QString*>(_v) = _t->getLogData(); break;
        default: break;
        }
    } else if (_c == QMetaObject::WriteProperty) {
        auto *_t = static_cast<UnikQProcess *>(_o);
        Q_UNUSED(_t)
        void *_v = _a[0];
        switch (_id) {
        case 0: _t->setLogData(*reinterpret_cast< QString*>(_v)); break;
        default: break;
        }
    } else if (_c == QMetaObject::ResetProperty) {
    }
#endif // QT_NO_PROPERTIES
}

QT_INIT_METAOBJECT const QMetaObject UnikQProcess::staticMetaObject = { {
    QMetaObject::SuperData::link<QProcess::staticMetaObject>(),
    qt_meta_stringdata_UnikQProcess.data,
    qt_meta_data_UnikQProcess,
    qt_static_metacall,
    nullptr,
    nullptr
} };


const QMetaObject *UnikQProcess::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *UnikQProcess::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_UnikQProcess.stringdata0))
        return static_cast<void*>(this);
    return QProcess::qt_metacast(_clname);
}

int UnikQProcess::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QProcess::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 12)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 12;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 12)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 12;
    }
#ifndef QT_NO_PROPERTIES
    else if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 1;
    } else if (_c == QMetaObject::QueryPropertyDesignable) {
        _id -= 1;
    } else if (_c == QMetaObject::QueryPropertyScriptable) {
        _id -= 1;
    } else if (_c == QMetaObject::QueryPropertyStored) {
        _id -= 1;
    } else if (_c == QMetaObject::QueryPropertyEditable) {
        _id -= 1;
    } else if (_c == QMetaObject::QueryPropertyUser) {
        _id -= 1;
    }
#endif // QT_NO_PROPERTIES
    return _id;
}

// SIGNAL 0
void UnikQProcess::logDataChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void UnikQProcess::logOut(QString _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 1, _a);
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
