Config file `info.cfg` is a list of line with `:` as field separator.
The first field indicated the filename, the second one the title.

The title lines are separated by the `\n` character and each line has
to be no longer that 14 characters.

Sample:
```
03-18-0:La mia vecchia\nCoinquilina
03-19-0:Vivevo a Lione
```

# note su passi successivi

Rappresentare un singolo sogno come una "stella", cioe' un centro con
i raggi. I punti dei raggi sono le coordinate delle parole presenti
nel sogno.  Non tutte le parole, ma quelle meno ricorrenti dell'intero
corpus dei sogni (es. rimuoviamo il 95% delle parole piu' ricorrenti).
Il centro della stella viene calcolato come baricentro delle parole del sogno.

# installation

assuming pip3 is installed, then:
```
pip install nltk spacy sklearn pandas matplotlib gensim xlrd
python3 -m spacy download it
```

# some useful links
https://medium.com/@Intellica.AI/comparison-of-different-word-embeddings-on-text-similarity-a-use-case-in-nlp-e83e08469c1c
https://textminingonline.com/training-word2vec-model-on-english-wikipedia-by-gensim
https://wikipedia2vec.github.io/wikipedia2vec/pretrained/


# testing pre-trained models

https://github.com/MartinoMensio/it_vectors_wiki_spacy
https://spacy.io/usage/vectors-similarity

# da 300 a 2 dimensioni

Principal component analysis

In python con sklearn
https://scikit-learn.org/stable/modules/generated/sklearn.decomposition.PCA.html


https://gist.github.com/conormm/ca0cdf78fa7a91fdacf500ff4dff0645

https://towardsdatascience.com/visualization-of-word-embedding-vectors-using-gensim-and-pca-8f592a5d3354
https://www.kaggle.com/jeffd23/visualizing-word-vectors-with-t-sne
https://projector.tensorflow.org/
