/*
#include <stdio.h>
#include <windows.h>
int main(int argc, char** argv)
{
    int t, arg;
    if (argc == 1)
    {
        printf("This tool pause CLI for some seconds.\nUsage:\nToolName.exe [SecondsNumber]\nPress Ctrl+C or Enter to exit.");
        getchar();
        exit(0);
    }
    scanf(argv[1], "%d", &t);
    while (t > 0)
    {
        printf("waiting %d s    \r", t);
        Sleep(1000);  //pause 1 second
        t--;
    }
    printf("\n");
    return 0;
}
*/
#include<stdio.h>
#include<windows.h>
int main(int argc, char* argv[])
{
    if (argc == 1)
    {
        printf("This tool delay CLI by milliseconds.\nUsage:\nToolName.exe [NumberByMilliseconds]\nPress Ctrl+C or Enter to exit.");
        getchar();
        exit(0);
    }
    int i = atoi(argv[1]);
    /*for (i = 0; i < argc; i++)
        printf("第 %d 个参数是 %s\n", i + 1, argv[i]);*/
    Sleep(i);
    return 0;
}