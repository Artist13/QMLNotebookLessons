#include "Headers/salarysetting.h"

SalarySetting::SalarySetting(QObject *parent) : QObject(parent)
{

}

double SalarySetting::hourCost() const
{
    return _hourCost;
}

void SalarySetting::setHourCost(double newCost)
{
    if(abs(newCost - _hourCost) < 1.0e-6)
        return;
    _hourCost = newCost;
    emit changeHourCost();

}

StudentBonus &SalarySetting::studentBonus()
{
    return _studentBonus;
}

double StudentBonus::getBonus(const int studentCount)
{
    for(int i = 1; i < Split.count(); i++)
    {
        if (studentCount > Split[i - 1].first)
        {
            if (studentCount < Split[i].first)
                return Split[i - 1].second;
        }else{
            //Сюда можно попасть только если количество меньше самой левой границы
            return 0;
        }
    }
    return Split[Split.count() - 1].second;
}

void StudentBonus::addPosition(const int &studentCount, const double &bonus)
{
    Split.push_back(StudentSplit(studentCount, bonus));
}

void StudentBonus::deletePosition(const int index)
{
    Split.remove(index);
}
