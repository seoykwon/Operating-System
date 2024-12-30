#include "types.h"
#include "user.h"
#include "stat.h"

int main()
{
    printf(1, "\ncheck all ps by ps(0):\n---------------------------\n");
    ps(0);
    int i;

    printf(1, "\ngetnice test ...\n");
    for (i = -1; i < 6; i++)
    {
        printf(1, "\tgetnice(%d) \treturn: %d\n", i, getnice(i));
    }
    printf(1, "\tgetnice(%d) \treturn: %d\n", 1000, getnice(1000));

    printf(1, "\nsetnice test 1...\n");
    for (i = -1; i < 6; i++)
    {
        printf(1, "\tsetnice(%d,15) \treturn: %d\n", i, setnice(i, 15));
        printf(1, "\tgetnice(%d) \treturn: %d\n", i, getnice(i));
    }
    printf(1, "\tsetnice(%d,15) \treturn: %d\n", 1000, setnice(1000, 15));
    printf(1, "\tgetnice(%d) \treturn: %d\n", 1000, getnice(1000));

    printf(1, "\ncheck all ps by ps(0):\n---------------------------\n");
    ps(0);

    printf(1, "\nsetnice test 2...\n");
    printf(1, "\tsetnice(%d,%d) \treturn: %d\n", 1, -1, setnice(1, -1));
    printf(1, "\tgetnice(%d) \treturn: %d\n", 1, getnice(1));
    printf(1, "\tsetnice(%d,%d) \treturn: %d\n", 1, 0, setnice(1, 0));
    printf(1, "\tgetnice(%d) \treturn: %d\n", 1, getnice(1));
    printf(1, "\tsetnice(%d,%d) \treturn: %d\n", 2, 39, setnice(2, 39));
    printf(1, "\tgetnice(%d) \treturn: %d\n", 2, getnice(2));
    printf(1, "\tsetnice(%d,%d) \treturn: %d\n", 2, 40, setnice(2, 40));
    printf(1, "\tgetnice(%d) \treturn: %d\n", 2, getnice(2));

    printf(1, "\ncheck all ps by ps(0) %d:\n");
    ps(0);

    printf(1, "\nps test ...\n");

    for (i = -1; i < 6; i++)
    {
        printf(1, "\nps(%d)\n---------------------------\n", i);
        ps(i);
    }
    exit();
}