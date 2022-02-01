module Types where 

data Agent = Agent {
    row :: Int,
    column :: Int
} deriving (Show, Eq) 

data Enviroment = Enviroment {
    n_rows :: Int,
    n_columns :: Int,
    current_time :: Int,
    final_time :: Int,
    random_time :: Int,
    obstacles :: [Agent],
    dirt :: [Agent],
    corral :: [Agent],
    children :: [Agent],
    robots :: [Agent],
    rnd_generator :: StdGen
} deriving (Show)  