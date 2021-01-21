#include <stdio.h>
#include <stdlib.h>
#include <time.h>
int  main( )
{
   char  c[128];
   int   a,b;

   system("cls");
   printf("\n*******おみくじ*******\n0を入力すると終了します\n");

   srand(time(NULL));                      // 乱数の準備

   while ( 1 )
     {
       printf("\n好きな数字をどうぞ: ");
       gets(c); a=atoi(c);
       if ( a==0 ) break;

       b=rand( )%10+1;                      // 乱数発生

       printf(" >>> ");

       switch ( (a+b)%10 )
         {
           case  0: printf("大吉"); break;
           case  1: printf("吉"); break;
           case  2: printf("吉"); break;
           case  3: printf("吉"); break;
           case  4: printf("吉"); break;
           case  5: printf("吉"); break;
           case  6: printf("凶"); break;
           case  7: printf("凶"); break;
           case  8: printf("凶"); break;
           case  9: printf("大凶"); break;
         }
       printf("\n");
    }
}

