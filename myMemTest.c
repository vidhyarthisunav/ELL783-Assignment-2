#include "types.h"
#include "stat.h"
#include "user.h"
#include "syscall.h"

#define PAGESIZE 4096

int
main(int argc, char *argv[]){

#if NFU
    int i;
    printf(1, "\nNFU Testing\n");
    printf(1, "\nProcess Starts\n");
    printf(1,"\nInitial process details:\n");
    printStats();


    printf(1,"\nAllocating 12 more pages...\n\n");
    for(i = 0; i<12; i++){
        sbrk(PAGESIZE);
    }
    printf(1,"\nProcess details:\n");
    printStats();

    //Adding one more page i.e page no.15 
    printf(1,"\nAllocating 16th page...\n\n");
    sbrk(PAGESIZE);

    printStats();
    printf(1,"\nAllocating 17th page...\n\n");
    sbrk(PAGESIZE);
    printStats();
    exit();

#else
    #if FIFO
        printf(1,"\nFIFO Testing\n");
    #elif SCFIFO
        printf(1,"\nSCFIFO Testing\n");
    #endif
    printf(1,"\nProcess starts\n");
    int i;
    char *page[14];
    printf(1,"\nInitial details:\n");
    printStats();
    printf(1,"\nAssigning 12 more pages for the process...\n\n");
    for(i = 0; i<12; i++){
        page[i] = sbrk(PAGESIZE);
    }
    printf(1,"\n",i,page[i]);
    printf(1,"\nDetails after assignment of 12 more pages:\n");
    printStats();

    printf(1,"\nAllocating 16th page...\n\n");
    page[12] = sbrk(PAGESIZE);
    printf(1,"\nDetails after assignment of 16th page:\n");
    printStats();
   
    printf(1,"\nAllocating 17th page...\n\n");
    page[13] = sbrk(PAGESIZE);
    printStats();

    printf(1,"\nfork() Testing\n");
    printf(1,"\nState of all the process before forking the child process:\n");
    procDump();
    if(fork() == 0){
        printf(1,"\nThis is the child process, PID: %d**\n",getpid());
        printf(1,"\nDetails of all processes:\n");
        procDump();
        printf(1,"\nChild process is exiting now...\n");
        exit();
    }
    else{
        wait();
        printf(1,"\nThis is the parent process\n");
        printf(1,"\nDetails of all processes:\n");
        procDump();
        exit();   
    }
#endif

    return 0;
}