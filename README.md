# ANNDSS
Artificial Neural Network for Dynamic Subset Selection and Displacement Error Prediction

This work is based on the paper (to be published) of the same title

##Abstract
Background Precise and accurate digital image correlation computed displacement data requires sufficient noise suppression and spatial resolution which improve and diminish, respectively, with increased subset size. Furthermore, spatially varying speckle pattern quality and displacement field complexity, typical of experimental solid mechanics, necessitate a location-specific optimal subset size to obtain a favourable compromise between noise suppression and spatial resolution to realise accurate and precise displacement measurements. Although methods of dynamic subset selection (DSS) have been proposed on the basis of speckle pattern quality metrics (SPQMs), they fail to ensure a favourable compromise.
Objective This work investigates the potential of an artificial neural network (ANN) as an approach to DSS purely based on image information to offer a favourable compromise.
Methods The ANN predicts the displacement error standard deviation (DESD) of a speckle pattern from multiple SPQMs and standard deviation of image noise such that the smallest subset offering sufficient noise suppression, dictated by a DESD threshold, is appointed.
Results Validation on synthetic images consistent with the training scope confirms the hypothesis that the smallest subset providing sufficient noise suppression, defined by the DESD threshold, offers a favourable compromise for up to moderate displacement gradients. Furthermore, results of experimental and synthetic images outside the training scope indicate that despite the decreased accuracy of the ANN, the DSS method remains capable of assigning subset sizes offering a good balance between noise suppression and spatial resolution. 
Conclusion Thus, the novel proposition of utilising an ANN, functioning as an error prediction tool, as an approach to DSS solely based on image information is an attractive alternative to the traditional trial and error approach to subset size selection. 

##Outcome:
The presented algorithm validated on synthetic images consistent with the training scope of the ANN reveal the potential of ANNs as an approach to dynamic subset selection and displacement error prediction:
- the ANN accurately and precisely predicts the DESD of a subset from its SPQMs and standard deviation of image noise; 
- subsequently the ANN accurately and reliably predicts the trend in noise suppression for an analysis which along with knowledge of the severity of the displacement field complexity, generally known a priori in experimental solid mechanics applications, affords all the necessary information to stipulate a DESD threshold appropriate for the analysis; 
- ANNDSS dynamically appoints the smallest subset size for each query point, based on the local speckle pattern, that offers noise suppression satisfying this DESD threshold; 
- the method offers improved noise suppression relative to the best results for the traditional trial and error approach to subset size selection for the same mean subset size
-  knowledge of the contribution of image noise to random error enables the quality of the computed displacement field to be inferred; and 
- provided the DESD threshold is appropriate, ANNDSS appoints subset sizes offering a favourable compromise between noise suppression and spatial resolution for up to moderate displacement gradients. 

Although the generalisability of the ANN and thus potential of ANNDSS is limited for speckle pattern characteristics outside the scope that the ANN was trained on, ANNDSS remains capable of offering a favourable compromise between noise suppression and spatial resolution for up to moderate displacement gradients. Furthermore, ANNDSS can be readily implemented with any 2D DIC algorithm capable of assigning the subset size of each query point independently while extension to stereo-DIC should be straightforward.
Thus, this novel approach to DSS purely based on image information through utilising an ANN as an error prediction tool is an attractive alternative to the traditional trial and error approach of subset size selection.