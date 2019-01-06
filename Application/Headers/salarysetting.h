#ifndef SALARYSETTING_H
#define SALARYSETTING_H

#include <QObject>
#include <QPair>
#include <QVector>

typedef QPair<int, double> StudentSplit;

struct StudentBonus{
public:
    QVector<StudentSplit> Split;

    double getBonus(const int studentCount);
    void addPosition(const int &studentCount, const double &bonus);
    void deletePosition(const int index);
};


class SalarySetting : public QObject
{
    Q_OBJECT
public:
    explicit SalarySetting(QObject *parent = nullptr);

    double hourCost() const;
    void setHourCost(double newCost);

    StudentBonus& studentBonus();
signals:
    void changeHourCost();
    void changeStudentBonus();

public slots:

private:
    double _hourCost;
    StudentBonus _studentBonus;
};

#endif // SALARYSETTING_H
