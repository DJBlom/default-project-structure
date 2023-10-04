##############################################################
# Contents: Paths to source files used by CppUTest
# Author: Dawid Blom.
# Date: September 18, 2022
#
# NOTE: This Makefile adds value to the CppUTests framework
# by specifying the folders where the code is to be tested.
##############################################################
PROJECT_DIR :=$(realpath ..)
TEST_DIR :=$(realpath .)
TEST_TARGET := UnitTests
CPP_PLATFORM := -std=c++20

SRC_DIRS :=\
	$(PROJECT_DIR)/source/features/source\
	$(PROJECT_DIR)/source/system/source\

INCLUDE_DIRS :=\
	$(CPPUTEST_HOME)/include\
	$(PROJECT_DIR)/source/features/include\
	$(PROJECT_DIR)/source/system/include\
	$(TEST_DIR)/mocks/include\


TEST_SRC_DIRS :=\
	$(TEST_DIR)\
	$(TEST_DIR)/tests\
	$(TEST_DIR)/mocks/src\


CPPUTEST_USE_GCOV := Y
CPPUTEST_USE_EXTENSIONS := Y
-include $(CPPUTEST_HOME)/build/MakefileWorker.mk





