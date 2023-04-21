/**
 * CS 2110 - Spring 2022 - Homework 9
 *
 * @author Panya Bhinder
 *
 * list.c: Complete the functions!
 */

/**
 * !!!!!!!!!!!!!!!!!!!!!!!!!!!!-IMPORTANT-!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 * For any function that must use malloc, if malloc returns NULL, the function
 * itself should return FAILURE if it returns an int or NULL otherwise
 */

// Do not add ANY additional includes!!!
#include "list.h"

/* You should NOT have any global variables. */

static struct user *create_user(char *name, enum user_type type, union user_data data);
static int create_student(int num_classes, double *grades, struct student *dataOut); //completed for you
static int create_instructor(double salary, struct instructor *dataOut); //completed for you
static int user_equal(const struct user *user1, const struct user *user2);

/** create_user
 *
 * Helper function that creates a struct user by allocating memory for it on the heap
 * and initializing with the passed in data. You MUST create a deep copy of
 * the data union. This means malloc'ing space for copies of each field.
 *
 * If malloc returns NULL, you should return NULL as well.
 *
 * If creating a student/instructor fails, you must free everything you've allocated
 * and return NULL
 *
 * You should call create_student() or create_instructor() in this function
 * to create a deep copy of the union user_data depending on the enum user_type
 *
 * (hint: you cannot just assign the parameter data to the data part of user)
 *
 * Remember to set the next pointer to NULL.
 *
 * @param the fields of the struct user struct
 * @return a struct user, return NULL if malloc fails
 */
static struct user *create_user(char *name, enum user_type type, union user_data data)
{
    struct user *newUser = malloc(sizeof(struct user));
    if (! newUser) {
        free(newUser);
        return NULL;
    }
    if (name == NULL) {
        newUser->name = NULL;
    } else {
        newUser -> name = (char *)malloc(strlen(name) + 1);
        if (!newUser->name) { 
            free(newUser); 
            return NULL; 
        }
        strcpy(newUser->name, name);
    }

    newUser -> type = type;
    if (type == STUDENT) {
        int create = create_student(data.student.num_classes, data.student.grades, &newUser -> data.student);
        if (create == FAILURE) {
            free(newUser);
            return NULL;
        }
    } else {
        int create = create_instructor(data.instructor.salary, &newUser -> data.instructor);
        if (create == FAILURE) {
            free(newUser);
            return NULL;
        }
    }

    newUser -> next = NULL;

    return newUser;
}

/** create_student
 *
 * Helper function that creates a struct student and allocates memory for the grade array on the heap.
 *
 * THIS FUNCTION IS IMPLEMENTED FOR YOU
 *
 * @param the fields of the student struct, and an existing pointer to a student
 * @return FAILURE if malloc fails, SUCCESS otherwise.
 */
static int create_student(int num_classes, double *grades, struct student *dataOut)
{
    /***do not change anything in this function***/
    dataOut->num_classes = num_classes;
    dataOut->grades = NULL;
    if (grades != NULL) {
        if (!(dataOut->grades = (double *) malloc(sizeof(double)*num_classes))) return FAILURE;
        memcpy(dataOut->grades, grades, sizeof(double)*num_classes);
    }
    return SUCCESS;
}

/** create_instructor
 *
 * Helper function that creates an struct instructor.
 *
 * THIS FUNCTION IS IMPLEMENTED FOR YOU
 *
 * @param the fields of the struct instructor, and an existing pointer to an instructor
 * @return always SUCCESS, since there is no malloc call
 */
static int create_instructor(double salary, struct instructor *dataOut)
{
    /***do not edit anything in this function***/
    dataOut->salary = salary; //yes that's all this function does
    return SUCCESS;
}

/** student_equal
 *
 * Helper function to compare two struct students. You may find it useful to call this helper
 * function from the user_equal function that you have to implement.
 *
 * @param the two student structs to be compared
 * @return 1 if equal, 0 otherwise
 */
