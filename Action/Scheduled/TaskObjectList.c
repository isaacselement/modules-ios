#include <stdio.h>
#include <stdlib.h>
#include "TaskObjectList.h"

TaskObject* CreateTaskObject(void* target ,float timeElapsed ,int repeats) {
    TaskObject* taskObject = (TaskObject*)malloc(sizeof(TaskObject)) ;
    taskObject->target = target;
    taskObject->repeats = repeats - 1;
    taskObject->timeElapsed = timeElapsed;
    taskObject->timeInvoke = timeElapsed;
    taskObject->next = NULL;
    return taskObject;
}

int ListLength(LinkList* L) {
    int i=0;
    if (L) {
        LinkList* p = L->next;
        while(p) {
            i++;
            p = p->next;
        }
    }
    return i;
}

int isListContains(LinkList* L, void* target) {
    if (L == NULL) return 0;
    
    LinkList* p = L;
    while(p) {
        if (p->target == target) {
            return 1;
        }
        p = p->next;
    }
    
    return 0;
}

LinkList* InsertList(LinkList* L, TaskObject* e) {
    TaskObject* p1 = L , *p0 = L;
    if (L == NULL) {
        L = e;
        L -> next = NULL;
    } else {
        int isAddInList = 0;
        while (p1) {
            if (e->timeElapsed <= p1->timeElapsed ) {
                e->next = p1;
                if (p1 == L) {
                    L = e ;
                } else {
                    p0->next = e;
                }
                isAddInList = 1;
                break;
            }
            p0 = p1;
            p1 = p1->next;
        }
        
        if(! isAddInList) {
            p0->next = e;
        }
    }
    return L;
}

LinkList* ListDelete(LinkList* L, void* target) {
    LinkList *p1 = L,  *p0 = L;
    while (p1) {
        
        if (p1->target == target) {
            
            if (p1 == L) {
                L = p1 -> next;
                p0 = L;
                free(p1);
                p1 = L;
                
            } else {
                p0->next = p1->next;
                free(p1);
                p1 = p0->next;
                
            }
            
        } else {
            
            p0 = p1;
            p1 = p1->next;
            
        }
        
    }
    return L;
}

LinkList* ClearList(LinkList* L) {
    LinkList *p = NULL, *q = NULL;
    if (L)  {
        p = L -> next;
        while (p) {
            q = p -> next;
            free(p);
            p = q;
        }
        L -> next = NULL;
    }
    L = NULL;
    return L;
}