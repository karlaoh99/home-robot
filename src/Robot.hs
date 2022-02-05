module Robot where
import Types
import Utils
import Debug.Trace


-- Clean the dirt in the square 
cleanDirt :: Enviroment -> Square -> Enviroment
cleanDirt env square =
    let dirt1 = filter (/= square) (dirt env)
        env1 = updateDirt env dirt1
    in trace ("Robot cleaned dirt at " ++ show square) env1


-- Condition to find a valid child for the robot
conditionFindAChid :: Enviroment -> Square -> Bool
conditionFindAChid env square =
    if (isAChild env square) && not (isACorral env square) && not (isARobot env square)
        then True
    else False


-- Condition to find a valid corral for the robot
conditionFindACorral :: Enviroment -> Square -> Bool
conditionFindACorral env square =
    if (isACorral env square) && not (isAChild env square) && not (isARobot env square)
        then True
    else False


-- Move only the robot
moveRobot :: Enviroment -> Square -> Square -> Enviroment
moveRobot env from to =
    let robots1 = filter (/= from) (robots env)
    in updateRobots env (robots1 ++ [to])


-- Move the robot and the child
moveRobotAndChild :: Enviroment -> Square -> Square -> Enviroment
moveRobotAndChild env from to =
    let robots1 = filter (/= from) (robots env)
        env1 = updateRobots env (robots1 ++ [to])
        children1 = filter (/= from) (children env1)
    in updateChildren env1 (children1 ++ [to])


-- Return the position to which move that is the closest to a child
goToMostCloseChild :: Enviroment -> Square -> Enviroment
goToMostCloseChild env square =
    let (pos1, pos2) = bfs env square conditionFindAChid
    in 
        if pos2 /= Square {row = -1, column = -1}
            then trace ("Robot moved from " ++ show square ++ " to " ++ show pos2) (moveRobot env square pos2)
        else if pos1 /= Square {row = -1, column = -1}
            then trace ("Robot moved from " ++ show square ++ " to " ++ show pos1) (moveRobot env square pos1)
        else goToMostCloseDirt env square


-- Return the position to which move that is the closest to a corral
goToMostCloseCorral :: Enviroment -> Square -> Enviroment
goToMostCloseCorral env square =
    let (pos1, pos2) = bfs env square conditionFindACorral
    in 
        if pos1 /= Square {row = -1, column = -1}
            then trace ("Robot moved child from " ++ show square ++ " to " ++ show pos1) (moveRobotAndChild env square pos1)
        else if pos2 /= Square {row = -1, column = -1}
            then trace ("Robot moved child from " ++ show square ++ " to " ++ show pos2) (moveRobotAndChild env square pos2)
        else goToMostCloseDirt env square 


-- Return the position to which move that is the closest to a dirt
goToMostCloseDirt :: Enviroment -> Square -> Enviroment
goToMostCloseDirt env square =
    let (pos1, pos2) = bfs env square isADirt
    in 
        if pos1 /= Square {row = -1, column = -1} || pos2 /= Square {row = -1, column = -1}
            then 
                if pos2 /= Square {row = -1, column = -1}
                    then trace ("Robot moved from " ++ show square ++ " to " ++ show pos2) (moveRobot env square pos2)
                else 
                    trace ("Robot moved from " ++ show square ++ " to " ++ show pos1) (moveRobot env square pos1)
        else
            let (s, pos) = getRandomElements (getValidRobotPositions env square) 1 (stdGen env)
                env1 = updateStdGen env s
            in 
                if length pos == 0
                    then env1
                else
                    let pos1 = pos !! 0
                    in trace ("Robot moved from " ++ show square ++ " to " ++ show pos1) (moveRobot env1 square pos1) 


-- Return True if a robot can move to the square
isValidRobotSquare :: Enviroment -> Square -> Bool
isValidRobotSquare env square = 
    if isAnObstacle env square || isARobot env square || not (isValidSquare env square)
        then False
    else True


-- Return the valid positions at which a robot can be moved
getValidRobotPositions :: Enviroment -> Square -> [Square]
getValidRobotPositions env robot =
    getValidRobotPositions_ env [Square {row = row robot, column = (column robot) + 1},
                                 Square {row = (row robot) + 1, column = column robot},
                                 Square {row = row robot, column = (column robot) - 1},
                                 Square {row = (row robot) - 1, column = column robot}] []

getValidRobotPositions_ :: Enviroment -> [Square] -> [Square] -> [Square] 
getValidRobotPositions_ env [] elements = elements
getValidRobotPositions_ env (s:xs) elements =
    if isValidRobotSquare env s
        then getValidRobotPositions_ env xs (elements ++ [s])
    else getValidRobotPositions_ env xs elements


