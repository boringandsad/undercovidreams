#!/bin/env python

from random import randint
import nltk
ita_stemmer = nltk.stem.snowball.ItalianStemmer()
import spacy
import sys
import json
#nlp = spacy.load("it_core_news_lg")
import stanza
nlp = stanza.Pipeline(lang='it', processors='tokenize,mwt,pos,lemma')
spacynlp = spacy.load("it_core_news_lg")
from sklearn.decomposition import PCA

corrections={}
corrections["abbraccia"]="abbracciare"
corrections["abbracciati"]="abbracciato"
corrections["allontaniamo"]="allontanare"
corrections["andando"]="andare"
corrections["andate"]="andare"
corrections["aperti"]="aperto"
corrections["aprendo"]="aprire"
corrections["attoniti"]="attonito"
corrections["avendo"]="avere"
corrections["avventate"]="avventato"
corrections["avviamo"]="avviare"
corrections["avviando"]="avviare"
corrections["bevi"]="bere"
corrections["busserò"]="bussare"
corrections["capiamo"]="capire"
corrections["cenire"]="cenare"
corrections["capii"]="capire"
corrections["chiedendo"]="chiedere"
corrections["chiudi"]="chiudere"
corrections["cimici"]="cimice"
corrections["connessa"]="connesso"
corrections["dicendo"]="dire"
corrections["dicendo"]="dire"
corrections["distratto"]="distratto"
corrections["facendo"]="fare"
corrections["finiamo"]="finire"
corrections["godendo"]="godere"
corrections["inizia"]="iniziare"
corrections["iniziamo"]="iniziare"
corrections["intravedo"]="intravedere"
corrections["lavarmi"]="lavare"
corrections["innervosivo"]="innervosire"
corrections["disoriento"]="disorientare"
corrections["lividi"]="livido"
corrections["prelievi"]="prelievo"
corrections["dimentico"]="dimenticare"
corrections["prendermi"]="prendere"
corrections["mcdonald'"]="mcdonald"
corrections["mettiamo"]="mettere"
corrections["orchi"]="orco"
corrections["offesa"]="offeso"
corrections["paracadute"]="paracadute"
corrections["passire"]="passare"
corrections["porta"]="portare"
corrections["portiamo"]="portare"
corrections["proviamo"]="provire"
corrections["puliamo"]="pulire"
corrections["rassereno"]="rasserenare"
corrections["ridiamo"]="ridere"
corrections["riaprano"]="riaprire"
corrections["risveglio"]="risvegliare"
corrections["vivevamo"]="vivere"
corrections["sore'"]="sorella"
corrections["spa"]="spa"
corrections["spente"]="spento"
corrections["supereroi"]="supereroe"
corrections["succhiassi"]="succhiare"
corrections["svegliere"]="svegliare"
corrections["tieni"]="tenere"
corrections["vedendo"]="vedere"
corrections["vedi"]="vedere"
corrections["vestita"]="vestito"
corrections["volassi"]="volare"
corrections["granule"]="granulo"
excluded_lemmas=["avere", "essere", "potere", "dovere", "sognare", "sogno", "certo", "altro","po'"]
def fix_adjective(text):
    return (text[:-1] + ('ə' if text[-1]=='o' else text[-1]))

def get_words(doc):
    wds=[]
    for sent in doc.sentences:
        for w in sent.words:
        # when misc is not present, there's a compound
#            if w.upos in ['VERB', 'ADJ', 'NOUN', 'PROPN', 'NUM'] and w.misc:
            if w.upos in ['VERB', 'NOUN', 'ADJ'] and w.misc:
                lemma=w.lemma
                # sometimes lemma can be null. in that case...
                if not lemma:
                    lemma=w.text # ...we put the text into the lemma. In case it will be fixed via the corrections
                if lemma in corrections.keys():
                    lemma=corrections[lemma]
                if w.text in corrections.keys():
                    lemma=corrections[w.text]
                if lemma in excluded_lemmas:
                    continue
#                if w.upos=='ADJ':
#                    lemma=fix_adjective(lemma)
                wds.append((w.text, lemma, w.upos))
    return wds

def get_word_vectors(words):
    return [spacynlp(word).vector for word in words if word != None]

fp= open('dreamsinfo.json', 'r')
dreamsinfo=json.load(fp)
for d in dreamsinfo:
    d["words"]=get_words(nlp(d["text"]))
#    print(d)

allwords=[]
for dream in dreamsinfo:
    for _,word,upos in dream['words']:
        allwords.append(word)
print("!")
pca = PCA(n_components=3)
pca.fit(get_word_vectors(allwords))
words2d=pca.transform(get_word_vectors(allwords)).tolist()
data_words=[(w, coord) for w, coord in zip(allwords,words2d)]

data_words_map={}
for w,coord in data_words:
    data_words_map[w]=coord

with open('words.json', 'w') as outfile:
    json.dump(data_words, outfile, sort_keys=True, indent=3, ensure_ascii=False)

for dream in dreamsinfo:
    c_x=0
    c_y=0
    c_z=0
    for (_,w,_) in dream['words']:
        c_x+=data_words_map[w][0]
        c_y+=data_words_map[w][1]
        c_z+=data_words_map[w][2]
    c_x=c_x/len(dream['words']) 
    c_y=c_y/len(dream['words'])
    c_z=c_z/len(dream['words'])     
    dream['coords']=(c_x, c_y, c_z)

with open('dreams.json', 'w') as outfile:
    json.dump(dreamsinfo, outfile, sort_keys=True, indent=3, ensure_ascii=False)
