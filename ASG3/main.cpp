#include<stdio.h>

#define MAX 100

int findInsertPos(double arr[], int n, double temp);

void moveDown(double arr[], int n, int pos);

int main(){

double arr[MAX];

char fname[100];

printf("Enter filename: ");

scanf("%s", fname);

FILE *fp = fopen(fname, "r");

while(fp==NULL){

if(fname[0]=='*')

return -1;

printf("Unable to open file\n");

printf("Enter filename: ");

scanf("%s", fname);

fp = fopen(fname, "r");

}

int i, n = 0, pos;

double temp;

while(!feof(fp)){

fscanf(fp, "%lf", &temp);

pos = findInsertPos(arr, n, temp);

moveDown(arr, n, pos);

arr[pos] = temp;

n++;

}

fclose(fp);

for(i=0; i<n; i++){

printf("%.2lf\n", arr[i]);

}

return 0;

}

int findInsertPos(double arr[], int n, double temp){

int pos=0;

while(pos<n && arr[pos]<temp){

pos++;

}

return pos;

}

void moveDown(double arr[], int n, int pos){

int i;

for(i=n-1; i>=pos; i--){

arr[i+1] = arr[i];

}

}
