##PROVER.PY##
from web3 import Web3


def hasher(value):
    return Web3.solidityKeccak(['bytes32'],[value]);

def check_beacon(checkpoints,num_checkpoints,interval):
    checkpoint = checkpoint[0]
    for i in range(1, num_checkpoints):
        for j in range(0,interval):
            checkpoint = hasher(checkpoint)
        if(checkpoint != checkpoints[i]):
            return (i,[checkpoints[i-1],checkpoints[i]])
    return (True,True)


def compute_checkpoints(first_checkpoint, num_checkpoints, interval):
    checkpoint = first_checkpoint
    checkpoints = [checkpoint]
    for i in range(1,num_checkpoints):
        for j in range(0,interval):
            checkpoint = hasher(checkpoint)

        checkpoints.append(checkpoint)

    return checkpoints
