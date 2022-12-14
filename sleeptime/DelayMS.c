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
    Sleep(i);
    return 0;
}
