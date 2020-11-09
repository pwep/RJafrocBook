# Empirical plot examples {#froc-empirical-examples}



## Introduction {#froc-empirical-examples-intro}

TBA So far, the description has been limited to definitions and formulae of various operating characteristics possible with FROC data. Now it is time to put numbers into the formulae and see actual plots. The starting point is the FROC plot. A simulator will be used to generate FROC datasets under controlled conditions.

## Raw FROC/AFROC/ROC plots

*Raw plots* correspond to the actual simulator generated continuous ratings, prior to any binning operation. The opposite of raw plots would be *binned plots*. The FROC plots shown below were generated using the data simulator introduced in Chapter \@ref(froc-paradigm). The examples are similar to the population FROC curves shown in that chapter but the emphasis here is on understanding the FROC data structure. To this end smaller numbers of cases, not 20,000 as in the previous chapter, are used. Examples are given using continuous ratings, termed "raw data", and binned data, for a smaller dataset and for a larger dataset. With a smaller dataset, the logic of constructing the plot is more transparent but the operating points are more susceptible to sampling variability. The examples illustrate key points distinguishing the free-response paradigm from ROC.

### Code for raw plots {#raw-plots-code1}


```{.r .numberLines}
seed <- 1;set.seed(seed)
mu <- 1
lambda <- 1
nu <- 1 
zeta1 <- -1
K1 <- 5
K2 <- 7 
Lmax <- 2
Lk2 <- floor(runif(K2, 1, Lmax + 1))

frocDataRaw <- SimulateFrocDataset(
  mu = mu, 
  lambda = lambda, 
  nu = nu, 
  I = 1,
  J = 1,
  K1 = K1, 
  K2 = K2, 
  perCase = Lk2, 
  zeta1 = zeta1
)

p1 <- PlotEmpiricalOperatingCharacteristics(
  dataset = frocDataRaw, 
  trts= 1, rdrs = 1, opChType = "FROC", 
  legend.position = "NULL")$Plot

p2 <- PlotEmpiricalOperatingCharacteristics(
  dataset = frocDataRaw, 
  trts= 1, rdrs = 1, opChType = "AFROC", 
  legend.position = "NULL")$Plot

p3 <- PlotEmpiricalOperatingCharacteristics(
  dataset = frocDataRaw, 
  trts= 1, rdrs = 1, opChType = "ROC", 
  legend.position = "NULL")$Plot

frocDataRaw_1_5_7 <- frocDataRaw # seed 2, K1 = 5, K2 = 7
```

### Explanation of the code

Line 1 sets the seed of the random number generator. Lines 2-5 set the simulator parameters $\mu = 1, \lambda = 1, \nu = 1, \zeta_1 = -1$. Briefly, $\mu$ determines the separation of two unit variance Gaussians, the left one determines the z-samples of latent NLs, while the right one determines the z-samples of latent LLs. $\lambda$ determines the number of latent NLs while $\nu$ determines the number of latent LLs. A latent NL or LL is marked if its z-sample $\geq \zeta_1$.

Lines 6-7 set the number of non-diseased cases $K_1 = 5$ and the number of diseased cases $K_2 = 7$.

Line 8 sets the maximum number of lesions per diseased case to 2. Line 9 randomly samples the actual number of lesions per diseased case. The following code illustrates the process.

#### Number of lesions per diseased case


```r
Lk2
#> [1] 1 1 2 2 1 2 2
sum(Lk2)
#> [1] 11
max(floor(runif(1000, 1, Lmax + 1)))
#> [1] 2
```

This shows that the first two diseased cases have one lesion each, the third and fourth have two lesions each, etc. The total number of lesions in the dataset is 11. The last two lines of the code snippet show that, even with a thousand simulations, the number of lesions per diseased case is indeed limited to two.

#### The structure of the FROC dataset

Returning to the explanation of the code, lines 11-21 uses the function `SimulateFrocDataset` to simulate the dataset object `frocDataRaw`. Its structure is examined next:


