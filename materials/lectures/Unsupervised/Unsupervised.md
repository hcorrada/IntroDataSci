Unsupervised Methods
========================================================
author: Hector Corrada Bravo
date: CMSC798: Intro. Data Sci



Introduction
=============

- So far we have seen "Supervised Methods" where interest is in analyzing a _response_ based
on various _predictors_.

- In many cases, especially for Exploratory Data Analysis, we want methods to extract patterns on
variables without analyzing a specific _response_.

- Methods for the latter case are called "Unsupervised Methods". Examples are _Principal Component Analysis_ and _Clustering_

Warning
=========

- Interpretation of these methods is much more _subjective_ than in Supervised Learning
- For example: 
  - we want to know if a given _predictor_ is related to _response_: we can do inference using hypothesis testing
  - we want to know which predictors are useful for prediction: use cross-validation to do model selection
  - we want to see how well we predict? Use cross-validation to report on test error
- In unsupervised methods, this is not clean at all
- Nonetheless, they can be very useful methods to understand data at hand

Motivating Example
=============================

_Genotypes across human populations_

- Recent technological advances have allowed identification of locations in human genome (DNA) that vary a lot across human populations (Single Nucleotide Polymorphisms, or SNPs).

- Also allows identifying changes in DNA that are associated with specific traits:
  - e.g., susceptibility to disease, or protection from disease
  
Motivating Example
======================

We will look at a dataset of 4,929 SNPs for 1,093 individuals from populations across the globe. 


```r
load("geno_data.rda")
print(dim(filtered_geno_data))
```

```
[1] 1093 4929
```

```r
table(filtered_geno_data$super_population)
```

```

AFR AMR EAS EUR OPT 
246 181 286 379   1 
```

_AFR: Africa, AMR: America, EAS: East Asia, EUR: Europe, OPT: A mystery_

Motivating Example
===================


