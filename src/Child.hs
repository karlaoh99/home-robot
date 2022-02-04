module Child where
import Types
import Utils
import Debug.Trace


-- Return True if a child can move to the square
isValidChildSquare :: Enviroment -> Square -> Bool
isValidChildSquare env square =
    if isADirt env square || isAChild env square || isARobot env square || isACorral env square || not (isValidSquare env square)
        then False
    else True


-- Return the valid positions at which a child can be moved
getValidChildPositions :: Enviroment -> Square -> [Square]
getValidChildPositions env child =
    getValidChildPositions_ env [ Square {row = row child, column = (column child) + 1},
                                  Square {row = (row child) + 1, column = column child},
                                  Square {row = row child, column = (column child) - 1},
                                  Square {row = (row child) - 1, column = column child} ] []

getValidChildPositions_ :: Enviroment -> [Square] -> [Square] -> [Square] 
getValidChildPositions_ env [] elements = elements
getValidChildPositions_ env (s:xs) elements =
    if isValidChildSquare env s
        then getValidChildPositions_ env xs (elements ++ [s])
    else getValidChildPositions_ env xs elements


-- Return the valid positions at which a child can generate dirt
getValidDirtPositions :: Enviroment -> Square -> [Square]
getValidDirtPositions env child =
    getValidDirtPositions_ env [ Square {row = row child, column = column child},
                                 Square {row = row child, column = (column child) + 1},
                                 Square {row = (row child) + 1, column = column child},
                                 Square {row = row child, column = (column child) - 1},
                                 Square {row = (row child) - 1, column = column child},
                                 Square {row = (row child) - 1, column = (column child) + 1},
                                 Square {row = (row child) + 1, column = (column child) + 1},
                                 Square {row = (row child) + 1, column = (column child) - 1},
                                 Square {row = (row child) - 1, column = (column child) - 1} ] []

getValidDirtPositions_ :: Enviroment -> [Square] -> [Square] -> [Square] 
getValidDirtPositions_ env [] elements = elements
getValidDirtPositions_ env (s:xs) elements =
    if isCleanSquare env s
        then getValidDirtPositions_ env xs (elements ++ [s])
    else getValidDirtPositions_ env xs elements


-- Return the position that an object is going to be moved to
getObstaclePosition :: Enviroment -> Square -> Int -> Square
getObstaclePosition env square d =
    if not (isValidSquare env square)
        then Square {row = -1, column = -1}
    else if d == 0
        then 
            let s = Square {row = row square, column = (column square) + 1}
            in 
                if s `elem` (obstacles env)
                    then getObstaclePosition env s d
                else if not (s `elem` (dirt env) || s `elem` (corral env) || s `elem` (children env) || s `elem` (robots env))
                    then s
                else Square {row = -1, column = -1}
    else if d == 1
        then
            let s = Square {row = (row square) + 1, column = column square}
            in 
                if s `elem` (obstacles env)
                    then getObstaclePosition env s d
                else if not (s `elem` (dirt env) || s `elem` (corral env) || s `elem` (children env) || s `elem` (robots env))
                    then s
                else Square {row = -1, column = -1}
    else if d == 2
        then
            let s = Square {row = row square, column = (column square) - 1}
            in 
                if s `elem` (obstacles env)
                    then getObstaclePosition env s d
                else if not (s `elem` (dirt env) || s `elem` (corral env) || s `elem` (children env) || s `elem` (robots env))
                    then s
                else Square {row = -1, column = -1}
    else
        let s = Square {row = (row square) - 1, column = column square}
        in 
            if s `elem` (obstacles env)
                then getObstaclePosition env s d
            else if not (s `elem` (dirt env) || s `elem` (corral env) || s `elem` (children env) || s `elem` (robots env))
                then s
            else Square {row = -1, column = -1}


-- Return the direction that an object is going to be moved
getDirection :: Square -> Square -> Int
getDirection square1 square2 =
    if (row square1) == (row square2) && (column square1) < (column square2)
        then 0
    else if (row square1) < (row square2) && (column square1) == (column square2)
        then 1
    else if id (row square1) == (row square2) && (column square1) > (column square2)
        then 2
    else 3


-- Execute a child action
childAction :: Enviroment -> Square -> Enviroment
childAction env child = 
    let (s, squares) = getRandomElements (getValidChildPositions env child) 1 (stdGen env)
        env1 = updateStdGen env s
    in
        if length squares == 0 
            then trace ("Child in position " ++ show child ++ " can not move") env1 
        else 
            let square = squares !! 0
            in
                if isAnObstacle env1 square
                    then 
                        let o = getObstaclePosition env1 square (getDirection child square)
                        in 
                            if o == (Square {row = -1, column = -1})
                                then trace ("Child tried to move from " ++ show child ++ " to " ++ show square) env1
                            else
                                let obstacles1 = filter (/= square) (obstacles env1)
                                    obstacles2 = obstacles1 ++ [o]
                                    env2 = updateObstacles env1 obstacles2
                                    children1 = filter (/= child) (children env2)
                                    children2 = children1 ++ [square]
                                    env3 = trace ("Child move from " ++ show child ++ " to " ++ show square) (updateChildren env2 children2)
                                    (s1, dirts) = getRandomElements (getValidDirtPositions env3 child) 1 (stdGen env3)
                                in 
                                    if length dirts == 0
                                        then env3
                                    else
                                        let dirt1 = dirts !! 0
                                            env4 = updateStdGen env3 s1 
                                            env5 = updateDirt env4 ((dirt env4) ++ [dirt1])
                                        in trace ("Child generated dirt at " ++ show dirt1) env5
                else 
                    let children1 = filter (/= child) (children env1)
                        children2 = children1 ++ [square]
                        env2 = trace("Child move from " ++ show child ++ " to " ++ show square) (updateChildren env1 children2)
                        (s1, dirts) = getRandomElements (getValidDirtPositions env2 child) 1 (stdGen env2)
                    in 
                        if length dirts == 0
                            then env2
                        else
                            let dirt1 = dirts !! 0
                                env3 = updateStdGen env2 s1 
                                env4 = updateDirt env3 ((dirt env3) ++ [dirt1])
                            in trace ("Child generated dirt at " ++ show dirt1) env4


-- Execute the action of each child
childrenTurn :: Enviroment -> [Square]-> Enviroment
childrenTurn env [] = env
childrenTurn env (c:cs) = 
    if isARobot env c || isACorral env c
        then trace ("Child in position " ++ show c ++ " can not move") (childrenTurn env cs) 
    else 
        let env1 = childAction env c
        in childrenTurn env1 cs  