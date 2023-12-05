#include<stdio.h>
#include<math.h>

int main(int argc, char *argv[]){
int notaA=5;
int notaB=8;
int media=notaA+notaB;
media=media/2;
int sub=7;
 
if (notaA<sub) {
notaA=sub;
}
 else {
 
if (notaB<sub) {
notaB=sub;
}
 else {
char* a="(nota da sub menor)";
printf("%s", a);
 }
 }
int mediaNova=notaA+notaB;
mediaNova=mediaNova/2;
mediaNova=mediaNova*100;
mediaNova=mediaNova/media;
mediaNova=mediaNova-100;
char* b="A media subiu:";
printf("%s", b);
printf("%d", mediaNova);

}
