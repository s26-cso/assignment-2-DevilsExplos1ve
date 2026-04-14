#include <stdio.h>
#include <stdlib.h>

struct Node {
    int val;
    struct Node* left;
    struct Node* right;
};

struct Node* make_node(int val);
struct Node* insert(struct Node* root, int val);
struct Node* get(struct Node* root, int val);
int getAtMost(int val, struct Node* root);

int main() {
    struct Node* root = NULL;
    root = insert(root, 50);
    insert(root, 30);
    insert(root, 70);
    insert(root, 40);

    
    struct Node* n = get(root, 40);
    if (n) printf("Found: %d\n", n->val);

    printf("At most 45: %d\n", getAtMost(45, root)); 
    printf("At most 20: %d\n", getAtMost(20, root)); q1

    return 0;
}