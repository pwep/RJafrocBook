# Split Plot Analysis {#split-plot-analysis}



## Extending the dataset to accommodate split-plot designs


```r
ds <- dataset02
```
* Need modality index as before.
* Each reader interprets a subset of the cases in both modalities.
* Assume reader `j` interprets $K_j$ cases, where K = $\sum_{i=1}^{J} K_j$ is the total number of cases imaged in both treatments.
* What is the structure of the dataset?
* LL[i,j, $k_j$, 1]; 
* Existing structure should suffice as each case is interpreted twice, once in each treatment, by _only_ one reader.
* Assume `K/J` = integer, 100 in the planned study; `J` = 8, `K` = 800
* Modification is needed only in FOM; also dataType needs to be changed to "SplitPlotRoc" or "SplitPlotFroc"
* ROC_SP or FROC_SP
* LL[i,j, 800, 1] for ROC 
* LL[i,j, 800, maxL] for FROC 
* Likewise for NL arrays 
* Work next on FOM 

## Introduction
Jason:
Thanks for inviting me to join your profile. Could you describe what you were planning on doing? Please use a simple example that illustrates the basic data collection. The key  point I want to be sure about is that strict pairing of readers across different treatments is preserved. I once had a study that had different readers interpreting in different treatments, which makes it impossible to separate the treatment effect (which is our primary interest) from a treatment-reader interaction effect. I am going to post that problem on Research Gate (the regulatory agency was telling them to do the study in a non-scientific way). Dev


Dr. Chakraborty, there will be 8 readers in my study. Around 800 CT images will be collected. Each reader reads 100 CT images unaided and aided by the CADe in two independent reading sessions separated by a washout period of 4 weeks. Each CT image will only be interpreted by one reader. I think it is a split-plot design with cases nested within reader so the strict pairing of readers across different treatments is preserved. Thanks for your help!


Hi Jason,
This problem has been solved in the ROC context (localization information not used) by Hillis and others; they may even have software. To analyze it using localization, one needs to use a location-sensitive figure of merit, like the weighted AFROC. That would be my recommendation. So, for each reader j, one has a figure of merit theta_ij, where i is the modality index. One can average over j, yielding theta_i_dot. Significance testing can be performed in the usual manner - e.g., DBMH or ORH. A custom program would need to be written or one can construct one out of R-scripts using the existing functions in RJafroc (the Windows program is obsolete). I can help in this regard. I would ask you to read the relevant papers and explain to me if my approach, summarized above, is basically correct. In any case, any method for ROC analysis can be adapted to FROC analysis if one uses the appropriate figure of merit. Good luck. Dev

Jason: Attached is the Hillis paper; I am not a statistician and find the term "nested" confusing; this paper claims to analyze split plot design using the OR approach as applied to ROC split plot data; if you think this is the correct approach for your study, apart from the limitation to ROC, I can easily extend the software to analyze FROC split plot data; please review and advise; Dev