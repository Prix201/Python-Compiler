#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct{
  char *key;
  int value;
} Entry;

typedef struct{
  Entry *entries;
  int size;
  int capacity;
} UnorderedMap;


int hash(char *key)
{
  int hash = 0;
  while (key[0]){
    // as id : [a-zA-Z_0-9] -> sums up to 70 charachters
    hash = (hash * 63) + *key;
    key++;
  }
  return hash;
}

UnorderedMap *create_unordered_map(int capacity)
{
  UnorderedMap *map = (UnorderedMap *)malloc(sizeof(UnorderedMap));
  map->entries = (Entry *)malloc(sizeof(Entry) * capacity);
  map->size = 0;
  map->capacity = capacity;
  return map;
}

void put(UnorderedMap *map, char *key, int value)
{
  int index = hash(key) % map->capacity;
  Entry *entry = &map->entries[index];
  while (entry->key != NULL)
  {
    if (strcmp(entry->key, key) == 0)
    {
      entry->value = value;
      return;
    }
    index = (index + 1) % map->capacity;
    entry = &map->entries[index];
  }
  entry->key = key;
  entry->value = value;
  map->size++;
}

int get(UnorderedMap *map, char *key)
{
  int index = hash(key) % map->capacity;
  Entry *entry = &map->entries[index];
  while (entry->key != NULL)
  {
    if (strcmp(entry->key, key) == 0)
    {
      return entry->value;
    }
    index = (index + 1) % map->capacity;
    entry = &map->entries[index];
  }
  return -1;
}

void remove_entry(UnorderedMap *map, char *key)
{
  int index = hash(key) % map->capacity;
  Entry *entry = &map->entries[index];
  while (entry->key != NULL)
  {
    if (strcmp(entry->key, key) == 0)
    {
      entry->key = NULL;
      map->size--;
      return;
    }
    index = (index + 1) % map->capacity;
    entry = &map->entries[index];
  }
}

void destroy_unordered_map(UnorderedMap *map)
{
  free(map->entries);
  free(map);
}