##CHALLENGER.PY##

checkpoints = []

def increment(x):
    return x + 1





def check_beacon(checkpoints):
    checkpoint = checkpoints[0]
    for i in range(0, num_checkpoints):
        if checkpoint != checkpoints[i]:
            return (i-1,checkpoints[i-1:i+1])
        for j in range(0,interval):
            checkpoint = increment(checkpoint)
    return (True,True)
            
