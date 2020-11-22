


# Standalone CAD vs. Radiologists {#standalone-cad-radiologists}

## Abstract {#standalone-cad-radiologists-abstract}
Computer aided detection (CAD) research for screening mammography has so far focused on measuring performance of radiologists with and without CAD. Standalone performance of CAD algorithms is rarely measured. One reason is the lack of clear methodology for comparing CAD to radiologists interpreting the same cases. This work extends the method used in a recent study of standalone performance. The method is termed random-reader fixed case (RRFC), since it only accounts for reader variability. The extension includes the effect of case-sampling variability. Since CAD is treated as an additional reader, the method is termed one-treatment random-reader random-case (1T-RRRC) analysis. The new method is based on existing methodology that allows comparing the average performance of readers in a single treatment to a constant value. The key modification is to regard the difference in performance between radiologists and CAD as a figure of merit, to which the existing work is directly applicable. The 1T-RRRC method was compared to RRFC and to an unorthodox usage of standard ROC analysis software, termed 2T-RRRC analysis, which involves replicating the CAD ratings as many times as there are radiologists, to simulate a second treatment, i.e., CAD is regarded as the second treatment. 1T-RRRC analysis has 3 random parameters as compared to 6 parameters in 2T-RRRC and one parameter in RRFC. As expected, since one is including an additional source of variability, both RRRC analyses (1T and 2T) yielded larger p-values and wider confidence intervals as compared to RRFC. For the F-statistic, degrees of freedom and p-value, both 1T-RRRC and 2T-RRRC analyses yielded exactly the same results. However, 2T-RRRC model parameter estimates were unrealistic; for example, it yielded zero for between-reader variance, whereas 1T-RRRC yielded the expected non-zero value, identical to that yielded by RRFC. The method is implemented in an open-source `R` package `RJafroc.` 

## Keywords {#standalone-cad-radiologists-ker-words}
Technology assessment, computer-aided detection (CAD), screening mammography, standalone performance, single-treatment multi-reader ROC analysis. 

## Introduction {#standalone-cad-radiologists-introduction}
In the US the majority of screening mammograms are analyzed by computer aided detection (CAD) algorithms1. Almost all major imaging device manufacturers provide CAD as part of their imaging workstation display software. In the United States, CAD is approved for use as a second reader2, i.e., the radiologist first interprets the images (typically 4 views, 2 views of each breast) without CAD and then CAD information (i.e., cued suspicious regions, possibly shown with associated probabilities of malignancies) is shown and the radiologist has the opportunity to revise the initial interpretation. 

The evolution of CAD algorithms has been guided mainly by comparing observer performance of radiologists with and without CAD. Clinical CAD systems sometimes only report the locations of suspicious regions, i.e., it may not provide ratings. However, a (continuous variable) malignancy index for every CAD-found suspicious region, or region of interest (ROI), is available to the algorithm designer3. Standalone performance, i.e., performance of designer-level CAD by itself, regarded as an algorithmic reader, vs. radiologists, is rarely measured. In breast cancer screening the authors are aware of only one study4 where standalone performance was measured. [Standalone performance has been measured in CAD for computed tomography colonography, chest radiography and three dimensional ultrasound5-9.] 

One reason for not measuring standalone performance of CAD is lack of an assessment tool for such measurements. The purpose of this work is to remove that impediment. It describes a method to compare standalone performance of designer-level CAD to radiologists interpreting the same cases and compares the method to those described in two recent publications4,10. 

## Methods {#standalone-cad-radiologists-methods}
Summarized are two recent studies of CAD vs. radiologists in mammography. This is followed by comments on the methodologies used in the two studies. The second study uses standard ROC software in an unorthodox or unconventional way. The statistical model underlying the analysis in the second study is summarized. A new method is described that avoids unorthodox usage of software and has fewer model parameters. Computational details of software implementing all three methods are summarized.

### Studies assessing performance of CAD vs. radiologists {#standalone-cad-radiologists-two-previous-studies}
The first study [@hupse2013standalone] measured performance in finding and localizing lesions in mammograms, i.e., search was involved, while the second study [@kooi2016comparison] measured lesion classification performance between non-diseased and diseased ROIs) previously found on mammograms by an independent algorithmic reader. 

