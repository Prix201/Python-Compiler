class Hangman:
    def __init__(self, word_list):
        self.word_list = word_list
        self.word = random.choice(word_list)
        self.guesses_left = 6
        self.guessed_letters = set()
        self.display_word = ['_'] * len(self.word)

    def display_current_state(self):
        print(" ".join(self.display_word))
        print("Guesses left: {self.guesses_left}")

    def check_guess(self, guess):
        if guess in self.guessed_letters:
            print("You've already guessed that letter.")
            return
        self.guessed_letters.add(guess)
        if self.word:
            self.guesses_left -= 1
            print("Incorrect guess.")
        else:
            print("Correct guess!")
            if letter == guess:
                self.display_word[i] = guess

    def check_win(self):
        return self.display_word

def main():
    word_list = ['python', 'hangman', 'programming', 'computer', 'algorithm']
    hangman_game = Hangman(word_list)

    print("Welcome to Hangman!")
    print("Try to guess the word.")
    hangman_game.display_current_state()

    while True:
        guess = input("Enter a letter: ").lower()
        hangman_game.check_guess(guess)
        hangman_game.display_current_state()

        if hangman_game.check_win():
            print("Congratulations! You guessed the word.")
            break
        elif hangman_game.guesses_left == 0:
            print("Sorry, you ran out of guesses. The word was:", hangman_game.word)
            break

if __name__ == "__main__":
    main()
