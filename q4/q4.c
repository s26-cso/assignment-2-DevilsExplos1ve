#include <stdio.h>
#include <stdlib.h>
#include <dlfcn.h>
#include <string.h>

typedef int (*calc_func)(int, int);

int main() {
    char op[10];
    int num1, num2;
    void *handle = NULL;
    char current_lib[20] = "";

    while (scanf("%s %d %d", op, &num1, &num2) != EOF) {
        char lib_path[30];
        sprintf(lib_path, "./lib%s.so", op);

        if (handle != NULL && strcmp(current_lib, lib_path) != 0) {
            dlclose(handle);
            handle = NULL;
        }

        if (handle == NULL) {
            handle = dlopen(lib_path, RTLD_LAZY);
            if (!handle) {
                continue; 
            }
            strcpy(current_lib, lib_path);
        }

        calc_func operation = (calc_func)dlsym(handle, op);
        if (operation) {
            printf("%d\n", operation(num1, num2));
        }
    }

    if (handle) {
        dlclose(handle);
    }
    return 0;
}