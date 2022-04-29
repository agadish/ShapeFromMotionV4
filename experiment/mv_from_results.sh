#!/usr/bin/env sh
RESULTS_DIR=../results
EXPERIMENTS_DIR=../experiment

mv $RESULTS_DIR/*_obj1_5.0_*obj2_5.0_*.avi $EXPERIMENTS_DIR/sd_exp/
mv $RESULTS_DIR/*_obj1_10.0_*obj2_10.0_*.avi $EXPERIMENTS_DIR/sd_exp/
mv $RESULTS_DIR/*_obj1_15.0_*obj2_15.0_*.avi $EXPERIMENTS_DIR/sd_exp/
mv $RESULTS_DIR/*.avi $EXPERIMENTS_DIR/mean_exp/