|sample_name |population |super_population | rs307377| rs7366653| rs41307846|
|:-----------|:----------|:----------------|--------:|---------:|----------:|
|perfect     |OPT        |OPT              |        0|         0|          0|
|HG00096     |GBR        |EUR              |        2|         0|          1|
|HG00097     |GBR        |EUR              |        2|         0|          0|
|HG00099     |GBR        |EUR              |        2|         0|          0|
|HG00100     |GBR        |EUR              |        2|         0|          0|
|HG00101     |GBR        |EUR              |        2|         0|          0|
|HG00102     |GBR        |EUR              |        2|         0|          0|
|HG00103     |GBR        |EUR              |        2|         0|          0|
|HG00104     |GBR        |EUR              |        2|         0|          1|
|HG00106     |GBR        |EUR              |        2|         0|          0|
|HG00108     |GBR        |EUR              |        2|         0|          0|
|HG00109     |GBR        |EUR              |        2|         0|          0|
|HG00110     |GBR        |EUR              |        2|         0|          0|
|HG00111     |GBR        |EUR              |        2|         0|          0|
|HG00112     |GBR        |EUR              |        2|         0|          0|
|HG00113     |GBR        |EUR              |        2|         0|          0|
|HG00114     |GBR        |EUR              |        2|         1|          0|
|HG00116     |GBR        |EUR              |        2|         0|          0|
|HG00117     |GBR        |EUR              |        2|         0|          0|
|HG00118     |GBR        |EUR              |        2|         0|          0|
|HG00119     |GBR        |EUR              |        2|         0|          0|
|HG00120     |GBR        |EUR              |        2|         0|          0|
|HG00121     |GBR        |EUR              |        2|         0|          0|
|HG00122     |GBR        |EUR              |        2|         0|          0|
|HG00123     |GBR        |EUR              |        1|         0|          0|
|HG00124     |GBR        |EUR              |        2|         0|          0|
|HG00125     |GBR        |EUR              |        2|         0|          0|
|HG00126     |GBR        |EUR              |        2|         0|          0|
|HG00127     |GBR        |EUR              |        2|         0|          0|
|HG00128     |GBR        |EUR              |        2|         0|          0|
|HG00129     |GBR        |EUR              |        2|         0|          0|
|HG00130     |GBR        |EUR              |        2|         0|          0|
|HG00131     |GBR        |EUR              |        2|         0|          0|
|HG00133     |GBR        |EUR              |        2|         0|          0|
|HG00134     |GBR        |EUR              |        2|         0|          0|
|HG00135     |GBR        |EUR              |        2|         0|          0|
|HG00136     |GBR        |EUR              |        2|         0|          0|
|HG00137     |GBR        |EUR              |        2|         0|          0|
|HG00138     |GBR        |EUR              |        2|         0|          0|
|HG00139     |GBR        |EUR              |        2|         0|          0|
|HG00140     |GBR        |EUR              |        2|         0|          0|
|HG00141     |GBR        |EUR              |        1|         0|          1|
|HG00142     |GBR        |EUR              |        2|         0|          0|
|HG00143     |GBR        |EUR              |        2|         0|          0|
|HG00146     |GBR        |EUR              |        1|         0|          0|
|HG00148     |GBR        |EUR              |        2|         0|          0|
|HG00149     |GBR        |EUR              |        2|         0|          0|
|HG00150     |GBR        |EUR              |        2|         0|          0|
|HG00151     |GBR        |EUR              |        2|         0|          0|
|HG00152     |GBR        |EUR              |        2|         0|          0|
|HG00154     |GBR        |EUR              |        2|         0|          0|
|HG00155     |GBR        |EUR              |        2|         0|          0|
|HG00156     |GBR        |EUR              |        2|         0|          0|
|HG00158     |GBR        |EUR              |        2|         0|          0|
|HG00159     |GBR        |EUR              |        2|         0|          0|
|HG00160     |GBR        |EUR              |        2|         0|          0|
|HG00171     |FIN        |EUR              |        2|         0|          0|
|HG00173     |FIN        |EUR              |        2|         0|          0|
|HG00174     |FIN        |EUR              |        2|         0|          0|
|HG00176     |FIN        |EUR              |        2|         0|          0|
|HG00177     |FIN        |EUR              |        1|         0|          0|
|HG00178     |FIN        |EUR              |        2|         0|          0|
|HG00179     |FIN        |EUR              |        2|         0|          1|
|HG00180     |FIN        |EUR              |        2|         0|          0|
|HG00182     |FIN        |EUR              |        2|         0|          0|
|HG00183     |FIN        |EUR              |        2|         0|          0|
|HG00185     |FIN        |EUR              |        2|         0|          0|
|HG00186     |FIN        |EUR              |        2|         0|          0|
|HG00187     |FIN        |EUR              |        1|         0|          0|
|HG00188     |FIN        |EUR              |        2|         0|          1|
|HG00189     |FIN        |EUR              |        2|         0|          0|
|HG00190     |FIN        |EUR              |        2|         0|          0|
|HG00231     |GBR        |EUR              |        2|         0|          0|
|HG00232     |GBR        |EUR              |        2|         0|          0|
|HG00233     |GBR        |EUR              |        2|         0|          0|
|HG00234     |GBR        |EUR              |        2|         0|          0|
|HG00235     |GBR        |EUR              |        2|         0|          0|
|HG00236     |GBR        |EUR              |        2|         1|          0|
|HG00237     |GBR        |EUR              |        2|         0|          0|
|HG00238     |GBR        |EUR              |        2|         0|          0|
|HG00239     |GBR        |EUR              |        2|         0|          0|
|HG00240     |GBR        |EUR              |        2|         0|          0|
|HG00242     |GBR        |EUR              |        2|         0|          0|
|HG00243     |GBR        |EUR              |        2|         0|          0|
|HG00244     |GBR        |EUR              |        2|         0|          0|
|HG00245     |GBR        |EUR              |        2|         0|          0|
|HG00246     |GBR        |EUR              |        2|         0|          0|
|HG00247     |GBR        |EUR              |        2|         0|          0|
|HG00249     |GBR        |EUR              |        1|         0|          0|
|HG00250     |GBR        |EUR              |        1|         0|          0|
|HG00251     |GBR        |EUR              |        2|         0|          0|
|HG00252     |GBR        |EUR              |        2|         0|          0|
|HG00253     |GBR        |EUR              |        2|         0|          0|
|HG00254     |GBR        |EUR              |        2|         0|          0|
|HG00255     |GBR        |EUR              |        2|         0|          0|
|HG00256     |GBR        |EUR              |        2|         0|          0|
|HG00257     |GBR        |EUR              |        2|         0|          0|
|HG00258     |GBR        |EUR              |        2|         0|          0|
|HG00259     |GBR        |EUR              |        2|         0|          0|
|HG00260     |GBR        |EUR              |        2|         0|          0|
|HG00261     |GBR        |EUR              |        1|         0|          0|
|HG00262     |GBR        |EUR              |        2|         0|          0|
|HG00263     |GBR        |EUR              |        2|         0|          0|
|HG00264     |GBR        |EUR              |        2|         0|          0|
|HG00265     |GBR        |EUR              |        1|         0|          0|
|HG00266     |FIN        |EUR              |        2|         0|          0|
|HG00267     |FIN        |EUR              |        2|         0|          0|
|HG00268     |FIN        |EUR              |        2|         0|          1|
|HG00269     |FIN        |EUR              |        2|         0|          0|
|HG00270     |FIN        |EUR              |        2|         0|          1|
|HG00271     |FIN        |EUR              |        2|         0|          0|
|HG00272     |FIN        |EUR              |        2|         0|          0|
|HG00273     |FIN        |EUR              |        2|         0|          0|
|HG00274     |FIN        |EUR              |        2|         0|          0|
|HG00275     |FIN        |EUR              |        2|         0|          0|
|HG00276     |FIN        |EUR              |        2|         0|          0|
|HG00277     |FIN        |EUR              |        2|         0|          0|
|HG00278     |FIN        |EUR              |        2|         0|          0|
|HG00280     |FIN        |EUR              |        2|         0|          0|
|HG00281     |FIN        |EUR              |        2|         0|          0|
|HG00282     |FIN        |EUR              |        2|         0|          0|
|HG00284     |FIN        |EUR              |        2|         0|          0|
|HG00285     |FIN        |EUR              |        1|         0|          0|
|HG00306     |FIN        |EUR              |        2|         0|          0|
|HG00309     |FIN        |EUR              |        2|         0|          0|
|HG00310     |FIN        |EUR              |        2|         0|          0|
|HG00311     |FIN        |EUR              |        2|         0|          0|
|HG00312     |FIN        |EUR              |        2|         0|          0|
|HG00313     |FIN        |EUR              |        2|         0|          0|
|HG00315     |FIN        |EUR              |        2|         0|          0|
|HG00318     |FIN        |EUR              |        1|         0|          0|
|HG00319     |FIN        |EUR              |        2|         0|          0|
|HG00320     |FIN        |EUR              |        2|         0|          0|
|HG00321     |FIN        |EUR              |        2|         0|          0|
|HG00323     |FIN        |EUR              |        2|         0|          0|
|HG00324     |FIN        |EUR              |        2|         0|          0|
|HG00325     |FIN        |EUR              |        2|         0|          0|
|HG00326     |FIN        |EUR              |        2|         0|          0|
|HG00327     |FIN        |EUR              |        2|         0|          0|
|HG00328     |FIN        |EUR              |        2|         0|          0|
|HG00329     |FIN        |EUR              |        2|         0|          0|
|HG00330     |FIN        |EUR              |        2|         0|          1|
|HG00331     |FIN        |EUR              |        2|         0|          1|
|HG00332     |FIN        |EUR              |        2|         0|          0|
|HG00334     |FIN        |EUR              |        1|         0|          0|
|HG00335     |FIN        |EUR              |        2|         0|          0|
|HG00336     |FIN        |EUR              |        2|         0|          0|
|HG00337     |FIN        |EUR              |        1|         0|          0|
|HG00338     |FIN        |EUR              |        2|         0|          0|
|HG00339     |FIN        |EUR              |        1|         0|          0|
|HG00341     |FIN        |EUR              |        2|         0|          0|
|HG00342     |FIN        |EUR              |        2|         0|          0|
|HG00343     |FIN        |EUR              |        2|         0|          1|
|HG00344     |FIN        |EUR              |        2|         0|          0|
|HG00345     |FIN        |EUR              |        2|         0|          0|
|HG00346     |FIN        |EUR              |        2|         0|          0|
|HG00349     |FIN        |EUR              |        2|         0|          0|
|HG00350     |FIN        |EUR              |        2|         0|          0|
|HG00351     |FIN        |EUR              |        2|         0|          0|
|HG00353     |FIN        |EUR              |        2|         0|          0|
|HG00355     |FIN        |EUR              |        1|         0|          0|
|HG00356     |FIN        |EUR              |        2|         0|          0|
|HG00357     |FIN        |EUR              |        2|         0|          0|
|HG00358     |FIN        |EUR              |        2|         0|          0|
|HG00359     |FIN        |EUR              |        2|         0|          0|
|HG00360     |FIN        |EUR              |        2|         0|          0|
|HG00361     |FIN        |EUR              |        2|         0|          1|
|HG00362     |FIN        |EUR              |        1|         0|          0|
|HG00364     |FIN        |EUR              |        2|         0|          0|
|HG00366     |FIN        |EUR              |        2|         0|          0|
|HG00367     |FIN        |EUR              |        2|         0|          1|
|HG00369     |FIN        |EUR              |        2|         0|          0|
|HG00372     |FIN        |EUR              |        2|         0|          0|
|HG00373     |FIN        |EUR              |        2|         0|          0|
|HG00375     |FIN        |EUR              |        2|         0|          0|
|HG00376     |FIN        |EUR              |        2|         0|          0|
|HG00377     |FIN        |EUR              |        2|         0|          0|
|HG00378     |FIN        |EUR              |        2|         0|          0|
|HG00381     |FIN        |EUR              |        2|         0|          0|
|HG00382     |FIN        |EUR              |        2|         0|          0|
|HG00383     |FIN        |EUR              |        2|         0|          0|
|HG00384     |FIN        |EUR              |        2|         1|          0|
|HG00403     |CHS        |EAS              |        2|         0|          0|
|HG00404     |CHS        |EAS              |        1|         0|          0|
|HG00406     |CHS        |EAS              |        2|         0|          0|
|HG00407     |CHS        |EAS              |        2|         0|          0|
|HG00418     |CHS        |EAS              |        2|         0|          0|
|HG00419     |CHS        |EAS              |        2|         0|          0|
|HG00421     |CHS        |EAS              |        2|         0|          0|
|HG00422     |CHS        |EAS              |        2|         0|          0|
|HG00427     |CHS        |EAS              |        2|         0|          0|
|HG00428     |CHS        |EAS              |        2|         0|          0|
|HG00436     |CHS        |EAS              |        2|         0|          0|
|HG00437     |CHS        |EAS              |        2|         0|          0|
|HG00442     |CHS        |EAS              |        2|         0|          0|
|HG00443     |CHS        |EAS              |        2|         0|          0|
|HG00445     |CHS        |EAS              |        2|         0|          0|
|HG00446     |CHS        |EAS              |        2|         0|          0|
|HG00448     |CHS        |EAS              |        2|         0|          0|
|HG00449     |CHS        |EAS              |        2|         0|          0|
|HG00451     |CHS        |EAS              |        2|         0|          0|
|HG00452     |CHS        |EAS              |        2|         0|          0|
|HG00457     |CHS        |EAS              |        1|         0|          0|
|HG00458     |CHS        |EAS              |        2|         0|          0|
|HG00463     |CHS        |EAS              |        2|         0|          0|
|HG00464     |CHS        |EAS              |        1|         0|          0|
|HG00472     |CHS        |EAS              |        1|         0|          0|
|HG00473     |CHS        |EAS              |        2|         0|          0|
|HG00475     |CHS        |EAS              |        2|         0|          0|
|HG00476     |CHS        |EAS              |        2|         0|          0|
|HG00478     |CHS        |EAS              |        1|         0|          0|
|HG00479     |CHS        |EAS              |        2|         0|          0|
|HG00500     |CHS        |EAS              |        2|         0|          0|
|HG00501     |CHS        |EAS              |        2|         0|          0|
|HG00512     |CHS        |EAS              |        2|         0|          0|
|HG00513     |CHS        |EAS              |        2|         0|          0|
|HG00524     |CHS        |EAS              |        2|         0|          0|
|HG00525     |CHS        |EAS              |        2|         0|          0|
|HG00530     |CHS        |EAS              |        2|         0|          0|
|HG00531     |CHS        |EAS              |        2|         0|          0|
|HG00533     |CHS        |EAS              |        2|         0|          0|
|HG00534     |CHS        |EAS              |        2|         0|          0|
|HG00536     |CHS        |EAS              |        2|         0|          0|
|HG00537     |CHS        |EAS              |        2|         0|          0|
|HG00542     |CHS        |EAS              |        1|         0|          0|
|HG00543     |CHS        |EAS              |        2|         0|          0|
|HG00553     |PUR        |AMR              |        2|         0|          0|
|HG00554     |PUR        |AMR              |        2|         0|          0|
|HG00556     |CHS        |EAS              |        1|         0|          0|
|HG00557     |CHS        |EAS              |        2|         0|          0|
|HG00559     |CHS        |EAS              |        2|         0|          0|
|HG00560     |CHS        |EAS              |        2|         0|          0|
|HG00565     |CHS        |EAS              |        2|         0|          0|
|HG00566     |CHS        |EAS              |        2|         0|          0|
|HG00577     |CHS        |EAS              |        1|         0|          0|
|HG00578     |CHS        |EAS              |        2|         0|          0|
|HG00580     |CHS        |EAS              |        2|         0|          0|
|HG00581     |CHS        |EAS              |        2|         0|          0|
|HG00583     |CHS        |EAS              |        2|         0|          0|
|HG00584     |CHS        |EAS              |        1|         0|          0|
|HG00589     |CHS        |EAS              |        2|         0|          0|
|HG00590     |CHS        |EAS              |        2|         0|          0|
|HG00592     |CHS        |EAS              |        1|         0|          0|
|HG00593     |CHS        |EAS              |        2|         0|          0|
|HG00595     |CHS        |EAS              |        2|         0|          0|
|HG00596     |CHS        |EAS              |        2|         0|          0|
|HG00607     |CHS        |EAS              |        2|         0|          0|
|HG00608     |CHS        |EAS              |        2|         0|          0|
|HG00610     |CHS        |EAS              |        2|         0|          0|
|HG00611     |CHS        |EAS              |        2|         0|          0|
|HG00613     |CHS        |EAS              |        2|         0|          0|
|HG00614     |CHS        |EAS              |        2|         0|          0|
|HG00619     |CHS        |EAS              |        2|         0|          0|
|HG00620     |CHS        |EAS              |        2|         0|          0|
|HG00625     |CHS        |EAS              |        1|         0|          0|
|HG00626     |CHS        |EAS              |        2|         0|          0|
|HG00628     |CHS        |EAS              |        2|         0|          0|
|HG00629     |CHS        |EAS              |        2|         0|          0|
|HG00634     |CHS        |EAS              |        2|         0|          0|
|HG00635     |CHS        |EAS              |        2|         0|          0|
|HG00637     |PUR        |AMR              |        2|         0|          0|
|HG00638     |PUR        |AMR              |        2|         0|          0|
|HG00640     |PUR        |AMR              |        2|         0|          0|
|HG00641     |PUR        |AMR              |        2|         0|          0|
|HG00650     |CHS        |EAS              |        1|         0|          0|
|HG00651     |CHS        |EAS              |        2|         0|          0|
|HG00653     |CHS        |EAS              |        1|         0|          0|
|HG00654     |CHS        |EAS              |        2|         0|          0|
|HG00656     |CHS        |EAS              |        2|         0|          0|
|HG00657     |CHS        |EAS              |        2|         0|          0|
|HG00662     |CHS        |EAS              |        2|         0|          0|
|HG00663     |CHS        |EAS              |        2|         0|          0|
|HG00671     |CHS        |EAS              |        2|         0|          0|
|HG00672     |CHS        |EAS              |        2|         0|          0|
|HG00683     |CHS        |EAS              |        2|         0|          0|
|HG00684     |CHS        |EAS              |        2|         0|          0|
|HG00689     |CHS        |EAS              |        2|         0|          0|
|HG00690     |CHS        |EAS              |        2|         0|          0|
|HG00692     |CHS        |EAS              |        2|         0|          0|
|HG00693     |CHS        |EAS              |        2|         0|          0|
|HG00698     |CHS        |EAS              |        2|         0|          0|
|HG00699     |CHS        |EAS              |        2|         0|          0|
|HG00701     |CHS        |EAS              |        1|         0|          0|
|HG00702     |CHS        |EAS              |        2|         0|          0|
|HG00704     |CHS        |EAS              |        2|         0|          0|
|HG00705     |CHS        |EAS              |        2|         0|          0|
|HG00707     |CHS        |EAS              |        2|         0|          0|
|HG00708     |CHS        |EAS              |        2|         0|          0|
|HG00731     |PUR        |AMR              |        2|         0|          0|
|HG00732     |PUR        |AMR              |        2|         0|          0|
|HG00734     |PUR        |AMR              |        2|         0|          0|
|HG00736     |PUR        |AMR              |        2|         0|          0|
|HG00737     |PUR        |AMR              |        1|         0|          0|
|HG00740     |PUR        |AMR              |        2|         1|          0|
|HG01047     |PUR        |AMR              |        2|         0|          0|
|HG01048     |PUR        |AMR              |        2|         0|          0|
|HG01051     |PUR        |AMR              |        2|         0|          0|
|HG01052     |PUR        |AMR              |        2|         0|          0|
|HG01055     |PUR        |AMR              |        2|         0|          0|
|HG01060     |PUR        |AMR              |        2|         0|          0|
|HG01061     |PUR        |AMR              |        2|         0|          0|
|HG01066     |PUR        |AMR              |        2|         2|          0|
|HG01067     |PUR        |AMR              |        2|         0|          0|
|HG01069     |PUR        |AMR              |        2|         0|          0|
|HG01070     |PUR        |AMR              |        2|         0|          0|
|HG01072     |PUR        |AMR              |        2|         0|          0|
|HG01073     |PUR        |AMR              |        2|         0|          0|
|HG01075     |PUR        |AMR              |        2|         0|          0|
|HG01079     |PUR        |AMR              |        2|         1|          0|
|HG01080     |PUR        |AMR              |        2|         0|          0|
|HG01082     |PUR        |AMR              |        2|         0|          0|
|HG01083     |PUR        |AMR              |        2|         1|          0|
|HG01085     |PUR        |AMR              |        2|         0|          0|
|HG01095     |PUR        |AMR              |        2|         0|          0|
|HG01097     |PUR        |AMR              |        2|         0|          0|
|HG01098     |PUR        |AMR              |        2|         0|          0|
|HG01101     |PUR        |AMR              |        2|         0|          0|
|HG01102     |PUR        |AMR              |        2|         0|          0|
|HG01104     |PUR        |AMR              |        2|         0|          0|
|HG01105     |PUR        |AMR              |        2|         0|          0|
|HG01107     |PUR        |AMR              |        1|         0|          0|
|HG01108     |PUR        |AMR              |        2|         0|          0|
|HG01112     |CLM        |AMR              |        2|         0|          0|
|HG01113     |CLM        |AMR              |        2|         0|          0|
|HG01124     |CLM        |AMR              |        2|         0|          0|
|HG01125     |CLM        |AMR              |        2|         1|          0|
|HG01133     |CLM        |AMR              |        2|         0|          0|
|HG01134     |CLM        |AMR              |        2|         0|          0|
|HG01136     |CLM        |AMR              |        2|         0|          0|
|HG01137     |CLM        |AMR              |        2|         0|          0|
|HG01140     |CLM        |AMR              |        2|         0|          0|
|HG01148     |CLM        |AMR              |        2|         0|          0|
|HG01149     |CLM        |AMR              |        2|         1|          0|
|HG01167     |PUR        |AMR              |        2|         2|          0|
|HG01168     |PUR        |AMR              |        2|         0|          0|
|HG01170     |PUR        |AMR              |        2|         0|          0|
|HG01171     |PUR        |AMR              |        2|         0|          0|
|HG01173     |PUR        |AMR              |        2|         0|          0|
|HG01174     |PUR        |AMR              |        2|         0|          0|
|HG01176     |PUR        |AMR              |        2|         0|          0|
|HG01183     |PUR        |AMR              |        2|         0|          0|
|HG01187     |PUR        |AMR              |        2|         0|          0|
|HG01188     |PUR        |AMR              |        2|         0|          0|
|HG01190     |PUR        |AMR              |        2|         0|          0|
|HG01191     |PUR        |AMR              |        2|         0|          0|
|HG01197     |PUR        |AMR              |        2|         0|          0|
|HG01198     |PUR        |AMR              |        2|         0|          0|
|HG01204     |PUR        |AMR              |        2|         2|          0|
|HG01250     |CLM        |AMR              |        2|         0|          0|
|HG01251     |CLM        |AMR              |        2|         0|          0|
|HG01257     |CLM        |AMR              |        2|         0|          0|
|HG01259     |CLM        |AMR              |        2|         0|          0|
|HG01271     |CLM        |AMR              |        2|         0|          0|
|HG01272     |CLM        |AMR              |        2|         0|          0|
|HG01274     |CLM        |AMR              |        2|         0|          0|
|HG01275     |CLM        |AMR              |        2|         1|          0|
|HG01277     |CLM        |AMR              |        2|         0|          0|
|HG01278     |CLM        |AMR              |        2|         0|          0|
|HG01334     |GBR        |EUR              |        2|         0|          0|
|HG01342     |CLM        |AMR              |        2|         0|          0|
|HG01344     |CLM        |AMR              |        2|         0|          0|
|HG01345     |CLM        |AMR              |        2|         0|          0|
|HG01350     |CLM        |AMR              |        2|         0|          0|
|HG01351     |CLM        |AMR              |        2|         0|          0|
|HG01353     |CLM        |AMR              |        2|         0|          0|
|HG01354     |CLM        |AMR              |        2|         0|          0|
|HG01356     |CLM        |AMR              |        2|         1|          0|
|HG01357     |CLM        |AMR              |        2|         0|          0|
|HG01359     |CLM        |AMR              |        2|         0|          0|
|HG01360     |CLM        |AMR              |        2|         0|          0|
|HG01365     |CLM        |AMR              |        2|         0|          0|
|HG01366     |CLM        |AMR              |        2|         0|          0|
|HG01374     |CLM        |AMR              |        2|         0|          0|
|HG01375     |CLM        |AMR              |        2|         0|          0|
|HG01377     |CLM        |AMR              |        1|         0|          1|
|HG01378     |CLM        |AMR              |        2|         0|          0|
|HG01383     |CLM        |AMR              |        2|         0|          0|
|HG01384     |CLM        |AMR              |        1|         0|          0|
|HG01389     |CLM        |AMR              |        2|         0|          0|
|HG01390     |CLM        |AMR              |        2|         0|          0|
|HG01437     |CLM        |AMR              |        2|         0|          0|
|HG01440     |CLM        |AMR              |        2|         0|          0|
|HG01441     |CLM        |AMR              |        2|         0|          0|
|HG01455     |CLM        |AMR              |        2|         0|          0|
|HG01456     |CLM        |AMR              |        2|         0|          0|
|HG01461     |CLM        |AMR              |        2|         0|          0|
|HG01462     |CLM        |AMR              |        2|         0|          0|
|HG01465     |CLM        |AMR              |        2|         0|          0|
|HG01488     |CLM        |AMR              |        2|         0|          0|
|HG01489     |CLM        |AMR              |        2|         0|          0|
|HG01491     |CLM        |AMR              |        2|         0|          0|
|HG01492     |CLM        |AMR              |        2|         1|          0|
|HG01494     |CLM        |AMR              |        2|         0|          0|
|HG01495     |CLM        |AMR              |        2|         0|          0|
|HG01497     |CLM        |AMR              |        2|         0|          0|
|HG01498     |CLM        |AMR              |        2|         0|          0|
|HG01515     |IBS        |EUR              |        2|         0|          0|
|HG01516     |IBS        |EUR              |        2|         0|          0|
|HG01518     |IBS        |EUR              |        2|         0|          0|
|HG01519     |IBS        |EUR              |        2|         0|          0|
|HG01521     |IBS        |EUR              |        2|         0|          0|
|HG01522     |IBS        |EUR              |        2|         0|          1|
|HG01550     |CLM        |AMR              |        2|         0|          1|
|HG01551     |CLM        |AMR              |        2|         0|          0|
|HG01617     |IBS        |EUR              |        2|         0|          0|
|HG01618     |IBS        |EUR              |        2|         0|          0|
|HG01619     |IBS        |EUR              |        2|         0|          0|
|HG01620     |IBS        |EUR              |        2|         0|          0|
|HG01623     |IBS        |EUR              |        2|         0|          0|
|HG01624     |IBS        |EUR              |        2|         0|          0|
|HG01625     |IBS        |EUR              |        2|         0|          0|
|HG01626     |IBS        |EUR              |        2|         0|          0|
|NA06984     |CEU        |EUR              |        2|         0|          0|
|NA06986     |CEU        |EUR              |        2|         0|          0|
|NA06989     |CEU        |EUR              |        2|         0|          0|
|NA06994     |CEU        |EUR              |        2|         0|          0|
|NA07000     |CEU        |EUR              |        2|         0|          0|
|NA07037     |CEU        |EUR              |        2|         0|          0|
|NA07048     |CEU        |EUR              |        2|         0|          0|
|NA07051     |CEU        |EUR              |        2|         0|          0|
|NA07056     |CEU        |EUR              |        2|         0|          0|
|NA07347     |CEU        |EUR              |        2|         0|          0|
|NA07357     |CEU        |EUR              |        2|         0|          0|
|NA10847     |CEU        |EUR              |        2|         0|          0|
|NA10851     |CEU        |EUR              |        2|         0|          0|
|NA11829     |CEU        |EUR              |        2|         0|          0|
|NA11830     |CEU        |EUR              |        2|         0|          0|
|NA11831     |CEU        |EUR              |        2|         0|          0|
|NA11843     |CEU        |EUR              |        2|         0|          0|
|NA11892     |CEU        |EUR              |        2|         0|          0|
|NA11893     |CEU        |EUR              |        1|         0|          0|
|NA11894     |CEU        |EUR              |        2|         0|          0|
|NA11919     |CEU        |EUR              |        2|         0|          0|
|NA11920     |CEU        |EUR              |        2|         0|          0|
|NA11930     |CEU        |EUR              |        2|         0|          0|
|NA11931     |CEU        |EUR              |        2|         0|          0|
|NA11932     |CEU        |EUR              |        2|         0|          0|
|NA11933     |CEU        |EUR              |        2|         0|          0|
|NA11992     |CEU        |EUR              |        2|         0|          0|
|NA11993     |CEU        |EUR              |        2|         0|          0|
|NA11994     |CEU        |EUR              |        2|         0|          0|
|NA11995     |CEU        |EUR              |        2|         0|          0|
|NA12003     |CEU        |EUR              |        2|         0|          0|
|NA12004     |CEU        |EUR              |        2|         0|          0|
|NA12006     |CEU        |EUR              |        2|         0|          0|
|NA12043     |CEU        |EUR              |        1|         0|          0|
|NA12044     |CEU        |EUR              |        2|         0|          0|
|NA12045     |CEU        |EUR              |        2|         0|          0|
|NA12046     |CEU        |EUR              |        2|         0|          1|
|NA12058     |CEU        |EUR              |        2|         0|          0|
|NA12144     |CEU        |EUR              |        2|         0|          1|
|NA12154     |CEU        |EUR              |        2|         0|          0|
|NA12155     |CEU        |EUR              |        2|         0|          0|
|NA12249     |CEU        |EUR              |        2|         0|          0|
|NA12272     |CEU        |EUR              |        2|         0|          0|
|NA12273     |CEU        |EUR              |        1|         0|          0|
|NA12275     |CEU        |EUR              |        2|         0|          0|
|NA12282     |CEU        |EUR              |        2|         0|          0|
|NA12283     |CEU        |EUR              |        2|         0|          0|
|NA12286     |CEU        |EUR              |        2|         0|          0|
|NA12287     |CEU        |EUR              |        2|         0|          0|
|NA12340     |CEU        |EUR              |        2|         0|          0|
|NA12341     |CEU        |EUR              |        2|         0|          0|
|NA12342     |CEU        |EUR              |        2|         0|          0|
|NA12347     |CEU        |EUR              |        2|         0|          0|
|NA12348     |CEU        |EUR              |        2|         0|          0|
|NA12383     |CEU        |EUR              |        2|         0|          0|
|NA12399     |CEU        |EUR              |        2|         0|          0|
|NA12400     |CEU        |EUR              |        2|         0|          0|
|NA12413     |CEU        |EUR              |        2|         0|          0|
|NA12489     |CEU        |EUR              |        2|         0|          0|
|NA12546     |CEU        |EUR              |        2|         0|          0|
|NA12716     |CEU        |EUR              |        2|         0|          0|
|NA12717     |CEU        |EUR              |        2|         0|          0|
|NA12718     |CEU        |EUR              |        2|         0|          0|
|NA12748     |CEU        |EUR              |        2|         0|          0|
|NA12749     |CEU        |EUR              |        2|         0|          0|
|NA12750     |CEU        |EUR              |        2|         0|          0|
|NA12751     |CEU        |EUR              |        2|         0|          0|
|NA12761     |CEU        |EUR              |        2|         0|          0|
|NA12763     |CEU        |EUR              |        2|         0|          0|
|NA12775     |CEU        |EUR              |        2|         0|          0|
|NA12777     |CEU        |EUR              |        2|         0|          0|
|NA12778     |CEU        |EUR              |        2|         0|          0|
|NA12812     |CEU        |EUR              |        2|         0|          0|
|NA12814     |CEU        |EUR              |        2|         0|          0|
|NA12815     |CEU        |EUR              |        2|         0|          0|
|NA12827     |CEU        |EUR              |        2|         0|          0|
|NA12829     |CEU        |EUR              |        2|         0|          0|
|NA12830     |CEU        |EUR              |        2|         0|          0|
|NA12842     |CEU        |EUR              |        2|         0|          0|
|NA12843     |CEU        |EUR              |        2|         0|          0|
|NA12872     |CEU        |EUR              |        2|         0|          0|
|NA12873     |CEU        |EUR              |        1|         0|          0|
|NA12874     |CEU        |EUR              |        2|         0|          0|
|NA12889     |CEU        |EUR              |        2|         0|          0|
|NA12890     |CEU        |EUR              |        2|         0|          0|
|NA18486     |YRI        |AFR              |        2|         0|          0|
|NA18487     |YRI        |AFR              |        2|         0|          0|
|NA18489     |YRI        |AFR              |        2|         0|          0|
|NA18498     |YRI        |AFR              |        2|         0|          0|
|NA18499     |YRI        |AFR              |        2|         0|          0|
|NA18501     |YRI        |AFR              |        2|         0|          0|
|NA18502     |YRI        |AFR              |        2|         0|          0|
|NA18504     |YRI        |AFR              |        2|         0|          0|
|NA18505     |YRI        |AFR              |        2|         0|          0|
|NA18507     |YRI        |AFR              |        2|         0|          0|
|NA18508     |YRI        |AFR              |        2|         0|          0|
|NA18510     |YRI        |AFR              |        2|         0|          0|
|NA18511     |YRI        |AFR              |        2|         0|          0|
|NA18516     |YRI        |AFR              |        1|         0|          0|
|NA18517     |YRI        |AFR              |        2|         0|          0|
|NA18519     |YRI        |AFR              |        2|         0|          0|
|NA18520     |YRI        |AFR              |        2|         0|          0|
|NA18522     |YRI        |AFR              |        2|         0|          0|
|NA18523     |YRI        |AFR              |        2|         0|          0|
|NA18525     |CHB        |EAS              |        2|         0|          0|
|NA18526     |CHB        |EAS              |        2|         0|          0|
|NA18527     |CHB        |EAS              |        2|         0|          0|
|NA18528     |CHB        |EAS              |        2|         0|          0|
|NA18530     |CHB        |EAS              |        2|         0|          0|
|NA18532     |CHB        |EAS              |        2|         0|          0|
|NA18534     |CHB        |EAS              |        2|         0|          0|
|NA18535     |CHB        |EAS              |        2|         0|          0|
|NA18536     |CHB        |EAS              |        2|         0|          0|
|NA18537     |CHB        |EAS              |        2|         0|          0|
|NA18538     |CHB        |EAS              |        1|         0|          0|
|NA18539     |CHB        |EAS              |        2|         0|          0|
|NA18541     |CHB        |EAS              |        1|         0|          0|
|NA18542     |CHB        |EAS              |        2|         0|          0|
|NA18543     |CHB        |EAS              |        1|         0|          0|
|NA18544     |CHB        |EAS              |        2|         0|          0|
|NA18545     |CHB        |EAS              |        2|         0|          0|
|NA18546     |CHB        |EAS              |        2|         0|          0|
|NA18547     |CHB        |EAS              |        2|         0|          0|
|NA18548     |CHB        |EAS              |        2|         0|          0|
|NA18549     |CHB        |EAS              |        2|         0|          0|
|NA18550     |CHB        |EAS              |        2|         0|          0|
|NA18552     |CHB        |EAS              |        2|         0|          0|
|NA18553     |CHB        |EAS              |        2|         0|          0|
|NA18555     |CHB        |EAS              |        2|         0|          0|
|NA18557     |CHB        |EAS              |        2|         0|          0|
|NA18558     |CHB        |EAS              |        2|         0|          0|
|NA18559     |CHB        |EAS              |        2|         0|          0|
|NA18560     |CHB        |EAS              |        2|         0|          0|
|NA18561     |CHB        |EAS              |        2|         0|          0|
|NA18562     |CHB        |EAS              |        2|         0|          0|
|NA18563     |CHB        |EAS              |        2|         0|          0|
|NA18564     |CHB        |EAS              |        2|         0|          0|
|NA18565     |CHB        |EAS              |        2|         0|          0|
|NA18566     |CHB        |EAS              |        2|         0|          0|
|NA18567     |CHB        |EAS              |        2|         0|          0|
|NA18570     |CHB        |EAS              |        2|         0|          0|
|NA18571     |CHB        |EAS              |        2|         0|          0|
|NA18572     |CHB        |EAS              |        2|         0|          0|
|NA18573     |CHB        |EAS              |        2|         0|          0|
|NA18574     |CHB        |EAS              |        2|         0|          0|
|NA18576     |CHB        |EAS              |        2|         0|          0|
|NA18577     |CHB        |EAS              |        2|         0|          0|
|NA18579     |CHB        |EAS              |        2|         0|          0|
|NA18582     |CHB        |EAS              |        2|         0|          0|
|NA18592     |CHB        |EAS              |        2|         0|          0|
|NA18593     |CHB        |EAS              |        2|         0|          0|
|NA18595     |CHB        |EAS              |        2|         0|          0|
|NA18596     |CHB        |EAS              |        2|         0|          0|
|NA18597     |CHB        |EAS              |        2|         0|          0|
|NA18599     |CHB        |EAS              |        2|         0|          0|
|NA18602     |CHB        |EAS              |        2|         0|          0|
|NA18603     |CHB        |EAS              |        2|         0|          0|
|NA18605     |CHB        |EAS              |        2|         0|          0|
|NA18606     |CHB        |EAS              |        2|         0|          0|
|NA18608     |CHB        |EAS              |        2|         0|          0|
|NA18609     |CHB        |EAS              |        2|         0|          0|
|NA18610     |CHB        |EAS              |        2|         0|          0|
|NA18611     |CHB        |EAS              |        2|         0|          0|
|NA18612     |CHB        |EAS              |        1|         0|          0|
|NA18613     |CHB        |EAS              |        2|         0|          0|
|NA18614     |CHB        |EAS              |        2|         0|          0|
|NA18615     |CHB        |EAS              |        2|         0|          0|
|NA18616     |CHB        |EAS              |        1|         0|          0|
|NA18617     |CHB        |EAS              |        2|         0|          0|
|NA18618     |CHB        |EAS              |        2|         0|          0|
|NA18619     |CHB        |EAS              |        2|         0|          0|
|NA18620     |CHB        |EAS              |        2|         0|          0|
|NA18621     |CHB        |EAS              |        2|         0|          0|
|NA18622     |CHB        |EAS              |        2|         0|          0|
|NA18623     |CHB        |EAS              |        2|         0|          0|
|NA18624     |CHB        |EAS              |        2|         0|          0|
|NA18626     |CHB        |EAS              |        2|         0|          0|
|NA18627     |CHB        |EAS              |        1|         0|          0|
|NA18628     |CHB        |EAS              |        1|         0|          0|
|NA18630     |CHB        |EAS              |        2|         0|          0|
|NA18631     |CHB        |EAS              |        2|         0|          0|
|NA18632     |CHB        |EAS              |        1|         0|          0|
|NA18633     |CHB        |EAS              |        1|         0|          0|
|NA18634     |CHB        |EAS              |        2|         0|          0|
|NA18635     |CHB        |EAS              |        2|         0|          0|
|NA18636     |CHB        |EAS              |        1|         0|          0|
|NA18637     |CHB        |EAS              |        2|         0|          0|
|NA18638     |CHB        |EAS              |        2|         0|          0|
|NA18639     |CHB        |EAS              |        1|         0|          0|
|NA18640     |CHB        |EAS              |        2|         0|          0|
|NA18641     |CHB        |EAS              |        2|         0|          0|
|NA18642     |CHB        |EAS              |        2|         0|          0|
|NA18643     |CHB        |EAS              |        2|         0|          0|
|NA18645     |CHB        |EAS              |        2|         0|          0|
|NA18647     |CHB        |EAS              |        2|         0|          0|
|NA18740     |CHB        |EAS              |        2|         0|          0|
|NA18745     |CHB        |EAS              |        2|         0|          0|
|NA18747     |CHB        |EAS              |        2|         0|          0|
|NA18748     |CHB        |EAS              |        2|         0|          0|
|NA18749     |CHB        |EAS              |        2|         0|          0|
|NA18757     |CHB        |EAS              |        2|         0|          0|
|NA18853     |YRI        |AFR              |        2|         0|          0|
|NA18856     |YRI        |AFR              |        2|         0|          0|
|NA18858     |YRI        |AFR              |        2|         0|          0|
|NA18861     |YRI        |AFR              |        2|         0|          0|
|NA18867     |YRI        |AFR              |        2|         0|          0|
|NA18868     |YRI        |AFR              |        2|         0|          0|
|NA18870     |YRI        |AFR              |        2|         0|          0|
|NA18871     |YRI        |AFR              |        2|         0|          0|
|NA18873     |YRI        |AFR              |        2|         0|          0|
|NA18874     |YRI        |AFR              |        2|         0|          0|
|NA18907     |YRI        |AFR              |        2|         0|          0|
|NA18908     |YRI        |AFR              |        2|         0|          0|
|NA18909     |YRI        |AFR              |        2|         0|          0|
|NA18910     |YRI        |AFR              |        2|         0|          0|
|NA18912     |YRI        |AFR              |        2|         0|          0|
|NA18916     |YRI        |AFR              |        2|         0|          0|
|NA18917     |YRI        |AFR              |        2|         0|          0|
|NA18923     |YRI        |AFR              |        2|         0|          0|
|NA18924     |YRI        |AFR              |        2|         0|          0|
|NA18933     |YRI        |AFR              |        2|         0|          0|
|NA18934     |YRI        |AFR              |        2|         0|          0|
|NA18939     |JPT        |EAS              |        2|         0|          0|
|NA18940     |JPT        |EAS              |        2|         0|          0|
|NA18941     |JPT        |EAS              |        2|         0|          0|
|NA18942     |JPT        |EAS              |        2|         0|          0|
|NA18943     |JPT        |EAS              |        1|         0|          0|
|NA18944     |JPT        |EAS              |        2|         0|          0|
|NA18945     |JPT        |EAS              |        2|         0|          0|
|NA18946     |JPT        |EAS              |        2|         0|          0|
|NA18947     |JPT        |EAS              |        2|         0|          0|
|NA18948     |JPT        |EAS              |        1|         0|          0|
|NA18949     |JPT        |EAS              |        1|         0|          0|
|NA18950     |JPT        |EAS              |        2|         0|          0|
|NA18951     |JPT        |EAS              |        2|         0|          0|
|NA18952     |JPT        |EAS              |        2|         0|          0|
|NA18953     |JPT        |EAS              |        2|         0|          0|
|NA18954     |JPT        |EAS              |        2|         0|          0|
|NA18956     |JPT        |EAS              |        1|         0|          0|
|NA18957     |JPT        |EAS              |        2|         0|          0|
|NA18959     |JPT        |EAS              |        1|         0|          0|
|NA18960     |JPT        |EAS              |        2|         0|          0|
|NA18961     |JPT        |EAS              |        2|         0|          0|
|NA18962     |JPT        |EAS              |        2|         0|          0|
|NA18963     |JPT        |EAS              |        2|         0|          0|
|NA18964     |JPT        |EAS              |        1|         0|          0|
|NA18965     |JPT        |EAS              |        2|         0|          0|
|NA18966     |JPT        |EAS              |        1|         0|          0|
|NA18968     |JPT        |EAS              |        0|         0|          0|
|NA18971     |JPT        |EAS              |        2|         0|          0|
|NA18973     |JPT        |EAS              |        2|         0|          0|
|NA18974     |JPT        |EAS              |        2|         0|          0|
|NA18975     |JPT        |EAS              |        2|         0|          0|
|NA18976     |JPT        |EAS              |        2|         0|          0|
|NA18977     |JPT        |EAS              |        2|         0|          0|
|NA18978     |JPT        |EAS              |        2|         0|          0|
|NA18980     |JPT        |EAS              |        1|         0|          0|
|NA18981     |JPT        |EAS              |        2|         0|          0|
|NA18982     |JPT        |EAS              |        1|         0|          0|
|NA18983     |JPT        |EAS              |        1|         0|          0|
|NA18984     |JPT        |EAS              |        2|         0|          0|
|NA18985     |JPT        |EAS              |        1|         0|          0|
|NA18986     |JPT        |EAS              |        2|         0|          0|
|NA18987     |JPT        |EAS              |        2|         0|          0|
|NA18988     |JPT        |EAS              |        2|         0|          0|
|NA18989     |JPT        |EAS              |        2|         0|          0|
|NA18990     |JPT        |EAS              |        2|         0|          0|
|NA18992     |JPT        |EAS              |        2|         0|          0|
|NA18994     |JPT        |EAS              |        2|         0|          0|
|NA18995     |JPT        |EAS              |        2|         0|          0|
|NA18998     |JPT        |EAS              |        0|         0|          0|
|NA18999     |JPT        |EAS              |        2|         0|          0|
|NA19000     |JPT        |EAS              |        2|         0|          0|
|NA19002     |JPT        |EAS              |        2|         0|          0|
|NA19003     |JPT        |EAS              |        1|         0|          0|
|NA19004     |JPT        |EAS              |        2|         0|          0|
|NA19005     |JPT        |EAS              |        1|         0|          0|
|NA19007     |JPT        |EAS              |        2|         0|          0|
|NA19009     |JPT        |EAS              |        1|         0|          0|
|NA19010     |JPT        |EAS              |        2|         0|          0|
|NA19012     |JPT        |EAS              |        2|         0|          0|
|NA19020     |LWK        |AFR              |        2|         0|          0|
|NA19028     |LWK        |AFR              |        2|         0|          0|
|NA19035     |LWK        |AFR              |        2|         0|          0|
|NA19036     |LWK        |AFR              |        2|         0|          0|
|NA19038     |LWK        |AFR              |        2|         0|          0|
|NA19041     |LWK        |AFR              |        2|         0|          0|
|NA19044     |LWK        |AFR              |        2|         0|          0|
|NA19046     |LWK        |AFR              |        2|         0|          0|
|NA19054     |JPT        |EAS              |        2|         0|          0|
|NA19055     |JPT        |EAS              |        0|         0|          0|
|NA19056     |JPT        |EAS              |        2|         0|          0|
|NA19057     |JPT        |EAS              |        1|         0|          0|
|NA19058     |JPT        |EAS              |        2|         0|          0|
|NA19059     |JPT        |EAS              |        1|         0|          0|
|NA19060     |JPT        |EAS              |        2|         0|          0|
|NA19062     |JPT        |EAS              |        2|         0|          0|
|NA19063     |JPT        |EAS              |        2|         0|          0|
|NA19064     |JPT        |EAS              |        2|         0|          0|
|NA19065     |JPT        |EAS              |        2|         0|          0|
|NA19066     |JPT        |EAS              |        2|         0|          0|
|NA19067     |JPT        |EAS              |        1|         0|          0|
|NA19068     |JPT        |EAS              |        2|         0|          0|
|NA19070     |JPT        |EAS              |        2|         0|          0|
|NA19072     |JPT        |EAS              |        2|         0|          0|
|NA19074     |JPT        |EAS              |        2|         0|          0|
|NA19075     |JPT        |EAS              |        0|         0|          0|
|NA19076     |JPT        |EAS              |        2|         0|          0|
|NA19077     |JPT        |EAS              |        1|         0|          0|
|NA19078     |JPT        |EAS              |        2|         0|          0|
|NA19079     |JPT        |EAS              |        1|         0|          0|
|NA19080     |JPT        |EAS              |        2|         0|          0|
|NA19081     |JPT        |EAS              |        2|         0|          0|
|NA19082     |JPT        |EAS              |        2|         0|          0|
|NA19083     |JPT        |EAS              |        2|         0|          0|
|NA19084     |JPT        |EAS              |        2|         0|          0|
|NA19085     |JPT        |EAS              |        2|         0|          0|
|NA19087     |JPT        |EAS              |        2|         0|          0|
|NA19088     |JPT        |EAS              |        2|         0|          0|
|NA19093     |YRI        |AFR              |        2|         0|          0|
|NA19095     |YRI        |AFR              |        2|         0|          0|
|NA19096     |YRI        |AFR              |        2|         0|          0|
|NA19098     |YRI        |AFR              |        2|         0|          0|
|NA19099     |YRI        |AFR              |        2|         0|          0|
|NA19102     |YRI        |AFR              |        2|         0|          0|
|NA19107     |YRI        |AFR              |        2|         0|          0|
|NA19108     |YRI        |AFR              |        2|         0|          0|
|NA19113     |YRI        |AFR              |        1|         0|          0|
|NA19114     |YRI        |AFR              |        1|         0|          0|
|NA19116     |YRI        |AFR              |        2|         0|          0|
|NA19117     |YRI        |AFR              |        2|         0|          0|
|NA19118     |YRI        |AFR              |        2|         0|          0|
|NA19119     |YRI        |AFR              |        2|         0|          0|
|NA19121     |YRI        |AFR              |        2|         0|          0|
|NA19129     |YRI        |AFR              |        2|         0|          0|
|NA19130     |YRI        |AFR              |        2|         0|          0|
|NA19131     |YRI        |AFR              |        2|         0|          0|
|NA19137     |YRI        |AFR              |        2|         0|          0|
|NA19138     |YRI        |AFR              |        2|         0|          0|
|NA19146     |YRI        |AFR              |        2|         0|          0|
|NA19147     |YRI        |AFR              |        2|         0|          0|
|NA19149     |YRI        |AFR              |        2|         0|          0|
|NA19150     |YRI        |AFR              |        2|         0|          0|
|NA19152     |YRI        |AFR              |        2|         0|          0|
|NA19160     |YRI        |AFR              |        2|         0|          0|
|NA19171     |YRI        |AFR              |        2|         0|          0|
|NA19172     |YRI        |AFR              |        2|         0|          0|
|NA19175     |YRI        |AFR              |        2|         0|          0|
|NA19185     |YRI        |AFR              |        2|         0|          0|
|NA19189     |YRI        |AFR              |        2|         0|          0|
|NA19190     |YRI        |AFR              |        2|         0|          0|
|NA19197     |YRI        |AFR              |        2|         0|          0|
|NA19198     |YRI        |AFR              |        2|         0|          0|
|NA19200     |YRI        |AFR              |        2|         0|          0|
|NA19204     |YRI        |AFR              |        2|         0|          0|
|NA19207     |YRI        |AFR              |        2|         0|          0|
|NA19209     |YRI        |AFR              |        2|         0|          0|
|NA19213     |YRI        |AFR              |        2|         0|          0|
|NA19222     |YRI        |AFR              |        2|         0|          0|
|NA19223     |YRI        |AFR              |        2|         0|          0|
|NA19225     |YRI        |AFR              |        2|         0|          0|
|NA19235     |YRI        |AFR              |        2|         0|          0|
|NA19236     |YRI        |AFR              |        2|         0|          0|
|NA19247     |YRI        |AFR              |        2|         0|          0|
|NA19248     |YRI        |AFR              |        2|         0|          0|
|NA19256     |YRI        |AFR              |        2|         0|          0|
|NA19257     |YRI        |AFR              |        2|         0|          0|
|NA19307     |LWK        |AFR              |        2|         0|          0|
|NA19308     |LWK        |AFR              |        2|         0|          0|
|NA19309     |LWK        |AFR              |        2|         0|          0|
|NA19310     |LWK        |AFR              |        2|         0|          0|
|NA19311     |LWK        |AFR              |        2|         0|          0|
|NA19312     |LWK        |AFR              |        2|         0|          0|
|NA19313     |LWK        |AFR              |        2|         0|          0|
|NA19315     |LWK        |AFR              |        1|         0|          0|
|NA19316     |LWK        |AFR              |        2|         0|          0|
|NA19317     |LWK        |AFR              |        2|         0|          0|
|NA19318     |LWK        |AFR              |        2|         0|          0|
|NA19319     |LWK        |AFR              |        2|         0|          0|
|NA19321     |LWK        |AFR              |        2|         0|          0|
|NA19324     |LWK        |AFR              |        2|         0|          0|
|NA19327     |LWK        |AFR              |        2|         0|          0|
|NA19328     |LWK        |AFR              |        2|         0|          0|
|NA19331     |LWK        |AFR              |        2|         0|          0|
|NA19332     |LWK        |AFR              |        2|         0|          0|
|NA19334     |LWK        |AFR              |        2|         0|          0|
|NA19338     |LWK        |AFR              |        2|         0|          0|
|NA19346     |LWK        |AFR              |        2|         0|          0|
|NA19347     |LWK        |AFR              |        2|         0|          0|
|NA19350     |LWK        |AFR              |        2|         0|          0|
|NA19351     |LWK        |AFR              |        2|         0|          0|
|NA19352     |LWK        |AFR              |        2|         0|          0|
|NA19355     |LWK        |AFR              |        2|         0|          0|
|NA19359     |LWK        |AFR              |        2|         0|          0|
|NA19360     |LWK        |AFR              |        2|         0|          0|
|NA19371     |LWK        |AFR              |        2|         0|          0|
|NA19372     |LWK        |AFR              |        2|         0|          0|
|NA19373     |LWK        |AFR              |        2|         0|          0|
|NA19374     |LWK        |AFR              |        2|         0|          0|
|NA19375     |LWK        |AFR              |        2|         0|          0|
|NA19376     |LWK        |AFR              |        2|         0|          0|
|NA19377     |LWK        |AFR              |        2|         0|          0|
|NA19379     |LWK        |AFR              |        2|         0|          0|
|NA19380     |LWK        |AFR              |        2|         0|          0|
|NA19381     |LWK        |AFR              |        2|         0|          0|
|NA19382     |LWK        |AFR              |        2|         0|          0|
|NA19383     |LWK        |AFR              |        2|         0|          0|
|NA19384     |LWK        |AFR              |        2|         0|          0|
|NA19385     |LWK        |AFR              |        2|         0|          0|
|NA19390     |LWK        |AFR              |        2|         0|          0|
|NA19391     |LWK        |AFR              |        2|         0|          0|
|NA19393     |LWK        |AFR              |        2|         0|          0|
|NA19394     |LWK        |AFR              |        2|         0|          0|
|NA19395     |LWK        |AFR              |        2|         0|          0|
|NA19396     |LWK        |AFR              |        2|         0|          0|
|NA19397     |LWK        |AFR              |        2|         0|          0|
|NA19398     |LWK        |AFR              |        2|         0|          0|
|NA19399     |LWK        |AFR              |        2|         0|          0|
|NA19401     |LWK        |AFR              |        2|         0|          0|
|NA19403     |LWK        |AFR              |        2|         0|          0|
|NA19404     |LWK        |AFR              |        2|         0|          0|
|NA19428     |LWK        |AFR              |        2|         0|          0|
|NA19429     |LWK        |AFR              |        2|         0|          0|
|NA19430     |LWK        |AFR              |        2|         0|          0|
|NA19431     |LWK        |AFR              |        2|         0|          0|
|NA19434     |LWK        |AFR              |        2|         0|          0|
|NA19435     |LWK        |AFR              |        2|         0|          0|
|NA19436     |LWK        |AFR              |        2|         0|          0|
|NA19437     |LWK        |AFR              |        2|         0|          0|
|NA19438     |LWK        |AFR              |        2|         0|          0|
|NA19439     |LWK        |AFR              |        2|         0|          0|
|NA19440     |LWK        |AFR              |        2|         0|          0|
|NA19443     |LWK        |AFR              |        2|         0|          0|
|NA19444     |LWK        |AFR              |        2|         0|          0|
|NA19445     |LWK        |AFR              |        2|         0|          0|
|NA19446     |LWK        |AFR              |        2|         0|          0|
|NA19448     |LWK        |AFR              |        2|         0|          0|
|NA19449     |LWK        |AFR              |        2|         0|          0|
|NA19451     |LWK        |AFR              |        2|         0|          0|
|NA19452     |LWK        |AFR              |        2|         0|          0|
|NA19453     |LWK        |AFR              |        2|         0|          0|
|NA19455     |LWK        |AFR              |        1|         0|          0|
|NA19456     |LWK        |AFR              |        2|         0|          0|
|NA19457     |LWK        |AFR              |        2|         0|          0|
|NA19461     |LWK        |AFR              |        2|         0|          0|
|NA19462     |LWK        |AFR              |        2|         0|          0|
|NA19463     |LWK        |AFR              |        2|         0|          0|
|NA19466     |LWK        |AFR              |        2|         0|          0|
|NA19467     |LWK        |AFR              |        2|         0|          0|
|NA19468     |LWK        |AFR              |        2|         0|          0|
|NA19469     |LWK        |AFR              |        2|         0|          0|
|NA19470     |LWK        |AFR              |        2|         0|          0|
|NA19471     |LWK        |AFR              |        2|         0|          0|
|NA19472     |LWK        |AFR              |        2|         0|          0|
|NA19473     |LWK        |AFR              |        2|         0|          0|
|NA19474     |LWK        |AFR              |        2|         0|          0|
|NA19625     |ASW        |AFR              |        2|         0|          0|
|NA19648     |MXL        |AMR              |        2|         0|          0|
|NA19651     |MXL        |AMR              |        2|         0|          0|
|NA19652     |MXL        |AMR              |        2|         0|          0|
|NA19654     |MXL        |AMR              |        2|         0|          0|
|NA19655     |MXL        |AMR              |        2|         0|          0|
|NA19657     |MXL        |AMR              |        2|         2|          0|
|NA19660     |MXL        |AMR              |        2|         0|          0|
|NA19661     |MXL        |AMR              |        2|         0|          0|
|NA19663     |MXL        |AMR              |        2|         0|          0|
|NA19664     |MXL        |AMR              |        2|         1|          0|
|NA19672     |MXL        |AMR              |        2|         0|          0|
|NA19675     |MXL        |AMR              |        2|         0|          0|
|NA19676     |MXL        |AMR              |        2|         1|          0|
|NA19678     |MXL        |AMR              |        2|         0|          0|
|NA19679     |MXL        |AMR              |        1|         0|          0|
|NA19681     |MXL        |AMR              |        2|         0|          0|
|NA19682     |MXL        |AMR              |        2|         0|          0|
|NA19684     |MXL        |AMR              |        2|         0|          0|
|NA19685     |MXL        |AMR              |        2|         0|          0|
|NA19700     |ASW        |AFR              |        2|         0|          0|
|NA19701     |ASW        |AFR              |        2|         0|          0|
|NA19703     |ASW        |AFR              |        2|         0|          0|
|NA19704     |ASW        |AFR              |        2|         0|          0|
|NA19707     |ASW        |AFR              |        2|         0|          0|
|NA19711     |ASW        |AFR              |        2|         0|          0|
|NA19712     |ASW        |AFR              |        2|         0|          0|
|NA19713     |ASW        |AFR              |        2|         0|          0|
|NA19716     |MXL        |AMR              |        2|         0|          0|
|NA19717     |MXL        |AMR              |        2|         0|          0|
|NA19719     |MXL        |AMR              |        2|         0|          0|
|NA19720     |MXL        |AMR              |        2|         1|          0|
|NA19722     |MXL        |AMR              |        2|         0|          0|
|NA19723     |MXL        |AMR              |        2|         0|          0|
|NA19725     |MXL        |AMR              |        2|         0|          0|
|NA19726     |MXL        |AMR              |        2|         1|          0|
|NA19728     |MXL        |AMR              |        2|         1|          0|
|NA19729     |MXL        |AMR              |        2|         0|          0|
|NA19731     |MXL        |AMR              |        2|         1|          0|
|NA19732     |MXL        |AMR              |        2|         1|          0|
|NA19734     |MXL        |AMR              |        2|         0|          0|
|NA19735     |MXL        |AMR              |        2|         0|          0|
|NA19737     |MXL        |AMR              |        2|         0|          0|
|NA19738     |MXL        |AMR              |        2|         0|          0|
|NA19740     |MXL        |AMR              |        2|         0|          0|
|NA19741     |MXL        |AMR              |        2|         1|          0|
|NA19746     |MXL        |AMR              |        2|         0|          0|
|NA19747     |MXL        |AMR              |        2|         2|          0|
|NA19749     |MXL        |AMR              |        2|         0|          0|
|NA19750     |MXL        |AMR              |        2|         0|          0|
|NA19752     |MXL        |AMR              |        2|         0|          0|
|NA19753     |MXL        |AMR              |        2|         0|          0|
|NA19755     |MXL        |AMR              |        2|         1|          0|
|NA19756     |MXL        |AMR              |        2|         1|          0|
|NA19758     |MXL        |AMR              |        2|         0|          0|
|NA19759     |MXL        |AMR              |        2|         2|          0|
|NA19761     |MXL        |AMR              |        2|         1|          0|
|NA19762     |MXL        |AMR              |        2|         1|          0|
|NA19764     |MXL        |AMR              |        2|         0|          0|
|NA19770     |MXL        |AMR              |        2|         0|          0|
|NA19771     |MXL        |AMR              |        2|         0|          0|
|NA19773     |MXL        |AMR              |        2|         0|          0|
|NA19774     |MXL        |AMR              |        2|         0|          0|
|NA19776     |MXL        |AMR              |        2|         1|          0|
|NA19777     |MXL        |AMR              |        2|         0|          0|
|NA19779     |MXL        |AMR              |        2|         0|          0|
|NA19780     |MXL        |AMR              |        2|         0|          0|
|NA19782     |MXL        |AMR              |        2|         0|          0|
|NA19783     |MXL        |AMR              |        2|         2|          0|
|NA19785     |MXL        |AMR              |        2|         1|          0|
|NA19786     |MXL        |AMR              |        2|         1|          0|
|NA19788     |MXL        |AMR              |        2|         0|          0|
|NA19789     |MXL        |AMR              |        2|         0|          0|
|NA19794     |MXL        |AMR              |        2|         0|          0|
|NA19795     |MXL        |AMR              |        2|         0|          0|
|NA19818     |ASW        |AFR              |        2|         0|          0|
|NA19819     |ASW        |AFR              |        1|         0|          0|
|NA19834     |ASW        |AFR              |        2|         0|          0|
|NA19835     |ASW        |AFR              |        2|         0|          0|
|NA19900     |ASW        |AFR              |        2|         0|          0|
|NA19901     |ASW        |AFR              |        2|         0|          0|
|NA19904     |ASW        |AFR              |        2|         0|          0|
|NA19908     |ASW        |AFR              |        2|         0|          0|
|NA19909     |ASW        |AFR              |        2|         0|          0|
|NA19914     |ASW        |AFR              |        2|         0|          0|
|NA19916     |ASW        |AFR              |        2|         0|          0|
|NA19917     |ASW        |AFR              |        2|         0|          0|
|NA19920     |ASW        |AFR              |        2|         0|          0|
|NA19921     |ASW        |AFR              |        2|         0|          0|
|NA19922     |ASW        |AFR              |        2|         0|          0|
|NA19923     |ASW        |AFR              |        2|         0|          0|
|NA19982     |ASW        |AFR              |        2|         0|          0|
|NA19984     |ASW        |AFR              |        2|         0|          0|
|NA19985     |ASW        |AFR              |        2|         0|          0|
|NA20126     |ASW        |AFR              |        2|         0|          0|
|NA20127     |ASW        |AFR              |        2|         0|          0|
|NA20276     |ASW        |AFR              |        2|         0|          0|
|NA20278     |ASW        |AFR              |        2|         0|          0|
|NA20281     |ASW        |AFR              |        2|         0|          0|
|NA20282     |ASW        |AFR              |        2|         0|          0|
|NA20287     |ASW        |AFR              |        2|         0|          0|
|NA20289     |ASW        |AFR              |        2|         0|          0|
|NA20291     |ASW        |AFR              |        2|         0|          0|
|NA20294     |ASW        |AFR              |        2|         0|          0|
|NA20296     |ASW        |AFR              |        2|         0|          0|
|NA20298     |ASW        |AFR              |        2|         0|          0|
|NA20299     |ASW        |AFR              |        2|         0|          0|
|NA20314     |ASW        |AFR              |        2|         0|          0|
|NA20317     |ASW        |AFR              |        2|         0|          0|
|NA20322     |ASW        |AFR              |        2|         0|          0|
|NA20332     |ASW        |AFR              |        2|         0|          0|
|NA20334     |ASW        |AFR              |        2|         0|          0|
|NA20336     |ASW        |AFR              |        2|         0|          0|
|NA20339     |ASW        |AFR              |        2|         0|          0|
|NA20340     |ASW        |AFR              |        2|         0|          0|
|NA20341     |ASW        |AFR              |        2|         0|          0|
|NA20342     |ASW        |AFR              |        2|         0|          0|
|NA20344     |ASW        |AFR              |        2|         0|          0|
|NA20346     |ASW        |AFR              |        2|         0|          0|
|NA20348     |ASW        |AFR              |        2|         0|          0|
|NA20351     |ASW        |AFR              |        2|         0|          0|
|NA20356     |ASW        |AFR              |        2|         0|          0|
|NA20357     |ASW        |AFR              |        2|         0|          0|
|NA20359     |ASW        |AFR              |        2|         0|          0|
|NA20363     |ASW        |AFR              |        2|         0|          0|
|NA20412     |ASW        |AFR              |        2|         0|          0|
|NA20414     |ASW        |AFR              |        2|         0|          1|
|NA20502     |TSI        |EUR              |        2|         0|          0|
|NA20503     |TSI        |EUR              |        1|         0|          0|
|NA20504     |TSI        |EUR              |        2|         1|          0|
|NA20505     |TSI        |EUR              |        2|         0|          0|
|NA20506     |TSI        |EUR              |        2|         0|          0|
|NA20507     |TSI        |EUR              |        2|         0|          0|
|NA20508     |TSI        |EUR              |        2|         0|          0|
|NA20509     |TSI        |EUR              |        2|         0|          0|
|NA20510     |TSI        |EUR              |        2|         0|          0|
|NA20512     |TSI        |EUR              |        2|         0|          0|
|NA20513     |TSI        |EUR              |        2|         0|          0|
|NA20515     |TSI        |EUR              |        2|         0|          0|
|NA20516     |TSI        |EUR              |        2|         0|          0|
|NA20517     |TSI        |EUR              |        2|         0|          0|
|NA20518     |TSI        |EUR              |        2|         0|          0|
|NA20519     |TSI        |EUR              |        2|         0|          1|
|NA20520     |TSI        |EUR              |        2|         0|          0|
|NA20521     |TSI        |EUR              |        2|         0|          0|
|NA20522     |TSI        |EUR              |        2|         0|          0|
|NA20524     |TSI        |EUR              |        2|         0|          0|
|NA20525     |TSI        |EUR              |        2|         0|          0|
|NA20527     |TSI        |EUR              |        2|         0|          0|
|NA20528     |TSI        |EUR              |        2|         0|          0|
|NA20529     |TSI        |EUR              |        2|         0|          0|
|NA20530     |TSI        |EUR              |        2|         0|          0|
|NA20531     |TSI        |EUR              |        2|         0|          0|
|NA20532     |TSI        |EUR              |        2|         0|          0|
|NA20533     |TSI        |EUR              |        2|         0|          0|
|NA20534     |TSI        |EUR              |        2|         0|          0|
|NA20535     |TSI        |EUR              |        2|         0|          0|
|NA20536     |TSI        |EUR              |        2|         0|          0|
|NA20537     |TSI        |EUR              |        2|         0|          0|
|NA20538     |TSI        |EUR              |        2|         0|          0|
|NA20539     |TSI        |EUR              |        2|         0|          0|
|NA20540     |TSI        |EUR              |        2|         0|          0|
|NA20541     |TSI        |EUR              |        2|         1|          0|
|NA20542     |TSI        |EUR              |        2|         0|          0|
|NA20543     |TSI        |EUR              |        2|         0|          0|
|NA20544     |TSI        |EUR              |        2|         0|          0|
|NA20581     |TSI        |EUR              |        2|         0|          0|
|NA20582     |TSI        |EUR              |        2|         0|          0|
|NA20585     |TSI        |EUR              |        2|         0|          0|
|NA20586     |TSI        |EUR              |        2|         0|          0|
|NA20588     |TSI        |EUR              |        2|         0|          0|
|NA20589     |TSI        |EUR              |        2|         0|          0|
|NA20752     |TSI        |EUR              |        2|         1|          0|
|NA20753     |TSI        |EUR              |        1|         0|          0|
|NA20754     |TSI        |EUR              |        1|         0|          0|
|NA20755     |TSI        |EUR              |        2|         0|          0|
|NA20756     |TSI        |EUR              |        2|         0|          0|
|NA20757     |TSI        |EUR              |        2|         0|          0|
|NA20758     |TSI        |EUR              |        2|         0|          1|
|NA20759     |TSI        |EUR              |        2|         0|          0|
|NA20760     |TSI        |EUR              |        2|         0|          0|
|NA20761     |TSI        |EUR              |        2|         0|          0|
|NA20765     |TSI        |EUR              |        2|         0|          0|
|NA20766     |TSI        |EUR              |        2|         0|          0|
|NA20768     |TSI        |EUR              |        2|         0|          0|
|NA20769     |TSI        |EUR              |        2|         0|          0|
|NA20770     |TSI        |EUR              |        2|         0|          0|
|NA20771     |TSI        |EUR              |        2|         0|          0|
|NA20772     |TSI        |EUR              |        2|         0|          0|
|NA20773     |TSI        |EUR              |        2|         0|          0|
|NA20774     |TSI        |EUR              |        2|         0|          0|
|NA20775     |TSI        |EUR              |        2|         0|          0|
|NA20778     |TSI        |EUR              |        2|         0|          0|
|NA20783     |TSI        |EUR              |        2|         0|          0|
|NA20785     |TSI        |EUR              |        1|         0|          0|
|NA20786     |TSI        |EUR              |        2|         0|          0|
|NA20787     |TSI        |EUR              |        2|         0|          0|
|NA20790     |TSI        |EUR              |        2|         0|          0|
|NA20792     |TSI        |EUR              |        2|         0|          1|
|NA20795     |TSI        |EUR              |        1|         0|          0|
|NA20796     |TSI        |EUR              |        2|         0|          0|
|NA20797     |TSI        |EUR              |        2|         0|          0|
|NA20798     |TSI        |EUR              |        2|         0|          0|
|NA20799     |TSI        |EUR              |        2|         0|          0|
|NA20800     |TSI        |EUR              |        2|         0|          0|
|NA20801     |TSI        |EUR              |        2|         0|          0|
|NA20802     |TSI        |EUR              |        2|         0|          0|
|NA20803     |TSI        |EUR              |        2|         0|          0|
|NA20804     |TSI        |EUR              |        2|         0|          0|
|NA20805     |TSI        |EUR              |        2|         0|          0|
|NA20806     |TSI        |EUR              |        2|         0|          0|
|NA20807     |TSI        |EUR              |        2|         0|          0|
|NA20808     |TSI        |EUR              |        2|         0|          0|
|NA20809     |TSI        |EUR              |        2|         0|          0|
|NA20810     |TSI        |EUR              |        2|         1|          0|
|NA20811     |TSI        |EUR              |        2|         0|          0|
|NA20812     |TSI        |EUR              |        2|         0|          0|
|NA20813     |TSI        |EUR              |        2|         0|          0|
|NA20814     |TSI        |EUR              |        2|         0|          0|
|NA20815     |TSI        |EUR              |        2|         0|          0|
|NA20816     |TSI        |EUR              |        2|         0|          0|
|NA20818     |TSI        |EUR              |        2|         0|          0|
|NA20819     |TSI        |EUR              |        2|         0|          0|
|NA20826     |TSI        |EUR              |        2|         0|          0|
|NA20828     |TSI        |EUR              |        2|         0|          0|