#### Study - 1 {#standalone-cad-radiologists-study1}
The first study [@hupse2013standalone] compared standalone performance of a CAD device to that of 9 radiologists interpreting the same cases (120 non-diseased and 80 with a single malignant mass per case). It used the LROC paradigm [@metz1976observer; @starr1975visual; @swensson1996unified], in which the observer gives an overall rating for presence of disease (an integer 0 to 100 scale was used) and indicates the location of the most suspicious region. On non-diseased cases the rating is classified as a false positive (FP), but on a diseased case the rating is classified as a correct localization (CL) if the location is sufficiently close to the lesion, and otherwise it is classified as an incorrect localization. For a given reporting threshold, the number of correct localizations divided by the number of diseased cases estimates the probability of correct localization (PCL) at that threshold. On non-diseased cases, the number of false positives (FPs) divided by the number of non-diseased cases estimates the probability of a false positive, or false positive fraction (FPF) at that threshold. The plot of PCL (ordinate) vs. FPF defines the LROC curve. Study - 1 used as figures of merit (FOMs) the interpolated PCL at two values of FPF, specifically FPF = 0.05 and FPF = 0.2, denoted $\text{PCL}_{0.05}$ and $\text{PCL}_{0.2}$, respectively. The t-test between the observed radiologist $\text{PCL}_{\text{FPF}}$ values and that of CAD was used to compute the two-sided p-value for rejecting the NH of equal performance. Study - 1 reported p-value = 0.17 for $\text{PCL}_{0.05}$ and p-value < 0.001, with CAD being inferior, for $\text{PCL}_{0.2}$. 

#### Study - 2 {#standalone-cad-radiologists-study2}
The second study [@kooi2016comparison] used 199 diseased and 199 non-diseased ROIs extracted by an independent CAD algorithm. These were interpreted using the ROC paradigm, using a different CAD algorithmic observer (convolution neural network based) from that used to determine the ROIs, and 4 expert radiologists. Again, an integer 0 to 100 rating scale was used. The figure of merit was the area (AUC) under the respective ROC curves (one per radiologist and one for CAD). The p-value for the difference in AUCs between the average radiologist and CAD was determined using an unorthodox application of the Dorfman-Berbaum-Metz [@dorfman1992receiver] multiple-reader multiple-case (DBM-MRMC) software with Hillis' modifications [@hillis2007comparison; @hillis2008recent], namely, *in the input data file radiologists and CAD were entered as two modalities*. In standard (or orthodox) DBM-MRMC, the data file consists, for example, of ratings of a set of cases by 4 readers in two modalities, i.e., each reader provides two ratings per case. To accommodate the paired data structure assumed by the software, the authors of Study - 2 *replicated the CAD ratings four times in the data file*, as explained in the caption to Table 1, in which sample ratings are only shown for the first and last radiologist and the first and last case. By this artifice they converted a single-treatment 5-reader (4 radiologists plus CAD) data file to a two-treatment 4-reader data file, in which the four readers in treatment 1 were the radiologists, and the four readers in treatment 2 were CAD. Note that the four readers in the second treatment yield identical ratings, since each is a replica of CAD. In the right half of Table 1 the replicated CAD observers are labeled C1, C2, C3 and C4. 

Table 1: This table explains the differences between the data structures in standard DBM-MRMC analysis and the unorthodox application of the software used in Study - 2. There are four radiologists, labeled R1, R2, R3 and R4 interpreting 398 cases (actually ROIs), labeled 1, 2, …, 398, in two modalities, labeled 1 and 2. Sample ratings are shown only for the first and last radiologist and the first and last case. In the left half of the table, labeled Standard DBM-MRMC, each radiologist interprets each case twice. In the right half of the table, labeled Unorthodox DBM-MRMC, the radiologists interpret each case once. CAD ratings are replicated four times to effectively create the second "treatment" or modality. The quotations are used to emphasize that there is, in fact, only one treatment. The replicated CAD observers are labeled C1, C2, C3 and C4.