static int student_equal(const struct student *student1, const struct student *student2)
{
    if (student1->num_classes != student2->num_classes) return 0;
    if (student1->grades != student2->grades)
    {
        if (student1->grades == NULL || student2->grades == NULL) return 0;
        if (memcmp(student1->grades, student2->grades,
                student1->num_classes * sizeof(double)))
        {
            return 0;
        }
    }
    return 1;
}

/** user_equal
 * Helper function to help you compare two user structs.
 *
 * If the name, type, and union fields are all equal, you should return 1.
 * Otherwise, return 0.
 *
 * NOTE: struct members that are pointers may be null!
 * If two users both have null for a certain pointer, the pointers are
 * considered equal.
 * However, if either of the input users is NULL, you should return 0.
 *
 * You may find it useful to call the student_equal function defined above.
 *
 * Make sure you're using the right function when comparing the name.
 * Remember that you are allowed to use functions from string.h
 *
 * This is meant to be used as a helper function in 'contains'; it is not tested
 * by the autograder.
 *
 * @param the two struct user structs to be compared
 * @return 1 if equal, 0 otherwise
 */
static int user_equal(const struct user *user1, const struct user *user2)
{
    if(user1 == NULL || user2 == NULL) {
        return 0;
    } 

    int type = 0;
    if (user1->type == user2->type) {
        type++;
    } else {
        return 0;
    }

    int string = 0;
    if (user1->name == NULL && user2->name == NULL) {
        string++;
    } else if (user1 -> name == NULL || user2 -> name == NULL) {
        return 0;
    } else if (strcmp(user1 -> name, user2 -> name) == 0) {
        string++;
    }

    int data = 0;
    if (user1 -> type == STUDENT) {
        if (student_equal(&(user1 -> data.student), &(user2 -> data.student))) {
            data++;
        } else {
            return 0;
        }
    } else {
        if (user1 -> data.instructor.salary == user2 -> data.instructor.salary) {
            data++;
        } else {
            return 0;
        }
    }

    if (type + string + data == 3) {
        return 1;
    } else {
        return 0;
    }

    /*
    
    else if (user1 -> name == NULL || user2 -> name == NULL) {
        return 0;
    } else if ((strcmp(user1 -> name, user2 -> name) == 0 || (user1->name == NULL && user2->name == NULL)) && user1 -> type == user2 -> type) {
        if (user1 -> type == STUDENT) {
            if (student_equal(& (user1 -> data.student), &(user2 -> data.student))) {
                return 1;
            }
        } else if (user1 -> type == INSTRUCTOR) {
            if (user1 -> data.instructor.salary == user2 -> data.instructor.salary) {
                return 1;
            }
        } else {
            return 0;
        }
    } 
    return 0;
    */
}

/** create_list
 *
 * Creates a struct user_list by allocating memory for it on the heap.
 * Be sure to initialize size to zero, head and tail to NULL.
 *
 * If malloc returns NULL, you should return NULL to indicate failure.
 *
 * @return a pointer to a new struct list or NULL on failure
 */
struct user_list *create_list(void)
{
    struct user_list *list = malloc(sizeof(*list));
    if (!list) {
        free(list);
        return NULL;
    }
    list -> head = NULL;
    list -> tail = NULL;
    list -> size = 0;
    return list;
}

/** push_front
 *
 * Adds the element at the front of the struct user_list.
 *
 * @param list a pointer to the struct user_list structure.
 * @param      the fields of the struct user struct
 * @return FAILURE if the struct user_list is NULL or if allocating the new user fails,
 * SUCCESS if successful.
 */
int push_front(struct user_list *list, char *name, enum user_type type, union user_data data)
{
    if (list == NULL) {
        return FAILURE;
    }
    struct user *add = create_user(name, type, data);
    if (!add) {
        free(add);
        return FAILURE;
    }

    if (list->size == 0) {
        add->next = list->head;
        list -> head = add;
        list->tail = add;
        list -> tail -> next = list -> head;
        list -> size += 1;
        return SUCCESS;
    } else {
        add -> next = list -> head;
        list -> head = add;
        list -> tail -> next = list -> head;
        list -> size += 1;
        return SUCCESS;
    }
}

