#include "types.h"
#include "user.h"
#include "stat.h"

int main()
{
    int size = 8192;
    int fd = open("README", O_RDONLY);
    char *text = (char *)mmap(0, size, PROT_READ, MAP_ANONYMOUS | MAP_POPULATE, fd, 0);
    printf(1, "mmap return is: %d\n", text);
    printf(1, "text[0] is: %d\n", text[0]);

    // int size = 8192;
    // int fd = open("README", O_RDONLY);
    // printf(1, "freemem now is %d\n", freemem());
    // char *text = (char *)mmap(0, size, PROT_READ, 0, fd, 0);
    // printf(1, "mmap return is: %d\n", text);
    // printf(1, "freemem now is %d\n", freemem());
    // printf(1, "text[4100] is: %c\n", text[4100]);
    // printf(1, "freemem now is %d\n", freemem());
    // // for(int i=4096; i<size; i++) printf(1, "%c", *(text+i));
    // printf(1, "text[300] is: %c\n", text[300]);
    // printf(1, "freemem now is %d\n", freemem());
    // printf(1, "\n");

    // int size = 8192;
    // int fd = open("README", O_RDONLY);
    // char *text = (char *)mmap(0, size, PROT_READ, 0, fd, 0);
    // printf(1, "mmap return is: %d\n", text);
    // printf(1, "text[9000] is: %c\n", text[9000]);
    // printf(1, "\n");

    // int size = 8192;
    // int fd = open("README", O_RDONLY);
    // char *text = (char *)mmap(0, size, PROT_READ, 0, fd, 0);
    // printf(1, "mmap return is: %d\n", text);
    // text[5000] = '5';
    // printf(1, "\n");

    // int size = 8192;
    // int fd = open("README", O_RDONLY);
    // printf(1, "freemem now is %d\n", freemem());
    // char *text = (char *)mmap(0, size, PROT_READ, MAP_POPULATE, fd, 0);
    // printf(1, "mmap return is: %d\n", text);
    // printf(1, "freemem now is %d\n", freemem());
    // int ret = munmap(0 + MMAPBASE);
    // printf(1, "munmap return is: %d\n", ret);
    // printf(1, "freemem now is %d\n", freemem());
    // printf(1, "\n");

    // int size = 8192;
    // int fd = open("README", O_RDONLY);
    // printf(1, "freemem now is %d\n", freemem());
    // char *text = (char *)mmap(size, size, PROT_READ, MAP_POPULATE, fd, 0);
    // printf(1, "mmap return is: %d\n", text);
    // printf(1, "freemem now is %d\n", freemem());
    // int ret = munmap(0 + MMAPBASE);
    // printf(1, "munmap return is: %d\n", ret);
    // printf(1, "freemem now is %d\n", freemem());
    // printf(1, "\n");

    // int size = 8192;
    // int fd = open("README", O_RDWR);
    // printf(1, "freemem now is %d\n", freemem());
    // char *text = (char *)mmap(0, size, PROT_READ | PROT_WRITE, MAP_POPULATE, fd, 0);
    // printf(1, "mmap return is: %d\n", text);
    // printf(1, "freemem now is %d\n", freemem());
    // printf(1, "parent text[110] is: %c\n", text[110]);
    // text[110] = '9';
    // printf(1, "parent text[110] is: %c\n", text[110]);
    // int fo;
    // if ((fo = fork()) == 0)
    // {
    //     printf(1, "fork! child freemem now is %d\n", freemem());
    //     printf(1, "child text[110] is: %c\n", text[110]);
    //     text[110] = '7';
    //     printf(1, "child text[110] is: %c\n", text[110]);
    // }
    // else
    // {
    //     wait();
    //     printf(1, "parent freemem now is %d\n", freemem());
    //     printf(1, "parent text[110] is: %c\n", text[110]);
    // }
}