```r
str(frocDataRaw)
#> List of 3
#>  $ ratings     :List of 3
#>   ..$ NL   : num [1, 1, 1:12, 1:4] 0.764 -0.799 -Inf -Inf -Inf ...
#>   ..$ LL   : num [1, 1, 1:7, 1:2] -Inf 0.943 0.944 0.309 0.522 ...
#>   ..$ LL_IL: logi NA
#>  $ lesions     :List of 3
#>   ..$ perCase: num [1:7] 1 1 2 2 1 2 2
#>   ..$ IDs    : num [1:7, 1:2] 1 1 1 1 1 ...
#>   ..$ weights: num [1:7, 1:2] 1 1 0.5 0.5 1 ...
#>  $ descriptions:List of 7
#>   ..$ fileName     : chr "NA"
#>   ..$ type         : chr "FROC"
#>   ..$ name         : logi NA
#>   ..$ truthTableStr: logi NA
#>   ..$ design       : chr "FCTRL"
#>   ..$ modalityID   : chr "1"
#>   ..$ readerID     : chr "1"
```

It is seen to consist of three `list` members: `ratings`, `lesions` and `descriptions`. Let us examine the `ratings` member.

#### The structure of the ratings member

The `ratings` member is itself a list of 3, consisting of `NL` the non-lesion localization ratings, `LL` the lesion localization ratings and `LL_IL` the incorrect localization ratings. The last member is needed for LROC datasets and can be ignored for now. Let us examine the contents of the `NL` member.

#### The structure of the NL member


```r
frocDataRaw_1_5_7$ratings$NL[1,1,,]
#>             [,1]       [,2]       [,3] [,4]
#>  [1,]  0.7635935       -Inf       -Inf -Inf
#>  [2,] -0.7990092       -Inf       -Inf -Inf
#>  [3,]       -Inf       -Inf       -Inf -Inf
#>  [4,]       -Inf       -Inf       -Inf -Inf
#>  [5,]       -Inf       -Inf       -Inf -Inf
#>  [6,]       -Inf       -Inf       -Inf -Inf
#>  [7,] -0.2894616       -Inf       -Inf -Inf
#>  [8,] -0.2992151 -0.4115108       -Inf -Inf
#>  [9,]  0.2522234       -Inf       -Inf -Inf
#> [10,] -0.8919211       -Inf       -Inf -Inf
#> [11,]  0.4356833  0.3773956 -0.2242679 -Inf
#> [12,]  0.1333364       -Inf       -Inf -Inf
```

-   It is seen to be an array with dimensions `[1,1,1:12,1:4]`.

-   The first dimension corresponds to the number of modalities, one in this example, the second dimension corresponds to the number of readers, also one in this example. The third dimension is the total number of cases, $K_1+K_2 = 12$ in this example, because NLs are possible on *both* non-diseased and diseased cases.

-   The fourth dimension is 4, as the simulator generated, over 12 cases, a maximum of 4 latent NLs per case. This is demonstrated in the code output below, generated by temporarily setting $\zeta_1 = -\infty$, which results in all latent marks being marked. Specifically, case 11, the sixth diseased case, generated 4 NLs, but one of them, at position 4, had rating less than $\zeta_1 = -1$, and was consequently not marked, i.e., assigned a rating of $-\infty$.


```
#>             [,1]       [,2]       [,3]      [,4]
#>  [1,]  0.7635935       -Inf       -Inf      -Inf
#>  [2,] -0.7990092       -Inf       -Inf      -Inf
#>  [3,]       -Inf       -Inf       -Inf      -Inf
#>  [4,]       -Inf       -Inf       -Inf      -Inf
#>  [5,]       -Inf       -Inf       -Inf      -Inf
#>  [6,] -1.1476570       -Inf       -Inf      -Inf
#>  [7,] -0.2894616       -Inf       -Inf      -Inf
#>  [8,] -0.2992151 -0.4115108       -Inf      -Inf
#>  [9,]  0.2522234       -Inf       -Inf      -Inf
#> [10,] -0.8919211       -Inf       -Inf      -Inf
#> [11,]  0.4356833  0.3773956 -0.2242679 -1.237538
#> [12,]  0.1333364       -Inf       -Inf      -Inf
```

