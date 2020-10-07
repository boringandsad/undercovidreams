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
pip3 install nltk
pip3 install spacy
python3 -m spacy download it
/Applications/Python\ 3.7/Install\ Certificates.command
pip3 install sklearn
```
