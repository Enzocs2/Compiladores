#include<stdio.h>
#include<math.h>

int main(int argc, char *argv[]){
int numeroVoltas=4;
for (int i=0;i<numeroVoltas; i=i+1){
char* fraseMotivacional="\nJa correu essas voltas: ";
printf("%s", fraseMotivacional);
printf("%d", i);
}
}
