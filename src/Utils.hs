module Utils where 
import Types
import Debug.Trace

print_enviroment :: Enviroment -> Enviroment
print_enviroment env = traceShow ("Time " ++ show (current_time env)) (print_enviroment_ env 0 0 "|")

print_enviroment_ :: Enviroment -> Int -> Int -> [Char] -> Enviroment
print_enviroment_ env i j str =
    if i == (n_rows env)
        then trace (str_line (n_columns env) "") env
    else if j == (n_columns env)
        then trace (str_line (n_columns env) "") (trace (str) (print_enviroment_ env (i+1) 0 "|"))
    else let pos = str_position env i j
         in print_enviroment_ env i (j+1) (str ++ pos)

str_position :: Enviroment -> Int -> Int -> [Char]
str_position env i j = 
    let agent = Agent {row = i, column = j}
    in  if agent `elem` (obstacles env)
            then " O |"
        else if agent `elem` (dirt env)
            then " D |"
        else if agent `elem` (corral env)  
            then " C |"
        else if agent `elem` (children env)
            then " N |"
        else if agent `elem` (robots env)
            then " R |"
        else "   |"

str_line :: Int -> [Char] -> [Char]
str_line n_columns str =
    if n_columns == 0
        then str ++ "-"
    else str_line (n_columns-1) (str ++ "----")