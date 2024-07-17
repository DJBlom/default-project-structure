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
TEST_TARGET := Default
CPPUTEST_EXE_FLAGS := -c
CPPUTEST_CXXFLAGS :=-std=c++23


SRC_DIRS :=\
	$(PROJECT_DIR)/api/source\
	$(PROJECT_DIR)/features/source\
	$(PROJECT_DIR)/system/source\


INCLUDE_DIRS :=\
	$(CPPUTEST_HOME)/include\
	$(PROJECT_DIR)/app/include\
	$(PROJECT_DIR)/api/include\
	$(PROJECT_DIR)/api/mocks/include\
	$(PROJECT_DIR)/system/include\
	$(PROJECT_DIR)/system/mocks/include\
	$(PROJECT_DIR)/features/include\
	$(PROJECT_DIR)/features/mocks/include\
	$(PROJECT_DIR)/algorithms/include\
	$(PROJECT_DIR)/algorithms/mocks/include\


TEST_SRC_DIRS :=\
	$(TEST_DIR)\
	$(PROJECT_DIR)/api/tests\
	$(PROJECT_DIR)/system/tests\
	$(PROJECT_DIR)/features/tests\
	$(PROJECT_DIR)/algorithms/tests\


MOCKS_SRC_DIRS := \
	$(PROJECT_DIR)/api/mocks/source\
	$(PROJECT_DIR)/system/mocks/source\
	$(PROJECT_DIR)/features/mocks/source\


CPPUTEST_USE_EXTENSIONS := Y
CPPUTEST_USE_GCOV := Y
CPPUTEST_USE_MEM_LEAK_DETECTION := N
-include $(CPPUTEST_HOME)/build/MakefileWorker.mk