Motivating Example
===================

Each of the `rsXXXX` columns corresponds to a SNP (location in the human genome that varies across populations). These are fairly well annotated, e.g, [http://snpedia.com/index.php/rs1799971](http://snpedia.com/index.php/rs1799971)

- The vast majority (about 80%) of people in the world inherited an `A` from both mother and father in this location of their genome. We say they have the `A/A` allele.
- Other people have a different allele, `A/G` or `G/G`, meaning they inherited a mutation (`G` instead of `A`) from either mother or father (in the first case) or both (in the second case).
- These two rare alleles have been associated with increased susceptibility to alcoholism.

Motivating Example
===================


```r
table(filtered_geno_data$rs1799971)
```

```

  0   1   2 
733 305  55 
```

In this dataset:
  - 733 individuals have the `A/A` allele (coded as `0`) 
  - 305 have the `A/G` allele (coded as `1`)
  - 55 have the `G/G` allele (coded as `2`)

Motivating Example
===================

All SNPs are coded the same way:

- `0`: they have the most frequent allele
- `1`: they inherited one copy of the mutation
- `2`: they inherited two copies of the mutation

We want to visualize this data for 4k variables!

Principal Component Analysis
=============================

A dimensionality reduction method: _embed data in high dimensional space to small number of dimensions we can visualize_

Given: 
 - Data set $\{\mathbf{x}_1, \mathbf{x}_2, \ldots, \mathbf{x}_n\}$, where $\mathbf{x}_i$ is the vector
of $p$ predictor values for the $i$-th observation. 

Return: 
  - Matrix $\left[ \phi_1, \phi_2, \ldots, \phi_p \right]$ of linear transformations that retain maximal variance.

Principal Component Analysis
=============================

The first transformation $\phi_1$ defines an embedding of the data into 1 dimension:

$$
Z_1 = \phi_{11}X_1 + \phi_{21} X_2 + \cdots + \phi_{p1} X_p
$$

where $\phi_1$ is selected so that the resulting dataset $\{ z_1, \ldots, z_n\}$ has _maximum variance_.

Note: in order for this to make sense:
 - data has to be centered, i.e., each $X_j$ has mean equal to zero
 - $\phi_1$ has to be normalized, i.e., $\sum_{j=1}^p \phi_{j1}^2=1$.


Principal Component Analysis
==============================

We can find $\phi_1$ by (surprise!) solving an optimization problem:

$$
\max_{\phi{11},\phi_{21},\ldots,\phi_{p1}}
\left\{ \frac{1}{n} \sum_{i=1}^n \left( \sum_{j=1}^p \phi_{j1} x_{ij} \right)^2 \right\} \\

\mathrm{s.t.} \sum_{j=1}^p \phi_{j1}^2 = 1
$$

_maximize variance_  
_subject to normalization constraint_

Principal Component Analysis
=================================

The second transformation $\phi_2$ is obtained next solving a similar problem with the added constraint that $\phi_2$ **is orthogonal** to $\phi_1$.

Taken together $\left[ \phi_1, \phi_2 \right]$ define a linear transformation of the data into 2 dimensional space.

$$
Z_{n\times 2} = X_{n \times p} \left[ \phi_1, \phi_2 \right]_{p \times 2}
$$

Example
========




|         PC1|         PC2|          PC3|sample_name |population |super_population |
|-----------:|-----------:|------------:|:-----------|:----------|:----------------|
|  -2.2208565|  13.8176265| -193.8613921|perfect     |OPT        |OPT              |
|  -6.0347539|  15.9403862|   -0.5350849|HG00096     |GBR        |EUR              |
|  -6.3073032|  14.7981564|   -1.0284508|HG00097     |GBR        |EUR              |
|  -7.0990373|  15.8130059|   -4.3762353|HG00099     |GBR        |EUR              |
|  -6.0040517|  17.2891462|   -0.3868090|HG00100     |GBR        |EUR              |
|  -7.5450341|  15.6152855|    1.1672255|HG00101     |GBR        |EUR              |
|  -6.4197360|  15.6946764|   -1.5019768|HG00102     |GBR        |EUR              |
|  -7.5458569|  17.8092027|    0.6258870|HG00103     |GBR        |EUR              |
|  -8.7018790|  15.3298474|    1.1435243|HG00104     |GBR        |EUR              |
|  -7.1949619|  15.1391491|   -0.4699450|HG00106     |GBR        |EUR              |
|  -7.9107437|  15.0045462|    0.4331865|HG00108     |GBR        |EUR              |
|  -6.1616722|  16.6915006|   -0.8094868|HG00109     |GBR        |EUR              |
|  -6.1296549|  15.8388315|   -0.5712044|HG00110     |GBR        |EUR              |
|  -5.7334983|  16.2146995|    0.5338058|HG00111     |GBR        |EUR              |
|  -5.3251210|  15.8221252|    1.1734587|HG00112     |GBR        |EUR              |
|  -6.8994996|  16.9807783|   -0.0411114|HG00113     |GBR        |EUR              |
|  -5.8559391|  17.1649051|   -1.2622634|HG00114     |GBR        |EUR              |
|  -6.9187579|  15.2973928|   -1.6379451|HG00116     |GBR        |EUR              |
|  -6.3709576|  15.2237214|   -2.2163053|HG00117     |GBR        |EUR              |
|  -6.9985318|  16.1794020|   -2.2201225|HG00118     |GBR        |EUR              |
|  -6.0821685|  14.7640170|    1.7714204|HG00119     |GBR        |EUR              |
|  -6.5373000|  18.0062182|   -0.6194924|HG00120     |GBR        |EUR              |
|  -8.9105164|  17.3251865|   -1.4989355|HG00121     |GBR        |EUR              |
|  -5.2544721|  17.2651001|   -0.1503810|HG00122     |GBR        |EUR              |
|  -7.5618397|  16.8264516|    1.7197816|HG00123     |GBR        |EUR              |
|  -6.8649617|  16.0506960|   -0.1413351|HG00124     |GBR        |EUR              |
|  -7.5180256|  18.0683275|    1.0706060|HG00125     |GBR        |EUR              |
|  -7.4558952|  15.3720534|    1.4831357|HG00126     |GBR        |EUR              |
|  -6.3914232|  16.3205844|    0.5178408|HG00127     |GBR        |EUR              |
|  -6.7127980|  15.8429078|   -0.4436025|HG00128     |GBR        |EUR              |
|  -5.9761455|  16.3071049|    1.4072602|HG00129     |GBR        |EUR              |
|  -7.5299979|  17.7564941|    0.7044037|HG00130     |GBR        |EUR              |
|  -4.4663982|  15.2144719|    0.5924722|HG00131     |GBR        |EUR              |
|  -7.4001402|  15.5529656|    0.0048779|HG00133     |GBR        |EUR              |
|  -7.2583722|  18.1385170|    0.8462992|HG00134     |GBR        |EUR              |
|  -7.2477491|  16.3300704|   -3.3506454|HG00135     |GBR        |EUR              |
|  -6.4341993|  17.1316203|    1.9440042|HG00136     |GBR        |EUR              |
|  -6.5738172|  18.4196554|    0.1170337|HG00137     |GBR        |EUR              |
|  -6.3443361|  15.9863325|    1.5742434|HG00138     |GBR        |EUR              |
|  -6.3902423|  16.5120599|    1.6000240|HG00139     |GBR        |EUR              |
|  -6.2369721|  17.2207906|   -0.5736278|HG00140     |GBR        |EUR              |
|  -6.6389429|  16.2254910|    0.7327638|HG00141     |GBR        |EUR              |
|  -6.4031976|  16.8760205|    1.8019924|HG00142     |GBR        |EUR              |
|  -6.5891360|  16.6739380|   -2.4542881|HG00143     |GBR        |EUR              |
|  -8.4072886|  15.8502403|    0.4281209|HG00146     |GBR        |EUR              |
|  -8.6503067|  14.7965163|   -0.9602582|HG00148     |GBR        |EUR              |
|  -5.9304090|  15.3432724|    0.9210311|HG00149     |GBR        |EUR              |
|  -6.5876691|  15.9045458|    1.3949666|HG00150     |GBR        |EUR              |
|  -7.5629400|  17.0328338|   -2.0045639|HG00151     |GBR        |EUR              |
|  -7.2554214|  14.3332812|    0.0985631|HG00152     |GBR        |EUR              |
|  -8.1279745|  16.2898170|    1.0112577|HG00154     |GBR        |EUR              |
|  -6.7980327|  15.7881423|    0.7607306|HG00155     |GBR        |EUR              |
|  -8.7421661|  15.4181803|    0.4016788|HG00156     |GBR        |EUR              |
|  -6.0827366|  15.6278083|   -0.5352002|HG00158     |GBR        |EUR              |
|  -6.8825283|  15.7627287|   -0.9951588|HG00159     |GBR        |EUR              |
|  -5.8603129|  16.2620658|    0.5815559|HG00160     |GBR        |EUR              |
|  -8.7232461|  12.8958590|   -0.6382736|HG00171     |FIN        |EUR              |
|  -8.2932809|  13.9599475|   -0.0132231|HG00173     |FIN        |EUR              |
|  -7.8273161|  13.1750637|    0.3408719|HG00174     |FIN        |EUR              |
|  -6.7150533|  11.4977541|    1.3425246|HG00176     |FIN        |EUR              |
|  -8.3795287|  13.4643927|   -1.0619257|HG00177     |FIN        |EUR              |
|  -7.1115325|  15.6844488|   -0.6084834|HG00178     |FIN        |EUR              |
|  -7.1347354|  14.9278768|   -0.6778147|HG00179     |FIN        |EUR              |
|  -7.7654088|  14.4332265|    0.7176380|HG00180     |FIN        |EUR              |
|  -6.6602331|  14.7401086|    1.8060399|HG00182     |FIN        |EUR              |
|  -8.7837025|  13.7115701|    1.0140190|HG00183     |FIN        |EUR              |
|  -8.7080462|  12.1964631|    1.2521440|HG00185     |FIN        |EUR              |
|  -8.5135776|  13.9008557|    0.2954825|HG00186     |FIN        |EUR              |
|  -7.3756625|  12.5992995|    1.0441628|HG00187     |FIN        |EUR              |
|  -8.5409675|  14.9724848|   -0.6831062|HG00188     |FIN        |EUR              |
|  -7.8491840|  15.9036990|   -5.0556662|HG00189     |FIN        |EUR              |
|  -7.9661363|  13.8320384|    1.2758875|HG00190     |FIN        |EUR              |
|  -7.7247428|  16.7985375|    2.0037808|HG00231     |GBR        |EUR              |
|  -7.1760306|  16.2352422|   -1.5874123|HG00232     |GBR        |EUR              |
|  -6.0896371|  17.4018956|    0.3838246|HG00233     |GBR        |EUR              |
|  -7.0541894|  15.7198674|    1.1433786|HG00234     |GBR        |EUR              |
|  -7.4417945|  17.6385560|   -0.4323714|HG00235     |GBR        |EUR              |
|  -7.1123652|  17.0046944|   -2.4268880|HG00236     |GBR        |EUR              |
|  -5.8029239|  14.7627753|    0.7518789|HG00237     |GBR        |EUR              |
|  -7.6649103|  15.0456941|    1.4107734|HG00238     |GBR        |EUR              |
|  -6.8312457|  17.0554804|   -0.2503806|HG00239     |GBR        |EUR              |
|  -5.4992688|  17.9608814|    1.2714956|HG00240     |GBR        |EUR              |
|  -8.1326742|  15.9099201|    1.1780240|HG00242     |GBR        |EUR              |
|  -7.4341178|  17.4281106|    0.5796553|HG00243     |GBR        |EUR              |
|  -7.3287799|  15.7660257|    0.0676622|HG00244     |GBR        |EUR              |
|  -7.9601079|  14.5881242|   -0.8313176|HG00245     |GBR        |EUR              |
|  -6.9419727|  15.3983231|    0.8699516|HG00246     |GBR        |EUR              |
|  -5.9964865|  15.5137185|   -0.0643370|HG00247     |GBR        |EUR              |
|  -6.2210548|  15.0005429|   -0.6531322|HG00249     |GBR        |EUR              |
|  -6.9692357|  17.5524584|    0.7374051|HG00250     |GBR        |EUR              |
|  -7.4074282|  16.2338840|   -0.1890375|HG00251     |GBR        |EUR              |
|  -7.8277924|  18.1266755|    1.3355497|HG00252     |GBR        |EUR              |
|  -7.9548160|  15.0553661|   -0.3405645|HG00253     |GBR        |EUR              |
|  -6.7322189|  14.8947751|    0.0536518|HG00254     |GBR        |EUR              |
|  -7.2604565|  14.2091168|    0.0343668|HG00255     |GBR        |EUR              |
|  -4.7317902|  17.9168062|   -0.2347950|HG00256     |GBR        |EUR              |
|  -7.7990138|  17.5481245|    0.0409061|HG00257     |GBR        |EUR              |
|  -7.7076991|  16.5508885|   -1.9770344|HG00258     |GBR        |EUR              |
|  -5.6014813|  14.4878316|    0.5357614|HG00259     |GBR        |EUR              |
|  -5.4768538|  16.6816595|    1.5554006|HG00260     |GBR        |EUR              |
|  -6.6973940|  15.2521262|    0.8300258|HG00261     |GBR        |EUR              |
|  -6.9291482|  16.1367762|    0.0037491|HG00262     |GBR        |EUR              |
|  -5.6404277|  14.5535361|   -2.5733548|HG00263     |GBR        |EUR              |
|  -8.4701461|  19.4483464|    1.7442836|HG00264     |GBR        |EUR              |
|  -7.8241922|  18.1722885|   -4.7293582|HG00265     |GBR        |EUR              |
|  -5.9868655|  14.8693438|   -5.2032716|HG00266     |FIN        |EUR              |
|  -7.6560650|  15.0999757|    0.8474563|HG00267     |FIN        |EUR              |
|  -7.7201175|  14.3572942|   -0.4256234|HG00268     |FIN        |EUR              |
|  -9.2233887|  12.4839370|    0.3232027|HG00269     |FIN        |EUR              |
|  -8.9391337|  16.3494798|    0.4279745|HG00270     |FIN        |EUR              |
|  -7.4936752|  14.7801082|    1.0823142|HG00271     |FIN        |EUR              |
|  -5.9504875|  12.6888478|    0.3015856|HG00272     |FIN        |EUR              |
|  -7.4558819|  12.0612542|   -0.8146424|HG00273     |FIN        |EUR              |
|  -8.6707510|  14.4156186|    1.5317661|HG00274     |FIN        |EUR              |
|  -7.9039820|  14.5681405|   -1.2430591|HG00275     |FIN        |EUR              |
|  -6.5341244|  13.9635631|    0.6755945|HG00276     |FIN        |EUR              |
|  -7.4217730|  14.5140927|   -1.3655717|HG00277     |FIN        |EUR              |
|  -8.8173293|  13.2192705|    0.2229023|HG00278     |FIN        |EUR              |
|  -6.7323713|  14.6159849|    0.2322264|HG00280     |FIN        |EUR              |
|  -6.7773127|  13.0589991|    0.7821623|HG00281     |FIN        |EUR              |
|  -8.2125631|  13.7680977|   -1.2672185|HG00282     |FIN        |EUR              |
|  -8.1813603|  16.4540796|    0.2014617|HG00284     |FIN        |EUR              |
|  -8.1328030|  12.6050728|   -0.7130001|HG00285     |FIN        |EUR              |
|  -7.0485297|  13.7856250|    0.1866179|HG00306     |FIN        |EUR              |
|  -7.1827114|  12.7772922|    0.0111028|HG00309     |FIN        |EUR              |
|  -7.0735428|  13.1955822|   -0.5676217|HG00310     |FIN        |EUR              |
|  -8.5287769|  15.6380550|   -0.8424340|HG00311     |FIN        |EUR              |
|  -7.7536969|  15.3347713|    1.5902645|HG00312     |FIN        |EUR              |
|  -7.7204028|  13.9610568|   -0.2972096|HG00313     |FIN        |EUR              |
|  -7.6908005|  13.8222606|   -0.0935646|HG00315     |FIN        |EUR              |
|  -8.2093656|  15.4436835|   -0.9567626|HG00318     |FIN        |EUR              |
|  -7.8571071|  13.0972789|    0.1234988|HG00319     |FIN        |EUR              |
|  -7.3567046|  13.7688571|    1.6459207|HG00320     |FIN        |EUR              |
|  -7.4679333|  14.1558629|    0.0407005|HG00321     |FIN        |EUR              |
|  -6.5595931|  10.9578603|    0.5933484|HG00323     |FIN        |EUR              |
|  -5.7878176|  13.1128383|    0.0949028|HG00324     |FIN        |EUR              |
|  -6.6858849|  13.2568993|   -0.4271999|HG00325     |FIN        |EUR              |
|  -8.3599496|  14.8714822|    0.3229922|HG00326     |FIN        |EUR              |
|  -7.5788888|  12.9638417|   -0.9035836|HG00327     |FIN        |EUR              |
|  -7.2250128|  14.4420200|    1.1985765|HG00328     |FIN        |EUR              |
|  -7.4865991|  13.7954747|   -1.4483257|HG00329     |FIN        |EUR              |
|  -6.3995319|  12.4229901|    1.4344635|HG00330     |FIN        |EUR              |
|  -6.7496045|  11.6262593|    1.6837153|HG00331     |FIN        |EUR              |
|  -7.1204919|  13.9925793|   -0.1317877|HG00332     |FIN        |EUR              |
|  -5.8143566|  14.2658233|    0.7543248|HG00334     |FIN        |EUR              |
|  -7.4384172|  13.9886385|    1.1380384|HG00335     |FIN        |EUR              |
|  -7.7656341|  13.9236560|    0.2624797|HG00336     |FIN        |EUR              |
|  -7.3625807|  15.6502669|   -3.3499715|HG00337     |FIN        |EUR              |
|  -7.8075409|  14.9211746|    0.2624426|HG00338     |FIN        |EUR              |
|  -9.0990543|  11.9087907|    0.8001511|HG00339     |FIN        |EUR              |
|  -5.1887389|  13.8203721|   -0.0417892|HG00341     |FIN        |EUR              |
|  -9.5546683|  13.0727179|    0.1798662|HG00342     |FIN        |EUR              |
|  -7.8985056|  14.3813752|    0.4333265|HG00343     |FIN        |EUR              |
|  -7.4382341|  15.9259820|   -1.8649253|HG00344     |FIN        |EUR              |
|  -5.5888660|  13.7960737|   -0.6106909|HG00345     |FIN        |EUR              |
|  -7.6280600|  13.1787209|    0.8611122|HG00346     |FIN        |EUR              |
|  -8.5742329|  14.3505350|    0.0577257|HG00349     |FIN        |EUR              |
|  -6.6195817|  13.1060983|    1.3471083|HG00350     |FIN        |EUR              |
|  -7.7816783|  13.3904063|   -0.6607824|HG00351     |FIN        |EUR              |
|  -7.9997776|  12.8908717|    0.7437938|HG00353     |FIN        |EUR              |
|  -8.9856127|  14.9678611|    0.3957203|HG00355     |FIN        |EUR              |
|  -8.3045811|  13.9510373|   -0.8714756|HG00356     |FIN        |EUR              |
|  -7.7497171|  14.6108605|    0.4021803|HG00357     |FIN        |EUR              |
|  -7.7159074|  15.5624459|    0.6052996|HG00358     |FIN        |EUR              |
|  -6.2221013|  13.6317980|    0.0855373|HG00359     |FIN        |EUR              |
|  -7.7908568|  15.6872220|   -0.1834357|HG00360     |FIN        |EUR              |
|  -7.6269100|  12.4122050|   -0.5132772|HG00361     |FIN        |EUR              |
|  -7.5237165|  13.3171441|    1.6142230|HG00362     |FIN        |EUR              |
|  -6.6169599|  14.8812879|   -0.6120535|HG00364     |FIN        |EUR              |
|  -8.1436704|  14.7888374|    0.2449181|HG00366     |FIN        |EUR              |
|  -6.5011446|  12.3718055|    0.3063034|HG00367     |FIN        |EUR              |
|  -7.9119649|  13.7049446|    0.8444334|HG00369     |FIN        |EUR              |
|  -7.3255748|  16.6212042|    0.5591061|HG00372     |FIN        |EUR              |
|  -7.2597681|  12.5130243|    1.6145835|HG00373     |FIN        |EUR              |
|  -8.6499219|  13.5918659|   -3.4826139|HG00375     |FIN        |EUR              |
|  -7.1120699|  12.9463651|    1.1304368|HG00376     |FIN        |EUR              |
|  -8.1754141|  11.5643721|    1.4015777|HG00377     |FIN        |EUR              |
|  -7.5880891|  12.0287686|    0.0961010|HG00378     |FIN        |EUR              |
|  -7.2191425|  14.9420364|   -0.1868162|HG00381     |FIN        |EUR              |
|  -8.6193338|  14.6616133|   -2.5815179|HG00382     |FIN        |EUR              |
|  -7.6749151|  14.6519620|    0.7057080|HG00383     |FIN        |EUR              |
|  -7.5946158|  13.6842351|    0.6601697|HG00384     |FIN        |EUR              |
| -13.4097774| -21.0829036|   -0.2070773|HG00403     |CHS        |EAS              |
| -12.4289450| -19.1645383|    0.4208828|HG00404     |CHS        |EAS              |
| -13.6376500| -20.1335056|   -0.5444114|HG00406     |CHS        |EAS              |
| -13.4393501| -21.0704226|   -0.2159442|HG00407     |CHS        |EAS              |
| -13.8699524| -20.8196206|    0.4224481|HG00418     |CHS        |EAS              |
| -14.4129320| -19.9426095|   -0.2902450|HG00419     |CHS        |EAS              |
| -12.7838550| -19.9280525|   -0.0922179|HG00421     |CHS        |EAS              |
| -13.4960533| -19.5159655|    0.3679487|HG00422     |CHS        |EAS              |
| -12.8347696| -20.8031148|   -0.0585338|HG00427     |CHS        |EAS              |
| -14.4720261| -21.3476466|    0.2578076|HG00428     |CHS        |EAS              |
| -14.5179905| -23.0957057|   -1.3635185|HG00436     |CHS        |EAS              |
| -12.7684106| -20.6813624|   -0.9697190|HG00437     |CHS        |EAS              |
| -12.5263689| -18.2916136|   -0.7176749|HG00442     |CHS        |EAS              |
| -13.5134623| -21.1187775|    0.3012710|HG00443     |CHS        |EAS              |
| -12.5059024| -17.3105500|   -1.1659814|HG00445     |CHS        |EAS              |
| -14.6389625| -19.2164926|   -0.3753611|HG00446     |CHS        |EAS              |
| -13.0106658| -19.3735493|    0.3604810|HG00448     |CHS        |EAS              |
| -13.9997050| -19.3812865|    0.1152197|HG00449     |CHS        |EAS              |
| -13.3032765| -20.3888505|    0.2110232|HG00451     |CHS        |EAS              |
| -15.6007319| -23.9881721|   -0.1695112|HG00452     |CHS        |EAS              |
| -13.5865328| -17.9518768|   -0.3649474|HG00457     |CHS        |EAS              |
| -13.3814089| -19.9777913|    0.5637039|HG00458     |CHS        |EAS              |
| -14.8388294| -21.4566884|    0.3233735|HG00463     |CHS        |EAS              |
| -14.1174309| -23.8460952|   -0.5113499|HG00464     |CHS        |EAS              |
| -14.7029610| -23.2793100|    1.1962380|HG00472     |CHS        |EAS              |
| -13.8543302| -20.5764418|    0.3122069|HG00473     |CHS        |EAS              |
| -13.8448683| -20.4847709|   -0.0612190|HG00475     |CHS        |EAS              |
| -13.6442885| -19.4821357|   -1.1561509|HG00476     |CHS        |EAS              |
| -13.8620620| -21.4786190|   -2.2782141|HG00478     |CHS        |EAS              |
| -12.2681111| -19.7029952|   -0.1542955|HG00479     |CHS        |EAS              |
| -15.2495536| -20.6837262|   -0.7335172|HG00500     |CHS        |EAS              |
| -14.0640808| -20.9847108|    0.5104539|HG00501     |CHS        |EAS              |
| -13.0828996| -23.0025930|   -0.0223092|HG00512     |CHS        |EAS              |
| -14.3741441| -21.7629964|   -0.6724490|HG00513     |CHS        |EAS              |
| -15.2930651| -22.9725301|    0.1067816|HG00524     |CHS        |EAS              |
| -14.2269736| -19.3609466|   -0.9064676|HG00525     |CHS        |EAS              |
| -12.1913073| -18.9653004|   -0.9480591|HG00530     |CHS        |EAS              |
| -13.5234891| -21.1572948|    0.6623750|HG00531     |CHS        |EAS              |
| -13.6393416| -19.2529714|   -1.8632049|HG00533     |CHS        |EAS              |
| -15.1260933| -22.8763375|    0.8398316|HG00534     |CHS        |EAS              |
| -15.4604570| -20.8614436|    0.7352380|HG00536     |CHS        |EAS              |
| -13.0378728| -21.1285383|   -0.6766213|HG00537     |CHS        |EAS              |
| -15.6526042| -21.9489715|   -0.5244565|HG00542     |CHS        |EAS              |
| -13.3951459| -18.1309110|    0.9725926|HG00543     |CHS        |EAS              |
|   0.9372767|   4.9645380|    1.4515054|HG00553     |PUR        |AMR              |
|  -2.5709898|   8.6546119|    2.0587591|HG00554     |PUR        |AMR              |
| -14.0015211| -21.1570294|   -1.7036084|HG00556     |CHS        |EAS              |
| -14.1570124| -19.2252776|   -0.3033445|HG00557     |CHS        |EAS              |
| -13.3336779| -20.4697877|    0.1235487|HG00559     |CHS        |EAS              |
| -14.1691720| -18.9817311|   -0.1929645|HG00560     |CHS        |EAS              |
| -13.1909887| -20.3271178|   -1.9260985|HG00565     |CHS        |EAS              |
| -14.6955694| -21.3691580|    0.0236544|HG00566     |CHS        |EAS              |
| -14.2922569| -19.2056507|   -2.5786454|HG00577     |CHS        |EAS              |
| -14.0918812| -19.3594028|    0.0483017|HG00578     |CHS        |EAS              |
| -13.0634603| -22.9418100|   -0.2697827|HG00580     |CHS        |EAS              |
| -14.4987250| -21.6988336|    0.2343712|HG00581     |CHS        |EAS              |
| -15.0382157| -22.5907922|   -0.2092199|HG00583     |CHS        |EAS              |
| -13.5027639| -19.3518516|   -1.9508120|HG00584     |CHS        |EAS              |
| -14.2822566| -19.8239795|   -0.7134912|HG00589     |CHS        |EAS              |
| -13.5833160| -20.2266977|    0.3029759|HG00590     |CHS        |EAS              |
| -14.3999338| -19.8592393|   -0.6564531|HG00592     |CHS        |EAS              |
| -15.7170775| -23.0775760|    0.9081076|HG00593     |CHS        |EAS              |
| -15.0659787| -19.0334792|   -0.7912393|HG00595     |CHS        |EAS              |
| -14.2366241| -19.7478815|   -0.7583013|HG00596     |CHS        |EAS              |
| -13.6055645| -19.0068603|   -0.0803551|HG00607     |CHS        |EAS              |
| -14.1175936| -20.1410874|   -1.0231548|HG00608     |CHS        |EAS              |
| -15.1297342| -20.2110776|    0.1805527|HG00610     |CHS        |EAS              |
| -12.7021757| -18.7440646|   -0.1377485|HG00611     |CHS        |EAS              |
| -14.7372185| -22.6668383|   -0.3122288|HG00613     |CHS        |EAS              |
| -13.5724144| -20.0750397|    0.3604451|HG00614     |CHS        |EAS              |
| -12.2017469| -17.7953069|   -1.2213017|HG00619     |CHS        |EAS              |
| -13.9384900| -21.8607588|    1.1041119|HG00620     |CHS        |EAS              |
| -14.6203074| -22.0044114|    0.5127043|HG00625     |CHS        |EAS              |
| -15.9164296| -21.2146509|   -1.6171560|HG00626     |CHS        |EAS              |
| -12.7677556| -21.9187442|   -1.5407361|HG00628     |CHS        |EAS              |
| -14.9365719| -19.5249248|    0.3937843|HG00629     |CHS        |EAS              |
| -14.9363464| -20.7686165|   -1.1819486|HG00634     |CHS        |EAS              |
| -14.6350297| -21.0360593|   -0.3068347|HG00635     |CHS        |EAS              |
|  -0.7849133|   8.4622242|    2.0907971|HG00637     |PUR        |AMR              |
|   0.7320360|   8.2471311|    1.6619638|HG00638     |PUR        |AMR              |
|  -3.0974244|  12.1915238|   -0.0441656|HG00640     |PUR        |AMR              |
|  -3.7456993|  11.0365617|   -1.8243894|HG00641     |PUR        |AMR              |
| -14.4328047| -21.1789534|   -1.1308509|HG00650     |CHS        |EAS              |
| -14.5300888| -22.4560872|    0.5187298|HG00651     |CHS        |EAS              |
| -12.8136809| -19.4136245|   -0.1370894|HG00653     |CHS        |EAS              |
| -13.9145316| -20.4732807|   -1.1394986|HG00654     |CHS        |EAS              |
| -13.5866345| -19.7915721|   -0.1420147|HG00656     |CHS        |EAS              |
| -13.4599277| -21.0817021|    0.3754589|HG00657     |CHS        |EAS              |
| -12.5441438| -20.1542265|   -0.8439716|HG00662     |CHS        |EAS              |
| -15.1872853| -18.3683532|   -0.3674110|HG00663     |CHS        |EAS              |
| -15.7474043| -21.6195652|   -1.8192318|HG00671     |CHS        |EAS              |
| -13.6023461| -18.6521797|    0.3142475|HG00672     |CHS        |EAS              |
| -12.7980206| -18.4655121|   -0.6740443|HG00683     |CHS        |EAS              |
| -15.8477709| -22.7714134|    0.0788578|HG00684     |CHS        |EAS              |
| -16.5661129| -22.6743934|   -1.5072104|HG00689     |CHS        |EAS              |
| -14.4999895| -20.1117072|   -1.5805178|HG00690     |CHS        |EAS              |
| -12.2642285| -17.9997678|    0.6071423|HG00692     |CHS        |EAS              |
| -15.1895070| -21.2776451|   -1.1135779|HG00693     |CHS        |EAS              |
| -13.1348755| -19.1515626|    0.0544923|HG00698     |CHS        |EAS              |
| -12.5215815| -20.1887290|    0.5689617|HG00699     |CHS        |EAS              |
| -12.5782425| -18.4221592|    0.5777015|HG00701     |CHS        |EAS              |
| -13.4504582| -19.6377702|   -0.0665851|HG00702     |CHS        |EAS              |
| -14.5258406| -21.6030452|    0.4688361|HG00704     |CHS        |EAS              |
| -12.8024012| -21.9172137|   -0.2482208|HG00705     |CHS        |EAS              |
| -15.8673089| -22.2427219|   -0.5921253|HG00707     |CHS        |EAS              |
| -12.4252886| -17.7011459|   -0.0952767|HG00708     |CHS        |EAS              |
|  -5.1504549|  13.6902871|    1.3446359|HG00731     |PUR        |AMR              |
|  -3.8089616|  10.0910021|    1.5759163|HG00732     |PUR        |AMR              |
|  -4.6820850|   9.3961718|   -1.3330701|HG00734     |PUR        |AMR              |
|  -4.3944719|  10.2708661|   -0.4993973|HG00736     |PUR        |AMR              |
|  -2.2381071|  14.0684007|    0.6692495|HG00737     |PUR        |AMR              |
|  -4.9739664|   9.7031298|    1.4112322|HG00740     |PUR        |AMR              |
|  -2.8410454|  10.9121586|    0.2750757|HG01047     |PUR        |AMR              |
|  -4.1072337|   8.5799591|   -0.4904094|HG01048     |PUR        |AMR              |
|   0.7201065|   5.6989576|    1.1803484|HG01051     |PUR        |AMR              |
|   0.8301774|   4.7577662|    1.2224180|HG01052     |PUR        |AMR              |
|  -0.2142053|  11.5333399|    1.4963936|HG01055     |PUR        |AMR              |
|  -3.2820619|  10.4968375|    1.5203538|HG01060     |PUR        |AMR              |
|  -4.1232601|  11.5400370|    0.3647508|HG01061     |PUR        |AMR              |
|  -5.6304194|  12.9315164|    3.2168374|HG01066     |PUR        |AMR              |
|  -4.0608554|  10.0807691|   -1.8907434|HG01067     |PUR        |AMR              |
|  -3.9262264|  10.2728894|   -0.6375339|HG01069     |PUR        |AMR              |
|  -6.9340235|  11.9106521|   -4.3516748|HG01070     |PUR        |AMR              |
|  -3.1397887|  12.2373291|    1.6343362|HG01072     |PUR        |AMR              |
|  -3.8247768|  11.2939216|    0.4070119|HG01073     |PUR        |AMR              |
|  -1.5031543|  12.8166617|    0.3443394|HG01075     |PUR        |AMR              |
|  -0.9100095|   9.8255788|    1.5395281|HG01079     |PUR        |AMR              |
|  -3.4007488|   7.8945581|    1.3220379|HG01080     |PUR        |AMR              |
|   0.1626761|   8.3594547|    1.3894260|HG01082     |PUR        |AMR              |
|  -1.9191817|  10.2362974|    0.7107389|HG01083     |PUR        |AMR              |
|  -4.1683820|   9.6765087|    0.8911403|HG01085     |PUR        |AMR              |
|  -3.0370795|   8.8332173|    0.8453274|HG01095     |PUR        |AMR              |
|  -4.5976756|  10.3591664|    1.5263503|HG01097     |PUR        |AMR              |
|  -2.8253256|   9.6096490|   -0.2840066|HG01098     |PUR        |AMR              |
|   0.3215256|   9.0458959|    1.0416666|HG01101     |PUR        |AMR              |
|  -3.7652150|   8.0138694|    1.3300600|HG01102     |PUR        |AMR              |
|  -5.8518604|  10.6651428|    0.3083071|HG01104     |PUR        |AMR              |
|  -2.4819358|  13.2468108|    1.4505218|HG01105     |PUR        |AMR              |
|   1.6752925|   6.5126018|    0.8345567|HG01107     |PUR        |AMR              |
|  18.2257842|   0.5837786|    1.3430863|HG01108     |PUR        |AMR              |
|  -6.5353499|  12.7475243|    1.0527390|HG01112     |CLM        |AMR              |
|  -8.4689903|   6.5475902|   -0.0755298|HG01113     |CLM        |AMR              |
|  -2.9455152|   6.0725147|    1.3095184|HG01124     |CLM        |AMR              |
|  -5.3364042|   6.4055195|    2.0707027|HG01125     |CLM        |AMR              |
|  -7.0951917|  11.1555484|   -0.2252259|HG01133     |CLM        |AMR              |
|  -3.0103596|   8.6098156|    0.5437526|HG01134     |CLM        |AMR              |
|  -4.2594156|   5.1726454|    1.3387653|HG01136     |CLM        |AMR              |
|  -4.7711313|   6.6599985|   -0.1182944|HG01137     |CLM        |AMR              |
|  -4.2601790|   9.2269276|   -1.7085620|HG01140     |CLM        |AMR              |
|  -3.1352521|   7.2674214|   -0.9525189|HG01148     |CLM        |AMR              |
|  -5.6669600|   2.2015622|    1.5565531|HG01149     |CLM        |AMR              |
|   0.9581338|   6.3325747|    1.2048865|HG01167     |PUR        |AMR              |
|  -5.5000208|  13.0572649|    1.0370534|HG01168     |PUR        |AMR              |
|  -2.6328633|   8.1655803|    1.2573702|HG01170     |PUR        |AMR              |
|  -1.9160267|   9.8841805|    0.4358445|HG01171     |PUR        |AMR              |
|  -3.8350740|  12.3895501|   -1.7285249|HG01173     |PUR        |AMR              |
|  -2.9338385|  11.1302025|    1.0820709|HG01174     |PUR        |AMR              |
|  -4.0544873|  10.8314734|    0.3762535|HG01176     |PUR        |AMR              |
|  -1.8353898|   7.4587545|    1.4521737|HG01183     |PUR        |AMR              |
|   0.9235541|   5.3785311|    1.7523087|HG01187     |PUR        |AMR              |
|   0.6082656|   6.3263848|    1.4282552|HG01188     |PUR        |AMR              |
|  -1.4904384|   7.9780433|    2.2048385|HG01190     |PUR        |AMR              |
|  -2.6560957|  10.5818983|   -0.2531080|HG01191     |PUR        |AMR              |
|  -3.8019843|  11.1067168|   -1.2218727|HG01197     |PUR        |AMR              |
|  -1.1477178|   9.7850794|   -1.3880057|HG01198     |PUR        |AMR              |
|  -3.5977859|   8.3969517|    1.1559976|HG01204     |PUR        |AMR              |
|  -4.5499690|   5.2435909|    2.4855903|HG01250     |CLM        |AMR              |
|  -7.8630415|   9.0479000|    1.2528358|HG01251     |CLM        |AMR              |
|  -6.6449848|   5.9935034|    0.5466197|HG01257     |CLM        |AMR              |
|  -7.0516047|  12.0987540|   -0.4001958|HG01259     |CLM        |AMR              |
|  -5.1491662|   7.0791695|    1.5527946|HG01271     |CLM        |AMR              |
|  -0.2480395|   4.3814681|    1.3897901|HG01272     |CLM        |AMR              |
|  -7.1389887|   4.7060774|    0.0699059|HG01274     |CLM        |AMR              |
|  -7.0072624|  14.2939836|   -0.7379943|HG01275     |CLM        |AMR              |
|  -7.4442470|   7.2935122|    0.3208425|HG01277     |CLM        |AMR              |
|  -8.4462492|   8.2587097|    1.0008635|HG01278     |CLM        |AMR              |
|  -7.6046674|  15.0233859|    1.6572013|HG01334     |GBR        |EUR              |
|   5.5338582|   1.7062156|    0.9121236|HG01342     |CLM        |AMR              |
|  -6.2242476|   2.9640409|    0.2992387|HG01344     |CLM        |AMR              |
|  -5.4979582|   8.2583231|    0.5331000|HG01345     |CLM        |AMR              |
|  -5.4717231|   6.9582311|    2.1818880|HG01350     |CLM        |AMR              |
|  -5.9859821|   8.1397525|    1.8757651|HG01351     |CLM        |AMR              |
|  -5.0433668|  10.9185132|    2.2040026|HG01353     |CLM        |AMR              |
|  -5.2600643|  10.7639350|    0.8128194|HG01354     |CLM        |AMR              |
|  -5.4697378|   7.8892839|    1.7684176|HG01356     |CLM        |AMR              |
|  -6.2263916|   9.0856555|    2.0695029|HG01357     |CLM        |AMR              |
|  -5.3699479|   9.8102655|    1.8293787|HG01359     |CLM        |AMR              |
|  -4.9492546|   7.0582281|    0.8562198|HG01360     |CLM        |AMR              |
|  -4.8140369|   3.7781610|    1.8796038|HG01365     |CLM        |AMR              |
|  -3.7632143|   5.1099199|    1.7878256|HG01366     |CLM        |AMR              |
|  -6.8156920|  10.0892877|    1.6169228|HG01374     |CLM        |AMR              |
|  -1.1654404|   4.1338794|    1.1395376|HG01375     |CLM        |AMR              |
|  -3.0895221|   5.5494379|    1.3175381|HG01377     |CLM        |AMR              |
|  -5.7992484|   1.8342688|    1.4651558|HG01378     |CLM        |AMR              |
|  -6.0309011|   9.9888760|    1.4941717|HG01383     |CLM        |AMR              |
|  -3.6049813|   9.9102346|    0.6179721|HG01384     |CLM        |AMR              |
|  -5.0802138|   9.9633539|    1.8810323|HG01389     |CLM        |AMR              |
|   3.4831484|   1.0020431|   -0.0947131|HG01390     |CLM        |AMR              |
|  -6.3311066|  13.5191595|   -0.3909131|HG01437     |CLM        |AMR              |
|  -1.3126960|   8.4565739|   -2.0065117|HG01440     |CLM        |AMR              |
|  -7.8549720|   3.0779365|   -0.2197920|HG01441     |CLM        |AMR              |
|  -7.4123659|   6.6254779|    1.8425389|HG01455     |CLM        |AMR              |
|  -5.4826070|   4.5338000|    1.9902562|HG01456     |CLM        |AMR              |
|  -1.1982905|   2.8348429|    2.5393149|HG01461     |CLM        |AMR              |
|   3.2237131|   1.8480166|    0.3284978|HG01462     |CLM        |AMR              |
|  -7.2706703|  11.0005917|    1.4070467|HG01465     |CLM        |AMR              |
|  -0.0160939|   8.5415761|   -0.7710438|HG01488     |CLM        |AMR              |
|  -6.0256622|  11.2823431|    0.8673323|HG01489     |CLM        |AMR              |
|  -4.9166216|  11.9838580|    0.9172305|HG01491     |CLM        |AMR              |
|  -5.4421223|   9.7754865|    0.8516004|HG01492     |CLM        |AMR              |
|  -4.4263283|   2.8997678|    0.5596970|HG01494     |CLM        |AMR              |
|  -3.6182241|   3.5933130|    2.5399988|HG01495     |CLM        |AMR              |
|  -7.3498995|   4.9665806|    2.0982267|HG01497     |CLM        |AMR              |
|  -4.1180798|   6.3837678|    1.9885488|HG01498     |CLM        |AMR              |
|  -7.1925526|  17.2694285|   -0.3778009|HG01515     |IBS        |EUR              |
|  -4.9101325|  17.5589934|    0.4217045|HG01516     |IBS        |EUR              |
|  -6.7209840|  17.1578473|    1.4990608|HG01518     |IBS        |EUR              |
|  -7.6640063|  18.7359311|    1.8959348|HG01519     |IBS        |EUR              |
|  -6.5841104|  14.6608390|   -0.5730972|HG01521     |IBS        |EUR              |
|  -6.3562839|  15.8879251|   -1.0101626|HG01522     |IBS        |EUR              |
|  -3.8337975|  10.1038172|    0.9698563|HG01550     |CLM        |AMR              |
|   7.3108566|   2.1820506|   -0.6120113|HG01551     |CLM        |AMR              |
|  -5.3149369|  16.1418354|    1.9177113|HG01617     |IBS        |EUR              |
|  -7.8154112|  14.3734149|    1.6308962|HG01618     |IBS        |EUR              |
|  -4.9151583|  14.5267467|    0.2516304|HG01619     |IBS        |EUR              |
|  -5.1188296|  14.0261684|    2.1222140|HG01620     |IBS        |EUR              |
|  -4.6559977|  14.0253538|    0.3436610|HG01623     |IBS        |EUR              |
|  -4.1836901|  14.9032209|    0.5923176|HG01624     |IBS        |EUR              |
|  -6.2819766|  16.6617921|    0.2585138|HG01625     |IBS        |EUR              |
|  -4.3866996|  14.9785950|    0.1442965|HG01626     |IBS        |EUR              |
|  -6.0606859|  16.5039189|    1.1308728|NA06984     |CEU        |EUR              |
|  -6.8576197|  17.0303847|   -1.3508154|NA06986     |CEU        |EUR              |
|  -9.7709984|  15.3892400|    1.8851845|NA06989     |CEU        |EUR              |
|  -7.4454891|  16.3765307|   -0.9040166|NA06994     |CEU        |EUR              |
|  -5.3692601|  15.5721964|   -0.7475061|NA07000     |CEU        |EUR              |
|  -7.4415679|  15.6817559|   -0.1157574|NA07037     |CEU        |EUR              |
|  -6.4754515|  15.8428375|   -1.5490873|NA07048     |CEU        |EUR              |
|  -7.1765385|  15.9170367|    0.6454052|NA07051     |CEU        |EUR              |
|  -5.7957851|  17.8696977|   -2.1178180|NA07056     |CEU        |EUR              |
|  -5.8555275|  14.7017075|    0.8955370|NA07347     |CEU        |EUR              |
|  -6.8096812|  16.6036562|   -1.1640718|NA07357     |CEU        |EUR              |
|  -6.6119482|  17.3554440|    1.2801434|NA10847     |CEU        |EUR              |
|  -7.7146583|  19.0453650|   -1.9714399|NA10851     |CEU        |EUR              |
|  -7.1016686|  16.8780075|    1.4490635|NA11829     |CEU        |EUR              |
|  -7.9090659|  16.6335871|    0.0377192|NA11830     |CEU        |EUR              |
|  -6.4209139|  19.2305887|   -3.3452476|NA11831     |CEU        |EUR              |
|  -6.6120823|  16.7556208|    2.2926069|NA11843     |CEU        |EUR              |
|  -6.9209075|  16.0210062|   -0.0111501|NA11892     |CEU        |EUR              |
|  -7.3658692|  13.0066405|    1.7533791|NA11893     |CEU        |EUR              |
|  -4.9738996|  15.9464932|   -0.0973964|NA11894     |CEU        |EUR              |
|  -6.9335794|  14.7581264|    1.0571648|NA11919     |CEU        |EUR              |
|  -8.3991587|  16.1408153|    0.5603639|NA11920     |CEU        |EUR              |
|  -8.6375374|  14.4070357|    0.0655901|NA11930     |CEU        |EUR              |
|  -6.6542205|  17.5242387|   -0.4731547|NA11931     |CEU        |EUR              |
|  -6.1708452|  18.3482909|    1.4405093|NA11932     |CEU        |EUR              |
|  -6.3200692|  17.1179460|    1.6824075|NA11933     |CEU        |EUR              |
|  -6.7161603|  16.1347130|    0.8105531|NA11992     |CEU        |EUR              |
|  -7.0896953|  15.0824170|    0.8901168|NA11993     |CEU        |EUR              |
|  -6.6347037|  15.8242599|   -0.0031871|NA11994     |CEU        |EUR              |
|  -5.9989849|  16.8947656|    0.3498567|NA11995     |CEU        |EUR              |
|  -6.2075228|  15.0531780|    0.2324949|NA12003     |CEU        |EUR              |
|  -5.4820748|  17.4387625|   -2.2898047|NA12004     |CEU        |EUR              |
|  -6.7302158|  17.9771432|    1.1373839|NA12006     |CEU        |EUR              |
|  -6.0313474|  15.6171228|    0.9727201|NA12043     |CEU        |EUR              |
|  -6.5343121|  15.3058466|   -1.8312129|NA12044     |CEU        |EUR              |
|  -5.9879906|  15.7733563|    1.4463425|NA12045     |CEU        |EUR              |
|  -6.2811262|  16.0576041|    1.3394632|NA12046     |CEU        |EUR              |
|  -6.5750332|  18.6045368|    0.1971874|NA12058     |CEU        |EUR              |
|  -6.1029296|  15.7576715|    1.6116706|NA12144     |CEU        |EUR              |
|  -5.6297154|  15.9461512|   -2.1409717|NA12154     |CEU        |EUR              |
|  -5.3243922|  18.9030016|   -0.1354175|NA12155     |CEU        |EUR              |
|  -6.6398392|  15.9155691|    0.6254697|NA12249     |CEU        |EUR              |
|  -6.0119886|  17.1488757|    1.8649231|NA12272     |CEU        |EUR              |
|  -5.7521660|  16.0448905|    0.4228626|NA12273     |CEU        |EUR              |
|  -6.3143469|  17.4793770|   -1.0489889|NA12275     |CEU        |EUR              |
|  -6.7713049|  15.5672774|    0.0810891|NA12282     |CEU        |EUR              |
|  -6.7594433|  13.2057467|    2.1437884|NA12283     |CEU        |EUR              |
|  -6.5315865|  14.6378239|    1.9498845|NA12286     |CEU        |EUR              |
|  -7.0956338|  15.8470682|    0.9087029|NA12287     |CEU        |EUR              |
|  -5.5417768|  15.3338300|   -1.6936855|NA12340     |CEU        |EUR              |
|  -6.6419769|  14.0890015|    0.2350580|NA12341     |CEU        |EUR              |
|  -6.0859801|  18.1683985|   -2.1585782|NA12342     |CEU        |EUR              |
|  -5.3339886|  17.1233925|    0.0758773|NA12347     |CEU        |EUR              |
|  -6.1693832|  15.9815185|    1.3758763|NA12348     |CEU        |EUR              |
|  -7.6160095|  16.2472211|   -0.8533929|NA12383     |CEU        |EUR              |
|  -6.5034160|  17.5306146|    0.0294420|NA12399     |CEU        |EUR              |
|  -7.9088669|  18.4977332|    1.4445378|NA12400     |CEU        |EUR              |
|  -8.5224288|  16.5542170|   -1.2520436|NA12413     |CEU        |EUR              |
|  -6.7438441|  16.6779298|    0.3355190|NA12489     |CEU        |EUR              |
|  -6.1244773|  17.5507597|   -0.6177279|NA12546     |CEU        |EUR              |
|  -6.8476718|  16.7893276|    2.2201224|NA12716     |CEU        |EUR              |
|  -7.1086618|  16.2014653|   -1.4080263|NA12717     |CEU        |EUR              |
|  -6.8959295|  16.1467189|   -0.2874435|NA12718     |CEU        |EUR              |
|  -8.2485817|  15.6281075|    0.0653502|NA12748     |CEU        |EUR              |
|  -6.9779671|  16.4920433|    0.2919597|NA12749     |CEU        |EUR              |
|  -5.8582871|  15.4242918|   -0.6336876|NA12750     |CEU        |EUR              |
|  -6.2234839|  16.8484357|   -1.6518153|NA12751     |CEU        |EUR              |
|  -6.6544571|  17.4887813|   -1.1902652|NA12761     |CEU        |EUR              |
|  -5.4961827|  16.5938857|   -1.4183994|NA12763     |CEU        |EUR              |
|  -7.6700397|  15.4051098|    0.8445571|NA12775     |CEU        |EUR              |
|  -7.0556517|  18.3208191|   -0.6340398|NA12777     |CEU        |EUR              |
|  -4.5257554|  15.4736963|   -0.2560797|NA12778     |CEU        |EUR              |
|  -7.4888032|  14.9460673|    1.4185929|NA12812     |CEU        |EUR              |
|  -8.3653841|  16.1630927|   -2.7742647|NA12814     |CEU        |EUR              |
|  -8.1440967|  18.3771000|    0.5461377|NA12815     |CEU        |EUR              |
|  -6.2550205|  18.0571860|    0.4045150|NA12827     |CEU        |EUR              |
|  -6.8962905|  14.7260861|   -0.7692032|NA12829     |CEU        |EUR              |
|  -5.0957561|  15.6763662|   -0.0661697|NA12830     |CEU        |EUR              |
|  -7.3939066|  15.1819381|   -0.2458317|NA12842     |CEU        |EUR              |
|  -8.0346505|  16.9428749|   -1.4043237|NA12843     |CEU        |EUR              |
|  -5.8184532|  15.2145865|   -1.3871946|NA12872     |CEU        |EUR              |
|  -6.2536902|  16.1667242|   -1.4025428|NA12873     |CEU        |EUR              |
|  -7.2971447|  16.0461003|    0.6865462|NA12874     |CEU        |EUR              |
|  -7.2798186|  18.0891917|    0.2729321|NA12889     |CEU        |EUR              |
|  -7.0439133|  15.1252562|    1.2847082|NA12890     |CEU        |EUR              |
|  35.2509285|  -6.9063349|   -0.3065559|NA18486     |YRI        |AFR              |
|  31.8682146|  -5.1187276|    0.7848152|NA18487     |YRI        |AFR              |
|  32.5785962|  -5.2846057|   -2.8739883|NA18489     |YRI        |AFR              |
|  32.7595600|  -7.4933808|    0.9428611|NA18498     |YRI        |AFR              |
|  33.0714648|  -6.5304194|   -1.6067014|NA18499     |YRI        |AFR              |
|  31.6745976|  -5.8798739|   -0.4464681|NA18501     |YRI        |AFR              |
|  33.6125249|  -6.9802180|    0.0228235|NA18502     |YRI        |AFR              |
|  34.1277530|  -5.3681921|    0.2502334|NA18504     |YRI        |AFR              |
|  33.4938121|  -6.2783265|    0.5631783|NA18505     |YRI        |AFR              |
|  35.4870417|  -6.4592774|   -2.7108946|NA18507     |YRI        |AFR              |
|  33.2462982|  -5.8429967|   -0.6568689|NA18508     |YRI        |AFR              |
|  32.7703607|  -5.3791589|    0.2581085|NA18510     |YRI        |AFR              |
|  32.9309424|  -6.6452936|   -0.4424936|NA18511     |YRI        |AFR              |
|  31.6727901|  -5.9486642|    1.2366178|NA18516     |YRI        |AFR              |
|  34.9700552|  -7.0866303|    0.5655484|NA18517     |YRI        |AFR              |
|  34.6114494|  -5.0304675|    0.7772102|NA18519     |YRI        |AFR              |
|  36.7817477|  -5.7967742|   -0.1714781|NA18520     |YRI        |AFR              |
|  30.9899525|  -5.2297428|    0.2623266|NA18522     |YRI        |AFR              |
|  32.8523899|  -7.0313895|   -1.0043038|NA18523     |YRI        |AFR              |
| -13.4870990| -21.2926823|   -1.2810844|NA18525     |CHB        |EAS              |
| -13.4008447| -20.1330831|   -0.2390629|NA18526     |CHB        |EAS              |
| -12.3014061| -20.0658669|    1.0235240|NA18527     |CHB        |EAS              |
| -12.8696782| -19.7646398|   -0.6547027|NA18528     |CHB        |EAS              |
| -14.1619737| -18.3735303|   -0.8803068|NA18530     |CHB        |EAS              |
| -13.4824961| -21.2078570|    0.2559432|NA18532     |CHB        |EAS              |
| -14.5947861| -21.0560405|    0.1281093|NA18534     |CHB        |EAS              |
| -13.2543660| -19.6630476|   -0.6429860|NA18535     |CHB        |EAS              |
| -15.1450130| -18.8536916|   -1.1520518|NA18536     |CHB        |EAS              |
| -13.8318204| -23.1120046|    0.4233395|NA18537     |CHB        |EAS              |
| -12.6105062| -19.1877038|    0.4976956|NA18538     |CHB        |EAS              |
| -15.1469492| -20.1762165|   -0.2560266|NA18539     |CHB        |EAS              |
| -11.6347101| -20.5676343|   -0.4636292|NA18541     |CHB        |EAS              |
| -13.3828437| -22.6515437|    0.3454560|NA18542     |CHB        |EAS              |
| -12.7882053| -19.1764891|    0.1477414|NA18543     |CHB        |EAS              |
| -14.3366358| -19.8529167|   -1.2936820|NA18544     |CHB        |EAS              |
| -14.6397280| -21.7660752|   -2.1059232|NA18545     |CHB        |EAS              |
| -14.7985427| -20.7083980|   -0.2744072|NA18546     |CHB        |EAS              |
| -13.5018553| -20.0903131|   -0.0161060|NA18547     |CHB        |EAS              |
| -11.4555959| -18.6870633|    0.2356921|NA18548     |CHB        |EAS              |
| -13.6903169| -20.6425639|   -0.1806622|NA18549     |CHB        |EAS              |
| -13.2925284| -23.0997328|   -0.2488235|NA18550     |CHB        |EAS              |
| -13.0908179| -18.5096340|    0.1409850|NA18552     |CHB        |EAS              |
| -12.6808949| -19.4373451|   -0.5781516|NA18553     |CHB        |EAS              |
| -13.8752611| -21.9256843|   -0.7516900|NA18555     |CHB        |EAS              |
| -11.9366569| -19.6755941|    0.5681377|NA18557     |CHB        |EAS              |
| -15.2246974| -18.8592289|   -1.7452963|NA18558     |CHB        |EAS              |
| -13.7111713| -20.8095441|    0.4362712|NA18559     |CHB        |EAS              |
| -12.6495978| -20.1666223|   -0.4314305|NA18560     |CHB        |EAS              |
| -14.6795493| -19.7899804|   -0.4856060|NA18561     |CHB        |EAS              |
| -13.5436486| -21.7168994|    1.4009559|NA18562     |CHB        |EAS              |
| -11.7114319| -16.3741254|   -0.3525042|NA18563     |CHB        |EAS              |
| -12.1411134| -18.2451736|    0.5884471|NA18564     |CHB        |EAS              |
| -14.2061254| -23.1335718|    0.7393842|NA18565     |CHB        |EAS              |
| -13.8153089| -18.9582003|    0.4065556|NA18566     |CHB        |EAS              |
| -14.8242479| -20.9981215|    0.1871698|NA18567     |CHB        |EAS              |
| -11.9247476| -21.1263665|   -0.5366771|NA18570     |CHB        |EAS              |
| -12.9891825| -18.7508562|   -0.8149049|NA18571     |CHB        |EAS              |
| -14.1060963| -21.1194885|    0.5389305|NA18572     |CHB        |EAS              |
| -13.8545531| -18.3751279|    0.8863986|NA18573     |CHB        |EAS              |
| -12.0667692| -20.2255152|   -0.5074119|NA18574     |CHB        |EAS              |
| -11.8650116| -17.0989228|    0.1792525|NA18576     |CHB        |EAS              |
| -13.9772382| -21.6526951|   -0.5521359|NA18577     |CHB        |EAS              |
| -13.8119563| -20.0260974|   -1.0223289|NA18579     |CHB        |EAS              |
| -14.5947145| -19.8164179|   -0.4995073|NA18582     |CHB        |EAS              |
| -13.2398857| -17.2135201|    0.8298239|NA18592     |CHB        |EAS              |
| -14.1079846| -20.5994144|   -0.5547325|NA18593     |CHB        |EAS              |
| -15.2913339| -21.2708362|   -1.2400363|NA18595     |CHB        |EAS              |
| -13.4027952| -21.3726196|    0.4729517|NA18596     |CHB        |EAS              |
| -13.5566891| -19.7703177|    0.5549601|NA18597     |CHB        |EAS              |
| -14.5626843| -20.0738523|    0.0768776|NA18599     |CHB        |EAS              |
| -13.7662560| -21.2601222|    0.3342283|NA18602     |CHB        |EAS              |
| -13.5104197| -18.6068144|   -0.5662608|NA18603     |CHB        |EAS              |
| -14.2207168| -22.8100888|   -0.6570326|NA18605     |CHB        |EAS              |
| -15.1586966| -21.6701403|    0.1098917|NA18606     |CHB        |EAS              |
| -14.4532737| -19.0351612|   -0.8337610|NA18608     |CHB        |EAS              |
| -13.6514413| -15.5679099|   -0.1618209|NA18609     |CHB        |EAS              |
| -13.9708414| -21.9458759|    0.9945290|NA18610     |CHB        |EAS              |
| -11.6042354| -21.8300344|    0.3086347|NA18611     |CHB        |EAS              |
| -14.0806770| -20.5726443|    0.8362368|NA18612     |CHB        |EAS              |
| -15.3205911| -21.5582701|   -0.3861673|NA18613     |CHB        |EAS              |
| -12.2714184| -19.2487453|    0.4178294|NA18614     |CHB        |EAS              |
| -13.2263485| -20.1372716|    0.2423130|NA18615     |CHB        |EAS              |
| -15.4743866| -20.2666592|   -0.1086202|NA18616     |CHB        |EAS              |
| -15.2532394| -20.0143222|   -0.6010221|NA18617     |CHB        |EAS              |
| -15.2496673| -20.7853024|   -0.4152435|NA18618     |CHB        |EAS              |
| -13.7415446| -19.5965152|   -0.3866898|NA18619     |CHB        |EAS              |
| -13.3709461| -18.3195380|   -1.5557558|NA18620     |CHB        |EAS              |
| -13.6859152| -19.7571306|    0.5302649|NA18621     |CHB        |EAS              |
| -12.4793763| -22.0539785|    0.8637563|NA18622     |CHB        |EAS              |
| -14.0345873| -18.5811576|   -0.2468227|NA18623     |CHB        |EAS              |
| -13.5297053| -18.5938022|   -0.1422604|NA18624     |CHB        |EAS              |
| -13.3945972| -18.0834805|   -0.2298739|NA18626     |CHB        |EAS              |
| -12.5980222| -18.9258919|    0.1990229|NA18627     |CHB        |EAS              |
| -15.6363067| -21.1003753|    0.4697235|NA18628     |CHB        |EAS              |
| -13.9141533| -20.8426534|   -0.6674861|NA18630     |CHB        |EAS              |
| -13.5555868| -20.7774862|   -0.5309335|NA18631     |CHB        |EAS              |
| -12.6514129| -19.8701729|   -0.6864189|NA18632     |CHB        |EAS              |
| -13.1626064| -22.5111706|   -0.1653387|NA18633     |CHB        |EAS              |
| -14.5144964| -20.3869740|    0.5354025|NA18634     |CHB        |EAS              |
| -11.9116498| -18.6792813|    1.2122933|NA18635     |CHB        |EAS              |
| -13.5369017| -21.1205828|   -0.8163036|NA18636     |CHB        |EAS              |
| -13.8207998| -21.3381883|    0.3883744|NA18637     |CHB        |EAS              |
| -10.8952711| -16.9676825|   -0.1683468|NA18638     |CHB        |EAS              |
| -14.5928848| -20.4937554|   -0.0253041|NA18639     |CHB        |EAS              |
| -13.1527190| -19.2175023|   -0.2130194|NA18640     |CHB        |EAS              |
| -11.8558659| -21.4169335|   -1.2201737|NA18641     |CHB        |EAS              |
| -14.7601527| -16.4363047|   -0.9915657|NA18642     |CHB        |EAS              |
| -13.8701150| -18.8001311|    0.6184888|NA18643     |CHB        |EAS              |
| -13.5360644| -20.9429739|   -0.0234808|NA18645     |CHB        |EAS              |
| -12.9155068| -17.1793099|    0.3193630|NA18647     |CHB        |EAS              |
| -14.3346703| -19.0231854|   -1.0710608|NA18740     |CHB        |EAS              |
| -13.0125130| -18.9136426|   -1.7011890|NA18745     |CHB        |EAS              |
| -13.3902805| -20.1588454|    0.2770464|NA18747     |CHB        |EAS              |
| -13.2435512| -18.3400791|   -3.8807917|NA18748     |CHB        |EAS              |
| -15.0137365| -18.9939429|    0.5061703|NA18749     |CHB        |EAS              |
| -14.8098479| -18.1263571|   -1.2887230|NA18757     |CHB        |EAS              |
|  31.2725269|  -6.0778421|    0.7005744|NA18853     |YRI        |AFR              |
|  36.4775879|  -5.3361147|   -1.1172377|NA18856     |YRI        |AFR              |
|  32.6350909|  -5.0287078|    1.5048739|NA18858     |YRI        |AFR              |
|  33.8120521|  -5.9878303|    0.7794821|NA18861     |YRI        |AFR              |
|  32.6458742|  -5.1674620|    0.9058181|NA18867     |YRI        |AFR              |
|  34.0984288|  -4.1294876|   -0.1382140|NA18868     |YRI        |AFR              |
|  31.3808301|  -5.8623637|    0.7137351|NA18870     |YRI        |AFR              |
|  33.6679473|  -4.1877782|   -0.6886703|NA18871     |YRI        |AFR              |
|  35.0934981|  -4.9994319|    1.6087660|NA18873     |YRI        |AFR              |
|  34.3256946|  -6.0152457|   -0.9693963|NA18874     |YRI        |AFR              |
|  33.9645796|  -5.2313905|    0.6517882|NA18907     |YRI        |AFR              |
|  32.3218010|  -4.1944295|   -0.4526417|NA18908     |YRI        |AFR              |
|  33.6353649|  -6.8809057|   -0.3121344|NA18909     |YRI        |AFR              |
|  32.7881323|  -6.5255067|    1.7099378|NA18910     |YRI        |AFR              |
|  33.7873786|  -6.2406943|    1.1536251|NA18912     |YRI        |AFR              |
|  33.6192883|  -6.0441051|   -2.7445416|NA18916     |YRI        |AFR              |
|  34.2808333|  -6.2168805|    0.4562636|NA18917     |YRI        |AFR              |
|  32.8968098|  -5.0855791|   -0.1741644|NA18923     |YRI        |AFR              |
|  33.2631216|  -5.9550566|   -0.0498048|NA18924     |YRI        |AFR              |
|  34.9998087|  -6.3724358|    0.0995989|NA18933     |YRI        |AFR              |
|  35.5212833|  -7.3730138|    1.5360641|NA18934     |YRI        |AFR              |
| -12.7644796| -20.4085565|   -0.4072926|NA18939     |JPT        |EAS              |
| -12.6370777| -18.8332291|    1.3141192|NA18940     |JPT        |EAS              |
| -14.4230279| -19.6960543|   -1.5836601|NA18941     |JPT        |EAS              |
| -12.7653691| -20.2799390|    0.8462615|NA18942     |JPT        |EAS              |
| -14.4921453| -21.4612479|    0.5979516|NA18943     |JPT        |EAS              |
| -15.1319332| -19.8723999|    0.1841304|NA18944     |JPT        |EAS              |
| -12.4119112| -22.2343271|    0.5095723|NA18945     |JPT        |EAS              |
| -13.2688190| -20.9255215|   -1.6617849|NA18946     |JPT        |EAS              |
| -12.4734758| -21.7535517|   -1.1309462|NA18947     |JPT        |EAS              |
| -12.8643320| -18.6111734|   -3.0144521|NA18948     |JPT        |EAS              |
| -13.0398633| -18.5159847|   -1.5528090|NA18949     |JPT        |EAS              |
| -11.5898934| -20.6774696|   -1.5148685|NA18950     |JPT        |EAS              |
| -14.6344434| -19.7833820|   -2.8007938|NA18951     |JPT        |EAS              |
| -13.4108437| -20.4804512|    0.0384233|NA18952     |JPT        |EAS              |
| -16.0085412| -19.4516931|   -0.0265703|NA18953     |JPT        |EAS              |
| -13.6908609| -22.1358129|   -0.4095057|NA18954     |JPT        |EAS              |
| -12.3581107| -21.5022682|   -0.4950345|NA18956     |JPT        |EAS              |
| -13.7507469| -20.4873707|    0.6650368|NA18957     |JPT        |EAS              |
| -13.6615763| -20.6660391|   -0.0103260|NA18959     |JPT        |EAS              |
| -13.9064933| -19.0289444|    0.4860220|NA18960     |JPT        |EAS              |
| -13.4365701| -21.7550061|    0.9400871|NA18961     |JPT        |EAS              |
| -12.5398667| -20.6160621|   -1.2529700|NA18962     |JPT        |EAS              |
| -14.9417946| -19.9145760|   -3.6583153|NA18963     |JPT        |EAS              |
| -12.7336914| -20.1227952|   -0.0924680|NA18964     |JPT        |EAS              |
| -12.3284397| -19.2212291|    0.5845502|NA18965     |JPT        |EAS              |
| -13.0171426| -21.3591437|   -1.0240384|NA18966     |JPT        |EAS              |
| -12.7601277| -17.8259744|   -1.4572270|NA18968     |JPT        |EAS              |
| -12.3961552| -19.5783972|    0.7857432|NA18971     |JPT        |EAS              |
| -13.1955697| -20.1217530|    0.8977835|NA18973     |JPT        |EAS              |
| -13.0911803| -17.9570917|   -1.5226341|NA18974     |JPT        |EAS              |
| -14.0354977| -20.1529168|   -0.3119559|NA18975     |JPT        |EAS              |
| -14.5734683| -20.4003060|   -0.2387010|NA18976     |JPT        |EAS              |
| -14.5583784| -20.1916982|    1.2336811|NA18977     |JPT        |EAS              |
| -15.3178616| -19.6587937|   -1.0508250|NA18978     |JPT        |EAS              |
| -14.4661318| -22.6613704|   -1.7947654|NA18980     |JPT        |EAS              |
| -13.0093340| -20.5640047|    0.1138005|NA18981     |JPT        |EAS              |
| -14.9745194| -17.6143186|   -0.9348990|NA18982     |JPT        |EAS              |
| -13.7562567| -21.5598957|    0.7915459|NA18983     |JPT        |EAS              |
| -13.0917556| -23.0207868|   -0.1903242|NA18984     |JPT        |EAS              |
| -14.1078470| -23.3154778|    1.1059169|NA18985     |JPT        |EAS              |
| -14.4704794| -20.8748889|   -0.4747579|NA18986     |JPT        |EAS              |
| -13.5008545| -20.2389596|    0.7069580|NA18987     |JPT        |EAS              |
| -14.0934526| -19.9951962|   -1.1595939|NA18988     |JPT        |EAS              |
| -14.4986479| -21.3658554|    0.7265994|NA18989     |JPT        |EAS              |
| -13.6689245| -21.8499666|   -0.0988297|NA18990     |JPT        |EAS              |
| -13.1144833| -19.3617419|    0.7962482|NA18992     |JPT        |EAS              |
| -13.1187479| -21.2211122|   -1.6430924|NA18994     |JPT        |EAS              |
| -14.5825344| -24.1510901|    0.0254757|NA18995     |JPT        |EAS              |
| -12.3889009| -20.3893549|   -0.1819213|NA18998     |JPT        |EAS              |
| -14.7462295| -20.4803114|    1.3701092|NA18999     |JPT        |EAS              |
| -15.2088656| -23.7243501|   -0.1738764|NA19000     |JPT        |EAS              |
| -13.2842705| -16.2602925|    0.6373957|NA19002     |JPT        |EAS              |
| -13.3784395| -20.3593211|   -0.8369951|NA19003     |JPT        |EAS              |
| -13.5450548| -22.4698063|    1.1020807|NA19004     |JPT        |EAS              |
| -13.1650817| -18.8607375|    0.0152094|NA19005     |JPT        |EAS              |
| -13.6774507| -19.8713747|    0.6561072|NA19007     |JPT        |EAS              |
| -14.4766843| -22.9301004|   -0.6408059|NA19009     |JPT        |EAS              |
| -12.7037319| -19.4068816|    0.5091575|NA19010     |JPT        |EAS              |
| -12.9340959| -21.7080274|    1.0123057|NA19012     |JPT        |EAS              |
|  27.8902060|  -3.8140105|   -0.2201354|NA19020     |LWK        |AFR              |
|  31.3814542|  -4.4651283|    0.4598149|NA19028     |LWK        |AFR              |
|  32.3793645|  -5.9487212|   -3.1036185|NA19035     |LWK        |AFR              |
|  31.8803485|  -6.0653766|    1.7917929|NA19036     |LWK        |AFR              |
|  30.9461521|  -5.3075741|    1.3034446|NA19038     |LWK        |AFR              |
|  31.1074144|  -4.4836569|    0.5806376|NA19041     |LWK        |AFR              |
|  31.5808877|  -5.0224974|    1.1438934|NA19044     |LWK        |AFR              |
|  28.4332635|  -5.1980362|    1.3601874|NA19046     |LWK        |AFR              |
| -14.1648374| -19.9025521|    0.3746527|NA19054     |JPT        |EAS              |
| -16.0384632| -19.4748350|   -1.1645128|NA19055     |JPT        |EAS              |
| -13.4258673| -18.0590026|    0.5814727|NA19056     |JPT        |EAS              |
| -15.3439937| -19.3636179|    0.5043034|NA19057     |JPT        |EAS              |
| -14.7073798| -21.0394623|   -0.2476732|NA19058     |JPT        |EAS              |
| -13.7982687| -19.2430088|    0.1246122|NA19059     |JPT        |EAS              |
| -13.1352502| -21.0063255|    0.0538541|NA19060     |JPT        |EAS              |
| -13.7564657| -19.1093948|   -0.7922151|NA19062     |JPT        |EAS              |
| -14.0721505| -21.5897525|    0.8870024|NA19063     |JPT        |EAS              |
| -13.5562926| -22.3912707|    0.4438667|NA19064     |JPT        |EAS              |
| -12.7040921| -20.3841876|   -0.3637940|NA19065     |JPT        |EAS              |
| -14.0699528| -19.1991274|   -0.0044626|NA19066     |JPT        |EAS              |
| -15.2304332| -21.4935944|   -0.1313999|NA19067     |JPT        |EAS              |
| -13.2969139| -19.6969275|    0.8524861|NA19068     |JPT        |EAS              |
| -13.4456696| -18.7300647|    0.0613946|NA19070     |JPT        |EAS              |
| -13.4524088| -19.5703215|    0.9548425|NA19072     |JPT        |EAS              |
| -16.0454563| -21.5785772|    0.2550781|NA19074     |JPT        |EAS              |
| -13.4136016| -20.5448782|    0.7371051|NA19075     |JPT        |EAS              |
| -14.7582192| -22.1149268|    0.3124545|NA19076     |JPT        |EAS              |
| -11.5175976| -20.0869589|    0.3260907|NA19077     |JPT        |EAS              |
| -14.5516464| -21.2903422|   -0.2964629|NA19078     |JPT        |EAS              |
| -13.4177819| -20.1458427|   -1.0833929|NA19079     |JPT        |EAS              |
| -12.4919722| -21.1497662|   -1.4258094|NA19080     |JPT        |EAS              |
| -14.7019363| -20.7660595|    0.4402665|NA19081     |JPT        |EAS              |
| -13.3849095| -22.2902710|    0.9354104|NA19082     |JPT        |EAS              |
| -12.4753369| -19.9880115|   -0.2007134|NA19083     |JPT        |EAS              |
| -14.1923489| -20.5437532|   -1.1347533|NA19084     |JPT        |EAS              |
| -12.7954115| -19.9411092|    0.5031289|NA19085     |JPT        |EAS              |
| -13.7025181| -18.3871603|    0.3553698|NA19087     |JPT        |EAS              |
| -12.8951449| -20.6110078|    0.9795753|NA19088     |JPT        |EAS              |
|  32.7007833|  -7.1741958|    0.2330387|NA19093     |YRI        |AFR              |
|  35.3663814|  -6.2163158|   -1.1043681|NA19095     |YRI        |AFR              |
|  34.1325031|  -5.8361837|   -0.8531032|NA19096     |YRI        |AFR              |
|  32.8520618|  -6.6088238|    1.1175092|NA19098     |YRI        |AFR              |
|  33.4537812|  -6.1449506|   -2.4155280|NA19099     |YRI        |AFR              |
|  32.8200033|  -4.8984925|    0.3827033|NA19102     |YRI        |AFR              |
|  32.3792808|  -6.6800141|    0.4940743|NA19107     |YRI        |AFR              |
|  32.4281136|  -4.6825211|    0.3052024|NA19108     |YRI        |AFR              |
|  32.8526580|  -6.6147799|    0.8522854|NA19113     |YRI        |AFR              |
|  34.2498716|  -5.5028697|    0.0962097|NA19114     |YRI        |AFR              |
|  34.1256066|  -5.1894292|   -0.6981845|NA19116     |YRI        |AFR              |
|  33.7348346|  -5.6316201|    0.6526724|NA19117     |YRI        |AFR              |
|  33.4226405|  -4.3504810|    1.6022638|NA19118     |YRI        |AFR              |
|  32.0248826|  -7.5411363|    0.6860415|NA19119     |YRI        |AFR              |
|  31.8832231|  -5.9833196|    1.4445601|NA19121     |YRI        |AFR              |
|  34.3089481|  -7.6477436|   -1.5395197|NA19129     |YRI        |AFR              |
|  32.4148321|  -6.5614584|    1.3585382|NA19130     |YRI        |AFR              |
|  33.6962206|  -6.6662536|    0.9354310|NA19131     |YRI        |AFR              |
|  32.5301088|  -6.4631699|   -0.7069999|NA19137     |YRI        |AFR              |
|  31.9040066|  -5.0515324|   -2.1738433|NA19138     |YRI        |AFR              |
|  33.9367108|  -7.1606860|   -0.0297413|NA19146     |YRI        |AFR              |
|  35.4827005|  -6.3627853|    0.9512007|NA19147     |YRI        |AFR              |
|  31.2672815|  -4.8712600|   -0.6802957|NA19149     |YRI        |AFR              |
|  34.0736361|  -4.8703796|    0.0903679|NA19150     |YRI        |AFR              |
|  33.4804370|  -6.3197262|    0.4055459|NA19152     |YRI        |AFR              |
|  32.5623954|  -6.1046309|    1.1101653|NA19160     |YRI        |AFR              |
|  32.1608821|  -5.8268450|    0.8795420|NA19171     |YRI        |AFR              |
|  33.5048480|  -5.4303959|   -2.0189212|NA19172     |YRI        |AFR              |
|  33.8945443|  -6.4341290|    1.3308772|NA19175     |YRI        |AFR              |
|  29.4212337|  -5.5285914|   -2.7907978|NA19185     |YRI        |AFR              |
|  31.8818200|  -4.4659647|   -0.3279898|NA19189     |YRI        |AFR              |
|  33.5168939|  -6.7802763|    0.9051778|NA19190     |YRI        |AFR              |
|  30.9703197|  -7.6538066|    0.4246947|NA19197     |YRI        |AFR              |
|  32.5262752|  -5.2721916|   -0.6350663|NA19198     |YRI        |AFR              |
|  31.6968187|  -5.7281168|   -0.4906240|NA19200     |YRI        |AFR              |
|  31.4703549|  -7.4269527|    0.5417168|NA19204     |YRI        |AFR              |
|  32.8246401|  -6.9469865|   -0.2353002|NA19207     |YRI        |AFR              |
|  35.0613253|  -7.9436077|    0.5123200|NA19209     |YRI        |AFR              |
|  30.8679933|  -5.8260455|    1.1128702|NA19213     |YRI        |AFR              |
|  32.1102246|  -6.0003507|    0.1270584|NA19222     |YRI        |AFR              |
|  32.1537403|  -6.2837208|    0.0670563|NA19223     |YRI        |AFR              |
|  34.1294194|  -7.9050765|    0.1623671|NA19225     |YRI        |AFR              |
|  32.8439465|  -5.6767726|   -1.6502214|NA19235     |YRI        |AFR              |
|  32.9181821|  -7.3121409|    0.8563750|NA19236     |YRI        |AFR              |
|  32.6157211|  -5.2031551|    0.5660696|NA19247     |YRI        |AFR              |
|  31.6242917|  -4.9553018|    0.7552277|NA19248     |YRI        |AFR              |
|  34.4317335|  -6.1575996|   -0.1943954|NA19256     |YRI        |AFR              |
|  32.9316176|  -5.9097862|    0.9357004|NA19257     |YRI        |AFR              |
|  31.3839938|  -5.2468316|   -1.3077892|NA19307     |LWK        |AFR              |
|  30.2363737|  -4.4160137|   -0.6597292|NA19308     |LWK        |AFR              |
|  28.9026439|  -4.6086400|    0.7400778|NA19309     |LWK        |AFR              |
|  32.3294864|  -5.8488536|    1.3785622|NA19310     |LWK        |AFR              |
|  31.3283731|  -6.9746489|   -0.1989162|NA19311     |LWK        |AFR              |
|  32.0202134|  -5.0650668|   -2.3625862|NA19312     |LWK        |AFR              |
|  32.2093780|  -6.3148457|    0.4509871|NA19313     |LWK        |AFR              |
|  31.8293031|  -5.3161817|    0.1627409|NA19315     |LWK        |AFR              |
|  29.8166167|  -6.0983357|    0.7074353|NA19316     |LWK        |AFR              |
|  33.3325201|  -4.6871171|   -0.9853485|NA19317     |LWK        |AFR              |
|  32.4613689|  -5.7247402|   -0.9926211|NA19318     |LWK        |AFR              |
|  33.0468936|  -5.8471233|    0.4159672|NA19319     |LWK        |AFR              |
|  31.1463334|  -4.2166739|    1.3829702|NA19321     |LWK        |AFR              |
|  31.4295887|  -4.2069271|    0.1187873|NA19324     |LWK        |AFR              |
|  30.5804542|  -4.6252277|    0.9497098|NA19327     |LWK        |AFR              |
|  32.2567808|  -6.2142424|    0.0051615|NA19328     |LWK        |AFR              |
|  30.4344441|  -5.1773448|    0.5842305|NA19331     |LWK        |AFR              |
|  31.3405514|  -5.9376325|    1.1511309|NA19332     |LWK        |AFR              |
|  29.3426111|  -4.9851566|    0.9548951|NA19334     |LWK        |AFR              |
|  29.1186016|  -3.9002874|   -2.4895827|NA19338     |LWK        |AFR              |
|  31.3282926|  -5.9870558|    0.4866391|NA19346     |LWK        |AFR              |
|  33.9871247|  -6.1946127|   -0.9101021|NA19347     |LWK        |AFR              |
|  30.7142938|  -5.8595015|    0.1852768|NA19350     |LWK        |AFR              |
|  33.5795024|  -5.5606131|   -2.0920363|NA19351     |LWK        |AFR              |
|  35.1716417|  -6.6904636|   -2.2337244|NA19352     |LWK        |AFR              |
|  28.0743052|  -5.4905421|    0.1242663|NA19355     |LWK        |AFR              |
|  32.1885813|  -4.6398331|   -1.8310685|NA19359     |LWK        |AFR              |
|  32.1563288|  -4.7055434|   -0.1585250|NA19360     |LWK        |AFR              |
|  33.9581219|  -6.1953139|    0.7663455|NA19371     |LWK        |AFR              |
|  33.0398409|  -6.7393688|    0.9473152|NA19372     |LWK        |AFR              |
|  30.4528111|  -5.6187773|    0.7593987|NA19373     |LWK        |AFR              |
|  30.5008813|  -5.8999767|    1.4127816|NA19374     |LWK        |AFR              |
|  30.6464710|  -5.4768067|    1.0870286|NA19375     |LWK        |AFR              |
|  32.4851656|  -6.2944665|    0.8374631|NA19376     |LWK        |AFR              |
|  32.0208068|  -6.3535276|   -1.0592096|NA19377     |LWK        |AFR              |
|  29.0247377|  -4.0556866|    1.1365108|NA19379     |LWK        |AFR              |
|  29.3383562|  -6.9668872|    0.2877434|NA19380     |LWK        |AFR              |
|  28.6194871|  -5.8064806|   -0.2286615|NA19381     |LWK        |AFR              |
|  31.4561313|  -5.1144776|    0.6637869|NA19382     |LWK        |AFR              |
|  31.5429100|  -6.8012382|    0.9914496|NA19383     |LWK        |AFR              |
|  34.9671990|  -5.3632911|    1.2326422|NA19384     |LWK        |AFR              |
|  32.8077048|  -4.6325014|   -0.7694567|NA19385     |LWK        |AFR              |
|  28.5412948|  -6.2025358|   -1.2517939|NA19390     |LWK        |AFR              |
|  29.5397547|  -5.9357018|    0.9383011|NA19391     |LWK        |AFR              |
|  30.1382817|  -6.1378673|    1.0746606|NA19393     |LWK        |AFR              |
|  33.4537295|  -5.7612598|    0.4845684|NA19394     |LWK        |AFR              |
|  31.5470317|  -4.9062333|    0.5619243|NA19395     |LWK        |AFR              |
|  31.1381985|  -6.2254106|    1.6681913|NA19396     |LWK        |AFR              |
|  31.2062887|  -7.1251898|    0.7106014|NA19397     |LWK        |AFR              |
|  31.2499897|  -4.5759786|   -1.7323949|NA19398     |LWK        |AFR              |
|  31.7148975|  -5.4783815|    1.3948889|NA19399     |LWK        |AFR              |
|  32.8916606|  -5.6358878|    0.6481917|NA19401     |LWK        |AFR              |
|  30.7955806|  -5.0016514|    0.7438580|NA19403     |LWK        |AFR              |
|  29.5429986|  -5.5586392|    1.5398845|NA19404     |LWK        |AFR              |
|  29.8851813|  -4.3303975|    1.0599935|NA19428     |LWK        |AFR              |
|  32.5151680|  -5.7388642|   -2.4908435|NA19429     |LWK        |AFR              |
|  32.0934987|  -4.7914612|   -1.4562058|NA19430     |LWK        |AFR              |
|  29.9390818|  -6.2099454|    0.4476574|NA19431     |LWK        |AFR              |
|  29.9706442|  -5.8568398|   -2.0951704|NA19434     |LWK        |AFR              |
|  29.7708542|  -4.5519652|   -0.1381358|NA19435     |LWK        |AFR              |
|  30.5938627|  -5.2681101|    1.4683581|NA19436     |LWK        |AFR              |
|  30.8956648|  -4.2575033|   -0.4014123|NA19437     |LWK        |AFR              |
|  32.7830392|  -6.0363477|    0.9054186|NA19438     |LWK        |AFR              |
|  32.0879886|  -3.9256028|   -1.3044466|NA19439     |LWK        |AFR              |
|  30.4817774|  -6.1275081|   -2.7735142|NA19440     |LWK        |AFR              |
|  31.2721548|  -3.9266434|   -0.4945299|NA19443     |LWK        |AFR              |
|  28.9847026|  -4.2171654|   -1.9562783|NA19444     |LWK        |AFR              |
|  33.0613611|  -5.5720975|   -0.1707914|NA19445     |LWK        |AFR              |
|  31.9161663|  -4.4898021|    0.7131544|NA19446     |LWK        |AFR              |
|  31.1153405|  -4.8463701|   -2.0173050|NA19448     |LWK        |AFR              |
|  31.2428741|  -6.2703689|   -2.5229249|NA19449     |LWK        |AFR              |
|  31.1983225|  -7.3420154|    1.3898934|NA19451     |LWK        |AFR              |
|  31.0572123|  -5.0524038|   -1.1954337|NA19452     |LWK        |AFR              |
|  30.7193472|  -5.1107533|   -0.3114217|NA19453     |LWK        |AFR              |
|  29.5883108|  -5.3592645|   -0.6451993|NA19455     |LWK        |AFR              |
|  30.0335885|  -5.9695862|    0.2448009|NA19456     |LWK        |AFR              |
|  31.3862206|  -5.0895466|   -2.2631851|NA19457     |LWK        |AFR              |
|  32.9397705|  -4.7030211|   -0.3828250|NA19461     |LWK        |AFR              |
|  35.3101072|  -6.2386243|   -0.3971812|NA19462     |LWK        |AFR              |
|  30.8134931|  -5.0365795|   -0.7290110|NA19463     |LWK        |AFR              |
|  31.1037665|  -5.5398312|    0.7402676|NA19466     |LWK        |AFR              |
|  27.3222470|  -3.6144611|    0.6425240|NA19467     |LWK        |AFR              |
|  30.7751965|  -4.9367330|   -1.6529920|NA19468     |LWK        |AFR              |
|  32.0923203|  -5.9761304|   -0.8965159|NA19469     |LWK        |AFR              |
|  31.0080349|  -4.9512097|   -1.1209948|NA19470     |LWK        |AFR              |
|  29.8306601|  -4.8979397|    1.5176901|NA19471     |LWK        |AFR              |
|  32.2018420|  -5.1200182|   -0.3219257|NA19472     |LWK        |AFR              |
|  30.6449878|  -4.0602123|    0.2702194|NA19473     |LWK        |AFR              |
|  30.0664767|  -4.1810336|    0.4161371|NA19474     |LWK        |AFR              |
|  16.9178154|  -4.7280911|   -0.2324976|NA19625     |ASW        |AFR              |
|  -3.2793610|  13.4406520|   -0.4443190|NA19648     |MXL        |AMR              |
|  -5.0713582|   8.5994963|   -0.1180130|NA19651     |MXL        |AMR              |
|  -5.2629933|   7.5763048|    1.7798760|NA19652     |MXL        |AMR              |
|  -6.9192138|  -0.7052242|    2.0496828|NA19654     |MXL        |AMR              |
|  -6.4211451|   8.6520027|    2.5157482|NA19655     |MXL        |AMR              |
|  -7.5759932|   3.1524646|    1.2290540|NA19657     |MXL        |AMR              |
|  -8.3633527|   5.0744016|    0.9244762|NA19660     |MXL        |AMR              |
|  -7.3044501|   1.4508347|    0.2172868|NA19661     |MXL        |AMR              |
|  -7.3620992|  -0.9986405|    2.5165729|NA19663     |MXL        |AMR              |
|  -6.4819818|   2.9207528|    2.8145179|NA19664     |MXL        |AMR              |
|  -7.5098600|   5.3703111|    1.3833770|NA19672     |MXL        |AMR              |
|  -5.9175910|  10.1417612|   -0.6434984|NA19675     |MXL        |AMR              |
|  -6.4265867|   7.2584136|    2.3095039|NA19676     |MXL        |AMR              |
|  -4.6194914|   7.5746496|    0.0691264|NA19678     |MXL        |AMR              |
|  -4.9354397|  11.3367691|   -0.5494072|NA19679     |MXL        |AMR              |
|  -7.9740300|  -0.0492325|    0.5661447|NA19681     |MXL        |AMR              |
|  -8.4277857|   3.0636206|    2.0184322|NA19682     |MXL        |AMR              |
|  -7.6692292|   8.5709916|    1.3761320|NA19684     |MXL        |AMR              |
|  -8.0172992|   5.0855797|    0.9976587|NA19685     |MXL        |AMR              |
|  27.3166595|  -1.3599113|   -0.1526233|NA19700     |ASW        |AFR              |
|  23.9130367|  -3.9926347|    0.4981269|NA19701     |ASW        |AFR              |
|  25.9651321|  -0.7539296|   -0.2517082|NA19703     |ASW        |AFR              |
|  27.4612187|  -5.2629158|   -0.9228582|NA19704     |ASW        |AFR              |
|  20.6276859|   1.5674802|   -1.4048322|NA19707     |ASW        |AFR              |
|  28.4272433|  -3.4301251|    0.8873640|NA19711     |ASW        |AFR              |
|  26.6138227|  -4.4063323|    1.5972770|NA19712     |ASW        |AFR              |
|  23.7164399|  -0.2894146|   -0.1155941|NA19713     |ASW        |AFR              |
|  -6.8266040|  -0.9410545|    2.8691438|NA19716     |MXL        |AMR              |
|  -8.4966201|   0.8592701|    1.5846820|NA19717     |MXL        |AMR              |
|  -6.6082273|   2.6119109|    1.4443545|NA19719     |MXL        |AMR              |
|  -7.2820446|   0.2632990|    1.4235654|NA19720     |MXL        |AMR              |
|  -5.8795420|   1.9149664|    2.3045856|NA19722     |MXL        |AMR              |
|  -6.4194397|   1.8007766|    1.0851187|NA19723     |MXL        |AMR              |
|  -5.5773576|   7.3182086|    1.8628026|NA19725     |MXL        |AMR              |
|  -7.7969043|   0.8147659|    1.9797812|NA19726     |MXL        |AMR              |
|  -9.3947501|  -5.9460722|    0.9451646|NA19728     |MXL        |AMR              |
| -11.5847053|  -5.8743315|    1.6904491|NA19729     |MXL        |AMR              |
| -10.6119434|  -6.5578554|    3.3067724|NA19731     |MXL        |AMR              |
| -12.5142390|  -9.6110861|    1.4637850|NA19732     |MXL        |AMR              |
|  -8.4356612|  -4.2502891|    3.2230826|NA19734     |MXL        |AMR              |
| -10.2796628|  -6.1354249|    1.8154397|NA19735     |MXL        |AMR              |
|  -5.9422489|   4.0766341|    0.3871488|NA19737     |MXL        |AMR              |
|  -6.4118431|   5.0112787|    1.3500559|NA19738     |MXL        |AMR              |
|  -9.6708734|  -4.8821491|    1.0232336|NA19740     |MXL        |AMR              |
|  -9.5603357|  -2.7519970|    2.9685594|NA19741     |MXL        |AMR              |
|  -9.1445769|  -4.6979138|    3.1006377|NA19746     |MXL        |AMR              |
|  -6.2701305|   1.9184493|    2.4451576|NA19747     |MXL        |AMR              |
|  -7.0353116|   4.3196336|    0.4771276|NA19749     |MXL        |AMR              |
|  -6.2814549|   7.4128783|    0.7588595|NA19750     |MXL        |AMR              |
|  -8.3828608|   3.9409044|    1.0323250|NA19752     |MXL        |AMR              |
|  -8.5191042|   0.2165459|    3.1656088|NA19753     |MXL        |AMR              |
|  -7.4103480|  -2.1772714|    0.9390016|NA19755     |MXL        |AMR              |
|  -7.5159709|   1.7268544|    0.6752059|NA19756     |MXL        |AMR              |
| -10.3419984|  -2.9484390|    1.8973541|NA19758     |MXL        |AMR              |
| -10.1934446|  -5.0113572|    2.2421917|NA19759     |MXL        |AMR              |
|  -6.5260648|   2.1844935|    0.7298402|NA19761     |MXL        |AMR              |
|  -6.6106613|   0.2643041|    2.5569028|NA19762     |MXL        |AMR              |
|  -7.1149788|   4.4597542|   -1.3537726|NA19764     |MXL        |AMR              |
|  -3.9975499|   1.9757200|    1.7539130|NA19770     |MXL        |AMR              |
|  -5.5476315|   3.1217026|    2.8665054|NA19771     |MXL        |AMR              |
|  -6.7040761|   6.2095047|    1.8854762|NA19773     |MXL        |AMR              |
|  -5.7353485|   4.7573586|    1.1570871|NA19774     |MXL        |AMR              |
|  -4.9483090|   1.5335016|    1.0860360|NA19776     |MXL        |AMR              |
|  -6.3265849|   3.7746966|    2.0791374|NA19777     |MXL        |AMR              |
|  -6.4494067|   6.0260276|    1.7475992|NA19779     |MXL        |AMR              |
|  -7.3049661|   6.9765987|   -0.0643451|NA19780     |MXL        |AMR              |
|  -6.2676688|   3.2060632|    1.1738761|NA19782     |MXL        |AMR              |
|  -9.1909284|  -3.9516022|    2.0454342|NA19783     |MXL        |AMR              |
|  -7.1133751|  -2.6442418|    2.8596017|NA19785     |MXL        |AMR              |
|  -7.2437830|   0.2292180|    3.3142444|NA19786     |MXL        |AMR              |
|  -6.9023602|  -2.9107716|    2.2806824|NA19788     |MXL        |AMR              |
|  -6.7567090|   5.2227115|    3.3873978|NA19789     |MXL        |AMR              |
|  -6.6744358|   7.5616246|    1.6455122|NA19794     |MXL        |AMR              |
|  -5.3581302|   1.9321598|   -0.0682901|NA19795     |MXL        |AMR              |
|  20.5854548|  -0.3400568|   -2.0000395|NA19818     |ASW        |AFR              |
|  18.4547944|   0.1118668|   -0.8440343|NA19819     |ASW        |AFR              |
|  21.8210023|   1.2055747|   -0.5970842|NA19834     |ASW        |AFR              |
|  25.3891683|  -2.9540086|   -1.5628752|NA19835     |ASW        |AFR              |
|  27.2422764|  -1.5913964|    0.7240391|NA19900     |ASW        |AFR              |
|  25.9457699|  -4.6530999|    1.1373181|NA19901     |ASW        |AFR              |
|  26.2395806|  -3.2250769|    0.5577078|NA19904     |ASW        |AFR              |
|  28.0750179|  -4.2398640|    1.5040315|NA19908     |ASW        |AFR              |
|  25.8924887|  -0.8743138|   -0.9442213|NA19909     |ASW        |AFR              |
|  20.6426636|  -0.2674173|    1.3618312|NA19914     |ASW        |AFR              |
|  28.6182824|  -5.4919831|    1.4151885|NA19916     |ASW        |AFR              |
|  25.8589463|  -4.9198097|    0.4397390|NA19917     |ASW        |AFR              |
|  30.1667642|  -3.3750252|    0.9419912|NA19920     |ASW        |AFR              |
|  13.9402115|   1.2737890|    0.4722056|NA19921     |ASW        |AFR              |
|  22.5129570|   0.4089097|   -0.1451448|NA19922     |ASW        |AFR              |
|  16.5906919|   2.0270201|    1.1894036|NA19923     |ASW        |AFR              |
|  25.4244366|  -2.1466916|   -0.5895175|NA19982     |ASW        |AFR              |
|  27.5641041|  -3.9109933|   -1.4978281|NA19984     |ASW        |AFR              |
|  24.7530475|  -1.0436353|   -0.6389899|NA19985     |ASW        |AFR              |
|  21.9556605|   0.2896288|    0.7781520|NA20126     |ASW        |AFR              |
|  30.4901133|  -5.8729307|    1.9826417|NA20127     |ASW        |AFR              |
|  24.3112831|  -1.0718457|    1.1615479|NA20276     |ASW        |AFR              |
|  11.0832717|   6.2940953|    0.5625472|NA20278     |ASW        |AFR              |
|  25.2646823|  -3.8017445|   -0.7811031|NA20281     |ASW        |AFR              |
|  21.3059923|  -0.5302488|    0.8785899|NA20282     |ASW        |AFR              |
|  24.2241897|  -2.8542403|    1.2244966|NA20287     |ASW        |AFR              |
|  21.1328858|  -1.3209462|    0.7160365|NA20289     |ASW        |AFR              |
|  30.3828632|  -4.6839689|   -1.4994611|NA20291     |ASW        |AFR              |
|  25.8877125|  -1.9696681|    1.9681864|NA20294     |ASW        |AFR              |
|  25.0027239|   0.1190115|    1.4849657|NA20296     |ASW        |AFR              |
|  28.8993531|  -3.0805669|   -0.1118456|NA20298     |ASW        |AFR              |
|   6.4320595|  -3.9304789|    1.1989173|NA20299     |ASW        |AFR              |
| -10.5501661|  -1.5453415|    0.7910220|NA20314     |ASW        |AFR              |
|  21.7388722|  -0.3214102|    0.2745526|NA20317     |ASW        |AFR              |
|  23.3309681|  -0.9040645|    0.5833909|NA20322     |ASW        |AFR              |
|  26.9849789|  -3.2348796|   -0.5928766|NA20332     |ASW        |AFR              |
|  19.3941371|   2.2745500|   -0.6403174|NA20334     |ASW        |AFR              |
|  19.6553834|   2.9367027|    0.4932946|NA20336     |ASW        |AFR              |
|  28.6340553|  -3.9201214|   -0.2245889|NA20339     |ASW        |AFR              |
|  29.2162182|  -3.0023399|   -2.1009196|NA20340     |ASW        |AFR              |
|  20.3745568|   0.0999673|    0.4434309|NA20341     |ASW        |AFR              |
|  17.2933794|   2.2832657|    0.5939872|NA20342     |ASW        |AFR              |
|  24.9897043|  -1.5534909|    0.7148575|NA20344     |ASW        |AFR              |
|  27.0822861|  -3.5502727|    1.3832766|NA20346     |ASW        |AFR              |
|  28.2539199|  -3.0245638|    0.8932569|NA20348     |ASW        |AFR              |
|  19.3854448|  -0.9972368|    0.7448843|NA20351     |ASW        |AFR              |
|  26.6304368|  -2.6071241|   -2.0255414|NA20356     |ASW        |AFR              |
|  28.5968817|  -1.7816302|   -1.9386038|NA20357     |ASW        |AFR              |
|  21.4414029|  -0.7268535|    0.9284060|NA20359     |ASW        |AFR              |
|  19.0720437|   0.3407883|    1.1860717|NA20363     |ASW        |AFR              |
|  22.3490923|  -2.0101612|   -1.6778737|NA20412     |ASW        |AFR              |
|   2.8925036|   0.0828092|    0.3798083|NA20414     |ASW        |AFR              |
|  -5.1691888|  15.0399777|   -1.3665976|NA20502     |TSI        |EUR              |
|  -5.6224893|  13.9364199|    0.6638937|NA20503     |TSI        |EUR              |
|  -6.0552553|  13.7919798|   -0.2128890|NA20504     |TSI        |EUR              |
|  -3.7837762|  14.9644601|    1.0921120|NA20505     |TSI        |EUR              |
|  -5.3436137|  13.8494988|   -0.9737861|NA20506     |TSI        |EUR              |
|  -6.2372693|  17.1052040|    1.2201038|NA20507     |TSI        |EUR              |
|  -5.5059803|  15.3897528|   -1.7390695|NA20508     |TSI        |EUR              |
|  -6.1057068|  15.5426840|    1.0916985|NA20509     |TSI        |EUR              |
|  -6.7343510|  15.8137452|    0.8307874|NA20510     |TSI        |EUR              |
|  -7.1676364|  14.9102402|    1.6584343|NA20512     |TSI        |EUR              |
|  -4.6052689|  14.9339177|    1.3565385|NA20513     |TSI        |EUR              |
|  -6.0166901|  16.5826471|   -0.0830339|NA20515     |TSI        |EUR              |
|  -4.9254049|  13.6782574|    2.0014879|NA20516     |TSI        |EUR              |
|  -5.6916156|  15.8980078|    1.1032599|NA20517     |TSI        |EUR              |
|  -5.8111096|  16.2974856|   -0.3636789|NA20518     |TSI        |EUR              |
|  -6.0882514|  15.0992325|    1.7097944|NA20519     |TSI        |EUR              |
|  -3.4142472|  14.9973893|    1.9730130|NA20520     |TSI        |EUR              |
|  -5.3579879|  16.1564129|    0.1195135|NA20521     |TSI        |EUR              |
|  -6.3095100|  14.0844679|    0.2287659|NA20522     |TSI        |EUR              |
|  -6.7027974|  14.3630889|    0.5594214|NA20524     |TSI        |EUR              |
|  -5.1331654|  14.4089848|   -1.2618994|NA20525     |TSI        |EUR              |
|  -7.3325878|  14.6767723|   -1.5185278|NA20527     |TSI        |EUR              |
|  -6.2912101|  14.5233943|   -0.0636938|NA20528     |TSI        |EUR              |
|  -7.1724110|  15.3622791|    1.3487694|NA20529     |TSI        |EUR              |
|  -5.2699578|  15.6405485|   -0.9364175|NA20530     |TSI        |EUR              |
|  -4.5997398|  13.6512659|   -0.4088605|NA20531     |TSI        |EUR              |
|  -5.7450202|  15.4342770|    0.0031639|NA20532     |TSI        |EUR              |
|  -5.0883637|  15.0219496|    0.8871431|NA20533     |TSI        |EUR              |
|  -5.8391709|  15.9495696|    1.4934336|NA20534     |TSI        |EUR              |
|  -5.5550927|  15.8921018|   -0.3261025|NA20535     |TSI        |EUR              |
|  -4.7811557|  16.0985592|   -0.5027845|NA20536     |TSI        |EUR              |
|  -5.5215666|  16.4290224|   -1.4691386|NA20537     |TSI        |EUR              |
|  -6.0115586|  13.8822226|    0.7099399|NA20538     |TSI        |EUR              |
|  -4.4496513|  15.8741624|   -0.4624877|NA20539     |TSI        |EUR              |
|  -4.0041002|  16.0006292|    1.8909476|NA20540     |TSI        |EUR              |
|  -5.2495726|  17.1600327|   -0.6043708|NA20541     |TSI        |EUR              |
|  -5.7840421|  17.0467350|   -1.1519135|NA20542     |TSI        |EUR              |
|  -5.9805150|  16.4203447|   -0.6330179|NA20543     |TSI        |EUR              |
|  -7.1441183|  15.6669355|    1.0936782|NA20544     |TSI        |EUR              |
|  -6.3816501|  15.4078733|    1.1369032|NA20581     |TSI        |EUR              |
|  -6.9618048|  14.7352167|    0.5210610|NA20582     |TSI        |EUR              |
|  -4.7413246|  13.9266584|   -2.4758231|NA20585     |TSI        |EUR              |
|  -5.0545448|  15.6711591|    0.2571599|NA20586     |TSI        |EUR              |
|  -4.1974174|  13.2453321|   -0.3565131|NA20588     |TSI        |EUR              |
|  -3.9624094|  14.1062465|    1.6183312|NA20589     |TSI        |EUR              |
|  -7.2559395|  16.7896382|   -1.3310892|NA20752     |TSI        |EUR              |
|  -6.2991243|  17.0274808|    0.7413229|NA20753     |TSI        |EUR              |
|  -6.2809863|  16.0623502|    0.6381985|NA20754     |TSI        |EUR              |
|  -5.3683249|  16.7056775|    1.3030632|NA20755     |TSI        |EUR              |
|  -5.4639016|  15.5317610|   -0.7821434|NA20756     |TSI        |EUR              |
|  -6.6157702|  14.5860907|    0.8348715|NA20757     |TSI        |EUR              |
|  -6.2874338|  17.5454452|   -0.0084668|NA20758     |TSI        |EUR              |
|  -6.1935753|  16.2751355|    1.9253455|NA20759     |TSI        |EUR              |
|  -6.7223478|  14.1212259|    2.2173511|NA20760     |TSI        |EUR              |
|  -5.8660082|  15.7742018|    1.0751121|NA20761     |TSI        |EUR              |
|  -4.9007383|  14.2553527|    1.2701887|NA20765     |TSI        |EUR              |
|  -6.1116813|  14.1934736|    1.5754503|NA20766     |TSI        |EUR              |
|  -6.7522286|  14.9599010|    0.7624394|NA20768     |TSI        |EUR              |
|  -6.0450298|  13.7734099|    1.5247167|NA20769     |TSI        |EUR              |
|  -5.8621432|  14.5486417|    1.8445080|NA20770     |TSI        |EUR              |
|  -5.4331953|  14.6974663|    0.2676511|NA20771     |TSI        |EUR              |
|  -7.3308202|  14.3323251|    0.1387615|NA20772     |TSI        |EUR              |
|  -7.1777632|  15.4063789|    1.5793339|NA20773     |TSI        |EUR              |
|  -6.3610624|  14.9340904|    0.7926426|NA20774     |TSI        |EUR              |
|  -3.0081012|  13.7760444|    1.6390738|NA20775     |TSI        |EUR              |
|  -5.1900812|  14.3959599|   -0.9837267|NA20778     |TSI        |EUR              |
|  -4.4685390|  15.7175645|   -0.2668525|NA20783     |TSI        |EUR              |
|  -6.2679894|  13.9524266|    1.8141008|NA20785     |TSI        |EUR              |
|  -6.5044693|  14.1984055|    0.8971722|NA20786     |TSI        |EUR              |
|  -6.1417418|  15.7250298|   -0.6070817|NA20787     |TSI        |EUR              |
|  -5.6587868|  15.2753511|    0.5892587|NA20790     |TSI        |EUR              |
|  -6.7071831|  16.0509501|    1.2036329|NA20792     |TSI        |EUR              |
|  -4.2136842|  15.1853436|   -0.7364308|NA20795     |TSI        |EUR              |
|  -5.6552374|  17.2942379|   -0.0951341|NA20796     |TSI        |EUR              |
|  -6.0894188|  14.9549188|   -0.6103979|NA20797     |TSI        |EUR              |
|  -5.5352711|  17.2430668|   -1.2634332|NA20798     |TSI        |EUR              |
|  -4.8682915|  13.9710894|    1.8851733|NA20799     |TSI        |EUR              |
|  -6.1655586|  16.3989996|    0.8015747|NA20800     |TSI        |EUR              |
|  -5.3260643|  14.8221697|    2.0744193|NA20801     |TSI        |EUR              |
|  -7.6357283|  15.0891922|   -0.9026173|NA20802     |TSI        |EUR              |
|  -5.8361458|  15.9353799|    1.5528590|NA20803     |TSI        |EUR              |
|  -6.2948306|  14.9845634|   -0.5242914|NA20804     |TSI        |EUR              |
|  -5.6927534|  15.2043750|    1.6565505|NA20805     |TSI        |EUR              |
|  -6.6170396|  13.5723994|    1.4447730|NA20806     |TSI        |EUR              |
|  -6.7806837|  14.8322058|   -2.0377776|NA20807     |TSI        |EUR              |
|  -5.4758076|  17.3944231|   -0.4366685|NA20808     |TSI        |EUR              |
|  -6.2845422|  16.0994026|   -0.8575555|NA20809     |TSI        |EUR              |
|  -7.0427964|  14.8985524|    0.5849355|NA20810     |TSI        |EUR              |
|  -5.9337603|  15.0940375|    0.6840492|NA20811     |TSI        |EUR              |
|  -3.9523540|  15.4000911|    0.7600512|NA20812     |TSI        |EUR              |
|  -6.1657559|  16.7829436|    0.1776694|NA20813     |TSI        |EUR              |
|  -5.8167146|  14.9383059|    1.7964498|NA20814     |TSI        |EUR              |
|  -6.5493895|  15.5849487|    2.2544165|NA20815     |TSI        |EUR              |
|  -7.4720326|  15.9853039|    1.6047363|NA20816     |TSI        |EUR              |
|  -5.9384763|  15.2438965|    1.9648916|NA20818     |TSI        |EUR              |
|  -5.2485317|  16.1731756|    2.0172386|NA20819     |TSI        |EUR              |
|  -4.6234527|  15.4360704|   -1.2808576|NA20826     |TSI        |EUR              |
|  -4.9153654|  15.6009297|    0.4092658|NA20828     |TSI        |EUR              |

Some notes
===========

- Each of the columns of the $Z$ matrix are called _Principal Components_
- The units of the PCs are _meaningless_
- In this case we also scaled the variables $X_j$ to have unit variance. **I** would not have done that with this dataset, but we'll see why I did it shortly.
- In general, if variables $X_j$ are measured in different units (e.g, miles vs. liters vs. dollars), variables should be scaled to have unit variance.
- Conversely, if they are all measured in the same units (as in this example), you should not scale them.

Example
=========

![plot of chunk unnamed-chunk-7](Unsupervised-figure/unnamed-chunk-7-1.png) 

***

Interpretation:
- First roughly corresponds to African population 
- Second component rouhgly corresponds to Eastern Asian population
- America not as well defined as the other populations

Interpretation 
===============

We can also look at $\phi$'s (aka _loadings_) to see how much weight each variable is assigned to each PC. 

For example, here are the 
top 10 SNPs for PC1

***


|SNP                                                   |     PC1|     PC2|
|:-----------------------------------------------------|-------:|-------:|
|[rs2740574](http://snpedia.com/index.php/rs2740574)   | -0.0510|  0.0072|
|[rs10743430](http://snpedia.com/index.php/rs10743430) | -0.0495|  0.0062|
|[rs2643103](http://snpedia.com/index.php/rs2643103)   | -0.0484|  0.0179|
|[rs2032487](http://snpedia.com/index.php/rs2032487)   | -0.0481|  0.0050|
|[rs4821480](http://snpedia.com/index.php/rs4821480)   | -0.0479|  0.0049|
|[rs4821481](http://snpedia.com/index.php/rs4821481)   | -0.0479|  0.0049|
|[rs9891361](http://snpedia.com/index.php/rs9891361)   | -0.0475|  0.0102|
|[rs710079](http://snpedia.com/index.php/rs710079)     |  0.0467| -0.0160|
|[rs3136687](http://snpedia.com/index.php/rs3136687)   |  0.0466| -0.0114|
|[rs5750248](http://snpedia.com/index.php/rs5750248)   | -0.0460|  0.0043|

Interpretation
===============

Book has an example of `biplot` which combines visualization of embedded data and loadings. **I don't like it!**

![plot of chunk unnamed-chunk-9](Unsupervised-figure/unnamed-chunk-9-1.png) 

Practicalities
===============

How many PCs to consider in post-hoc analysis?

A result of PCA is a measure of the variance corresponding to each PC. From that we can calculate the _percentage of variance explained_ for the $m$-th PC:

$$
PVE_m=\frac{\sum_{i=1}^n z_{im}^2}{\sum_{j=1}^p \sum_{i=1}^n x_{ij}^2}
$$

Practicalities
===============

How many PCs to consider in post-hoc analysis?

We can use this measure to choose number of PCs in an ad-hoc manner

In this case, going further than PC3 does not add information

***

![plot of chunk unnamed-chunk-10](Unsupervised-figure/unnamed-chunk-10-1.png) 

Practicalities
===============

_Rule of thumb_: 
  - If no apparent patterns in first couple of PCs, stop! 
  - Otherwise, look at other PCs using PVE as guide.

Still, this is very much ad-hoc, and no commonly agreed upon method for choosing number of PCs used in practice.

A final caveat: PCA is **notoriously easy** to over-interpret...

Motivating Example
===================

Let's reveal the source of our motivating data. This came from a [blog post](https://liorpachter.wordpress.com/2014/12/02/the-perfect-human-is-puerto-rican/) by [Lior Pachter](https://math.berkeley.edu/~lpachter/) a mathematician and computational biologist. 

- He did use real genotype data from the [1000 genomes project](http://www.1000genomes.org/)
- And created, _in silico_ a hypothetical human being where each SNP was set optimally
  - i.e., if it's a protective mutation, then mutation was given, if it's a deleterious mutation, then mutation was not inherited

Example
=========

This hypothetical human being is the `OPT` population

***

![plot of chunk unnamed-chunk-11](Unsupervised-figure/unnamed-chunk-11-1.png) 

Example
=================

Which from PC3 you can see it is indeed hypothetical

***

![plot of chunk unnamed-chunk-12](Unsupervised-figure/unnamed-chunk-12-1.png) 

Example
========

Now, things got interesting when he reported that the nearest individual in the _embedded_ dataset to this perfect human was a Puerto Rican woman:

[1] "[HG00737](https://catalog.coriell.org/0/sections/Search/Sample_Detail.aspx?Ref=HG00737&PgId=166)"

[Medical Daily](http://www.medicaldaily.com/biologist-says-puerto-rican-women-possess-ideal-genotype-perfect-human-dna-ancestry-313956)  
[HuffPost](http://www.huffingtonpost.com/julio-pabon/the-closet-perfect-human-_b_6304366.html)  
[El Nuevo Dia (Puerto Rican Newspaper)](http://clasificados.endi.com/ciencia/ciencia/nota/serhumanoperfectoseriapuertorriqueno-1903858/) [Google Translate](https://translate.google.com/translate?hl=en&sl=auto&tl=en&u=http%3A%2F%2Fclasificados.endi.com%2Fciencia%2Fciencia%2Fnota%2Fserhumanoperfectoseriapuertorriqueno-1903858%2F)  
[Latin Times](http://www.latintimes.com/new-study-reveals-perfect-human-genetically-speaking-caribbean-island-280363)  
[The Backlash...](http://globalvoicesonline.org/2014/12/17/the-perfect-human-doesnt-live-in-puerto-rico-or-any-other-country/)

[_and a lot more_](https://www.google.com/?gws_rd=ssl#q=perfect+human+pachter)

Summary
========

Principal Component Analysis

- Conceptually simple
- Powerful EDA tool, very useful. 
- Interpretation very ad-hoc
- Part of large set of unsupervised methods based on _matrix decompositions_

