from pyforth import *

result = None

def rGet(cod,p) :
    global result
    result = ds.pop()

rDict['get'] = rGet

def invokeForth(expression):
    pcode = []
    tokenizeWords(expression +  ' get')

    for word in words:
        if word == None : return None
        cAct = cDict.get(word)  # Is there a compile time action ?
        rAct = rDict.get(word)  # Is there a runtime action ?

        if cAct : cAct(pcode)   # run at compile time
        elif rAct :
            if type(rAct) == type([]) :
                pcode.append(rRun)     # Compiled word.
                pcode.append(word)     # for now do dynamic lookup
            else : pcode.append(rAct)  # push builtin for runtime
        else :
            # Number to be pushed onto ds at runtime
            pcode.append(rPush)
            try : pcode.append(int(word))
            except :
                try: pcode.append(float(word))
                except :
                    pcode[-1] = rRun     # Change rPush to rRun
                    pcode.append(word)   # Assume word will be defined

        if pcode == None : print; return
    execute(pcode)
    return result
