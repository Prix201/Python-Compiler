#include<stdio.h>
#include<stdlib.h>
#include<string.h>

typedef struct node{
    int type;
    int no_of_childs;
    struct node * child_nodes[1000];
    char name[100];
    char value[100];
}node;

node* create_new_node(char*a,char*b){
    node*temp = (node*)malloc(sizeof(node));
    
    strcpy(temp->name,a);
    strcpy(temp->value,b);
    
    temp->type = 0;
    temp->no_of_childs = 0;
    for(int i = 0 ; i < 1000 ; i ++)temp->child_nodes[i] = NULL;

    return temp;
}

void add_new_child(node*parent,node*child){
    if(child == NULL)return;
    if(parent == NULL)return;

    parent->child_nodes[parent->no_of_childs++] = child;
}

int count = 0;





void print_all_node(node*head,FILE*file,char*name){
    if(!head)return;

    if(head->type == 1 && head->no_of_childs == 1){
        print_all_node(head->child_nodes[0],file,name);
        return;
    }

    node*temp = head;

    char node_name[20] = "node_";
    char num[20];
    sprintf(num, "%d", count++);
    strcat(node_name, num);
    fprintf (file ," %s [label = \"%s\"]\n",node_name,head->name);

    for(int i = 0 ; i < head->no_of_childs ; i ++){
        char child_name[20];
        print_all_node(head->child_nodes[i],file,child_name);
        fprintf(file , " %s -> %s\n",node_name,child_name);
    }

    if(!strcmp(head->name,"INT") || !strcmp(head->name,"NAME") || !strcmp(head->name,"FLOAT")){
        char child_name[20] = "node_";
        char num[20];
        sprintf(num, "%d", count++);
        strcat(child_name, num);
        fprintf (file ," %s [label = \"%s\"]\n",child_name,head->value);
        fprintf(file , " %s -> %s\n",node_name,child_name);
    }

    if(!strcmp(head->name,"STRING")){
        char child_name[20] = "node_";
        char num[20];
        sprintf(num, "%d", count++);
        strcat(child_name, num);
        fprintf (file ," %s [label = \"",child_name);
        for(int i = 1 ; i < strlen(head->value) - 1 ; i ++)fprintf(file,"%c",head->value[i]);
        fprintf(file , "\"]\n");
        fprintf(file , " %s -> %s\n",node_name,child_name);
    }

    strcpy(name,node_name);
}
void print_it(node*head){
    FILE *file = fopen("output.dot", "w");


    fprintf(file,"digraph G {\n");
    fprintf(file," node [shape=ellipse, style=filled, fillcolor=white]\n");
    char  a[20];
    print_all_node(head,file,a);
    fprintf(file,"}\n");
    fclose(file);

}