Table: (\#tab:standalone-cad-table-standard)This table explains the differences between the data structures in standard DBM-MRMC analysis and the unorthodox application of the software used in Study - 2. There are four radiologists, labeled R1, R2, R3 and R4 interpreting 398 cases (actually ROIs), labeled 1, 2, …, 398, in two modalities, labeled 1 and 2. Sample ratings are shown only for the first and last radiologist and the first and last case. In the left half of the table, labeled Standard DBM-MRMC, each radiologist interprets each case twice. In the right half of the table, labeled Unorthodox DBM-MRMC, the radiologists interpret each case once. CAD ratings are replicated four times to effectively create the second "treatment" or modality. The quotations are used to emphasize that there is, in fact, only one treatment. The replicated CAD observers are labeled C1, C2, C3 and C4.

|Reader |Treatment |Case |Rating |Reader |Treatment |Case |Rating |
|:------|:---------|:----|:------|:------|:---------|:----|:------|
|R1     |1         |1    |75     |R1     |1         |1    |75     |
|...    |...       |...  |...    |...    |...       |...  |...    |
|R1     |1         |398  |0      |R1     |1         |398  |0      |
|...    |...       |...  |...    |...    |...       |...  |...    |
|R4     |1         |1    |50     |R4     |1         |1    |50     |
|...    |...       |...  |...    |...    |...       |...  |...    |
|R4     |1         |398  |25     |R4     |1         |398  |25     |
|R1     |2         |1    |45     |C1     |2         |1    |55     |
|...    |...       |...  |...    |...    |...       |...  |...    |
|R1     |2         |398  |25     |C1     |2         |398  |5      |
|...    |...       |...  |...    |...    |...       |...  |...    |
|R4     |2         |1    |95     |C4     |2         |1    |55     |
|...    |...       |...  |...    |...    |...       |...  |...    |
|R4     |2         |398  |20     |C4     |2         |398  |5      |



Study  – 2 reported a not significant difference between CAD and the radiologists (p = 0.253). 

#### Comments {#standalone-cad-radiologists-comments}
For the purpose of this work, which focuses on the respective analysis methods, the difference in observer performance paradigms between the two studies, namely a search paradigm in Study - 1 vs. an ROI classification paradigm in Study – 2, is inconsequential. The paired t-test used in Study - 1 treats the case-sample as fixed11. In other words, the analysis is not accounting for case-sampling variability but it is accounting for reader variability. While not explicitly stated, the reason for the unorthodox analysis in Study – 2 was the desire to include case-sampling variability. ^[Prof. Karssemeijer (private communication, 10/27/2017) had consulted with a few ROC experts to determine if the procedure used in Study – 2 was valid, and while the experts thought it was probably valid they were not sure.]

In what follows, the analysis in Study – 1 is referred to as random-reader fixed-case (RRFC) while that in Study – 2 is referred to as dual-treatment random-reader random-case (2T-RRRC).

### The 2T-RRRC analysis model {#standalone-cad-radiologists-2TRRRC-anlaysis}

The following approach uses the Obuchowski and Rockette (OR) figure of merit model18 for analyzing MRMC ROC studies, instead of  the pseudovalue model used in the original DBM paper15. Hillis has shown the two to be equivalent19. For fully paired multiple-reader multiple-treatment interpretations (i.e., assuming the data structure in the left half of Table 1) the OR model is:

\begin{equation}
\theta_{ij\{c\}}=\mu+\tau_i+\left ( \tau \text{R} \right )_{ij}+\epsilon_{ij\{c\}}
(\#eq:standalone-cad-model)
\end{equation}


Assuming two treatments, i (i = 1, 2) is the treatment index, j (j = 1, ..., J) is the radiologist index, and k (k = 1, ..., K) is the case index, and   is a figure of merit for reader j in treatment i and case-sample  . A case-sample is a set or ensemble of cases, diseased and non-diseased, and different integer values of c correspond to different case-samples. The first two terms on the right hand side of Eqn. (1) are fixed effects (average performance and treatment effect, respectively). The next two terms are random effect variables that, by assumption, are sampled as follows:

\begin{equation}
\left.
\begin{aligned}  
R_j \sim  N\left ( 0,\sigma_R^2 \right )\\
\left ( \tau R \right )_{ij} \sim N\left ( 0,\sigma_{\tau R}^2 \right )\\
\end{aligned}
\right \}
(\#eq:standalone-cad-model-sampling)
\end{equation}


The terms   represents the random treatment-independent contribution of reader j, modeled as a sample from a zero-mean normal distribution with variance  ,  represents the random treatment-dependent contribution of reader j in treatment i, modeled as a sample from a zero-mean normal distribution with variance  . The sampling of the last (error) term is described by:

\begin{equation}
\epsilon_{ij\{c\}}\sim N_{I \times J}\left ( \vec{0} , \Sigma \right )
(\#eq:standalone-cad-eps-sampling)
\end{equation}


Here $N_{I \times J}$ is the $I \times J$  variate normal distribution and $\vec{0}$ denotes the  $I \times J$  length zero-vector. The covariance matrix $\Sigma$ is defined by 4 parameters, $Var$, $Cov_1$, $Cov_2$, $Cov_3$, defined as follows18:

\begin{equation}
Cov(\epsilon_{ij\{c\}},\epsilon_{i'j'\{c\}}) =
\left\{\begin{matrix}
\text{Var} \; (i=i',j=j') \\
\text{Cov1} \; (i\ne i',j=j')\\ 
\text{Cov2} \; (i = i',j \ne j')\\ 
\text{Cov3} \; (i\ne i',j \ne j')
\end{matrix}\right\}
(\#eq:standalone-cad-or-cov)
\end{equation}

Software {U of Iowa and `RJafroc`} yields estimates of all terms appearing on the right hand side of Eqn. \@ref(eq:standalone-cad-or-cov). Excluding fixed effects, the model represented by Eqn. \@ref(eq:standalone-cad-model) contains six parameters: 

\begin{equation}
\sigma_R^2, \sigma_{\tau R}^2, Var, Cov_1, Cov_2, Cov_3
(\#eq:standalone-var-comp)
\end{equation}

The meanings the last four terms are described in [@hillis2007comparison; @obuchowski1995hypothesis; @hillis2005comparison; @chakraborty2017observer]. Briefly, $Var$ is the variance of a reader's FOMs, in a given treatment, over interpretations of different case-samples, averaged over readers and treatments; $Cov_1/Var$ is the correlation of a reader's FOMs, over interpretations of different case-samples in different treatments, averaged over all different treatment same reader pairings; $Cov_2/Var$ is the correlation of different reader's FOMs, over interpretations of different case-samples in the same treatment, averaged over all same treatment different reader pairings and finally, $Cov_3/Var$ is the correlation of different reader's FOMs, over interpretations of different case-samples in different treatments, averaged over all different treatment different reader pairings. One expects the following inequalities to hold:

\begin{equation}
Var \geq Cov_1 \geq Cov_2 \geq Cov_3
(\#eq:standalone-var-comp-ordering)
\end{equation}


In practice, since one is usually limited to one case-sample, i.e., $\{1\}$, resampling techniques [@efron1994introduction] -- e.g., the jackknife -- are used to estimate these terms.

### Random-reader random-case (1T-RRRC) analysis {#standalone-cad-radiologists-1TRRRC-anlaysis}

In this work standalone CAD is regarded as an algorithmic reader, not a different treatment. Therefore, needed is a single treatment method for analyzing readers and CAD, where the latter is regarded as an additional treatment TBA 25. The method should account for both reader variability and case variability. The proposed method is termed single-treatment RRRC (1T-RRRC) analysis. The cited reference uses as the starting point the [@obuchowski1995hypothesis] model, which for the radiologists (i.e., *excluding* CAD) interpreting in a single-treatment reduces to the following Eqn.:

\begin{equation}
\theta_{j\{c\}}=\mu+R_j+\epsilon_{j\{c\}}
(\#eq:standalone-or-model-single-treatment)
\end{equation}

$\theta_{j\{c\}}$ is the figure of merit for radiologist $j$ ($j = 1, 2, ..., J$) interpreting case-sample $\{c\}$; $R_j$ is the random effect of radiologist $j$ and $\epsilon_{j\{c\}}$ is the error term. For single-treatment multiple-reader interpretations the error term is distributed as:
  
\begin{equation}
\epsilon_{j\{c\}}\sim N_{J}\left ( \vec{0} , \Sigma \right )
(\#eq:standalone-cad-eps-sampling-single-treatment)
\end{equation}

The $J \times J$ covariance matrix $\Sigma$ is defined by two parameters, $Var$ and $Cov_2$, as follows:  

\begin{equation}
\Sigma_{jj'} = \text{Cov}\left ( \epsilon_{j\{c\}}, \epsilon_{j'\{c\}} \right )
=
\left\{\begin{matrix}
Var & j = j'\\ 
Cov_2 & j \neq j'
\end{matrix}\right.
(\#eq:standalone-cad-var-cov2-single-treatment)
\end{equation}

The terms $Var$ and $Cov_2$ are estimated using resampling methods. Using the jackknife, and denoting the difference FOM with case k removed by $\psi_{j(k)}$  (the index in parenthesis denotes deleted case $k$, and since one is dealing with a single case-sample, the case-sample index $c\{c\}$ is superfluous). The covariance matrix is estimated using (the dot symbol represents an average over the replaced index): 

\begin{equation}
\Sigma_{jj'}|_\text{jack} = \frac{K-1}{K} \sum_{k=1}^{K} \left ( \psi_{j(k)}  - \psi_{j(\bullet)} \right ) \left ( \psi_{j'(k)}  - \psi_{j'(\bullet)} \right )
(\#eq:standalone-cad-single-treatment-sigma-jackknife)
\end{equation}


The final estimates of $Var$ and $Cov_2$ are averaged (indicated in the following equation by the angular brackets) over all pairings of radiologists satisfying the relevant equalities/inequalities shown just below the closing angular bracket:


\begin{equation}
\left.
\begin{aligned}  
Var = \left \langle \Sigma_{jj'}|_{\text{jack}} \right \rangle_{j=j'}\\
Cov_2 = \left \langle \Sigma_{jj'}|_{\text{jack}} \right \rangle_{j \neq j'}
\end{aligned}
\right \}
(\#eq:standalone-cad-final-estimates-var-cov2)
\end{equation}


Hillis' formulae16,19 permit one to test the NH:  , where   is a pre-specified constant. One could set   equal to the performance of CAD, but that would not be accounting for the fact that the performance of CAD is itself a random variable, whose case-sampling variability needs to be accounted for.

Instead, the following model was used for the figure of merit of the radiologists and CAD (j = 0 is used to denote the CAD algorithmic reader): 

Insert Eqn. 12 here:

  is the CAD figure of merit for case-sample  ;   is the average figure of merit increment of the radiologists over CAD. To reduce this model to one to which existing formulae16,19 are directly applicable, one subtracts the CAD figure of merit from each radiologist's figure of merit (for the same case-sample), and defines this as the difference figure of merit  , i.e., 
  
Insert Eqn. 13 here:

Then Eqn. (12) reduces to: 

Insert Eqn. 14 here:

Eqn. (14) is identical in form to Eqn. (7) with the subtle difference that the figure of merit on the left hand side of Eqn. (14) is a difference FOM, that between the radiologist's and CAD. Eqn. (14) describes a model for J difference radiologists interpreting a common case set, each of whose performances is a difference from that of CAD; the difference is positive if the radiologist is better. Under the NH the expected difference is zero:  . The method16,19 for single-treatment multiple-reader analysis is now directly applicable to the model described by Eqn. (14) . Detailed computational formulae are presented in the cited references and reference 11. 

Apart from fixed effects, the model in Eqn. (14) contains three parameters:

Insert Eqn. 15 here:

Setting   yields the RRFC model, which contains only one random parameter, namely  . In other words, a valid analysis should yield identical estimates of this parameter from either RRFC or RRRC analysis.

### Computational details {#standalone-cad-radiologists-computational-details}
The three analyses, namely random-reader fixed-case (RRFC), dual-treatment random-reader random-case (2T-RRRC) and single-treatment random-reader random-case (1T-RRRC), are implemented in RJafroc, an R-package21. The function calls necessary to reproduce the results that follow are in the Appendix. [The PT-Mono font is used to distinguish software specific terms from normal text.]

## Results {#standalone-cad-radiologists-results}
The three methods, in historical order RRFC, 2T-RRRC and 1T-RRRC, were applied to an LROC dataset similar to that used in Study – 1 (DPC thanks Prof. Karssemeijer for making this dataset available, which enabled this study). 

The primary results (as distinct from model parameters) are listed in Table 2 for four FOMs, namely  ,  ,   and the empirical area (AUC) under the ROC curve. The first two FOMs are identical to those used in Study – 1. Columns 3 and 4 list the CAD FOM  , and its 95% confidence interval  , columns 5 and 6 list the average radiologist FOM   (the dot symbol represents an average over the radiologist index) and its 95% confidence interval  , columns 7 and 8 list the average difference FOM  , i.e., radiologist minus CAD, and its 95% confidence interval  , and the last three columns list the F-statistic, the denominator degrees of freedom (ddf) and the p-value for rejecting the null hypothesis. The numerator degree of freedom (ndf) of the F-statistic, not listed, is unity.

{Table 2 goes here}

 
The most relevant results, in the last three columns, are that 2T-RRRC and 1T-RRRC yield identical F-statistics, ddf and p-values. So the intuition of the authors of Study – 2, that the unorthodox method of using DBM – MRMC software to account for both reader and case-sampling variability, turns out to be correct. Therefore, if interest is solely in these statistics, one is justified in using the unorthodox method. 

Commented on next are other aspects of the results evident in Table 2. 
1.	Where a direct comparison is possible, namely RRFC analysis using   and  as FOMs, the p-values in Table 2 are similar to those reported in Study – 1.
2.	All FOMs (i.e.,  ,   and  ) in Table 2 are independent of the method of analysis. However, the corresponding confidence intervals (i.e.,  ,   and  ) depend on the analyses.
3.	Since RRFC analysis ignores case sampling variability, the CAD figure of merit is a constant, with zero-width confidence interval. For compactness the CI is listed as 0, rather than two identical values in parentheses. The confidence interval listed for 2T-RRRC analyses is centered on the corresponding CAD value, as are all confidence intervals in Table 2.
4.	The LROC FOMs increase as the value of FPF (the subscript) increases. This should be obvious, as PCL increases as FPF increases, a general feature of any partial curve based figure of merit. 
5.	The area (AUC) under the ROC is larger than the largest PCL value, i.e., AUC >  . This too should be obvious from the general characteristic of the LROC14.
6.	The p-value for either RRRC analyses (2T or 1T) is larger than the corresponding RRFC value. Accounting for case-sampling variability increases the p-value, leading to less possibility of finding a significant difference. 
7.	Partial curve-based FOMs, such as  , lead, depending on the choice of FPF, to different conclusions. The p-values generally decrease as FPF increases. Measuring performance on the steep part of the LROC curve (i.e., small FPF) needs to account for greater reader variability and risks potentially lower statistical power.
8.	Ignoring localization information (i.e., using the AUC FOM) led to a not-significant difference between CAD and the radiologists (p = 0.3210), while the corresponding   FOM yielded a significant difference (p = 0.0409). Accounting for localization leads to a less "noisy" measurement. Swensson has demonstrated this for the LROC paradigm14 and one of the authors (DPC) has demonstrated this for the FROC paradigm22.
9.	For 1T-RRRC analysis,   is listed as NA, for not applicable, since   is not a model parameter, see Eqn. (14).

The following characteristics are evident from Table 2.
1.	For 2T-RRRC analyses  . Actually, the analysis yielded very small values, of the order of 10-18 to 10-19, which, being smaller than double precision accuracy, were replaced by zeroes in Table 2. [All current implementations of R use IEC 60559 floating-point (i.e., double precision) arithmetic, for which the precision is 2.22 x 10-16.]   is clearly an unphysical result as the radiologists do not have identical performance. In contrast, 1T-RRRC analyses yielded more realistic values, identical to those obtained by RRFC analyses, and consistent with expectation – see comment following Eqn. (15). 
2.	Because 2T analysis found zero reader variability, it follows from the definitions of the covariances18, that  , as evident in the table.
3.	When they can be compared (i.e.,  ,   and  ), all variance and covariance estimates were smaller for the 2T method than for the 1T method.
4.	For the 2T method the expected inequalities, Eqn. (6), are not obeyed (specifically,  , is not obeyed).

Table 2: Model parameter estimates for the three types of analyses summarized in Table 2. [NA = not applicable; the variances and covariances are defined in Eqn. (2) and Eqn. (3)]

Table 2 goes here.

For an analysis method to be considered statistically valid it needs to be tested with simulations to determine if it has the proper null hypothesis behavior. The design of a ratings simulator to statistically match a given dataset is addressed in Chapter 23 of reference 11. Using this simulator, the 1T-RRRC method had the expected null hypothesis behavior (Table 23.5, ibid).  

## Discussion {#standalone-cad-radiologists-discussion}
The argument often made for not measuring standalone performance is that since CAD will be used only as a second reader, it is only necessary to measure performance of radiologists without and with CAD. It has been stated23: “high stand-alone performance is neither a necessary nor a sufficient condition for CAD to be truly useful clinically”. In the author's opinion, measuring performance with and without CAD has set a low bar for CAD to be considered useful. As examples, CAD is not penalized for missing cancers as long as the radiologist finds them and CAD is not penalized for excessive false positives (FPs) as long as the radiologist ignores them. 

Described is an extension of the analysis used in Study – 1 that accounts for case sampling variability. It extends Hillis' single-treatment analysis to a situation where one of the "readers" is a special reader, and the desire is to compare performance of this reader to the average of the remaining readers. The method, along with two other methods, was used to analyze an LROC data set using different figures of merit. 

1T-RRRC analyses yielded identical overall results (specifically the F-statistic, degrees of freedom and p-value) to those yielded by the unorthodox application of DBM-MRMC software, termed 2T-RRRC analyses, where the CAD reader is regarded as a second treatment. However, the values of the model parameters of the dual-treatment analysis lacked clear physical meanings. In particular, the result   is clearly an artifact. One can only speculate as to what happens when software is used in a manner that it was not intended for: perhaps finding that all readers in the second treatment have identical FOMs led the software to yield  . The single-treatment model has half as many parameters as the dual-treatment model and the parameters have clear physical meanings and the values are realistic.

The paradigm used to collect the observer performance data  - e.g., receiver operating characteristic (ROC)24, free-response ROC (FROC)25, location ROC (LROC)12-14 or region of interest (ROI)26 - is irrelevant – all that is needed is a scalar performance measure for the actual paradigm used. In addition to PCL and AUC, RJafroc currently implements the partial area   under the LROC, from FPF = 0 to a specified value as well other FROC-paradigm based FOMs.

While there is consensus that CAD works for microcalcifications, for masses its performance is controversial27,28. Two large clinical studies29,30 (222,135 and 684,956 women, respectively) showed that CAD actually had a detrimental effect on patient outcome. A more recent large clinical study has confirmed the negative view of CAD31 and there has been a call for ending Medicare reimbursement for CAD interpretations32. 

In the authors' opinion standalone performance is the most direct measure of CAD performance. Its neglect could be a reason for the current disappointing performance of CAD. Lack of clear-cut methodology to assess standalone CAD performance has limited past CAD research. The current work removes that impediment. Going forward, assessment of standalone performance of CAD vs. expert radiologists is strongly encouraged.

## Appendix {#standalone-cad-radiologists-appendix}
Assuming RJafroc has been installed21, the following commands yield the results in Tables 2 and 3. Note that R is case sensitive.
	
{Table 4 goes here}


## References {#standalone-cad-radiologists-references}





  
