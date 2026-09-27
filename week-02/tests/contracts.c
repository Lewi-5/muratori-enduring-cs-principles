#include <assert.h>
#include <limits.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "platform.h"
#define main exercise_main
#include SOURCE
#undef main

int main(void)
{
#if EXERCISE == 1
    if (CHAR_BIT != 8) { puts("octet tests skipped"); return 0; }
    unsigned char raw[] = {0, 127, 128, 255};
    char out[20]; memset(out, '!', sizeof out);
    assert(format_bytes(raw, 4, out, 12) && strcmp(out, "00 7f 80 ff") == 0);
    assert(out[12] == '!');
    memset(out, '!', sizeof out);
    assert(!format_bytes(raw, 4, out, 11) && out[0] == '!' && out[10] == '!');
    assert(!format_bytes(raw, SIZE_MAX, out, sizeof out) && out[0] == '!');
    assert(!format_bytes(NULL, 1, out, sizeof out));
    assert(!format_bytes(NULL, 0, out, 0) && out[0] == '!');
    assert(format_bytes(NULL, 0, out, 1) && out[0] == '\0');
    assert(format_bytes(raw + 3, 1, out, 3) && strcmp(out, "ff") == 0);
#elif EXERCISE == 2
    size_t out = 99;
    assert(!is_power_of_two(0) && !is_power_of_two(3) && is_power_of_two(1) && is_power_of_two(64));
    size_t inputs[] = {0, 1, 8, 9}, wanted[] = {0, 8, 8, 16};
    for (size_t i = 0; i < 4; ++i) assert(align_up(inputs[i], 8, &out) && out == wanted[i]);
    size_t top = SIZE_MAX & ~(size_t)7;
    assert(align_up(top, 8, &out) && out == top);
    assert(!align_up(top + 1, 8, &out) && out == top);
    assert(!align_up(1, 0, &out) && !align_up(1, 3, &out) && out == top);
    assert(align_up(SIZE_MAX, 1, &out) && out == SIZE_MAX);
#elif EXERCISE == 3
    MemberSpec good[] = {{1,1},{8,8},{4,4}};
    size_t offsets[3] = {99,99,99}, size = 99, align = 99;
    assert(predict_layout(good,3,offsets,&size,&align));
    assert(offsets[0]==0 && offsets[1]==8 && offsets[2]==16 && size==24 && align==8);
    MemberSpec extended[] = {{1,1},{64,64}};
    assert(predict_layout(extended,2,offsets,&size,&align) && offsets[1]==64 && size==128 && align==64);
    MemberSpec bad[][3] = {{{0,1},{1,1},{1,1}},{{1,3},{1,1},{1,1}},{{3,2},{1,1},{1,1}},
        {{SIZE_MAX,1},{1,1},{1,1}},{{SIZE_MAX-1,2},{1,1},{1,1}},{{SIZE_MAX-1,2},{1,1},{0,1}}};
    for (size_t i=0;i<sizeof bad/sizeof bad[0];++i) {
        offsets[0]=offsets[1]=offsets[2]=size=align=99;
        assert(!predict_layout(bad[i],3,offsets,&size,&align));
        assert(offsets[0]==99 && offsets[1]==99 && offsets[2]==99 && size==99 && align==99);
    }
    MemberSpec tail[]={{SIZE_MAX-1,2},{1,1}};
    assert(!predict_layout(tail,2,offsets,&size,&align) && size==99);
    assert(!predict_layout(NULL,0,offsets,&size,&align));
#elif EXERCISE == 4
    char out[30];
    FieldSpan spans[]={{0,1},{8,8},{16,4}};
    assert(layout_map(spans,3,24,out,sizeof out) && strcmp(out,"A.......BBBBBBBBCCCC....")==0);
    FieldSpan unsorted[]={{2,2},{0,2}};
    assert(layout_map(unsorted,2,4,out,5) && strcmp(out,"BBAA")==0);
    assert(layout_map(NULL,0,3,out,4) && strcmp(out,"...")==0);
    FieldSpan bad[][2]={{{0,3},{2,1}},{{0,0},{2,1}},{{4,1},{0,1}},{{SIZE_MAX,1},{0,1}}};
    for(size_t i=0;i<4;++i) {
        memset(out,'!',sizeof out);
        assert(!layout_map(bad[i],2,4,out,sizeof out));
        for(size_t j=0;j<sizeof out;++j) assert(out[j]=='!');
    }
    assert(!layout_map(spans,3,24,out,24));
    assert(!layout_map(NULL,0,SIZE_MAX,out,SIZE_MAX));
    assert(!layout_map(spans,27,24,out,sizeof out));
    assert(!layout_map(NULL,0,0,out,sizeof out));
    FieldSpan actual[]={{offsetof(struct A,tag),sizeof(char)}, {offsetof(struct A,value),sizeof(double)}, {offsetof(struct A,count),sizeof(int)}};
    char *map=malloc(sizeof(struct A)+1); assert(map);
    assert(layout_map(actual,3,sizeof(struct A),map,sizeof(struct A)+1));
    assert(strlen(map)==sizeof(struct A));
    for(size_t i=0;i<3;++i) {
        size_t occurrences=0;
        for(size_t j=0;j<sizeof(struct A);++j) occurrences+=map[j]=="ABC"[i];
        assert(occurrences==actual[i].size);
    }
    free(map);
#elif EXERCISE == 5
    size_t out=99;
    assert(member_offset(3,4,24,16,4,&out) && out==88);
    assert(!member_offset(4,4,24,16,4,&out) && out==88);
    assert(!member_offset(0,1,4,3,2,&out));
    assert(!member_offset(0,1,0,0,0,&out));
    assert(!member_offset(0,1,4,0,0,&out));
    assert(!member_offset(SIZE_MAX/3,SIZE_MAX/3+1,3,1,1,&out));
    assert(!member_offset(1,2,SIZE_MAX,0,1,&out));
    assert(grid_offset(3,4,4,2,3,&out) && out==44);
    assert(!grid_offset(3,4,4,3,0,&out) && out==44);
    assert(!grid_offset(3,4,4,0,4,&out));
    assert(!grid_offset(SIZE_MAX,2,1,0,0,&out));
    assert(!grid_offset(2,2,SIZE_MAX,0,0,&out));
    assert(!grid_offset(0,4,4,0,0,&out));
#elif EXERCISE == 6
    assert(next_static()==1); assert(next_static()==2); assert(next_static()==3);
    assert(next_automatic()==1 && next_automatic()==1);
    assert(frames_distinct(0) && frames_distinct(1) && frames_distinct(1000) && !frames_distinct(1001));
    int n=INT_MAX;
    assert(!counter_bump(&n) && n==INT_MAX && !counter_bump(NULL));
    n=INT_MAX-1; assert(counter_bump(&n) && n==INT_MAX && !counter_bump(&n));
    n=INT_MIN; assert(counter_bump(&n) && n==INT_MIN+1);
    int *a=counter_create(7), *b=counter_create(-1);
    assert(a && b && a!=b && counter_bump(a) && *a==8 && *b==-1);
    counter_destroy(a); counter_destroy(b); counter_destroy(NULL);
#elif EXERCISE == 7
    assert(!alloc_aligned(0,alignof(max_align_t)));
    assert(!alloc_aligned(100,0) && !alloc_aligned(100,3));
    assert(!alloc_aligned(SIZE_MAX,64));
    if (REFERENCE_ABI) {
        size_t offset; assert(align_up(sizeof(Header),alignof(Record),&offset));
        size_t needed=offset+3*sizeof(Record);
        void *block=malloc(needed+1); assert(block);
        memset(block,0xa5,needed+1);
        Header *h=NULL; Record *r=NULL;
        assert(!carve(block,needed-1,3,&h,&r) && h==NULL && r==NULL);
        assert(!carve((unsigned char *)block+1,needed,3,&h,&r));
        assert(!carve(block,needed,SIZE_MAX,&h,&r));
        if (SIZE_MAX > UINT32_MAX) assert(!carve(block,needed,(size_t)UINT32_MAX+1,&h,&r));
        for(size_t i=0;i<needed+1;++i) assert(((unsigned char *)block)[i]==0xa5);
        assert(carve(block,needed,3,&h,&r));
        assert(h->count==0 && h->capacity==3 && is_aligned(r,alignof(Record)));
        for(size_t i=0;i<3;++i) assert(r[i].id==i && r[i].next==0 && r[i].weight==0.0);
        assert(carve(block,offset,0,&h,&r) && h->capacity==0 && r==NULL);
        free(block);
        unsigned char *aligned=alloc_aligned(100,64); assert(aligned && is_aligned(aligned,64));
        for(size_t i=0;i<100;++i) aligned[i]=(unsigned char)i;
        assert(aligned[99]==99); free(aligned);
        puts("target alignment checks passed");
    } else puts("target alignment checks skipped");
#elif EXERCISE == 8
    Record table[4]={{0,0,0},{1,3,0},{2,0,0},{3,2,0}};
    size_t out=99;
    assert(node_at(table,4,1)==&table[1] && node_at(table,4,0)==NULL && node_at(table,4,4)==NULL);
    assert(chain_length(table,4,1,&out) && out==3);
    assert(chain_length(NULL,0,0,&out) && out==0);
    assert(!chain_length(NULL,0,1,&out) && out==0);
    table[3].next=1; assert(!chain_length(table,4,1,&out) && out==0);
    table[3].next=4; assert(!chain_length(table,4,1,&out));
    table[1].next=1; assert(!chain_length(table,4,1,&out));
    assert(!chain_length(table,1048577,0,&out));
    assert(!chain_length(NULL,4,0,&out));
#elif EXERCISE == 9
    assert(shared_counter==7 && shared_zero==0 && shared_limit==100);
    assert(shared_address()==&shared_counter);
    assert(bump_shared() && shared_counter==8);
    assert(bump_hidden() && *hidden_address()==4);
    assert(next_local()==1); assert(next_local()==2);
    shared_counter=INT_MAX; assert(!bump_shared() && shared_counter==INT_MAX);
#elif EXERCISE == 10
    MemberSpec members[26]={{0,0}}; const char *names[26]={NULL}; size_t count=99;
    assert(parse_types("char,double,int",members,names,&count) && count==3);
    assert(members[0].size==sizeof(char) && members[1].align==alignof(double));
    assert(strcmp(names[2],"int")==0);
    const char *bad[]={"",",char","char,","char,,int","unknown"," int","Int"};
    for(size_t i=0;i<sizeof bad/sizeof bad[0];++i) {
        MemberSpec old[26]; memcpy(old,members,sizeof old); count=99;
        assert(!parse_types(bad[i],members,names,&count) && count==99);
        assert(memcmp(old,members,sizeof old)==0);
    }
    if(REFERENCE_ABI) {
        struct First {char a; double b; int c;}; struct Second {double a; int b; char c;};
        size_t offsets[26],size,align;
        assert(parse_types("char,double,int",members,names,&count));
        assert(predict_layout(members,count,offsets,&size,&align));
        assert(size==sizeof(struct First) && align==_Alignof(struct First));
        assert(offsets[0]==offsetof(struct First,a) && offsets[1]==offsetof(struct First,b) && offsets[2]==offsetof(struct First,c));
        assert(parse_types("double,int,char",members,names,&count));
        assert(predict_layout(members,count,offsets,&size,&align));
        assert(size==sizeof(struct Second) && align==_Alignof(struct Second));
        assert(offsets[0]==offsetof(struct Second,a) && offsets[1]==offsetof(struct Second,b) && offsets[2]==offsetof(struct Second,c));
        puts("reference ABI checks passed");
    } else puts("reference ABI checks skipped");
#endif
    puts("contract passed");
    return 0;
}
