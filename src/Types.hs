module Types where 
import System.Random


data Square = Square {
    row :: Int,
    column :: Int
} deriving (Show, Eq, Ord) 


data Enviroment = Enviroment {
    nRows :: Int,
    nColumns :: Int,
    currentTime :: Int,
    finalTime :: Int,
    randomTime :: Int,
    obstacles :: [Square],
    dirt :: [Square],
    corral :: [Square],
    children :: [Square],
    robots :: [Square],
    stdGen :: StdGen
} deriving (Show)  


-- TODO Init variables
-- Init the enviroment
initEnviroment :: Int -> Int -> Int -> Int -> Enviroment
initEnviroment nRows nColumns finalTime randomTime = 
    let obstacles = [Square {row = 3, column = 1}, Square {row = 3, column = 2}]
        dirt = [Square {row = 2, column = 1},  Square {row = 3, column = 4}]
        corral = [Square {row = 0, column = 4}, Square {row = 0, column = 5}]
        children = [Square {row = 0, column = 0}, Square {row = 5, column = 5}]
        robots = [Square {row = 1, column = 3}, Square {row = 0, column = 1}]  
        stdGen = mkStdGen 42      
    in Enviroment {
        nRows = nRows, 
        nColumns = nColumns, 
        currentTime = 0,
        finalTime = finalTime,
        randomTime = randomTime,
        obstacles = obstacles,
        dirt = dirt,
        corral = corral,
        children = children,
        robots = robots, 
        stdGen = stdGen }


-- Functions to edit the enviroment
updateCurrentTime :: Enviroment -> Enviroment
updateCurrentTime env =
    Enviroment {
        nRows = (nRows env), 
        nColumns = (nColumns env), 
        currentTime = (currentTime env) + 1,
        finalTime = (finalTime env),
        randomTime = (randomTime env),
        obstacles = (obstacles env),
        dirt = (dirt env),
        corral = (corral env),
        children = (children env),
        robots = (robots env), 
        stdGen = (stdGen env) }

updateObstacles :: Enviroment -> [Square] -> Enviroment
updateObstacles env obstacles =
    Enviroment {
        nRows = (nRows env), 
        nColumns = (nColumns env), 
        currentTime = (currentTime env),
        finalTime = (finalTime env),
        randomTime = (randomTime env),
        obstacles = obstacles,
        dirt = (dirt env),
        corral = (corral env),
        children = (children env),
        robots = (robots env), 
        stdGen = (stdGen env) }

updateDirt :: Enviroment -> [Square] -> Enviroment
updateDirt env dirt =
    Enviroment {
        nRows = (nRows env), 
        nColumns = (nColumns env), 
        currentTime = (currentTime env),
        finalTime = (finalTime env),
        randomTime = (randomTime env),
        obstacles = (obstacles env),
        dirt = dirt,
        corral = (corral env),
        children = (children env),
        robots = (robots env), 
        stdGen = (stdGen env) }

updateChildren :: Enviroment -> [Square] -> Enviroment
updateChildren env children =
    Enviroment {
        nRows = (nRows env), 
        nColumns = (nColumns env), 
        currentTime = (currentTime env),
        finalTime = (finalTime env),
        randomTime = (randomTime env),
        obstacles = (obstacles env),
        dirt = (dirt env),
        corral = (corral env),
        children = children,
        robots = (robots env), 
        stdGen = (stdGen env) }

updateRobots :: Enviroment -> [Square] -> Enviroment
updateRobots env robots =
    Enviroment {
        nRows = (nRows env), 
        nColumns = (nColumns env), 
        currentTime = (currentTime env),
        finalTime = (finalTime env),
        randomTime = (randomTime env),
        obstacles = (obstacles env),
        dirt = (dirt env),
        corral = (corral env),
        children = (children env),
        robots = robots, 
        stdGen = (stdGen env) }

updateStdGen :: Enviroment -> StdGen -> Enviroment
updateStdGen env stdGen =
    Enviroment {
        nRows = (nRows env), 
        nColumns = (nColumns env), 
        currentTime = (currentTime env),
        finalTime = (finalTime env),
        randomTime = (randomTime env),
        obstacles = (obstacles env),
        dirt = (dirt env),
        corral = (corral env),
        children = (children env),
        robots = (robots env), 
        stdGen = stdGen }