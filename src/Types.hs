module Types where 
import System.Random
import Input


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


-- Init the enviroment
initEnviroment :: Enviroment
initEnviroment = 
    let (nRows, nColumns, finalTime, randomTime, rndSeed, obstacles, dirt, corral, children, robots) = initEnviromentVariables
        stdGen = mkStdGen rndSeed
    in Enviroment {
        nRows = nRows, 
        nColumns = nColumns, 
        currentTime = 0,
        finalTime = finalTime,
        randomTime = randomTime,
        obstacles = map convertToSquare obstacles,
        dirt = map convertToSquare dirt,
        corral = map convertToSquare corral,
        children = map convertToSquare children,
        robots = map convertToSquare robots, 
        stdGen = stdGen }

convertToSquare :: (Int, Int) -> Square
convertToSquare element = Square {row = (fst element), column = (snd element)}


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