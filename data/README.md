## Codebook for *fracture_data.csv*  

#### Joshua Poirier
#### NEOS
#### Project Geoscientist
#### March 2017

## Overview  

*fracture_data.csv* contains the input data for fracture predictions for wells
An1 and An2. The data is believed to have been originally published by Shen and
Gao, 2007; however, it was transcribed by **Joshua Poirier** from Guangren Shi's
2014 book **Data Mining and Knowledge Discovery for Geoscientists.** You can
purchase the book from [Amazon](https://www.amazon.com/Data-Mining-Knowledge-Discovery-Geoscientists/dp/0124104371/ref=sr_1_1?ie=UTF8&qid=1490908644&sr=8-1&keywords=data+mining+and+knowledge+discovery+for+geoscientists+%2B+guangren+shi) or directly from the publisher, [Elsevier](https://www.elsevier.com/books/data-mining-and-knowledge-discovery-for-geoscientists/shi/978-0-12-410437-2).

Shi describes the location of the data as follows:

> Located southeast of the Biyang Sag in Nanxiang Basin in central China, the Anpeng Oil-field covers an area of about 17.5 square kilometers, close to Tanghe-zaoyuan in the northwest-west, striking a large boundary fault in the south, and close to a deep sag in the east. As an inherited nose structure plunging from northwest to southeast, this oilfield is a simple structure without faults, where commercial oil and gas flows have been discovered (Ming et al., 2005; Wang et al., 2006). One of its favorable pool-forming conditions is that the fractures are found to be well developed at formations as deep as 2800 m or more. These fractures provide favorable oil-gas migration pathways and enlarged the accumulation space.

Shi used the data features as input into a backpropogating neural network (BPNN)
as well as multiple regression analysis (MRA) in order to predict the presence
of fractures. Shi used samples 1-29 for training and 30-33 for testing. The
features included **DT**, **RHO**, **PHIN**, **R_XO**, **R_LLD**, **R_LLS**, and
**R_DS.** The target to be predicted was **IL.**

## Features  

Below lists the variables found in *fracture_data.csv* and their descriptions.
Units for the features are not given as they have been normalized over the
interval [0, 1]. This is how the data is presented in Shi, 2014.

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

## Preview  

The following table shows the first five rows of the data.  

| Sample | Well | Depth   | DT     | RHO    | PHIN   | R_XO   | R_LLD  | R_LLS  | R_DS   | IL |
| ------ | ---- | ------- | ------ | ------ | ------ | ------ | ------ | ------ | ------ | -- |
| 1      | An1  | 3065.13 | 0.5557 | 0.2516 | 0.8795 | 0.3548 | 0.6857 | 0.6688 | 0.0169 | 1  |
| 2      | An1  | 3089.68 | 0.9908 | 0.0110 | 0.8999 | 0.6792 | 0.5421 | 0.4071 | 0.1350 | 1  |
| 3      | An1  | 3098.21 | 0.4444 | 0.1961 | 0.5211 | 0.7160 | 0.7304 | 0.6879 | 0.0425 | 1  |
| 4      | An1  | 3102.33 | 0.4028 | 0.3506 | 0.5875 | 0.6218 | 0.6127 | 0.5840 | 0.0287 | 1  |
| 5      | An1  | 3173.25 | 0.3995 | 0.3853 | 0.0845 | 0.5074 | 0.8920 | 0.8410 | 0.0510 | 1  |

## References  

Shi, Gaungren, 2014. Data Mining and Knowledge Discovery for Geoscientists.
  Petroleum Industry Press, Elsevier.
