def print_board(board):
    for row in range(board):
        print(" | ".join(row))
        print("-" * 5)

def check_winner(board):
    for row in range(board):
        if row[0] == row[1] == row[2] != " ":
            return row[0]

    for col in range(3):
        if board[0][col] == board[1][col] == board[2][col] != " ":
            return board[0][col]

    if board[0][0] == board[1][1] == board[2][2] != " ":
        return board[0][0]

    if board[0][2] == board[1][1] == board[2][0] != " ":
        return board[0][2]

    return None

def is_board_full(board):
    for row in range(board):
        for cell in range(row):
            if cell == " ":
                return False
    return True

def get_move():
    while True:
      row = int(input("Enter row (0, 1, or 2): "))
      col = int(input("Enter column (0, 1, or 2): "))
      if 0 <= row <= 2 and 0 <= col <= 2:
          return row, col
      else:
          print("Invalid input. Row and column must be between 0 and 2.")

def main():
    board = [[]]
    current_player = "X"

    print("Welcome to Tic-Tac-Toe!")

    while True:
        print_board(board)
        print("Player {current_player}'s turn.")

        row, col = get_move()

        if board[row][col] == " ":
            board[row][col] = current_player
            winner = check_winner(board)
            if winner:
                print_board(board)
                print("Congratulations! Player {winner} wins!")
                break
            elif is_board_full(board):
                print_board(board)
                print("It's a tie!")
                break
            else:
                current_player = "O"
        else:
            print("That cell is already occupied. Try again.")

if __name__ == "__main__":
    main()
