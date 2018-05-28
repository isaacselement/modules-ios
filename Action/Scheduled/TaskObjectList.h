#ifndef Touch_TaskObjectList_h
#define Touch_TaskObjectList_h

typedef struct TaskObject {
    void* target ;
    int repeats ;
    float timeElapsed ;
    float timeInvoke ;
    struct TaskObject* next;
} TaskObject;

typedef struct TaskObject LinkList;

TaskObject* CreateTaskObject(void* target ,float timeElapsed ,int repeats) ;

int ListLength(LinkList* L) ;

int isListContains(LinkList* L, void* target) ;

LinkList* InsertList(LinkList* L, TaskObject* e) ;

LinkList* ListDelete(LinkList* L, void* target) ;

LinkList* ClearList(LinkList* L) ;

#endif
