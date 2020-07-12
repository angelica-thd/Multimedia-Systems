import random

m = int(input('Enter first seq length. '))
n = int(input('Enter second seq length. '))

A = ['N' for i in range(m)]
B = ['N' for i in range(n)]

round = 0
while round <= max(m,n):
    if round%2==0:
        p =1
        print("Player1's turn")
    else:
        p =2
        print("Player2's turn")

    if len(A)<len(B):
        if len(A)==1:
            A.remove(A[-1])
        else:
            A = A[:len(A)-2]
            B = B[:len(B)-1]

    elif len(A)>len(B):
        if len(B)==1:
            A.remove(B[-1])
        else:
            B = B[:len(B)-2]
            A = A[:len(A)-1]

    else:
        if random.randint(1,2)==1:
            if len(A)==1:
                A.remove(A[-1])
            else:
                A = A[:len(A)-2]
                B = B[:len(B)-1]
        else:
            if len(B)==1:
                A.remove(B[-1])
            else:
                B = B[:len(B)-2]
                A = A[:len(A)-1]
    print("A: "+str(A))
    print("B: "+str(B))
    if A==[] or B ==[]:
        if p==1:
             print("Player1 won.")
        elif p ==2:
            print("Player2 won.")
        break
    round +=1
print("Rounds played: "+str(round))
