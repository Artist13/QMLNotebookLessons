#include "Headers/qmldatamapper.h"
#include <QDataWidgetMapper>


/*
    Mapping - объект (поле ввода/вывода в форме редактирования)
    updateMapping - подтягивает данные из базы и заполняет форму

    Для чего currentIndex?

*/
struct Mapping{
    QPointer <QObject> object;
    int section;
    QByteArray propertyName;
};

class QmlDataMapperPrivate
{
public:
    QmlDataMapperPrivate() : m_model(0), m_currentIndex(-1)
    {

    }

    void updateMapping(Mapping &mapping, QObject *object, const int &section, const QByteArray &propertyName);
    void clear();
    void update();
    QAbstractItemModel * m_model;
    QVector<Mapping> m_mappings;
    int m_currentIndex;
};

void QmlDataMapperPrivate::updateMapping(Mapping &mapping, QObject *object, const int &section, const QByteArray &propertyName)
{
    mapping.object = object;
    mapping.section = section;
    mapping.propertyName = (propertyName.isEmpty() ? "text" : propertyName);
}

void QmlDataMapperPrivate::update()
{
    if(!m_model)
    {
        //qDebug() << "Current model is Empty";
        return;
    }

    if(m_mappings.isEmpty())
    {
        //qDebug() << "Current mapping is Empty";
        return;
    }

    if(m_currentIndex == -1)
    {
        return;
        //qDebug() << "Current index is -1";
    }

    foreach(const Mapping &mapping, m_mappings)
    {
        if(mapping.object)
        {
            //Сбрасывает данные на те, которые хранятся в бд??
            mapping.object->setProperty(mapping.propertyName, m_model->data(m_model->index(m_currentIndex, 0), mapping.section));
        }
    }
}

void QmlDataMapperPrivate::clear()
{
    if(!m_model)
        return;

    if(m_mappings.isEmpty())
        return;

    if(m_currentIndex == -1)
        return;

    foreach(const Mapping &mapping, m_mappings)
    {
        if(mapping.object)
        {
            mapping.object->setProperty(mapping.propertyName, "");
        }
    }
}



QmlDataMapper::QmlDataMapper(QObject *parent) : QObject(parent), d(new QmlDataMapperPrivate())
{

}

QmlDataMapper::~QmlDataMapper()
{
    delete d;
}

void QmlDataMapper::addMapping(QObject *object, const int &section)
{
    addMapping(object, section, "text");
}

void QmlDataMapper::addMapping(QObject *object, const int &section, const QByteArray &propertyName)
{
    for(int i = 0; i < d->m_mappings.count(); ++i)
    {
        Mapping &mapping = d->m_mappings[i];
        if(mapping.object == object)
        {
            d->updateMapping(mapping, object, section, propertyName);
            //При обновлении каждого mappingа подтягивает данные из модели
            d->update();
            return;
        }
        //Перенес сюда
        //d->update();
    }

    Mapping mapping;
    d->updateMapping(mapping, object, section, propertyName);
    d->m_mappings.append(mapping);

    d->update();
}

void QmlDataMapper::clearMapping()
{
    d->m_mappings.clear();
}

int QmlDataMapper::currentIndex() const
{
    return d->m_currentIndex;
}

int QmlDataMapper::count() const
{
    if(!d->m_model)
        return 0;

    return d->m_model->rowCount();
}

QByteArray QmlDataMapper::mappedPropertyName(QObject *object) const
{
    foreach(const Mapping &mapping, d->m_mappings)
    {
        if(mapping.object == object)
            return mapping.propertyName;
    }

    return QByteArray();
}

int QmlDataMapper::mappedSection(QObject *object) const
{
    foreach(const Mapping &mapping, d->m_mappings)
    {
        if(mapping.object == object)
            return mapping.section;
    }
    return 0;
}

QObject* QmlDataMapper::mappedControlAt(const int &section) const
{
    foreach(const Mapping &mapping, d->m_mappings)
    {
        if(mapping.section == section)
            return mapping.object;
    }
    return nullptr;
}



QAbstractItemModel* QmlDataMapper::model() const
{
    return d->m_model;
}

void QmlDataMapper::removeMapping(QObject *object)
{
    for (int i = 0; i < d->m_mappings.count(); ++i)
    {
        if(d->m_mappings[i].object ==object)
        {
            d->m_mappings.remove(i);
            return;
        }
    }
}

void QmlDataMapper::setModel(QAbstractItemModel *model)
{
    d->m_model = model;

    d->m_currentIndex = 0;

    d->update();
    emit countChanged();
}

void QmlDataMapper::revert()
{
    d->update();
}

void QmlDataMapper::setCurrentIndex(int index)
{
    if(!d->m_model)
        return;
    const int rowCount = d->m_model->rowCount();
    if(index < 0 || index >= rowCount)
        return;

    d->m_currentIndex = index;
    d->update();
    emit currentIndexChanged(d->m_currentIndex);
}

void QmlDataMapper::toFirst()
{
    setCurrentIndex(0);
}

void QmlDataMapper::toLast()
{
    if (!d->m_model)
        return;

    const int rowCount = d->m_model->rowCount();

    setCurrentIndex(rowCount);
}

void QmlDataMapper::toNext()
{
    setCurrentIndex(d->m_currentIndex +1);
}

void QmlDataMapper::toPrevious()
{
    setCurrentIndex(d->m_currentIndex - 1);
}

void QmlDataMapper::updateData(int index)
{
    d->m_currentIndex = index;
    d->update();
    emit countChanged();
}

void QmlDataMapper::newData()
{
    //нужно установить текущий индекс
    d->clear();
    emit countChanged();
}










































