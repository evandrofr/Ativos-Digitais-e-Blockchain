# Plataforma de crowdfunding v0.0.1
users: public(HashMap[address, uint256])

# Endereço do dono do contrato
owner: public(address)
end: public(bool)
meta: uint256
total: public(uint256)
timeStart: public(uint256)
timeEnd: public(uint256)

@external
def __init__(meta: uint256, duration: uint256):
    self.owner = msg.sender
    self.meta = meta
    self.total = 0
    self.end = False
    self.timeStart = block.timestamp
    self.timeEnd = self.timeStart + 60*duration

@external
@payable
def donate(donation: uint256):
    assert self.end == False
    assert block.timestamp < self.timeEnd
    self.users[msg.sender] += donation
    self.total += donation
    
@external
@payable
def finish():
    assert msg.sender == self.owner
    assert block.timestamp > self.timeEnd
    self.end = True
    if (self.total >= self.meta):
        send(msg.sender, self.balance)