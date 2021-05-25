# Plataforma de crowdfunding v1.0.0
users: public(HashMap[address, uint256])

# Endereço do dono do contrato
owner: public(address)
end: public(bool)
meta: public(uint256)
total: public(uint256)
timeStart: public(uint256)
timeEnd: public(uint256)

@external
def __init__(meta: uint256, duration: uint256):
    self.owner = msg.sender
    self.meta = meta
    self.end = False
    self.total = 0
    self.timeStart = block.timestamp
    self.timeEnd = self.timeStart + 60*duration # Considerando o tempo em minutos

@external
@payable
def donate():
    assert self.end == False, "Error: donations are finish"
    assert block.timestamp < self.timeEnd, "Error: dotations time is finish"
    
    self.users[msg.sender] += msg.value
    self.total += msg.value
    
@external
@payable
def finish():
    assert msg.sender == self.owner, "Error: you are not the owner"
    assert block.timestamp > self.timeEnd, "Error: wait for the end time"
    
    self.end = True
    if (self.balance >= self.meta):
        send(msg.sender, self.balance)
        self.total = 0
        
@external
def cancel():
    assert self.end == True, "Error: the crowdfunding is not finished"
    assert self.users[msg.sender] > 0, "Error: you don't have more donations"
    
    send(msg.sender, self.users[msg.sender])
    self.total -= self.users[msg.sender]
    self.users[msg.sender] = 0