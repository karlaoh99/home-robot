module Main where
import Types
import Utils
import Child
import Robot
import Data.Set as Set
import Debug.Trace
import System.Random
   
  
main = do
    let env = trace "Initial enviroment" (printEnviroment (initEnviroment 6 6 30 3))
    let env1 = simulateTurn env
    let isClean = houseIsClean env1
    if isClean
        then print("The simulation finished and the house is clean")
    else print("The simulation finished and the house is not clean")


naturalChange :: Enviroment -> Enviroment
naturalChange env = robotsTurn env (robots env)


randomChange :: Enviroment -> Enviroment
randomChange env = childrenTurn env (children env) 

 
simulateTurn :: Enviroment -> Enviroment
simulateTurn env =
    if (currentTime env) == (finalTime env) 
        then env
    else  
        let env1 = printCurrentTime (updateCurrentTime env)
            env2 = naturalChange env1
        in  
            if ((currentTime env1) `mod` (randomTime env1)) == 0
                then 
                    let env3 = randomChange env2 
                    in simulateTurn (printEnviroment env3)
            else
                simulateTurn (printEnviroment env2)
   

houseIsClean :: Enviroment -> Bool
houseIsClean env = 
    let squares = (obstacles env) ++ (dirt env) ++ (corral env) ++ (children env) ++ (robots env)
        setSquares = Set.fromList squares
        cleanSquares = ((nRows env) * (nColumns env)) - (length setSquares) 
    in fromIntegral cleanSquares >=  0.6 * fromIntegral (nRows env) * fromIntegral (nColumns env)