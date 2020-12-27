#!/bin/env python

import spacy
import sys
import json
nlp = spacy.load("it_core_news_lg")
from sklearn.decomposition import PCA

def get_words(index, docs):
    wds=[]
    for w in docs[index]:
        if w.pos_ in ['NOUN','VERB','ADJ']:
            wds.append(w.lemma_)
    return wds

def get_word_vectors(words):
    return [nlp(word).vector for word in words]

raw_dreams=[]
dreams=[]

print('reading dreams file')
try:
    fp = open('sogni.txt', 'r')
    line = fp.readline()
    while line:
        raw_dreams.append(line)
        dreams.append(nlp(line))
        line = fp.readline()
except Exception as e:
    print(e)
    sys.exit(1)

pca = PCA(n_components=2)

allwords=[]
for i in range(0,len(dreams)):
    allwords+=get_words(i, dreams)
allwords=list(set(allwords))
pca.fit(get_word_vectors(allwords))

print('reducing dimension to 2')
dreams2d=[]
for i in range(0,len(dreams)):
    try:
        print("%d/%d"%(i, len(dreams)))
        words=get_words(i, dreams)
        coords2d=pca.transform(get_word_vectors(words)).tolist()
        dreams2d+=[[(w, coord) for w, coord in zip(words, coords2d)]]
    except:
        print('could not map dream:"%s"'%dreams[i])

data=[]
for i in range(0,len(dreams)):
    data.append({'text': raw_dreams[0], 'coords': dreams2d[i]})

with open('coordinates.txt', 'w') as outfile:
    json.dump(data, outfile)