-   Note that all listed ratings are greater than $\zeta_1 = -1$.

-   Case 1, the first non-diseased case, has a single NL mark rated 0.7635935 and the remaining 3 locations are filled with $-\infty$s.

-   Case 6, the first diseased case, has zero NL marks and all 4 locations for it are filled with $-\infty$s.

-   Case 11, the sixth diseased case, has three NL marks rated 0.4356833, 0.3773956, -0.2242679 and the remaining location for it is $-\infty$. As noted above, this case generated a fourth rating that fell below $\zeta_1 = -1$.

#### The structure of the LL member


```r
frocDataRaw$ratings$LL[1,1,,]
#>           [,1]      [,2]
#> [1,]      -Inf      -Inf
#> [2,] 0.9428932      -Inf
#> [3,] 0.9438713      -Inf
#> [4,] 0.3090462      -Inf
#> [5,] 0.5218499      -Inf
#> [6,] 0.7642934      -Inf
#> [7,] 1.3876716 0.8972123
```

-   It is seen to be an array with dimensions `[1,1,1:7,1:2]`.

-   The first dimension corresponds to the number of modalities, one in this example, the second dimension corresponds to the number of readers, also one in this example. The third dimension is the total number of diseased cases, $K_2 = 7$ in this example, because LLs are only possible on diseased cases.

-   The fourth dimension is 2, as the maximum number of lesions per diseased case is 2.

-   Note that all listed ratings are greater than $\zeta_1 = -1$.

-   Case 1, the first diseased case, has zero LL marks and both locations are filled with $-\infty$s.

-   Case 2, the second diseased case, has one LL mark rated 0.9428932 and the remaining location is $-\infty$.

-   Case 7, the seventh diseased case, has two LL marks rated 1.3876716, 0.8972123 and zero locations with $-\infty$.

### Explanation of the code, continued

Returning to the explanation of the code in Section \@ref(raw-plots-code1):

-   Lines 23 - 25 use the `PlotEmpiricalOperatingCharacteristics` function to calculate the FROC plot object, which is saved to `p1`. Note the argument `opChType = "FROC"`, for the desired FROC plot.

-   Lines 28 - 31 use the `PlotEmpiricalOperatingCharacteristics` function to calculate the AFROC plot object, which is saved to `p2`. Note the argument `opChType = "AFROC"`.

-   Finally, lines 33 - 35 use the `PlotEmpiricalOperatingCharacteristics` function to calculate the ROC plot object, which is saved to `p3`. Note the argument `opChType = "ROC"`.

In summary, the code generates FROC, AFROC and ROC plots shown in the top row of Fig. \@ref(fig:froc-afroc-roc-raw-seed1). The discreteness, i.e., the relatively big jumps between data points, is due to the small numbers of cases. Increasing the numbers of cases to $K_1 = 50$ and $K_2 = 70$ yields the lower row of plots in Fig. \@ref(fig:froc-afroc-roc-raw-seed1). The fact that the upper row left plot does not seem to match the lower row left plot, especially near NLF = 0.25, is due to sampling variability with few cases.



