module Input where


initEnviromentVariables :: (Int, Int, Int, Int, Int, [(Int, Int)], [(Int, Int)], [(Int, Int)], [(Int, Int)], [(Int, Int)])
initEnviromentVariables =
    let nRows = 6
        nColumns = 6
        finalTime = 20
        randomTime = 3
        obstacles = [(3, 1), (3, 2)]
        dirt = [(2, 1), (3, 4)]
        corral = [(0, 4), (0, 5)]
        children = [(0, 0), (5, 5)]
        robots = [(1, 3), (0, 1)]
        rndSeed = 40
    in (nRows, nColumns, finalTime, randomTime, rndSeed, obstacles, dirt, corral, children, robots) 