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
RESULTS_SD_PLANE_EXPERIMENT_INDEX = 1

class PlaneExperiment(object):
    def __init__(self, data_frame: pd.core.frame.DataFrame, column_name=None, column_value=None, filter_label_func=None):
        if column_name and column_value:
            self._data_frame = data_frame.loc[data_frame[column_name] == column_value]
        else:
            self._data_frame = data_frame

        x = np.array(self._get_column(0))
        y = np.array(self._get_column(1))
        max_data = max(np.max(x), np.max(y))
        self._max_data = max_data
        z_value = np.array(self._get_column(2))
        if not len(set(z_value)) == 1:
            raise ValueError('DataFrame referes to more than 1 value of z')
        self._z_value = z_value[0]

        labels = np.array(self._get_column(3))
        if filter_label_func:
            used_indices = [i for i in range(len(labels))
                       if filter_label_func(labels[i]) is not None]
            used_x = [x[i] for i in used_indices]
            used_y = [y[i] for i in used_indices]

            used_labels = np.array([filter_label_func(labels[i]) for i in used_indices])
            used_labels_raw = np.array([labels[i] for i in used_indices])

            # Save removed dots
            removed_indices = [i for i in range(len(labels))
                       if filter_label_func(labels[i]) is None]
            removed_x = [x[i] for i in removed_indices]
            removed_y = [y[i] for i in removed_indices]

            removed_labels = np.array([0 for i in removed_indices])

        self._data = np.array([(used_x[i] / max_data, used_y[i] / max_data, ) for i in range(len(used_x))])
        self._labels = used_labels
        self._labels_raw = used_labels_raw
        self._removed_data = np.array([(removed_x[i] / max_data, removed_y[i] / max_data, ) for i in range(len(removed_x))])
        self._removed_labels = removed_labels

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

    @property
    def labels_raw(self):
        return self._labels_raw

    @property
    def max_data(self):
        return self._max_data

    def build_data(self):
        x = self.x_dots
        y = self.y_dots
        assert(len(x) == len(y))
        return np.array([(x[i], y[i]) for i in range(len(x))])

    def build_labels(self):
        return np.array(self.label_dots)

def filter_label_func_minus1_to_1(data):
    return (2 * data) -1

def filter_label_func_35(data):
    if 0.35 >= data:
        return -1
    elif 0.65 <= data:
        return 1
    return None


class DataParser(object):
    def __init__(self):
        super(DataParser, self).__init__()

    def parse(self, data, labels, labels_raw, removed_data, factor, title_data='', xlabel='', ylabel='', experiment_name=''):
        raise NotImplementedError()

    def create_plot(self, X, y, y_raw, removed_X, factor, clf, title, xlabel, ylabel, experiment_name=''):
        # plot the data points
        plt.clf()
        if removed_X.size:
            plt.scatter(removed_X[:, 0] * factor, removed_X[:, 1] * factor, c=['grey'] * len(removed_X), marker='x', s=70, cmap=plt.cm.PiYG)

        def label_value_to_color(val):
            if val < 0.07:
                return '#FF0000'
            elif 0.07 <= val < 0.14:
                return '#DF0000'
            elif 0.14 <= val < 0.21:
                return '#BF0000'
            elif 0.21 <= val < 0.28:
                return '#9F0000'
            elif 0.28 <= val <= 0.35:
                return '#7F0000'

            if 0.65 <= val < 0.72:
                return '#007F00'
            if 0.72 <= val < 0.79:
                return '#009F00'
            if 0.79 <= val < 0.86:
                return '#00BF00'
            if 0.86 <= val < 0.93:
                return '#00DF00'
            if 0.93 <= val:
                return '#00FF00'
            import ipdb ; ipdb.set_trace()
            return '#0000FF'

        def label_value_size(val):
            if val < 0.07:
                return 30
            elif 0.07 <= val < 0.14:
                return 60
            elif 0.14 <= val < 0.21:
                return 120
            elif 0.21 <= val < 0.28:
                return 240
            elif 0.28 <= val <= 0.35:
                print('wa')
                return 480

            if 0.65 <= val < 0.72:
                print('wa')
                return 480
            if 0.72 <= val < 0.79:
                return 240
            if 0.79 <= val < 0.86:
                return 120
            if 0.86 <= val < 0.93:
                return 60
            if 0.93 <= val:
                return 30
            import ipdb ; ipdb.set_trace()
            return 90

        colors = [label_value_to_color(t) for t in y_raw]
        sizes = [label_value_size(t) for t in y_raw]
        plt.scatter(X[:, 0] * factor, X[:, 1] * factor, c=colors, s=sizes, cmap=plt.cm.PiYG)

        # plot the decision function
        max_axis_val = 0
        if X.size:
            max_axis_val = max(max_axis_val, np.max(X))
        if removed_X.size:
            max_axis_val = max(max_axis_val, np.max(removed_X))
        max_axis_val *= factor

        plt.xlim([0, max_axis_val * 1.05])
        plt.ylim([0, max_axis_val * 1.05])
        plt.title(title)
        ax = plt.gca()
        ax.set_xlabel(xlabel)
        ax.set_ylabel(ylabel)
        xlim = ax.get_xlim()
        ylim = ax.get_ylim()

        # create grid to evaluate model
        xx = np.linspace(xlim[0] - 2, xlim[1] + 2, 30) / factor
        yy = np.linspace(ylim[0] - 2, ylim[1] + 2, 30) / factor
        YY, XX = np.meshgrid(yy, xx)
        xy = np.vstack([XX.ravel(), YY.ravel()]).T
        #  import ipdb ; ipdb.set_trace()
        if hasattr(clf, 'decision_function'):
            Z = clf.decision_function(xy).reshape(XX.shape)
        elif hasattr(clf, 'predict'):
            Z = clf.predict(xy).reshape(XX.shape)
        elif hasattr(clf, 'predict_proba'):
            Z = clf.predict_proba(xy).reshape(XX.shape)
        else:
            raise Exception('Set decision function manually')

        # plot decision boundary and margins
        ax.contour(XX * factor, YY * factor, Z, colors='k', levels=[-1, 0, 1], alpha=0.5,
                   linestyles=['--', '-', '--'])
        plt.savefig('%s.png' % (experiment_name, ))
        plt.show()


