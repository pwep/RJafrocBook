---
output:
  pdf_document: default
  html_document: default
---
# Obuchowski Rockette (OR) Analysis {#ORAnalysisSigTesting}



## Introduction
In previous chapters the DBM significance testing procedure [@RN204] for analyzing MRMC ROC data, along with improvements [@RN2508], has been described. Because the method assumes that jackknife pseudovalues can be regarded as independent and identically distributed case-level figures of merit, it has been rightly criticized by Hillis and others [@zhou2009statistical]. Hillis states that the method "works" but lacks firm statistical foundations [@RN1772; @RN1865; @RN1866]. I would add that it "works" as long as one restricts to the empirical AUC figure of merit. In my book I gave a justification for why the method "works". Specifically, the *empirical AUC pseudovalues qualify as case-level FOMs* - this property has also been noted by [@RN1395]. However, this property applies *only* to the empirical AUC, so an alternate approach that applies to any figure of merit is highly desirable. 

Hillis' has proposed that a method based on an earlier publication [@RN1450], which does not depend on pseudovalues, is preferable from both conceptual and practical points of view. This chapter is named "OR Analysis", where OR stands for Obuchowski and Rockette. The OR method has advantages in being able to handle more complex study designs [@RN2508] that are addressed in subsequent chapters, and applications to other FOMs (e.g., the FROC paradigm uses a rather different FOM from empirical ROC-AUC) are best performed with the OR method.

This chapter delves into the significance testing procedure employed in OR analysis. 

Multiple readers interpreting a case-set in multiple treatments is analyzed and the results, DBM vs. OR, are compared for the same dataset. The special cases of fixed-reader and fixed-case analyses are described. Single treatment analysis, where interest is in comparing average performance of readers to a fixed value, is described. Three methods of estimating the covariance matrix are described.

Before proceeding, it is understood that datasets analyzed in this chapter follow a _factorial_ design, sometimes call fully-factorial or fully-crossed design. Basically, the data structure is symmetric, e.g., all readers interpret all cases in all modalities. The next chapter will describe the analysis of _split-plot_ datasets, where, for example, some readers interpret all cases in one modality, while the remaining readers interpret all cases in the other modality.

## Random-reader random-case (RRRC) analysis {#OR_RRRC}
In conventional ANOVA models, such as used in DBM, the covariance matrix of the error term is diagonal with all diagonal elements equal to a common variance, represented in the DBM model by the scalar $\epsilon$ term. Because of the correlated structure of the error term, in OR analysis, a customized ANOVA is needed. The null hypothesis (NH) is that the true figures-of-merit of all treatments are identical, i.e., 