![(\#fig:froc-afroc-roc-raw-seed1)Raw FROC, AFROC and ROC plots with seed = 1: the top row is for $K_1 = 5$ and $K_2 = 7$ cases while the bottom row is for $K_1 = 50$ and $K_2 = 70$ cases, details below](13-froc-empirical-examples_files/figure-latex/froc-afroc-roc-raw-seed1-1.pdf) 

Fig. \@ref(fig:froc-afroc-roc-raw-seed1) Raw FROC, AFROC and ROC plots with `seed` = 1: the top row is for $K_1 = 5$ and $K_2 = 7$ cases while the bottom row is for $K_1 = 50$ and $K_2 = 70$ cases. Model parameters are $\mu$ = 1, $\lambda$ = 1, $\nu$ = 1 and $\zeta_1$ = -1. The discreteness (jumps) in the upper row is due to the small number of cases. The decreased discreteness in the lower row is due to the larger numbers of cases. If the number of cases is increased further, the plots will approach continuous plots, like those shown in Chapter \@ref(froc-paradigm). Note that the AFROC and ROC plots are contained within the unit square, unlike the semi-constrained FROC plot.

#### Effect of seed on raw plots

Shown next are similar plots but this time `seed` = 2.





![(\#fig:froc-afroc-roc-raw-seed2)Raw FROC, AFROC and ROC plots with seed = 2: the top row is for $K_1 = 5$ and $K_2 = 7$ cases while the bottom row is for $K_1 = 50$ and $K_2 = 70$ cases, details below](13-froc-empirical-examples_files/figure-latex/froc-afroc-roc-raw-seed2-1.pdf) 

Fig. \@ref(fig:froc-afroc-roc-raw-seed2) Raw FROC, AFROC and ROC plots with `seed` = 2: the top row is for $K_1 = 5$ and $K_2 = 7$ cases while the bottom row is for $K_1 = 50$ and $K_2 = 70$ cases. Model parameters are $\mu$ = 1, $\lambda$ = 1, $\nu$ = 1 and $\zeta_1$ = -1. Note the large variability in the upper row plots as compared to those in Fig. \@ref(fig:froc-afroc-roc-raw-seed1). The effect of case-sampling variability is most apparent for small datasets.

### Key differences from the ROC paradigm:

-   In a ROC study, each case generates exactly one rating.

-   In a FROC study, each case can generate zero or more (0, 1, 2, ...) mark-rating pairs.

-   The number of marks per case is a random variable as is the rating of each mark.

-   Each mark corresponds to a distinct location on the image and associated with it is a rating, i.e., confidence level in presence of disease at the region indicated by the mark.

-   In the ROC paradigm, each non-diseased case generates one FP and each diseased case generates one TP.

-   In a FROC study, each non-diseased case can generate zero or more NLs and each diseased case can generate zero or more NLs and zero or more LLs.

-   The number of lesions in the case limits the number of LLs.

## The chance level FROC and AFROC

The chance level FROC was addressed in the previous chapter; it is a "flat-liner", hugging the x-axis, except for a slight upturn at large NLF.



![(\#fig:froc-afroc-chance-level)The left figure is the near guessing observer's FROC and the right figure is the corresponding AFROC for $\mu=0.01$.](13-froc-empirical-examples_files/figure-latex/froc-afroc-chance-level-1.pdf) 

Fig. \@ref(fig:froc-afroc-chance-level) shows "near guessing" FROC and AFROC plots for $\mu = 0.1$. These plots were generated by the code with $\mu$ = 0.1, $\lambda$ = 1, $\nu$ = 0.1, $\zeta_1$ = -1, $K_1$ = 50, $K_2$ = 70. One does not expect to observe curves like these with radiologists as they rarely guess in the clinic -- there is too much at stake.

The AFROC of a guessing observer is not the line connecting (0,0) to (1,1) [@RN2518]. A guessing observer will also generate a "flat-liner", but this time the plot ends at FPF = 1, and the straight line extension will be a vertical line connecting this point to (1,1). In the limit $\mu \rightarrow 0+$, AFROC-AUC tends to zero.

*To summarize, AFROC AUC of a guessing observer is zero.* On the other hand, suppose an expert radiologist views screening images and the lesions on diseased cases are very difficult, even for the expert, and the radiologist does not find any of them. Being an expert the radiologist successfully screens out non-diseased cases and sees nothing suspicious in any of them -- this is a measure of the expertise of the radiologist, not mistaking variants of normal anatomy for false lesions on non-diseased cases. Accordingly, the expert radiologist does not report anything, and the operating point is "stuck" at the origin. Even in this unusual situation, one would be justified in connecting the origin to (1,1) and claiming area under AFROC is 0.5. The extension gives the radiologist credit for not marking any non-diseased case; of course, the radiologist does not get any credit for marking any of the lesions. An even better radiologist, who finds and marks some of the lesions, will score higher, and AFROC-AUC will exceed 0.5. See TBA §17.7.4 for a software demonstration of this unusual situation.

## Location-level "true-negatives"

The quotes are intended to draw attention to confusion that can result when one inappropriately applies ROC terminology to the FROC paradigm. For the 5 / 7 dataset, seed = 1, and reporting threshold set to -1, the first non-diseased case has one NL rated 0.7635935. The remaining three entries for this case are filled with $-\infty$.

What really happened is only known if one has access to the internals of the simulator. To the data analyst the following possibilities are indistinguishable:

-   Four latent NLs, one of whose ratings exceeded $\zeta_1$, i.e., three location-level "true negatives" occurred on this case.
-   Three latent NLs, one of whose ratings exceeded $\zeta_1$, i.e., two location-level "true negatives" occurred on this case.
-   Two latent NLs, one of whose ratings exceeded $\zeta_1$, i.e., one location-level "true negative" occurred on this case.
-   One latent NL, whose rating exceeded $\zeta_1$, i.e., 0 location-level "true negatives" occurred on this case.

The second non-diseased case has one NL mark rated -0.7990092 and similar ambiguities occur regarding the number of latent NLs. The third, fourth and fifth non-diseased cases have no marks. All four locations-holders on each of these cases are filled with $-\infty$, which indicates un-assigned values corresponding to either absence of any latent NL or presence of one or more latent NLs that did not exceed $\zeta_1$ and therefore did not get marked.

To summarize: absence of an actual NL mark, indicated by a $-\infty$ rating, could be due to either (i) non-occurrence of the corresponding latent NL or (ii) occurrence of the latent NL but its rating did not exceed $\zeta_1$. One cannot distinguish between the two possibilities, as in either scenario, the corresponding rating is assigned the $-\infty$ value and either scenario would explain the absence of a mark.

For those who insist on using ROC terminology to describe FROC data the second possibility would be termed a location level True Negative ("TN"). Their "logic" is as follows: there was the possibility of a NL mark, which they term a "FP", but the observer did not make it. Since the complement of a FP event is a TN event, this was a TN event. However, as just shown, one cannot tell if it was a "TN" event or there was no latent event in the first place. Here is the conclusion: there is no place in the FROC lexicon for a location level "TN".

If $\zeta_1$ = $-\infty$ then all latent marks are actually marked and the ambiguities mentioned above disappear. As noted previously, when this change is made one confirms that there were actually four latent NLs on the sixth diseased case (the eleventh sequential case), but the one rated -1.237538 fell below $\zeta_1 = -1$ and was consequently not marked.

So one might wonder, why not ask the radiologists to report everything they see, no matter now low the confidence level? Unfortunately, that would be contrary to their clinical task, where there is a price to pay for excessive NLs. It would also be contrary to a principle of good experimental design: one should keep interference with actual clinical practice, designed to make the data easier to analyze, to a minimum.

## Binned FROC/AFROC/ROC plots

In the preceding example, continuous ratings data was available and data binning was not employed. Shown next is the code for generating the plots when the data is binned.

### Code for binned plots {#binned-plots-code1}


```{.r .numberLines}
seed <- 1;set.seed(seed)
zeta1 <- -1
K1 <- 5
K2 <- 7 
Lmax <- 2
Lk2 <- floor(runif(K2, 1, Lmax + 1))

frocDataRaw <- SimulateFrocDataset(
  mu = mu, 
  lambda = lambda, 
  nu = nu, 
  I = 1,
  J = 1,
  K1 = K1, 
  K2 = K2, 
  perCase = Lk2, 
  zeta1 = zeta1
)

frocDataBinned <- DfBinDataset(
  frocDataRaw, 
  desiredNumBins = 5,
  opChType = "FROC")

p1 <- PlotEmpiricalOperatingCharacteristics(
  dataset = frocDataBinned, 
  trts= 1, rdrs = 1, opChType = "FROC", 
  legend.position = "NULL")$Plot

p2 <- PlotEmpiricalOperatingCharacteristics(
  dataset = frocDataBinned, 
  trts= 1, rdrs = 1, opChType = "AFROC", 
  legend.position = "NULL")$Plot

p3 <- PlotEmpiricalOperatingCharacteristics(
  dataset = frocDataBinned, 
  trts= 1, rdrs = 1, opChType = "ROC", 
  legend.position = "NULL")$Plot
#> Warning in min(c(NL[NL != UNINITIALIZED], LL[LL != UNINITIALIZED])): no non-
#> missing arguments to min; returning Inf
```

This is similar to the code for the raw plots except that at lines 20-23 we have used the function `DfBinDataset` to bin the raw data `frocDataRaw` and the binned data is saved to `frocDataBinned`, which is used in the subsequent plotting routines. Note the arguments `desiredNumBins` and `opChType`. The binning function needs to know the desired number of bins (set to 5 in this example) and the operating characteristic that the binning is aimed at (here set to "FROC").



![(\#fig:froc-afroc-roc-binned-seed1)Binned FROC, AFROC and ROC plots with seed = 1: the top row is for $K_1 = 5$ and $K_2 = 7$ cases while the bottom row is for $K_1 = 50$ and $K_2 = 70$ cases, details below](13-froc-empirical-examples_files/figure-latex/froc-afroc-roc-binned-seed1-1.pdf) 

#### Effect of seed on binned plots

Shown next are corresponding plots with `seed` = 2.





![(\#fig:froc-afroc-roc-binned-seed2)Binned FROC, AFROC and ROC plots with seed = 2: the top row is for $K_1 = 5$ and $K_2 = 7$ cases while the bottom row is for $K_1 = 50$ and $K_2 = 70$ cases, details below](13-froc-empirical-examples_files/figure-latex/froc-afroc-roc-binned-seed2-1.pdf) 

### Structure of the binned data


```r
str(frocDataBinnedSeed1$ratings$NL)
#>  num [1, 1, 1:120, 1:18] 4 4 4 5 4 4 3 3 3 4 ...
str(frocDataBinnedSeed1$ratings$LL)
#>  num [1, 1, 1:70, 1:2] -Inf -Inf -Inf 1 3 ...
table(frocDataBinnedSeed1$ratings$NL)
#> 
#> -Inf    1    2    3    4    5 
#> 1177  365  122  366  123    7
sum(as.numeric(table(frocDataBinnedSeed1$ratings$NL)))
#> [1] 2160
table(frocDataBinnedSeed1$ratings$LL)
#> 
#> -Inf    1    2    3 
#>  132    4    1    3
sum(as.numeric(table(frocDataBinnedSeed1$ratings$LL)))
#> [1] 140
sum(Lk2Seed1)
#> [1] 104
sum(Lk2Seed1) - sum(as.vector(table(frocDataBinnedSeed1$ratings$LL))[2:6])
#> [1] NA
```

The `table()` function converts an array into a counts table. In the first usage, there are 120 x 4 = 480 elements in the array. From the output of `table(frocDataBinnedSeed1$ratings$NL)` one sees that there are 378 entries in the NL array that equal $-\infty$, 50 that equal 1, etc. These sum to 480. Because the fourth dimension of the NL array is determined by cases with the most NLs, therefore, on cases with fewer NLs, this dimension is "padded" with $-\infty$s. One does not know how many of the 378 $-\infty$s are latent NLs. The actual number of latent NLs could be considerably smaller, and the number of marked NLs even smaller, as this is determined by $\zeta_1$. The last three statements are important to understand and will be further explained below.

The LL array contains 70 x 2 = 140 values. From the output of `table(frocDataBinnedSeed1$ratings$lL)` one sees that there are 78 entries in the LL array that equal $-\infty$, 10 entries that equal 1, etc. These sum to 140. Since the total number of lesions is 104, the number of unmarked lesions is known. Specifically, summing the LL counts in bins 1 through 5 (corresponding to indices 2-6, since index 1 applies to the $-\infty$s) and subtracting from the total number of lesions one gets: 104 -- (10+5+8+35+4) = 104 -- 62 = 42, see last line of above code output. Therefore, the number of unmarked lesions is 42. The listed value 78, is an overestimate because it includes the $-\infty$ counts from the fourth dimension $-\infty$ "padding" of the `LL` array. This happens because some other diseased case had lesions in those location-holders.

## Discussion {#froc-empirical-examples-Discussion}
TBA

## References {#froc-empirical-examples-references}