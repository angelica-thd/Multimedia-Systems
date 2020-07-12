from Bio import SeqIO
import random

class ScoreParam:

    def __init__(self, gap, mismatch):
        self.gap = gap
        self.mismatch = mismatch
    def match(self, chr):
        if chr == 'A':
            return 3
        elif chr == 'C' or chr == 'T':
            return 2
        else:
            return 1

def global_align(x, y, score=ScoreParam(-4, -3)):
    k = random.randint(1,10)
    print("Parameter k is "+str(k))
    k +=1
    A = []
    count = 0
    for i in range(len(y) + 1):
        A.append([0] * (len(x) +1))
    for i in range(len(y)+1):
        A[i][0] = score.gap * i
    for i in range(len(x)+1):
        A[0][i] = score.gap * i
    for i in range(1, len(y) + 1):
        for j in range(1, len(x) + 1):
            A[i][j] = max(
            A[i][j-1] + score.gap,
            A[i-1][j] + score.gap,
            A[i-1][j-1] + (score.match(y[i-1]) if y[i-1] == x[j-1] else score.mismatch))


    align_X = ""
    align_Y = ""
    i = len(x)
    j = len(y)

    while i > 0 or j > 0:
        current_score = A[j][i]
        if i > 0 and j > 0 and x[i - 1] == y[j - 1]:
            align_X = x[i - 1] + align_X
            align_Y = y[j - 1] + align_Y
            i = i - 1
            j = j - 1
        elif i > 0 and j>1 and (current_score == A[j][i - 1] + score.mismatch or current_score == A[j][i - 1] + score.gap):
            count+=1
            if count == k:
                count = 0
                align_X = x[i - 1] + align_X
                align_Y = y[j - 1] + align_Y
                i = i - 1
                j = j - 1
            else:
                align_X = x[i - 1] + align_X
                align_Y = "_" + align_Y
                i = i - 1
        else:
            count+=1
            if count == k:
                count = 0
                align_X = x[i - 1] + align_X
                align_Y = y[j - 1] + align_Y
                j = j - 1
                i = i - 1
            else:
                align_X = "_" + align_X
                align_Y = y[j - 1] + align_Y
                j = j - 1

    return (align_X, align_Y)


x = 'GAATTCAATACTCCACTTTCCATTCTGTTCAAAGGTCACGTATAGTCCTGGGAATACTCAGGGTTCTCACTTCATGGCTATGCAGGTATTTGTTCCCACA'
y = 'GAATTATACTCCACTTTCCAATGTGTAAAGGTCACTATATCCTGGCATAC'

seq1 = ''
seq2 = ''
with open("C:/Users/ageli/Documents/MATLAB/multimedia/bioinformatics/lysozyme_c.fasta","r" ) as lysozyme_c:
    for record in SeqIO.parse(lysozyme_c,"fasta"):
        seq1 += record
with open("C:/Users/ageli/Documents/MATLAB/multimedia/bioinformatics/a_lactalbumin.fasta","r") as a_lactalbumin:
    for record in SeqIO.parse(a_lactalbumin,"fasta"):
        seq2 += record


a,b = global_align(seq1, seq2, score=ScoreParam(-4, -3))
print(a,end="\n")
print(b)
