#ifndef Touch_ArrayListHelper_h
#define Touch_ArrayListHelper_h

typedef struct RowColumn {
    int row ;
    int column ;
} RowColumn;

void shuffle (int* array) ;
void swap (int* pm, int* pn) ;

// when you 'generate', the you should 'destroy' it. just like 'alloc' & 'release'
void destroyArray (void* array) ;
int* generateIntArray (int count) ;
RowColumn* generateRandomRowColumnArray (int outterCount, int innerCount) ;

#endif
