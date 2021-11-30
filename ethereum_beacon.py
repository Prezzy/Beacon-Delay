#python3

import requests
import hashlib
import hmac
from math import ceil
import datetime

HASH_LEN = 32

# Returns hash and height of latest block mined
def get_latest_block():
    req = requests.get('https://api.blockchair.com/ethereum/stats')

    # Create dict using response read as JSON
    data = req.json()
    
    return data["data"]["best_block_hash"], data["data"]["best_block_height"]


# Returns 160 bytes of block header as hex
def get_block_header(block_hash):
    req = requests.get('https://api.blockchair.com/ethereum/raw/block/0x' + block_hash)
    data = req.json()
    for x in data["data"].keys():
       keyID = x
    data = data["data"][keyID]["decoded_raw_block"]

    hdr = data["size"]
    hdr += data["parentHash"]
    hdr += data["stateRoot"]
    hdr += data["timestamp"]
    hdr += data["difficulty"]
    hdr += data["nonce"]
    hdr = hdr.replace('0x', '')
    return hdr[:160]


# Returns SHA256 HMAC of data using key 
def hmac_sha256(key, data):
    return hmac.new(key, data, hashlib.sha256).digest()


# HMAC Key derivation Function (HKDF)
# Smaller output but higher entropy than that of key (acting as data).
def hkdf(length, input_key, salt=b'', info=b''):    
    if len(salt) == 0:
        salt = bytes([0]*HASH_LEN)
    prk = hmac_sha256(salt, input_key)
    t = b''
    output = b''
    for i in range(ceil(length / HASH_LEN)):
        t = hmac_sha256(prk, t + info + bytes([1+i]))
        output += t
    return output[:length]


def get_beacon_output():
    block_hash, block_height = get_latest_block()
    print(f"Block Hash: {block_hash}")
    dat = get_block_header(block_hash)
    binary_header = bin(int('1'+dat, 16))[3:]
    binary_block_hash = bin(int('1'+block_hash, 16))[3:]

    # Extractor using HMAC
    # Extractor uses both block hash and header
    extractor_in = int(binary_header, 2) | int(binary_block_hash, 2)
    extractor_in = bin(extractor_in)[2:].zfill(640)

    extractor_in_bytes = extractor_in.encode('utf-8')
    extractor_out_bytes = hkdf(4, extractor_in_bytes)

    # Convert bytes to big-endian and get integer prepending with 0's to fill 32bits
    extractor_out = bin(int.from_bytes(extractor_out_bytes, 'big'))[2:].zfill(32)
    print(f"extractorOutput aka beacon output ({len(extractor_out)} bits):\n{extractor_out}")
    print(f"{int(extractor_out,2)}")
    return(int(extractor_out,2))


get_beacon_output()
