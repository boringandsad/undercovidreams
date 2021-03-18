#!/bin/env python

from random import randint
import spacy
import sys
import json
#nlp = spacy.load("it_core_news_lg")
import stanza
nlp = stanza.Pipeline(lang='it', processors='tokenize,mwt,pos,lemma')
spacynlp = spacy.load("it_core_news_lg")
from sklearn.decomposition import PCA

# def get_words(index, docs):
#     wds=[]
#     for w in docs[index]:
#         if w.pos_ in ['NOUN','VERB','ADJ']:
#             wds.append(w.lemma_)
#     return wds

corrections={}
corrections["dicendo"]="dire"
corrections["abbraccia"]="abbracciare"
corrections["abbracciati"]="abbracciato"
corrections["andando"]="andare"
corrections["andate"]="andare"
corrections["aperti"]="aperto"
corrections["aprendo"]="aprire"
corrections["avendo"]="avere"
corrections["avviamo"]="avviare"
corrections["avviando"]="avviare"
corrections["bevi"]="bere"
corrections["chiedendo"]="chiedere"
corrections["chiudi"]="chiudere"
corrections["connessa"]="connesso"
corrections["dicendo"]="dire"
corrections["facendo"]="fare"
corrections["finiamo"]="finire"
corrections["godendo"]="godere"
corrections["inizia"]="iniziare"
corrections["iniziamo"]="iniziare"
corrections["mettiamo"]="mettere"
corrections["offesa"]="offeso"
corrections["porta"]="portare"
corrections["portiamo"]="portare"
corrections["ridiamo"]="ridere"
corrections["spente"]="spento"
corrections["tieni"]="tenere"
corrections["vedendo"]="vedere"
corrections["vedi"]="vedere"
corrections["vestita"]="vestito"
excluded_lemmas=["avere", "essere", "potere", "dovere", "sognare", "sogno"]
def get_words(index, docs):
    wds=[]
    for sent in docs[index].sentences:
        for w in sent.words:
            if w.upos in ['VERB', 'ADJ', 'NOUN', 'PROPN', 'NUM']:
                lemma=w.lemma
                if not lemma and w.text in corrections.keys():
                    lemma=corrections[w.text]
                if lemma in excluded_lemmas:
                    continue                    
                if lemma and ((w.text, lemma) not in wds):
                    wds.append((w.text, lemma))
    return wds

def get_word_vectors(words):
    return [spacynlp(word).vector for word in words if word != None]

raw_dreams=[]
dreams=[]

#print('reading dreams file')
try:
    fp = open('sogni.txt', 'r')
    line = fp.readline()
    lastdream=""
    while line:
        if (line.strip()=="---"):
            if lastdream!="":
                raw_dreams.append(lastdream.lower())
                dreams.append(nlp(lastdream.lower()))
                lastdream=""
        else:
            lastdream+=line.strip()
        line = fp.readline()
    raw_dreams.append(lastdream.lower())
    dreams.append(nlp(lastdream.lower()))
except Exception as e:
    print(e)
    sys.exit(1)

data_dreams=[]

for i in range(0,len(dreams)):
    data_dreams.append({'text': raw_dreams[i], 'words': get_words(i, dreams)})

with open('dreams.json', 'w') as outfile:
    json.dump(data_dreams, outfile)

allwords=[]
for i in range(0,len(data_dreams)):
    for _,word in data_dreams[i]['words']:
        allwords.append(word)
allwords=list(set(allwords))
#for i in range(0,len(dreams)):
#    allwords+=get_words(i, dreams)[1]
#allwords=list(set(allwords))

print('reducing dimension to 2')
pca = PCA(n_components=2)
pca.fit(get_word_vectors(allwords))
words2d=pca.transform(get_word_vectors(allwords)).tolist()
data_words=[(w, coord) for w, coord in zip(allwords,words2d)]

with open('words.json', 'w') as outfile:
    json.dump(data_words, outfile)