\begin{equation}
NH:\tau_i=0\;\; (i=1,2,...,I)
(\#eq:ORModelNH)
\end{equation}

The analysis described next considers both readers and cases as random effects. The F-statistic is denoted $F_{ORH}$, defined by: 

\begin{equation}
F_{ORH}=\frac{MS(T)}{MS(TR)+J\max(Cov_2-Cov_3,0)}
(\#eq:F-OR-H)
\end{equation}

Eqn. \@ref(eq:F-OR-H) incorporates Hillis’ modification of the original OR F-statistic. The modification ensures that the constraint Eqn. \@ref(eq:CovOrderings) is always obeyed and also avoids a possibly negative (and hence illegal) F-statistic. The relevant mean squares are defined by (note that these are calculated using *FOM* values, not *pseudovalues*):

\begin{equation}
\left.\begin{matrix}
MS(T)=\frac{J}{I-1}\sum_{i=1}^{I}(\theta_{i\bullet}-\theta_{\bullet\bullet})^2\\
\\ 
MS(R)=\frac{I}{J-1}\sum_{j=1}^{J}(\theta_{\bullet j}-\theta_{\bullet\bullet})^2\\
\\
MS(TR)=\frac{1}{(I-1)(J-1)}\sum_{i=1}^{I}\sum_{j=1}^{J}(\theta_{ij}-\theta_{i\bullet}-\theta_{\bullet j}+\theta_{\bullet\bullet})
\end{matrix}\right\}
(\#eq:MS-OR)
\end{equation}

The original paper [@RN1450] actually proposed a different test statistic $F_{OR}$:

\begin{equation}
F_{OR}=\frac{MS(T)}{MS(TR)+J(Cov_2-Cov_3)}
(\#eq:F-OR)
\end{equation}

Note that Eqn. \@ref(eq:F-OR) lacks the constraint, subsequently proposed by Hillis, which ensures that the denominator cannot be negative. The following distribution was proposed for the test statistic. 

\begin{equation}
F_{ORH}\sim F_{ndf,ddf}
(\#eq:SamplingDistr-F-OR)
\end{equation}

The original degrees of freedom were defined by:

\begin{equation}
\text{ndf}=I-1\\
\text{ddf} = (I-1)\times(J-1)
(\#eq:ORdegreesOfFreedom)
\end{equation}

It turns out that the Obuchowski-Rockette test statistic is very conservative, meaning it is highly biased against rejecting the null hypothesis (the data simulator used in their validation did not detect this behavior). Because of this the predicted sample sizes tended to be quite large. In this connection I have two informative anecdotes.

### Two anecdotes {#TwoAnecdotes}

* The late Dr. Robert F. Wagner once stated to the author (ca. 2001) that the sample-size tables published by Obuchowski [@RN1971;@RN1972], using the version of Eqn. \@ref(eq:F-OR-H) with the *ddf* as originally suggested by Obuchowski and Rockette, predicted such high number of readers and cases that he was doubtful about the chances of anyone conducting a practical ROC study! 

* The second story is that the author once conducted NH simulations using a Roe-Metz simulator and the significance testing as described in the Obuchowski-Rockette paper: the method did not reject the null hypothesis even once in 2000 trials! Recall that with $\alpha = 0.05$ a valid test should reject the null hypothesis about $100\pm20$ times in 2000 trials. The author recalls (ca. 2004) telling Dr. Steve Hillis about this issue, and he suggested a different denominator degrees of freedom *ddf*, see next, substitution of which magically solved the problem, i.e., the simulations rejected the null hypothesis 5% of the time. 

### Hillis ddf {#Hills-ddf}
Hillis' proposed new *ddf* is shown below (*ndf* is unchanged), with the subscript $H$ denoting the Hillis modification:

\begin{equation}
\text{ddf}_H = \frac{\left [ MS(TR) + J \max(Cov_2-Cov_3,0)\right ]^2}{\frac{\left [ MS(TR) \right ]^2}{(I-1)(J-1)}}
(\#eq:ddfH)
\end{equation}

If $Cov_2 < Cov_3$ (which is the *exact opposite* of the expected ordering, Eqn. \@ref(eq:CovOrderings)), this reduces to $(I-1)\times(J-1)$, the value originally proposed by Obuchowski and Rockette. With Hillis' proposed changes, under the null hypothesis the observed statistic $F_{ORH}$, defined in Eqn. \@ref(eq:F-OR-H), is distributed as an F-statistic with $\text{ndf} = I-1$ and *ddf* $= ddf_H$ degrees of freedom [@RN1772;@RN1865;@RN1866]: 

\begin{equation}
F_{ORH}\sim F_{ndf,ddf_H}
(\#eq:SamplingDistr-F-OR-H)
\end{equation}

If the expected ordering is true, i.e., $Cov_2 > Cov_3$ , which is the more likely situation, then $ddf_H$ is *larger* than $(I-1)\times(J-1)$, i.e., the Obuchowski-Rockette's *ddf*, and the p-value decreases, i.e., there is a larger probability of rejecting the NH. The modified OR method is more likely to have the correct NH behavior, i.e, it will reject the NH 5% of the time when alpha is set to 0.05 (statisticians refer to this as "the 5% test"). This has been confirmed in simulation testing (@RN1866).

### Decision rule, p-value and confidence interval
The critical value of the F-statistic for rejection of the null hypothesis is $F_{1-\alpha,ndf,ddf_H}$, i.e., that value such that fraction $(1-\alpha)$ of the area under the distribution lies to the left of the critical value. From definition Eqn. \@ref(eq:F-OR-H):

* Rejection of the NH is more likely if $MS(T)$ increases, meaning the treatment effect is larger; 

* $MS(TR)$ is smaller meaning there is less contamination of the treatment effect by treatment-reader variability; 

* The greater of $Cov2$ or $Cov3$, which is usually $Cov2$, decreases, meaning there is less "noise" in the measurement due to between-reader variability. Recall that $Cov_2$ involves different-reader same-treatment pairings.  

* $\alpha$ increases, meaning one is allowing a greater probability of Type I errors; 

* $ndf$ increases, as this lowers the critical value of the F-statistic. With more treatment pairings, the chance that at least one paired-difference will reject the NH is larger. 

* $ddf_H$ increases, as this lowers the critical value of the F-statistic. 

The p-value of the test is the probability, under the NH, that an equal or larger value of the F-statistic than $F_{OR}$ could be observed by chance. In other words, it is the area under the F-distribution $F_{ndf,ddf_H}$ that lies above the observed value $F_{OR}$:

\begin{equation}
p=\Pr(F>F_{OR} \mid F\sim F_{ndf,ddf_H})
(\#eq:pValueORRRRC)
\end{equation}

The $(1-\alpha)$ confidence interval for $\theta_{i \bullet} - \theta_{i' \bullet}$ is given by (the average is over the reader index):

\begin{equation}
CI_{1-\alpha,RRRC}=\theta_{i \bullet} - \theta_{i' \bullet} \pm t_{\alpha/2, ddf_H}\sqrt{\frac{2}{J}(MS(TR)+J\max(Cov_2-Cov_3,0))}
(\#eq:CIalpha-RRRC)
\end{equation}

## Fixed-reader random-case (FRRC) analysis
Using the Roe and Metz vertical bar notation $\mid R$ to denote that reader is regarded as a fixed effect [@RN1124], the F -statistic for testing the null hypothesis $NH: \tau_i = 0 \; (i=1,1,2,...I)$ is [@RN1865]: 

\begin{equation}
F_{OR \mid R}=\frac{MS(T)}{Var-Cov_1+(J-1)\max(Cov_2-Cov_3,0)}
(\#eq:DefFStatFRRC)
\end{equation}

$F_{OR \mid R}$ is distributed as an F-statistic with:

\begin{equation}
\left.\begin{matrix}
ndf=I-1\\ 
ddf=\infty\\
F_{OR \mid R} \sim F_{ndf,ddf}
\end{matrix}\right\}
(\#eq:FStatFRRC)
\end{equation}

Alternatively, as with Eqn. \@ref(eq:F-1RMT),

$$(I-1)F_{OR \mid R} \sim \chi^2_{I-1}$$
For $J$ = 1, Eqn. \@ref(eq:DefFStatFRRC) reduces to Eqn. \@ref(eq:DefF-1RMT). 

The critical value of the statistic is $F_{1-\alpha,I-1,\infty}$ which is that value such that fraction $(1-\alpha)$ of the area under the distribution lies to the left of the critical value. The null hypothesis is rejected if the observed value of the F- statistic exceeds the critical value, i.e.,:

$$F_{OR \mid R}>F_{1-\alpha,I-1,\infty}$$

The p-value of the test is the probability that a random sample from the distribution $F_{I-1,\infty}$ exceeds the observed value of the F statistic defined in Eqn. \@ref(eq:DefFStatFRRC):

\begin{equation}
p=\Pr(F>F_{OR \mid R} \mid F \sim F_{I-1,\infty})
(\#eq:pValueaphaFRRC)
\end{equation}

The $(1-\alpha)$ (symmetric) confidence interval for the difference figure of merit is given by:

\begin{equation}
CI_{1-\alpha,FRRC}=(\theta_{i \bullet} - \theta_{i' \bullet}) \pm t_{\alpha/2, \infty}\sqrt{\frac{2}{J}(Var-Cov_1+(J-1)\max(Cov_2-Cov_3,0))}
(\#eq:CIalphaFRRC)
\end{equation}

The NH is rejected if any of the following equivalent conditions is met:

* The observed value of the F-statistic exceeds the critical value $F_{1-\alpha,I-1,\infty}$.
* The p-value defined by Eqn. \@ref(eq:pValueaphaFRRC) is less than $\alpha$.
* The $(1-\alpha)$ confidence interval does not include zero.

Notice that for J = 1, Eqn. \@ref(eq:CIalphaFRRC) reduces to Eqn. \@ref(eq:CIalpha1R).

## Random-reader fixed-case (RRFC) analysis
When case is treated as a fixed factor, the appropriate F-statistic for testing the null hypothesis $NH: \tau_i = 0 \; (i=1,1,2,...I)$ is: 

\begin{equation}
F_{OR \mid C}=\frac{MS(T)}{MS(TR)}
(\#eq:DefFStatRRFC)
\end{equation}

$F_{OR \mid C}$ is distributed as an F-statistic with:

\begin{equation}
\left.\begin{matrix}
ndf=I-1\\ 
ddf=(I-1)(J-1)\\
F_{OR \mid C} \sim F_{ndf,ddf}
\end{matrix}\right\}
(\#eq:FStatRRFC)
\end{equation}

The critical value of the statistic is $F_{1-\alpha,I-1,(I-1)(J-1)}$, which is that value such that fraction $(1-\alpha)$ of the distribution lies to the left of the critical value. The null hypothesis is rejected if the observed value of the F statistic exceeds the critical value:

$$F_{OR \mid C}>F_{1-\alpha,I-1,(I-1)(J-1)}$$

The p-value of the test is the probability that a random sample from the distribution exceeds the observed value:

$$p=\Pr(F>F_{OR \mid C} \mid F \sim F_{1-\alpha,I-1,(I-1)(J-1)})$$

The $(1-\alpha)$ confidence interval is given by:

\begin{equation}
CI_{1-\alpha,RRFC}=(\theta_{i \bullet} - \theta_{i' \bullet}) \pm t_{\alpha/2, (I-1)(J-1)}\sqrt{\frac{2}{J}MS(TR)}
(\#eq:CIalphaRRFC)
\end{equation}

## Discussion/Summary


## References  
