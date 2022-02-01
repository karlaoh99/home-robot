module Main where
import Types
import Utils
import Debug.Trace
import System.Random


main = do
    let env = init_enviroment 6 6 7 3
    let env1 = simulate_turn env
    print(env1)


temp :: Enviroment -> Enviroment
temp env = env


child_action :: Enviroment -> Agent -> Enviroment
child_action env agent = 
    traceShow (agent) (temp env)

children_turn :: Enviroment -> [Agent]-> Enviroment
children_turn env [] = env
children_turn env (c:cs) = 
    let env1 = child_action env c
    in children_turn env1 cs  


robot_action :: Enviroment -> Agent -> Enviroment
robot_action env agent = 
    traceShow (agent) (temp env)

robots_turn :: Enviroment -> [Agent]-> Enviroment
robots_turn env [] = env
robots_turn env (r:rs) = 
    let env1 = robot_action env r
    in robots_turn env1 rs  


natural_change :: Enviroment -> Enviroment
natural_change env =
    let env1 = robots_turn env (robots env)
    in let env2 = children_turn env1 (children env1) in env2


random_change :: Enviroment -> Enviroment
random_change env = env


init_enviroment :: Int -> Int -> Int -> Int -> Enviroment
init_enviroment n_rows n_columns final_time random_time = 
    let obstacles = [Agent {row = 4, column = 0}]
        dirt = [Agent {row = 2, column = 1}]
        corral = [Agent {row = 0, column = 4}, Agent {row = 0, column = 5}]
        children = [Agent {row = 0, column = 0}, Agent {row = 4, column = 3}]
        robots = [Agent {row = 1, column = 3}]        
    in Enviroment {
        n_rows = n_rows, 
        n_columns = n_columns, 
        current_time = 0,
        final_time = final_time,
        random_time = random_time,
        obstacles = obstacles,
        dirt = dirt,
        corral = corral,
        children = children,
        robots = robots }


sum_currente_time :: Enviroment -> Enviroment
sum_currente_time env =
    Enviroment {
        n_rows = (n_rows env), 
        n_columns = (n_columns env), 
        current_time = (current_time env) + 1,
        final_time = (final_time env),
        random_time = (random_time env),
        obstacles = (obstacles env),
        dirt = (dirt env),
        corral = (corral env),
        children = (children env),
        robots = (robots env) }


simulate_turn :: Enviroment -> Enviroment
simulate_turn env =
    if (current_time env) == (final_time env) 
        then env
    else
        let env1 = sum_currente_time env
            env2 = natural_change env1
        in  if ((current_time env1) `mod` (random_time env1)) == 0
                then let env3 = random_change env2 in simulate_turn (print_enviroment env3)
            else
                simulate_turn (print_enviroment env2)

