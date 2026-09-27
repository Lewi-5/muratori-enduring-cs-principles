#ifndef EX09_DATA_H
#define EX09_DATA_H
extern int shared_counter;
extern int shared_zero;
extern const int shared_limit;
int bump_shared(void);
int bump_hidden(void);
int next_local(void);
int *shared_address(void);
const int *hidden_address(void);
#endif
