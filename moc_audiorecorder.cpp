/****************************************************************************
** Meta object code from reading C++ file 'audiorecorder.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.14.2)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include <memory>
#include "audiorecorder.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'audiorecorder.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.14.2. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_AudioRecorder_t {
    QByteArrayData data[16];
    char stringdata0[216];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_AudioRecorder_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_AudioRecorder_t qt_meta_stringdata_AudioRecorder = {
    {
QT_MOC_LITERAL(0, 0, 13), // "AudioRecorder"
QT_MOC_LITERAL(1, 14, 8), // "recorded"
QT_MOC_LITERAL(2, 23, 0), // ""
QT_MOC_LITERAL(3, 24, 9), // "audioFile"
QT_MOC_LITERAL(4, 34, 13), // "processBuffer"
QT_MOC_LITERAL(5, 48, 12), // "QAudioBuffer"
QT_MOC_LITERAL(6, 61, 17), // "setOutputLocation"
QT_MOC_LITERAL(7, 79, 11), // "togglePause"
QT_MOC_LITERAL(8, 91, 12), // "toggleRecord"
QT_MOC_LITERAL(9, 104, 12), // "updateStatus"
QT_MOC_LITERAL(10, 117, 22), // "QMediaRecorder::Status"
QT_MOC_LITERAL(11, 140, 14), // "onStateChanged"
QT_MOC_LITERAL(12, 155, 21), // "QMediaRecorder::State"
QT_MOC_LITERAL(13, 177, 14), // "updateProgress"
QT_MOC_LITERAL(14, 192, 3), // "pos"
QT_MOC_LITERAL(15, 196, 19) // "displayErrorMessage"

    },
    "AudioRecorder\0recorded\0\0audioFile\0"
    "processBuffer\0QAudioBuffer\0setOutputLocation\0"
    "togglePause\0toggleRecord\0updateStatus\0"
    "QMediaRecorder::Status\0onStateChanged\0"
    "QMediaRecorder::State\0updateProgress\0"
    "pos\0displayErrorMessage"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_AudioRecorder[] = {

 // content:
       8,       // revision
       0,       // classname
       0,    0, // classinfo
       9,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       1,       // signalCount

 // signals: name, argc, parameters, tag, flags
       1,    1,   59,    2, 0x06 /* Public */,

 // slots: name, argc, parameters, tag, flags
       4,    1,   62,    2, 0x0a /* Public */,
       6,    0,   65,    2, 0x0a /* Public */,
       7,    0,   66,    2, 0x0a /* Public */,
       8,    0,   67,    2, 0x0a /* Public */,
       9,    1,   68,    2, 0x0a /* Public */,
      11,    1,   71,    2, 0x0a /* Public */,
      13,    1,   74,    2, 0x0a /* Public */,
      15,    0,   77,    2, 0x0a /* Public */,

 // signals: parameters
    QMetaType::Void, QMetaType::QString,    3,

 // slots: parameters
    QMetaType::Void, 0x80000000 | 5,    2,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void, 0x80000000 | 10,    2,
    QMetaType::Void, 0x80000000 | 12,    2,
    QMetaType::Void, QMetaType::LongLong,   14,
    QMetaType::Void,

       0        // eod
};

void AudioRecorder::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        auto *_t = static_cast<AudioRecorder *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: _t->recorded((*reinterpret_cast< QString(*)>(_a[1]))); break;
        case 1: _t->processBuffer((*reinterpret_cast< const QAudioBuffer(*)>(_a[1]))); break;
        case 2: _t->setOutputLocation(); break;
        case 3: _t->togglePause(); break;
        case 4: _t->toggleRecord(); break;
        case 5: _t->updateStatus((*reinterpret_cast< QMediaRecorder::Status(*)>(_a[1]))); break;
        case 6: _t->onStateChanged((*reinterpret_cast< QMediaRecorder::State(*)>(_a[1]))); break;
        case 7: _t->updateProgress((*reinterpret_cast< qint64(*)>(_a[1]))); break;
        case 8: _t->displayErrorMessage(); break;
        default: ;
        }
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        switch (_id) {
        default: *reinterpret_cast<int*>(_a[0]) = -1; break;
        case 5:
            switch (*reinterpret_cast<int*>(_a[1])) {
            default: *reinterpret_cast<int*>(_a[0]) = -1; break;
            case 0:
                *reinterpret_cast<int*>(_a[0]) = qRegisterMetaType< QMediaRecorder::Status >(); break;
            }
            break;
        case 6:
            switch (*reinterpret_cast<int*>(_a[1])) {
            default: *reinterpret_cast<int*>(_a[0]) = -1; break;
            case 0:
                *reinterpret_cast<int*>(_a[0]) = qRegisterMetaType< QMediaRecorder::State >(); break;
            }
            break;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        {
            using _t = void (AudioRecorder::*)(QString );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&AudioRecorder::recorded)) {
                *result = 0;
                return;
            }
        }
    }
}

QT_INIT_METAOBJECT const QMetaObject AudioRecorder::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_meta_stringdata_AudioRecorder.data,
    qt_meta_data_AudioRecorder,
    qt_static_metacall,
    nullptr,
    nullptr
} };


const QMetaObject *AudioRecorder::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *AudioRecorder::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_AudioRecorder.stringdata0))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int AudioRecorder::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 9)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 9;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 9)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 9;
    }
    return _id;
}

// SIGNAL 0
void AudioRecorder::recorded(QString _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 0, _a);
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