/** push_back
 *
 * Adds the element to the back of the struct user_list.
 *
 * @param list a pointer to the struct user_list structure.
 * @param      the fields of the struct user struct
 * @return FAILURE if the struct user_list is NULL
 *         or malloc fails (do not add the data in this case)
 *         otherwise return SUCCESS
 */
int push_back(struct user_list *list, char *name, enum user_type type, union user_data data)
{
    if (list == NULL) {
        return FAILURE;
    }
    struct user *add = create_user(name, type, data);
    if (!add) {
        free(add);
        return FAILURE;
    }

    if (list -> size == 0) {
        list -> head = add;
        list -> tail = add;
        add -> next = add;
        list -> size += 1;
        return SUCCESS;
    } else {
        add -> next = list -> tail -> next;
        list -> tail -> next = add;
        list -> tail = add;
        list -> size += 1;
        return SUCCESS;
    }
}

/** add_at_index
 *
 * Add the element at the specified index in the struct user_list. This index must lie in
 * the inclusive range [0,size].
 * For example, if you have no elements in the struct user_list,
 * you should be able to add to index 0 but no further.
 * If you have two elements in the struct user_list,
 * you should be able to add to index 2 but no further.
 *
 * @param list a pointer to the struct user_list structure
 * @param index 0-based, starting from the head in the inclusive range
 *              [0,size]
 * @param the fields of the struct user struct
 * @return FAILURE if the index is out of bounds or the struct user_list is NULL
 *         or malloc fails (do not add the data in this case)
 *         otherwise return SUCCESS
 */
int add_at_index(struct user_list *list, int index, char *name, enum user_type type, union user_data data)
{
    if (list == NULL || index < 0 || index > list -> size) {
        return FAILURE;
    } else if (index == 0) {
        push_front(list, name, type, data);
        return SUCCESS;
    } else if (index == list->size) {
        push_back(list,name, type, data);
        return SUCCESS;
    } else {
        struct user *newUser = create_user(name, type, data);
        if (!newUser) {
            free(newUser);
            return FAILURE;
        }
        struct user *temp = list->head;
        for (int i = 0; i < index - 1; i++) {
            temp = temp->next;
        }
        newUser->next = temp->next;
        temp->next = newUser;
        list->size += 1;
        return SUCCESS;
    }
}

/** get
 *
 * Gets the data at the specified index in the struct user_list
 *
 * @param list a pointer to the struct user_list structure
 * @param index 0-based, starting from the head.
 * @param dataOut A pointer to a pointer used to return the data from the
 *        specified index in the struct user_list or NULL on failure.
 * @return FAILURE if dataOut is NULL or index is out of range of the struct user_list or
 *         the struct user_list is NULL, SUCCESS otherwise
 */
int get(struct user_list *list, int index, struct user **dataOut)
{
    if (dataOut == NULL || list == NULL || index >= list -> size || index < 0) {
        return FAILURE;
    } else {
        struct user *temp = list->head;
        for (int i = 0; i < index; i++) {
            temp = temp->next;
        }
        *dataOut = temp;
        return SUCCESS;
    }

}

/** contains
  *
  * Traverses the struct user_list, trying to see if the struct user_list contains some
  * data. We say the list contains some input if there exists some user with
  * equal data as the input.
  *
  * You should use 'user_equal' here to compare the data. Note that pointers are
  * allowed to be null!
  *
  * If there are multiple pieces of data in the struct user_list which are equal to
  * the "data" parameter, return the one at the lowest index.
  *
  *
  * @param list a pointer to the struct user_list structure
  * @param data The data, to see if it exists in the struct user_list
  * @param dataOut A pointer to a pointer used to return the data contained in
  *                the struct user_list or NULL on failure
  * @return int    FAILURE if dataOut is NULL, the list is NULL, or the list
  *                does not contain data, else SUCCESS
  */
int contains(struct user_list *list, struct user *data, struct user **dataOut)
{
    if (list == NULL || dataOut == NULL) {
        return FAILURE;
    } else {
        struct user *temp = list -> head;
        int i = 0;
        while (i < list-> size) {
            if (user_equal(data, temp)) {
                *dataOut = temp;
                return SUCCESS;
            }
            temp = temp->next;
            i++;
        }
        *dataOut = NULL;
        return FAILURE;
    }
}

