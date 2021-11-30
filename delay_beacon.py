##DELAY_BEACON.PY##
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


def log_loop(event_filter, poll_interval):
    while True:
        for event in event_filter.get_new_entries():
            handle_challenge(event)
        time.sleep(poll_interval)


#######################
#BLOCKCHAIN CONNECTION#
#######################
def connect_contract(): 
    web3 = Web3(HTTPProvider(blockchain_address))
    web3.eth.defaultAccount = web3.eth.accounts[0]
    compiled_contract_path = 'build/contracts/Referee.json'

    deployed_contract_address = '0x46255c43eD20EA23019fE913742a1298cb47223F'

    with open(compiled_contract_path) as file:
        contract_json = json.load(file)
        contract_abi = contract_json['abi']

    contract = web3.eth.contract(address=deployed_contract_address, abi=contract_abi)
    return contract


def main():
    contract = connect_contract()
    start = 1963068368         #get_beacon_output()

                            #get result int, change to bytes
                            #input to to keccack as bytes32.

    start = start.to_bytes(32,byteorder='big')
    print(start)
    print(num_checkpoints)
    print(interval)
    checkpoints = compute_checkpoints(start, num_checkpoints, interval)

    beacon = checkpoints[-1]
    print(beacon)

    beacon_filter = contract.events.SubBeacon().createFilter(fromBlock="latest")

    tx_hash = contract.functions.submitBeacon(start,beacon, checkpoints[1:]).transact()

    log = beacon_filter.get_new_entries()
    print(log[0]["args"])
    print(log[0]["args"]["beacon"])

    #challenge_filter = contract.events.postChallenge().createFilter(fromBlock="latest"))

    #log_loop(challenge_filter,2)

main()
