import math
import numpy as np
import pandas as pd

from sklearn.model_selection import train_test_split

import tensorflow as tf
import tflearn
from tflearn.data_utils import to_categorical

def build_model():

    # reset all parameters and variables
    tf.reset_default_graph()

    # define network layers
    net = tflearn.input_data([None, 7])                         # input layer
    net = tflearn.fully_connected(net, 15, activation='ReLU')   # hidden layer
    net = tflearn.fully_connected(net, 2, activation='softmax') # output layer

    # define optimizer and build model
    net = tflearn.regression(net, optimizer='sgd', learning_rate=0.25, loss='categorical_crossentropy')
    model = tflearn.DNN(net)

    return model

def main():

    # load data into data frame
    data = pd.read_csv('data/fracture_data.csv')

    # split data frame into features (X) and labels (y)
    X = data.loc[:, 'DT':'R_DS'].values
    y = to_categorical((data.loc[:, 'IL'].values == 2).astype(np.int_), 2)

    # split data into training and testing subsets
    train_X, train_y = X[0:28], y[0:28]
    test_X, test_y = X[29:32], y[29:32]

    # build and fit model
    model = build_model()
    model.fit(train_X, train_y, validation_set=0.15, show_metric=True, n_epoch=200)

    # evaluate model using test set
    predictions = (np.array(model.predict(test_X))[:,0] >= 0.5).astype(np.int_)
    test_accuracy = np.mean(predictions == test_y[:,0], axis=0)
    print('Test accuracy: {}'.format(test_accuracy))

if __name__ == '__main__':
    main()
