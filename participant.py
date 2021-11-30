#participant.py
from ethereum_beacon import get_beacon_output
from web3 import Web3, HTTPProvider
from prover import compute_checkpoints
import json
import time


##################
#GLOBAL VARIABLES#
##################

num_checkpoints = 2**3
invocations_per_round = 2**10
interval = invocations_per_round // num_checkpoints
current_round = 0
blockchain_address = 'http://127.0.0.1:9545'

###########
#FUNCTIONS#
###########

def handle_challenge(event):

    args = event["args"]

    round_num = args["round"]
    prev_idx = args["prevIdx"]
    checkpoints = args["checkpoints"]
    challenger = args["challenger"]

    interval = interval//num_checkpoints

    (prev_idx, start_out_pair) = check_beacon(checkpoints,num_checkpoints,interval)

    if(prev_idx) == True:
        print("beacon was correct, must accept result") #is this true for middle ch?
    else:
        new_checkpoints = compute_checkpoints(start_out_pair[0],num_checkpoints,interval)
        interval = interval // num_checkpoints
        contract.functions.postChallenge(prev_idx, new_checkpoints[1:], challenger).transact()


def handle_beacon_post(event):
    args = event["args"]
    start = args["start"]
    beacon = args["beacon"]
    checkpoints = args["checkpoints"]
    checkpoints = [start] + checkpoints
    result = check_beacon(checkpoints, num_checkpoints,interval)

    if(result[0] == True):
        print("Beacon is good")
        return (True,True)
    else:
        return result

    return True

def log_loop_challenge(event_filter, poll_interval):
    while True:
        for event in event_filter.get_new_entries():
            handle_challenge(event)
        time.sleep(poll_interval)

def log_loop_beacon(event_filter, poll_interval):
    flag = True
    while flag:
        for event in event_filter.get_new_entries():
            return handle_beacon_post(event)
        time.sleep(poll_interval)
                

#######################
#BLOCKCHAIN CONNECTION#
#######################
def connect_contract(): 
    web3 = Web3(HTTPProvider(blockchain_address))
    web3.eth.defaultAccount = web3.eth.accounts[1]
    compiled_contract_path = 'build/contracts/Referee.json'

    deployed_contract_address = '0x46255c43eD20EA23019fE913742a1298cb47223F'

    with open(compiled_contract_path) as file:
        contract_json = json.load(file)
        contract_abi = contract_json['abi']

    contract = web3.eth.contract(address=deployed_contract_address, abi=contract_abi)
    return (contract, web3)


def main():
    (contract,web3) = connect_contract()

    my_account = web3.eth.defaultAccount

    submitBeacon_filter = contract.events.SubBeacon().createFilter(fromBlock="latest")

    print("entered Loop")

    result = log_loop_beacon(submitBeacon_filter,2)

    if result[0] == True:
        print("Beacon is good")
        return True
    else:
        (prev_idx, start_out_pair) = result
        interval = interval // num_checkpoints
        new_checkpoints = compute_checkpoints(start_out_pair[0],num_checkpoints,interval)
        contract.functions.postChallenge(prev_idx, new_checkpoints[1:], my_account).transact()




    #contract.function.postChallenge()

    #challenge_filter = contract.events.postChallenge().createFilter(fromBlocks="latest"))

    #log_loop_challenge(challenge_filter,2)

main()