SVC_KERNEL_TYPES = ('linear', 'poly', 'rbf', )
class SVCParser(DataParser):
    def __init__(self, kernel_type, gamma=None):
        if kernel_type not in SVC_KERNEL_TYPES:
            raise TypeError('Invalid kernel type, use %s' % (SVC_KERNEL_TYPES, ))
        super(SVCParser, self).__init__()
        self._kernel_type = kernel_type
        self._gamma = gamma

    def parse(self, data, labels, labels_raw, removed_data, factor, title_data='', xlabel='', ylabel='', experiment_name=''):
        """
        Returns: np.ndarray of shape (3,2) :
                    A two dimensional array of size 3 that contains the number of support vectors for each class(2) in the three kernels.
        """
        c_value = 75
        result = np.ndarray((3, 2, ))
        x = data
        y = labels
        kwargs = dict()

        if self._gamma is None:
            svc = svm.SVC(C=c_value, kernel=self._kernel_type)
        else:
            svc = svm.SVC(C=c_value, kernel=self._kernel_type, gamma=self._gamma)

        trained_svc = svc.fit(data, labels)
        self.create_plot(
            data,
            labels,
            labels_raw,
            removed_data,
            factor,
            trained_svc,
            '%s: SVM (%s kernel, C=%d%s)' % (title_data, self._kernel_type, c_value, '' if self._gamma is None else ', $\gamma$=%.1f' % (self._gamma, ), ),
            xlabel,
            ylabel,
            '%s_%s' % (experiment_name, self._kernel_type, )
        )

        return trained_svc.n_support_

class SVRParser(DataParser):
    def parse(self, data, labels, labels_raw, removed_data, factor, title_data='', xlabel='', ylabel='', experiment_name=''):
        """
        Returns: np.ndarray of shape (3,2) :
                    A two dimensional array of size 3 that contains the number of support vectors for each class(2) in the three kernels.
        """
        c_value = 1000
        result = np.ndarray((3, 2, ))
        x = data
        y = labels
        kernel_types = ('linear', 'poly', 'rbf', )
        for i in range(len(kernel_types)):
            svr = svm.SVR(C=c_value, kernel=kernel_types[i])
            trained_svr = svr.fit(data, labels)
            self.create_plot(
                data,
                labels,
                labels_raw,
                removed_data,
                factor,
                trained_svr,
                'SVR with %s kernel, %s' % (kernel_types[i], title_data, ),
                xlabel,
                ylabel,
                '%s_%s' % (experiment_name, self._kernel_type, )
            )

            plt.show()
            result[i] = trained_svr.n_support_

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
    parsers = [SVCParser('linear'), SVCParser('poly'), SVCParser('rbf', gamma=1.7)]

    data_frame = get_mean_plane_data_frame()
    mean_experiment_groups = [PlaneExperiment(data_frame, 'STD', val, filter_label_func=filter_label_func_35) for val in [0.25, 0.8, 1.2]]

    i = 0
    for experiment in mean_experiment_groups:
        for parser in parsers:
            i += 1
            #  plt.subplot(len(mean_experiment_groups), len(parsers), i)
            parser.parse(experiment.data,
                         experiment.labels,
                         experiment.labels_raw,
                         experiment._removed_data,
                         experiment.max_data,
                         '$\sigma=%.2f$' % (experiment.z_value ,),
                         '$\mu_{A}$',
                         '$\mu_{B}$',
                         'mean_exp__sd_%.2f' % (experiment.z_value, ))
    #  plt.show()
    #  plt.savefig('mean_figure.png')

def handle_sd_experiments():
    parsers = [SVCParser('linear'), SVCParser('poly'), SVCParser('rbf', gamma=1.7)]

    data_frame = get_sd_plane_data_frame()
    sd_experiment_groups = [PlaneExperiment(data_frame, 'Mean', val, filter_label_func=filter_label_func_35) for val in [5, 10, 15]]

    i = 0
    for experiment in sd_experiment_groups:
        for parser in parsers:
            #  i += 1
            #  plt.subplot(len(sd_experiment_groups), len(parsers), i)
            try:
                parser.parse(experiment.data,
                             experiment.labels,
                             experiment.labels_raw,
                             experiment._removed_data,
                             experiment.max_data,
                             '$\mu=%.2f$' % (experiment.z_value ,),
                             '$\sigma_{A}$',
                             '$\sigma_{B}$',
                             'sd_exp__mean_%d' % (experiment.z_value, ))
            except Exception as e:
                print('Error: %s' % (e, ))
                raise
                continue

    #  plt.show()
    #  plt.savefig('sd_figure.png')

def main():
    handle_mean_experiments()
    handle_sd_experiments()



if __name__ == '__main__':
    exit(main())
