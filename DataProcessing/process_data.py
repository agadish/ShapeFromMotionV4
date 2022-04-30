#!/usr/bin/env python3
"""
@brief Process the data for Shape From Motion project 2022.

@prerequirements python3 packages: pandas, openpyxl

@author Assaf Gadish, Dvir Ben Asuli. Supervised by Dr. Hevda Spitzer
"""

import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
from sklearn import svm

DATA_PATH = './results.xlsx'

RESULTS_MEAN_PLANE_EXPERIMENT_INDEX = 0
RESULTS_SD_PLANE_EXPERIMENT_INDEX = 0

class PlaneExperiment(object):
    def __init__(self, data_frame: pd.core.frame.DataFrame, column_name=None, column_value=None, filter_label_func=None):
        if column_name and column_value:
            self._data_frame = data_frame.loc[data_frame[column_name] == column_value]
        else:
            self._data_frame = data_frame

        x = np.array(self._get_column(0))
        y = np.array(self._get_column(1))
        z_value = np.array(self._get_column(2))
        if not len(set(z_value)) == 1:
            raise ValueError('DataFrame referes to more than 1 value of z')
        self._z_value = z_value

        labels = np.array(self._get_column(3))
        if filter_label_func:
            indices = [i for i in range(len(labels))
                       if filter_label_func(labels[i]) is not None]
            x = [x[i] for i in indices]
            y = [y[i] for i in indices]
            labels = [filter_label_func(labels[i]) for i in indices]

        self._data = np.array([(x[i], y[i], ) for i in range(len(x))])
        self._labels = labels


    def _get_column(self, index):
        column_title = self._data_frame.columns[index]
        return self._data_frame[column_title]

    @property
    def data(self):
        return self._data

    @property
    def labels(self):
        return self._labels

    @property
    def z_value(self):
        return self._z_value

    @property
    def data(self):
        return self._data

    @property
    def label_dots(self):
        column_title = self._data_frame.columns[3]
        return self._data_frame[column_title]

    def build_data(self):
        x = self.x_dots
        y = self.y_dots
        assert(len(x) == len(y))
        return np.array([(x[i], y[i]) for i in range(len(x))])

    def build_labels(self):
        return np.array(self.label_dots)

def filter_label_func_35(data):
    if 0 <= data <= 0.35:
        return -1
    elif 0.65 <= data <= 1:
        return 1
    return None


class DataParser(object):
    def __init__(self):
        super(DataParser, self).__init__()

    def parse(self, data, labels, experiments_len):
        raise NotImplementedError()

    #  def create_plot(self, X, y, clf):
    #      plt.clf()
    #
    #      # plot the data points
    #      plt.scatter(X[:, 0], X[:, 1], c=y, s=30, cmap=plt.cm.PiYG)
    #
    #      # plot the decision function
    #      plt.xlim([0, np.max(X) + 1])
    #      plt.ylim([0, np.max(X) + 1])
    #      ax = plt.gca()
    #      xlim = ax.get_xlim()
    #      ylim = ax.get_ylim()
    #
    #      # create grid to evaluate model
    #      xx = np.linspace(xlim[0] - 2, xlim[1] + 2, 30)
    #      yy = np.linspace(ylim[0] - 2, ylim[1] + 2, 30)
    #      YY, XX = np.meshgrid(yy, xx)
    #      xy = np.vstack([XX.ravel(), YY.ravel()]).T
    #      Z = clf.decision_function(xy).reshape(XX.shape)
    #
    #      # plot decision boundary and margins
    #      ax.contour(XX, YY, Z, colors='k', levels=[-1, 0, 1], alpha=0.5,
    #                 linestyles=['--', '-', '--'])
    def create_plot(self, X, y, clf, i, experiments_len, classifiers_len):
        ax = plt.subplot(experiments_len, classifiers_len + 1, i + 1)
        try:
            clf.fit(X, y)
            score = clf.score(X, y)

            # Plot the decision boundary. For that, we will assign a color to each
            # point in the mesh [x_min, x_max]x[y_min, y_max].
            if hasattr(clf, "decision_function"):
                Z = clf.decision_function(np.c_[xx.ravel(), yy.ravel()])
            else:
                Z = clf.predict_proba(np.c_[xx.ravel(), yy.ravel()])[:, 1]

            # Put the result into a color plot
            Z = Z.reshape(xx.shape)
            ax.contourf(xx, yy, Z, cmap=cm, alpha=0.8)

            # Plot the training points
            ax.scatter(
                X[:, 0], X[:, 1], c=y, cmap=cm_bright, edgecolors="k"
            )
            # Plot the testing points
            ax.scatter(
                X[:, 0],
                X[:, 1],
                c=y,
                cmap=cm_bright,
                edgecolors="k",
                alpha=0.6,
            )

            ax.set_xlim(xx.min(), xx.max())
            ax.set_ylim(yy.min(), yy.max())
            ax.set_xticks(())
            ax.set_yticks(())
            #  if ds_cnt == 0:
            #      ax.set_title(name)
            ax.text(
                xx.max() - 0.3,
                yy.min() + 0.3,
                ("%.2f" % score).lstrip("0"),
                size=15,
                horizontalalignment="right",
            )
        except Exception as e:
            print('fit error: %s' % (e, ))



class SVMParser(DataParser):
    def parse(self, data, labels, experiments_len):
        """
        Returns: np.ndarray of shape (3,2) :
                    A two dimensional array of size 3 that contains the number of support vectors for each class(2) in the three kernels.
        """
        c_value = 1000
        result = np.ndarray((3, 2, ))
        x = data
        y = labels
        kernel_types = ('linear', lambda x, y: (1 + np.dot(x,y.T)) ** 2, 'rbf', )
        for i in range(len(kernel_types)):
            svc = svm.SVC(C=c_value, kernel=kernel_types[i])
            trained_svc = svc.fit(data, labels)
            self.create_plot(data, labels, trained_svc, i, experiments_len, len(kernel_types))
            plt.show()
            result[i] = trained_svc.n_support_

        return result


######## Experiments Data ################
def get_mean_plane_data_frame():
    f = pd.ExcelFile(DATA_PATH)
    data_frame = f.parse(RESULTS_MEAN_PLANE_EXPERIMENT_INDEX)
    return data_frame

def get_sd_plane_data_frame():
    f = pd.ExcelFile(DATA_PATH)
    data_frame = f.parse(RESULTS_SD_PLANE_EXPERIMENT_INDEX)
    return data_frame


def handle_mean_experiments():
    parsers = [SVMParser()]

    # Mean experiments
    data_frame = get_mean_plane_data_frame()
    mean_experiment_groups = [PlaneExperiment(data_frame, 'STD', val, filter_label_func=filter_label_func_35) for val in [0.25, 0.8, 1.2]]

    for experiment in mean_experiment_groups:
        for parser in parsers:
            parser.parse(experiment.data, experiment.labels, len(mean_experiment_groups))

def handle_sd_experiments():
    parsers = [SVMParser()]
    data_frame = get_sd_plane_data_frame()
    sd_experiment_groups = [PlaneExperiment(data_frame, 'Mean', val, filter_label_func=filter_label_func_35) for val in [0.25, 0.8, 1.2]]

    for experiment in sd_experiment_groups:
        for parser in parsers:
            parser.parse(experiment.data, experiment.labels, en(sd_experiment_groups))

def main():
    handle_mean_experiments()
    #  handle_sd_experiments()



if __name__ == '__main__':
    exit(main())
