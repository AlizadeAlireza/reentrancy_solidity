re-entry:

    can happen when when a contract function makes an external call to an untrusted
    contract.

    the untrusted contract repeatedly calls the the original function before it's finished executing
    in order to drain the funds.


Example:

    - we'll have one contract under attack called bank
    - we'll have attacker contract called thief

    bank contract: 

        deposit func(): witch increases the amount the each address has

        withdraw fucn(): requires the address in question to have more than a balance
        of zero and sends the money and sets the balance

    thief contract: 

        attack fucn(): 

        fallback func(): this is used when money is sent without a specific function 
        being called.


Work steps:

    - when a thief calls attack() it deposits one eth to the bank to increase its balance
    to one.
    it then calls withdraw() immediately after.

    - the bank checks if the caller has a balance of more than zero
    witch is true!
    then it makes an external call to send the caller back their one-eth.

    - re-entrancy starts!!!    

        - while the bank is sending the money the fallback() of the thief
        check to see if the bank still has some cash,
        if it does it cause the withdraw() again.
        
        - the bank the checks the thieves balance and it's still greater than zero!!!
        so obviously the send out the one-eth.
        this happens again and again until the funds are drained.

The issue problem:

    - the bank's withdraw() dosen't hit the final line of code to 
    update the balance to zero while it's being called recursively.

    - it's being called recursively the thief contract just continually 
    receives one-eth until the bank is completely out of funds.

Recommended Soloutions:

    steps:

        - first make all of your checks.

        - make the changes update balances
        or change the state.

        - finally make calls to other contract.


    1 :

    so we can update the balance first and then send the money.

    if the thief tries to call again their balance is already set to zero
    and the bank doesn't get wrecked. 

    2: 

    use booleans to hypothetically lock function until they're finished.

        - we can set state variable called locked.

        - write a modifier turns it on and off.

            when a function using this modifier is called the boolean is switched to true 
            ie : locked
            only after all of the code in the function has been executed does
            the boolean switch to off of false.

            this means if the fallback function from the thief calls again
            recursively it's going to fail.

        - we can also use things like open zeppelin's pre-made re-entrancy gurds
        and download it and use for extra safety.
        



