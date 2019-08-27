protocol Game {
    var name: String { get }
    var state: String { get }
}

protocol GameTracking {
    func gameDidStart(_ game: Game)
    func gameDidUpdateState(_ game: Game)
    func gameDidEnd(_ game: Game)
}

struct Tracker: GameTracking {
    func gameDidStart(_ game: Game) {
        print("\(game.name) did start!")
    }
    
    func gameDidUpdateState(_ game: Game) {
        print("Game did update:\n\(game.state)")
    }
    
    func gameDidEnd(_ game: Game) {
        print("\(game.name) did end")
    }
}

enum BoardType: Int {
    case small = 3
    case middle = 5
    case large = 7
}

struct MatrixIndex: Hashable {
    let row, column: Int
    
    init(_ row: Int, _ column: Int) {
        self.row = row
        self.column = column
    }
    
    func onMainDiagonal() -> Bool {
        return row == column
    }
    
    func onCounterDiagonal(_ matrixSize: Int) -> Bool {
        return row == matrixSize - 1 - column
    }
}

struct Matrix {
    
    let boardSize: Int
    let boardType: BoardType
    var board: [Character]
    
    init(_ type: BoardType) {
        self.boardType = type
        boardSize = type.rawValue
        board = Array(repeating: "_", count: boardSize * boardSize)
    }
    
    subscript(index: MatrixIndex) -> Character {
        set {
            board[index.row * boardSize + index.column] = newValue
        }
        
        get {
            return board[index.row * boardSize + index.column]
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

struct TicTacToe {
    var matrix: Matrix
    var isXWinner: Bool?
    var lastStep: MatrixIndex? = nil
    
    var tracker: GameTracking?
    
    init(_ boardType: BoardType, _ tracker: GameTracking? = nil) {
        matrix = Matrix(boardType)
        self.tracker = tracker
        self.tracker?.gameDidStart(self)
    }
    
    mutating func stepPlayerX(_ matrIdx: MatrixIndex) {
        print("\nStep of player X")
        matrix[matrIdx] = "x"
        lastStep = matrIdx
        tracker?.gameDidUpdateState(self)
    }
    
    mutating func stepPlayerO(_ matrIdx: MatrixIndex) {
        print("Step of player O")
        matrix[matrIdx] = "o"
        lastStep = matrIdx
        tracker?.gameDidUpdateState(self)
    }
    
    func checkRowOnEqualValues(_ step: MatrixIndex) -> Bool {
        for colInd in 0 ..< matrix.boardSize - 1 {
            if matrix[MatrixIndex(step.row, colInd)] != matrix[MatrixIndex(step.row, colInd + 1)] {
                return false
            }
        }
        return true
    }
    
    func checkColumnOnEqualValues(_ step: MatrixIndex) -> Bool {
        for rowInd in 0 ..< matrix.boardSize - 1 {
            if matrix[MatrixIndex(rowInd, step.column)] != matrix[MatrixIndex(rowInd + 1, step.column)] {
                return false
            }
        }
        return true
    }
    
    func CheckMainDiagonalOnEqualValues() -> Bool {
        for idx in 0 ..< matrix.boardSize - 1 {
            if matrix[MatrixIndex(idx, idx)] != matrix[MatrixIndex(idx + 1, idx + 1)] {
                return false
            }
        }
        return true
    }
    
    func CheckCounterDiagonalOnEqualValues() -> Bool {
        for idx in 0 ..< matrix.boardSize - 1 {
            if (matrix[MatrixIndex(idx, matrix.boardSize - 1 - idx)] != matrix[MatrixIndex(idx + 1, matrix.boardSize - 2 - idx)]) {
                return false
            }
        }
        return true
    }
    
    mutating func checkEnd() -> Bool {
        guard let step = lastStep else {
            return false
        }
        
        var isEnd = checkRowOnEqualValues(step)
        
        if !isEnd {
            isEnd = checkColumnOnEqualValues(step)
        } else {
            isXWinner = (matrix[step] == "x") ? true : false
            return true
        }
        
        if isEnd {
            isXWinner = (matrix[step] == "x") ? true : false
            return true
        }
        
        // check step situation on diagonal or counter-diagonal
        let onMainDiagonal = step.onMainDiagonal()
        let onCounterDiagonal = step.onCounterDiagonal(matrix.boardSize)
        
        if !onMainDiagonal || !onCounterDiagonal {
            return isEnd
        }
        
        if onMainDiagonal {
            isEnd = CheckMainDiagonalOnEqualValues()
        }
        
        if isEnd {
            isXWinner = (matrix[step] == "x") ? true : false
            return true
        }
        
        if onCounterDiagonal {
            isEnd = CheckCounterDiagonalOnEqualValues()
        }
        
        if isEnd {
            isXWinner = (matrix[step] == "x") ? true : false
            return true
        }
        
        return isEnd
    }
}

extension TicTacToe: Game {
    var name: String {
        return "TicTacToe"
    }
    
    var state: String {
        var str = ""
        for i in 0 ..< matrix.board.count {
            if i % matrix.boardSize == 0 {
                str += "\n"
            }
            str += (String(matrix.board[i]) + " ")
        }
        return str
    }
}

var game = TicTacToe(BoardType.middle, Tracker())

var indices = game.matrix.indices

var isXTurn = true

while !game.checkEnd() && !indices.isEmpty {
    let idx = indices.randomElement()
    isXTurn ? game.stepPlayerX(idx!) : game.stepPlayerO(idx!)
    indices.remove(idx!)
    print("Value: \(game.matrix[idx!])")
    isXTurn = !isXTurn
}

switch(game.isXWinner) {
case true:
    print("The winner is X")
case false:
    print("The winner is O")
case nil:
    print("No winner")
default:
    print("Invalid case")
}