/** pop_front
  *
  * Removes the user at the front of the struct user_list, and returns its data.
  *
  * @param list a pointer to the struct user_list.
  * @param dataOut A pointer to a pointer used to return the data in the first
  *                struct user or NULL if the struct user_list is NULL or empty
  * @return FAILURE if dataOut is NULL (the struct user_list is NULL or empty),
  *         else SUCCESS
  */
int pop_front(struct user_list *list, struct user **dataOut)
{
    if (list == NULL || list->size == 0) {
        return FAILURE;
    } else {
        *dataOut = list->head;
        if (list->size == 1) {
            list->head = NULL;
            list->tail = NULL;
        } else {
            list->head = list->head->next;
            list->tail->next = list->head;
        }
        list->size -= 1;
        return SUCCESS;
    }
}
/** pop_back
  *
  * Removes the user at the back of the struct user_list, and returns its data.
  *
  * @param list a pointer to the struct user_list.
  * @param dataOut A pointer to a pointer used to return the data in the last
  *                struct user or NULL if the struct user_list is NULL or empty
  * @return FAILURE if dataOut is NULL (the struct user_list is NULL or empty),
  *         else SUCCESS
  */
int pop_back(struct user_list *list, struct user **dataOut)
{
    if (list == NULL || list->size == 0) {
        return FAILURE;
    } else {
        *dataOut = list->tail;
        if (list->size == 1) {
            list->head = NULL;
            list->tail = NULL;
        } else {
            struct user *temp = list -> head;
            for (int i = 1; i < list->size - 1; i++) {
                temp = temp->next;
            }
            temp->next = list->head;
            list->tail = temp;
        }
        list->size -= 1;
        return SUCCESS;
    }
}


/** remove_at_index
 *
 * Remove the element at the specified index in the struct user_list.
 *
 * @param list a pointer to the struct user_list structure
 * @param dataOut A pointer to a pointer used to return the data in the 
 *                struct user at index or NULL if the struct user_list is NULL or empty
 * @param index 0-based, starting from the head in the inclusive range
 *              [0,size-1]
 * @return FAILURE if the index is out of bounds, the struct user_list is NULL or
 *         the dataOut is NULL
 *         otherwise return SUCCESS
 */
int remove_at_index(struct user_list *list, struct user **dataOut, int index)
{
    if (list == NULL || index < 0 || index > list -> size || dataOut == NULL) {
        return FAILURE;
    } else if (index == 0) {
        pop_front(list, dataOut);
        return SUCCESS;
    } else if (index == list->size - 1) {
        pop_back(list, dataOut);
        return SUCCESS;
    } else {
        struct user *temp = list->head;
        for (int i = 0; i < index - 1; i++) {
            temp = temp->next;
        }
        *dataOut = temp->next;
        temp->next = temp->next->next;
        list->size -= 1;
        return SUCCESS;
    }
}

/** empty_list
 *
 * Empties the struct user_list. After this is called, the struct user_list should be
 * empty. This does NOT free the struct user_list struct itself, just all users and
 * data within. Make sure to check that the list is not NULL before
 * using it.
 *
 * Once again, the things that need to be freed after this function are:
 * - the user structs
 * - all pointers in the user struct (and the union within)
 *
 * However, if you're using other functions you've written (which you should be),
 * those functions might take care of some of the freeing for you.
 *
 * You may call free on a char pointer as well as a struct pointer.
 *
 * If 'list' is NULL, don't do anything.
 *
 * @param list a pointer to the struct user_list structure
 */
void empty_list(struct user_list *list)
{
    if (list != NULL) {
        struct user *temp = list->head;
        struct user *temp2 = list->head;
        for (int i = 0; i < list->size; i++) {
            free(temp->name);
            if (temp->type == STUDENT) {
                free(temp->data.student.grades);
            }
            temp2 = temp2->next;
            free(temp);
            temp = temp2;
        }
        list->head = NULL;
        list->tail = NULL;
        list->size = 0;
    }
}

