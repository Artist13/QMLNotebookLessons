#ifndef BOOTSTRAP_H
#define BOOTSTRAP_H

#include "database.h"

// Производит загрузку всех баз данных и других необходимых ресурсов
class Bootstrap
{
public:
    Bootstrap();
    static void run();
};

#endif // BOOTSTRAP_H
