module Utils where 
import Types
import Debug.Trace
import System.Random


-- Print the enviroment
printEnviroment :: Enviroment -> Enviroment
printEnviroment env = printEnviroment_ env 0 0 "|"

printEnviroment_ :: Enviroment -> Int -> Int -> [Char] -> Enviroment
printEnviroment_ env i j str =
    if i == (nRows env)
        then trace ((strLine (nColumns env)) ++ "\n") env
    else if j == (nColumns env)
        then trace (strLine (nColumns env)) (trace (str) (printEnviroment_ env (i+1) 0 "|"))
    else 
        let pos = strSquare env i j
        in printEnviroment_ env i (j+1) (str ++ pos)


-- Help functions for printing the enviroment
strSquare :: Enviroment -> Int -> Int -> [Char]
strSquare env i j = 
    let square = Square {row = i, column = j}
    in  
        if isAnObstacle env square
            then "  O  |"
        else if isADirt env square && isARobot env square && isAChild env square
            then " DRN |"
        else if isADirt env square && isARobot env square
            then " DR  |"
        else if isADirt env square
            then "  D  |"
        else if isACorral env square && isAChild env square && isARobot env square   
            then " CNR |"
        else if isACorral env square && isAChild env square
            then " CN  |"
        else if isACorral env square && isARobot env square
            then " CR  |"
        else if isACorral env square
            then "  C  |"
        else if isAChild env square && isARobot env square
            then " NR  |"
        else if isAChild env square
            then "  N  |"
        else if isARobot env square
            then "  R  |"
        else "     |"

strLine :: Int -> [Char]
strLine nColumns = strLine_ nColumns ""

strLine_ :: Int -> [Char] -> [Char]
strLine_ nColumns str =
    if nColumns == 0
        then str ++ "-"
    else strLine_ (nColumns-1) (str ++ "------")


-- Print the current time of the enviroment
printCurrentTime :: Enviroment -> Enviroment
printCurrentTime env = trace("Time " ++ show (currentTime env)) env 


-- Return a random set of at least k elements from a list
getRandomElements :: [Square] -> Int -> StdGen -> (StdGen, [Square])
getRandomElements elements count s =
    if length elements == 0
        then (s, [])
    else getRandomElements_ elements count [] s

getRandomElements_ :: [Square] -> Int -> [Square] -> StdGen -> (StdGen, [Square])
getRandomElements_ elements count selected s =
     if count == 0
        then (s, selected)
    else 
        let n = (length elements) - 1
            (r, s1) = randomR (0, n :: Int) s
            e = elements !! r
        in 
            if e `elem` selected 
                then getRandomElements_ elements (count - 1) selected s1
            else 
                getRandomElements_ elements (count - 1) (selected ++ [e]) s1  


-- Return True if the square is clean
isCleanSquare :: Enviroment -> Square -> Bool
isCleanSquare env square =
    if isADirt env square || isAChild env square || isARobot env square || isACorral env square || isAnObstacle env square || not (isValidSquare env square)
        then False
    else True


-- Return True if the square is inside the enviroment
isValidSquare :: Enviroment -> Square -> Bool
isValidSquare env square = 
    if (row square) < 0 || (column square) < 0 || (row square) >= (nRows env) || (column square) >= (nColumns env) 
        then False
    else True


-- Return true if inside the square there is a child
isAChild :: Enviroment -> Square -> Bool
isAChild env square = square `elem` (children env)


-- Return true if inside the square there is a dirt
isADirt :: Enviroment -> Square -> Bool
isADirt env square = square `elem` (dirt env)


-- Return true if inside the square there is a corral
isACorral :: Enviroment -> Square -> Bool
isACorral env square = square `elem` (corral env)


-- Return true if inside the square there is a robot
isARobot :: Enviroment -> Square -> Bool
isARobot env square = square `elem` (robots env)


-- Return true if inside the square there is a robot
isAnObstacle :: Enviroment -> Square -> Bool
isAnObstacle env square = square `elem` (obstacles env)