/** get_highest_paid
 *
 * Traverses the struct user_list, determining the highest of all instructor salaries and
 * returning the struct user corresponding to the highest paid instructor.
 *
 * If there are multiple highest paid instructors in the list, return the one that shows up
 * earlier in the list (closer to head).
 *
 * You should make sure your code only looks at instructors, as students do not have salaries!
 *
 * If there are no instructors in the list, place NULL at dataOut.
 *
 * @param list a pointer to the struct user_list structure
 * @param dataOut A pointer to pointer to struct user used to return the highest paid instructor.
 *                  or NULL if there are no instructors or the list is NULL or empty
 * @return FAILURE if the struct user_list is NULL or empty, else SUCCESS
 */
int get_highest_paid(struct user_list *list, struct user **dataOut)
{
    if (list == NULL || list->size == 0) {
        *dataOut = NULL;
        return FAILURE;
    } else {
        *dataOut = NULL;
        struct user *temp = list->head;
        double max = -1;
        for (int i = 0; i < list->size; i++) {
            if (temp->type == INSTRUCTOR) {
                if (temp->data.instructor.salary > max) {
                    *dataOut = temp;
                    max = temp->data.instructor.salary;
                }
            }
            temp = temp->next;
        }
        return SUCCESS;
    }
}


/** is_passing_all_classes
 *
 * Traverses the struct user_list, finding the student with the given name and 
 * determining whether they're passing all their classes.
 * 
 * We say a student is passing a class if their grade is greater than 
 * or equal to 60.
 *
 * You should make sure your code only considers students, even if there is 
 * an instructor of the same name!
 *
 * If a student is not taking any classes, they are NOT considered to be passing.
 *
 * @param list a pointer to the struct user_list structure
 * @param dataOut A pointer to int used to return whether or not the student 
 *                is passing their classes. Insert 1 if they are passing, 
 *                0 if they are not, or -1 if the user_list is NULL or empty 
 *                or does not contain the student with the given name.
 * @return FAILURE if the struct user_list is NULL or empty or does not contain
 *                 the student name passed in as a parameter, else SUCCESS
 */
int is_passing_all_classes(struct user_list *list, char *name, int *dataOut)
{
    if (list == NULL || list->size == 0) {
        *dataOut = -1;
        return FAILURE;
    } else {
        struct user *temp = list->head;
        for (int i = 0; i < list->size; i++) {
            if (temp->type == STUDENT) {
                if (strcmp(temp->name, name) == 0) {
                    if (temp->data.student.num_classes == 0) {
                        *dataOut = 0;
                        return SUCCESS;
                    }
                    for (int k = 0; k < temp->data.student.num_classes; k++) {
                        if (temp->data.student.grades[k] < 60) {
                            *dataOut = 0;
                            return SUCCESS;
                        }
                    }
                    *dataOut = 1;
                    return SUCCESS;
                }

            }
            temp = temp->next;
        }
        *dataOut = -1;
        return FAILURE;
    }

    return 0;
}

/** end_semester
 *
 * Traverses the struct user_list, performing an operation on each user.
 *
 * For students:
 *    - All classes should be dropped (num_classes = 0)
 *    - The grades array should be updated accordingly (set to NULL)
 *    - You should not leak memory while doing this
 * For instructors:
 *    - You should add 10000 to their current salary.
 *
 * @param list a pointer to the struct user_list structure
 * @return FAILURE if the struct user_list is NULL or empty,
 *                else SUCCESS
 */
int end_semester(struct user_list *list)
{
    if (list == NULL || list->size == 0) {
        return FAILURE;
    } else {
        struct user *temp = list->head;
        for (int i = 0; i < list->size; i++) {
            if (temp->type == STUDENT) {
                temp->data.student.num_classes = 0;
                free(temp->data.student.grades);
                temp->data.student.grades = NULL;
            } else if (temp->type == INSTRUCTOR) {
                temp->data.instructor.salary += 10000;
            }
            temp = temp->next;
        }
        return SUCCESS;
    }

}
