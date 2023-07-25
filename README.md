# Distributed_Dual_Coordinate_Ascent_in_Tree_Networks
Distributed Dual Coordinate Ascent (DDCA) in general tree networks and communication network effect on synchronous machine learning

------------------------
A. INTRODUCE
Due to the big size of data and limited data storage volume of a single computer or a single server, data are often stored in a distributed manner. Thus, performing large-scale machine learning operations with the distributed datasets through communication networks is often required. In this paper, we study the convergence rate of the distributed dual coordinate ascent for distributed machine learning problems in a general tree-structured network. Since a tree network model can be understood as the generalization of a star network model, our algorithm can be thought of as the generalization of the distributed dual coordinate ascent in a star network model. We provide the convergence rate of the distributed dual coordinate ascent over a general tree network in a recursive manner and analyze the network effect on the convergence rate. Secondly, by considering network communication delays, we optimize the distributed dual coordinate ascent algorithm to maximize its convergence speed. From our analytical result, we can choose the optimal number of local iterations depending on the communication delay severity to achieve the fastest convergence speed. In numerical experiments, we consider machine learning scenarios over communication networks, where local workers cannot directly reach to a central node due to constraints in communication, and demonstrate that the usability of our distributed dual coordinate ascent algorithm in tree networks. Additionally, we show that adapting number of local and global iterations to network communication delays in the distributed dual coordinated ascent algorithm can improve its convergence speed.

------------------------
B. GOALS:
Distribued machine learning process (solving a regularized loss minimzation problem) in a tree network

------------------------
C. CONTENTS:
libsvm-3.23 libary is used to read Covtype dataset in Matlab.

C.1. FOLDERS
00_Dataset: Datasets are provided. KDD and Covtype dataset are used in the code.

01_KDD_regression: Regression operation with KDD dataset

02_Cov_classification: Classification operation with Covtype dataset

03_Optimal_H: Analysis code for optimal number of local iterations

04_Layer_vs_Convergence: Analysis code for convergence rate change with respect to the number of layer in a tree network


C.2. MAIN FILES & To-Do
Due to file size limitation in GitHub, we couldn't upload original datasets, or needed to compress the dataset. You need to upzip or run a code for preprocessing dataset.

C.3. Running KDD_regression
(a) Go to the folder "00_Dataset/KDD" 
(b) Run "data_load.m" in matlab in the folder "00_Dataset/KDD". The matlab will generate a mat file "KddData_normalized.mat", which will be used in the main file. 
(c) Go to the folder "01_KDD_regression", and run "main.m" in matlab.

C.4. Running Cov_classification
(a) Go to the folder "00_Dataset/cov" 
(b) Upzip "covtype.libsvm.binary.scale.zip", and make sure that "covtype.libsvm.binary.scale" is unzip under the folder "00_Dataset/cov"
(c) Go to the folder "02_Cov_classification", and run "main.m" in matlab.


------------------------
D. ADDITION
Dataset were obtained from the machine learning repository (https://archive.ics.uci.edu) and LIBSVM homepage (https://www.csie.ntu.edu.tw/~cjlin/libsvmtools/datasets/binary.html)

(b) Contact info.: Myung (Michael) Cho, Ph.D. 
- Email: michael.myung.cho@gmail.com
- Homepage: https://sites.google.com/view/myungcho/home

------------------------
E. REFERENCE PAPERS: 
[1] Myung Cho, Lifeng Lai, and Weiyu Xu, “Distributed dual coordinate ascent in general tree networks and communication network effect on synchronous machine learning,” IEEE Journal on Selected Areas in Communication (JSAC), vol. 39, no. 7, pp. 2105-2119, 2021.

[2] Myung Cho, Lifeng Lai, and Weiyu Xu, “Generalized distributed dual coordinate ascent in a tree network for machine learning,” in Proceedings of IEEE International Conference on Acoustics, Speech, and Signal Processing (ICASSP), 2019, pp. 3512-3516.



