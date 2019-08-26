import Foundation
import UIKit

enum BoardType: Int {
    case small = 3
    case middle = 5
    case large = 7
}

struct Matrix {
    let boardSize: Int
    let boardType: BoardType
    var board: [Character]
    var isXWinner = false
    var haveWinner = false
    
    init(boardType: BoardType) {
        self.boardType = boardType
        boardSize = self.boardType.rawValue
        board = Array(repeating: "_", count: boardSize * boardSize)
    }
    
    struct MatrixIndex: Hashable {
        let row, column: Int
        
        init(_ row: Int, _ column: Int) {
            self.row = row
            self.column = column
        }
    }
    
    mutating func stepPlayerX(_ matrIdx: MatrixIndex) {
        print("")
        print("Step of player X")
        
        board[matrIdx.row * boardSize + matrIdx.column] = "x"
    }
    
    mutating func stepPlayerO(_ matrIdx: MatrixIndex) {
        print("")
        print("Step of player O")
        
        board[matrIdx.row * boardSize + matrIdx.column] = "o"
    }
    
    func currentBoardState() {
        for i in 0 ..< boardSize * boardSize {
            if i % boardSize == 0 {
                print("")
            }
            print(board[i], terminator: " ")
        }
        print("")
    }

    mutating func checkEnd() -> Bool {
        switch boardType {
        case .small:
            for i in 0 ..< boardSize {
                if (board[i] == board[i + 1]) && (board[i + 1] == board[i + 2]) && (board[i + 2] != "_") {
                    if board[i] == "x" {
                        isXWinner = true
                    }
                    haveWinner = true
                    return haveWinner
                } else if (board[i] == board[i + boardSize]) && (board[i + boardSize] == board[i + 2 * boardSize]) && (board[i + 2 * boardSize] != "_") {
                    if board[i] == "x" {
                        isXWinner = true
                    }
                    haveWinner = true
                    return haveWinner
                } else if (i == 0 && (board[0] == board[4]) && (board[4] == board[8]) && (board[8] != "_")) {
                    if board[i] == "x" {
                        isXWinner = true
                    }
                    haveWinner = true
                    return haveWinner
                } else if (i == 2 && (board[2] == board[4]) && (board[4] == board[6]) && (board[6] != "_")) {
                    if board[i] == "x" {
                        isXWinner = true
                    }
                    haveWinner = true
                    return haveWinner
                }
            }
            return haveWinner
        case .middle:
            print("No information about winner.")
            return false
        case .large:
            print("No information about winner.")
            return false
        }
    }
    
    var indices: Set<MatrixIndex> {
        var indices = Set<MatrixIndex>()
        for i in 0..<boardSize {
            for j in 0..<boardSize {
                indices.insert(MatrixIndex(i, j))
            }
        }
        return indices
    }
}

var game = Matrix(boardType: BoardType.small)
print("Start game")

var indices = game.indices
var isXTurn = true

game.currentBoardState()
//while let idx = indices.randomElement() {
//    isXTurn ? game.stepPlayerX(idx) : game.stepPlayerO(idx)
//    indices.remove(idx)
//    isXTurn = !isXTurn
//    game.currentBoardState()
//}

while !game.checkEnd() && !indices.isEmpty {
    let idx = indices.randomElement()
    isXTurn ? game.stepPlayerX(idx!) : game.stepPlayerO(idx!)
    indices.remove(idx!)
    isXTurn = !isXTurn
    game.currentBoardState()
}

if game.haveWinner {
    if game.isXWinner {
        print("The winner is X.")
    } else {
        print("The winner is O.")
    }
} else {
    print("No winner")
}

print("\nEnd game")