-- Run a BFS until it finds a square that meets the condition  
bfs :: Enviroment -> Square -> (Enviroment -> Square -> Bool) -> (Square, Square)
bfs env square condition = 
    let queue = []
        visited = []
        s0 = Square {row = row square, column = (column square) + 1}
        s1 = Square {row = (row square) + 1, column = column square}
        s2 = Square {row = row square, column = (column square) - 1}
        s3 = Square {row = (row square) - 1, column = column square}
        father = Square {row = -1, column = -1}
        dir0 = 
            if not (isValidSquare env s0) || s0 `elem` visited
                then ([], [])
            else if s0 `elem` (obstacles env) || s0 `elem` (robots env)
                then ([], [s0])
            else ([(s0, father)], [s0]) 
        dir1 = 
            if not (isValidSquare env s1) || s1 `elem` visited
                then ([], [])
            else if s1 `elem` (obstacles env) || s1 `elem` (robots env)
                then ([], [s1])
            else ([(s1, father)], [s1]) 
        dir2 = 
            if not (isValidSquare env s2) || s2 `elem` visited
                then ([], [])
            else if s2 `elem` (obstacles env) || s2 `elem` (robots env)
                then ([], [s2])
            else ([(s2, father)], [s2]) 
        dir3 = 
            if not (isValidSquare env s3) || s3 `elem` visited
                then ([], [])
            else if s3 `elem` (obstacles env) || s3 `elem` (robots env)
                then ([], [s3])
            else ([(s3, father)], [s3]) 
        queue1 = queue ++ (fst dir0) ++ (fst dir1) ++ (fst dir2) ++ (fst dir3)
        visited1 = visited ++ (snd dir0) ++ (snd dir1)  ++ (snd dir2) ++ (snd dir3)  
    in bfs_ env condition queue1 visited1

bfs_ :: Enviroment -> (Enviroment -> Square -> Bool) -> [(Square, Square)] -> [Square] -> (Square, Square)
bfs_ env condition queue visited =
    if length queue == 0
        then (Square {row = -1, column = -1}, Square {row = -1, column = -1})
    else 
        let (cur, father) = queue !! 0
            queue1 = tail queue
        in 
            if (condition env cur) 
                then (cur, father)
            else            
                let s0 = Square {row = row cur, column = (column cur) + 1}
                    s1 = Square {row = (row cur) + 1, column = column cur}
                    s2 = Square {row = row cur, column = (column cur) - 1}
                    s3 = Square {row = (row cur) - 1, column = column cur}
                    dir0 = 
                        if not (isValidSquare env s0) || s0 `elem` visited
                            then ([], [])
                        else if s0 `elem` (obstacles env) || s0 `elem` (robots env) || (s0 `elem` (corral env) && s0 `elem` (children env))   
                            then ([], [s0])
                        else ([(s0, cur)], [s0]) 
                    dir1 = 
                        if not (isValidSquare env s1) || s1 `elem` visited
                            then ([], [])
                        else if s1 `elem` (obstacles env) || s1 `elem` (robots env) || (s0 `elem` (corral env) && s0 `elem` (children env)) 
                            then ([], [s1])
                        else ([(s1, cur)], [s1]) 
                    dir2 = 
                        if not (isValidSquare env s2) || s2 `elem` visited
                            then ([], [])
                        else if s2 `elem` (obstacles env) || s2 `elem` (robots env) || (s0 `elem` (corral env) && s0 `elem` (children env)) 
                            then ([], [s2])
                        else ([(s2, cur)], [s2]) 
                    dir3 = 
                        if not (isValidSquare env s3) || s3 `elem` visited
                            then ([], [])
                        else if s3 `elem` (obstacles env) || s3 `elem` (robots env) || (s0 `elem` (corral env) && s0 `elem` (children env)) 
                            then ([], [s3])
                        else ([(s3, cur)], [s3]) 
                    queue2 = queue1 ++ (fst dir0) ++ (fst dir1) ++ (fst dir2) ++ (fst dir3)
                    visited1 = visited ++ (snd dir0) ++ (snd dir1)  ++ (snd dir2) ++ (snd dir3)  
                    (resC, resF) = bfs_ env condition queue2 visited1
                in 
                    if resF == cur
                        then
                            if father == Square {row = -1, column = -1}
                                then (resC, resF)
                            else (cur, father)
                    else (resC, resF)
                    

-- Execute a robot action
robotAction :: Enviroment -> Square -> Enviroment
robotAction env robot = 
    if isADirt env robot && not (isAChild env robot)
        then cleanDirt env robot
    else if isAChild env robot && not (isACorral env robot)
        then goToMostCloseCorral env robot
    else goToMostCloseChild env robot


-- Execute the action of each robot
robotsTurn :: Enviroment -> [Square]-> Enviroment
robotsTurn env [] = env
robotsTurn env (r:rs) = 
    let env1 = robotAction env r
    in robotsTurn env1 rs  