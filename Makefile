
MJB_TOPDIR:=.

include $(MJB_TOPDIR)/mjb.mk

# setup initial repos 
init: repo/init

# handles repos that are outside of ./scripts/feeds' scope
update: repo/update

world: repo/world
