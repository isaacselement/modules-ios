#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include "ArrayListHelper.h"

// index 0 is storing the length
int* generateIntArray (int count) {
    int length = count + 1;
    int* p = (int*) malloc(length * sizeof(int));
    if (! p) {
        printf("\t Memory is not enough!");
        return NULL;
    }
    
    * (p + 0) = length;
    for (int i = 1; i < length; i++) {
        * (p + i) = i-1;
    }
    return p;
}

void swap (int* pm, int* pn) {
    int temp;
    temp = *pm;
    *pm = *pn;
    *pn = temp;
}

void shuffle (int* array) {
    int length = *(array);
    srand((int)time(0));
    for (int i = 1; i < length; ++i) {
        // Select a random element between i and end of array to swap with.
        int nElements = length - i;
        int n = (rand() % nElements) + i;
        swap(&array[i], &array[n]);
    }
}

RowColumn* generateRandomRowColumnArray (int outterCount, int innerCount) {
    RowColumn* rowColumn = (RowColumn*) malloc(outterCount * innerCount * sizeof(RowColumn));
    
    int* outterarray = generateIntArray(outterCount);
    shuffle(outterarray);
    int outterlength = *(outterarray);
    
    int index = 0 ;
    
    for (int i = 1; i < outterlength; i++) {
        int radomOutterIndex = * (outterarray + i);
        int* innerarray = generateIntArray(innerCount);
        shuffle(innerarray);
        int innerlength = *(innerarray);
        for (int j = 1; j < innerlength; j++) {
            int radomInnerIndex = *(innerarray + j);
            
            (rowColumn+index)->row = radomOutterIndex;
            (rowColumn+index)->column = radomInnerIndex;
            
            index ++;
        }
        destroyArray(innerarray);
    }
    destroyArray(outterarray);
    
    return rowColumn;
}

void destroyArray (void* array) {
    free(array);
}