class Player:
    def __init__(self, name):
        self.name = name
        self.health = 100
        self.items = []

    def take_damage(self, damage):
        self.health -= damage

    def heal(self, amount):
        self.health += amount

    def add_item(self, item):
        self.items.append(item)

class Enemy:
    def __init__(self, name, damage):
        self.name = name
        self.damage = damage

    def attack(self, player):
        player.take_damage(self.damage)
        print("{self.name} attacks you for {self.damage} damage!")

class Item:
    def __init__(self, name, description):
        self.name = name
        self.description = description

class Room:
    def __init__(self, name, description, enemy, item):
        self.name = name
        self.description = description
        self.enemy = enemy
        self.item = item

    def describe_room(self):
        print(self.description)
        if self.enemy:
            print("You see a {self.enemy.name} in the room!")
        if self.item:
            print("You find a {self.item.name}.")

def main():
    player_name = input("Enter your name: ")
    player = Player(player_name)

    enemy1 = Enemy("Goblin", 10)
    enemy2 = Enemy("Skeleton", 15)

    item1 = Item("Potion", "Restores 20 health.")
    item2 = Item("Sword", "Deals 10 extra damage.")

    room1 = Room("Hallway", "You are in a dark hallway.")
    room2 = Room("Library", "You find yourself in an old library.", enemy1, item1)
    room3 = Room("Dungeon", "You enter a damp dungeon.", enemy2, item2)

    current_room = room1

    print("Welcome, {player_name}! Let's begin the adventure.")

    while True:
        current_room.describe_room()
        action = input("What do you want to do? (attack/heal/move): ")

        if action == "attack":
            if current_room.enemy:
                current_room.enemy.attack(player)
            else:
                print("There is nothing to attack here.")
        elif action == "heal":
            player.heal(20)
            print("You heal yourself for 20 health.")
        elif action == "move":
            direction = input("Which direction do you want to move? (left/right): ")
            if direction == "left":
                current_room = room2
            elif direction == "right":
                current_room = room3
            else:
                print("Invalid direction.")
        else:
            print("Invalid action.")

        if player.health <= 0:
            print("Game over. You have been defeated!")
            break
        elif current_room.enemy and player.health > 0:
            print("You're still in combat. Be careful!")

if __name__ == "__main__":
    main()
