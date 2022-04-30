# -*- coding: utf-8 -*-
"""
=====================
Classifier comparison
=====================

A comparison of a several classifiers in scikit-learn on synthetic datasets.
The point of this example is to illustrate the nature of decision boundaries
of different classifiers.
This should be taken with a grain of salt, as the intuition conveyed by
these examples does not necessarily carry over to real datasets.

Particularly in high-dimensional spaces, data can more easily be separated
linearly and the simplicity of classifiers such as naive Bayes and linear SVMs
might lead to better generalization than is achieved by other classifiers.

The plots show training points in solid colors and testing points
semi-transparent. The lower right shows the classification accuracy on the test
set.

"""

# Code source: Gaël Varoquaux
#              Andreas Müller
# Modified for documentation by Jaques Grobler
# License: BSD 3 clause

import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
from matplotlib.colors import ListedColormap
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.datasets import make_moons, make_circles, make_classification
from sklearn.neural_network import MLPClassifier
from sklearn.neighbors import KNeighborsClassifier
from sklearn.svm import SVC
from sklearn.gaussian_process import GaussianProcessClassifier
from sklearn.gaussian_process.kernels import RBF
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier, AdaBoostClassifier
from sklearn.naive_bayes import GaussianNB
from sklearn.discriminant_analysis import QuadraticDiscriminantAnalysis

h = 0.02  # step size in the mesh
DATA_PATH = './results.xlsx'
RESULTS_MEAN_PLANE_EXPERIMENT_INDEX = 0
RESULTS_SD_PLANE_EXPERIMENT_INDEX = 0

names = [
    "Nearest Neighbors",
    "Linear SVM",
    "RBF SVM",
    "Gaussian Process",
    "Decision Tree",
    "Random Forest",
    "Neural Net",
    "AdaBoost",
    "Naive Bayes",
    "QDA",
]

classifiers = [
    #  KNeighborsClassifier(3),
    SVC(kernel="linear", C=0.025),
    SVC(gamma=2, C=1),
    #  GaussianProcessClassifier(1.0 * RBF(1.0)),
    #  DecisionTreeClassifier(max_depth=5),
    #  RandomForestClassifier(max_depth=5, n_estimators=10, max_features=1),
    #  MLPClassifier(alpha=1, max_iter=1000),
    #  AdaBoostClassifier(),
    #  GaussianNB(),
    #  QuadraticDiscriminantAnalysis(),
]

X, y = make_classification(
    n_features=2, n_redundant=0, n_informative=2, random_state=1, n_clusters_per_class=1
)
rng = np.random.RandomState(2)
X += 2 * rng.uniform(size=X.shape)
linearly_separable = (X, y)

######## Experiments Data ################
def get_mean_plane_data_frame():
    f = pd.ExcelFile(DATA_PATH)
    data_frame = f.parse(RESULTS_MEAN_PLANE_EXPERIMENT_INDEX)
    return data_frame

def get_sd_plane_data_frame():
    f = pd.ExcelFile(DATA_PATH)
    data_frame = f.parse(RESULTS_SD_PLANE_EXPERIMENT_INDEX)
    return data_frame
#
#  datasets = [
#      make_moons(noise=0.3, random_state=0),
#      make_circles(noise=0.2, factor=0.5, random_state=1),
#      linearly_separable,
#  ]
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


mean_data_frame = get_mean_plane_data_frame()
#  sd_data_frame = get_sd_plane_data_frame()
mean_experiment_groups = [PlaneExperiment(mean_data_frame, 'STD', val, filter_label_func=filter_label_func_35) for val in [0.25, 0.8, 1.2]]
#  sd_experiment_groups = [PlaneExperiment(sd_data_frame, 'Mean', val, filter_label_func=filter_label_func_35) for val in [0.25, 0.8, 1.2]]
experiments = mean_experiment_groups# + sd_experiment_groups

figure = plt.figure(figsize=(27, 9))
i = 1
# iterate over datasets
for ds_cnt, experiment in enumerate(experiments):
    # preprocess dataset, split into training and test part
    X = experiment.data
    y = experiment.labels
    X = StandardScaler().fit_transform(X)
    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=0.4, random_state=42
    )

    x_min, x_max = X[:, 0].min() - 0.5, X[:, 0].max() + 0.5
    y_min, y_max = X[:, 1].min() - 0.5, X[:, 1].max() + 0.5
    xx, yy = np.meshgrid(np.arange(x_min, x_max, h), np.arange(y_min, y_max, h))

    # just plot the dataset first
    cm = plt.cm.RdBu
    cm_bright = ListedColormap(["#FF0000", "#0000FF"])
    ax = plt.subplot(len(experiments), len(classifiers) + 1, i)
    #  if ds_cnt == 0:
    #      ax.set_title("Input data")
    # Plot the training points
    ax.scatter(X_train[:, 0], X_train[:, 1], c=y_train, cmap=cm_bright, edgecolors="k")
    # Plot the testing points
    ax.scatter(
        X_test[:, 0], X_test[:, 1], c=y_test, cmap=cm_bright, alpha=0.6, edgecolors="k"
    )
    ax.set_xlim(xx.min(), xx.max())
    ax.set_ylim(yy.min(), yy.max())
    ax.set_xticks(())
    ax.set_yticks(())
    i += 1

    # iterate over classifiers
    for name, clf in zip(names, classifiers):
        ax = plt.subplot(len(experiments), len(classifiers) + 1, i)
        try:
            clf.fit(X_train, y_train)
            score = clf.score(X_test, y_test)

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
                X_train[:, 0], X_train[:, 1], c=y_train, cmap=cm_bright, edgecolors="k"
            )
            # Plot the testing points
            ax.scatter(
                X_test[:, 0],
                X_test[:, 1],
                c=y_test,
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
            i += 1
        except Exception as e:
            print('fit error: %s' % (e, ))
            continue

plt.tight_layout()
plt.show()
