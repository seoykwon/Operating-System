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

    /**
     * int pid1 = fork();
    int a = 1;
    int range = 10000;


    if(pid1>0){

        setnice(getpid(),0);
        for(int i = 0; i< range; i++){
            for(int j = 0; j< range; j++){
            a = 9.9+9.9*a;
            }
        }
        printf(1,"ans: %d\n",a);

    }
    else if(pid1 == 0){
        setnice(getpid(),10);
        for(int i = 0; i< range; i++){
            for(int j = 0; j< range; j++){
            a = 9.9+9.9*a;
            }
        }
        printf(1,"ans: %d\n",a);
    }

    exit();
     */

    /**
     * setnice(getpid(),5);
    int pid1 = fork();
    int a = 1;
    int range = 2000;

    if(pid1>0){
        int pid2 = fork();
        if(pid2>0){
            int pid3 = fork();

            if(pid3>0){
                wait();
                for(int i = 0; i< range; i++){
                    for(int j = 0; j< range; j++){
                        a = 9.9+9.9*a;
                    }
                }
                printf(1,"%d - ans: %d\n",getpid(),a);
            }
            else if (pid3==0){
                setnice(getpid(),15);
                for(int i = 0; i< range; i++){
                    for(int j = 0; j< range; j++){
                        a = 9.9+9.9*a;
                    }
                }
                printf(1,"%d - ans: %d\n",getpid(),a);
            }
        }
        else if(pid2 == 0){
            setnice(getpid(),10);
            for(int i = 0; i< range; i++){
                for(int j = 0; j< range; j++){
                a = 9.9+9.9*a;
                }
            }
            printf(1,"%d - ans: %d\n",getpid(),a);
        }
    }
    else if(pid1 == 0){
        setnice(getpid(),5);
        for(int i = 0; i< range; i++){
            for(int j = 0; j< range; j++){
            a = 9.9+9.9*a;
            }
        }
        printf(1,"%d - ans: %d\n",getpid(),a);
    }

    exit();
     */
}