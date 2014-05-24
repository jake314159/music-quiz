import sys


# a limit on the max number of words to stop stupid answers breaking things
MAX_WORDS = 300

# How many changes are needed to change one string to another
# Implementation based on http://en.wikipedia.org/wiki/Levenshtein_distance#Iterative_with_full_matrix
def LevenshteinDistance(s1, s2):
    matrix = [[0 for x in xrange(len(s2)+1)] for x in xrange(len(s1)+1)] 
 
    # source prefixes can be transformed into empty string by
    # dropping all characters
    for i in range(1,len(s1)+1):
        matrix[i][0] = i

    # target prefixes can be reached from empty source prefix
    # by inserting every characters
    for i in range(1,len(s2)+1):
        matrix[0][i] = i

    for j in range(1, len(s2)+1):
        for i in range(1, len(s1)+1):
            if s1[i-1] == s2[j-1]:
                matrix[i][j] = matrix[i-1][j-1] #no operation required
            else:
                matrix[i][j] = min( 
                                    matrix[i-1][j] +1, # deletion
                                    matrix[i][j-1] +1, # insert
                                    matrix[i-1][j-1]+1 # substitute
                                  )


    return matrix[len(s1)][len(s2)]


# Checks how many words are in both strings
# ignoring their order
# returns a pair where (correct, total words)
def WordsCorrect(s1, s2):
    split1 = s1.split(" ", MAX_WORDS) ##string to match
    split2 = s2.split(" ", MAX_WORDS) ##user input
    i = 0
    
    correctWords = 0
    while i < len(split1):
        match = 0
        j = 0
        while j < len(split2):
            if split1[i] == split2[j]:
                match = 1
            j += 1
        correctWords += match
        i += 1

    return (correctWords, len(split1))

def WordsCorrectPreFtString(s1, s2):
    split1 = s1.split(" ", MAX_WORDS) ##string to match
    split2 = s2.split(" ", MAX_WORDS) ##user input
    i = 0

    toFt1 = 0
    for s in split1:
        if s == "featuring" or s == "ft" or s == "ft.":
            break
        else:
            toFt1 += 1
    toFt2 = 0
    for s in split2:
        if s == "featuring" or s == "ft" or s == "ft.":
            break
        else:
            toFt2 += 1
    
    correctWords = 0
    while i < toFt1:
        match = 0
        j = 0
        while j < toFt2:
            if split1[i] == split2[j]:
                match = 1
            j += 1
        correctWords += match
        i += 1

    return (correctWords, toFt1)

if len(sys.argv) < 3:
    print "Not enough paramiters!"
    exit(1)
    

s1 = sys.argv[1].lower()
s2 = sys.argv[2].lower()
Ldis = LevenshteinDistance(s1, s2)
corr, corrC = WordsCorrect(s1, s2)
corrFt, corrFtC = WordsCorrectPreFtString(s1, s2)

#print "Livenshtein distance:  " + str(Ldis)
#print "Corect words:          " + str(corr) + " out of " + str(corrC)
#print "Corect words to ft:    " + str(corrFt) + " out of " + str(corrFtC)

score = 0
if Ldis == 0:
    score = 100 ## Full points
elif Ldis <= 3:
    ## Close but a minor spelling mistake
    score = 100- (10*Ldis)
elif Ldis <= 10:
    ## Major spelling mistake but not random
    score = (40*(float(corr)/float(corrC))) + (40*(float(corrFt)/float(corrFtC)))
else:
    ## Pretty much a guess
    score = (10*(float(corr)/float(corrC))) + (10*(float(corrFt)/float(corrFtC)))

print str(int(score))

