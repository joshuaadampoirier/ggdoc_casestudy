## Predicting fracture presence by applying neural networks to conventional well-logging data  
Joshua Poirier  
Geoscientist  
NEOS  
May 2017  

### Abstract  
This case study comes from Guangren Shi's chapter on Artificial Neural Networks
from his book "Data Mining and Knowledge Discovery for Geoscientists." You can
purchase the book from [Amazon](https://www.amazon.com/Data-Mining-Knowledge-Discovery-Geoscientists/dp/0124104371/ref=sr_1_1?ie=UTF8&qid=1490908644&sr=8-1&keywords=data+mining+and+knowledge+discovery+for+geoscientists+%2B+guangren+shi) or directly from the publisher, [Elsevier](https://www.elsevier.com/books/data-mining-and-knowledge-discovery-for-geoscientists/shi/978-0-12-410437-2). The objective is to predict fractures using conventional
well-logging data. This data has practical value when the data of the imaging
log and core samples are limited.  

### Introduction  

Shi describes the study location as follows:

> Located southeast of the Biyang Sag in Nanxiang Basin in central China, the Anpeng Oil-field covers an area of about 17.5 square kilometers, close to Tanghe-zaoyuan in the northwest-west, striking a large boundary fault in the south, and close to a deep sag in the east. As an inherited nose structure plunging from northwest to southeast, this oilfield is a simple structure without faults, where commercial oil and gas flows have been discovered (Ming et al., 2005; Wang et al., 2006). One of its favorable pool-forming conditions is that the fractures are found to be well developed at formations as deep as 2800 m or more. These fractures provide favorable oil-gas migration pathways and enlarged the accumulation space.

Augmenting Shi's description with the work of Dong (2015) and Guo (2014) I was
able to build the following map. In the upper-right we see the location of the
Nanxiang Basin in central China. The basin is split into sags and uplifts as
shown in the lower-right - we're focused on teh Biyang Sag in red. The left
image shows the Biyang Sag in detail. Shi describes the oilfield as being a
simple structure without faults. This is consistent with Guo (2014) as we see
no mapped faults near Anpengzhen on the map. Unfortunately, the well locations
are not available. While this won't prevent me from moving forward with the
study, it does limit the geologic context for my solution.

![](figures/biyang_studyarea.png)  

The above map was made using the R script *mapping_functions.R*.

The data was transcribed from Shi's book and includes data from 33 samples in
wells An1 and An2, of which he used 29 as learning samples; holding out 4 as a
test set to evaluate the accuracy of his model. The data features available are
summarized below. Units are not given as each log has been normalized over the
interval [0, 1].

| Variable name | Description                                                  |
| ------------- | ------------------------------------------------------------ |
| Sample        | Sample number                                                |
| Well          | Well number                                                  |
| Depth         | Measured depth in meters                                     |
| DT            | Acoustic time                                                |
| RHO           | Compensated neutron density                                  |
| PHIN          | Compensated neutron porosity                                 |
| R_XO          | Microspherically focused resistivity                         |
| R_LLD         | Deep laterolog resistivity                                   |
| R_LLS         | Shallow laterolog resistivity                                |
| R_DS          | Absolute difference between R_LLD and R_LLS                  |
| IL            | Fracture identification determined by imaging log (1=fracture, 2=nonfracture) |  

The following table shows a preview of the first five rows of the data.  

| Sample | Well | Depth   | DT     | RHO    | PHIN   | R_XO   | R_LLD  | R_LLS  | R_DS   | IL |
| ------ | ---- | ------- | ------ | ------ | ------ | ------ | ------ | ------ | ------ | -- |
| 1      | An1  | 3065.13 | 0.5557 | 0.2516 | 0.8795 | 0.3548 | 0.6857 | 0.6688 | 0.0169 | 1  |
| 2      | An1  | 3089.68 | 0.9908 | 0.0110 | 0.8999 | 0.6792 | 0.5421 | 0.4071 | 0.1350 | 1  |
| 3      | An1  | 3098.21 | 0.4444 | 0.1961 | 0.5211 | 0.7160 | 0.7304 | 0.6879 | 0.0425 | 1  |
| 4      | An1  | 3102.33 | 0.4028 | 0.3506 | 0.5875 | 0.6218 | 0.6127 | 0.5840 | 0.0287 | 1  |
| 5      | An1  | 3173.25 | 0.3995 | 0.3853 | 0.0845 | 0.5074 | 0.8920 | 0.8410 | 0.0510 | 1  |  

### Training and Testing Sets  

In order to evaluate my final model I'm going to split the data into training
testing data subsets. I'll use samples 1-29 as training data to build the neural
network and evaluate the neural networks performance on samples 30-33 (as Shi
did). In addition, I'll randomly hold 15% of the training data as a validation
set. If I were to tune hyperparameters to the testing set, the testing set would
end up bleeding into the training process. This will help avoid overfitting.

### Network Architecture  

[TFLearn](http://tflearn.org) is a Python package that allows you to build a
neural network by defining the layers. It does a lot of the heavy lifting for
me - so I don't have to code weight initialization, feed-forward propogation, or
the backward propogation of errors through the network. I can simply focus on
the architecture of the network.  

For this network I only deviated from Shi's work mildly. Like Shi, I use 7 input
neurons corresponding to the well logs we're using to train the network. I use a
single hidden layer with 15 neurons. Deviating from Shi, I use *rectified
linear units (ReLU)* for the activation function. Shi uses sigmoids for the
activations. ReLU's were first used in a network by Hahnloser et al. (2000) and
(as per LeCun 2015) have since become the most popular activation function for
deep learning. The output layer (two neurons - one indicating fracture presence,
the other indicating its absence) utilizes the *softmax* activation function to
ensure the outputs add to 1, and can be interpreted as probabilities of fracture
presence/absence.

### Testing the network  

![](figures/nn-performance.png)

## References  

Abadi, Martin et al. [TensorFlow: Large-scale machine learning on heterogeneous systems](http://tensorflow.org). tensorflow.org. 2015.

Damien, Aymeric et al. [TFLearn](http://tflearn.org/). GitHub. 2016.

Dong, Yanlei et al. [Seismic geomorphology study of the Paleogene Hetaoyuan Formation, central-south Biyang Sag, Nanxiang Basin, China](https://doi.org/10.1016/j.marpetgeo.2015.02.042).
Marine and Petroleum Geology. Vol. 64 June 2015.

Guo, Pengfei et al. [Formation and Identification of Unresolved Complex Mixtures
in Lacustrine Biodegraded Oil from Nanxiang Basin, China](http://dx.doi.org/10.1155/2014/102576).
The Scientific World Journal, Vol. 2014.  

Hahnloser, R. et al. [Digital selection and analogue amplification coexist in a cortex-inspired silicon circuit](https://www.nature.com/nature/journal/v405/n6789/full/405947a0.html).
Nature. Vol. 405. June 2000.

Kahle, D. and Wickham, H. [ggmap: Spatial Visualization with ggplot2](http://journal.r-project.org/archive/2013-1/kahle-wickham.pdf).
The R Journal, 5(1).

LeCun, Yann et al. [Deep learning](http://www.nature.com/nature/journal/v521/n7553/full/nature14539.html).
Nature. Vol. 521. May 2015.

Shi, Gaungren, 2014. Data Mining and Knowledge Discovery for Geoscientists.
  Petroleum Industry Press, Elsevier.
