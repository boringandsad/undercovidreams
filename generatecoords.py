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

def get_words(index, docs):
    wds=[]
    for sent in docs[index].sentences:
        for w in sent.words:
            if w.upos in ['VERB', 'ADJ', 'NOUN']:
                wds.append(w.lemma)
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
for i in range(0,len(dreams)):
    allwords+=get_words(i, dreams)
allwords=list(set(allwords))

print('reducing dimension to 2')
pca = PCA(n_components=2)
pca.fit(get_word_vectors(allwords))
words2d=pca.transform(get_word_vectors(allwords)).tolist()
data_words=[(w, coord) for w, coord in zip(allwords,words2d)]

with open('words.json', 'w') as outfile:
    json.dump(data_words, outfile)

