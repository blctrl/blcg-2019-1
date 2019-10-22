# Makefile
TOP = ../..
include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE

# The following are used for debugging messages.
#!USR_CXXFLAGS += -DDEBUG

DBD += oms.dbd
DBDINC += xxxRecord
DBD += xxxSupport.dbd
DBDINC += blcRecord.dbd

LIBRARY_IOC_DEFAULT += oms
oms_DBD +=devOms.dbd
oms_DBD +=xxxSupport.dbd
oms_DBD +=blcSupport.dbd

# The following is required for the OMS PC68/78 (i.e., devOmsPC68) device driver.
ifdef ASYN
SRCS += devOmsPC68.cc drvOmsPC68.cc
endif

# The following is required for the OMS VME8/44 (i.e., devOMS) device driver.
oms_SRCS += devOms.cc drvOms.cc

# The following is required for the OMS VME58 (i.e., devOms58) device driver.
oms_SRCS += devOms58.cc drvOms58.cc

# OMS MAXv device driver support.
oms_SRCS += devMAXv.cc drvMAXv.cc

oms_SRCS += xxxRecord.c
oms_SRCS += devXxxSoft.c
oms_SRCS += devjwh.c
oms_SRCS += blcRecord.c devblcSoft.c

# Trajectory support for MAXV controller
ifdef SNCSEQ
ifdef ASYN
SRCS += MAX_trajectoryScan.st
endif
endif

# The following is required for all OMS device drivers.
oms_SRCS += devOmsCom.cc

oms_LIBS += motor
ifdef ASYN
oms_LIBS += asyn
endif

# MAXV_trajectoryScan.st needs the following:
ifdef SNCSEQ
oms_LIBS += seq pv
endif


oms_LIBS += $(EPICS_BASE_IOC_LIBS)

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE
